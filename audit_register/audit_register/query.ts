/* eslint-disable max-nested-callbacks */
import { extendType, arg, stringArg, intArg } from 'nexus'
import { Prisma } from '@prisma/client'
import * as appConst from '../../../util/constants'

export const AUDIT_REGISTER_QUERY = extendType({
    type: 'Query',
    definition(t) {
        t.crud.auditRegister()
        t.crud.auditRegisters({ ordering: true, pagination: true, filtering: true })
        t.int('auditRegisterCount', {
            args: { where: arg({ type: 'AuditRegisterWhereInput', nullable: true }) },
            resolve: async (_root, args, ctx) => {
                return await ctx.db.auditRegister.count({ where: args.where as Prisma.AuditRegisterWhereInput })
            },
        })
        t.field('auditAssignmentViewData', {
            type: 'JSON',
            args: {
                aap_item_id: stringArg({ required: false }),
                sub_assignment_id: stringArg({ required: false }),
                aap_detail_id: stringArg({ required: false }),
                mngmt_action_status: stringArg({ required: false }),
                office_code: stringArg({ required: false }),
                fin_year: stringArg({ required: false }),
                skip: intArg({ required: false }),
                take: intArg({ required: false }),
            },
            resolve: async (_root, args, ctx) => {
                const where: any = {
                    audit_register_finding: args.mngmt_action_status
                        ? {
                              some: { audit_register_details: { some: { mngmt_action_status: args.mngmt_action_status } } },
                          }
                        : undefined,
                    commencement_form: {
                        is_latest: { equals: true },
                        commencement_details: {
                            some: {
                                aap_detail: {
                                    aap_sub_assignments: args.sub_assignment_id
                                        ? { some: { assignment_id: args.sub_assignment_id } }
                                        : undefined,
                                    aap_item_id: args.aap_item_id,
                                    id: args.aap_detail_id,
                                    mda_profile_def: { office_code: args.office_code },
                                    aap_item: { aap: { fin_year_id: args.fin_year } },
                                },
                            },
                        },
                    },
                }
                const skip = args.skip ? args.skip : 0
                const take = args.take ? args.take : 0
                const auditRegisters = await ctx.db.auditRegister.findMany({
                    where: where,
                    select: {
                        audit_register_finding: {
                            select: {
                                audit_finding: {
                                    select: {
                                        finding_status: true,
                                        commencement_detail: {
                                            select: {
                                                audit_commencement_form: true,
                                                aap_detail: {
                                                    select: {
                                                        aap_level_details: { select: { level_id: true, classif_code: true } },
                                                        aap_sub_assignments: { select: { assignment: { select: { ref: true } } } },
                                                        aap_item: { select: { ref: true } },
                                                        mda_profile_def: { select: { auditable_area: true, auditable_area_code: true } },
                                                    },
                                                },
                                            },
                                        },
                                    },
                                },
                                audit_register_details: { where: { is_latest: true }, select: { finding_status: true } },
                            },
                        },
                    },
                    skip: skip,
                    take: take,
                })
                const auditHierarchyCodes = await ctx.db.auditHierarchyCode.findMany({
                    where: { config: { is_latest: true } },
                    select: { id: true, name: true },
                })
                const hierarchyCodeMap = new Map<string, string>()
                auditHierarchyCodes.forEach((code) => {
                    hierarchyCodeMap.set(code.id, code.name)
                })
                const itemVsAssignmentData = new Map<string, any[]>()
                auditRegisters.forEach((auditRegister) => {
                    auditRegister?.audit_register_finding?.forEach((finding) => {
                        const { status, closedCount, openCount } = getTheFindingStatus(finding)
                        const itemRef = finding.audit_finding?.commencement_detail?.aap_detail?.aap_item.ref || ''
                        const subAssignments = finding.audit_finding?.commencement_detail?.aap_detail?.aap_sub_assignments
                        let asan = '-'
                        if (subAssignments && subAssignments.length > 0) {
                            asan = subAssignments[0].assignment.ref
                        }
                        const assignmentData: any = {
                            asan: asan,
                            name: finding.audit_finding?.commencement_detail?.audit_commencement_form.name || '',
                            auditable_area: finding.audit_finding?.commencement_detail?.aap_detail?.mda_profile_def?.auditable_area || '',
                            auditable_area_code:
                                finding.audit_finding?.commencement_detail?.aap_detail?.mda_profile_def?.auditable_area_code || '',
                            status: status,
                            closed_count: closedCount,
                            open_count: openCount,
                            total_count: closedCount + openCount,
                        }
                        finding.audit_finding?.commencement_detail?.aap_detail?.aap_level_details.forEach((level) => {
                            assignmentData[level.level_id] = hierarchyCodeMap.get(level.classif_code)
                        })
                        const details = itemVsAssignmentData.get(itemRef) || new Array<any>()
                        details.push(assignmentData)
                        itemVsAssignmentData.set(itemRef, details)
                    })
                })
                const returnData = new Array<any>()
                itemVsAssignmentData.forEach((details, itemRef) => {
                    let openCount = 0
                    let closedCount = 0

                    details.forEach((detail) => {
                        openCount += detail.open_count || 0
                        closedCount += detail.closed_count || 0
                    })
                    returnData.push({
                        closed_count: closedCount,
                        open_count: openCount,
                        total_count: closedCount + openCount,
                        assign_details: details,
                        item_ref: itemRef,
                    })
                })
                return { data: returnData }
            },
        })
    },
})

function getTheFindingStatus(finding: any) {
    let isClosed = false
    let closedCount = 0
    let openCount = 0
    finding.audit_register_details.forEach((detail: any) => {
        if (detail.finding_status === appConst.STATUS_CODES.CLOSED) {
            closedCount++
            isClosed = true
        } else {
            openCount++
        }
    })
    const status = isClosed ? appConst.STATUS_CODES.CLOSED : appConst.STATUS_CODES.OPEN
    return { status, closedCount, openCount }
}
