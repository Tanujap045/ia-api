import { extendType } from 'nexus'
export const AUDIT_REGISTER_DETAIL_QUERY = extendType({
    type: 'Query',
    definition(t) {
        t.crud.auditRegisterDetail()
        t.crud.auditRegisterDetails({ ordering: true, pagination: true, filtering: true })
    },
})
