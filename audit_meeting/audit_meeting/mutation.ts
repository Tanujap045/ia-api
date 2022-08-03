import { extendType } from 'nexus'
import { audit_handler, wf_util, sysadmin, documents, error } from 'fmis-common'
import * as appConst from '../../../util/constants'
import { Context } from 'nexus-plugin-prisma/dist/utils'
import { updateAssignmentStatus } from '../../global/audit_assignment_status'
import { isValidCuid } from '../../../util'

export const AUDIT_MEETING_MUTATION = extendType({
    type: 'Mutation',
    definition(t) {
        t.crud.createOneAuditMeeting({
            // authorize: (root, args, ctx) => {
            //     return ctx.isInternal || ctx.isAuthorized(ctx.token.username, appConst.FUNCTION_CODE.IA_AUDIT_MEETING + '_C', '')
            // },
            resolve: async (root, args, ctx, info, originalResolver) => {
                await checkClosureInitiation(ctx, args.data.commencemet_form?.connect?.id || '')
                await checkDuplicateDraftRecords(ctx, args.data.ref || '')
                const wfParams = wf_util.validateNGetWfParams(args)
                const docs = args.data.documents
                delete args.data.documents
                wfParams['seq_key'] = appConst.FUNCTION_CODE.IA_AUDIT_MEETING + '_REF'
                wfParams['seq_conf'] = { fin_year: await sysadmin.GetFinYearForSeqGeneration(ctx) }
                const res = await originalResolver(root, args, ctx, info)
                if (docs && res && res?.id) {
                    await documents.generateDocuments(res.id.toString(), docs, ctx.rawToken || '', ctx.token)
                }
                await audit_handler.publishAudit(
                    wfParams,
                    appConst.FUNCTION_CODE.IA_AUDIT_MEETING,
                    res,
                    'create',
                    ctx.rawToken || '',
                    ctx.token,
                )
                const detailIds: string[] = ['DUMMY']
                for (const detail of args.data.audit_meeting_details?.create || []) {
                    detailIds.push(detail?.commencement_detail?.connect?.id || '')
                }
                const commencementDetails = await ctx.db.commencementDetail.findMany({
                    where: { id: { in: detailIds } },
                    select: { aap_detail_id: true },
                })
                if (isValidCuid(args.data.ref)) {
                    for (const comDetail of commencementDetails) {
                        await updateAssignmentStatus(
                            ctx.db,
                            appConst.AAP_ASSIGN_CATEGORY.get(appConst.FUNCTION_CODE.IA_AUDIT_MEETING) || '',
                            'Draft',
                            comDetail?.aap_detail_id || '',
                        )
                    }
                }
                return res
            },
        })
        t.crud.updateOneAuditMeeting({
            // authorize: (root, args, ctx) => {
            //     return ctx.isInternal || ctx.isAuthorized(ctx.token.username, appConst.FUNCTION_CODE.IA_AUDIT_MEETING + '_R', '')
            // },
            resolve: async (root, args, ctx, info, originalResolver) => {
                const wfParams = wf_util.validateNGetWfParams(args)
                const docs = args.data.documents
                delete args.data.documents
                let res: any
                if (!(await wf_util.canSaveAllowed(ctx, appConst.FUNCTION_CODE.IA_AUDIT_MEETING, 'ALL', wfParams))) {
                    res = await ctx.db.auditMeeting.findUnique({
                        where: { id: args.where.id! },
                    })
                    wfParams['byPassAudit'] = true
                } else {
                    if (!appConst.INACTIVE_CODES.includes(args.data.status?.set || '')) {
                        await checkClosureInitiation(ctx, args.data.commencemet_form?.connect?.id || '')
                    }
                    await cleanUpAuditMeeting(ctx, args.where.id!)
                    res = await originalResolver(root, args, ctx, info)
                    if (docs && res && res?.id) {
                        await documents.generateDocuments(res.id, docs, ctx.rawToken || '', ctx.token)
                    }
                }
                wfParams['seq_key'] = appConst.FUNCTION_CODE.IA_AUDIT_MEETING + '_REF'
                wfParams['seq_conf'] = { fin_year: await sysadmin.GetFinYearForSeqGeneration(ctx) }
                await audit_handler.publishAudit(
                    wfParams,
                    appConst.FUNCTION_CODE.IA_AUDIT_MEETING,
                    res,
                    'update',
                    ctx.rawToken || '',
                    ctx.token,
                )
                return res
            },
        })
        t.crud.deleteOneAuditMeeting({
            // authorize: (root, args, ctx) => {
            //     return ctx.isInternal || ctx.isAuthorized(ctx.token.username, appConst.FUNCTION_CODE.IA_AUDIT_MEETING + '_D', '')
            // },
            resolve: async (root, args, ctx, info, originalResolver) => {
                await cleanUpAuditMeeting(ctx, args.where.id!)
                const res = await originalResolver(root, args, ctx, info)
                await audit_handler.publishAudit({}, appConst.FUNCTION_CODE.IA_AUDIT_MEETING, res, 'delete', ctx.rawToken || '', ctx.token)
                return res
            },
        })

        t.crud.updateManyAuditMeeting()
        t.crud.deleteManyAuditMeeting()
    },
})

const cleanUpAuditMeeting = async (ctx: Context, auditMeetingId: string) => {
    const txnPromises = new Array<any>()
    txnPromises.push(ctx.db.auditMeetingDetail.deleteMany({ where: { audit_meeting_id: auditMeetingId } }))
    txnPromises.push(ctx.db.meetingPoint.deleteMany({ where: { audit_meeting_id: auditMeetingId } }))
    txnPromises.push(ctx.db.participant.deleteMany({ where: { audit_meeting_id: auditMeetingId } }))
    txnPromises.push(ctx.db.auditMeetingDocument.deleteMany({ where: { audit_meeting_id: auditMeetingId } }))
    txnPromises.push(ctx.db.auditMeeting.update({ where: { id: auditMeetingId }, data: { commencemet_form: { disconnect: true } } }))
    try {
        await ctx.db.$transaction(txnPromises)
    } catch (err) {
        console.log('Error Occured while deleting auditMeeting: ', err)
    }
}
const checkClosureInitiation = async (ctx: Context, commencementFormId: string) => {
    const closuerMeetCount = await ctx.db.auditClosureForm.count({
        where: { commencement_form_id: commencementFormId, status: { in: appConst.ACTIVE_CODES } },
    })
    if (closuerMeetCount > 0) {
        error.throwUserError('auditMeeting.closureform.submitted')
    }
}
async function checkDuplicateDraftRecords(ctx: Context, ref: string) {
    const draftCount = await ctx.db.auditMeeting.count({ where: { ref: ref, status: appConst.STATUS_CODES.DRAFT } })
    if (draftCount > 0) {
        console.log('Another draft record exists for the same Audit Meeting ')
        error.throwUserError('draft.record.exists')
    }
}
