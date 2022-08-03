import { Prisma } from '@prisma/client'
import { arg, extendType } from 'nexus'

export const AAP_ADMIN_ACTIVITY_EXEC_QUERY = extendType({
    type: 'Query',
    definition(t) {
        t.crud.aapAdminActivityExec({})
        t.crud.aapAdminActivityExecs({ ordering: true, pagination: true, filtering: true })
        t.int('aapAdminActivityExecCount', {
            args: { where: arg({ type: 'AAPAdminActivityExecWhereInput', nullable: true }) },
            resolve: async (_root, args, ctx) => {
                return await ctx.db.aAPAdminActivityExec.count({ where: args.where as Prisma.AAPAdminActivityExecWhereInput })
            },
        })
    },
})
