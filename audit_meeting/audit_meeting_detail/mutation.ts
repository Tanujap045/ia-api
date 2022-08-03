import { extendType } from 'nexus'
export const AUDIT_MEETING_DETAIL_MUTATION = extendType({
    type: 'Mutation',
    definition(t) {
        t.crud.createOneAuditMeetingDetail()
        t.crud.updateOneAuditMeetingDetail()
        t.crud.deleteOneAuditMeetingDetail()
        t.crud.updateManyAuditMeetingDetail()
        t.crud.deleteManyAuditMeetingDetail()
    },
})
