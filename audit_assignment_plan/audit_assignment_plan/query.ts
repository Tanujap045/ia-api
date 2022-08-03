import { arg, extendType } from 'nexus'
import { Prisma } from '@prisma/client'

export const AUDIT_ASSIGNMENT_PLAN_QUERY = extendType({
    type: 'Query',
    definition(t) {
        t.crud.auditAssignmentPlan()
        t.crud.auditAssignmentPlans({ ordering: true, pagination: true, filtering: true })
        t.int('auditAssignmentPlanCount', {
            args: { where: arg({ type: 'AuditAssignmentPlanWhereInput', nullable: true }) },
            resolve: async (__, args, ctx) => {
                return await ctx.db.auditAssignmentPlan.count({ where: args.where as Prisma.AuditAssignmentPlanWhereInput })
            },
        })
    },
})
