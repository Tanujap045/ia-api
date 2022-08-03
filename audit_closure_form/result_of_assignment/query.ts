import { extendType } from 'nexus'

export const RESULT_OF_ASSIGNMENT_QUERY = extendType({
    type: 'Query',
    definition(t) {
        t.crud.resultOfAssignment()
        t.crud.resultOfAssignments({ ordering: true, pagination: true, filtering: true })
    },
})
