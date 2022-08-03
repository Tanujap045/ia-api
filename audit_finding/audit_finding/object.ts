import { objectType, extendInputType } from 'nexus'

export const AUDIT_FINDING_OBJ = objectType({
    name: 'AuditFinding',
    definition(t) {
        t.model.id()
        t.model.tenant_id()
        t.model.commencement_detail_id()
        t.model.recurrent_finding()
        t.model.parent_finding_id()
        t.model.finding_status()
        t.model.finding_remarks()
        t.model.ref()
        t.model.status()
        t.model.is_active()
        t.model.is_latest()
        t.model.is_effective()
        t.model.effective_from()
        t.model.version_no()
        t.model.version_user()
        t.model.version_date()
        t.model.commencement_detail()
        t.model.parent_finding()
        t.model.child_finding()
        t.model.finding_observations({ ordering: true, pagination: true, filtering: true })
        t.model.audit_finding_details({ ordering: true, pagination: true, filtering: true })
        t.model.audit_register_finding({ ordering: true, pagination: true, filtering: true })
        t.model.audit_program_detail({ ordering: true, pagination: true, filtering: true })
        t.model.followup_audit({ ordering: true, pagination: true, filtering: true })
    },
})

export const AUDIT_FINDING_OBJ_CREATE_EXT = extendInputType({
    type: 'AuditFindingCreateInput',
    definition(t) {
        t.field('wf_params', { type: 'JSON', nullable: true })
        t.field('documents', { type: 'JSON', nullable: true })
    },
})

export const AUDIT_FINDING_OBJ_UPDATE_EXT = extendInputType({
    type: 'AuditFindingUpdateInput',
    definition(t) {
        t.field('wf_params', { type: 'JSON', nullable: true })
        t.field('documents', { type: 'JSON', nullable: true })
    },
})
