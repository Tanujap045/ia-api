-- AlterTable
ALTER TABLE "AuditFinding" ADD COLUMN     "finding_instance_id" TEXT;

-- CreateTable
CREATE TABLE "AuditFindingInstance" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "commencement_id" TEXT,
    "ref" TEXT NOT NULL,
    "status" TEXT NOT NULL DEFAULT E'Draft',
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "is_latest" BOOLEAN NOT NULL DEFAULT false,
    "is_effective" BOOLEAN NOT NULL DEFAULT false,
    "effective_from" TIMESTAMP(3),
    "version_no" INTEGER NOT NULL DEFAULT 1,
    "version_user" TEXT NOT NULL DEFAULT E'SYSTEM',
    "version_date" TIMESTAMP(3) NOT NULL,

    PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "AuditFindingInstance" ADD FOREIGN KEY("commencement_id")REFERENCES "AuditCommencementForm"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditFinding" ADD FOREIGN KEY("finding_instance_id")REFERENCES "AuditFindingInstance"("id") ON DELETE SET NULL ON UPDATE CASCADE;
