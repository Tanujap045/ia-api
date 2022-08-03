import { objectType } from 'nexus'
import { api } from 'fmis-common'

export const AUDIT_FINDING_DETAIL_OBJ = objectType({
    name: 'AuditFindingDetail',
    definition(t) {
        t.model.id()
        t.model.tenant_id()
        t.model.audit_finding_id()
        t.model.criteria_observation()
        t.model.title()
        t.model.description()
        t.model.implication()
        t.model.cause()
        t.model.mngmt_response()
        t.model.mngmt_response_doc_id()
        t.model.category()
        t.model.risk_rating()
        t.model.followup_audit_approach()
        t.model.recommendations({ ordering: true, pagination: true, filtering: true })
        t.model.mgmt_action_plan({ ordering: true, pagination: true, filtering: true })
        t.model.audit_finding()
        t.field('document_info', {
            type: 'JSON',
            async resolve(root, args, ctx) {
                const query = `
                query file($id: String!) {
                    file(where: { id: $id }) {
                      id
                      input_name
                      path
                      size
                      mimetype
                    }
                  }
                `
                const result = await api.request(
                    process.env.SYS_ADM_API_URL || '',
                    query,
                    { id: root.mngmt_response_doc_id || '' },
                    ctx.rawToken || '',
                    ctx.token,
                )
                return result.file
            },
        })
    },
})
