/* eslint-disable max-nested-callbacks */
import { Prisma } from '@prisma/client'
import { arg, extendType, stringArg } from 'nexus'
// eslint-disable-next-line @typescript-eslint/no-var-requires
const generateId = require('generate-unique-id')

import { uploadFile } from '../../../util'
import { Workbook } from 'exceljs'
import { processRowHeaders } from '../../../file'
import * as appConst from '../../../util/constants'
import { pocessClassifDetails, auditProgramDetailsQuery, auditTestHeaders } from './db'

export const AAP_AUDIT_PROGRAM_QUERY = extendType({
    type: 'Query',
    definition(t) {
        t.crud.auditProgram()
        t.crud.auditPrograms({
            ordering: true,
            pagination: true,
            filtering: true,
        })
        t.int('auditProgramCount', {
            args: { where: arg({ type: 'AuditProgramWhereInput', nullable: true }) },
            resolve: async (_root, args, ctx) => {
                return await ctx.db.auditProgram.count({ where: args.where as Prisma.AuditProgramWhereInput })
            },
        })

        t.field('auditTestResultsOfflineDownload', {
            type: 'JSON',
            args: { id: stringArg({ nullable: false }) },
            resolve: async (_root, args, ctx) => {
                const res = await auditProgramDetailsQuery(ctx, args.id || '')
                const fileName =
                    'TestResults_' +
                    (res[0]?.audit_program?.audit_commencement?.file_number || '') +
                    '_' +
                    generateId({ length: 3 }) +
                    '.xlsx'
                let testResultData: any[] = []
                testResultData = await pocessClassifDetails(res, ctx, testResultData)
                const workbook = new Workbook()
                const sheet = workbook.addWorksheet('sheet1')
                const col = 1
                let row = 2
                processRowHeaders(auditTestHeaders, sheet, col)
                for (const data of testResultData) {
                    const values = Object.values(data) as string[]
                    for (let i = 0; i < values.length; i++) {
                        sheet.getCell(row, i + 1).value = values[i]
                    }
                    row++
                }
                const streamToReturn = await workbook.xlsx.writeBuffer()
                const uploadResp = await uploadFile(ctx, streamToReturn, fileName, appConst.MimeTypeSetting.xlsx)
                return {
                    status: 'SUCCESS',
                    uploadResp: uploadResp,
                }
            },
        })
    },
})
