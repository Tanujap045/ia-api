import { extendType, arg } from 'nexus'
import { audit_handler, wf_util, sysadmin, error } from 'fmis-common'
import * as appConst from '../../util/constants'
import * as cuid from 'cuid'
import { Context } from 'nexus-plugin-prisma/dist/utils'

export const AAP_ADMIN_ACTIVITY_EXEC_MUTATION = extendType({
    type: 'Mutation',
    definition(t) {
        t.crud.createOneAAPAdminActivityExec({
            // authorize: (root, args, ctx) => {
            //     return ctx.isInternal || ctx.isAuthorized(ctx.token.username, appConst.FUNCTION_CODE.IA_AAP_ADMIN_ACTIVITY_EXEC + '_C', '')
            // },
            resolve: async (root, args, ctx, info, originalResolver) => {
                const wfParams = wf_util.validateNGetWfParams(args)
                await handleDraftRecord(ctx, args.data.ref || '')
                await handleUniqueCheck(
                    ctx,
                    args.data.admin_activity?.connect?.id || '',
                    args.data.exec_status,
                    args.data.id || '',
                    args.data.ref || '',
                )
                wfParams['seq_key'] = appConst.FUNCTION_CODE.IA_AAP_ADMIN_ACTIVITY_EXEC + '_REF'
                wfParams['seq_conf'] = { fin_year: await sysadmin.GetFinYearForSeqGeneration(ctx) }
                const res = await originalResolver(root, args, ctx, info)
                await audit_handler.publishAudit(
                    wfParams,
                    appConst.FUNCTION_CODE.IA_AAP_ADMIN_ACTIVITY_EXEC,
                    res,
                    'create',
                    ctx.rawToken || '',
                    ctx.token,
                )
                return res
            },
        })
        t.crud.updateOneAAPAdminActivityExec({
            // authorize: (root, args, ctx) => {
            //     return ctx.isInternal || ctx.isAuthorized(ctx.token.username, appConst.FUNCTION_CODE.IA_AAP_ADMIN_ACTIVITY_EXEC + '_R', '')
            // },
            resolve: async (root, args, ctx, info, originalResolver) => {
                const wfParams = wf_util.validateNGetWfParams(args)
                let res: any
                if (!(await wf_util.canSaveAllowed(ctx, appConst.FUNCTION_CODE.IA_AAP_ADMIN_ACTIVITY_EXEC, 'ALL', wfParams))) {
                    res = await ctx.db.aAPAdminActivityExec.findUnique({
                        where: { id: args.where.id! },
                    })
                    wfParams['byPassAudit'] = true
                } else {
                    await handleUniqueCheck(
                        ctx,
                        args.data.admin_activity?.connect?.id || '',
                        args.data.exec_status?.set || '',
                        args.where.id!,
                        args.data.ref?.set || '',
                    )
                    res = await originalResolver(root, args, ctx, info)
                }
                wfParams['seq_key'] = appConst.FUNCTION_CODE.IA_AAP_ADMIN_ACTIVITY_EXEC + '_REF'
                wfParams['seq_conf'] = { fin_year: await sysadmin.GetFinYearForSeqGeneration(ctx) }
                await audit_handler.publishAudit(
                    wfParams,
                    appConst.FUNCTION_CODE.IA_AAP_ADMIN_ACTIVITY_EXEC,
                    res,
                    'update',
                    ctx.rawToken || '',
                    ctx.token,
                )
                return res
            },
        })
        t.crud.deleteOneAAPAdminActivityExec({
            // authorize: (root, args, ctx) => {
            //     return ctx.isInternal || ctx.isAuthorized(ctx.token.username, appConst.FUNCTION_CODE.IA_AAP_ADMIN_ACTIVITY_EXEC + '_D', '')
            // },
            resolve: async (root, args, ctx, info, originalResolver) => {
                const res = await originalResolver(root, args, ctx, info)
                await audit_handler.publishAudit(
                    {},
                    appConst.FUNCTION_CODE.IA_AAP_ADMIN_ACTIVITY_EXEC,
                    res,
                    'delete',
                    ctx.rawToken || '',
                    ctx.token,
                )
                return res
            },
        })
        t.crud.deleteManyAAPAdminActivityExec({
            // authorize: (root, args, ctx) => {
            //     return ctx.isInternal || ctx.isAuthorized(ctx.token.username, appConst.FUNCTION_CODE.IA_AAP_ADMIN_ACTIVITY_EXEC + '_D', '')
            // },
            resolve: async (root, args, ctx, info, originalResolver) => {
                const res = await originalResolver(root, args, ctx, info)
                await audit_handler.publishAudit(
                    {},
                    appConst.FUNCTION_CODE.IA_AAP_ADMIN_ACTIVITY_EXEC,
                    res,
                    'delete',
                    ctx.rawToken || '',
                    ctx.token,
                )
                return res
            },
        })
        t.list.field('createManyAAPAdminActivityExec', {
            type: 'AAPAdminActivityExec',
            args: { data: arg({ type: 'AAPAdminActivityExecBulkCreateInput', required: true }) },
            resolve: async (_root, args, ctx) => {
                const wfParams = wf_util.validateNGetWfParams(args)
                wfParams['seq_key'] = appConst.FUNCTION_CODE.IA_AAP_ADMIN_ACTIVITY_EXEC + '_REF'
                wfParams['seq_conf'] = { fin_year: await sysadmin.GetFinYearForSeqGeneration(ctx) }
                const txnPromises: any[] = []
                const list: any = args.data.list
                let res: any = []
                const execStatus: string[] = []
                let activityIds = ''
                for (const activity of list) {
                    activity.id = activity.id ? activity.id : cuid.default()
                    activity.ref = activity.ref ? activity.ref : cuid.default()
                    if (execStatus.includes((activity.admin_activity?.connect?.id || 'unknown') + '#' + activity.exec_status)) {
                        error.throwUserError('execstatus.already.found')
                    }
                    activityIds = activityIds.concat((activity.admin_activity?.connect?.id || '') + '#')
                    execStatus.push((activity.admin_activity?.connect?.id || '') + '#' + activity.exec_status)
                    txnPromises.push(
                        ctx.db.aAPAdminActivityExec.create({
                            data: activity,
                        }),
                    )
                }
                await handleDraftRecord(ctx, list[0].ref || '')
                await multipleUniqueCheck(ctx, execStatus, activityIds, list[0].ref || '')
                try {
                    res = await ctx.db.$transaction(txnPromises)
                    await audit_handler.publishAudit(
                        wfParams,
                        appConst.FUNCTION_CODE.IA_AAP_ADMIN_ACTIVITY_EXEC,
                        res,
                        'create',
                        ctx.rawToken || '',
                        ctx.token,
                        undefined,
                        true,
                    )
                } catch (err) {
                    console.log('Error while creating MDA Mapping Definition. ', err)
                    error.throwUserError('system.global.error')
                }
                return res
            },
        })
    },
})

const handleUniqueCheck = async (ctx: Context, activityId: string, executionStatus: string, id: string, ref: string) => {
    const aapAdminActivityCount = await ctx.db.aAPAdminActivityExec.count({
        where: {
            id: { not: id },
            ref: { not: ref },
            app_adm_activity_id: activityId,
            exec_status: executionStatus,
            status: { notIn: appConst.INACTIVE_CODES },
        },
    })
    if (aapAdminActivityCount > 0) {
        error.throwUserError('execstatus.already.found')
    }
}

const multipleUniqueCheck = async (ctx: Context, execStatus: string[], activityIds: string, ref: string) => {
    const aaPAdminActivityExecs = await ctx.db.aAPAdminActivityExec.findMany({
        where: { ref: { not: ref }, app_adm_activity_id: { in: activityIds.split('#') }, status: { notIn: appConst.INACTIVE_CODES } },
        select: { app_adm_activity_id: true, exec_status: true },
    })
    if (aaPAdminActivityExecs.length > 0) {
        for (const adminActivity of aaPAdminActivityExecs) {
            if (execStatus.includes((adminActivity.app_adm_activity_id || '') + '#' + adminActivity.exec_status)) {
                error.throwUserError('execstatus.already.found')
            }
        }
    }
}

const handleDraftRecord = async (ctx: Context, ref: string) => {
    if (!cuid.isCuid(ref)) {
        const aapeCount = await ctx.db.aAPAdminActivityExec.count({ where: { ref: ref, status: appConst.STATUS_CODES.DRAFT } })
        if (aapeCount > 0) {
            console.log('Draft record already exist for the same aap admin activity execution')
            error.throwUserError('draft.record.exists')
        }
    }
}
