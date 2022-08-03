import { Context } from 'nexus-plugin-prisma/dist/utils'
import { WF_STATUS_EVENT, seq, sysadmin } from 'fmis-common'
import * as appConst from '../../../util/constants'

export const doPostProcessForAuditFinding = async (ctx: Context, input: WF_STATUS_EVENT) => {
    const rows = await ctx.db.auditFindingInstance.findMany({
        where: {
            status: appConst.STATUS_CODES.APPROVED,
            ref: input.source_ref_updated,
        },
        orderBy: { version_date: 'desc' },
        take: 2,
        select: {
            id: true,
            is_effective: true,
            findings: {
                select: {
                    id: true,
                    ref: true,
                    audit_finding_details: { select: { mgmt_action_plan: { select: { id: true, ref: true } } } },
                },
            },
        },
    })
    if (rows.length !== 2 || rows[0].is_effective !== true) {
        return
    }
    const refMap = prepareRefWithFindingId(rows[0])
    const txns = await prepareTxnsForUpdateRelations(rows[1], input.source_id, ctx, refMap)
    try {
        await ctx.db.$transaction(txns)
    } catch (e) {
        console.log('Error occured while updating the post approval edit relations of audit finding', e)
    }
}

const prepareRefWithFindingId = (row: any) => {
    const refVsIdMap = new Map<string, string>()
    for (const finding of row.findings || []) {
        refVsIdMap.set(finding.ref, finding.id)
        for (const findingDetail of finding.audit_finding_details) {
            for (const mngmtPlan of findingDetail.mgmt_action_plan) {
                refVsIdMap.set(mngmtPlan.ref, mngmtPlan.id)
            }
        }
    }
    return refVsIdMap
}

const prepareTxnsForUpdateRelations = async (prevFinding: any, sourceId: string, ctx: Context, refMap: Map<string, string>) => {
    const mngmtPlanIds = new Array<string>()
    const findingIds = new Array<string>()
    if (prevFinding.findings.length > 0) {
        for (const finding of prevFinding.findings || []) {
            findingIds.push(finding.id)
            for (const findingDetail of finding.audit_finding_details) {
                for (const mngmtPlan of findingDetail.mgmt_action_plan) {
                    mngmtPlanIds.push(mngmtPlan.id)
                }
            }
        }
    }

    const txns = new Array<any>()
    const auditRegFindings = await ctx.db.auditRegisterFinding.findMany({
        where: { audit_finding_id: { in: findingIds } },
        select: { id: true, audit_finding: { select: { ref: true } } },
    })
    if (auditRegFindings.length > 0) {
        for (const regFinding of auditRegFindings) {
            txns.push(
                ctx.db.auditRegisterFinding.update({
                    where: { id: regFinding.id },
                    data: { audit_finding_id: refMap.get(regFinding.audit_finding?.ref || '') },
                }),
            )
        }
    }
    const auditProgDetails = await ctx.db.auditProgramDetail.findMany({
        where: { finding_id: { in: findingIds } },
        select: { id: true, finding: { select: { ref: true } } },
    })
    if (auditProgDetails.length > 0) {
        for (const progDetail of auditProgDetails) {
            txns.push(
                ctx.db.auditProgramDetail.update({
                    where: { id: progDetail.id },
                    data: { finding_id: refMap.get(progDetail.finding?.ref || '') },
                }),
            )
        }
    }
    const aapDetails = await ctx.db.aAPDetail.findMany({
        where: { finding_id: { in: findingIds } },
        select: { id: true, finding: { select: { ref: true } } },
    })

    if (aapDetails.length > 0) {
        for (const aapDetail of aapDetails) {
            txns.push(
                ctx.db.aAPDetail.update({ where: { id: aapDetail.id }, data: { finding_id: refMap.get(aapDetail.finding?.ref || '') } }),
            )
        }
    }
    const auditRegDetails = await ctx.db.auditRegisterDetail.findMany({
        where: { mngmt_action_plan_id: { in: mngmtPlanIds } },
        select: { id: true, mngmt_action_plan: { select: { ref: true } } },
    })
    if (auditRegDetails.length > 0) {
        for (const regDetail of auditRegDetails) {
            txns.push(
                ctx.db.auditRegisterDetail.update({
                    where: { id: regDetail.id },
                    data: { mngmt_action_plan_id: refMap.get(regDetail.mngmt_action_plan?.ref || '') },
                }),
            )
        }
    }
    return txns
}

export async function updateRefAuditFinding(ctx: Context, sourceId: string) {
    // updating the reference for updateRefAuditFinding....
    const auditFindings = await ctx.db.auditFinding.findMany({
        where: { finding_instance_id: sourceId },
        select: { id: true, ref: true },
    })
    const txn = new Array<any>()
    for (const finding of auditFindings) {
        const reference = await seq.generate(
            appConst.FUNCTION_CODE.IA_AUDIT_FINDING + '_INDV_REF',
            { fin_year: await sysadmin.GetFinYearForSeqGeneration(ctx) },
            ctx,
        )
        txn.push(
            ctx.db.auditFinding.update({
                where: { id: finding.id },
                data: { ref: reference, is_effective: true, status: appConst.STATUS_CODES.APPROVED, is_latest: true },
            }),
        )
    }
    try {
        await ctx.db.$transaction(txn)
    } catch (e) {
        console.log('Error occured while updating audit finding ref', e)
    }
}
