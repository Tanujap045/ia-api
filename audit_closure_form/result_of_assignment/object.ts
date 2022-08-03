import { objectType } from 'nexus'

export const RESULT_OF_ASSIGNMENT_OBJ = objectType({
    name: 'ResultOfAssignment',
    definition(t) {
        t.model.id()
        t.model.tenant_id()
        t.model.sno()
        t.model.item()
        t.model.value()
        t.model.audit_closure_form_id()
        t.model.audit_closure_form()
    },
})
