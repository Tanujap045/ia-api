import { extendType } from 'nexus'
export const AUDIT_REGISTER_DETAIL_MUTATION = extendType({
    type: 'Mutation',
    definition(t) {
        t.crud.createOneAuditRegisterDetail()
        t.crud.updateOneAuditRegisterDetail()
        t.crud.deleteOneAuditRegisterDetail()
    },
})
