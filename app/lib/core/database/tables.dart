import 'package:drift/drift.dart';

class Systems extends Table {
  @override
  String get tableName => 'systems';

  TextColumn get id => text().clientDefault(
    () => DateTime.now().millisecondsSinceEpoch.toString(),
  )();
  TextColumn get displayName => text()();
  TextColumn get pronounsExternal => text().nullable()();
  TextColumn get languagePrimary => text().withDefault(const Constant('de'))();
  TextColumn get languageSecondary =>
      text().withDefault(const Constant('en'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('PartsData')
class Parts extends Table {
  @override
  String get tableName => 'parts';

  TextColumn get id => text().clientDefault(
    () => DateTime.now().millisecondsSinceEpoch.toString(),
  )();
  TextColumn get displayName => text().nullable()();
  TextColumn get pronouns => text().nullable()();
  TextColumn get apparentAge => text().nullable()();
  TextColumn get role => text().nullable()();
  TextColumn get descriptionInternal => text().nullable()();
  TextColumn get descriptionExternal => text().nullable()();
  TextColumn get visibility => text().withDefault(const Constant('Internal'))();
  TextColumn get status => text().withDefault(const Constant('Active'))();
  TextColumn get integratedInto => text().nullable()();
  DateTimeColumn get emergedAt => dateTime().nullable()();
  TextColumn get emergenceContext => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('SwitchEventsData')
class SwitchEvents extends Table {
  @override
  String get tableName => 'switch_events';

  TextColumn get id => text().clientDefault(
    () => DateTime.now().millisecondsSinceEpoch.toString(),
  )();
  TextColumn get partId => text().references(Parts, #id)();
  DateTimeColumn get timestamp => dateTime().withDefault(currentDateAndTime)();
  TextColumn get markedBy =>
      text().withDefault(const Constant('SelfCheckin'))();
  TextColumn get contextTags => text().nullable()();
  TextColumn get note => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ConsentProfileData')
class ConsentProfiles extends Table {
  @override
  String get tableName => 'consent_profiles';

  TextColumn get partId => text().references(Parts, #id)();

  TextColumn get touchGeneral =>
      text().withDefault(const Constant('Unknown'))();
  TextColumn get touchIntimate =>
      text().withDefault(const Constant('Unknown'))();
  TextColumn get kiss => text().withDefault(const Constant('Unknown'))();
  TextColumn get petNames => text().withDefault(const Constant('Unknown'))();
  TextColumn get sexualActivity =>
      text().withDefault(const Constant('Unknown'))();

  TextColumn get driving => text().withDefault(const Constant('Unknown'))();
  TextColumn get alcohol => text().withDefault(const Constant('Unknown'))();
  TextColumn get decisionsFinancial =>
      text().withDefault(const Constant('Unknown'))();
  TextColumn get decisionsMedical =>
      text().withDefault(const Constant('Unknown'))();

  TextColumn get notes => text().nullable()();
  DateTimeColumn get lastReviewed =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {partId};
}

@DataClassName('TriggerEntryData')
class TriggerEntries extends Table {
  @override
  String get tableName => 'trigger_entries';

  TextColumn get id => text().clientDefault(
    () => DateTime.now().millisecondsSinceEpoch.toString(),
  )();
  TextColumn get partId => text().references(Parts, #id)();
  TextColumn get type => text().withDefault(const Constant('Other'))();
  TextColumn get description => text()();
  TextColumn get severity => text().withDefault(const Constant('Moderate'))();
  TextColumn get copingSuggestion => text().nullable()();
  BoolColumn get appliesExternally =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('EmergencyContactData')
class EmergencyContacts extends Table {
  @override
  String get tableName => 'emergency_contacts';

  TextColumn get id => text().clientDefault(
    () => DateTime.now().millisecondsSinceEpoch.toString(),
  )();
  IntColumn get rank => integer().withDefault(const Constant(0))();
  TextColumn get name => text()();
  TextColumn get relationship => text()();
  TextColumn get phone => text()();
  TextColumn get email => text().nullable()();
  BoolColumn get knowsAboutDiagnosis =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get knowsAboutParts =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get knowsAboutTrauma =>
      boolean().withDefault(const Constant(false))();
  TextColumn get preferredContactMethod =>
      text().withDefault(const Constant('Phone'))();
  TextColumn get availableHours => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('MedicalRecordData')
class MedicalRecords extends Table {
  @override
  String get tableName => 'medical_records';

  TextColumn get id => text().clientDefault(
    () => DateTime.now().millisecondsSinceEpoch.toString(),
  )();
  TextColumn get bloodType => text().nullable()();
  TextColumn get allergies => text().nullable()();
  TextColumn get medications => text().nullable()();
  TextColumn get diagnoses => text().nullable()();
  TextColumn get primaryPhysician => text().nullable()();
  TextColumn get healthInsuranceProvider => text().nullable()();
  TextColumn get healthInsuranceMemberId => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
