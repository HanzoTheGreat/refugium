import 'dart:io';
import 'dart:math';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlcipher_flutter_libs/sqlcipher_flutter_libs.dart';
import 'package:sqlite3/open.dart' as sqlite_open;
import 'tables.dart';

part 'database.g.dart';

const _keyName = 'refugium_db_key';
const _keyLength = 32;

Future<String> _getOrCreateKey() async {
  const storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
  final existing = await storage.read(key: _keyName);
  if (existing != null) return existing;

  final rng = Random.secure();
  final bytes = List<int>.generate(_keyLength, (_) => rng.nextInt(256));
  final key = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  await storage.write(key: _keyName, value: key);
  return key;
}

@DriftDatabase(
  tables: [
    Systems,
    Parts,
    SwitchEvents,
    ConsentProfiles,
    TriggerEntries,
    EmergencyContacts,
    MedicalRecords,
    JournalEntries,
    Connections,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 8;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      if (from < 2) await m.createTable(switchEvents);
      if (from < 3) await m.createTable(consentProfiles);
      if (from < 4) await m.createTable(triggerEntries);
      if (from < 5) await m.createTable(emergencyContacts);
      if (from < 6) await m.createTable(medicalRecords);
      if (from < 7) await m.createTable(journalEntries);
      if (from < 8) await m.createTable(connections);
    },
  );

  static Future<AppDatabase> open() async {
    applyWorkaroundToOpenSqlCipherOnOldAndroidVersions();
    sqlite_open.open.overrideFor(
      sqlite_open.OperatingSystem.android,
      openCipherOnAndroid,
    );

    final key = await _getOrCreateKey();
    final dbFolder = await getApplicationDocumentsDirectory();
    final dbFile = File(p.join(dbFolder.path, 'refugium.db'));

    return AppDatabase(
      NativeDatabase(
        dbFile,
        setup: (db) {
          db.execute("PRAGMA key = '$key';");
        },
      ),
    );
  }
}
