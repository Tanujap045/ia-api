import { extendType } from 'nexus'

export const ASSIGNMENT_INFO_QUERY = extendType({
    type: 'Query',
    definition(t) {
        t.crud.assignmentInfo()
        t.crud.assignmentInfos({ ordering: true, pagination: true, filtering: true })
    },
})
