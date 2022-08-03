import { extendType } from 'nexus'

export const RECOMMENDATION_QUERY = extendType({
    type: 'Query',
    definition(t) {
        t.crud.recommendation()
        t.crud.recommendations({ ordering: true, pagination: true, filtering: true })
    },
})
