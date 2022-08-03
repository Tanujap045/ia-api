import { Prisma } from '@prisma/client'
import { arg, extendType } from 'nexus'

export const AUDIT_FINDING_INSTANCE_QUERY = extendType({
    type: 'Query',
    definition(t) {
        t.crud.auditFindingInstance()
        t.crud.auditFindingInstances({
            ordering: true,
            pagination: true,
            filtering: true,
            resolve: async (root, args, ctx, info, orginalResolver) => {
                // await getIdsFromClassifNames(ctx, args)
                return await orginalResolver(root, args, ctx, info)
            },
        })
        t.int('auditFindingInstanceCount', {
            args: { where: arg({ type: 'AuditFindingInstanceWhereInput', nullable: true }) },
            resolve: async (_root, args, ctx) => {
                // await getIdsFromClassifNames(ctx, args)
                return await ctx.db.auditFindingInstance.count({ where: args.where as Prisma.AuditFindingInstanceWhereInput })
            },
        })
    },
})
