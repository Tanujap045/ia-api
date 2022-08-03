import { extendType } from 'nexus'

export const AUDIT_MEETING_DETAIL_QUERY = extendType({
    type: 'Query',
    definition(t) {
        t.crud.auditMeetingDetail()
        t.crud.auditMeetingDetails({ ordering: true, pagination: true, filtering: true })
    },
})
