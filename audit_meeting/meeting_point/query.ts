import { extendType } from 'nexus'

export const MEETING_POINT_QUERY = extendType({
    type: 'Query',
    definition(t) {
        t.crud.meetingPoint()
        t.crud.meetingPoints({ ordering: true, pagination: true, filtering: true })
    },
})
