import { objectType, extendInputType } from 'nexus'

export const AUDIT_CLOSURE_FORM_OBJ = objectType({
    name: 'AuditClosureForm',
    definition(t) {
        t.model.id()
        t.model.tenant_id()
        t.model.commencement_form_id()
        t.model.area_of_exposure()
        t.model.sugesstion_for_auditor()
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
        t.model.audit_working_papers({ ordering: true, pagination: true, filtering: true })
        t.model.result_of_assignment({ ordering: true, pagination: true, filtering: true })
        t.model.assignment_info({ ordering: true, pagination: true, filtering: true })
    },
})

export const AUDIT_CLOSURE_FORM_OBJ_CREATE_EXT = extendInputType({
    type: 'AuditClosureFormCreateInput',
    definition(t) {
        t.field('wf_params', { type: 'JSON', nullable: true })
    },
})

export const AUDIT_CLOSURE_FORM_OBJ_UPDATE_EXT = extendInputType({
    type: 'AuditClosureFormUpdateInput',
    definition(t) {
        t.field('wf_params', { type: 'JSON', nullable: true })
    },
})
