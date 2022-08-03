import { objectType, extendInputType } from 'nexus'
export const AUDIT_REGISTER_OBJ = objectType({
    name: 'AuditRegister',
    definition(t) {
        t.model.id()
        t.model.tenant_id()
        t.model.commencement_form_id()
        t.model.ref()
        t.model.status()
        t.model.is_active()
        t.model.is_latest()
        t.model.is_effective()
        t.model.effective_from()
        t.model.version_no()
        t.model.version_user()
        t.model.version_date()
        t.model.commencement_form()
        t.model.audit_register_finding({ ordering: true, pagination: true, filtering: true })
    },
})
export const AUDIT_REGISTER_OBJ_CREATE_EXT = extendInputType({
    type: 'AuditRegisterCreateInput',
    definition(t) {
        t.field('wf_params', { type: 'JSON', nullable: true })
    },
})

export const AUDIT_REGISTER_OBJ_UPDATE_EXT = extendInputType({
    type: 'AuditRegisterUpdateInput',
    definition(t) {
        t.field('wf_params', { type: 'JSON', nullable: true })
    },
})
