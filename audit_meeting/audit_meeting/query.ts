import { extendType, arg } from 'nexus'
import { Prisma } from '@prisma/client'

export const AUDIT_MEETING_QUERY = extendType({
    type: 'Query',
    definition(t) {
        t.crud.auditMeeting()
        t.crud.auditMeetings({ ordering: true, pagination: true, filtering: true })
        t.int('auditMeetingCount', {
            args: { where: arg({ type: 'AuditMeetingWhereInput', nullable: true }) },
            resolve: async (_root, args, ctx) => {
                return await ctx.db.auditMeeting.count({ where: args.where as Prisma.AuditMeetingWhereInput })
            },
        })
    },
})
