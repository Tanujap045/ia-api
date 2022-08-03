import { WF_STATUS_EVENT, error } from 'fmis-common'
import { Context } from 'nexus-plugin-prisma/dist/utils'
import * as appConst from '../../../util/constants'

export const auditTestHeaders = [
    'Auditable Area',
    'AuditableArea Id',
    'Domain',
    'Subject',
    'Objective',
    'Objective Id',
    'Risk',
    'Risk Id',
    'Control',
    'Control Id',
    'Procedure',
    'Procedure Id',
    'Type of Test',
    'Test',
    'Test Id',
    'Test Description',
    'Population Size',
    'Sample Size',
    'Number Passed',
    'Number Failed',
    'Summmary of Test Results',
    'Conclusion',
]

export const doPostProcessForAuditProgram = async (ctx: Context, input: WF_STATUS_EVENT) => {
    const rows = await ctx.db.auditProgram.findMany({
        where: { status: { equals: appConst.STATUS_CODES.APPROVED }, ref: { equals: input.source_ref_updated } },
        orderBy: { version_date: 'desc' },
        take: 2,
        select: {
            is_effective: true,
            details: {
                select: {
                    id: true,
                    ref: true,
                },
            },
        },
    })

    if (rows.length !== 2 && rows[0].is_effective !== true) {
        return
    }
    const refWithProgDetl = prepareRefWithDetail(rows[0])
    const txns = await prepareTxnsForAuditProgrm(refWithProgDetl, rows[1], ctx)

    try {
        await ctx.db.$transaction(txns)
    } catch (e) {
        console.log('Error Occured while updating the approval edit relations of audit program', e)
    }
}

const prepareRefWithDetail = (auditPgrm: any) => {
    const refWithDetail = new Map<string, string>()
    auditPgrm.details.forEach((detail: any) => {
        refWithDetail.set(detail.ref, detail.id)
    })
    return refWithDetail
}

const prepareTxnsForAuditProgrm = async (refMap: Map<string, string>, prevAudtPrgm: any, ctx: Context) => {
    const txns = new Array<any>()
    const prgmDetailIds = new Array<string>()
    prevAudtPrgm.details.forEach((prgmDetail: any) => {
        prgmDetailIds.push(prgmDetail.id)
    })
    const workSheetDetails = await ctx.db.auditTestWorksheetDetail.findMany({
        where: { audit_program_id: { in: prgmDetailIds } },
        select: { id: true, audit_program_detail: { select: { ref: true } } },
    })
    workSheetDetails.forEach((detail) => {
        txns.push(
            ctx.db.auditTestWorksheetDetail.update({
                where: { id: detail.id },
                data: { audit_program_id: refMap.get(detail.audit_program_detail?.ref || '') },
            }),
        )
    })
    const findingObservations = await ctx.db.auditFindingObservation.findMany({
        where: { audit_program_detail_id: { in: prgmDetailIds } },
        select: { id: true, audit_program_detail: { select: { ref: true } } },
    })
    findingObservations.forEach((observation) => {
        txns.push(
            ctx.db.auditFindingObservation.update({
                where: { id: observation.id },
                data: { audit_program_detail_id: refMap.get(observation.audit_program_detail?.ref || '') },
            }),
        )
    })
    return txns
}

export function TestResultDataCheck(record: any, classifMap: Map<string, string>, summaryTestResultData: any[]) {
    for (const sheetDetails of record?.worksheet_details) {
        for (const testDetails of record?.test_assignements) {
            const responseObj: any = {}
            responseObj['auditable_area'] =
                record?.aap_detail?.mda_profile_def?.auditable_area + '-' + record?.aap_detail?.mda_profile_def?.auditable_area_code || ''
            responseObj['auditable_area_id'] = record?.aap_detail?.mda_profile_def?.id || ''
            for (const level of record?.aap_detail?.aap_level_details || []) {
                if (level.level_id === appConst.DOMAIN) {
                    responseObj['domain'] = classifMap.get(level?.classif_code)?.split('-')[0] || ''
                    //   responseObj['domain_id'] = classifMap.get(level?.classif_code)?.split('-')[1] || ''
                } else if (level.level_id === appConst.SUBJECT) {
                    responseObj['subject'] = classifMap.get(level?.classif_code)?.split('-')[0] || ''
                    //    responseObj['subject_id'] = classifMap.get(level?.classif_code)?.split('-')[1] || ''
                }
            }
            responseObj['objective'] = record?.objective?.objective || ''
            responseObj['objective_id'] = record?.objective?.id || ''
            responseObj['risk'] = record.control?.risk_assessment_conclusion_details[0]?.risk?.name || ''
            responseObj['risk_id'] = record?.control?.risk_assessment_conclusion_details[0]?.risk?.id || ''
            responseObj['control'] = record?.control?.name || ''
            responseObj['control_id'] = record?.control?.id || ''
            responseObj['procedure'] = record?.procedure?.name || ''
            responseObj['procedure_id'] = record?.procedure?.id || ''
            responseObj['type_of_test'] = sheetDetails?.type_of_test || ''
            responseObj['test'] = testDetails?.test?.test || ''
            responseObj['test_id'] = testDetails?.test?.id || ''
            responseObj['information_source'] = sheetDetails?.information_source || ''
            responseObj['population_size'] = sheetDetails?.population_size || 0
            responseObj['sample_size'] = sheetDetails?.sample_size || 0
            summaryTestResultData.push(responseObj)
        }
    }

    return summaryTestResultData
}

export const pocessClassifDetails = async (res: any, ctx: Context, testResultData: any[]) => {
    const classifIDs: any[] = []
    const classifMap = new Map<string, string>()
    res.forEach((info: any) => {
        info?.aap_detail?.aap_level_details.forEach((levelDetails: any) => {
            classifIDs.push(levelDetails?.classif_code)
        })
    })
    const codes = await ctx.db.auditHierarchyCode.findMany({
        where: { id: { in: classifIDs } },
        select: { id: true, name: true },
    })
    for (const code of codes) {
        classifMap.set(code?.id, code?.name + '-' + code?.id)
    }
    res.forEach((details: any) => {
        testResultData = TestResultDataCheck(details, classifMap, testResultData)
    })
    return testResultData
}

export const auditProgramDetailsQuery = async (ctx: Context, id: string) => {
    const res = await ctx.db.auditProgramDetail.findMany({
        where: {
            audit_program: {
                audit_commencement: {
                    id: { equals: id },
                    is_effective: { equals: true },
                },
            },
        },
        select: {
            audit_program: {
                select: {
                    audit_commencement: {
                        select: {
                            ref: true,
                            name: true,
                            file_number: true,
                        },
                    },
                },
            },
            id: true,
            objective: {
                select: {
                    id: true,
                    objective: true,
                },
            },
            control: {
                select: {
                    id: true,
                    name: true,
                    risk_assessment_conclusion_details: {
                        where: {
                            risk_assessment_conclusion: { is_effective: { equals: true } },
                            audit_decision: { notIn: [appConst.STATUS_CODES.DEFER, appConst.STATUS_CODES.CLOSED] },
                        },
                        select: { risk: { select: { id: true, name: true } } },
                    },
                },
            },
            procedure: {
                select: {
                    id: true,
                    name: true,
                },
            },
            worksheet_details: {
                select: {
                    id: true,
                    information_source: true,
                    population_size: true,
                    sample_size: true,
                    type_of_test: true,
                },
            },

            test_assignements: {
                select: {
                    test: {
                        select: {
                            id: true,
                            test: true,
                        },
                    },
                },
            },
            aap_detail: {
                select: {
                    aap_level_details: { select: { level_id: true, classif_code: true } },
                    aap_sub_assignments: { select: { assignment: { select: { ref: true } } } },
                    aap_item: { select: { ref: true } },
                    mda_profile_def: { select: { auditable_area: true, auditable_area_code: true, id: true } },
                },
            },
        },
    })
    if (!res) {
        error.throwUserError('no.data.found')
    }

    return res
}
