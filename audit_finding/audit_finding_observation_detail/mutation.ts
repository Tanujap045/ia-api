import { extendType } from 'nexus'
export const AUDIT_FINDING_OBSERVATION_DETAIL_MUTATION = extendType({
    type: 'Mutation',
    definition(t) {
        t.crud.createOneAuditFindingObservationDetail()
        t.crud.updateOneAuditFindingObservationDetail()
        t.crud.deleteOneAuditFindingObservationDetail()
        t.crud.updateManyAuditFindingObservationDetail()
        t.crud.deleteManyAuditFindingObservationDetail()
    },
})
