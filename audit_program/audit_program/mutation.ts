import { extendType } from 'nexus'
import { audit_handler, wf_util, sysadmin, error } from 'fmis-common'
import * as appConst from '../../../util/constants'
import { Context } from 'nexus-plugin-prisma/dist/utils'
import { updateAssignmentStatus } from '../../global/audit_assignment_status/db'
import * as cuid from 'cuid'
import { isValidCuid } from '../../../util'
export const AAP_AUDIT_PROGRAM_MUTATION = extendType({
    type: 'Mutation',
    definition(t) {
        t.crud.createOneAuditProgram({
            // authorize: (root, args, ctx) => {
            //     return ctx.isInternal || ctx.isAuthorized(ctx.token.username, appConst.FUNCTION_CODE.IA_AUDIT_PROGRAM + '_C', '')
            // },
            resolve: async (root, args, ctx, info, originalResolver) => {
                const wfParams = wf_util.validateNGetWfParams(args)
                wfParams['seq_key'] = appConst.FUNCTION_CODE.IA_AUDIT_PROGRAM + '_REF'
                wfParams['seq_conf'] = { fin_year: await sysadmin.GetFinYearForSeqGeneration(ctx) }
                await handleDraftRecord(ctx, args.data.ref || '')
                await validatePostApprEditProcess(
                    ctx,
                    args.data?.ref || '',
                    args.data.audit_commencement?.connect?.id || '',
                    args.data.details?.create || [],
                )
                for (const det of args.data.details?.create || []) {
                    det.aap_detail?.connect?.id + ','
                }
                await handleUniqueCheck(ctx, args.data.audit_commencement?.connect?.id || '', args.data?.ref || '')
                const res = await originalResolver(root, args, ctx, info)
                await audit_handler.publishAudit(
                    wfParams,
                    appConst.FUNCTION_CODE.IA_AUDIT_PROGRAM,
                    res,
                    'create',
                    ctx.rawToken || '',
                    ctx.token,
                )
                if (isValidCuid(args.data.ref)) {
                    for (const detailId of args.data.details?.create || []) {
                        await updateAssignmentStatus(
                            ctx.db,
                            appConst.AAP_ASSIGN_CATEGORY.get(appConst.FUNCTION_CODE.IA_AUDIT_PROGRAM) || '',
                            'Draft',
                            detailId?.aap_detail?.connect?.id || '',
                        )
                    }
                }
                return res
            },
        })
        t.crud.updateOneAuditProgram({
            // authorize: (root, args, ctx) => {
            //     return ctx.isInternal || ctx.isAuthorized(ctx.token.username, appConst.FUNCTION_CODE.IA_AUDIT_PROGRAM + '_R', '')
            // },
            resolve: async (root, args, ctx, info, originalResolver) => {
                const wfParams = wf_util.validateNGetWfParams(args)
                let res: any
                if (!(await wf_util.canSaveAllowed(ctx, appConst.FUNCTION_CODE.IA_AUDIT_PROGRAM, 'ALL', wfParams))) {
                    res = await ctx.db.auditProgram.findUnique({
                        where: { id: args.where.id! },
                    })
                    wfParams['byPassAudit'] = true
                } else {
                    if (appConst.INACTIVE_CODES.includes(args.data.status?.set || '')) {
                        await validatePostApprEditProcess(
                            ctx,
                            args.data.ref?.set || '',
                            args.data.audit_commencement?.connect?.id || '',
                            args.data.details?.create || [],
                        )
                    }
                    await cleanUpAuditProgram(ctx, args.where.id!)
                    res = await originalResolver(root, args, ctx, info)
                }
                wfParams['seq_key'] = appConst.FUNCTION_CODE.IA_AUDIT_PROGRAM + '_REF'
                wfParams['seq_conf'] = { fin_year: await sysadmin.GetFinYearForSeqGeneration(ctx) }
                await audit_handler.publishAudit(
                    wfParams,
                    appConst.FUNCTION_CODE.IA_AUDIT_PROGRAM,
                    res,
                    'update',
                    ctx.rawToken || '',
                    ctx.token,
                )
                return res
            },
        })
        t.crud.deleteOneAuditProgram({
            // authorize: (root, args, ctx) => {
            //     return ctx.isInternal || ctx.isAuthorized(ctx.token.username, appConst.FUNCTION_CODE.IA_AUDIT_PROGRAM + '_D', '')
            // },
            resolve: async (root, args, ctx, info, originalResolver) => {
                const res = await originalResolver(root, args, ctx, info)
                await cleanUpAuditProgram(ctx, args.where.id || '')
                await audit_handler.publishAudit({}, appConst.FUNCTION_CODE.IA_AUDIT_PROGRAM, res, 'delete', ctx.rawToken || '', ctx.token)
                return res
            },
        })
    },
})

const cleanUpAuditProgram = async (ctx: Context, id: string) => {
    const txnPromises = new Array<any>()
    const auditPrgmIds = new Array<string>()
    const auditProgramDetails = await ctx.db.auditProgramDetail.findMany({ where: { audit_program_id: id }, select: { id: true } })
    for (const detail of auditProgramDetails) {
        auditPrgmIds.push(detail.id)
    }
    txnPromises.push(ctx.db.auditProgram.update({ data: { audit_commencement: { disconnect: true } }, where: { id: id } }))
    txnPromises.push(ctx.db.testAssignementDetail.deleteMany({ where: { program_detail_id: { in: auditPrgmIds } } }))
    txnPromises.push(ctx.db.auditProgramDetail.deleteMany({ where: { audit_program_id: id } }))
    try {
        await ctx.db.$transaction(txnPromises)
    } catch (err) {
        console.log('Error Occured while deleting auditProgramDetails: ', err)
    }
}

const handleUniqueCheck = async (ctx: Context, commencementId: string, ref: string) => {
    const auditProgramCount = await ctx.db.auditProgram.count({
        where: { ref: { not: ref }, audit_commencement_id: commencementId, status: { notIn: appConst.INACTIVE_CODES } },
    })
    if (auditProgramCount > 0) {
        error.throwUserError('auditprogram.duplicate.exists')
    }
}

const validatePostApprEditProcess = async (ctx: Context, ref: string, commencementId: string, prgmDetails: any) => {
    if (!cuid.isCuid(ref)) {
        const reportsCount = await ctx.db.report.count({
            where: { commencement_detail: { commencement_id: commencementId }, status: { notIn: appConst.INACTIVE_CODES } },
        })
        if (reportsCount > 0) {
            console.log('Reports are already submitted')
            error.throwUserError('report.record.exists')
        }
    }
    const aapItem = await ctx.db.aAPItem.findFirst({
        where: { aap_item_details: { some: { commencement_detail: { some: { commencement_id: { equals: commencementId } } } } } },
        select: { audit_type: true },
    })
    if (aapItem?.audit_type === appConst.AUDIT_TYPES.SCHEDULE || aapItem?.audit_type === appConst.AUDIT_TYPES.ADHOC) {
        await checkPreConditionForCreate(ctx, prgmDetails, commencementId)
    }
}

const handleDraftRecord = async (ctx: Context, ref: string) => {
    if (!cuid.isCuid(ref)) {
        const auditProgramCount = await ctx.db.auditProgram.count({
            where: { ref: ref, status: { equals: appConst.STATUS_CODES.DRAFT } },
        })
        if (auditProgramCount > 0) {
            console.log('Another Draft Record already exists for the same  Audit Program')
            error.throwUserError('draft.record.exists')
        }
    }
}

const checkPreConditionForCreate = async (ctx: Context, prgmDetails: any, commencementId: string) => {
    let aapDetailIds = ''
    for (const detail of prgmDetails) {
        aapDetailIds = aapDetailIds.concat(detail.aap_detail?.connect?.id + ',')
    }
    const riskConclusionCount = await ctx.db.riskAssessmentConclusion.count({
        where: {
            is_effective: { equals: true },
            commencement_detail: { aap_detail_id: { in: aapDetailIds.split(',') } },
            audit_way_forward: { in: [appConst.STATUS_CODES.CLOSE_ENG, appConst.STATUS_CODES.DEFER_ENG] },
        },
    })
    if (riskConclusionCount > 0) {
        console.log('The risk assessment conclusion for the audit is closed, audit program is not allowed to create')
        error.throwUserError('notable.create', 'Audit Program')
    }
    const auditAssignPlanCount = await ctx.db.auditAssignmentPlan.count({
        where: { is_effective: { equals: true }, audit_commencement_id: { equals: commencementId } },
    })
    if (auditAssignPlanCount === 0) {
        console.log('The audit program is not allowed to create because audit assignment plan is not declared')
        error.throwUserError('not.allow.create', 'Audit Assignment Plan', 'Audit Program')
    }
}
