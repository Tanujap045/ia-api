import { objectType } from 'nexus'

export const TIME_FIN_RESOURCE = objectType({
    name: 'TimeFinResource',
    definition(t) {
        t.model.id()
        t.model.tenant_id()
        t.model.sno()
        t.model.phase()
        t.model.audit_assignment_plan()
        t.model.days()
        t.model.resource_cost()
        t.model.ope_cost()
        t.model.tottal_cost()
        t.model.target_date()
        t.model.audit_assignment_plan_id()
    },
})
