import { extendType } from 'nexus'
export const AUDIT_FINDING_OBSERVATION_MUTATION = extendType({
    type: 'Mutation',
    definition(t) {
        t.crud.createOneAuditFindingObservation()
        t.crud.updateOneAuditFindingObservation()
        t.crud.deleteOneAuditFindingObservation()
        t.crud.updateManyAuditFindingObservation()
        t.crud.deleteManyAuditFindingObservation()
    },
})
