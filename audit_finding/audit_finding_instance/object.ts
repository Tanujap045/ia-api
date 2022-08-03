import { objectType, extendInputType, inputObjectType } from 'nexus'

export const AUDIT_FINDING_INST_OBJ = objectType({
    name: 'AuditFindingInstance',
    definition(t) {
        t.model.id()
        t.model.tenant_id()
        t.model.commencement_id()
        t.model.ref()
        t.model.status()
        t.model.is_active()
        t.model.is_latest()
        t.model.is_effective()
        t.model.effective_from()
        t.model.version_no()
        t.model.version_user()
        t.model.version_date()
        t.model.commencement_from()
        t.model.findings({ ordering: true, pagination: true, filtering: true })
    },
})

export const AUDIT_FINDING_INST_OBJ_CREATE_EXT = extendInputType({
    type: 'AuditFindingInstanceCreateInput',
    definition(t) {
        t.field('wf_params', { type: 'JSON', nullable: true })
        t.field('documents', { type: 'JSON', nullable: true })
    },
})

export const AUDIT_FINDING_INST_OBJ_UPDATE_EXT = extendInputType({
    type: 'AuditFindingInstanceUpdateInput',
    definition(t) {
        t.field('wf_params', { type: 'JSON', nullable: true })
        t.field('documents', { type: 'JSON', nullable: true })
    },
})

export const AUDIT_FINDING_BULK_CREATE = inputObjectType({
    name: 'AuditFindingInstanceBulkCreateInput',
    definition(t) {
        t.list.field('AuditFindingInstances', { type: 'AuditFindingInstanceCreateInput' })
        t.field('wf_params', { type: 'JSON', nullable: true })
    },
})
