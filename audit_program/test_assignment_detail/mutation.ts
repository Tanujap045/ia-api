import { extendType } from 'nexus'
export const TEST_ASSIGNMENT_DETAIL_MUTATION = extendType({
    type: 'Mutation',
    definition(t) {
        t.crud.createOneTestAssignementDetail()
        t.crud.updateOneTestAssignementDetail()
        t.crud.deleteOneTestAssignementDetail()
        t.crud.updateManyTestAssignementDetail()
        t.crud.deleteManyTestAssignementDetail()
    },
})
