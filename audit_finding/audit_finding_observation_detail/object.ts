import { objectType } from 'nexus'

export const AUDIT_FINDING_OBSERVATION_DETAIL_OBJ = objectType({
    name: 'AuditFindingObservationDetail',
    definition(t) {
        t.model.id()
        t.model.tenant_id()
        t.model.name()
        t.model.description()
        t.model.status()
        t.model.risk_rating()
        t.model.post_fwp_obs()
        t.model.audit_finding_observation_id()
        t.model.audit_finding_observation()
    },
})
