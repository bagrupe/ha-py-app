import 'package:app/common/keys.dart';
import 'package:app/routes/melder/common/report_workflow_config.dart';

/// Shared configuration for the defects reporting workflow.
const maengelMelderConfig = ReportWorkflowConfig(
  tag: 'Mängelmelder',
  overviewRoute: '/karte/maengel/uebersicht/meine',
  stepRoute: '/karte/maengel/schritt',
  detailRoutePrefix: '/karte/maengel/detail/',
  titleKey: 'application.melder.maengel.title',
  completedTextKey: 'application.melder.maengel.completed',
  completionButtonTextKey: 'application.melder.maengel.submit',
  addButtonLabelKey: 'application.melder.maengel.add',
  reportedTitleKey: 'application.melder.maengel.reported_title',
  addButtonKey: K.addMangel,
  emptyMessageKey: 'application.melder.maengel.empty',
  errorMessageKey: 'application.melder.maengel.error',
);

/// Shared configuration for the ideas reporting workflow.
const ideaReporterConfig = ReportWorkflowConfig(
  tag: 'Ideenmelder',
  overviewRoute: '/karte/ideahub/uebersicht/meine',
  stepRoute: '/karte/ideahub/schritt',
  detailRoutePrefix: '/karte/idea/detail/',
  titleKey: 'application.melder.ideas.title',
  completedTextKey: 'application.melder.ideas.completed',
  completionButtonTextKey: 'application.melder.ideas.submit',
  addButtonLabelKey: 'application.melder.ideas.add',
  reportedTitleKey: 'application.melder.ideas.reported_title',
  addButtonKey: K.ideahub,
  emptyMessageKey: 'application.melder.ideas.empty',
  errorMessageKey: 'application.melder.ideas.error',
);
