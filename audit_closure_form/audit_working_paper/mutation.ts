import { extendType } from 'nexus'
export const AUDIT_WORKING_PAPER_MUTATION = extendType({
    type: 'Mutation',
    definition(t) {
        t.crud.createOneAuditWorkingPaper()
        t.crud.updateOneAuditWorkingPaper()
        t.crud.deleteOneAuditWorkingPaper()
        t.crud.updateManyAuditWorkingPaper()
        t.crud.deleteManyAuditWorkingPaper()
    },
})
