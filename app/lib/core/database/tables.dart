import 'package:drift/drift.dart';

class Systems extends Table {
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

class Parts extends Table {
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
