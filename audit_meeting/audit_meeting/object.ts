import { objectType, extendInputType } from 'nexus'

export const AUDIT_MEETING_OBJ = objectType({
    name: 'AuditMeeting',
    definition(t) {
        t.model.id()
        t.model.tenant_id()
        t.model.commencement_from_id()
        t.model.location()
        t.model.proposed_date()
        t.model.actual_date()
        t.model.documentation()
        t.model.meeting_type()
        t.model.reason()
        t.model.ref()
        t.model.status()
        t.model.is_active()
        t.model.is_latest()
        t.model.is_effective()
        t.model.effective_from()
        t.model.version_no()
        t.model.version_user()
        t.model.version_date()
        t.model.commencemet_form()
        t.model.audit_meeting_details({ ordering: true, pagination: true, filtering: true })
        t.model.meeting_agendas({ ordering: true, pagination: true, filtering: true })
        t.model.participants({ ordering: true, pagination: true, filtering: true })
        t.model.meeting_documents({ ordering: true, pagination: true, filtering: true })
    },
})

export const AUDIT_MEETING_CREATE_EXT = extendInputType({
    type: 'AuditMeetingCreateInput',
    definition(t) {
        t.field('wf_params', { type: 'JSON', nullable: true })
        t.field('documents', { type: 'JSON', nullable: true })
    },
})

export const AUDIT_MEETING_UPDATE_EXT = extendInputType({
    type: 'AuditMeetingUpdateInput',
    definition(t) {
        t.field('wf_params', { type: 'JSON', nullable: true })
        t.field('documents', { type: 'JSON', nullable: true })
    },
})
