import { objectType } from 'nexus'

export const AUDIT_PROGRAM_DETAIL_OBJ = objectType({
    name: 'AuditProgramDetail',
    definition(t) {
        t.model.id()
        t.model.tenant_id()
        t.model.sno()
        t.model.ref()
        t.model.audit_program_id()
        t.model.aap_detail_id()
        t.model.objective_id()
        t.model.control_id()
        t.model.finding_id()
        t.model.procedure_id()
        t.model.objective()
        t.model.control()
        t.model.procedure()
        t.model.aap_detail()
        t.model.audit_program()
        t.model.test_assignements({ ordering: true, pagination: true, filtering: true })
        t.model.worksheet_details({ ordering: true, pagination: true, filtering: true })
        t.model.finding()
        t.model.audit_finding_observations({ ordering: true, pagination: true, filtering: true })
    },
})
