import { extendType } from 'nexus'

export const MANAGEMENT_CONTACT_MUTATION_OBJ = extendType({
    type: 'Mutation',
    definition(t) {
        t.crud.createOneManagementContact()
        t.crud.updateOneManagementContact()
        t.crud.deleteOneManagementContact()
        t.crud.updateManyManagementContact()
        t.crud.deleteManyManagementContact()
    },
})
