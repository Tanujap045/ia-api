import { extendType } from 'nexus'
export const RECOMMENDATION_MUTATION = extendType({
    type: 'Mutation',
    definition(t) {
        t.crud.createOneRecommendation()
        t.crud.updateOneRecommendation()
        t.crud.deleteOneRecommendation()
        t.crud.updateManyRecommendation()
        t.crud.deleteManyRecommendation()
    },
})
