import { objectType } from 'nexus'

export const AUDIT_MEETING_DETAIL_OBJ = objectType({
    name: 'AuditMeetingDetail',
    definition(t) {
        t.model.id()
        t.model.tenant_id()
        t.model.audit_meeting_id()
        t.model.commencement_detail_id()
        t.model.commencement_detail()
        t.model.audit_meeting()
    },
})
