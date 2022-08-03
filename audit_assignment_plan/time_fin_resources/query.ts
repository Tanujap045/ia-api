import { extendType } from 'nexus'

export const TIME_FIN_RESOURCE_QUERY_OBJ = extendType({
    type: 'Query',
    definition(t) {
        t.crud.timeFinResource()
        t.crud.timeFinResources()
    },
})
