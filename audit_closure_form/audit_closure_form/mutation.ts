import { audit_handler, sysadmin, wf_util, error } from 'fmis-common'
import * as appConst from '../../../util/constants'
import { extendType } from 'nexus'
import { Context } from 'nexus-plugin-prisma/dist/utils'
import { updateAssignmentStatus } from '../../global/audit_assignment_status/db'
import { isValidCuid } from '../../../util'

export const AUDIT_CLOSURE_FORM_MUTATION = extendType({
    type: 'Mutation',
    definition(t) {
        t.crud.createOneAuditClosureForm({
            //    authorize: (root, args, ctx) => {
            //         return ctx.isInternal || ctx.isAuthorized(ctx.token.username, appConst.FUNCTION_CODE.IA_AUDIT_CLOSURE_FORM+ '_C', '')
            //     },

            resolve: async (root, args, ctx, info, originalResolver) => {
                const wfParams = wf_util.validateNGetWfParams(args)
                wfParams['seq_key'] = appConst.FUNCTION_CODE.IA_AUDIT_CLOSURE_FORM + '_REF'
                wfParams['seq_conf'] = {
                    fin_year: await sysadmin.GetFinYearForSeqGeneration(ctx),
                }
                await handleUniqueCheck(ctx, args.data.commencement_form?.connect?.id || '')
                const res = await originalResolver(root, args, ctx, info)
                await audit_handler.publishAudit(
                    wfParams,
                    appConst.FUNCTION_CODE.IA_AUDIT_CLOSURE_FORM,
                    res,
                    'create',
                    ctx.rawToken || '',
                    ctx.token,
                )
                const aapDetail = await ctx.db.auditCommencementForm.findUnique({
                    where: { id: args.data.commencement_form?.connect?.id || '' },
                    include: { commencement_details: { include: { aap_detail: true } } },
                })
                if (isValidCuid(args.data.ref)) {
                    await updateAssignmentStatus(
                        ctx.db,
                        appConst.AAP_ASSIGN_CATEGORY.get(appConst.FUNCTION_CODE.IA_AUDIT_CLOSURE_FORM) || '',
                        'Draft',
                        aapDetail?.commencement_details[0]?.aap_detail_id || '',
                    )
                }
                return res
            },
        })
        t.crud.updateOneAuditClosureForm({
            // authorize: (__, args, ctx) => {
            //     return (
            //         ctx.isInternal ||
            //         ctx.isAuthorized(ctx.token.username, appConst.FUNCTION_CODE.IA_AUDIT_CLOSURE_FORM + '_R','')
            //     )
            // },
            resolve: async (root, args, ctx, info, originalResolver) => {
                const wfParams = wf_util.validateNGetWfParams(args)
                let res: any
                wfParams['seq_key'] = appConst.FUNCTION_CODE.IA_AUDIT_CLOSURE_FORM + '_REF'
                wfParams['seq_conf'] = { fin_year: await sysadmin.GetFinYearForSeqGeneration(ctx) }
                if (!(await wf_util.canSaveAllowed(ctx, appConst.FUNCTION_CODE.IA_AUDIT_CLOSURE_FORM, 'ALL', wfParams))) {
                    res = await ctx.db.auditClosureForm.findUnique({
                        where: { id: args.where.id! },
                    })
                    wfParams['byPassAudit'] = true
                } else {
                    await cleanUpAuditClosureForm(ctx, args.where.id || '')
                    res = await originalResolver(root, args, ctx, info)
                }
                await audit_handler.publishAudit(
                    wfParams,
                    appConst.FUNCTION_CODE.IA_AUDIT_CLOSURE_FORM,
                    res,
                    'update',
                    ctx.rawToken || '',
                    ctx.token,
                )
                return res
            },
        })
        t.crud.deleteOneAuditClosureForm({
            resolve: async (root, args, ctx, info, originalResolver) => {
                await cleanUpAuditClosureForm(ctx, args.where.id || '')
                const res = await originalResolver(root, args, ctx, info)
                await audit_handler.publishAudit(
                    {},
                    appConst.FUNCTION_CODE.IA_AUDIT_CLOSURE_FORM,
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

const cleanUpAuditClosureForm = async (ctx: Context, auditClosureFormId: string) => {
    const txnPromises = new Array<any>()
    txnPromises.push(
        ctx.db.auditClosureForm.update({ where: { id: auditClosureFormId }, data: { commencement_form: { disconnect: true } } }),
    )

    txnPromises.push(ctx.db.auditWorkingPaper.deleteMany({ where: { audit_closure_form_id: auditClosureFormId } }))
    txnPromises.push(ctx.db.resultOfAssignment.deleteMany({ where: { audit_closure_form_id: auditClosureFormId } }))
    txnPromises.push(ctx.db.assignmentInfo.deleteMany({ where: { audit_closure_form_id: auditClosureFormId } }))
    try {
        await ctx.db.$transaction(txnPromises)
    } catch (err) {
        console.log('Error Occured while deleting auditClosureForm: ', err)
    }
}

const handleUniqueCheck = async (ctx: Context, commencementId: string) => {
    const auditClosureFormCount = await ctx.db.auditClosureForm.count({
        where: { commencement_form_id: commencementId, status: { notIn: appConst.INACTIVE_CODES } },
    })
    if (auditClosureFormCount > 0) {
        error.throwUserError('auditClosureForm.duplicate.exists')
    }
}
