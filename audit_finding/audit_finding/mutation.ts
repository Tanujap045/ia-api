import { extendType } from 'nexus'

export const AUDIT_FINDING_MUTATION = extendType({
    type: 'Mutation',
    definition(t) {
        t.crud.createOneAuditFinding()
        t.crud.updateOneAuditFinding()
        t.crud.deleteOneAuditFinding()
    },
})
