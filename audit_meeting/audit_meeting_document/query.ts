import { extendType } from 'nexus'

export const AUDIT_MEETING_DOCUMENT_QUERY = extendType({
    type: 'Query',
    definition(t) {
        t.crud.auditMeetingDocument()
        t.crud.auditMeetingDocuments({ ordering: true, pagination: true, filtering: true })
    },
})
