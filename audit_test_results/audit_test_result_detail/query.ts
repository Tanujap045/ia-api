import { extendType } from 'nexus'

export const AUDIT_TEST_RESULT_DETAIL_QUERY = extendType({
    type: 'Query',
    definition(t) {
        t.crud.auditTestResultDetail()
        t.crud.auditTestResultDetails({ ordering: true, pagination: true, filtering: true })
    },
})
