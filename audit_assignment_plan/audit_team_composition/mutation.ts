import { extendType } from 'nexus'

export const AUDIT_TEAM_COMPOSITION_MUTATION_OBJ = extendType({
    type: 'Mutation',
    definition(t) {
        t.crud.createOneAuditTeamComposition()
        t.crud.updateOneAuditTeamComposition()
        t.crud.deleteOneAuditTeamComposition()
        t.crud.updateManyAuditTeamComposition()
        t.crud.deleteManyAuditTeamComposition()
    },
})
