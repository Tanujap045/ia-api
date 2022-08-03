import { audit_handler, documents, error, sysadmin, wf_util } from 'fmis-common'
import { extendType } from 'nexus'
import { Context } from 'nexus-plugin-prisma/dist/utils'
import * as appConst from '../../../util/constants'
import { updateAssignmentStatus } from '../../global/audit_assignment_status/db'
import { isValidCuid } from '../../../util'
export const AUDIT_ASSIGNMENT_PLAN_MUTATION = extendType({
    type: 'Mutation',
    definition(t) {
        t.crud.createOneAuditAssignmentPlan({
            // authorize: (root, args, ctx) => {
            //     return ctx.isInternal || ctx.isAuthorized(ctx.token.username, appConst.FUNCTION_CODE.IA_AUDIT_ASSIGNMENT_PLAN + '_C',  '')
            // },
            resolve: async (root, args, ctx, info, originalResolver) => {
                await validateAuditAssignmentPlan(ctx, args.data.audit_commencement?.connect?.id || '')
                const wfParams = wf_util.validateNGetWfParams(args)
                const docs = args.data.documents
                delete args.data.documents
                wfParams['seq_key'] = appConst.FUNCTION_CODE.IA_AUDIT_ASSIGNMENT_PLAN + '_REF'
                wfParams['seq_conf'] = {
                    fin_year: await sysadmin.GetFinYearForSeqGeneration(ctx),
                }
                const res = await originalResolver(root, args, ctx, info)
                if (docs && res && res?.id) {
                    await documents.generateDocuments(res.id.toString(), docs, ctx.rawToken || '', ctx.token)
                }
                await audit_handler.publishAudit(
                    wfParams,
                    appConst.FUNCTION_CODE.IA_AUDIT_ASSIGNMENT_PLAN,
                    res,
                    'create',
                    ctx.rawToken || '',
                    ctx.token,
                )
                const commencementDetail = await ctx.db.commencementDetail.findFirst({
                    where: { audit_commencement_form: { id: args.data.audit_commencement?.connect?.id || '', is_effective: true } },
                    select: { aap_detail_id: true },
                })
                if (isValidCuid(args.data.ref)) {
                    await updateAssignmentStatus(
                        ctx.db,
                        appConst.AAP_ASSIGN_CATEGORY.get(appConst.FUNCTION_CODE.IA_AUDIT_ASSIGNMENT_PLAN) || '',
                        'Draft',
                        commencementDetail?.aap_detail_id || '',
                    )
                }
                return res
            },
        })
        t.crud.updateOneAuditAssignmentPlan({
            // authorize: (__, args, ctx) => {
            //     return (
            //         ctx.isInternal ||
            //         ctx.isAuthorized(ctx.token.username, appConst.FUNCTION_CODE.IA_AUDIT_ASSIGNMENT_PLAN + '_R', '')
            //     )
            // },
            resolve: async (root, args, ctx, info, originalResolver) => {
                const wfParams = wf_util.validateNGetWfParams(args)
                const docs = args.data.documents
                delete args.data.documents
                let res: any
                if (!(await wf_util.canSaveAllowed(ctx, appConst.FUNCTION_CODE.IA_AUDIT_ASSIGNMENT_PLAN, 'ALL', wfParams))) {
                    res = await ctx.db.auditAssignmentPlan.findUnique({
                        where: { id: args.where.id! },
                    })
                    wfParams['byPassAudit'] = true
                } else {
                    await cleanupAuditAssignmentPlan(ctx, args.where.id!)
                    res = await originalResolver(root, args, ctx, info)
                    if (docs && res && res?.id) {
                        await documents.generateDocuments(res.id, docs, ctx.rawToken || '', ctx.token)
                    }
                }
                wfParams['seq_key'] = appConst.FUNCTION_CODE.IA_AUDIT_ASSIGNMENT_PLAN + '_REF'
                wfParams['seq_conf'] = { fin_year: await sysadmin.GetFinYearForSeqGeneration(ctx) }
                await audit_handler.publishAudit(
                    wfParams,
                    appConst.FUNCTION_CODE.IA_AUDIT_ASSIGNMENT_PLAN,
                    res,
                    'update',
                    ctx.rawToken || '',
                    ctx.token,
                )
                return res
            },
        })
        t.crud.deleteOneAuditAssignmentPlan({
            resolve: async (root, args, ctx, info, originalResolver) => {
                await cleanupAuditAssignmentPlan(ctx, args.where.id!)
                const res = await originalResolver(root, args, ctx, info)
                await audit_handler.publishAudit(
                    {},
                    appConst.FUNCTION_CODE.IA_AUDIT_ASSIGNMENT_PLAN,
                    res,
                    'delete',
                    ctx.rawToken || '',
                    ctx.token,
                )
                return res
            },
        })
    },
})

async function cleanupAuditAssignmentPlan(ctx: Context, id: string) {
    const txnPromises = []
    txnPromises.push(ctx.db.auditAssignmentPlan.update({ data: { audit_commencement: { disconnect: true } }, where: { id: id } }))
    txnPromises.push(ctx.db.managementContact.deleteMany({ where: { audit_assignment_plan_id: id } }))
    txnPromises.push(ctx.db.auditTeamComposition.deleteMany({ where: { audit_assignment_plan_id: id } }))
    txnPromises.push(ctx.db.timeFinResource.deleteMany({ where: { audit_assignment_plan_id: id } }))
    try {
        await ctx.db.$transaction(txnPromises)
    } catch (err) {
        console.log('Error performing cleanup for Audit Assignment Plan. ', err)
    }
}

async function validateAuditAssignmentPlan(ctx: Context, commencementId: string) {
    const recordCount = await ctx.db.auditAssignmentPlan.count({
        where: { audit_commencement_id: commencementId, status: { notIn: appConst.INACTIVE_CODES } },
    })
    if (recordCount > 0) {
        console.log('Commencmencement Form already mapped to another record.')
        error.throwUserError('commencement.form.exists')
    }
    const commenceDetlCount = await ctx.db.commencementDetail.count({ where: { commencement_id: { equals: commencementId } } })
    const riskConclusionCount = await ctx.db.riskAssessmentConclusion.count({
        where: {
            is_effective: { equals: true },
            audit_way_forward: { in: [appConst.STATUS_CODES.CLOSE_ENG, appConst.STATUS_CODES.DEFER_ENG] },
            commencement_detail: { commencement_id: { equals: commencementId } },
        },
    })
    if (commenceDetlCount === riskConclusionCount) {
        console.log('The risk assessment conclusion for the audit is closed, audit assignment is not allowed to create')
        error.throwUserError('notable.create', 'Audit Assignment Plan')
    }

    const riskAssessConclCount = await ctx.db.riskAssessmentConclusion.count({
        where: {
            is_effective: { equals: true },
            commencement_detail: { commencement_id: { equals: commencementId } },
        },
    })
    if (riskAssessConclCount === 0) {
        console.log('The audit assignment plan is not allowed to create because risk assessment conclusion is not declared')
        error.throwUserError('not.allow.create', 'Risk Assessment Conclusion', 'Audit Assignment Plan')
    }
}
