import { extendType } from 'nexus'

export const TEST_ASSIGNMENT_DETAIL_QUERY = extendType({
    type: 'Query',
    definition(t) {
        t.crud.testAssignementDetail()
        t.crud.testAssignementDetails({ ordering: true, pagination: true, filtering: true })
    },
})
