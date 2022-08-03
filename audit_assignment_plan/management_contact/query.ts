import { extendType } from 'nexus'

export const MANAGEMENT_CONTACT_QUERY_OBJ = extendType({
    type: 'Query',
    definition(t) {
        t.crud.managementContact()
        t.crud.managementContacts()
    },
})
