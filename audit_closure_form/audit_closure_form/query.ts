import { extendType, arg, stringArg } from 'nexus'
import { Prisma } from '@prisma/client'
import { Context } from 'nexus-plugin-prisma/dist/utils'
import { getDaysArray } from '../../../masters/resource_plan_configuration/holiday_calendar/calendar_event'
import * as appConst from '../../../util/constants'

export const AUDIT_CLOSURE_FORM_QUERY = extendType({
    type: 'Query',
    definition(t) {
        t.crud.auditClosureForm()
        t.crud.auditClosureForms({ ordering: true, pagination: true, filtering: true })
        t.int('auditClosureFormCount', {
            args: { where: arg({ type: 'AuditClosureFormWhereInput', nullable: true }) },
            resolve: async (_root, args, ctx) => {
                return await ctx.db.auditClosureForm.count({ where: args.where as Prisma.AuditClosureFormWhereInput })
            },
        })
        t.field('getKeyOfAuditAssignmentData', {
            type: 'JSON',
            args: { assignmentId: stringArg({ nullable: false }) },
            resolve: async (root, args, ctx) => {
                return await prepareKeyOfAuditCalcData(ctx, args.assignmentId)
            },
        })
    },
})

const prepareKeyOfAuditCalcData = async (ctx: Context, assignmentId: string) => {
    const response: any = {}
    const assignmentData = await prepareDataForKeyOfAudit(ctx, assignmentId)
    response['draftReportIssueProgressTime'] = assignmentData.draftRepObj
    response['finalReportIssueProgressTime'] = assignmentData.finalRepObj
    response['financialResourceBudget'] = assignmentData.financialBudget
    response['noOfInternalAuditors'] = await prepareInternalAuditors(ctx, assignmentId)
    response['totalExcludeTimeForAudit'] = assignmentData.totalTime
    return response
}

// calculate approved and actual auditors count based on sub assignment.
const prepareInternalAuditors = async (ctx: Context, assignmentId: string) => {
    const auditorDetails = await ctx.db.aAPAuditorDetail.findMany({
        where: {
            aap_auditor: {
                aap_detail: { aap_item: { aap_sub_assignment: { some: { id: assignmentId } }, aap: { is_effective: { equals: true } } } },
            },
        },
        select: {
            is_active: true,
            auditor_txns: { orderBy: { version_date: 'asc' } },
        },
    })
    const auditorCountObj = prepareActualAuditorCount(auditorDetails)
    const data: any = {}
    data['approved_standard'] = auditorCountObj.aapApprAuditorCount
    data['actual'] = auditorCountObj.commenceApprAuditorCount
    data['variance'] = Math.abs(auditorCountObj.aapApprAuditorCount - auditorCountObj.commenceApprAuditorCount)
    return data
}

// prepare the auditors count after commencement form approval
const prepareActualAuditorCount = (auditorDetails: any) => {
    let commenceApprAuditorCount = 0
    let aapApprAuditorCount = 0
    for (const auditorDetail of auditorDetails) {
        if (auditorDetail.is_active && auditorDetail.auditor_txns.length === 0) {
            aapApprAuditorCount += 1
            commenceApprAuditorCount += 1
        }
        if (!auditorDetail.is_active && auditorDetail.auditor_txns.length > 0) {
            auditorDetail.auditor_txns[0].replaced_by === '' ? (aapApprAuditorCount += 1) : aapApprAuditorCount
        }
    }
    return { commenceApprAuditorCount, aapApprAuditorCount }
}

// prepare commencement form, report actuals and audit meeting queries for calculation purpose
const prepareDataForKeyOfAudit = async (ctx: Context, assignmentId: string) => {
    const commenceDetQry = { some: { aap_detail: { aap_sub_assignments: { some: { assignment_id: assignmentId } } } } }
    const commencementForm = await ctx.db.auditCommencementForm.findFirst({
        where: {
            commencement_details: commenceDetQry,
            is_effective: true,
        },
        select: { audit_dates: true, audit_dates_and_budget: true },
    })

    const reportActuals = await ctx.db.reportActual.findMany({
        where: {
            commencement_form: {
                commencement_details: commenceDetQry,
            },
            is_effective: true,
        },
        orderBy: { auditor_id: 'desc' },
        select: { report_actual_details: { select: { total_cost: true, completion_date: true } } },
    })
    const auditMeeting = await ctx.db.auditMeeting.findFirst({
        where: {
            commencemet_form: {
                commencement_details: commenceDetQry,
            },
            is_effective: true,
            documentation: appConst.MEETING.DOCUMENTATION,
            meeting_type: appConst.MEETING.OPEN_TYPE,
        },
        select: { actual_date: true },
    })
    const reportObj = await prepareReportObj(ctx, assignmentId)

    return await prepareCalculationsObj(commencementForm, reportActuals, auditMeeting, reportObj)
}

// fetch the reports based on assignment id
const prepareReportObj = async (ctx: Context, assignmentId: string) => {
    const reports = await ctx.db.report.findMany({
        where: {
            commencement_detail: { aap_detail: { aap_sub_assignments: { some: { assignment_id: assignmentId } } } },
            status: { notIn: appConst.INACTIVE_CODES },
        },
        orderBy: { submission_date: 'desc' },
        select: { submission_date: true, report_type: true },
    })
    const draftRepDateArray = new Array<Date>()
    const finalRepDateArray = new Array<Date>()
    for (const report of reports) {
        switch (report.report_type) {
            case appConst.REPORT_TYPES.DRAFT_REPORT:
                draftRepDateArray.push(report.submission_date)
                break
            case appConst.REPORT_TYPES.FINAL_REPORT:
                finalRepDateArray.push(report.submission_date)
                break
        }
    }
    return { draftRepDateArray, finalRepDateArray }
}

// prepare calculations for audit closure form - key of audit accordian.
const prepareCalculationsObj = async (
    commencementForm: any,
    reportActuals: any,
    auditMeeting: any,
    repObj: {
        draftRepDateArray: Date[]
        finalRepDateArray: Date[]
    },
) => {
    const financialBudget: any = {}
    const totalTime: any = {}
    const draftRepObj: any = {}
    const finalRepObj: any = {}
    const auditDateMap = new Map<string, Date>()
    let estimatedBudget = 0
    for (const auditDate of commencementForm?.audit_dates || []) {
        auditDateMap.set(auditDate.description + '_startDate', auditDate.start_date)
        auditDateMap.set(auditDate.description + '_endDate', auditDate.end_date)
    }
    for (const auditBudget of commencementForm?.audit_dates_and_budget || []) {
        estimatedBudget += auditBudget.estimated_budget
    }
    await prepareDraftRepIssueCalc(auditDateMap, draftRepObj, repObj, reportActuals)
    await prepareDraftRepNFinalRepCalc(auditDateMap, finalRepObj, repObj)
    await prepareCalcForFinNTotTime(auditDateMap, reportActuals, financialBudget, totalTime, estimatedBudget, auditMeeting)
    return { draftRepObj, finalRepObj, financialBudget, totalTime }
}

// calculate draft report issue time after holding audit closing meeting.
const prepareDraftRepIssueCalc = async (
    auditDateMap: Map<string, Date>,
    data: any,
    repObj: {
        draftRepDateArray: Date[]
        finalRepDateArray: Date[]
    },
    reportActuals: any,
) => {
    const approvedTotalTime = await getDaysArray(
        auditDateMap.get('Reporting_startDate')?.toDateString() || '',
        auditDateMap.get('Field Work_endDate')?.toDateString() || '',
    )
    let actualTotalTime
    const submissionDate = repObj.draftRepDateArray.length > 0 ? repObj.draftRepDateArray[0].toDateString() : ''
    if (!submissionDate) {
        actualTotalTime = []
    } else {
        actualTotalTime = await getDaysArray(
            reportActuals.length > 0 ? reportActuals[0].report_actual_details[1].completion_date.toDateString() : '',
            submissionDate,
        )
    }
    data['approved_standard'] = approvedTotalTime.length
    data['actual'] = actualTotalTime.length
    data['variance'] = Math.abs(approvedTotalTime.length - actualTotalTime.length)
}

// calculate final audit report report generated time after issuing the draft audit report
const prepareDraftRepNFinalRepCalc = async (
    auditDateMap: Map<string, Date>,
    data: any,
    repObj: {
        draftRepDateArray: Date[]
        finalRepDateArray: Date[]
    },
) => {
    const approvedTotalTime = await getDaysArray(
        auditDateMap.get('Reporting_startDate')?.toDateString() || '',
        auditDateMap.get('Reporting_endDate')?.toDateString() || '',
    )
    let actualTotalTime
    const finalSubmisDate = repObj.finalRepDateArray.length > 0 ? repObj.finalRepDateArray[0].toDateString() : ''
    const firstDraftSubDate =
        repObj.draftRepDateArray.length > 0 ? repObj.draftRepDateArray[repObj.draftRepDateArray.length - 1].toDateString() : ''
    if (!finalSubmisDate || !firstDraftSubDate) {
        actualTotalTime = []
    }
    actualTotalTime = await getDaysArray(finalSubmisDate, firstDraftSubDate)
    data['approved_standard'] = approvedTotalTime.length
    data['actual'] = actualTotalTime.length
    data['variance'] = Math.abs(approvedTotalTime.length - actualTotalTime.length)
}

// calculate total excluding time and financial resources budget.
const prepareCalcForFinNTotTime = async (
    auditDateMap: Map<string, Date>,
    reportActuals: any,
    financialBudget: any,
    totalTime: any,
    estimatedBudget: number,
    auditMeeting: any,
) => {
    const approvedTotalTime = await getDaysArray(
        auditDateMap.get('Audit Assignment_startDate')?.toDateString() || '',
        auditDateMap.get('Audit Assignment_endDate')?.toDateString() || '',
    )
    let totalCost = 0
    for (const reportActual of reportActuals) {
        for (const detail of reportActual.report_actual_details) {
            totalCost += detail.total_cost
        }
    }
    const actualTotalTime = await getDaysArray(new Date().toDateString(), auditMeeting?.actual_date.toDateString())
    financialBudget['approved_standard'] = estimatedBudget
    financialBudget['actual'] = totalCost
    financialBudget['variance'] = Math.abs(estimatedBudget - totalCost)
    totalTime['approved_standard'] = approvedTotalTime.length
    totalTime['actual'] = actualTotalTime.length
    totalTime['variance'] = Math.abs(approvedTotalTime.length - actualTotalTime.length)
}
