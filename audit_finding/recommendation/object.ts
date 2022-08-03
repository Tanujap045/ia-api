import { objectType } from 'nexus'

export const RECOMMENDATION_OBJ = objectType({
    name: 'Recommendation',
    definition(t) {
        t.model.id()
        t.model.tenant_id()
        t.model.sno()
        t.model.recommendation()
        t.model.status()
        t.model.audit_finding_detail()
        t.model.audit_finding_detail_id()
    },
})
