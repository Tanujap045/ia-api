import { objectType } from 'nexus'

export const ASSIGNMENT_INFO_OBJ = objectType({
    name: 'AssignmentInfo',
    definition(t) {
        t.model.id()
        t.model.tenant_id()
        t.model.sno()
        t.model.item()
        t.model.approved_standard()
        t.model.actual()
        t.model.variance()
        t.model.audit_closure_form_id()
        t.model.audit_closure_form()
    },
})
