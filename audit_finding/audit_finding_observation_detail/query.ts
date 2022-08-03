import { extendType } from 'nexus'

export const AUDIT_FINDING_OBSERVATION_DETAIL_QUERY = extendType({
    type: 'Query',
    definition(t) {
        t.crud.auditFindingObservationDetail()
        t.crud.auditFindingObservationDetails({ ordering: true, pagination: true, filtering: true })
    },
})
