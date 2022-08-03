import { objectType } from 'nexus'

export const MANAGEMENT_CONTACT_OBJ = objectType({
    name: 'ManagementContact',
    definition(t) {
        t.model.id()
        t.model.tenant_id()
        t.model.sno()
        t.model.auditable_area()
        t.model.audit_assignment_plan()
        t.model.designition()
        t.model.name()
        t.model.email()
        t.model.phone()
        t.model.audit_assignment_plan_id()
    },
})
