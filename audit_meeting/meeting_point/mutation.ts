import { extendType } from 'nexus'
export const MEETING_POINT_MUTATION = extendType({
    type: 'Mutation',
    definition(t) {
        t.crud.createOneMeetingPoint()
        t.crud.updateOneMeetingPoint()
        t.crud.deleteOneMeetingPoint()
        t.crud.updateManyMeetingPoint()
        t.crud.deleteManyMeetingPoint()
    },
})
