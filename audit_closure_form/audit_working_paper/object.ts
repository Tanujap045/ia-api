import { objectType } from 'nexus'

export const AUDIT_WORKING_PAPER_OBJ = objectType({
    name: 'AuditWorkingPaper',
    definition(t) {
        t.model.id()
        t.model.tenant_id()
        t.model.sno()
        t.model.question()
        t.model.status()
        t.model.remarks()
        t.model.audit_closure_form_id()
        t.model.audit_closure_form()
    },
})
