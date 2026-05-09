import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [Systems, Parts, SwitchEvents, ConsentProfiles, TriggerEntries],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openDatabase());

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      if (from < 2) await m.createTable(switchEvents);
      if (from < 3) await m.createTable(consentProfiles);
      if (from < 4) await m.createTable(triggerEntries);
    },
  );

  static QueryExecutor _openDatabase() {
    return driftDatabase(name: 'refugium_db');
  }
}
