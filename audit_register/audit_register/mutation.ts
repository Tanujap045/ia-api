import { extendType } from 'nexus'
import { audit_handler, error, sysadmin, wf_util } from 'fmis-common'
import * as appConst from '../../../util/constants'
import { Context } from 'nexus-plugin-prisma/dist/utils'
import * as cuid from 'cuid'
export const AUDIT_REGISTER_MUTATION = extendType({
    type: 'Mutation',
    definition(t) {
        t.crud.createOneAuditRegister({
            authorize: (root, args, ctx) => {
                return ctx.isInternal || ctx.isAuthorized(ctx.token.username, appConst.FUNCTION_CODE.IA_AUDIT_REGISTER + '_C', '')
            },
            resolve: async (root, args, ctx, info, originalResolver) => {
                await handleDraftRecord(ctx, args.data.ref || '')
                await validatePostApprEditAuditReg(args, args.data.ref || '')
                await managementActionCheck(
                    args,
                    ctx,
                    args.data.id || '',
                    args.data.commencement_form?.connect?.id || '',
                    args.data.ref || '',
                )
                const wfParams = wf_util.validateNGetWfParams(args)
                wfParams['seq_key'] = appConst.FUNCTION_CODE.IA_AUDIT_REGISTER + '_REF'
                wfParams['seq_conf'] = {
                    fin_year: await sysadmin.GetFinYearForSeqGeneration(ctx),
                }
                const res = await originalResolver(root, args, ctx, info)
                await audit_handler.publishAudit(
                    wfParams,
                    appConst.FUNCTION_CODE.IA_AUDIT_REGISTER,
                    res,
                    'create',
                    ctx.rawToken || '',
                    ctx.token,
                )
                return res
            },
        })
        t.crud.updateOneAuditRegister({
            authorize: (__, args, ctx) => {
                return ctx.isInternal || ctx.isAuthorized(ctx.token.username, appConst.FUNCTION_CODE.IA_AUDIT_REGISTER + '_R', '')
            },
            resolve: async (root, args, ctx, info, originalResolver) => {
                const wfParams = wf_util.validateNGetWfParams(args)
                let res: any
                wfParams['seq_key'] = appConst.FUNCTION_CODE.IA_AUDIT_REGISTER + '_REF'
                wfParams['seq_conf'] = { fin_year: await sysadmin.GetFinYearForSeqGeneration(ctx) }
                if (!(await wf_util.canSaveAllowed(ctx, appConst.FUNCTION_CODE.IA_AUDIT_REGISTER, 'ALL', wfParams))) {
                    res = await ctx.db.auditRegister.findUnique({
                        where: { id: args.where.id! },
                    })
                    wfParams['byPassAudit'] = true
                } else {
                    if (!appConst.INACTIVE_CODES.includes(args.data.status?.set || '')) {
                        await validatePostApprEditAuditReg(args, args.data.ref?.set || '')
                    }
                    await managementActionCheck(
                        args,
                        ctx,
                        args.where.id || '',
                        args.data.commencement_form?.connect?.id || '',
                        args.data.ref?.set || '',
                    )
                    await cleanUpAuditRegister(ctx, args.where.id || '')
                    res = await originalResolver(root, args, ctx, info)
                }
                await audit_handler.publishAudit(
                    wfParams,
                    appConst.FUNCTION_CODE.IA_AUDIT_REGISTER,
                    res,
                    'update',
                    ctx.rawToken || '',
                    ctx.token,
                )
                return res
            },
        })

        t.crud.deleteOneAuditRegister({
            authorize: (root, args, ctx) => {
                return ctx.isInternal || ctx.isAuthorized(ctx.token.username, appConst.FUNCTION_CODE.IA_AUDIT_REGISTER + '_D', '')
            },
            resolve: async (root, args, ctx, info, originalResolver) => {
                await cleanUpAuditRegister(ctx, args.where.id || '')
                const res = await originalResolver(root, args, ctx, info)
                await audit_handler.publishAudit({}, appConst.FUNCTION_CODE.IA_AUDIT_REGISTER, res, 'delete', ctx.rawToken || '', ctx.token)
                return res
            },
        })
    },
})

const cleanUpAuditRegister = async (ctx: Context, auditRegisterId: string) => {
    const txnPromises = new Array<any>()
    const registerDetailIds = new Array<string>()
    const registerDetails = await ctx.db.auditRegisterDetail.findMany({
        where: { register_finding: { audit_register_id: auditRegisterId } },
        select: { id: true },
    })
    for (const detail of registerDetails) {
        registerDetailIds.push(detail.id)
    }
    txnPromises.push(ctx.db.supportingDoc.deleteMany({ where: { audit_register_detail_id: { in: registerDetailIds } } }))
    txnPromises.push(ctx.db.auditRegisterDetail.deleteMany({ where: { id: { in: registerDetailIds } } }))
    txnPromises.push(ctx.db.auditRegisterFinding.deleteMany({ where: { audit_register_id: auditRegisterId } }))
    txnPromises.push(ctx.db.auditRegister.update({ where: { id: auditRegisterId }, data: { commencement_form: { disconnect: true } } }))
    try {
        await ctx.db.$transaction(txnPromises)
    } catch (err) {
        console.log('Error Occured while deleting auditRegister: ', err)
    }
}

const managementActionCheck = async (args: any, ctx: Context, id: string, cmmId: string, ref: string) => {
    const auditFindingIds: string[] = []
    args.data.audit_register_finding?.create?.forEach((auditFinding: any) => {
        auditFindingIds.push(auditFinding?.audit_finding?.connect?.id || '')
        // auditFinding?.audit_register_details?.create?.forEach((registerDetails: any) => {
        //     mnActnPlanIds.push(registerDetails?.mngmt_action_plan?.connect?.id || '')
        // })
    })
    const auditRegisterFindingCount = await ctx.db.auditRegisterFinding.count({
        where: {
            audit_register: {
                id: { not: id },
                ref: { not: ref },
                status: { notIn: appConst.INACTIVE_CODES },
                commencement_form_id: cmmId,
            },
            audit_finding_id: { in: auditFindingIds },
            // audit_register_details: {
            //     some: { mngmt_action_plan: { id: { in: mnActnPlanIds } } },
            // },
        },
    })
    if (auditRegisterFindingCount > 0) {
        error.throwUserError('register.conf.exist')
    }
}

const validatePostApprEditAuditReg = async (args: any, ref: string) => {
    if (!cuid.isCuid(ref)) {
        let regDetailCount = 0
        const findingStsArr = new Array<string>()
        args.data.audit_register_finding?.create?.forEach((regFinding: any) => {
            regFinding.audit_register_details?.create?.forEach((regDetail: any) => {
                if (regDetail.finding_status === appConst.STATUS_CODES.CLOSED) {
                    findingStsArr.push(regDetail.finding_status || '')
                }
                regDetailCount++
            })
        })
        if (regDetailCount === findingStsArr.length) {
            error.throwUserError('register.findings.closed')
        }
    }
}

const handleDraftRecord = async (ctx: Context, ref: string) => {
    if (!cuid.isCuid(ref)) {
        const auditRegCount = await ctx.db.auditRegister.count({ where: { ref: ref, status: appConst.STATUS_CODES.DRAFT } })
        if (auditRegCount > 0) {
            error.throwUserError('draft.record.exists')
        }
    }
}
