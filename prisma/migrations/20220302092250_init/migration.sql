-- CreateTable
CREATE TABLE "AuditHierarchyLevel" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "name" TEXT NOT NULL,
    "parent_id" TEXT,
    "version_no" INTEGER NOT NULL DEFAULT 1,
    "version_user" TEXT NOT NULL DEFAULT E'SYSTEM',
    "version_date" TIMESTAMP(3) NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AuditHierarchyDetailConf" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "ref" TEXT NOT NULL,
    "parent_id" TEXT,
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

-- CreateTable
CREATE TABLE "AuditHierarchyCode" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "name" TEXT NOT NULL,
    "ref_num" INTEGER NOT NULL DEFAULT 0,
    "conf_id" TEXT NOT NULL,
    "audit_level_id" TEXT,
    "path" TEXT NOT NULL,
    "parent_id" TEXT,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "status" TEXT NOT NULL DEFAULT E'A',
    "approval_status" TEXT NOT NULL DEFAULT E'Draft',
    "version_no" INTEGER NOT NULL DEFAULT 1,
    "version_user" TEXT NOT NULL DEFAULT E'SYSTEM',
    "version_date" TIMESTAMP(3) NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AuditHierarchyCodeTxn" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "ref" TEXT NOT NULL,
    "conf_id" TEXT NOT NULL,
    "code_id" TEXT NOT NULL,
    "name" TEXT,
    "is_active" BOOLEAN,
    "is_processed" BOOLEAN NOT NULL DEFAULT false,
    "version_no" INTEGER NOT NULL DEFAULT 1,
    "version_user" TEXT NOT NULL DEFAULT E'SYSTEM',
    "version_date" TIMESTAMP(3) NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AuditPlanDef" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "ref" TEXT NOT NULL,
    "risk_control_level" TEXT NOT NULL,
    "audit_program_level" TEXT NOT NULL,
    "mda_start_month" TEXT NOT NULL,
    "mda_start_day" DECIMAL(65,30) NOT NULL,
    "mda_end_month" TEXT NOT NULL,
    "mda_end_day" DECIMAL(65,30) NOT NULL,
    "type_of_auditplan" TEXT NOT NULL DEFAULT E'RollOver',
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

-- CreateTable
CREATE TABLE "AuditProgramStructure" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "name" TEXT NOT NULL,
    "parent_id" TEXT,
    "version_no" INTEGER NOT NULL DEFAULT 1,
    "version_user" TEXT NOT NULL DEFAULT E'SYSTEM',
    "version_date" TIMESTAMP(3) NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AuditObjectiveDef" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "ref" TEXT NOT NULL,
    "objective" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "audit_classification" TEXT NOT NULL,
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

-- CreateTable
CREATE TABLE "RiskDefAuditObjectiveDefMapping" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "risk_id" TEXT,
    "control_id" TEXT,
    "objective_id" TEXT NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ObjectiveAuditClassifDetail" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "source_id" TEXT NOT NULL,
    "classif_level" TEXT NOT NULL,
    "classif_codes" TEXT NOT NULL,
    "version_no" INTEGER NOT NULL DEFAULT 1,
    "version_user" TEXT NOT NULL DEFAULT E'SYSTEM',
    "version_date" TIMESTAMP(3) NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AuditProcedureDef" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "ref" TEXT NOT NULL,
    "description" TEXT,
    "name" TEXT NOT NULL,
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

-- CreateTable
CREATE TABLE "AuditProcedureDefDetail" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "procedure_def_id" TEXT,
    "risk_id" TEXT,
    "control_id" TEXT,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AuditProcedureClassifDetail" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "source_id" TEXT NOT NULL,
    "classif_level" TEXT NOT NULL,
    "classif_code" TEXT NOT NULL,
    "version_no" INTEGER NOT NULL DEFAULT 1,
    "version_user" TEXT NOT NULL DEFAULT E'SYSTEM',
    "version_date" TIMESTAMP(3) NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AuditTestDef" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "ref" TEXT NOT NULL,
    "test" TEXT NOT NULL,
    "procedure_id" TEXT NOT NULL,
    "version_no" INTEGER NOT NULL DEFAULT 1,
    "version_user" TEXT NOT NULL DEFAULT E'SYSTEM',
    "version_date" TIMESTAMP(3) NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ControlDef" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "name" TEXT NOT NULL,
    "ref" TEXT NOT NULL,
    "audit_procedure_id" TEXT,
    "description" TEXT NOT NULL,
    "control_type" TEXT NOT NULL,
    "category" TEXT NOT NULL,
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

-- CreateTable
CREATE TABLE "RiskDef" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "ref" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "category" TEXT NOT NULL,
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

-- CreateTable
CREATE TABLE "AuditClassifCode" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "source_id" TEXT NOT NULL,
    "classif_level" TEXT NOT NULL,
    "classif_code" TEXT NOT NULL,
    "version_no" INTEGER NOT NULL DEFAULT 1,
    "version_user" TEXT NOT NULL DEFAULT E'SYSTEM',
    "version_date" TIMESTAMP(3) NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RiskControlDefMapping" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "riskdef_id" TEXT,
    "control_def_id" TEXT,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "version_no" INTEGER NOT NULL DEFAULT 1,
    "version_user" TEXT NOT NULL DEFAULT E'SYSTEM',
    "version_date" TIMESTAMP(3) NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "EntityRiskMaturityDef" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "characteristic" TEXT NOT NULL,
    "sample_audit_test" TEXT NOT NULL,
    "version_no" INTEGER NOT NULL DEFAULT 1,
    "version_user" TEXT NOT NULL DEFAULT E'SYSTEM',
    "version_date" TIMESTAMP(3) NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RiskAndControlTransaction" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "name" TEXT NOT NULL,
    "from_year" INTEGER NOT NULL,
    "to_year" INTEGER NOT NULL,
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

-- CreateTable
CREATE TABLE "RiskLikelihoodDef" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "risk_score" DECIMAL(65,30) NOT NULL,
    "risk_control_id" TEXT NOT NULL,
    "descriptor" TEXT NOT NULL,
    "narration" TEXT NOT NULL,
    "version_no" INTEGER NOT NULL DEFAULT 1,
    "version_user" TEXT NOT NULL DEFAULT E'SYSTEM',
    "version_date" TIMESTAMP(3) NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "EntityRiskImpactDef" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "score" DECIMAL(65,30) NOT NULL,
    "descriptor" TEXT NOT NULL,
    "risk_control_id" TEXT NOT NULL,
    "version_no" INTEGER NOT NULL DEFAULT 1,
    "version_user" TEXT NOT NULL DEFAULT E'SYSTEM',
    "version_date" TIMESTAMP(3) NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RiskConsequenceDefMapping" (
    "id" TEXT NOT NULL,
    "narration" TEXT NOT NULL,
    "entity_risk_imapct_id" TEXT NOT NULL,
    "risk_consequence_id" TEXT NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RiskConsequenceCategoryDef" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "sno" INTEGER NOT NULL,
    "category" TEXT NOT NULL,
    "version_no" INTEGER NOT NULL DEFAULT 1,
    "version_user" TEXT NOT NULL DEFAULT E'SYSTEM',
    "version_date" TIMESTAMP(3) NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ControlScoreConfigDef" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "range_start" DECIMAL(65,30),
    "range_end" DECIMAL(65,30),
    "no_of_slabs" INTEGER,
    "risk_control_id" TEXT NOT NULL,
    "version_no" INTEGER NOT NULL DEFAULT 1,
    "version_user" TEXT NOT NULL DEFAULT E'SYSTEM',
    "version_date" TIMESTAMP(3) NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ControlScoreDef" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "slab_no" INTEGER NOT NULL,
    "start_range" DECIMAL(65,30) NOT NULL,
    "end_range" DECIMAL(65,30) NOT NULL,
    "descriptor" TEXT NOT NULL,
    "interpretation" TEXT NOT NULL,
    "testing_required" TEXT NOT NULL,
    "control_config_id" TEXT NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TransactionRiskRanking" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "sno" TEXT NOT NULL,
    "applicability_from" INTEGER NOT NULL,
    "applicability_to" INTEGER NOT NULL,
    "start_range" INTEGER NOT NULL,
    "end_range" INTEGER NOT NULL,
    "no_of_slabs" INTEGER NOT NULL,
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

-- CreateTable
CREATE TABLE "RiskScoreDef" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "period" TEXT,
    "no_of_slabs" DECIMAL(65,30) NOT NULL,
    "start_range" DECIMAL(65,30) NOT NULL,
    "end_range" DECIMAL(65,30) NOT NULL,
    "risk_score_id" TEXT NOT NULL,
    "version_no" INTEGER NOT NULL DEFAULT 1,
    "version_user" TEXT NOT NULL DEFAULT E'SYSTEM',
    "version_date" TIMESTAMP(3) NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RiskScoreDefDetail" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "slab_no" INTEGER NOT NULL,
    "start_range" DECIMAL(65,30) NOT NULL,
    "end_range" DECIMAL(65,30) NOT NULL,
    "descriptor" TEXT NOT NULL,
    "colour" TEXT NOT NULL,
    "audit_timing" TEXT NOT NULL,
    "audit_frequency" INTEGER NOT NULL DEFAULT 0,
    "version_no" INTEGER NOT NULL DEFAULT 1,
    "version_user" TEXT NOT NULL DEFAULT E'SYSTEM',
    "version_date" TIMESTAMP(3) NOT NULL,
    "risk_score_def_id" TEXT NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RiskCriteriaDef" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "sno" INTEGER NOT NULL,
    "criteria" TEXT NOT NULL,
    "weightage" DECIMAL(65,30) NOT NULL,
    "risk_score_id" TEXT NOT NULL,
    "version_no" INTEGER NOT NULL DEFAULT 1,
    "version_user" TEXT NOT NULL DEFAULT E'SYSTEM',
    "version_date" TIMESTAMP(3) NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RiskScoreDefCriteriaMapping" (
    "id" TEXT NOT NULL,
    "risk_criteria_id" TEXT NOT NULL,
    "risk_score" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "version_no" INTEGER NOT NULL DEFAULT 1,
    "version_user" TEXT NOT NULL DEFAULT E'SYSTEM',
    "version_date" TIMESTAMP(3) NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RiskEvaluationDef" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "descriptor" TEXT NOT NULL,
    "colour_code" TEXT NOT NULL,
    "risk_score" DECIMAL(65,30) NOT NULL,
    "interpretation_req_action" TEXT NOT NULL,
    "risk_score_id" TEXT NOT NULL,
    "risk_impact_id" TEXT NOT NULL,
    "risk_control_id" TEXT NOT NULL,
    "version_no" INTEGER NOT NULL DEFAULT 1,
    "version_user" TEXT NOT NULL DEFAULT E'SYSTEM',
    "version_date" TIMESTAMP(3) NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "FileNumberConf" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "period_start" TIMESTAMP(3),
    "period_end" TIMESTAMP(3),
    "no_of_components" DECIMAL(65,30) NOT NULL,
    "delimeter" TEXT NOT NULL,
    "version_no" INTEGER NOT NULL DEFAULT 1,
    "version_user" TEXT NOT NULL DEFAULT E'SYSTEM',
    "version_date" TIMESTAMP(3) NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "FileNumberComponentDef" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "sno" INTEGER NOT NULL,
    "component" TEXT NOT NULL,
    "component_size" INTEGER NOT NULL,
    "component_type" TEXT NOT NULL,
    "filenumber_config_id" TEXT NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AuditOpinionGuidelineConf" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "ref" TEXT NOT NULL,
    "classification" TEXT NOT NULL,
    "audit_objective_id" TEXT,
    "no_of_slabs" INTEGER NOT NULL,
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

-- CreateTable
CREATE TABLE "AuditOpinionGuidelineConfDetail" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "slab_no" INTEGER NOT NULL,
    "txn_fail_percent_start" DECIMAL(65,30) NOT NULL,
    "txn_fail_percent_end" DECIMAL(65,30) NOT NULL,
    "conclusion_opinion" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "guideline_conf_id" TEXT NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AuditOpinionClassifCode" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "source_id" TEXT NOT NULL,
    "classif_level" TEXT NOT NULL,
    "classif_code" TEXT NOT NULL,
    "version_no" INTEGER NOT NULL DEFAULT 1,
    "version_user" TEXT NOT NULL DEFAULT E'SYSTEM',
    "version_date" TIMESTAMP(3) NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "FollowUpAuditConf" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "ref" TEXT NOT NULL,
    "treatment_of_followup_audit" TEXT NOT NULL,
    "grouping_of_findigs" TEXT NOT NULL,
    "placemnt_od_identifier" TEXT NOT NULL,
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

-- CreateTable
CREATE TABLE "KeyStakeHolder" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "name" TEXT NOT NULL,
    "ref" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "category" TEXT NOT NULL,
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

-- CreateTable
CREATE TABLE "MDAProfileDef" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "mda_code" TEXT,
    "office_code" TEXT,
    "mda" TEXT NOT NULL,
    "auditable_area" TEXT NOT NULL,
    "auditable_area_code" TEXT NOT NULL,
    "auditable_level_id" TEXT NOT NULL,
    "from" INTEGER NOT NULL,
    "to" INTEGER,
    "applicalble_subsequent_level" BOOLEAN NOT NULL DEFAULT false,
    "purpose_mission_mandate" TEXT NOT NULL,
    "key_products_services" TEXT NOT NULL,
    "is_organization_coa" BOOLEAN NOT NULL DEFAULT false,
    "it_in_use" TEXT NOT NULL,
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

-- CreateTable
CREATE TABLE "MDAAddress" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "mda_profile_id" TEXT NOT NULL,
    "address_id" TEXT,
    "is_primary" BOOLEAN NOT NULL DEFAULT false,
    "version_no" INTEGER NOT NULL DEFAULT 1,
    "version_user" TEXT NOT NULL DEFAULT E'SYSTEM',
    "version_date" TIMESTAMP(3) NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MDAAuditableAreaDetail" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "auditable_area" TEXT NOT NULL,
    "auditable_area_code" TEXT NOT NULL,
    "auditable_level_id" TEXT NOT NULL,
    "parent_id" TEXT,
    "auditable_area_id" TEXT NOT NULL,
    "mda_profile_id" TEXT NOT NULL,
    "version_no" INTEGER NOT NULL DEFAULT 1,
    "version_user" TEXT NOT NULL DEFAULT E'SYSTEM',
    "version_date" TIMESTAMP(3) NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MDAKeyStrategicObjective" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "objective" TEXT NOT NULL,
    "summary_of_strategies" TEXT NOT NULL,
    "mda_profile_id" TEXT NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MDAInternalKeyStakeHolder" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "code" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "mda_profile_id" TEXT NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MDAExternalKeyStakeHolder" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "code" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "mda_profile_id" TEXT NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MDAPoliciesProcessesOtherInfo" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "nature_of_document" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "document_id" TEXT NOT NULL,
    "document_link" TEXT,
    "date_of_upload" TIMESTAMP(3) NOT NULL,
    "mda_profile_id" TEXT NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MDAAuditReport" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "file_id" TEXT NOT NULL,
    "file_ref_no" TEXT NOT NULL,
    "audit_name" TEXT NOT NULL,
    "audit_classification" TEXT NOT NULL,
    "audit_type" TEXT NOT NULL,
    "year_of_audit" TEXT NOT NULL,
    "mda_profile_id" TEXT NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MDAManagementContact" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "employee_id" TEXT NOT NULL,
    "mda_profile_id" TEXT NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AuditHierarchyMDAMapping" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "mda_profile_id" TEXT,
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

-- CreateTable
CREATE TABLE "MDAAuditHierarchyCode" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "source_id" TEXT NOT NULL,
    "classif_level" TEXT NOT NULL,
    "classif_code" TEXT NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ResourcePlanConfig" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
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

-- CreateTable
CREATE TABLE "ResourcePlanConfigDetail" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "source_id" TEXT NOT NULL,
    "ref" TEXT NOT NULL,
    "grade" TEXT NOT NULL,
    "vacation" DECIMAL(65,30),
    "holidays" DECIMAL(65,30),
    "sick_leave" DECIMAL(65,30),
    "other_leaves" DECIMAL(65,30),
    "version_no" INTEGER NOT NULL DEFAULT 1,
    "version_user" TEXT NOT NULL DEFAULT E'SYSTEM',
    "version_date" TIMESTAMP(3) NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "LeaveDetail" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "config_id" TEXT NOT NULL,
    "order" INTEGER,
    "leave_type" TEXT NOT NULL,
    "no_of_days" DECIMAL(65,30) NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ActivityDetail" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "source_id" TEXT NOT NULL,
    "activity" TEXT NOT NULL,
    "no_of_days" DECIMAL(65,30) NOT NULL,
    "version_no" INTEGER NOT NULL DEFAULT 1,
    "version_user" TEXT NOT NULL DEFAULT E'SYSTEM',
    "version_date" TIMESTAMP(3) NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "LocationAllowanceMapping" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "from" INTEGER NOT NULL,
    "to" INTEGER,
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

-- CreateTable
CREATE TABLE "LocationAllowanceMappingDetail" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "ref" TEXT NOT NULL,
    "grade" TEXT NOT NULL,
    "amount" DECIMAL(65,30) NOT NULL,
    "mapping_id" TEXT NOT NULL,
    "version_no" INTEGER NOT NULL DEFAULT 1,
    "version_user" TEXT NOT NULL DEFAULT E'SYSTEM',
    "version_date" TIMESTAMP(3) NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RatecardConfig" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "from" INTEGER NOT NULL,
    "to" INTEGER,
    "expense_head" TEXT NOT NULL,
    "unit" TEXT NOT NULL,
    "rate_per_unit" DECIMAL(65,30) NOT NULL,
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

-- CreateTable
CREATE TABLE "CalendarEvent" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "event_category" TEXT NOT NULL DEFAULT E'ACTIVITY',
    "event_type" TEXT NOT NULL,
    "source_ref" TEXT,
    "from" TIMESTAMP(3) NOT NULL,
    "to" TIMESTAMP(3) NOT NULL,
    "no_of_days" DECIMAL(65,30),
    "exceeded_days" DECIMAL(65,30) NOT NULL DEFAULT 0,
    "description" TEXT,
    "user_id" TEXT,
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

-- CreateTable
CREATE TABLE "HolidayMaster" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "name" TEXT NOT NULL,
    "ref" TEXT NOT NULL,
    "fin_year" TEXT NOT NULL,
    "from" TIMESTAMP(3) NOT NULL,
    "to" TIMESTAMP(3) NOT NULL,
    "no_of_days" DECIMAL(65,30),
    "description" TEXT,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "version_no" INTEGER NOT NULL DEFAULT 1,
    "version_user" TEXT NOT NULL DEFAULT E'SYSTEM',
    "version_date" TIMESTAMP(3) NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "WeekendConf" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "days" TEXT NOT NULL DEFAULT E'SATURDAY,SUNDAY',
    "fin_year" TEXT NOT NULL,
    "no_of_days" DECIMAL(65,30) NOT NULL DEFAULT 2,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "version_no" INTEGER NOT NULL DEFAULT 1,
    "version_user" TEXT NOT NULL DEFAULT E'SYSTEM',
    "version_date" TIMESTAMP(3) NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RiskMaturityAssessment" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "mda_profile_id" TEXT,
    "risk_maturity_category" TEXT NOT NULL,
    "ia_approach" TEXT NOT NULL,
    "reason" TEXT NOT NULL,
    "mda_ia_approach" TEXT,
    "assesment_by" TEXT,
    "period_start_year" INTEGER,
    "period_end_year" INTEGER,
    "period_id" TEXT,
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

-- CreateTable
CREATE TABLE "CharacteristicDetail" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "file_id" TEXT,
    "entity_risk_def_id" TEXT,
    "mgmt_response" TEXT NOT NULL DEFAULT E'No',
    "risk_maturity_assessment_id" TEXT NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AuditPlanSchedule" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "years_covered" INTEGER NOT NULL,
    "period_start_year" INTEGER NOT NULL,
    "period_end_year" INTEGER NOT NULL,
    "submission_target_date" TIMESTAMP(3) NOT NULL,
    "file_id" TEXT,
    "parent_id" TEXT,
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

-- CreateTable
CREATE TABLE "AuditPlanScheduleDetail" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "ref" INTEGER NOT NULL,
    "mda_profile_id" TEXT,
    "risk_maturity_assesment_id" TEXT,
    "level" TEXT NOT NULL,
    "ia_approach" TEXT NOT NULL,
    "ciau_ia_approach" TEXT,
    "planning_method" TEXT,
    "schedule_id" TEXT NOT NULL,
    "version_no" INTEGER NOT NULL DEFAULT 1,
    "version_user" TEXT NOT NULL DEFAULT E'SYSTEM',
    "version_date" TIMESTAMP(3) NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RiskAssessment" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "schedule_id" TEXT,
    "audit_schedule_id" TEXT,
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

-- CreateTable
CREATE TABLE "RiskAssessmentDetail" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "level_code" TEXT,
    "sublevel_code" TEXT,
    "auditable_area" TEXT NOT NULL,
    "mda_profile_id" TEXT NOT NULL,
    "rec_year" TEXT NOT NULL,
    "risk_score" DECIMAL(65,30) NOT NULL,
    "assessment_id" TEXT NOT NULL,
    "level_alias" TEXT,
    "risk_score_id" TEXT,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AssessmentByLevel" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "level_id" TEXT NOT NULL,
    "classif_code" TEXT NOT NULL,
    "assessment_id" TEXT NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AssessmentBySubLevel" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "level_id" TEXT NOT NULL,
    "classif_code" TEXT NOT NULL,
    "total_risk_score" DECIMAL(65,30),
    "ref" INTEGER NOT NULL,
    "level_alias" TEXT,
    "parent_id" TEXT NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RiskRankBySubLevel" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "parent_id" TEXT NOT NULL,
    "risk_type" TEXT NOT NULL,
    "weight" DECIMAL(65,30),
    "rank" DECIMAL(65,30) NOT NULL,
    "comments" TEXT,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SAP" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "from" INTEGER NOT NULL,
    "to" INTEGER NOT NULL,
    "iau_code" TEXT,
    "period_id" TEXT,
    "audit_plan_schedule_id" TEXT,
    "ref" TEXT NOT NULL,
    "can_process" BOOLEAN NOT NULL DEFAULT true,
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

-- CreateTable
CREATE TABLE "SAPItem" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "total_budget" DECIMAL(65,30),
    "total_auditor_weeks" DECIMAL(65,30),
    "planning_method" TEXT NOT NULL DEFAULT E'ARA',
    "sap_id" TEXT NOT NULL,
    "ref" TEXT NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SAPSelectionDetail" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "recommended_year" TEXT,
    "proposed_year" TEXT,
    "proposed_year_reason" TEXT,
    "proposed_year_other_reason" TEXT,
    "mda_profile_id" TEXT,
    "budget" DECIMAL(65,30) NOT NULL,
    "auditor_weeks" DECIMAL(65,30) NOT NULL,
    "classification" TEXT NOT NULL,
    "sap_item_id" TEXT NOT NULL,
    "risk_assessment_id" TEXT,
    "risk_assessment_detail_id" TEXT,
    "schedule_detail_id" TEXT,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "NRBLevelDetail" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "sap_selection_detail_id" TEXT NOT NULL,
    "level_id" TEXT NOT NULL,
    "classif_code" TEXT NOT NULL,
    "level_alias" TEXT,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AAP" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "sap_id" TEXT,
    "from" INTEGER,
    "to" INTEGER,
    "fin_year_id" TEXT NOT NULL,
    "iau_code" TEXT,
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

-- CreateTable
CREATE TABLE "AAPItem" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "aap_id" TEXT,
    "is_edited" BOOLEAN NOT NULL DEFAULT false,
    "audit_type" TEXT NOT NULL DEFAULT E'ScheduleAudit',
    "ref" TEXT NOT NULL,
    "execution_status" TEXT NOT NULL DEFAULT E'Pending',
    "version_no" INTEGER NOT NULL DEFAULT 1,
    "version_user" TEXT NOT NULL DEFAULT E'SYSTEM',
    "version_date" TIMESTAMP(3) NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AAPDetail" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "ref" TEXT NOT NULL,
    "mda_profile_def_id" TEXT,
    "aap_item_id" TEXT NOT NULL,
    "classification" TEXT,
    "scope" TEXT,
    "objective" TEXT,
    "scope_edited" BOOLEAN NOT NULL DEFAULT false,
    "is_edited" BOOLEAN NOT NULL DEFAULT false,
    "budget" DECIMAL(65,30),
    "total_auditor_weeks" DECIMAL(65,30),
    "sap_selection_detail_id" TEXT,
    "finding_id" TEXT,
    "planned" INTEGER NOT NULL DEFAULT 1,
    "version_no" INTEGER NOT NULL DEFAULT 1,
    "version_user" TEXT NOT NULL DEFAULT E'SYSTEM',
    "version_date" TIMESTAMP(3) NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AAPLevelDetail" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "aap_detail_id" TEXT NOT NULL,
    "level_id" TEXT NOT NULL,
    "classif_code" TEXT NOT NULL,
    "level_alias" TEXT,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AAPObjeciveMapping" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "is_deleted" BOOLEAN NOT NULL DEFAULT false,
    "is_edited" BOOLEAN NOT NULL DEFAULT false,
    "objective_id" TEXT,
    "assignment_id" TEXT,
    "aap_detail_id" TEXT NOT NULL,
    "guideline_openion_id" TEXT,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ScheduleMonth" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "seq" INTEGER NOT NULL,
    "month" TEXT NOT NULL,
    "aap_detail_id" TEXT NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AAPAuditor" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "admin_activity_id" TEXT,
    "designation" TEXT NOT NULL,
    "specialization" TEXT NOT NULL,
    "exp_range_start" DECIMAL(65,30) NOT NULL,
    "exp_range_end" DECIMAL(65,30),
    "aap_detail_id" TEXT,
    "resource_source" TEXT NOT NULL DEFAULT E'Within MDA',
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AAPAuditorDetail" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "aap_auditor_id" TEXT NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "name" TEXT NOT NULL,
    "user_id" TEXT,
    "role" TEXT NOT NULL,
    "dept_org" TEXT NOT NULL,
    "specialization" TEXT NOT NULL,
    "days_assigned" DECIMAL(65,30) NOT NULL,
    "available_days" DECIMAL(65,30),
    "prof_charges" DECIMAL(65,30) NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AAPAuditorDetailTxn" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "replaced_by" TEXT,
    "is_processed" BOOLEAN NOT NULL DEFAULT false,
    "version_date" TIMESTAMP(3) NOT NULL,
    "detail_id" TEXT,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AuditorDayExpenseDetail" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "planning" TEXT NOT NULL,
    "field_work" TEXT NOT NULL,
    "reporting" TEXT NOT NULL,
    "review" TEXT NOT NULL,
    "aap_auditor_detail_id" TEXT,
    "fin_resource_id" TEXT,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AAPFinancialResource" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "aap_detail_id" TEXT,
    "admin_activity_id" TEXT,
    "rate_card_id" TEXT,
    "ref" INTEGER,
    "expense_head" TEXT,
    "quantity" DECIMAL(65,30) NOT NULL,
    "cost" DECIMAL(65,30) NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AAPAdminActivity" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "category" TEXT,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "start_date" TIMESTAMP(3) NOT NULL,
    "end_date" TIMESTAMP(3) NOT NULL,
    "aap_item_details_id" TEXT NOT NULL,
    "version_no" INTEGER NOT NULL DEFAULT 1,
    "version_user" TEXT NOT NULL DEFAULT E'SYSTEM',
    "version_date" TIMESTAMP(3) NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AAPSubAssignment" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "app_item_id" TEXT,
    "ref" TEXT NOT NULL,
    "followup_assignment_ref" TEXT,
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

-- CreateTable
CREATE TABLE "AAPSubAssignmentDetail" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "assignment_id" TEXT NOT NULL,
    "aap_detail_id" TEXT,
    "scope" TEXT,
    "version_no" INTEGER NOT NULL DEFAULT 1,
    "version_user" TEXT NOT NULL DEFAULT E'SYSTEM',
    "version_date" TIMESTAMP(3) NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AAPAdminActivityExec" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "app_item_id" TEXT,
    "app_adm_activity_id" TEXT,
    "remarks" TEXT,
    "exec_status" TEXT NOT NULL,
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

-- CreateTable
CREATE TABLE "AssignmentActivity" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "audit_type" TEXT[],
    "name" TEXT NOT NULL,
    "order" INTEGER NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "COIDeclaration" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "declarant" TEXT NOT NULL,
    "conflict" TEXT,
    "description" TEXT NOT NULL,
    "proposed_management" TEXT NOT NULL,
    "ref" TEXT NOT NULL,
    "assignment_id" TEXT,
    "aap_detail_id" TEXT,
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

-- CreateTable
CREATE TABLE "AuditCommencementForm" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "audit_type" TEXT NOT NULL,
    "name" TEXT,
    "comments" TEXT NOT NULL,
    "vote" TEXT,
    "scope" TEXT,
    "limitation_of_scope" TEXT,
    "file_number" TEXT,
    "year_of_audit" TEXT,
    "audit_authority" TEXT DEFAULT E'Approved Annual Audit Plan',
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

-- CreateTable
CREATE TABLE "AdhocConsultingCommencementDetail" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "introduction" TEXT NOT NULL,
    "background" TEXT NOT NULL,
    "scope" TEXT NOT NULL,
    "limitation_of_scope" TEXT,
    "support_expected" TEXT NOT NULL,
    "management_expectation" TEXT NOT NULL,
    "commencement_id" TEXT,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "FollowUpCommencementDetail" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "followup_audit_no" TEXT NOT NULL,
    "sub_assignment_ref" TEXT NOT NULL,
    "followup_assignment_ref" TEXT NOT NULL,
    "scope" TEXT NOT NULL,
    "limitation_of_scope" TEXT,
    "scope_doc" TEXT,
    "commencement_id" TEXT,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AuditDatesAndBudget" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "start_date" TIMESTAMP(3),
    "end_date" TIMESTAMP(3),
    "time_budget" DECIMAL(65,30) NOT NULL,
    "funding_source" TEXT NOT NULL,
    "estimated_budget" DECIMAL(65,30) NOT NULL,
    "other_reason" TEXT,
    "commencement_id" TEXT,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CommencementObjeciveMapping" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "objective_id" TEXT,
    "commencement_id" TEXT,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CommencementDetail" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "aap_detail_id" TEXT,
    "commencement_id" TEXT NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AuditDate" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "order" DECIMAL(65,30) NOT NULL,
    "description" TEXT,
    "start_date" TIMESTAMP(3) NOT NULL,
    "end_date" TIMESTAMP(3) NOT NULL,
    "duration" DECIMAL(65,30) NOT NULL,
    "commencement_id" TEXT NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ResourceAndBudget" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "status" TEXT NOT NULL DEFAULT E'Available',
    "auditable_area" TEXT NOT NULL,
    "aap_auditor_id" TEXT,
    "commencement_id" TEXT NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ReportDistribution" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "department" TEXT NOT NULL,
    "designation" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "user_id" TEXT,
    "email" TEXT NOT NULL,
    "commencement_id" TEXT NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RequestList" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "commencement_id" TEXT NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "DocumentDetail" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "ref" INTEGER NOT NULL,
    "src_ref" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "request_id" TEXT,
    "aap_detail_id" TEXT[],

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RequestListResponse" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "aap_detail_id" TEXT,
    "request_list_id" TEXT,
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

-- CreateTable
CREATE TABLE "RequestListResponseDetail" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "remarks" TEXT,
    "document_id" TEXT NOT NULL,
    "uploaded_date" TIMESTAMP(3),
    "document_detail_id" TEXT,
    "req_list_resp_id" TEXT NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SummaryAuditableArea" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "commencement_detail_id" TEXT,
    "mda_profile_id" TEXT,
    "file_number" TEXT NOT NULL,
    "sub_assignment_name" TEXT NOT NULL,
    "audit_period" TEXT NOT NULL,
    "purpose" TEXT NOT NULL,
    "governance_process" TEXT NOT NULL,
    "risk_management_process" TEXT NOT NULL,
    "control_env" TEXT NOT NULL,
    "financial_arrangements" TEXT NOT NULL,
    "fraud_consideration" TEXT NOT NULL,
    "audit_criteria" TEXT NOT NULL,
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

-- CreateTable
CREATE TABLE "SummaryAuditSubject" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "commencement_detail_id" TEXT,
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

-- CreateTable
CREATE TABLE "SummaryAuditSubjectDetail" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "summary_id" TEXT NOT NULL,
    "risk_id" TEXT,
    "control_id" TEXT,
    "ref" INTEGER,
    "document_id" TEXT,
    "version_no" INTEGER NOT NULL DEFAULT 1,
    "version_user" TEXT NOT NULL DEFAULT E'SYSTEM',
    "version_date" TIMESTAMP(3) NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SummaryAuditSubjectCode" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "level_id" TEXT NOT NULL,
    "level_code" TEXT NOT NULL,
    "summary_audit_subject_detail_id" TEXT NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AuditScope" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "commencement_detail_id" TEXT,
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

-- CreateTable
CREATE TABLE "AuditScopeDetail" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "risk_id" TEXT,
    "control_id" TEXT,
    "objective_id" TEXT,
    "scope_id" TEXT,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "InherentRisk" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "commencement_detail_id" TEXT,
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

-- CreateTable
CREATE TABLE "InherentRiskDetail" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "inherent_risk_id" TEXT NOT NULL,
    "audit_scope_detail_id" TEXT,
    "likelihood" DECIMAL(65,30) NOT NULL,
    "likelihood_reason" TEXT NOT NULL,
    "impact" DECIMAL(65,30) NOT NULL,
    "impact_reason" TEXT NOT NULL,
    "total_score" DECIMAL(65,30) NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ControlAssessment" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "commencement_detail_id" TEXT,
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

-- CreateTable
CREATE TABLE "ControlAssessmentDetail" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "assessment_id" TEXT NOT NULL,
    "response" TEXT NOT NULL,
    "alternate_control" TEXT,
    "inherent_risk_id" TEXT,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ResidualRiskAssessment" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "commencement_detail_id" TEXT,
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

-- CreateTable
CREATE TABLE "ResidualRiskAssessmentDetail" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "assessment_id" TEXT NOT NULL,
    "adequacy" TEXT NOT NULL,
    "effectiveness" TEXT NOT NULL,
    "adequacy_reason" TEXT NOT NULL,
    "effectiveness_reason" TEXT NOT NULL,
    "likelihood" DECIMAL(65,30) NOT NULL,
    "impact" DECIMAL(65,30) NOT NULL,
    "likelihood_reason" TEXT NOT NULL,
    "impact_reason" TEXT NOT NULL,
    "total_score" DECIMAL(65,30) NOT NULL,
    "control_score" DECIMAL(65,30) NOT NULL,
    "control_assessment_detail_id" TEXT,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RiskAssessmentConclusion" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "commencement_detail_id" TEXT,
    "audit_way_forward" TEXT,
    "remarks" TEXT,
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

-- CreateTable
CREATE TABLE "RiskAssessmentConclusionDetail" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "risk_assessment_conclusion_id" TEXT NOT NULL,
    "risk_id" TEXT,
    "control_id" TEXT,
    "control_score" DECIMAL(65,30) NOT NULL,
    "audit_method" TEXT NOT NULL,
    "audit_decision" TEXT,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RiskAssessmentConclusionCode" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "level_id" TEXT NOT NULL,
    "level_code" TEXT NOT NULL,
    "risk_assessment_con_id" TEXT NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AuditAssignmentStatus" (
    "id" TEXT NOT NULL,
    "state" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "aap_detail_id" TEXT,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AuditAssignmentPlan" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "audit_commencement_id" TEXT,
    "background_info" TEXT,
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

-- CreateTable
CREATE TABLE "ManagementContact" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "sno" INTEGER NOT NULL,
    "auditable_area" TEXT NOT NULL,
    "designition" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "phone" TEXT NOT NULL,
    "audit_assignment_plan_id" TEXT NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AuditTeamComposition" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "sno" INTEGER NOT NULL,
    "auditable_area" TEXT NOT NULL,
    "role" TEXT NOT NULL,
    "auditor_name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "phone" TEXT NOT NULL,
    "audit_assignment_plan_id" TEXT NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TimeFinResource" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "sno" INTEGER NOT NULL,
    "phase" TEXT NOT NULL,
    "days" DECIMAL(65,30) NOT NULL,
    "resource_cost" DECIMAL(65,30) NOT NULL,
    "ope_cost" DECIMAL(65,30) NOT NULL,
    "tottal_cost" DECIMAL(65,30) NOT NULL,
    "target_date" TIMESTAMP(3) NOT NULL,
    "audit_assignment_plan_id" TEXT NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AuditProgram" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "audit_commencement_id" TEXT,
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

-- CreateTable
CREATE TABLE "AuditProgramDetail" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "sno" INTEGER NOT NULL DEFAULT 1,
    "ref" TEXT NOT NULL,
    "audit_program_id" TEXT NOT NULL,
    "aap_detail_id" TEXT,
    "objective_id" TEXT,
    "control_id" TEXT,
    "procedure_id" TEXT,
    "finding_id" TEXT,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TestAssignementDetail" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "test_id" TEXT,
    "auditor_name" TEXT,
    "auditor_id" TEXT NOT NULL,
    "start_date" TIMESTAMP(3) NOT NULL,
    "end_date" TIMESTAMP(3) NOT NULL,
    "program_detail_id" TEXT NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AuditTestWorksheet" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "commencement_detail_id" TEXT,
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

-- CreateTable
CREATE TABLE "AuditTestWorksheetDetail" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "sno" INTEGER NOT NULL DEFAULT 1,
    "worksheet_id" TEXT NOT NULL,
    "type_of_test" TEXT NOT NULL,
    "population_size" DECIMAL(65,30) NOT NULL,
    "sample_size" DECIMAL(65,30) NOT NULL,
    "information_source" TEXT NOT NULL,
    "audit_program_id" TEXT,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AuditTestResult" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "commencement_detail_id" TEXT,
    "type_of_test" TEXT NOT NULL,
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

-- CreateTable
CREATE TABLE "AuditTestResultDetail" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "sno" INTEGER NOT NULL DEFAULT 1,
    "audit_test_seq" TEXT NOT NULL,
    "no_of_txns" INTEGER NOT NULL,
    "txn_passed" INTEGER NOT NULL,
    "txn_failed" INTEGER NOT NULL,
    "result_summary" TEXT NOT NULL,
    "test_conclusion" TEXT NOT NULL,
    "date" TIMESTAMP(3),
    "status" TEXT NOT NULL DEFAULT E'Not Done',
    "document_id" TEXT,
    "other_document_id" TEXT,
    "audit_test_result_id" TEXT NOT NULL,
    "test_assignment_detail_id" TEXT,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AuditFinding" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "commencement_detail_id" TEXT,
    "recurrent_finding" BOOLEAN NOT NULL DEFAULT false,
    "parent_finding_id" TEXT,
    "finding_status" TEXT,
    "finding_remarks" TEXT,
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

-- CreateTable
CREATE TABLE "AuditFindingObservation" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "audit_program_detail_id" TEXT,
    "audit_finding_id" TEXT NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AuditFindingObservationDetail" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "status" TEXT,
    "risk_rating" TEXT,
    "post_fwp_obs" TEXT,
    "audit_finding_observation_id" TEXT NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AuditFindingDetail" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "audit_finding_id" TEXT NOT NULL,
    "criteria_observation" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "implication" TEXT NOT NULL,
    "cause" TEXT NOT NULL,
    "mngmt_response" TEXT,
    "mngmt_response_doc_id" TEXT,
    "category" TEXT,
    "risk_rating" TEXT,
    "followup_audit_approach" TEXT,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Recommendation" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "sno" INTEGER NOT NULL DEFAULT 1,
    "recommendation" TEXT NOT NULL,
    "status" TEXT,
    "audit_finding_detail_id" TEXT NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MngmtActionPlan" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "sno" INTEGER NOT NULL DEFAULT 1,
    "ref" TEXT NOT NULL,
    "rr_numbers" INTEGER[],
    "action" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "lead_person" TEXT NOT NULL,
    "support_person" TEXT NOT NULL,
    "start_date" TIMESTAMP(3) NOT NULL,
    "end_date" TIMESTAMP(3) NOT NULL,
    "status" TEXT,
    "document_id" TEXT,
    "audit_finding_detail_id" TEXT NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AuditMeeting" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "commencement_from_id" TEXT,
    "location" TEXT NOT NULL,
    "proposed_date" TIMESTAMP(3) NOT NULL,
    "actual_date" TIMESTAMP(3) NOT NULL,
    "documentation" TEXT NOT NULL,
    "meeting_type" TEXT NOT NULL,
    "reason" TEXT,
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

-- CreateTable
CREATE TABLE "AuditMeetingDetail" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "audit_meeting_id" TEXT NOT NULL,
    "commencement_detail_id" TEXT,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AuditMeetingDocument" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "audit_meeting_id" TEXT NOT NULL,
    "sno" INTEGER NOT NULL,
    "document_name" TEXT NOT NULL,
    "document_type" TEXT NOT NULL,
    "document_id" TEXT NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MeetingPoint" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "sno" DECIMAL(65,30) NOT NULL DEFAULT 1,
    "item" TEXT NOT NULL,
    "lead_agency" TEXT NOT NULL,
    "lead_person" TEXT NOT NULL,
    "audit_meeting_id" TEXT NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Participant" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "name" TEXT NOT NULL,
    "designation" TEXT NOT NULL,
    "institution" TEXT NOT NULL,
    "audit_meeting_id" TEXT NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ReportActual" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "commencement_form_id" TEXT,
    "auditor_id" TEXT,
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

-- CreateTable
CREATE TABLE "ReportActualDetail" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "sno" INTEGER NOT NULL DEFAULT 1,
    "phase" TEXT NOT NULL,
    "days" DECIMAL(65,30) NOT NULL,
    "resource_cost" DECIMAL(65,30) NOT NULL,
    "ope_cost" DECIMAL(65,30) NOT NULL,
    "total_cost" DECIMAL(65,30) NOT NULL,
    "completion_date" TIMESTAMP(3),
    "report_actual_id" TEXT NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AuditClosureForm" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "commencement_form_id" TEXT,
    "area_of_exposure" TEXT NOT NULL,
    "sugesstion_for_auditor" TEXT NOT NULL,
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

-- CreateTable
CREATE TABLE "AuditWorkingPaper" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "sno" INTEGER NOT NULL DEFAULT 1,
    "question" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "remarks" TEXT,
    "audit_closure_form_id" TEXT NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ResultOfAssignment" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "sno" INTEGER NOT NULL DEFAULT 1,
    "item" TEXT NOT NULL,
    "value" TEXT NOT NULL,
    "audit_closure_form_id" TEXT NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AssignmentInfo" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "sno" INTEGER NOT NULL DEFAULT 1,
    "item" TEXT NOT NULL,
    "approved_standard" TEXT NOT NULL,
    "actual" TEXT NOT NULL,
    "variance" TEXT NOT NULL,
    "audit_closure_form_id" TEXT NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "EngagementForm" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "commencement_form_id" TEXT,
    "other_reason" TEXT,
    "category" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "report_doc" TEXT NOT NULL,
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

-- CreateTable
CREATE TABLE "EngagementFormDetail" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "engagemnt_form_id" TEXT NOT NULL,
    "commencement_detail_id" TEXT,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AuditRegister" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "commencement_form_id" TEXT,
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

-- CreateTable
CREATE TABLE "AuditRegisterFinding" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "audit_register_id" TEXT NOT NULL,
    "audit_finding_id" TEXT,
    "finding_status" TEXT,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AuditRegisterDetail" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "register_finding_id" TEXT NOT NULL,
    "mngmt_action_plan_id" TEXT,
    "date_of_task" TIMESTAMP(3),
    "mngmt_action_status" TEXT,
    "description" TEXT,
    "remarks" TEXT,
    "auditor_status" TEXT,
    "finding_status" TEXT,
    "reported_by" TEXT,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SupportingDoc" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "sno" INTEGER NOT NULL DEFAULT 1,
    "name" TEXT NOT NULL,
    "category" TEXT NOT NULL,
    "document_id" TEXT NOT NULL,
    "document_name" TEXT,
    "audit_register_detail_id" TEXT NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "IAUDevision" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "code" TEXT NOT NULL,
    "full_code" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "alias" TEXT NOT NULL,
    "iau_office_code" TEXT,
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

-- CreateTable
CREATE TABLE "IAUDevisionDetail" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "is_deleted" BOOLEAN NOT NULL DEFAULT false,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "mda_profile_id" TEXT,
    "iau_devision_id" TEXT NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Report" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "report_type" TEXT NOT NULL DEFAULT E'Draft Report',
    "submission_date" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "approved_date" TIMESTAMP(3),
    "commencement_detail_id" TEXT,
    "ref" TEXT NOT NULL,
    "status" TEXT NOT NULL DEFAULT E'Draft',
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "is_latest" BOOLEAN NOT NULL DEFAULT false,
    "is_effective" BOOLEAN NOT NULL DEFAULT false,
    "effective_from" TIMESTAMP(3),
    "report_version" INTEGER NOT NULL DEFAULT 1,
    "version_no" INTEGER NOT NULL DEFAULT 1,
    "version_user" TEXT NOT NULL DEFAULT E'SYSTEM',
    "version_date" TIMESTAMP(3) NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ReportItem" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "sno" INTEGER NOT NULL,
    "item" TEXT NOT NULL,
    "document_id" TEXT,
    "report_id" TEXT NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "DraftReport" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "commencement_detail_id" TEXT,
    "report_detail" JSONB,
    "desc_ack" JSONB,
    "exec_summary" JSONB,
    "audit_background" JSONB,
    "audit_scope" JSONB,
    "process_methodology" JSONB,
    "audit_finding" JSONB,
    "conc_openion" JSONB,
    "closing_meeting" JSONB,
    "version_no" INTEGER NOT NULL DEFAULT 1,
    "version_user" TEXT NOT NULL DEFAULT E'SYSTEM',
    "version_date" TIMESTAMP(3) NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SeqConf" (
    "tenant_id" TEXT,
    "type" TEXT NOT NULL,
    "key_template" TEXT NOT NULL,
    "value_template" TEXT NOT NULL,
    "input_fields" TEXT NOT NULL,
    "dynamic_fields" TEXT NOT NULL,
    "start_value" INTEGER NOT NULL,
    "seq_size" INTEGER NOT NULL,
    "version_no" INTEGER NOT NULL DEFAULT 1,
    "version_user" TEXT NOT NULL DEFAULT E'SYSTEM',
    "version_date" TIMESTAMP(3) NOT NULL
);

-- CreateTable
CREATE TABLE "SeqCode" (
    "tenant_id" TEXT,
    "type" TEXT NOT NULL,
    "key" TEXT NOT NULL,
    "next_value" INTEGER NOT NULL,
    "version_no" INTEGER NOT NULL DEFAULT 1,
    "version_user" TEXT NOT NULL DEFAULT E'SYSTEM',
    "version_date" TIMESTAMP(3) NOT NULL
);

-- CreateTable
CREATE TABLE "Identity" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "source_id" TEXT NOT NULL,
    "ref_key" TEXT NOT NULL,
    "version_no" INTEGER NOT NULL DEFAULT 1,
    "version_user" TEXT NOT NULL DEFAULT E'SYSTEM',
    "version_date" TIMESTAMP(3) NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Address" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT,
    "line1" TEXT NOT NULL,
    "line2" TEXT NOT NULL,
    "line3" TEXT NOT NULL,
    "pin_code" TEXT NOT NULL,
    "country" TEXT NOT NULL,
    "state" TEXT NOT NULL,
    "district" TEXT NOT NULL,
    "sub_district" TEXT NOT NULL,
    "village" TEXT NOT NULL,
    "panchayat" TEXT NOT NULL,
    "tier_id" TEXT,
    "is_active" BOOLEAN NOT NULL,
    "version_no" INTEGER NOT NULL DEFAULT 1,
    "version_user" TEXT NOT NULL DEFAULT E'SYSTEM',
    "version_date" TIMESTAMP(3) NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "AuditHierarchyLevel.name_unique" ON "AuditHierarchyLevel"("name");

-- CreateIndex
CREATE UNIQUE INDEX "AuditHierarchyLevel.parent_id_unique" ON "AuditHierarchyLevel"("parent_id");

-- CreateIndex
CREATE UNIQUE INDEX "AuditHierarchyLevel.parent_id_name_unique" ON "AuditHierarchyLevel"("parent_id", "name");

-- CreateIndex
CREATE UNIQUE INDEX "AuditHierarchyCode.path_unique" ON "AuditHierarchyCode"("path");

-- CreateIndex
CREATE UNIQUE INDEX "AuditHierarchyCode.parent_id_name_unique" ON "AuditHierarchyCode"("parent_id", "name");

-- CreateIndex
CREATE UNIQUE INDEX "AuditProgramStructure.name_unique" ON "AuditProgramStructure"("name");

-- CreateIndex
CREATE UNIQUE INDEX "AuditProgramStructure.parent_id_unique" ON "AuditProgramStructure"("parent_id");

-- CreateIndex
CREATE UNIQUE INDEX "AuditProgramStructure.parent_id_name_unique" ON "AuditProgramStructure"("parent_id", "name");

-- CreateIndex
CREATE UNIQUE INDEX "AuditPlanSchedule.parent_id_unique" ON "AuditPlanSchedule"("parent_id");

-- CreateIndex
CREATE UNIQUE INDEX "RiskAssessmentDetail.level_code_sublevel_code_mda_profile_id_rec_year_risk_score_assessment_id_unique" ON "RiskAssessmentDetail"("level_code", "sublevel_code", "mda_profile_id", "rec_year", "risk_score");

-- CreateIndex
CREATE UNIQUE INDEX "AuditAssignmentStatus.aap_detail_id_unique" ON "AuditAssignmentStatus"("aap_detail_id");

-- CreateIndex
CREATE UNIQUE INDEX "SeqConf.type_unique" ON "SeqConf"("type");

-- CreateIndex
CREATE UNIQUE INDEX "SeqCode.type_key_unique" ON "SeqCode"("type", "key");

-- AddForeignKey
ALTER TABLE "AuditHierarchyLevel" ADD FOREIGN KEY("parent_id")REFERENCES "AuditHierarchyLevel"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditHierarchyDetailConf" ADD FOREIGN KEY("parent_id")REFERENCES "AuditHierarchyDetailConf"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditHierarchyCode" ADD FOREIGN KEY("audit_level_id")REFERENCES "AuditHierarchyLevel"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditHierarchyCode" ADD FOREIGN KEY("conf_id")REFERENCES "AuditHierarchyDetailConf"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditHierarchyCode" ADD FOREIGN KEY("parent_id")REFERENCES "AuditHierarchyCode"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditHierarchyCodeTxn" ADD FOREIGN KEY("conf_id")REFERENCES "AuditHierarchyDetailConf"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditHierarchyCodeTxn" ADD FOREIGN KEY("code_id")REFERENCES "AuditHierarchyCode"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditProgramStructure" ADD FOREIGN KEY("parent_id")REFERENCES "AuditProgramStructure"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RiskDefAuditObjectiveDefMapping" ADD FOREIGN KEY("risk_id")REFERENCES "RiskDef"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RiskDefAuditObjectiveDefMapping" ADD FOREIGN KEY("control_id")REFERENCES "ControlDef"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RiskDefAuditObjectiveDefMapping" ADD FOREIGN KEY("objective_id")REFERENCES "AuditObjectiveDef"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ObjectiveAuditClassifDetail" ADD FOREIGN KEY("source_id")REFERENCES "AuditObjectiveDef"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditProcedureDefDetail" ADD FOREIGN KEY("risk_id")REFERENCES "RiskDef"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditProcedureDefDetail" ADD FOREIGN KEY("control_id")REFERENCES "ControlDef"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditProcedureDefDetail" ADD FOREIGN KEY("procedure_def_id")REFERENCES "AuditProcedureDef"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditProcedureClassifDetail" ADD FOREIGN KEY("source_id")REFERENCES "AuditProcedureDef"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditTestDef" ADD FOREIGN KEY("procedure_id")REFERENCES "AuditProcedureDef"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditClassifCode" ADD FOREIGN KEY("source_id")REFERENCES "RiskDef"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RiskControlDefMapping" ADD FOREIGN KEY("riskdef_id")REFERENCES "RiskDef"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RiskControlDefMapping" ADD FOREIGN KEY("control_def_id")REFERENCES "ControlDef"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RiskLikelihoodDef" ADD FOREIGN KEY("risk_control_id")REFERENCES "RiskAndControlTransaction"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EntityRiskImpactDef" ADD FOREIGN KEY("risk_control_id")REFERENCES "RiskAndControlTransaction"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RiskConsequenceDefMapping" ADD FOREIGN KEY("entity_risk_imapct_id")REFERENCES "EntityRiskImpactDef"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RiskConsequenceDefMapping" ADD FOREIGN KEY("risk_consequence_id")REFERENCES "RiskConsequenceCategoryDef"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ControlScoreConfigDef" ADD FOREIGN KEY("risk_control_id")REFERENCES "RiskAndControlTransaction"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ControlScoreDef" ADD FOREIGN KEY("control_config_id")REFERENCES "ControlScoreConfigDef"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RiskScoreDef" ADD FOREIGN KEY("risk_score_id")REFERENCES "TransactionRiskRanking"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RiskScoreDefDetail" ADD FOREIGN KEY("risk_score_def_id")REFERENCES "RiskScoreDef"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RiskCriteriaDef" ADD FOREIGN KEY("risk_score_id")REFERENCES "TransactionRiskRanking"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RiskScoreDefCriteriaMapping" ADD FOREIGN KEY("risk_criteria_id")REFERENCES "RiskCriteriaDef"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RiskEvaluationDef" ADD FOREIGN KEY("risk_control_id")REFERENCES "RiskAndControlTransaction"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RiskEvaluationDef" ADD FOREIGN KEY("risk_score_id")REFERENCES "RiskLikelihoodDef"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RiskEvaluationDef" ADD FOREIGN KEY("risk_impact_id")REFERENCES "EntityRiskImpactDef"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "FileNumberComponentDef" ADD FOREIGN KEY("filenumber_config_id")REFERENCES "FileNumberConf"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditOpinionGuidelineConf" ADD FOREIGN KEY("audit_objective_id")REFERENCES "AuditObjectiveDef"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditOpinionGuidelineConfDetail" ADD FOREIGN KEY("guideline_conf_id")REFERENCES "AuditOpinionGuidelineConf"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditOpinionClassifCode" ADD FOREIGN KEY("source_id")REFERENCES "AuditOpinionGuidelineConf"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MDAAddress" ADD FOREIGN KEY("address_id")REFERENCES "Address"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MDAAddress" ADD FOREIGN KEY("mda_profile_id")REFERENCES "MDAProfileDef"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MDAAuditableAreaDetail" ADD FOREIGN KEY("mda_profile_id")REFERENCES "MDAProfileDef"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MDAKeyStrategicObjective" ADD FOREIGN KEY("mda_profile_id")REFERENCES "MDAProfileDef"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MDAInternalKeyStakeHolder" ADD FOREIGN KEY("mda_profile_id")REFERENCES "MDAProfileDef"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MDAExternalKeyStakeHolder" ADD FOREIGN KEY("mda_profile_id")REFERENCES "MDAProfileDef"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MDAPoliciesProcessesOtherInfo" ADD FOREIGN KEY("mda_profile_id")REFERENCES "MDAProfileDef"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MDAAuditReport" ADD FOREIGN KEY("mda_profile_id")REFERENCES "MDAProfileDef"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MDAManagementContact" ADD FOREIGN KEY("mda_profile_id")REFERENCES "MDAProfileDef"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditHierarchyMDAMapping" ADD FOREIGN KEY("mda_profile_id")REFERENCES "MDAProfileDef"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MDAAuditHierarchyCode" ADD FOREIGN KEY("source_id")REFERENCES "AuditHierarchyMDAMapping"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ResourcePlanConfigDetail" ADD FOREIGN KEY("source_id")REFERENCES "ResourcePlanConfig"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "LeaveDetail" ADD FOREIGN KEY("config_id")REFERENCES "ResourcePlanConfigDetail"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ActivityDetail" ADD FOREIGN KEY("source_id")REFERENCES "ResourcePlanConfigDetail"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "LocationAllowanceMappingDetail" ADD FOREIGN KEY("mapping_id")REFERENCES "LocationAllowanceMapping"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RiskMaturityAssessment" ADD FOREIGN KEY("mda_profile_id")REFERENCES "MDAProfileDef"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CharacteristicDetail" ADD FOREIGN KEY("risk_maturity_assessment_id")REFERENCES "RiskMaturityAssessment"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CharacteristicDetail" ADD FOREIGN KEY("entity_risk_def_id")REFERENCES "EntityRiskMaturityDef"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditPlanSchedule" ADD FOREIGN KEY("parent_id")REFERENCES "AuditPlanSchedule"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditPlanScheduleDetail" ADD FOREIGN KEY("schedule_id")REFERENCES "AuditPlanSchedule"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditPlanScheduleDetail" ADD FOREIGN KEY("mda_profile_id")REFERENCES "MDAProfileDef"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditPlanScheduleDetail" ADD FOREIGN KEY("risk_maturity_assesment_id")REFERENCES "RiskMaturityAssessment"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RiskAssessment" ADD FOREIGN KEY("schedule_id")REFERENCES "AuditPlanSchedule"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RiskAssessment" ADD FOREIGN KEY("audit_schedule_id")REFERENCES "AuditPlanScheduleDetail"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RiskAssessmentDetail" ADD FOREIGN KEY("level_code")REFERENCES "AuditHierarchyCode"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RiskAssessmentDetail" ADD FOREIGN KEY("sublevel_code")REFERENCES "AuditHierarchyCode"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RiskAssessmentDetail" ADD FOREIGN KEY("assessment_id")REFERENCES "RiskAssessment"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RiskAssessmentDetail" ADD FOREIGN KEY("risk_score_id")REFERENCES "RiskScoreDefDetail"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RiskAssessmentDetail" ADD FOREIGN KEY("mda_profile_id")REFERENCES "MDAProfileDef"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AssessmentByLevel" ADD FOREIGN KEY("assessment_id")REFERENCES "RiskAssessment"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AssessmentBySubLevel" ADD FOREIGN KEY("parent_id")REFERENCES "AssessmentByLevel"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RiskRankBySubLevel" ADD FOREIGN KEY("parent_id")REFERENCES "AssessmentBySubLevel"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SAP" ADD FOREIGN KEY("audit_plan_schedule_id")REFERENCES "AuditPlanSchedule"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SAPItem" ADD FOREIGN KEY("sap_id")REFERENCES "SAP"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SAPSelectionDetail" ADD FOREIGN KEY("sap_item_id")REFERENCES "SAPItem"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SAPSelectionDetail" ADD FOREIGN KEY("risk_assessment_id")REFERENCES "RiskAssessment"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SAPSelectionDetail" ADD FOREIGN KEY("schedule_detail_id")REFERENCES "AuditPlanScheduleDetail"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SAPSelectionDetail" ADD FOREIGN KEY("risk_assessment_detail_id")REFERENCES "RiskAssessmentDetail"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SAPSelectionDetail" ADD FOREIGN KEY("mda_profile_id")REFERENCES "MDAProfileDef"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "NRBLevelDetail" ADD FOREIGN KEY("sap_selection_detail_id")REFERENCES "SAPSelectionDetail"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AAP" ADD FOREIGN KEY("sap_id")REFERENCES "SAP"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AAPItem" ADD FOREIGN KEY("aap_id")REFERENCES "AAP"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AAPDetail" ADD FOREIGN KEY("sap_selection_detail_id")REFERENCES "SAPSelectionDetail"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AAPDetail" ADD FOREIGN KEY("mda_profile_def_id")REFERENCES "MDAProfileDef"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AAPDetail" ADD FOREIGN KEY("aap_item_id")REFERENCES "AAPItem"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AAPDetail" ADD FOREIGN KEY("finding_id")REFERENCES "AuditFinding"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AAPLevelDetail" ADD FOREIGN KEY("aap_detail_id")REFERENCES "AAPDetail"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AAPObjeciveMapping" ADD FOREIGN KEY("guideline_openion_id")REFERENCES "AuditOpinionGuidelineConf"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AAPObjeciveMapping" ADD FOREIGN KEY("objective_id")REFERENCES "AuditObjectiveDef"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AAPObjeciveMapping" ADD FOREIGN KEY("assignment_id")REFERENCES "AAPSubAssignmentDetail"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AAPObjeciveMapping" ADD FOREIGN KEY("aap_detail_id")REFERENCES "AAPDetail"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ScheduleMonth" ADD FOREIGN KEY("aap_detail_id")REFERENCES "AAPDetail"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AAPAuditor" ADD FOREIGN KEY("aap_detail_id")REFERENCES "AAPDetail"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AAPAuditor" ADD FOREIGN KEY("admin_activity_id")REFERENCES "AAPAdminActivity"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AAPAuditorDetail" ADD FOREIGN KEY("aap_auditor_id")REFERENCES "AAPAuditor"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AAPAuditorDetailTxn" ADD FOREIGN KEY("detail_id")REFERENCES "AAPAuditorDetail"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditorDayExpenseDetail" ADD FOREIGN KEY("aap_auditor_detail_id")REFERENCES "AAPAuditorDetail"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditorDayExpenseDetail" ADD FOREIGN KEY("fin_resource_id")REFERENCES "AAPFinancialResource"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AAPFinancialResource" ADD FOREIGN KEY("rate_card_id")REFERENCES "RatecardConfig"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AAPFinancialResource" ADD FOREIGN KEY("admin_activity_id")REFERENCES "AAPAdminActivity"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AAPFinancialResource" ADD FOREIGN KEY("aap_detail_id")REFERENCES "AAPDetail"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AAPAdminActivity" ADD FOREIGN KEY("aap_item_details_id")REFERENCES "AAPDetail"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AAPSubAssignment" ADD FOREIGN KEY("app_item_id")REFERENCES "AAPItem"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AAPSubAssignmentDetail" ADD FOREIGN KEY("aap_detail_id")REFERENCES "AAPDetail"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AAPSubAssignmentDetail" ADD FOREIGN KEY("assignment_id")REFERENCES "AAPSubAssignment"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AAPAdminActivityExec" ADD FOREIGN KEY("app_item_id")REFERENCES "AAPItem"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AAPAdminActivityExec" ADD FOREIGN KEY("app_adm_activity_id")REFERENCES "AAPAdminActivity"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "COIDeclaration" ADD FOREIGN KEY("aap_detail_id")REFERENCES "AAPDetail"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "COIDeclaration" ADD FOREIGN KEY("assignment_id")REFERENCES "AAPSubAssignment"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AdhocConsultingCommencementDetail" ADD FOREIGN KEY("commencement_id")REFERENCES "AuditCommencementForm"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "FollowUpCommencementDetail" ADD FOREIGN KEY("commencement_id")REFERENCES "AuditCommencementForm"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditDatesAndBudget" ADD FOREIGN KEY("commencement_id")REFERENCES "AuditCommencementForm"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CommencementObjeciveMapping" ADD FOREIGN KEY("objective_id")REFERENCES "AuditObjectiveDef"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CommencementObjeciveMapping" ADD FOREIGN KEY("commencement_id")REFERENCES "AuditCommencementForm"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CommencementDetail" ADD FOREIGN KEY("aap_detail_id")REFERENCES "AAPDetail"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CommencementDetail" ADD FOREIGN KEY("commencement_id")REFERENCES "AuditCommencementForm"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditDate" ADD FOREIGN KEY("commencement_id")REFERENCES "AuditCommencementForm"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ResourceAndBudget" ADD FOREIGN KEY("aap_auditor_id")REFERENCES "AAPAuditor"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ResourceAndBudget" ADD FOREIGN KEY("commencement_id")REFERENCES "AuditCommencementForm"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ReportDistribution" ADD FOREIGN KEY("commencement_id")REFERENCES "AuditCommencementForm"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RequestList" ADD FOREIGN KEY("commencement_id")REFERENCES "AuditCommencementForm"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DocumentDetail" ADD FOREIGN KEY("request_id")REFERENCES "RequestList"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RequestListResponse" ADD FOREIGN KEY("request_list_id")REFERENCES "RequestList"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RequestListResponse" ADD FOREIGN KEY("aap_detail_id")REFERENCES "AAPDetail"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RequestListResponseDetail" ADD FOREIGN KEY("req_list_resp_id")REFERENCES "RequestListResponse"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RequestListResponseDetail" ADD FOREIGN KEY("document_detail_id")REFERENCES "DocumentDetail"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SummaryAuditableArea" ADD FOREIGN KEY("mda_profile_id")REFERENCES "MDAProfileDef"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SummaryAuditableArea" ADD FOREIGN KEY("commencement_detail_id")REFERENCES "CommencementDetail"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SummaryAuditSubject" ADD FOREIGN KEY("commencement_detail_id")REFERENCES "CommencementDetail"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SummaryAuditSubjectDetail" ADD FOREIGN KEY("risk_id")REFERENCES "RiskDef"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SummaryAuditSubjectDetail" ADD FOREIGN KEY("summary_id")REFERENCES "SummaryAuditSubject"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SummaryAuditSubjectCode" ADD FOREIGN KEY("summary_audit_subject_detail_id")REFERENCES "SummaryAuditSubjectDetail"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditScope" ADD FOREIGN KEY("commencement_detail_id")REFERENCES "CommencementDetail"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditScopeDetail" ADD FOREIGN KEY("risk_id")REFERENCES "RiskDef"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditScopeDetail" ADD FOREIGN KEY("control_id")REFERENCES "ControlDef"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditScopeDetail" ADD FOREIGN KEY("objective_id")REFERENCES "AuditObjectiveDef"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditScopeDetail" ADD FOREIGN KEY("scope_id")REFERENCES "AuditScope"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "InherentRisk" ADD FOREIGN KEY("commencement_detail_id")REFERENCES "CommencementDetail"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "InherentRiskDetail" ADD FOREIGN KEY("audit_scope_detail_id")REFERENCES "AuditScopeDetail"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "InherentRiskDetail" ADD FOREIGN KEY("inherent_risk_id")REFERENCES "InherentRisk"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ControlAssessment" ADD FOREIGN KEY("commencement_detail_id")REFERENCES "CommencementDetail"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ControlAssessmentDetail" ADD FOREIGN KEY("assessment_id")REFERENCES "ControlAssessment"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ControlAssessmentDetail" ADD FOREIGN KEY("inherent_risk_id")REFERENCES "InherentRiskDetail"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ResidualRiskAssessment" ADD FOREIGN KEY("commencement_detail_id")REFERENCES "CommencementDetail"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ResidualRiskAssessmentDetail" ADD FOREIGN KEY("control_assessment_detail_id")REFERENCES "ControlAssessmentDetail"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ResidualRiskAssessmentDetail" ADD FOREIGN KEY("assessment_id")REFERENCES "ResidualRiskAssessment"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RiskAssessmentConclusion" ADD FOREIGN KEY("commencement_detail_id")REFERENCES "CommencementDetail"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RiskAssessmentConclusionDetail" ADD FOREIGN KEY("risk_id")REFERENCES "RiskDef"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RiskAssessmentConclusionDetail" ADD FOREIGN KEY("control_id")REFERENCES "ControlDef"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RiskAssessmentConclusionDetail" ADD FOREIGN KEY("risk_assessment_conclusion_id")REFERENCES "RiskAssessmentConclusion"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RiskAssessmentConclusionCode" ADD FOREIGN KEY("risk_assessment_con_id")REFERENCES "RiskAssessmentConclusionDetail"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditAssignmentStatus" ADD FOREIGN KEY("aap_detail_id")REFERENCES "AAPDetail"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditAssignmentPlan" ADD FOREIGN KEY("audit_commencement_id")REFERENCES "AuditCommencementForm"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ManagementContact" ADD FOREIGN KEY("audit_assignment_plan_id")REFERENCES "AuditAssignmentPlan"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditTeamComposition" ADD FOREIGN KEY("audit_assignment_plan_id")REFERENCES "AuditAssignmentPlan"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TimeFinResource" ADD FOREIGN KEY("audit_assignment_plan_id")REFERENCES "AuditAssignmentPlan"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditProgram" ADD FOREIGN KEY("audit_commencement_id")REFERENCES "AuditCommencementForm"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditProgramDetail" ADD FOREIGN KEY("objective_id")REFERENCES "AuditObjectiveDef"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditProgramDetail" ADD FOREIGN KEY("control_id")REFERENCES "ControlDef"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditProgramDetail" ADD FOREIGN KEY("procedure_id")REFERENCES "AuditProcedureDef"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditProgramDetail" ADD FOREIGN KEY("aap_detail_id")REFERENCES "AAPDetail"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditProgramDetail" ADD FOREIGN KEY("audit_program_id")REFERENCES "AuditProgram"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditProgramDetail" ADD FOREIGN KEY("finding_id")REFERENCES "AuditFinding"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TestAssignementDetail" ADD FOREIGN KEY("test_id")REFERENCES "AuditTestDef"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TestAssignementDetail" ADD FOREIGN KEY("program_detail_id")REFERENCES "AuditProgramDetail"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditTestWorksheet" ADD FOREIGN KEY("commencement_detail_id")REFERENCES "CommencementDetail"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditTestWorksheetDetail" ADD FOREIGN KEY("audit_program_id")REFERENCES "AuditProgramDetail"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditTestWorksheetDetail" ADD FOREIGN KEY("worksheet_id")REFERENCES "AuditTestWorksheet"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditTestResult" ADD FOREIGN KEY("commencement_detail_id")REFERENCES "CommencementDetail"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditTestResultDetail" ADD FOREIGN KEY("test_assignment_detail_id")REFERENCES "TestAssignementDetail"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditTestResultDetail" ADD FOREIGN KEY("audit_test_result_id")REFERENCES "AuditTestResult"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditFinding" ADD FOREIGN KEY("commencement_detail_id")REFERENCES "CommencementDetail"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditFinding" ADD FOREIGN KEY("parent_finding_id")REFERENCES "AuditFinding"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditFindingObservation" ADD FOREIGN KEY("audit_finding_id")REFERENCES "AuditFinding"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditFindingObservation" ADD FOREIGN KEY("audit_program_detail_id")REFERENCES "AuditProgramDetail"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditFindingObservationDetail" ADD FOREIGN KEY("audit_finding_observation_id")REFERENCES "AuditFindingObservation"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditFindingDetail" ADD FOREIGN KEY("audit_finding_id")REFERENCES "AuditFinding"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Recommendation" ADD FOREIGN KEY("audit_finding_detail_id")REFERENCES "AuditFindingDetail"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MngmtActionPlan" ADD FOREIGN KEY("audit_finding_detail_id")REFERENCES "AuditFindingDetail"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditMeeting" ADD FOREIGN KEY("commencement_from_id")REFERENCES "AuditCommencementForm"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditMeetingDetail" ADD FOREIGN KEY("audit_meeting_id")REFERENCES "AuditMeeting"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditMeetingDetail" ADD FOREIGN KEY("commencement_detail_id")REFERENCES "CommencementDetail"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditMeetingDocument" ADD FOREIGN KEY("audit_meeting_id")REFERENCES "AuditMeeting"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MeetingPoint" ADD FOREIGN KEY("audit_meeting_id")REFERENCES "AuditMeeting"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Participant" ADD FOREIGN KEY("audit_meeting_id")REFERENCES "AuditMeeting"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ReportActual" ADD FOREIGN KEY("commencement_form_id")REFERENCES "AuditCommencementForm"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ReportActualDetail" ADD FOREIGN KEY("report_actual_id")REFERENCES "ReportActual"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditClosureForm" ADD FOREIGN KEY("commencement_form_id")REFERENCES "AuditCommencementForm"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditWorkingPaper" ADD FOREIGN KEY("audit_closure_form_id")REFERENCES "AuditClosureForm"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ResultOfAssignment" ADD FOREIGN KEY("audit_closure_form_id")REFERENCES "AuditClosureForm"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AssignmentInfo" ADD FOREIGN KEY("audit_closure_form_id")REFERENCES "AuditClosureForm"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EngagementForm" ADD FOREIGN KEY("commencement_form_id")REFERENCES "AuditCommencementForm"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EngagementFormDetail" ADD FOREIGN KEY("engagemnt_form_id")REFERENCES "EngagementForm"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EngagementFormDetail" ADD FOREIGN KEY("commencement_detail_id")REFERENCES "CommencementDetail"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditRegister" ADD FOREIGN KEY("commencement_form_id")REFERENCES "AuditCommencementForm"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditRegisterFinding" ADD FOREIGN KEY("audit_finding_id")REFERENCES "AuditFinding"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditRegisterFinding" ADD FOREIGN KEY("audit_register_id")REFERENCES "AuditRegister"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditRegisterDetail" ADD FOREIGN KEY("mngmt_action_plan_id")REFERENCES "MngmtActionPlan"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditRegisterDetail" ADD FOREIGN KEY("register_finding_id")REFERENCES "AuditRegisterFinding"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SupportingDoc" ADD FOREIGN KEY("audit_register_detail_id")REFERENCES "AuditRegisterDetail"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "IAUDevisionDetail" ADD FOREIGN KEY("iau_devision_id")REFERENCES "IAUDevision"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "IAUDevisionDetail" ADD FOREIGN KEY("mda_profile_id")REFERENCES "MDAProfileDef"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Report" ADD FOREIGN KEY("commencement_detail_id")REFERENCES "CommencementDetail"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ReportItem" ADD FOREIGN KEY("report_id")REFERENCES "Report"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DraftReport" ADD FOREIGN KEY("commencement_detail_id")REFERENCES "CommencementDetail"("id") ON DELETE SET NULL ON UPDATE CASCADE;
