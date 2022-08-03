import { objectType } from 'nexus'
import { api } from 'fmis-common'

export const AUDIT_MEETING_DOCUMENT_OBJ = objectType({
    name: 'AuditMeetingDocument',
    definition(t) {
        t.model.id()
        t.model.tenant_id()
        t.model.audit_meeting_id()
        t.model.sno()
        t.model.document_name()
        t.model.document_type()
        t.model.document_id()
        t.model.audit_meeting()
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
                    { id: root.document_id || '' },
                    ctx.rawToken || '',
                    ctx.token,
                )
                return result.file
            },
        })
    },
})
