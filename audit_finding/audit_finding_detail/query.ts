import { extendType } from 'nexus'

export const AUDIT_FINDING_DETAIL_QUERY = extendType({
    type: 'Query',
    definition(t) {
        t.crud.auditFindingDetail()
        t.crud.auditFindingDetails({ ordering: true, pagination: true, filtering: true })
    },
})
