import { extendType } from 'nexus'

export const PARTICIPANT_QUERY = extendType({
    type: 'Query',
    definition(t) {
        t.crud.participant()
        t.crud.participants({ ordering: true, pagination: true, filtering: true })
    },
})
