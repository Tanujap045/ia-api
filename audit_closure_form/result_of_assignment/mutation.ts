import { extendType } from 'nexus'
export const RESULT_OF_ASSIGNMENT_MUTATION = extendType({
    type: 'Mutation',
    definition(t) {
        t.crud.createOneResultOfAssignment()
        t.crud.updateOneResultOfAssignment()
        t.crud.deleteOneResultOfAssignment()
        t.crud.updateManyResultOfAssignment()
        t.crud.deleteManyResultOfAssignment()
    },
})
