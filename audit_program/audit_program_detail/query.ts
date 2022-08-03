import { booleanArg, extendType, stringArg } from 'nexus'
import * as appConst from '../../../util/constants'

export const AUDIT_PROGRAM_DETAIL_QUERY = extendType({
    type: 'Query',
    definition(t) {
        t.crud.auditProgramDetail()
        t.crud.auditProgramDetails({ ordering: true, pagination: true, filtering: true })
        t.field('auditProceduresWithAuditTest', {
            type: 'JSON',
            args: {
                objective_id: stringArg({ required: false }),
                commencement_ids: stringArg({ required: true }),
                create: booleanArg({ required: false, default: true }),
            },
            resolve: async (_parent, args, ctx) => {
                const commencementIds = args.commencement_ids.split(',') || ['DUMMY']
                const whereQry = {
                    objective_id: args.objective_id ? { in: args.objective_id.split(',') } : undefined,
                    audit_program: { audit_commencement: { commencement_details: { some: { id: { in: commencementIds } } } } },
                } as any
                if (args.create) {
                    whereQry['worksheet_details'] = { every: { worksheet: { status: { in: appConst.INACTIVE_CODES } } } }
                }
                const auditProgramDetail: any = await ctx.db.auditProgramDetail.findMany({
                    where: whereQry,
                    include: {
                        aap_detail: true,
                        procedure: true,
                    },
                })
                const controlIds = ['DUMMY']
                auditProgramDetail.forEach((detail: any) => {
                    controlIds.push(detail.control_id || '')
                })
                const riskAssessments = await ctx.db.residualRiskAssessmentDetail.findMany({
                    where: {
                        control_assessment_detail: {
                            inherent_risk: { audit_scope_detail: { control_id: { in: controlIds } } },
                        },
                    },
                    select: {
                        control_score: true,
                        control_assessment_detail: {
                            select: {
                                inherent_risk: {
                                    select: {
                                        audit_scope_detail: {
                                            select: {
                                                control_id: true,
                                            },
                                        },
                                    },
                                },
                            },
                        },
                    },
                })
                const controlScoreDefs = await ctx.db.controlScoreDef.findMany()

                const controlVsScoreMap = new Map<string, Array<{ score: number; test: string }>>()
                riskAssessments.forEach((assessment) => {
                    const scoreConf = controlScoreDefs.find(function (e) {
                        return e.start_range <= (assessment.control_score || 0) && e.end_range >= (assessment.control_score || 0)
                    })
                    const controlId = assessment.control_assessment_detail?.inherent_risk?.audit_scope_detail?.control_id || ''
                    const scoreMap = controlVsScoreMap.get(controlId) || Array<{ score: number; test: string }>()
                    scoreMap.push({
                        score: assessment.control_score,
                        test: scoreConf?.testing_required || '',
                    })
                    controlVsScoreMap.set(controlId, scoreMap)
                })
                const controlIdVsTestType = new Map<string, string>()
                let testDesc = appConst.AUDIT_TEST_DESC.BOTH
                controlVsScoreMap.forEach((scoreObjs, controlId) => {
                    scoreObjs.forEach((obj) => {
                        if (obj.test === appConst.AUDIT_TEST_DESC.SUBSTANTIVE_TEST) {
                            testDesc = appConst.AUDIT_TEST_DESC.SUBSTANTIVE_TEST
                        } else if (obj.test === appConst.AUDIT_TEST_DESC.CONTROL_TEST) {
                            testDesc = appConst.AUDIT_TEST_DESC.CONTROL_TEST
                        } else {
                            testDesc = appConst.AUDIT_TEST_DESC.BOTH
                        }
                    })
                    controlIdVsTestType.set(controlId, testDesc)
                })
                auditProgramDetail.forEach((detail: any) => {
                    detail['test_desc'] = controlIdVsTestType.get(detail.control_id || '')
                })
                return { list: auditProgramDetail }
            },
        })
    },
})
