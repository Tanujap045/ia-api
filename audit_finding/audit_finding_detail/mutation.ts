import { extendType } from 'nexus'
export const AUDIT_FINDING_DETAIL_MUTATION = extendType({
    type: 'Mutation',
    definition(t) {
        t.crud.createOneAuditFindingDetail()
        t.crud.updateOneAuditFindingDetail()
        t.crud.deleteOneAuditFindingDetail()
        t.crud.updateManyAuditFindingDetail()
        t.crud.deleteManyAuditFindingDetail()
    },
})
