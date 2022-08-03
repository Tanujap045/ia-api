import { objectType, extendInputType, inputObjectType } from 'nexus'

export const AAP_ADMIN_ACTIVITY_EXEC_OBJ = objectType({
    name: 'AAPAdminActivityExec',
    definition(t) {
        t.model.id()
        t.model.tenant_id()
        t.model.app_item_id()
        t.model.app_adm_activity_id()
        t.model.remarks()
        t.model.exec_status()
        t.model.ref()
        t.model.status()
        t.model.is_active()
        t.model.is_latest()
        t.model.is_effective()
        t.model.effective_from()
        t.model.version_no()
        t.model.version_user()
        t.model.version_date()
        t.model.aap_item()
        t.model.admin_activity()
    },
})

export const AAP_ADMIN_ACTIVITY_EXEC_OBJ_CREATE_EXT = extendInputType({
    type: 'AAPAdminActivityExecCreateInput',
    definition(t) {
        t.field('wf_params', { type: 'JSON', nullable: true })
    },
})
export const AAP_ADMIN_ACTIVITY_EXEC_OBJ_UPDATE_EXT = extendInputType({
    type: 'AAPAdminActivityExecUpdateInput',
    definition(t) {
        t.field('wf_params', { type: 'JSON', nullable: true })
    },
})

export const AAP_ADMIN_ACTIVITY_EXEC_BULK_CREATE = inputObjectType({
    name: 'AAPAdminActivityExecBulkCreateInput',
    definition(t) {
        t.list.field('list', { type: 'AAPAdminActivityExecCreateInput' })
        t.field('wf_params', { type: 'JSON', nullable: true })
    },
})
