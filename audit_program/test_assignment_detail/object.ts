import { objectType } from 'nexus'

export const TEST_ASSIGNMENT_DETAIL_OBJ = objectType({
    name: 'TestAssignementDetail',
    definition(t) {
        t.model.id()
        t.model.tenant_id()
        t.model.test_id()
        t.model.auditor_name()
        t.model.auditor_id()
        t.model.start_date()
        t.model.end_date()
        t.model.program_detail_id()
        t.model.test()
        t.model.program_detail()
        t.model.audit_test_result_detail({ ordering: true, pagination: true, filtering: true })
    },
})
