import { extendInputType, objectType } from 'nexus'
export const AUDIT_ASSIGNMENT_PLAN_OBJ = objectType({
    name: 'AuditAssignmentPlan',
    definition(t) {
        t.model.id()
        t.model.tenant_id()
        t.model.audit_commencement_id()
        t.model.background_info()
        t.model.ref()
        t.model.status()
        t.model.is_active()
        t.model.is_latest()
        t.model.is_effective()
        t.model.effective_from()
        t.model.version_no()
        t.model.version_user()
        t.model.version_date()
        t.model.audit_commencement()
        t.model.contacts({ ordering: true, pagination: true, filtering: true })
        t.model.team_composition({ ordering: true, pagination: true, filtering: true })
        t.model.time_fin_resources({ ordering: true, pagination: true, filtering: true })
    },
})

export const AUDIT_ASSIGNMENT_PLAN_OBJ_CREATE_EXT = extendInputType({
    type: 'AuditAssignmentPlanCreateInput',
    definition(t) {
        t.field('wf_params', { type: 'JSON', nullable: true })
        t.field('documents', { type: 'JSON', nullable: true })
    },
})

export const AUDIT_ASSIGNMENT_PLAN_OBJ_UPDATE_EXT = extendInputType({
    type: 'AuditAssignmentPlanUpdateInput',
    definition(t) {
        t.field('wf_params', { type: 'JSON', nullable: true })
        t.field('documents', { type: 'JSON', nullable: true })
    },
})
