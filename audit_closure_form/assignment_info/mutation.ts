import { extendType } from 'nexus'
export const ASSIGNMENT_INFO_MUTATION = extendType({
    type: 'Mutation',
    definition(t) {
        t.crud.createOneAssignmentInfo()
        t.crud.updateOneAssignmentInfo()
        t.crud.deleteOneAssignmentInfo()
        t.crud.updateManyAssignmentInfo()
        t.crud.deleteManyAssignmentInfo()
    },
})
