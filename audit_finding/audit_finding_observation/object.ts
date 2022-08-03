import { objectType } from 'nexus'

export const AUDIT_FINDING_OBSERVATION_OBJ = objectType({
    name: 'AuditFindingObservation',
    definition(t) {
        t.model.id()
        t.model.tenant_id()
        t.model.audit_program_detail_id()
        t.model.audit_finding_id()
        t.model.audit_finding()
        t.model.audit_program_detail()
        t.model.audit_finding_observation_details({ ordering: true, pagination: true, filtering: true })
    },
})
