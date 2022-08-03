INSERT INTO public."AuditHierarchyLevel"
(id, tenant_id, name, parent_id, version_no, version_user, version_date, created_at)
VALUES('Domain', 'TEN1', 'Domain', NULL, 1, 'Sachin_002', '2021-03-04 10:48:08.380', '2021-03-04 10:48:08.379');
INSERT INTO public."AuditHierarchyLevel"
(id, tenant_id, name, parent_id, version_no, version_user, version_date, created_at)
VALUES('Subject', NULL, 'Subject', 'Domain', 1, 'SYSTEM', '2021-03-04 10:48:08.380', '2021-03-04 10:48:08.379');
INSERT INTO public."AuditHierarchyLevel"
(id, tenant_id, name, parent_id, version_no, version_user, version_date, created_at)
VALUES('Module', NULL, 'Module', 'Subject', 1, 'SYSTEM', '2021-03-04 10:48:08.380', '2021-03-04 10:48:08.379');
INSERT INTO public."AuditHierarchyLevel"
(id, tenant_id, name, parent_id, version_no, version_user, version_date, created_at)
VALUES('Task', NULL, 'Task', 'Module', 1, 'SYSTEM', '2021-03-04 10:48:08.380', '2021-03-04 10:48:08.379');



INSERT INTO public."AuditPlanDef"
(id,tenant_id,ref,risk_control_level,audit_program_level,mda_start_month,mda_start_day,mda_end_month,mda_end_day, version_no, version_user, version_date)
VALUES('AUDIT_PLAN_CONFIG','TEN1','AUDIT_PLAN_CONFIG','ALL','Subject','JAN',1,'DEC',31, 2, 'superadmin', '2021-06-01 11:01:32.211');

INSERT INTO public."FollowUpAuditConf"
(id, tenant_id, "ref", treatment_of_followup_audit, grouping_of_findigs, placemnt_od_identifier, status, is_active, is_latest, is_effective, effective_from, version_no, version_user, version_date)
VALUES('FOLLOWUP_AUDIT_CONFIG', 'TEN1', 'FOLLOWUP_AUDIT_CONFIG', 'As a Sub-assignment of a Sub-assignment', 'Across Assignments', 'Prefix', 'Draft', true, false, false, NULL, 1, 'superadmin', '2021-08-23 10:38:22.697');

INSERT INTO public."AuditHierarchyDetailConf"
(id, tenant_id, "ref", status, is_active, is_latest, is_effective, effective_from, version_no, version_user, version_date)
VALUES('AUDIT_HIERARCHY_DETAIL', 'TEN1', 'AUDIT_HIERARCHY_DETAIL', 'Draft', true, false, false, NULL, 1, 'superadmin', '2021-09-01 16:31:44.826');

INSERT INTO public."EntityRiskMaturityDef"
(id, tenant_id, characteristic, sample_audit_test, version_no, version_user, version_date)
VALUES
('DEF01', 'TEN1', 'The organisation''s objectives are defined', 'Check the organisation''s objectives are determined by the board and have been communicated to all staff. Check other objectives and targets are consistent with the organisation''s objectives', 1, 'superadmin', NOW()),
('DEF02', 'TEN1', 'Management have been trained to understand what risks are and their responsibility for them', 'Interview managers to confirm their understanding or risk and the extent to which they manage it ', 1, 'superadmin', NOW()),
('DEF03', 'TEN1', 'A scoring system for assessing risks has been defined', 'Check the scoring system has been approved communicated and is used ', 1, 'superadmin', NOW()),
('DEF04', 'TEN1', 'The risk appetite of the organisation has been defined in terms of the scoring system', 'Check the document on which the controlling body has approved the risk appetite. Ensure it is consistent with the scoring system and has been communicated ', 1, 'superadmin', NOW()),
('DEF05', 'TEN1', 'Processes have been defined to determine risks and these have been followed', 'Examine the processes to ensure they are sufficient to ensure identification of all  risks. Check they are in use by examining the output from any workshop', 1, 'superadmin', NOW()),
('DEF06', 'TEN1', 'All risks have been collected into one list. Risks have been allocated to specific job titles', 'Examine the risk register. Ensure it is complete, regularly reviewed, assesses and used to manage risks. Risks are allocated to managers', 1, 'superadmin', NOW()),
('DEF07', 'TEN1', 'All risks have been assessed in accordance with the defined scoring system', 'Check the scoring applied to a selection of risks is consistent with the policy. Look for consistency (that is, similar risks have similar scores)', 1, 'superadmin', NOW()),
('DEF08', 'TEN1', 'Responses to the risks have been selected and implemented', 'Check the Risk Register to ensure appropriate responses have been identified', 1, 'superadmin', NOW()),
('DEF09', 'TEN1', 'Management have set up methods to monitor the proper operation of  key processes, responses and action plans(Monitoring controls)', 'For a selection of responses , processes and actions, examine the monitoring controls and ensure management would know if the responses or processes were not working or if the actions were not implemented', 1, 'superadmin', NOW()),
('DEF10', 'TEN1', 'Risks are regularly reviewed by the organisation', 'Check for evidence that a thorough review process is regularly carried out ', 1, 'superadmin', NOW()),
('DEF11', 'TEN1', 'Management report risks to directors where responses have not managed the risks to a level acceptable to the board', 'For risks above the risk appetite , check that the board has been formally informed of their existence', 1, 'superadmin', NOW()),
('DEF12', 'TEN1', 'All significant new projects are routinely assessed for risks', 'Examine project proposals for analysis of the risks which might threaten them', 1, 'superadmin', NOW()),
('DEF13', 'TEN1', 'Responsibility for the determination, assessment and management of risks is included in job descriptions', 'Examine job descriptions. Check instructions for setting up job descriptions', 1, 'superadmin', NOW()),
('DEF14', 'TEN1', 'Managers provide assurance on the effectiveness of their risk management ', 'Examine the assurance provided. For key risks, Check that controls and the management of system of monitoring are operating', 1, 'superadmin', NOW()),
('DEF15', 'TEN1', 'Managers are assessed on their risk management performances', 'Examine a sample of appraisals for evidence that risk management was properly assessed for performance', 1, 'superadmin', NOW());

INSERT INTO public."AuditProgramStructure"
(id, tenant_id, "name", parent_id, version_no, version_user, version_date, created_at)
VALUES
('Audit Program', 'TEN1', 'Audit Program', NULL, 1, 'Sachin_002', NOW(),  NOW()),
('Audit Objectives', NULL, 'Audit Objectives', 'Audit Program', 1, 'SYSTEM', NOW(),  NOW()),
('Audit Procedures', NULL, 'Audit Procedures', 'Audit Objectives', 1, 'SYSTEM', NOW(),  NOW()),
('Audit Test', NULL, 'Audit Test', 'Audit Procedures', 1, 'SYSTEM', NOW(),  NOW());




INSERT INTO public."RiskAndControlTransaction"
( id,tenant_id,name,from_year,to_year,status,is_active,is_latest,is_effective,version_no,version_user,version_date)
VALUES('TXN_0001','TEN1','Risk And Control Version',2021,2022,'Approved',true,true,true,1,'superadmin', '2021-06-01 11:01:32.211');

INSERT INTO public."TransactionRiskRanking"
(id, tenant_id, sno, applicability_from, applicability_to, start_range, end_range, no_of_slabs, status, is_active, is_latest, is_effective, effective_from, version_no, version_user, version_date)
VALUES('cksiku4ta0000k8oc84czhrog', 'TEN1', '1', 2020, 2021, 0, 10, 4, 'Draft', true, false, false, NULL, 1, 'Sachin_002', '2021-08-19 07:02:56.737');

INSERT INTO public."RiskCriteriaDef"
(id, tenant_id, sno, criteria, weightage, risk_score_id, version_no, version_user, version_date)
VALUES
('cksilkycx0090k8ociyes2u0q', 'TEN1', 1, 'Complexity', 10, 'cksiku4ta0000k8oc84czhrog', 1, 'SYSTEM', '2021-08-19 07:23:48.087'),
('cksilk3cx0090k8ociyes2u0q', 'TEN1', 4, 'Management', 10, 'cksiku4ta0000k8oc84czhrog', 1, 'SYSTEM', '2021-08-19 07:23:48.087'),
('cksilk4cx0090k8ociyes2u0q', 'TEN1', 5, 'Change', 20, 'cksiku4ta0000k8oc84czhrog', 1, 'SYSTEM', '2021-08-19 07:23:48.087'),
('cksilk5cx0090k8ociyes2u0q', 'TEN1', 6, 'Size', 25, 'cksiku4ta0000k8oc84czhrog', 1, 'SYSTEM', '2021-08-19 07:23:48.087'),
('cksilk2cx0090k8ociyes2u0q', 'TEN1', 3, 'Control', 20, 'cksiku4ta0000k8oc84czhrog', 1, 'SYSTEM', '2021-08-19 07:23:48.087'),
('cksilk1cx0090k8ociyes2u0q', 'TEN1', 2, 'Impact', 15, 'cksiku4ta0000k8oc84czhrog', 1, 'SYSTEM', '2021-08-19 07:23:48.087');

INSERT INTO public."RiskScoreDef"
(id, tenant_id, "period", no_of_slabs, start_range, end_range, risk_score_id, version_no, version_user, version_date)
VALUES('cksiku4ta0001k8ocym1t919j', NULL, '2020-2021', 4, 0, 6, 'cksiku4ta0000k8oc84czhrog', 1, 'SYSTEM', '2021-08-19 07:02:56.737');


INSERT INTO public."RiskScoreDefDetail"
(id, tenant_id, slab_no, start_range, end_range, "descriptor", colour, audit_timing, version_no, version_user, version_date, risk_score_def_id,audit_frequency)
VALUES
('cksiku4ta0002k8ocquonr4be', NULL, 1, 0, 1.1, 'Low', 'Green', 'Should be monitored for risk changes', 1, 'SYSTEM', '2021-08-19 07:02:56.737', 'cksiku4ta0001k8ocym1t919j',0),
('cksiku4ta0003k8oc274ywjpz', NULL, 2, 1.2, 2.49, 'Moderate', 'Yellow', 'Should be audited every three years', 1, 'SYSTEM', '2021-08-19 07:02:56.737', 'cksiku4ta0001k8ocym1t919j',3),
('cksiku4ta0004k8oci5ux6ur3', NULL, 3, 2.5, 3.49, 'Significant', 'Orange', 'Should be audited every two years', 1, 'SYSTEM', '2021-08-19 07:02:56.737', 'cksiku4ta0001k8ocym1t919j',2),
('cksiku4ta0005k8oc5qwj5grb', NULL, 4, 3.5, 5, 'High', 'Red', 'Must be audited every year', 1, 'SYSTEM', '2021-08-19 07:02:56.737', 'cksiku4ta0001k8ocym1t919j',1);

INSERT INTO public."RiskLikelihoodDef"
(id, tenant_id, risk_score, risk_control_id, "descriptor", narration, version_no, version_user, version_date)
VALUES('cksg348i902230umthg4v8xck', 'TEN1', 1, 'TXN_0001', 'Rare', 'The event may occur in some exceptional circumstances. It has not happened in the last 10 years and is not likely to occur in the next 3 to 5 years(probability of <10%)', 1, 'Sachin_002', '2021-08-17 13:11:22.642');
INSERT INTO public."RiskLikelihoodDef"
(id, tenant_id, risk_score, risk_control_id, "descriptor", narration, version_no, version_user, version_date)
VALUES('cksg34rs302370umto20er0s6', 'TEN1', 2, 'TXN_0001', 'Unlikely', 'The event could occur in some circumstances. It has occurred in the last 10 years but is not likely to happen in the next 3 to 5 years (probability of >=10% <25%)', 1, 'Sachin_002', '2021-08-17 13:11:47.620');
INSERT INTO public."RiskLikelihoodDef"
(id, tenant_id, risk_score, risk_control_id, "descriptor", narration, version_no, version_user, version_date)
VALUES('cksg34rsi02460umt7zz4nrra', 'TEN1', 3, 'TXN_0001', 'Possible', 'The event should occur in some circumstances. It has occurred in the last 5 years and likely to happen in the next 3 to 5 years (probability of >=25% <50%)', 1, 'Sachin_002', '2021-08-17 13:11:47.635');
INSERT INTO public."RiskLikelihoodDef"
(id, tenant_id, risk_score, risk_control_id, "descriptor", narration, version_no, version_user, version_date)
VALUES('cksg34rst02560umtn6x71pl5', 'TEN1', 4, 'TXN_0001', 'Likely', 'The event will probably occur in most circumstances. It has occurred in the last 5 years and likely to happen in the next 3 to 5 years (probability of >=50% <75%)', 1, 'Sachin_002', '2021-08-17 13:11:47.646');
INSERT INTO public."RiskLikelihoodDef"
(id, tenant_id, risk_score, risk_control_id, "descriptor", narration, version_no, version_user, version_date)
VALUES('cksg34rt302660umt8k8asb3o', 'TEN1', 5, 'TXN_0001', 'Almost Certain', 'Event will occur in most circumstances. It has occurred in the last 2 certain years and likely to happen in the next 3 to 5 years (probability of >75%)', 1, 'Sachin_002', '2021-08-17 13:11:47.656');



INSERT INTO public."RiskConsequenceCategoryDef"
(id, tenant_id, sno, category, version_no, version_user, version_date)
VALUES('ckseapy4z27750uqjjlwmfdgx', 'TEN1', 1, 'Reputation', 1, 'Sachin_002', '2021-08-17 13:12:42.161');
INSERT INTO public."RiskConsequenceCategoryDef"
(id, tenant_id, sno, category, version_no, version_user, version_date)
VALUES('ckseapy5d27820uqj4xl73dzn', 'TEN1', 2, 'Financial', 1, 'Sachin_002', '2021-08-17 13:12:42.181');
INSERT INTO public."RiskConsequenceCategoryDef"
(id, tenant_id, sno, category, version_no, version_user, version_date)
VALUES('ckseapy5l27890uqj801qqzgq', 'TEN1', 3, 'Operational', 1, 'Sachin_002', '2021-08-17 13:12:42.191');
INSERT INTO public."RiskConsequenceCategoryDef"
(id, tenant_id, sno, category, version_no, version_user, version_date)
VALUES('ckseapy5s27960uqjf4cafo4u', 'TEN1', 4, 'Compliance', 1, 'Sachin_002', '2021-08-17 13:12:42.198');


INSERT INTO public."EntityRiskImpactDef"
(id, tenant_id, score, "descriptor", risk_control_id, version_no, version_user, version_date)
VALUES('ckshesonv28500uogpaweun2z', 'TEN1', 1, 'Notable', 'TXN_0001', 1, 'Sachin_002', '2021-08-18 11:26:05.277');
INSERT INTO public."EntityRiskImpactDef"
(id, tenant_id, score, "descriptor", risk_control_id, version_no, version_user, version_date)
VALUES('ckshesoot28840uog26lww25a', 'TEN1', 2, 'Minor', 'TXN_0001', 1, 'Sachin_002', '2021-08-18 11:26:05.310');
INSERT INTO public."EntityRiskImpactDef"
(id, tenant_id, score, "descriptor", risk_control_id, version_no, version_user, version_date)
VALUES('ckshesopi29170uog6tw6bamy', 'TEN1', 3, 'Moderate', 'TXN_0001', 1, 'Sachin_002', '2021-08-18 11:26:05.335');
INSERT INTO public."EntityRiskImpactDef"
(id, tenant_id, score, "descriptor", risk_control_id, version_no, version_user, version_date)
VALUES('ckshesoq229520uoglclnaust', 'TEN1', 4, 'Major', 'TXN_0001', 1, 'Sachin_002', '2021-08-18 11:26:05.356');
INSERT INTO public."EntityRiskImpactDef"
(id, tenant_id, score, "descriptor", risk_control_id, version_no, version_user, version_date)
VALUES('ckshesors29860uogd8sdk0w8', 'TEN1', 5, 'Catastrophic', 'TXN_0001', 1, 'Sachin_002', '2021-08-18 11:26:05.417');


INSERT INTO public."RiskConsequenceDefMapping"
(id, narration, entity_risk_imapct_id, risk_consequence_id)
VALUES
('1', 'Minor injury or incident. No impact or minimal impact', 'ckshesonv28500uogpaweun2z', 'ckseapy4z27750uqjjlwmfdgx'),
('2', 'Up to 0.5% of audited entity''s budget', 'ckshesonv28500uogpaweun2z', 'ckseapy5d27820uqj4xl73dzn'),
('3', 'Loss of service for up to one days/Unexpected loss of a single staff member/ Near miss injury or incident', 'ckshesonv28500uogpaweun2z', 'ckseapy5l27890uqj801qqzgq'),
('4', 'Insignificant legal and regulatory failure', 'ckshesonv28500uogpaweun2z', 'ckseapy5s27960uqjf4cafo4u'),
('5', 'Isolated adverse local media coverage and/or adverse stakeholder comments or complaints', 'ckshesoot28840uog26lww25a', 'ckseapy4z27750uqjjlwmfdgx'),
('6', 'More than 0.5% and upto 0.75% of audited entity''s budget', 'ckshesoot28840uog26lww25a', 'ckseapy5d27820uqj4xl73dzn'),
('7', 'Loss of service of more than 1 and up to 2 days/Unexpected loss of a senior staff member/Minor injury or incident', 'ckshesoot28840uog26lww25a', 'ckseapy5l27890uqj801qqzgq'),
('8', 'Minor and isolated failure that can be resolved without penalties', 'ckshesoot28840uog26lww25a', 'ckseapy5s27960uqjf4cafo4u'),
('9', 'Extended local adverse media coverage and/or adverse stakeholder comments', 'ckshesopi29170uog6tw6bamy', 'ckseapy4z27750uqjjlwmfdgx'),
('10', 'More than 0.75% and up to 1% of audited entity''s budget', 'ckshesopi29170uog6tw6bamy', 'ckseapy5d27820uqj4xl73dzn'),
('11', 'Loss of service of more than 2 and up to 3 days/Unexpected loss of a key staff member who is integral to the business/injury or incident requiring medical attention', 'ckshesopi29170uog6tw6bamy', 'ckseapy5l27890uqj801qqzgq'),
('12', 'Limited failure resulting in reportable incidents to regulators', 'ckshesopi29170uog6tw6bamy', 'ckseapy5s27960uqjf4cafo4u'),
('13', 'Adverse national media coverage, and/or some loss of confidence by stakeholders', 'ckshesoq229520uoglclnaust', 'ckseapy4z27750uqjjlwmfdgx'),
('14', 'More than 1% and up to 5% of audited entity''s budget', 'ckshesoq229520uoglclnaust', 'ckseapy5d27820uqj4xl73dzn'),
('15', 'Loss of service of more than 3 and up to 5 days/Unexpected loss of a key staff member with specialist knowledge/Serious injury or incident', 'ckshesoq229520uoglclnaust', 'ckseapy5l27890uqj801qqzgq'),
('16', 'Major failure resulting in regulators raising non-compliance issues.', 'ckshesoq229520uoglclnaust', 'ckseapy5s27960uqjf4cafo4u'),
('17', 'Extended national and international adverse media coverage, and/or significant loss of confidence by stakeholders', 'ckshesors29860uogd8sdk0w8', 'ckseapy4z27750uqjjlwmfdgx'),
('18', 'In excess of 5% of audited entity''s budget', 'ckshesors29860uogd8sdk0w8', 'ckseapy5d27820uqj4xl73dzn'),
('19', 'Loss of service for more than 5 days/unplanned loss of senior management or several key staff/loss of life or permanent incapacitation', 'ckshesors29860uogd8sdk0w8', 'ckseapy5l27890uqj801qqzgq'),
('20', 'Significant failure resulting in criminal penalties', 'ckshesors29860uogd8sdk0w8', 'ckseapy5s27960uqjf4cafo4u');

INSERT INTO public."ControlScoreConfigDef"
(id, tenant_id, range_start, range_end, no_of_slabs, risk_control_id, version_no, version_user, version_date)
VALUES('cksg3ppo509820umt4hp33sne', 'TEN1', 2021, 2022, 4, 'TXN_0001', 1, 'Sachin_002', '2021-08-17 13:28:04.663');




INSERT INTO public."ControlScoreDef"
(id, tenant_id, slab_no, start_range, end_range, "descriptor", interpretation, testing_required, control_config_id)
VALUES('cksg3ppo509830umtm2ypgrn7', NULL, 1, 0, 0, 'Do not Exists', 'Control activities are not in place', 'Substantive Test', 'cksg3ppo509820umt4hp33sne');
INSERT INTO public."ControlScoreDef"
(id, tenant_id, slab_no, start_range, end_range, "descriptor", interpretation, testing_required, control_config_id)
VALUES('cksg3ppo609860umt5jmq3omf', NULL, 4, 70, 100, 'Strong', 'Control activities are adequate and materially operate as designed', 'Both', 'cksg3ppo509820umt4hp33sne');
INSERT INTO public."ControlScoreDef"
(id, tenant_id, slab_no, start_range, end_range, "descriptor", interpretation, testing_required, control_config_id)
VALUES('cksg3ppo509840umtqyca25x9', NULL, 2, 0, 39, 'Weak', 'Control activities are inadequate whether they are adhered to or control activities are adequate but are materially not adhered to', 'Both', 'cksg3ppo509820umt4hp33sne');
INSERT INTO public."ControlScoreDef"
(id, tenant_id, slab_no, start_range, end_range, "descriptor", interpretation, testing_required, control_config_id)
VALUES('cksg3ppo609850umtb4nq9xs1', NULL, 3, 40, 69, 'Moderate', 'Control activities adequate but not applied consistently', 'Both', 'cksg3ppo509820umt4hp33sne');



INSERT INTO public."RiskScoreDefCriteriaMapping"
(id, risk_criteria_id, risk_score, version_no, version_user, version_date, description)
VALUES

('cksilkscx0094k8oc5ds72yz8', 'cksilkycx0090k8ociyes2u0q', '4', 1, 'SYSTEM', '2021-08-19 07:23:48.087', 'Operation is complex, task can only be done by experienced employee'),
('cksilkycx0093o8ocau85nyu2', 'cksilkycx0090k8ociyes2u0q', '3', 1, 'SYSTEM', '2021-08-19 07:23:48.087', 'Operation is moderately complex, training and detailed instruction required'),
('cksilkycx0092k8oc3s2gtpbexi', 'cksilkycx0090k8ociyes2u0q', '2', 1, 'SYSTEM', '2021-08-19 07:23:48.087', 'Operation is relatively simple, some training required'),
('cksilkycx0091ks8oc2h33npcfu', 'cksilkycx0090k8ociyes2u0q', '1', 1, 'SYSTEM', '2021-08-19 07:23:48.087', 'Operation is simple or routine'),
('cksilkscx0084k8oc5ds72yz8', 'cksilkycx0090k8ociyes2u0q', '5', 1, 'SYSTEM', '2021-08-19 07:23:48.087', 'Operation is very complex, specialist in the field required'),
('cksilkycx009ak8oc32gtpbexi', 'cksilk3cx0090k8ociyes2u0q', '5', 1, 'SYSTEM', '2021-08-19 07:23:48.087', 'Significant interest to have internal audit assessment in the functional area such as indication to have scheduled audit every year or in the first year''s audit plan'),
('cksilkscx0094k8oc5ms72yz8', 'cksilk3cx0090k8ociyes2u0q', '4', 1, 'SYSTEM', '2021-08-19 07:23:48.087', 'Interest to have internal audit assessment in the functional area such as indication to have audit every two years'),
('cksilkycx0093o8ocru85nyu2', 'cksilk3cx0090k8ociyes2u0q', '3', 1, 'SYSTEM', '2021-08-19 07:23:48.087', 'Some interest to have internal audit assessment in the functional area such as indication to have audit every three years'),
('cksilkycx0092k8oc32gtpbexi', 'cksilk3cx0090k8ociyes2u0q', '2', 1, 'SYSTEM', '2021-08-19 07:23:48.087', 'Little interest in using internal audit resources because no significant issues have been identified by management'),
('cksilkycx0091k8oc2h33npcfu', 'cksilk3cx0090k8ociyes2u0q', '1', 1, 'SYSTEM', '2021-08-19 07:23:48.087', 'No interest in using internal audit resources because independent assessment is received from other sources'),
('cksilkycx00a1k85och33npcfu', 'cksilk4cx0090k8ociyes2u0q', '5', 1, 'SYSTEM', '2021-08-19 07:23:48.087', 'Dynamic environment with change in policy, process, senior management and more than 25% turnover'),
('cksilkycd0094k8oc5ms72yz8', 'cksilk4cx0090k8ociyes2u0q', '4', 1, 'SYSTEM', '2021-08-19 07:23:48.087', 'Moderately dynamic without change in policy but some changes toprocess, senior management including process owner and staff turnover of between 15 and 25%'),
('cksilkycx0893k8ocru85nyu2', 'cksilk4cx0090k8ociyes2u0q', '3', 1, 'SYSTEM', '2021-08-19 07:23:48.087', 'Moderate change without change in policy but some changes to process, senior management but not process owner and staff turnover of between 10 and 15%'),
('cksilkycx0092k8o4c2gtpbexi', 'cksilk4cx0090k8ociyes2u0q', '2', 1, 'SYSTEM', '2021-08-19 07:23:48.087', 'Moderately stable without change in policy, process but some changes in senior management but not process owner and staff turnover of between 5 and 10%'),
('cksilkycx0091k85och33npcfu', 'cksilk4cx0090k8ociyes2u0q', '1', 1, 'SYSTEM', '2021-08-19 07:23:48.087', 'Stable environment without changes in policy, process, senior management and less than 5% turnover in support staff'),
('cksilkycx00h4k8oc5ms72yz8', 'cksilk5cx0090k8ociyes2u0q', '5', 1, 'SYSTEM', '2021-08-19 07:23:48.087', 'Annual cost is over MK10 billion or processing is valued at more than MK100 billion'),
('cksilkycx00h4k8od5ms72yz8', 'cksilk5cx0090k8ociyes2u0q', '4', 1, 'SYSTEM', '2021-08-19 07:23:48.087', 'Annual cost ranges from MK5 billion to less than MK10 billion or value of processing ranges from MK50 billion to less than MK100 billion '),
('cksilkycx0093k8ocru85ny12', 'cksilk5cx0090k8ociyes2u0q', '3', 1, 'SYSTEM', '2021-08-19 07:23:48.087', 'Annual cost ranges from MK1 billion to less than MK5 billion or value of processing ranges from MK10 billion to less than MK50 billion'),
('cksilkycx0092k8oc62gtpbexi', 'cksilk5cx0090k8ociyes2u0q', '2', 1, 'SYSTEM', '2021-08-19 07:23:48.087', 'Annual cost ranges from MK100 million to less than MK1 billion or value of processing ranges from MK100 million to less than MK 10 billion'),
('cksilky4cx0091k8och33npcfu', 'cksilk5cx0090k8ociyes2u0q', '1', 1, 'SYSTEM', '2021-08-19 07:23:48.087', 'Annual cost is less than MK100 million or value of processing is less than MK 100 million'),
('cksilkya8x0091k8och33npcfu', 'cksilk2cx0090k8ociyes2u0q', '5', 1, 'SYSTEM', '2021-08-19 07:23:48.087', 'Control activities are not in place'),
('cksilkycx00s4k8oc5ms72yz8', 'cksilk2cx0090k8ociyes2u0q', '4', 1, 'SYSTEM', '2021-08-19 07:23:48.087', 'Control activities are inadequate and not operated as designed'),
('cksilkycx0093k8ocru85n2yu2', 'cksilk2cx0090k8ociyes2u0q', '3', 1, 'SYSTEM', '2021-08-19 07:23:48.087', 'Control activities are inadequate but those in place operate as designed'),
('cksilkycx00928k8oc2gtpbexi', 'cksilk2cx0090k8ociyes2u0q', '2', 1, 'SYSTEM', '2021-08-19 07:23:48.087', 'Control activities are materially adequate and but not applied consistently'),
('cksilkyc8x0091k8och33npcfu', 'cksilk2cx0090k8ociyes2u0q', '1', 1, 'SYSTEM', '2021-08-19 07:23:48.087', 'Control activities are adequate and operate as designed'),
('cksilyyc2x0091k8och33npcfu', 'cksilk1cx0090k8ociyes2u0q', '5', 1, 'SYSTEM', '2021-08-19 07:23:48.087', 'Affects almost all ministries or almost the whole country'),
('cksilkycx0094q8oc5ms72yz8', 'cksilk1cx0090k8ociyes2u0q', '4', 1, 'SYSTEM', '2021-08-19 07:23:48.087', 'Affects more than one ministry or communities in more than one region'),
('cksilkycx0093k8oc3ru85nyu2', 'cksilk1cx0090k8ociyes2u0q', '3', 1, 'SYSTEM', '2021-08-19 07:23:48.087', 'Affects one ministry or one region in Malawi'),
('cksilkycx00992k8oc2gtpbexi', 'cksilk1cx0090k8ociyes2u0q', '2', 1, 'SYSTEM', '2021-08-19 07:23:48.087', 'Affects one department in the ministry or more than one community in Malawi'),
('cksilkyc2x0091k8och33npcfu', 'cksilk1cx0090k8ociyes2u0q', '1', 1, 'SYSTEM', '2021-08-19 07:23:48.087', 'Affects one section in a department or one community in Malawi');

-- ('cksilky4cx0091k8osh33npcfu', 'cksilk5cx0090k8ociyes2u0q', 'cksikudta0005k8oc5qwj5grb', 1, 'SYSTEM', '2021-08-19 07:23:48.087', 'Annual cost is over MK10 billion or processing is valued at more than MK100 billion'),
-- ('cksilkycx00a1k85och33npcfu', 'cksilk4cx0090k8ociyes2u0q', 'cksikudta0005k8oc5qwj5grb', 1, 'SYSTEM', '2021-08-19 07:23:48.087', 'Dynamic environment with change in policy, process, senior management and more than 25% turnover'),
-- ('cksilkya8x0091k8och33npcfu', 'cksilk2cx0090k8ociyes2u0q', 'cksikudta0005k8oc5qwj5grb', 1, 'SYSTEM', '2021-08-19 07:23:48.087', 'Control activities are not in place'),
-- ('cksilyyc2x0091k8och33npcfu', 'cksilk1cx0090k8ociyes2u0q', 'cksikudta0005k8oc5qwj5grb', 1, 'SYSTEM', '2021-08-19 07:23:48.087', 'Affects almost all ministries or almost the whole country');




INSERT INTO public."RiskEvaluationDef"
(id, tenant_id, "descriptor", colour_code, risk_score, interpretation_req_action, risk_score_id, risk_impact_id, risk_control_id, version_no, version_user, version_date)
VALUES
('cksylzwsa000465ocp78e8vlt', NULL, 'Low', 'Green', 1, 'Risk of no major concern but can be monitored', 'cksg348i902230umthg4v8xck', 'ckshesonv28500uogpaweun2z', 'TXN_0001', 1, 'SYSTEM', '2021-08-30 12:19:44.699'),
('cksylzx46001165ocv5vzbxnz', NULL, 'Low', 'Green', 2, 'Risk of no major concern but can be monitored', 'cksg34rs302370umto20er0s6', 'ckshesonv28500uogpaweun2z', 'TXN_0001', 1, 'SYSTEM', '2021-08-30 12:19:45.126'),
('cksylzxc8001765oc4pquvm4a', NULL, 'Low', 'Green', 3, 'Risk of no major concern but can be monitored', 'cksg34rsi02460umt7zz4nrra', 'ckshesonv28500uogpaweun2z', 'TXN_0001', 1, 'SYSTEM', '2021-08-30 12:19:45.416'),
('cksylzxm4002465ocqgqw59lx', NULL, 'Low', 'Green', 4, 'Risk of no major concern but can be monitored', 'cksg34rst02560umtn6x71pl5', 'ckshesonv28500uogpaweun2z', 'TXN_0001', 1, 'SYSTEM', '2021-08-30 12:19:45.772'),
('cksylzy39003765oc1h9rg6jr', NULL, 'Low', 'Green', 2, 'Risk of no major concern but can be monitored', 'cksg348i902230umthg4v8xck', 'ckshesoot28840uog26lww25a', 'TXN_0001', 1, 'SYSTEM', '2021-08-30 12:19:46.390'),
('cksylzygh004465ocnud3o34l', NULL, 'Low', 'Green', 4, 'Risk of no major concern but can be monitored', 'cksg34rs302370umto20er0s6', 'ckshesoot28840uog26lww25a', 'TXN_0001', 1, 'SYSTEM', '2021-08-30 12:19:46.865'),
('cksylzyou005165ocxbh18xkd', NULL, 'Low', 'Green', 6, 'Risk of no major concern but can be monitored', 'cksg34rsi02460umt7zz4nrra', 'ckshesoot28840uog26lww25a', 'TXN_0001', 1, 'SYSTEM', '2021-08-30 12:19:47.167'),
('cksylzyxh005765ocbr3llw8u', NULL, 'Moderate', 'Yellow', 8, 'Risk of no concern but requires periodic monitoring', 'cksg34rst02560umtn6x71pl5', 'ckshesoot28840uog26lww25a', 'TXN_0001', 1, 'SYSTEM', '2021-08-30 12:19:47.478'),
('cksylzzgs007065ocat2yep7b', NULL, 'Low', 'Green', 3, 'Risk of no major concern but can be monitored', 'cksg348i902230umthg4v8xck', 'ckshesopi29170uog6tw6bamy', 'TXN_0001', 1, 'SYSTEM', '2021-08-30 12:19:48.173'),
('cksylzzom007665ocdtnfnkrf', NULL, 'Low', 'Green', 6, 'Risk of no major concern but can be monitored', 'cksg34rs302370umto20er0s6', 'ckshesopi29170uog6tw6bamy', 'TXN_0001', 1, 'SYSTEM', '2021-08-30 12:19:48.455'),
('cksylzzxf008265ocp8032t23', NULL, 'Moderate', 'Yellow', 9, 'Risk of no concern but requires periodic monitoring', 'cksg34rsi02460umt7zz4nrra', 'ckshesopi29170uog6tw6bamy', 'TXN_0001', 1, 'SYSTEM', '2021-08-30 12:19:48.772'),
('cksym00he009465ocsf54bdp3', NULL, 'High', 'Red', 15, 'Risk of major concern and requires active review', 'cksg34rt302660umt8k8asb3o', 'ckshesopi29170uog6tw6bamy', 'TXN_0001', 1, 'SYSTEM', '2021-08-30 12:19:49.490'),
('cksym00pf010065oc9vjhk97j', NULL, 'Low', 'Green', 4, 'Risk of no major concern but can be monitored', 'cksg348i902230umthg4v8xck', 'ckshesoq229520uoglclnaust', 'TXN_0001', 1, 'SYSTEM', '2021-08-30 12:19:49.780'),
('cksym0141010765oc3lp5hbf6', NULL, 'Moderate', 'Yellow', 8, 'Risk of no concern but requires periodic monitoring', 'cksg34rs302370umto20er0s6', 'ckshesoq229520uoglclnaust', 'TXN_0001', 1, 'SYSTEM', '2021-08-30 12:19:50.306'),
('cksym01x8012065ocwac3q99u', NULL, 'High', 'Red', 16, 'Risk of major concern and requires active review', 'cksg34rst02560umtn6x71pl5', 'ckshesoq229520uoglclnaust', 'TXN_0001', 1, 'SYSTEM', '2021-08-30 12:19:51.356'),
('cksym02ew012665oc80i4ibs1', NULL, 'High', 'Red', 20, 'Risk of major concern and requires active review', 'cksg34rt302660umt8k8asb3o', 'ckshesoq229520uoglclnaust', 'TXN_0001', 1, 'SYSTEM', '2021-08-30 12:19:51.993'),
('cksym03mw014465ocswr5zc55', NULL, 'High', 'Red', 15, 'Risk of major concern and requires active review', 'cksg34rsi02460umt7zz4nrra', 'ckshesors29860uogd8sdk0w8', 'TXN_0001', 1, 'SYSTEM', '2021-08-30 12:19:53.577'),
('cksylzxus003165ocsfdnoorg', NULL, 'Moderate', 'Yellow', 5, 'Risk of no concern but requires periodic monitoring', 'cksg34rt302660umt8k8asb3o', 'ckshesonv28500uogpaweun2z', 'TXN_0001', 1, 'SYSTEM', '2021-08-30 12:19:46.084'),
('cksym03uy015165oc5k65ecim', NULL, 'High', 'Red', 20, 'Risk of major concern and require active review', 'cksg34rst02560umtn6x71pl5', 'ckshesors29860uogd8sdk0w8', 'TXN_0001', 1, 'SYSTEM', '2021-08-30 12:19:53.867'),
('cksym043t015765oc3w6kcvsr', NULL, 'High', 'Red', 25, 'Risk of major concern and require active review', 'cksg34rt302660umt8k8asb3o', 'ckshesors29860uogd8sdk0w8', 'TXN_0001', 1, 'SYSTEM', '2021-08-30 12:19:54.186'),
('cksylzz6f006465oc14cntln7', NULL, 'Significant', 'Orange', 10, 'Risk of concern and requires continuous review', 'cksg34rt302660umt8k8asb3o', 'ckshesoot28840uog26lww25a', 'TXN_0001', 1, 'SYSTEM', '2021-08-30 12:19:47.800'),
('cksym006z008865ocof93zdly', NULL, 'Significant', 'Orange', 12, 'Risk of concern and requires continuous review', 'cksg34rst02560umtn6x71pl5', 'ckshesopi29170uog6tw6bamy', 'TXN_0001', 1, 'SYSTEM', '2021-08-30 12:19:49.115'),
('cksym01kk011365ocb01yfyss', NULL, 'Significant', 'Orange', 12, 'Risk of concern and requires continuous review', 'cksg34rsi02460umt7zz4nrra', 'ckshesoq229520uoglclnaust', 'TXN_0001', 1, 'SYSTEM', '2021-08-30 12:19:50.900'),
('cksym02u8013265ocrkn9ojgk', NULL, 'Significant', 'Orange', 5, 'Risk of concern and requires continuous review', 'cksg348i902230umthg4v8xck', 'ckshesors29860uogd8sdk0w8', 'TXN_0001', 1, 'SYSTEM', '2021-08-30 12:19:52.545'),
('cksym038i013865ocwbs5wpgd', NULL, 'Significant', 'Orange', 10, 'Risk of concern and requires continuous review', 'cksg34rs302370umto20er0s6', 'ckshesors29860uogd8sdk0w8', 'TXN_0001', 1, 'SYSTEM', '2021-08-30 12:19:53.058');



INSERT INTO public."FileNumberConf"
(id, tenant_id, period_start, period_end, no_of_components, delimeter, version_no, version_user, version_date)
VALUES('FNC_1', 'TEN1', NOW(), NOW(), 7, '-', 1, 'SYSTEM'::text, NOW());


INSERT INTO public."FileNumberComponentDef"
(id, tenant_id, sno, component, component_size, component_type, filenumber_config_id)
VALUES
('FNCD_1', 'TEN1', 1, 'Audit Classification', 1, 'Number', 'FNC_1'),
('FNCD_2', 'TEN1', 2, 'Audit type', 1, 'Number', 'FNC_1'),
('FNCD_3', 'TEN1', 3, 'Audit Domain', 1, 'Number', 'FNC_1'),
('FNCD_4', 'TEN1', 4, 'Audit Subject', 2, 'Number', 'FNC_1'),
('FNCD_5', 'TEN1', 5, 'Vote', 3, 'Number', 'FNC_1'),
('FNCD_6', 'TEN1', 6, 'Year', 4, 'Number', 'FNC_1'),
('FNCD_7', 'TEN1', 7, 'Audit number serially', 2, 'Number', 'FNC_1');


INSERT INTO public."HolidayMaster"
(id, tenant_id, "name", "ref", fin_year, "from", "to", no_of_days, description, is_active, version_no, version_user, version_date)
VALUES
('ckuclbu2d0000nd125e924ryu', 'TEN1', 'New Year''s Day', 'ckuclbu2e0001nd12gbajzr6w', '2021', '2021-01-01 00:00:00.000', '2021-01-01 23:59:59.599', 1.000000000000000000000000000000, NULL, true, 1, 'SYSTEM', '2021-10-04 11:49:30.231'),
('ckucld4e20011nd122gzmolpf', 'TEN1', 'Chilembwe Day', 'ckucld4e20010nd12t21kmsce', '2021', '2021-01-15 00:00:00.000', '2021-01-15 23:59:59.599', 1.000000000000000000000000000000, NULL, true, 1, 'SYSTEM', '2021-10-04 11:50:30.267'),
('ckucldyus0021nd12pov2gzxj', 'TEN1', 'Martyrs'' Day', 'ckucldyus0020nd12vjqfrqg8', '2021', '2021-03-03 00:00:00.000', '2021-03-03 23:59:59.599', 1.000000000000000000000000000000, NULL, true, 1, 'SYSTEM', '2021-10-04 11:51:09.749'),
('ckuclexbl0031nd12c4480ltp', 'TEN1', 'Good Friday', 'ckuclexbl0030nd12ey3q273g', '2021', '2021-04-02 00:00:00.000', '2021-04-02 23:59:59.599', 1.000000000000000000000000000000, NULL, true, 1, 'SYSTEM', '2021-10-04 11:51:54.417'),
('ckuclflyn0041nd12xnbqkrkr', 'TEN1', 'Easter Monday', 'ckuclflyn0040nd12q7w4rw75', '2021', '2021-04-05 00:00:00.000', '2021-04-05 23:59:59.599', 1.000000000000000000000000000000, NULL, true, 1, 'SYSTEM', '2021-10-04 11:52:26.352'),
('ck1clbu2d0000nd125e924ryu', 'TEN1', 'Eid-al-Fitr', 'ckuclbu2e0001nd12gbajzr6w', '2021', '2021-05-13 00:00:00.000', '2021-05-13 23:59:59.599', 1.000000000000000000000000000000, NULL, true, 1, 'SYSTEM', '2021-10-04 11:49:30.231'),
('ck2clbu2d0000nd125e924ryu', 'TEN1', 'Freedom Day', 'ckuclbu2e0001nd12gbajzr6w', '2021', '2021-06-14 00:00:00.000', '2021-06-14 23:59:59.599', 1.000000000000000000000000000000, NULL, true, 1, 'SYSTEM', '2021-10-04 11:49:30.231'),
('c3uclbu2d0000nd125e924ryu', 'TEN1', 'Republic Day', 'ckuclbu2e0001nd12gbajzr6w', '2021', '2021-07-06 00:00:00.000', '2021-07-06 23:59:59.599', 1.000000000000000000000000000000, NULL, true, 1, 'SYSTEM', '2021-10-04 11:49:30.231'),
('ck4clbu2d0000nd125e924ryu', 'TEN1', 'Christmas Day', 'ckuclbu2e0001nd12gbajzr6w', '2021', '2021-12-25 00:00:00.000', '2021-12-25 23:59:59.599', 1.000000000000000000000000000000, NULL, true, 1, 'SYSTEM', '2021-10-04 11:49:30.231'),
('ck5clbs2d0000nd125e924ryu', 'TEN1', 'Labour Day', 'ckuclbu2e0001nd12gbajzr6w', '2021', '2021-05-01 00:00:00.000', '2021-05-01 23:59:59.599', 1.000000000000000000000000000000, NULL, true, 1, 'SYSTEM', '2021-10-04 11:49:30.231'),
('ck5clfs2d0000nd125e924ryu', 'TEN1', 'Mother''s Day', 'ckuclbu2e0001nd12gbajzr6w', '2021', '2021-10-11 00:00:00.000', '2021-10-11 23:59:59.599', 1.000000000000000000000000000000, NULL, true, 1, 'SYSTEM', '2021-10-04 11:49:30.231'),
('ck5clfd2d0000nd125e924ryu', 'TEN1', 'Boxing Day', 'ckuclbu2e0001nd12gbajzr6w', '2021', '2021-12-26 00:00:00.000', '2021-12-26 23:59:59.599', 1.000000000000000000000000000000, NULL, true, 1, 'SYSTEM', '2021-10-04 11:49:30.231');

INSERT INTO public."WeekendConf"
(id, tenant_id, days, fin_year, no_of_days, is_active, version_no, version_user, version_date)
VALUES
('ckucroj4l0000o912uf0lv9my', 'TEN1', 'SATURDAY,SUNDAY', '2021', 2.000000000000000000000000000000, true, 1, 'SYSTEM', '2021-10-04 14:47:20.278'),
('ckuroj4l0000o912uf0lv9my', 'TEN1', 'SATURDAY,SUNDAY', '2022', 2.000000000000000000000000000000, true, 1, 'SYSTEM', '2021-10-04 14:47:20.278');


INSERT INTO public."AssignmentActivity"
(id, tenant_id, audit_type, name, "order")
VALUES
('COMMENCEMENT', 'TEN1', '{"SCHEDULE_AUDIT","ADHOC_AUDIT","FOLLOW_UP_AUDIT","CONSULTING_ASSIGNMENT_AUDIT"}', 'Audit Resources and Schedule', 0),
('REQUEST_LIST_RESP', 'TEN1', '{"SCHEDULE_AUDIT","ADHOC_AUDIT","FOLLOW_UP_AUDIT","CONSULTING_ASSIGNMENT_AUDIT"}', 'Request List Response', 10),
('SUMMARY_AUDITABLE_AREA', 'TEN1', '{"SCHEDULE_AUDIT","ADHOC_AUDIT","CONSULTING_ASSIGNMENT_AUDIT"}', 'Summary Auditable Area', 20),
('SUMMARY_AUDITABLE_SUBJECT', 'TEN1', '{"SCHEDULE_AUDIT","ADHOC_AUDIT","CONSULTING_ASSIGNMENT_AUDIT"}', 'Summary Audit Subject', 30),
('AUDIT_SCOPE', 'TEN1', '{"SCHEDULE_AUDIT","ADHOC_AUDIT"}', 'Audit Scope', 40),
('INHERENT_RISK_ASSESSMENT', 'TEN1', '{"SCHEDULE_AUDIT","ADHOC_AUDIT"}', 'Inherent Risk', 50),
('CONTROL_ASSESSMENT', 'TEN1', '{"SCHEDULE_AUDIT","ADHOC_AUDIT"}', 'Control Assessment', 60),
('RESIDUAL_RISK_ASSESSMENT', 'TEN1', '{"SCHEDULE_AUDIT","ADHOC_AUDIT"}', 'Residual Risk Assessment', 70),
('RISK_ASSESSMENT_CONCLUSION', 'TEN1', '{"SCHEDULE_AUDIT","ADHOC_AUDIT"}', 'Risk Assessment Conclusion', 80),
('AUDIT_ASSIGNMENT_PLAN', 'TEN1', '{"SCHEDULE_AUDIT","ADHOC_AUDIT"}', 'Audit Assignment Plan', 90),
('AUDIT_PROGRAM', 'TEN1', '{"SCHEDULE_AUDIT","ADHOC_AUDIT","FOLLOW_UP_AUDIT"}', 'Audit Program', 100),
('AUDIT_TEST_RESULTS', 'TEN1', '{"SCHEDULE_AUDIT","ADHOC_AUDIT","FOLLOW_UP_AUDIT"}', 'Audit Test Results', 110),
('AUDIT_FINDINGS', 'TEN1', '{"SCHEDULE_AUDIT","ADHOC_AUDIT","FOLLOW_UP_AUDIT"}', 'Audit Findings', 120),
('ENGAGEMENT_REPORTS', 'TEN1', '{"CONSULTING_ASSIGNMENT_AUDIT"}', 'Engagement Reports', 130),
('AUDIT_MEETINGS', 'TEN1', '{"SCHEDULE_AUDIT","ADHOC_AUDIT","FOLLOW_UP_AUDIT","CONSULTING_ASSIGNMENT_AUDIT"}', 'Audit Meetings', 140),
('REPORT_ACTUALS', 'TEN1', '{"SCHEDULE_AUDIT","ADHOC_AUDIT","CONSULTING_ASSIGNMENT_AUDIT"}', 'Report Actuals', 150),
('AUDIT_CLOSURE_FORM', 'TEN1', '{"SCHEDULE_AUDIT","ADHOC_AUDIT"}', 'Audit Closure Form', 160),
('REPORT', 'TEN1', '{"SCHEDULE_AUDIT","ADHOC_AUDIT","FOLLOW_UP_AUDIT","CONSULTING_ASSIGNMENT_AUDIT"}', 'Reports', 170);
