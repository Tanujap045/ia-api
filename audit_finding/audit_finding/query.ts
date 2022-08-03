import { Prisma } from '@prisma/client'
import { arg, extendType, stringArg } from 'nexus'
import { Context } from 'nexus-plugin-prisma/dist/utils'
import { getIdsFromClassifNames } from '../../../util/commons'
import * as appConst from '../../../util/constants'

export const AUDIT_FINDING_QUERY = extendType({
    type: 'Query',
    definition(t) {
        t.crud.auditFinding()
        t.crud.auditFindings({
            ordering: true,
            pagination: true,
            filtering: true,
            resolve: async (root, args, ctx, info, orginalResolver) => {
                await getIdsFromClassifNames(ctx, args)
                return await orginalResolver(root, args, ctx, info)
            },
        })
        t.int('auditFindingCount', {
            args: { where: arg({ type: 'AuditFindingWhereInput', nullable: true }) },
            resolve: async (_root, args, ctx) => {
                await getIdsFromClassifNames(ctx, args)
                return await ctx.db.auditFinding.count({ where: args.where as Prisma.AuditFindingWhereInput })
            },
        })
        t.field('auditFindingsByItem', {
            type: 'JSON',
            args: { assignmentId: stringArg({ nullable: false }) },
            resolve: async (root, args, ctx) => {
                const auditFindings = await ctx.db.auditFinding.findMany({
                    where: {
                        commencement_detail: { aap_detail: { aap_sub_assignments: { some: { assignment_id: args.assignmentId } } } },
                        finding_instance: { is_effective: { equals: true } },
                    },
                    select: { recurrent_finding: true, audit_finding_details: { select: { risk_rating: true, audit_finding_id: true } } },
                })
                return await prepareFindingData(ctx, args.assignmentId, auditFindings)
            },
        })
        t.field('getAuditObservations', {
            type: 'JSON',
            args: { aapItemId: stringArg({ nullable: true }), assignmentId: stringArg({ nullable: true }) },
            resolve: async (_, args, ctx) => {
                const findingsData = await getFindingsData(ctx, args)
                const response = new Array<any>()
                for (const [, finding] of findingsData.auditFindingMap) {
                    if (finding.parent_finding_id === null) {
                        const singleFindingData = new Array<any>()
                        singleFindingData.push(finding)
                        let parentFindingId = finding.id
                        while (parentFindingId !== null) {
                            const childFinding = findingsData.childFindingMap.get(parentFindingId) || null
                            if (childFinding !== null) {
                                singleFindingData.push(childFinding)
                            }
                            if (childFinding === null) {
                                break
                            }
                            parentFindingId = childFinding.id
                        }
                        response.push(singleFindingData)
                    }
                }
                return response
            },
        })
    },
})

const getFindingsData = async (ctx: Context, args: any) => {
    const auditableAreaCodes = await getAuditableAreaCodes(ctx, args)
    const auditFindings = await getAuditFindings(ctx, auditableAreaCodes)
    const auditFindingMap = new Map<string, any>()
    const childFindingMap = new Map<string, any>()
    for (const finding of auditFindings) {
        auditFindingMap.set(finding.id, finding)
        if (finding.parent_finding_id !== null) {
            childFindingMap.set(finding.parent_finding_id, finding)
        }
    }
    return { childFindingMap, auditFindingMap }
}

const getAuditableAreaCodes = async (ctx: Context, args: any) => {
    const aapDetails = await ctx.db.aAPDetail.findMany({
        where: {
            aap_item: { aap: { is_latest: { equals: true } } },
            OR: [
                { aap_item_id: { equals: args.aapItemId || '' } },
                { aap_sub_assignments: { some: { assignment_id: { equals: args.assignmentId || '' } } } },
            ],
        },
        select: { mda_profile_def_id: true },
    })
    const auditableAreaCodes = new Array<string>()
    for (const aapDetail of aapDetails) {
        auditableAreaCodes.push(aapDetail.mda_profile_def_id || '')
    }
    return auditableAreaCodes
}

const getAuditFindings = async (ctx: Context, auditableAreaCodes: string[]) => {
    return await ctx.db.auditFinding.findMany({
        where: {
            finding_instance: { is_effective: { equals: true } },
            audit_register_finding: {
                some: {
                    audit_register_details: {
                        some: { finding_status: { equals: appConst.FINDING_STATUS }, is_latest: true },
                    },
                },
            },
            commencement_detail: {
                aap_detail: {
                    mda_profile_def_id: { in: auditableAreaCodes },
                },
            },
        },
        select: {
            id: true,
            ref: true,
            parent_finding_id: true,
            audit_finding_details: {
                select: {
                    description: true,
                    followup_audit_approach: true,
                    mgmt_action_plan: {
                        select: { sno: true, action: true, start_date: true, end_date: true },
                    },
                },
            },
            finding_observations: { select: { audit_finding_observation_details: { select: { name: true } } } },
        },
    })
}

const prepareFindingData = async (ctx: Context, assignmentId: string, auditFindings: any) => {
    let recurrantFindingCount = 0
    let highRiskFindingCount = 0
    let moderateRiskFindingCount = 0
    let significantRiskFindingCount = 0
    let lowRiskFindingCount = 0
    const auditFindingCheck = new Map<string, boolean>()
    for (const auditFinding of auditFindings) {
        if (auditFinding.recurrent_finding) {
            recurrantFindingCount += 1
        }
        for (const findDetail of auditFinding.audit_finding_details) {
            const key = findDetail.audit_finding_id + '#' + (findDetail.risk_rating || '')
            if (!auditFindingCheck.get(key)) {
                switch (findDetail.risk_rating.toLowerCase()) {
                    case 'high':
                        highRiskFindingCount += 1
                        break
                    case 'moderate':
                        moderateRiskFindingCount += 1
                        break
                    case 'significant':
                        significantRiskFindingCount += 1
                        break
                    case 'low':
                        lowRiskFindingCount += 1
                        break
                }
            }
            auditFindingCheck.set(key, true)
        }
    }
    const recommendations = await ctx.db.recommendation.count({
        where: {
            audit_finding_detail: {
                audit_finding: {
                    commencement_detail: { aap_detail: { aap_sub_assignments: { some: { assignment_id: assignmentId } } } },
                    is_effective: true,
                },
            },
        },
    })
    return {
        totalAuditFindingCount: auditFindings.length,
        totalRecurrantFindingCount: recurrantFindingCount,
        totalHighRiskAuditFindingCount: highRiskFindingCount,
        totalModerateRiskAuditFindingCount: moderateRiskFindingCount,
        totalSignificantRiskAuditFindingCount: significantRiskFindingCount,
        totalLowRiskAuditFindingCount: lowRiskFindingCount,
        totalAuditRecommendationCount: recommendations,
    }
}
