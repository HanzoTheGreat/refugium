// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $SystemsTable extends Systems with TableInfo<$SystemsTable, System> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SystemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now().millisecondsSinceEpoch.toString(),
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pronounsExternalMeta = const VerificationMeta(
    'pronounsExternal',
  );
  @override
  late final GeneratedColumn<String> pronounsExternal = GeneratedColumn<String>(
    'pronouns_external',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _languagePrimaryMeta = const VerificationMeta(
    'languagePrimary',
  );
  @override
  late final GeneratedColumn<String> languagePrimary = GeneratedColumn<String>(
    'language_primary',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('de'),
  );
  static const VerificationMeta _languageSecondaryMeta = const VerificationMeta(
    'languageSecondary',
  );
  @override
  late final GeneratedColumn<String> languageSecondary =
      GeneratedColumn<String>(
        'language_secondary',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('en'),
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    displayName,
    pronounsExternal,
    languagePrimary,
    languageSecondary,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'systems';
  @override
  VerificationContext validateIntegrity(
    Insertable<System> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('pronouns_external')) {
      context.handle(
        _pronounsExternalMeta,
        pronounsExternal.isAcceptableOrUnknown(
          data['pronouns_external']!,
          _pronounsExternalMeta,
        ),
      );
    }
    if (data.containsKey('language_primary')) {
      context.handle(
        _languagePrimaryMeta,
        languagePrimary.isAcceptableOrUnknown(
          data['language_primary']!,
          _languagePrimaryMeta,
        ),
      );
    }
    if (data.containsKey('language_secondary')) {
      context.handle(
        _languageSecondaryMeta,
        languageSecondary.isAcceptableOrUnknown(
          data['language_secondary']!,
          _languageSecondaryMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  System map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return System(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      pronounsExternal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pronouns_external'],
      ),
      languagePrimary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language_primary'],
      )!,
      languageSecondary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language_secondary'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SystemsTable createAlias(String alias) {
    return $SystemsTable(attachedDatabase, alias);
  }
}

class System extends DataClass implements Insertable<System> {
  final String id;
  final String displayName;
  final String? pronounsExternal;
  final String languagePrimary;
  final String languageSecondary;
  final DateTime createdAt;
  const System({
    required this.id,
    required this.displayName,
    this.pronounsExternal,
    required this.languagePrimary,
    required this.languageSecondary,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['display_name'] = Variable<String>(displayName);
    if (!nullToAbsent || pronounsExternal != null) {
      map['pronouns_external'] = Variable<String>(pronounsExternal);
    }
    map['language_primary'] = Variable<String>(languagePrimary);
    map['language_secondary'] = Variable<String>(languageSecondary);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SystemsCompanion toCompanion(bool nullToAbsent) {
    return SystemsCompanion(
      id: Value(id),
      displayName: Value(displayName),
      pronounsExternal: pronounsExternal == null && nullToAbsent
          ? const Value.absent()
          : Value(pronounsExternal),
      languagePrimary: Value(languagePrimary),
      languageSecondary: Value(languageSecondary),
      createdAt: Value(createdAt),
    );
  }

  factory System.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return System(
      id: serializer.fromJson<String>(json['id']),
      displayName: serializer.fromJson<String>(json['displayName']),
      pronounsExternal: serializer.fromJson<String?>(json['pronounsExternal']),
      languagePrimary: serializer.fromJson<String>(json['languagePrimary']),
      languageSecondary: serializer.fromJson<String>(json['languageSecondary']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'displayName': serializer.toJson<String>(displayName),
      'pronounsExternal': serializer.toJson<String?>(pronounsExternal),
      'languagePrimary': serializer.toJson<String>(languagePrimary),
      'languageSecondary': serializer.toJson<String>(languageSecondary),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  System copyWith({
    String? id,
    String? displayName,
    Value<String?> pronounsExternal = const Value.absent(),
    String? languagePrimary,
    String? languageSecondary,
    DateTime? createdAt,
  }) => System(
    id: id ?? this.id,
    displayName: displayName ?? this.displayName,
    pronounsExternal: pronounsExternal.present
        ? pronounsExternal.value
        : this.pronounsExternal,
    languagePrimary: languagePrimary ?? this.languagePrimary,
    languageSecondary: languageSecondary ?? this.languageSecondary,
    createdAt: createdAt ?? this.createdAt,
  );
  System copyWithCompanion(SystemsCompanion data) {
    return System(
      id: data.id.present ? data.id.value : this.id,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      pronounsExternal: data.pronounsExternal.present
          ? data.pronounsExternal.value
          : this.pronounsExternal,
      languagePrimary: data.languagePrimary.present
          ? data.languagePrimary.value
          : this.languagePrimary,
      languageSecondary: data.languageSecondary.present
          ? data.languageSecondary.value
          : this.languageSecondary,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('System(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('pronounsExternal: $pronounsExternal, ')
          ..write('languagePrimary: $languagePrimary, ')
          ..write('languageSecondary: $languageSecondary, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    displayName,
    pronounsExternal,
    languagePrimary,
    languageSecondary,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is System &&
          other.id == this.id &&
          other.displayName == this.displayName &&
          other.pronounsExternal == this.pronounsExternal &&
          other.languagePrimary == this.languagePrimary &&
          other.languageSecondary == this.languageSecondary &&
          other.createdAt == this.createdAt);
}

class SystemsCompanion extends UpdateCompanion<System> {
  final Value<String> id;
  final Value<String> displayName;
  final Value<String?> pronounsExternal;
  final Value<String> languagePrimary;
  final Value<String> languageSecondary;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const SystemsCompanion({
    this.id = const Value.absent(),
    this.displayName = const Value.absent(),
    this.pronounsExternal = const Value.absent(),
    this.languagePrimary = const Value.absent(),
    this.languageSecondary = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SystemsCompanion.insert({
    this.id = const Value.absent(),
    required String displayName,
    this.pronounsExternal = const Value.absent(),
    this.languagePrimary = const Value.absent(),
    this.languageSecondary = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : displayName = Value(displayName);
  static Insertable<System> custom({
    Expression<String>? id,
    Expression<String>? displayName,
    Expression<String>? pronounsExternal,
    Expression<String>? languagePrimary,
    Expression<String>? languageSecondary,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (displayName != null) 'display_name': displayName,
      if (pronounsExternal != null) 'pronouns_external': pronounsExternal,
      if (languagePrimary != null) 'language_primary': languagePrimary,
      if (languageSecondary != null) 'language_secondary': languageSecondary,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SystemsCompanion copyWith({
    Value<String>? id,
    Value<String>? displayName,
    Value<String?>? pronounsExternal,
    Value<String>? languagePrimary,
    Value<String>? languageSecondary,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return SystemsCompanion(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      pronounsExternal: pronounsExternal ?? this.pronounsExternal,
      languagePrimary: languagePrimary ?? this.languagePrimary,
      languageSecondary: languageSecondary ?? this.languageSecondary,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (pronounsExternal.present) {
      map['pronouns_external'] = Variable<String>(pronounsExternal.value);
    }
    if (languagePrimary.present) {
      map['language_primary'] = Variable<String>(languagePrimary.value);
    }
    if (languageSecondary.present) {
      map['language_secondary'] = Variable<String>(languageSecondary.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SystemsCompanion(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('pronounsExternal: $pronounsExternal, ')
          ..write('languagePrimary: $languagePrimary, ')
          ..write('languageSecondary: $languageSecondary, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PartsTable extends Parts with TableInfo<$PartsTable, PartsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PartsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now().millisecondsSinceEpoch.toString(),
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pronounsMeta = const VerificationMeta(
    'pronouns',
  );
  @override
  late final GeneratedColumn<String> pronouns = GeneratedColumn<String>(
    'pronouns',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _apparentAgeMeta = const VerificationMeta(
    'apparentAge',
  );
  @override
  late final GeneratedColumn<String> apparentAge = GeneratedColumn<String>(
    'apparent_age',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionInternalMeta =
      const VerificationMeta('descriptionInternal');
  @override
  late final GeneratedColumn<String> descriptionInternal =
      GeneratedColumn<String>(
        'description_internal',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _descriptionExternalMeta =
      const VerificationMeta('descriptionExternal');
  @override
  late final GeneratedColumn<String> descriptionExternal =
      GeneratedColumn<String>(
        'description_external',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _visibilityMeta = const VerificationMeta(
    'visibility',
  );
  @override
  late final GeneratedColumn<String> visibility = GeneratedColumn<String>(
    'visibility',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Internal'),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Active'),
  );
  static const VerificationMeta _integratedIntoMeta = const VerificationMeta(
    'integratedInto',
  );
  @override
  late final GeneratedColumn<String> integratedInto = GeneratedColumn<String>(
    'integrated_into',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emergedAtMeta = const VerificationMeta(
    'emergedAt',
  );
  @override
  late final GeneratedColumn<DateTime> emergedAt = GeneratedColumn<DateTime>(
    'emerged_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emergenceContextMeta = const VerificationMeta(
    'emergenceContext',
  );
  @override
  late final GeneratedColumn<String> emergenceContext = GeneratedColumn<String>(
    'emergence_context',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    displayName,
    pronouns,
    apparentAge,
    role,
    descriptionInternal,
    descriptionExternal,
    visibility,
    status,
    integratedInto,
    emergedAt,
    emergenceContext,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'parts';
  @override
  VerificationContext validateIntegrity(
    Insertable<PartsData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    }
    if (data.containsKey('pronouns')) {
      context.handle(
        _pronounsMeta,
        pronouns.isAcceptableOrUnknown(data['pronouns']!, _pronounsMeta),
      );
    }
    if (data.containsKey('apparent_age')) {
      context.handle(
        _apparentAgeMeta,
        apparentAge.isAcceptableOrUnknown(
          data['apparent_age']!,
          _apparentAgeMeta,
        ),
      );
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    }
    if (data.containsKey('description_internal')) {
      context.handle(
        _descriptionInternalMeta,
        descriptionInternal.isAcceptableOrUnknown(
          data['description_internal']!,
          _descriptionInternalMeta,
        ),
      );
    }
    if (data.containsKey('description_external')) {
      context.handle(
        _descriptionExternalMeta,
        descriptionExternal.isAcceptableOrUnknown(
          data['description_external']!,
          _descriptionExternalMeta,
        ),
      );
    }
    if (data.containsKey('visibility')) {
      context.handle(
        _visibilityMeta,
        visibility.isAcceptableOrUnknown(data['visibility']!, _visibilityMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('integrated_into')) {
      context.handle(
        _integratedIntoMeta,
        integratedInto.isAcceptableOrUnknown(
          data['integrated_into']!,
          _integratedIntoMeta,
        ),
      );
    }
    if (data.containsKey('emerged_at')) {
      context.handle(
        _emergedAtMeta,
        emergedAt.isAcceptableOrUnknown(data['emerged_at']!, _emergedAtMeta),
      );
    }
    if (data.containsKey('emergence_context')) {
      context.handle(
        _emergenceContextMeta,
        emergenceContext.isAcceptableOrUnknown(
          data['emergence_context']!,
          _emergenceContextMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PartsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PartsData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      ),
      pronouns: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pronouns'],
      ),
      apparentAge: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}apparent_age'],
      ),
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      ),
      descriptionInternal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description_internal'],
      ),
      descriptionExternal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description_external'],
      ),
      visibility: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}visibility'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      integratedInto: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}integrated_into'],
      ),
      emergedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}emerged_at'],
      ),
      emergenceContext: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}emergence_context'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PartsTable createAlias(String alias) {
    return $PartsTable(attachedDatabase, alias);
  }
}

class PartsData extends DataClass implements Insertable<PartsData> {
  final String id;
  final String? displayName;
  final String? pronouns;
  final String? apparentAge;
  final String? role;
  final String? descriptionInternal;
  final String? descriptionExternal;
  final String visibility;
  final String status;
  final String? integratedInto;
  final DateTime? emergedAt;
  final String? emergenceContext;
  final DateTime createdAt;
  final DateTime updatedAt;
  const PartsData({
    required this.id,
    this.displayName,
    this.pronouns,
    this.apparentAge,
    this.role,
    this.descriptionInternal,
    this.descriptionExternal,
    required this.visibility,
    required this.status,
    this.integratedInto,
    this.emergedAt,
    this.emergenceContext,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || displayName != null) {
      map['display_name'] = Variable<String>(displayName);
    }
    if (!nullToAbsent || pronouns != null) {
      map['pronouns'] = Variable<String>(pronouns);
    }
    if (!nullToAbsent || apparentAge != null) {
      map['apparent_age'] = Variable<String>(apparentAge);
    }
    if (!nullToAbsent || role != null) {
      map['role'] = Variable<String>(role);
    }
    if (!nullToAbsent || descriptionInternal != null) {
      map['description_internal'] = Variable<String>(descriptionInternal);
    }
    if (!nullToAbsent || descriptionExternal != null) {
      map['description_external'] = Variable<String>(descriptionExternal);
    }
    map['visibility'] = Variable<String>(visibility);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || integratedInto != null) {
      map['integrated_into'] = Variable<String>(integratedInto);
    }
    if (!nullToAbsent || emergedAt != null) {
      map['emerged_at'] = Variable<DateTime>(emergedAt);
    }
    if (!nullToAbsent || emergenceContext != null) {
      map['emergence_context'] = Variable<String>(emergenceContext);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PartsCompanion toCompanion(bool nullToAbsent) {
    return PartsCompanion(
      id: Value(id),
      displayName: displayName == null && nullToAbsent
          ? const Value.absent()
          : Value(displayName),
      pronouns: pronouns == null && nullToAbsent
          ? const Value.absent()
          : Value(pronouns),
      apparentAge: apparentAge == null && nullToAbsent
          ? const Value.absent()
          : Value(apparentAge),
      role: role == null && nullToAbsent ? const Value.absent() : Value(role),
      descriptionInternal: descriptionInternal == null && nullToAbsent
          ? const Value.absent()
          : Value(descriptionInternal),
      descriptionExternal: descriptionExternal == null && nullToAbsent
          ? const Value.absent()
          : Value(descriptionExternal),
      visibility: Value(visibility),
      status: Value(status),
      integratedInto: integratedInto == null && nullToAbsent
          ? const Value.absent()
          : Value(integratedInto),
      emergedAt: emergedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(emergedAt),
      emergenceContext: emergenceContext == null && nullToAbsent
          ? const Value.absent()
          : Value(emergenceContext),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory PartsData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PartsData(
      id: serializer.fromJson<String>(json['id']),
      displayName: serializer.fromJson<String?>(json['displayName']),
      pronouns: serializer.fromJson<String?>(json['pronouns']),
      apparentAge: serializer.fromJson<String?>(json['apparentAge']),
      role: serializer.fromJson<String?>(json['role']),
      descriptionInternal: serializer.fromJson<String?>(
        json['descriptionInternal'],
      ),
      descriptionExternal: serializer.fromJson<String?>(
        json['descriptionExternal'],
      ),
      visibility: serializer.fromJson<String>(json['visibility']),
      status: serializer.fromJson<String>(json['status']),
      integratedInto: serializer.fromJson<String?>(json['integratedInto']),
      emergedAt: serializer.fromJson<DateTime?>(json['emergedAt']),
      emergenceContext: serializer.fromJson<String?>(json['emergenceContext']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'displayName': serializer.toJson<String?>(displayName),
      'pronouns': serializer.toJson<String?>(pronouns),
      'apparentAge': serializer.toJson<String?>(apparentAge),
      'role': serializer.toJson<String?>(role),
      'descriptionInternal': serializer.toJson<String?>(descriptionInternal),
      'descriptionExternal': serializer.toJson<String?>(descriptionExternal),
      'visibility': serializer.toJson<String>(visibility),
      'status': serializer.toJson<String>(status),
      'integratedInto': serializer.toJson<String?>(integratedInto),
      'emergedAt': serializer.toJson<DateTime?>(emergedAt),
      'emergenceContext': serializer.toJson<String?>(emergenceContext),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PartsData copyWith({
    String? id,
    Value<String?> displayName = const Value.absent(),
    Value<String?> pronouns = const Value.absent(),
    Value<String?> apparentAge = const Value.absent(),
    Value<String?> role = const Value.absent(),
    Value<String?> descriptionInternal = const Value.absent(),
    Value<String?> descriptionExternal = const Value.absent(),
    String? visibility,
    String? status,
    Value<String?> integratedInto = const Value.absent(),
    Value<DateTime?> emergedAt = const Value.absent(),
    Value<String?> emergenceContext = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => PartsData(
    id: id ?? this.id,
    displayName: displayName.present ? displayName.value : this.displayName,
    pronouns: pronouns.present ? pronouns.value : this.pronouns,
    apparentAge: apparentAge.present ? apparentAge.value : this.apparentAge,
    role: role.present ? role.value : this.role,
    descriptionInternal: descriptionInternal.present
        ? descriptionInternal.value
        : this.descriptionInternal,
    descriptionExternal: descriptionExternal.present
        ? descriptionExternal.value
        : this.descriptionExternal,
    visibility: visibility ?? this.visibility,
    status: status ?? this.status,
    integratedInto: integratedInto.present
        ? integratedInto.value
        : this.integratedInto,
    emergedAt: emergedAt.present ? emergedAt.value : this.emergedAt,
    emergenceContext: emergenceContext.present
        ? emergenceContext.value
        : this.emergenceContext,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  PartsData copyWithCompanion(PartsCompanion data) {
    return PartsData(
      id: data.id.present ? data.id.value : this.id,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      pronouns: data.pronouns.present ? data.pronouns.value : this.pronouns,
      apparentAge: data.apparentAge.present
          ? data.apparentAge.value
          : this.apparentAge,
      role: data.role.present ? data.role.value : this.role,
      descriptionInternal: data.descriptionInternal.present
          ? data.descriptionInternal.value
          : this.descriptionInternal,
      descriptionExternal: data.descriptionExternal.present
          ? data.descriptionExternal.value
          : this.descriptionExternal,
      visibility: data.visibility.present
          ? data.visibility.value
          : this.visibility,
      status: data.status.present ? data.status.value : this.status,
      integratedInto: data.integratedInto.present
          ? data.integratedInto.value
          : this.integratedInto,
      emergedAt: data.emergedAt.present ? data.emergedAt.value : this.emergedAt,
      emergenceContext: data.emergenceContext.present
          ? data.emergenceContext.value
          : this.emergenceContext,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PartsData(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('pronouns: $pronouns, ')
          ..write('apparentAge: $apparentAge, ')
          ..write('role: $role, ')
          ..write('descriptionInternal: $descriptionInternal, ')
          ..write('descriptionExternal: $descriptionExternal, ')
          ..write('visibility: $visibility, ')
          ..write('status: $status, ')
          ..write('integratedInto: $integratedInto, ')
          ..write('emergedAt: $emergedAt, ')
          ..write('emergenceContext: $emergenceContext, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    displayName,
    pronouns,
    apparentAge,
    role,
    descriptionInternal,
    descriptionExternal,
    visibility,
    status,
    integratedInto,
    emergedAt,
    emergenceContext,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PartsData &&
          other.id == this.id &&
          other.displayName == this.displayName &&
          other.pronouns == this.pronouns &&
          other.apparentAge == this.apparentAge &&
          other.role == this.role &&
          other.descriptionInternal == this.descriptionInternal &&
          other.descriptionExternal == this.descriptionExternal &&
          other.visibility == this.visibility &&
          other.status == this.status &&
          other.integratedInto == this.integratedInto &&
          other.emergedAt == this.emergedAt &&
          other.emergenceContext == this.emergenceContext &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PartsCompanion extends UpdateCompanion<PartsData> {
  final Value<String> id;
  final Value<String?> displayName;
  final Value<String?> pronouns;
  final Value<String?> apparentAge;
  final Value<String?> role;
  final Value<String?> descriptionInternal;
  final Value<String?> descriptionExternal;
  final Value<String> visibility;
  final Value<String> status;
  final Value<String?> integratedInto;
  final Value<DateTime?> emergedAt;
  final Value<String?> emergenceContext;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const PartsCompanion({
    this.id = const Value.absent(),
    this.displayName = const Value.absent(),
    this.pronouns = const Value.absent(),
    this.apparentAge = const Value.absent(),
    this.role = const Value.absent(),
    this.descriptionInternal = const Value.absent(),
    this.descriptionExternal = const Value.absent(),
    this.visibility = const Value.absent(),
    this.status = const Value.absent(),
    this.integratedInto = const Value.absent(),
    this.emergedAt = const Value.absent(),
    this.emergenceContext = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PartsCompanion.insert({
    this.id = const Value.absent(),
    this.displayName = const Value.absent(),
    this.pronouns = const Value.absent(),
    this.apparentAge = const Value.absent(),
    this.role = const Value.absent(),
    this.descriptionInternal = const Value.absent(),
    this.descriptionExternal = const Value.absent(),
    this.visibility = const Value.absent(),
    this.status = const Value.absent(),
    this.integratedInto = const Value.absent(),
    this.emergedAt = const Value.absent(),
    this.emergenceContext = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  static Insertable<PartsData> custom({
    Expression<String>? id,
    Expression<String>? displayName,
    Expression<String>? pronouns,
    Expression<String>? apparentAge,
    Expression<String>? role,
    Expression<String>? descriptionInternal,
    Expression<String>? descriptionExternal,
    Expression<String>? visibility,
    Expression<String>? status,
    Expression<String>? integratedInto,
    Expression<DateTime>? emergedAt,
    Expression<String>? emergenceContext,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (displayName != null) 'display_name': displayName,
      if (pronouns != null) 'pronouns': pronouns,
      if (apparentAge != null) 'apparent_age': apparentAge,
      if (role != null) 'role': role,
      if (descriptionInternal != null)
        'description_internal': descriptionInternal,
      if (descriptionExternal != null)
        'description_external': descriptionExternal,
      if (visibility != null) 'visibility': visibility,
      if (status != null) 'status': status,
      if (integratedInto != null) 'integrated_into': integratedInto,
      if (emergedAt != null) 'emerged_at': emergedAt,
      if (emergenceContext != null) 'emergence_context': emergenceContext,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PartsCompanion copyWith({
    Value<String>? id,
    Value<String?>? displayName,
    Value<String?>? pronouns,
    Value<String?>? apparentAge,
    Value<String?>? role,
    Value<String?>? descriptionInternal,
    Value<String?>? descriptionExternal,
    Value<String>? visibility,
    Value<String>? status,
    Value<String?>? integratedInto,
    Value<DateTime?>? emergedAt,
    Value<String?>? emergenceContext,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return PartsCompanion(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      pronouns: pronouns ?? this.pronouns,
      apparentAge: apparentAge ?? this.apparentAge,
      role: role ?? this.role,
      descriptionInternal: descriptionInternal ?? this.descriptionInternal,
      descriptionExternal: descriptionExternal ?? this.descriptionExternal,
      visibility: visibility ?? this.visibility,
      status: status ?? this.status,
      integratedInto: integratedInto ?? this.integratedInto,
      emergedAt: emergedAt ?? this.emergedAt,
      emergenceContext: emergenceContext ?? this.emergenceContext,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (pronouns.present) {
      map['pronouns'] = Variable<String>(pronouns.value);
    }
    if (apparentAge.present) {
      map['apparent_age'] = Variable<String>(apparentAge.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (descriptionInternal.present) {
      map['description_internal'] = Variable<String>(descriptionInternal.value);
    }
    if (descriptionExternal.present) {
      map['description_external'] = Variable<String>(descriptionExternal.value);
    }
    if (visibility.present) {
      map['visibility'] = Variable<String>(visibility.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (integratedInto.present) {
      map['integrated_into'] = Variable<String>(integratedInto.value);
    }
    if (emergedAt.present) {
      map['emerged_at'] = Variable<DateTime>(emergedAt.value);
    }
    if (emergenceContext.present) {
      map['emergence_context'] = Variable<String>(emergenceContext.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PartsCompanion(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('pronouns: $pronouns, ')
          ..write('apparentAge: $apparentAge, ')
          ..write('role: $role, ')
          ..write('descriptionInternal: $descriptionInternal, ')
          ..write('descriptionExternal: $descriptionExternal, ')
          ..write('visibility: $visibility, ')
          ..write('status: $status, ')
          ..write('integratedInto: $integratedInto, ')
          ..write('emergedAt: $emergedAt, ')
          ..write('emergenceContext: $emergenceContext, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SystemsTable systems = $SystemsTable(this);
  late final $PartsTable parts = $PartsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [systems, parts];
}

typedef $$SystemsTableCreateCompanionBuilder =
    SystemsCompanion Function({
      Value<String> id,
      required String displayName,
      Value<String?> pronounsExternal,
      Value<String> languagePrimary,
      Value<String> languageSecondary,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$SystemsTableUpdateCompanionBuilder =
    SystemsCompanion Function({
      Value<String> id,
      Value<String> displayName,
      Value<String?> pronounsExternal,
      Value<String> languagePrimary,
      Value<String> languageSecondary,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$SystemsTableFilterComposer
    extends Composer<_$AppDatabase, $SystemsTable> {
  $$SystemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pronounsExternal => $composableBuilder(
    column: $table.pronounsExternal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get languagePrimary => $composableBuilder(
    column: $table.languagePrimary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get languageSecondary => $composableBuilder(
    column: $table.languageSecondary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SystemsTableOrderingComposer
    extends Composer<_$AppDatabase, $SystemsTable> {
  $$SystemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pronounsExternal => $composableBuilder(
    column: $table.pronounsExternal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get languagePrimary => $composableBuilder(
    column: $table.languagePrimary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get languageSecondary => $composableBuilder(
    column: $table.languageSecondary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SystemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SystemsTable> {
  $$SystemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get pronounsExternal => $composableBuilder(
    column: $table.pronounsExternal,
    builder: (column) => column,
  );

  GeneratedColumn<String> get languagePrimary => $composableBuilder(
    column: $table.languagePrimary,
    builder: (column) => column,
  );

  GeneratedColumn<String> get languageSecondary => $composableBuilder(
    column: $table.languageSecondary,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SystemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SystemsTable,
          System,
          $$SystemsTableFilterComposer,
          $$SystemsTableOrderingComposer,
          $$SystemsTableAnnotationComposer,
          $$SystemsTableCreateCompanionBuilder,
          $$SystemsTableUpdateCompanionBuilder,
          (System, BaseReferences<_$AppDatabase, $SystemsTable, System>),
          System,
          PrefetchHooks Function()
        > {
  $$SystemsTableTableManager(_$AppDatabase db, $SystemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SystemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SystemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SystemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<String?> pronounsExternal = const Value.absent(),
                Value<String> languagePrimary = const Value.absent(),
                Value<String> languageSecondary = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SystemsCompanion(
                id: id,
                displayName: displayName,
                pronounsExternal: pronounsExternal,
                languagePrimary: languagePrimary,
                languageSecondary: languageSecondary,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String displayName,
                Value<String?> pronounsExternal = const Value.absent(),
                Value<String> languagePrimary = const Value.absent(),
                Value<String> languageSecondary = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SystemsCompanion.insert(
                id: id,
                displayName: displayName,
                pronounsExternal: pronounsExternal,
                languagePrimary: languagePrimary,
                languageSecondary: languageSecondary,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SystemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SystemsTable,
      System,
      $$SystemsTableFilterComposer,
      $$SystemsTableOrderingComposer,
      $$SystemsTableAnnotationComposer,
      $$SystemsTableCreateCompanionBuilder,
      $$SystemsTableUpdateCompanionBuilder,
      (System, BaseReferences<_$AppDatabase, $SystemsTable, System>),
      System,
      PrefetchHooks Function()
    >;
typedef $$PartsTableCreateCompanionBuilder =
    PartsCompanion Function({
      Value<String> id,
      Value<String?> displayName,
      Value<String?> pronouns,
      Value<String?> apparentAge,
      Value<String?> role,
      Value<String?> descriptionInternal,
      Value<String?> descriptionExternal,
      Value<String> visibility,
      Value<String> status,
      Value<String?> integratedInto,
      Value<DateTime?> emergedAt,
      Value<String?> emergenceContext,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$PartsTableUpdateCompanionBuilder =
    PartsCompanion Function({
      Value<String> id,
      Value<String?> displayName,
      Value<String?> pronouns,
      Value<String?> apparentAge,
      Value<String?> role,
      Value<String?> descriptionInternal,
      Value<String?> descriptionExternal,
      Value<String> visibility,
      Value<String> status,
      Value<String?> integratedInto,
      Value<DateTime?> emergedAt,
      Value<String?> emergenceContext,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$PartsTableFilterComposer extends Composer<_$AppDatabase, $PartsTable> {
  $$PartsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pronouns => $composableBuilder(
    column: $table.pronouns,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get apparentAge => $composableBuilder(
    column: $table.apparentAge,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descriptionInternal => $composableBuilder(
    column: $table.descriptionInternal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descriptionExternal => $composableBuilder(
    column: $table.descriptionExternal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get visibility => $composableBuilder(
    column: $table.visibility,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get integratedInto => $composableBuilder(
    column: $table.integratedInto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get emergedAt => $composableBuilder(
    column: $table.emergedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get emergenceContext => $composableBuilder(
    column: $table.emergenceContext,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PartsTableOrderingComposer
    extends Composer<_$AppDatabase, $PartsTable> {
  $$PartsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pronouns => $composableBuilder(
    column: $table.pronouns,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get apparentAge => $composableBuilder(
    column: $table.apparentAge,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descriptionInternal => $composableBuilder(
    column: $table.descriptionInternal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descriptionExternal => $composableBuilder(
    column: $table.descriptionExternal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get visibility => $composableBuilder(
    column: $table.visibility,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get integratedInto => $composableBuilder(
    column: $table.integratedInto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get emergedAt => $composableBuilder(
    column: $table.emergedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get emergenceContext => $composableBuilder(
    column: $table.emergenceContext,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PartsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PartsTable> {
  $$PartsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get pronouns =>
      $composableBuilder(column: $table.pronouns, builder: (column) => column);

  GeneratedColumn<String> get apparentAge => $composableBuilder(
    column: $table.apparentAge,
    builder: (column) => column,
  );

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get descriptionInternal => $composableBuilder(
    column: $table.descriptionInternal,
    builder: (column) => column,
  );

  GeneratedColumn<String> get descriptionExternal => $composableBuilder(
    column: $table.descriptionExternal,
    builder: (column) => column,
  );

  GeneratedColumn<String> get visibility => $composableBuilder(
    column: $table.visibility,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get integratedInto => $composableBuilder(
    column: $table.integratedInto,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get emergedAt =>
      $composableBuilder(column: $table.emergedAt, builder: (column) => column);

  GeneratedColumn<String> get emergenceContext => $composableBuilder(
    column: $table.emergenceContext,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$PartsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PartsTable,
          PartsData,
          $$PartsTableFilterComposer,
          $$PartsTableOrderingComposer,
          $$PartsTableAnnotationComposer,
          $$PartsTableCreateCompanionBuilder,
          $$PartsTableUpdateCompanionBuilder,
          (PartsData, BaseReferences<_$AppDatabase, $PartsTable, PartsData>),
          PartsData,
          PrefetchHooks Function()
        > {
  $$PartsTableTableManager(_$AppDatabase db, $PartsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PartsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PartsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PartsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> displayName = const Value.absent(),
                Value<String?> pronouns = const Value.absent(),
                Value<String?> apparentAge = const Value.absent(),
                Value<String?> role = const Value.absent(),
                Value<String?> descriptionInternal = const Value.absent(),
                Value<String?> descriptionExternal = const Value.absent(),
                Value<String> visibility = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> integratedInto = const Value.absent(),
                Value<DateTime?> emergedAt = const Value.absent(),
                Value<String?> emergenceContext = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PartsCompanion(
                id: id,
                displayName: displayName,
                pronouns: pronouns,
                apparentAge: apparentAge,
                role: role,
                descriptionInternal: descriptionInternal,
                descriptionExternal: descriptionExternal,
                visibility: visibility,
                status: status,
                integratedInto: integratedInto,
                emergedAt: emergedAt,
                emergenceContext: emergenceContext,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> displayName = const Value.absent(),
                Value<String?> pronouns = const Value.absent(),
                Value<String?> apparentAge = const Value.absent(),
                Value<String?> role = const Value.absent(),
                Value<String?> descriptionInternal = const Value.absent(),
                Value<String?> descriptionExternal = const Value.absent(),
                Value<String> visibility = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> integratedInto = const Value.absent(),
                Value<DateTime?> emergedAt = const Value.absent(),
                Value<String?> emergenceContext = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PartsCompanion.insert(
                id: id,
                displayName: displayName,
                pronouns: pronouns,
                apparentAge: apparentAge,
                role: role,
                descriptionInternal: descriptionInternal,
                descriptionExternal: descriptionExternal,
                visibility: visibility,
                status: status,
                integratedInto: integratedInto,
                emergedAt: emergedAt,
                emergenceContext: emergenceContext,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PartsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PartsTable,
      PartsData,
      $$PartsTableFilterComposer,
      $$PartsTableOrderingComposer,
      $$PartsTableAnnotationComposer,
      $$PartsTableCreateCompanionBuilder,
      $$PartsTableUpdateCompanionBuilder,
      (PartsData, BaseReferences<_$AppDatabase, $PartsTable, PartsData>),
      PartsData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SystemsTableTableManager get systems =>
      $$SystemsTableTableManager(_db, _db.systems);
  $$PartsTableTableManager get parts =>
      $$PartsTableTableManager(_db, _db.parts);
}
