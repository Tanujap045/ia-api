import { objectType } from 'nexus'

export const AUDIT_TEAM_COMPOSITION_OBJ = objectType({
    name: 'AuditTeamComposition',
    definition(t) {
        t.model.id()
        t.model.tenant_id()
        t.model.sno()
        t.model.auditable_area()
        t.model.role()
        t.model.auditor_name()
        t.model.email()
        t.model.phone()
        t.model.audit_assignment_plan_id()
        t.model.audit_assignment_plan()
    },
})
