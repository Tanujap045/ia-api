import { objectType } from 'nexus'

export const MEETING_POINT_OBJ = objectType({
    name: 'MeetingPoint',
    definition(t) {
        t.model.id()
        t.model.tenant_id()
        t.model.sno()
        t.model.item()
        t.model.lead_agency()
        t.model.lead_person()
        t.model.audit_meeting_id()
        t.model.audit_meeting()
    },
})
