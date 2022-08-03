import { extendType, arg } from 'nexus'
import { audit_handler, wf_util, sysadmin, documents, error } from 'fmis-common'
import * as appConst from '../../../util/constants'
import { Context } from 'nexus-plugin-prisma/dist/utils'
import * as cuid from 'cuid'
import { updateAssignmentStatus } from '../../global/audit_assignment_status/db'
import { isValidCuid } from '../../../util'

export const AUDIT_FINDING_INSTANCE_MUTATION = extendType({
    type: 'Mutation',
    definition(t) {
        t.crud.createOneAuditFindingInstance({
            // authorize: (root, args, ctx) => {
            //     return ctx.isInternal || ctx.isAuthorized(ctx.token.username, appConst.FUNCTION_CODE.IA_AUDIT_FINDING + '_C', '')
            // },
            resolve: async (root, args, ctx, info, originalResolver) => {
                await checkDuplicateDraftRecords(ctx, args.data.ref || '')

                const commencementIds = new Array<string>()

                args.data.findings?.create?.forEach((finding) => {
                    commencementIds.push(finding.commencement_detail?.connect?.id || '')
                })
                await checkPreConditionForCreate(ctx, commencementIds)
                await checkClosureInitiation(ctx, commencementIds)
                if (!cuid.isCuid(args.data.ref || '')) {
                    await AuditTypeCheckAtApprovedRecEdit(ctx, args.data.ref || '')
                }

                const wfParams = wf_util.validateNGetWfParams(args)
                const docs = args.data.documents
                delete args.data.documents

                wfParams['seq_key'] = appConst.FUNCTION_CODE.IA_AUDIT_FINDING + '_REF'
                wfParams['seq_conf'] = { fin_year: await sysadmin.GetFinYearForSeqGeneration(ctx) }
                const res = await originalResolver(root, args, ctx, info)
                if (docs && res) {
                    await documents.generateDocuments(res.id.toString(), docs, ctx.rawToken || '', ctx.token)
                }
                await audit_handler.publishAudit(
                    wfParams,
                    appConst.FUNCTION_CODE.IA_AUDIT_FINDING,
                    res,
                    'create',
                    ctx.rawToken || '',
                    ctx.token,
                )
                const commencementDetails = await ctx.db.commencementDetail.findMany({
                    where: { id: { in: commencementIds } },
                    select: { aap_detail_id: true },
                })

                for (const detail of commencementDetails) {
                    if (isValidCuid(args.data.ref)) {
                        await updateAssignmentStatus(
                            ctx.db,
                            appConst.AAP_ASSIGN_CATEGORY.get(appConst.FUNCTION_CODE.IA_AUDIT_FINDING) || '',
                            'Draft',
                            detail?.aap_detail_id || '',
                        )
                    }
                }

                return res
            },
        })
        t.crud.updateOneAuditFindingInstance({
            // authorize: (root, args, ctx) => {
            //     return ctx.isInternal || ctx.isAuthorized(ctx.token.username, appConst.FUNCTION_CODE.IA_AUDIT_FINDING + '_R', '')
            // },
            resolve: async (root, args, ctx, info, originalResolver) => {
                const wfParams = wf_util.validateNGetWfParams(args)
                const docs = args.data.documents
                delete args.data.documents
                let res: any
                if (!(await wf_util.canSaveAllowed(ctx, appConst.FUNCTION_CODE.IA_AUDIT_FINDING, 'ALL', wfParams))) {
                    res = await ctx.db.auditFindingInstance.findUnique({
                        where: { id: args.where.id! },
                    })
                    wfParams['byPassAudit'] = true
                } else {
                    const commencementIds = new Array<string>()

                    args.data.findings?.create?.forEach((finding) => {
                        commencementIds.push(finding.commencement_detail?.connect?.id || '')
                    })
                    if (!appConst.INACTIVE_CODES.includes(args.data.status?.set || '')) {
                        await checkPreConditionForCreate(ctx, commencementIds)
                        await checkClosureInitiation(ctx, commencementIds)
                    }
                    if (!cuid.isCuid(args.data.ref?.set || '')) {
                        await AuditTypeCheckAtApprovedRecEdit(ctx, args.data.ref?.set || '')
                    }
                    await cleanUpAuditFinding(ctx, args.where.id!)
                    res = await originalResolver(root, args, ctx, info)
                    if (docs && res && res?.id) {
                        await documents.generateDocuments(res.id, docs, ctx.rawToken || '', ctx.token)
                    }
                }
                wfParams['seq_key'] = appConst.FUNCTION_CODE.IA_AUDIT_FINDING + '_REF'
                wfParams['seq_conf'] = { fin_year: await sysadmin.GetFinYearForSeqGeneration(ctx) }
                await audit_handler.publishAudit(
                    wfParams,
                    appConst.FUNCTION_CODE.IA_AUDIT_FINDING,
                    res,
                    'update',
                    ctx.rawToken || '',
                    ctx.token,
                )
                return res
            },
        })
        t.crud.deleteOneAuditFindingInstance({
            // authorize: (root, args, ctx) => {
            //     return ctx.isInternal || ctx.isAuthorized(ctx.token.username, appConst.FUNCTION_CODE.IA_AUDIT_FINDING + '_D', '')
            // },
            resolve: async (root, args, ctx, info, originalResolver) => {
                await cleanUpAuditFinding(ctx, args.where.id!)
                const res = await originalResolver(root, args, ctx, info)
                await audit_handler.publishAudit({}, appConst.FUNCTION_CODE.IA_AUDIT_FINDING, res, 'delete', ctx.rawToken || '', ctx.token)
                return res
            },
        })
        t.field('createManyAuditFindingInstance', {
            type: 'JSON',
            args: { data: arg({ type: 'AuditFindingInstanceBulkCreateInput', nullable: false }) },
            resolve: async (_parent, args, ctx) => {
                const wfParams = wf_util.validateNGetWfParams(args)
                wfParams['seq_key'] = appConst.FUNCTION_CODE.IA_AUDIT_FINDING + '_REF'
                wfParams['seq_conf'] = {
                    fin_year: await sysadmin.GetFinYearForSeqGeneration(ctx),
                }
                console.log(wfParams)
                const txnPromises: any[] = []
                const AuditFindingInstances: any = args.data.AuditFindingInstances
                const idVsDocumentMap = new Map<string, any>()
                const commencementDetailIds: string[] = []
                for (const auditFindingInstance of AuditFindingInstances) {
                    for (const auditFinding of auditFindingInstance.findings.create) {
                        commencementDetailIds.push(auditFinding.commencement_detail?.connect?.id || '')
                        const docs = auditFinding.documents
                        delete auditFinding.documents
                        auditFinding.id = auditFinding.id ? auditFinding.id : cuid.default()
                        idVsDocumentMap.set(auditFinding.id, docs)
                    }
                    const txn = ctx.db.auditFindingInstance.create({
                        data: auditFindingInstance,
                    })
                    txnPromises.push(txn)
                }
                await checkDuplicateDraftRecords(ctx, AuditFindingInstances[0].ref || '')
                await checkPreConditionForCreate(ctx, commencementDetailIds)
                await checkClosureInitiation(ctx, commencementDetailIds)
                if (!cuid.isCuid(AuditFindingInstances[0].ref || '')) {
                    await AuditTypeCheckAtApprovedRecEdit(ctx, AuditFindingInstances[0].ref || '')
                }
                try {
                    const res = await ctx.db.$transaction(txnPromises)
                    await audit_handler.publishAudit(
                        wfParams,
                        appConst.FUNCTION_CODE.IA_AUDIT_FINDING,
                        res,
                        'create',
                        ctx.rawToken || '',
                        ctx.token,
                        undefined,
                        true,
                    )
                } catch (err) {
                    console.log('Error while creating Audit Finding Instance', err)
                    error.throwUserError('system.global.error')
                }
                const commencementDetails = await ctx.db.commencementDetail.findMany({
                    where: { id: { in: commencementDetailIds } },
                    select: { aap_detail_id: true },
                })

                if (isValidCuid(AuditFindingInstances[0].ref)) {
                    for (const detail of commencementDetails) {
                        await updateAssignmentStatus(
                            ctx.db,
                            appConst.AAP_ASSIGN_CATEGORY.get(appConst.FUNCTION_CODE.IA_AUDIT_FINDING) || '',
                            'Draft',
                            detail.aap_detail_id || '',
                        )
                    }
                }
                await documents.generateMultipleDocuments(idVsDocumentMap, ctx.rawToken || '', ctx.token)
                return { status: 'Success' }
            },
        })
    },
})

const cleanUpAuditFinding = async (ctx: Context, findingInstanceId: string) => {
    const txnPromises = new Array<any>()
    const auditObserIds = new Array<string>()
    const auditFindDetlIds = new Array<string>()
    const auditFindObersvations = await ctx.db.auditFindingObservation.findMany({
        where: { audit_finding: { finding_instance_id: findingInstanceId } },
        select: { id: true },
    })
    for (const observation of auditFindObersvations) {
        auditObserIds.push(observation.id)
    }
    const auditFindDetails = await ctx.db.auditFindingDetail.findMany({
        where: { audit_finding: { finding_instance_id: findingInstanceId } },
        select: { id: true },
    })
    for (const detail of auditFindDetails) {
        auditFindDetlIds.push(detail.id)
    }
    // txnPromises.push(ctx.db.auditFinding.update({ data: { commencement_detail: { disconnect: true } }, where: { id: findingInstanceId } }))
    txnPromises.push(ctx.db.auditFindingObservationDetail.deleteMany({ where: { audit_finding_observation_id: { in: auditObserIds } } }))
    txnPromises.push(ctx.db.auditFindingObservation.deleteMany({ where: { audit_finding: { finding_instance_id: findingInstanceId } } }))
    txnPromises.push(ctx.db.mngmtActionPlan.deleteMany({ where: { audit_finding_detail_id: { in: auditFindDetlIds } } }))
    txnPromises.push(ctx.db.recommendation.deleteMany({ where: { audit_finding_detail_id: { in: auditFindDetlIds } } }))
    txnPromises.push(ctx.db.auditFindingDetail.deleteMany({ where: { audit_finding: { finding_instance_id: findingInstanceId } } }))
    txnPromises.push(ctx.db.auditFinding.deleteMany({ where: { finding_instance_id: findingInstanceId } }))
    try {
        await ctx.db.$transaction(txnPromises)
    } catch (err) {
        console.log('Error Occured while deleting auditFinding: ', err)
    }
}
async function checkDuplicateDraftRecords(ctx: Context, ref: string) {
    const draftCount = await ctx.db.auditFindingInstance.count({ where: { ref: ref, status: appConst.STATUS_CODES.DRAFT } })
    if (draftCount > 0) {
        console.log('Another draft record exists for the same Audit Finding ')
        error.throwUserError('draft.record.exists')
    }
}

const AuditTypeCheckAtApprovedRecEdit = async (ctx: Context, ref: string) => {
    const res = await ctx.db.auditFindingInstance.findFirst({
        where: { ref: ref, is_effective: true },
        select: {
            id: true,
            findings: {
                select: {
                    commencement_detail: {
                        select: {
                            aap_detail: {
                                select: {
                                    aap_item: {
                                        select: {
                                            audit_type: true,
                                        },
                                    },
                                },
                            },
                            reports: {
                                where: {
                                    is_effective: true,
                                    report_type: appConst.REPORT_TYPES.FINAL_REPORT,
                                },
                            },
                            audit_commencement_form: {
                                select: {
                                    audit_meeting: {
                                        where: {
                                            is_effective: true,
                                            meeting_type: appConst.MEETING.CLOSE_TYPE,
                                        },
                                    },
                                },
                            },
                        },
                    },
                },
            },
        },
    })
    if (res && res.findings.length > 0) {
        for (const finding of res.findings) {
            const type = finding.commencement_detail?.aap_detail?.aap_item.audit_type || ''
            if (finding.commencement_detail?.reports && finding.commencement_detail?.reports.length > 0) {
                // ADHOC_AUDIT and SCHEDULE_AUDIT
                if (type === appConst.FUNCTION_CODE.ADHOC_AUDIT || appConst.FUNCTION_CODE.SCHEDULE_AUDIT) {
                    console.log(
                        'Final Report is declared, so edit of Approved record of audit type SCHEDULE_AUDIT or ADHOC_AUDIT is not allowed',
                    )
                    error.throwUserError('finalReport.exists')
                }
            }
            if (
                finding.commencement_detail?.audit_commencement_form.audit_meeting &&
                finding.commencement_detail?.audit_commencement_form.audit_meeting.length > 0
            ) {
                // FOLLOW_UP_AUDIT
                if (type === appConst.FUNCTION_CODE.FOLLOW_UP_AUDIT) {
                    console.log('Closing Meeting is declared, so edit of Approved record of audit type FOLLOW_UP_AUDIT is not allowed')
                    error.throwUserError('closingMeeting.declared')
                }
            }
        }
    }
}
const checkClosureInitiation = async (ctx: Context, cmDetailArray: string[]) => {
    const closureCount = await ctx.db.auditClosureForm.count({
        where: {
            commencement_form: {
                commencement_details: {
                    some: {
                        id: { in: cmDetailArray },
                    },
                },
            },
            status: { in: appConst.ACTIVE_CODES },
        },
    })
    if (closureCount > 0) {
        error.throwUserError('auditFinding.closureform.submitted')
    }
}

const checkPreConditionForCreate = async (ctx: Context, cmDetailArray: string[]) => {
    const aapItem = await ctx.db.aAPItem.findFirst({
        where: { aap_item_details: { some: { commencement_detail: { some: { id: { in: cmDetailArray } } } } } },
        select: { audit_type: true },
    })
    if (aapItem?.audit_type === appConst.AUDIT_TYPES.SCHEDULE || aapItem?.audit_type === appConst.AUDIT_TYPES.ADHOC) {
        const riskConclusionCount = await ctx.db.riskAssessmentConclusion.count({
            where: {
                is_effective: { equals: true },
                commencement_detail_id: { in: cmDetailArray },
                audit_way_forward: { in: [appConst.STATUS_CODES.DEFER_ENG, appConst.STATUS_CODES.CLOSE_ENG] },
            },
        })
        if (riskConclusionCount > 0) {
            console.log('The risk assessment conclusion for the audit is closed, audit finding is not allowed to create')
            error.throwUserError('notable.create', 'Audit Finding')
        }
        const auditTestResCount = await ctx.db.auditTestResult.count({
            where: { is_effective: { equals: true }, commencement_detail_id: { in: cmDetailArray } },
        })
        if (auditTestResCount === 0) {
            console.log('The audit finding is not allowed to create because audit test result is not created')
            error.throwUserError('not.allow.create', 'Audit Test Result', 'Audit Finding')
        }
    }
}
