import { extendType } from 'nexus'

export const AUDIT_FINDING_OBSERVATION_QUERY = extendType({
    type: 'Query',
    definition(t) {
        t.crud.auditFindingObservation()
        t.crud.auditFindingObservations({ ordering: true, pagination: true, filtering: true })
    },
})
