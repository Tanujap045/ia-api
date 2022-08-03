import { extendType } from 'nexus'

export const TIME_FIN_RESOURCE_MUTATION_OBJ = extendType({
    type: 'Mutation',
    definition(t) {
        t.crud.createOneTimeFinResource()
        t.crud.updateOneTimeFinResource()
        t.crud.deleteOneTimeFinResource()
        t.crud.updateManyTimeFinResource()
        t.crud.deleteManyTimeFinResource()
    },
})
