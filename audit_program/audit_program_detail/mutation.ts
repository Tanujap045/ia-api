import { extendType } from 'nexus'
export const AUDIT_PROGRAM_DETAIL_MUTATION = extendType({
    type: 'Mutation',
    definition(t) {
        t.crud.createOneAuditProgramDetail()
        t.crud.updateOneAuditProgramDetail()
        t.crud.deleteOneAuditProgramDetail()
        t.crud.updateManyAuditProgramDetail()
        t.crud.deleteManyAuditProgramDetail()
    },
})
