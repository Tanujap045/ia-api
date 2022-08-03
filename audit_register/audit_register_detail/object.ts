import { objectType } from 'nexus'
export const AUDIT_REGISTER_DETAIL_OBJ = objectType({
    name: 'AuditRegisterDetail',
    definition(t) {
        t.model.id()
        t.model.tenant_id()
        t.model.register_finding_id()
        t.model.mngmt_action_plan_id()
        t.model.date_of_task()
        t.model.mngmt_action_status()
        t.model.description()
        t.model.remarks()
        t.model.is_latest()
        t.model.auditor_status()
        t.model.finding_status()
        t.model.reported_by()
        t.model.mngmt_action_plan()
        t.model.register_finding()
        t.model.supporting_docs({ ordering: true, pagination: true, filtering: true })
    },
})
