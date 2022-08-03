import { extendType } from 'nexus'

export const AUDIT_TEAM_COMPOSITION_QUERY_OBJ = extendType({
    type: 'Query',
    definition(t) {
        t.crud.auditTeamComposition()
        t.crud.auditTeamCompositions()
    },
})
