import { extendType } from 'nexus'

export const AUDIT_WORKING_PAPER_QUERY = extendType({
    type: 'Query',
    definition(t) {
        t.crud.auditWorkingPaper()
        t.crud.auditWorkingPapers({ ordering: true, pagination: true, filtering: true })
    },
})
