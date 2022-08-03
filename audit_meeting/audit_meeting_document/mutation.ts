import { extendType } from 'nexus'
export const AUDIT_MEETING_DOCUMENT_MUTATION = extendType({
    type: 'Mutation',
    definition(t) {
        t.crud.createOneAuditMeetingDocument()
        t.crud.updateOneAuditMeetingDocument()
        t.crud.deleteOneAuditMeetingDocument()
        t.crud.updateManyAuditMeetingDocument()
        t.crud.deleteManyAuditMeetingDocument()
    },
})
