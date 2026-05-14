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

class $SwitchEventsTable extends SwitchEvents
    with TableInfo<$SwitchEventsTable, SwitchEventsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SwitchEventsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _partIdMeta = const VerificationMeta('partId');
  @override
  late final GeneratedColumn<String> partId = GeneratedColumn<String>(
    'part_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _markedByMeta = const VerificationMeta(
    'markedBy',
  );
  @override
  late final GeneratedColumn<String> markedBy = GeneratedColumn<String>(
    'marked_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('SelfCheckin'),
  );
  static const VerificationMeta _contextTagsMeta = const VerificationMeta(
    'contextTags',
  );
  @override
  late final GeneratedColumn<String> contextTags = GeneratedColumn<String>(
    'context_tags',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _remotePartNameMeta = const VerificationMeta(
    'remotePartName',
  );
  @override
  late final GeneratedColumn<String> remotePartName = GeneratedColumn<String>(
    'remote_part_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    partId,
    timestamp,
    markedBy,
    contextTags,
    note,
    remotePartName,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'switch_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<SwitchEventsData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('part_id')) {
      context.handle(
        _partIdMeta,
        partId.isAcceptableOrUnknown(data['part_id']!, _partIdMeta),
      );
    } else if (isInserting) {
      context.missing(_partIdMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    }
    if (data.containsKey('marked_by')) {
      context.handle(
        _markedByMeta,
        markedBy.isAcceptableOrUnknown(data['marked_by']!, _markedByMeta),
      );
    }
    if (data.containsKey('context_tags')) {
      context.handle(
        _contextTagsMeta,
        contextTags.isAcceptableOrUnknown(
          data['context_tags']!,
          _contextTagsMeta,
        ),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('remote_part_name')) {
      context.handle(
        _remotePartNameMeta,
        remotePartName.isAcceptableOrUnknown(
          data['remote_part_name']!,
          _remotePartNameMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SwitchEventsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SwitchEventsData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      partId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}part_id'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      markedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}marked_by'],
      )!,
      contextTags: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}context_tags'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      remotePartName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_part_name'],
      ),
    );
  }

  @override
  $SwitchEventsTable createAlias(String alias) {
    return $SwitchEventsTable(attachedDatabase, alias);
  }
}

class SwitchEventsData extends DataClass
    implements Insertable<SwitchEventsData> {
  final String id;
  final String partId;
  final DateTime timestamp;
  final String markedBy;
  final String? contextTags;
  final String? note;
  final String? remotePartName;
  const SwitchEventsData({
    required this.id,
    required this.partId,
    required this.timestamp,
    required this.markedBy,
    this.contextTags,
    this.note,
    this.remotePartName,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['part_id'] = Variable<String>(partId);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['marked_by'] = Variable<String>(markedBy);
    if (!nullToAbsent || contextTags != null) {
      map['context_tags'] = Variable<String>(contextTags);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || remotePartName != null) {
      map['remote_part_name'] = Variable<String>(remotePartName);
    }
    return map;
  }

  SwitchEventsCompanion toCompanion(bool nullToAbsent) {
    return SwitchEventsCompanion(
      id: Value(id),
      partId: Value(partId),
      timestamp: Value(timestamp),
      markedBy: Value(markedBy),
      contextTags: contextTags == null && nullToAbsent
          ? const Value.absent()
          : Value(contextTags),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      remotePartName: remotePartName == null && nullToAbsent
          ? const Value.absent()
          : Value(remotePartName),
    );
  }

  factory SwitchEventsData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SwitchEventsData(
      id: serializer.fromJson<String>(json['id']),
      partId: serializer.fromJson<String>(json['partId']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      markedBy: serializer.fromJson<String>(json['markedBy']),
      contextTags: serializer.fromJson<String?>(json['contextTags']),
      note: serializer.fromJson<String?>(json['note']),
      remotePartName: serializer.fromJson<String?>(json['remotePartName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'partId': serializer.toJson<String>(partId),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'markedBy': serializer.toJson<String>(markedBy),
      'contextTags': serializer.toJson<String?>(contextTags),
      'note': serializer.toJson<String?>(note),
      'remotePartName': serializer.toJson<String?>(remotePartName),
    };
  }

  SwitchEventsData copyWith({
    String? id,
    String? partId,
    DateTime? timestamp,
    String? markedBy,
    Value<String?> contextTags = const Value.absent(),
    Value<String?> note = const Value.absent(),
    Value<String?> remotePartName = const Value.absent(),
  }) => SwitchEventsData(
    id: id ?? this.id,
    partId: partId ?? this.partId,
    timestamp: timestamp ?? this.timestamp,
    markedBy: markedBy ?? this.markedBy,
    contextTags: contextTags.present ? contextTags.value : this.contextTags,
    note: note.present ? note.value : this.note,
    remotePartName: remotePartName.present
        ? remotePartName.value
        : this.remotePartName,
  );
  SwitchEventsData copyWithCompanion(SwitchEventsCompanion data) {
    return SwitchEventsData(
      id: data.id.present ? data.id.value : this.id,
      partId: data.partId.present ? data.partId.value : this.partId,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      markedBy: data.markedBy.present ? data.markedBy.value : this.markedBy,
      contextTags: data.contextTags.present
          ? data.contextTags.value
          : this.contextTags,
      note: data.note.present ? data.note.value : this.note,
      remotePartName: data.remotePartName.present
          ? data.remotePartName.value
          : this.remotePartName,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SwitchEventsData(')
          ..write('id: $id, ')
          ..write('partId: $partId, ')
          ..write('timestamp: $timestamp, ')
          ..write('markedBy: $markedBy, ')
          ..write('contextTags: $contextTags, ')
          ..write('note: $note, ')
          ..write('remotePartName: $remotePartName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    partId,
    timestamp,
    markedBy,
    contextTags,
    note,
    remotePartName,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SwitchEventsData &&
          other.id == this.id &&
          other.partId == this.partId &&
          other.timestamp == this.timestamp &&
          other.markedBy == this.markedBy &&
          other.contextTags == this.contextTags &&
          other.note == this.note &&
          other.remotePartName == this.remotePartName);
}

class SwitchEventsCompanion extends UpdateCompanion<SwitchEventsData> {
  final Value<String> id;
  final Value<String> partId;
  final Value<DateTime> timestamp;
  final Value<String> markedBy;
  final Value<String?> contextTags;
  final Value<String?> note;
  final Value<String?> remotePartName;
  final Value<int> rowid;
  const SwitchEventsCompanion({
    this.id = const Value.absent(),
    this.partId = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.markedBy = const Value.absent(),
    this.contextTags = const Value.absent(),
    this.note = const Value.absent(),
    this.remotePartName = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SwitchEventsCompanion.insert({
    this.id = const Value.absent(),
    required String partId,
    this.timestamp = const Value.absent(),
    this.markedBy = const Value.absent(),
    this.contextTags = const Value.absent(),
    this.note = const Value.absent(),
    this.remotePartName = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : partId = Value(partId);
  static Insertable<SwitchEventsData> custom({
    Expression<String>? id,
    Expression<String>? partId,
    Expression<DateTime>? timestamp,
    Expression<String>? markedBy,
    Expression<String>? contextTags,
    Expression<String>? note,
    Expression<String>? remotePartName,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (partId != null) 'part_id': partId,
      if (timestamp != null) 'timestamp': timestamp,
      if (markedBy != null) 'marked_by': markedBy,
      if (contextTags != null) 'context_tags': contextTags,
      if (note != null) 'note': note,
      if (remotePartName != null) 'remote_part_name': remotePartName,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SwitchEventsCompanion copyWith({
    Value<String>? id,
    Value<String>? partId,
    Value<DateTime>? timestamp,
    Value<String>? markedBy,
    Value<String?>? contextTags,
    Value<String?>? note,
    Value<String?>? remotePartName,
    Value<int>? rowid,
  }) {
    return SwitchEventsCompanion(
      id: id ?? this.id,
      partId: partId ?? this.partId,
      timestamp: timestamp ?? this.timestamp,
      markedBy: markedBy ?? this.markedBy,
      contextTags: contextTags ?? this.contextTags,
      note: note ?? this.note,
      remotePartName: remotePartName ?? this.remotePartName,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (partId.present) {
      map['part_id'] = Variable<String>(partId.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (markedBy.present) {
      map['marked_by'] = Variable<String>(markedBy.value);
    }
    if (contextTags.present) {
      map['context_tags'] = Variable<String>(contextTags.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (remotePartName.present) {
      map['remote_part_name'] = Variable<String>(remotePartName.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SwitchEventsCompanion(')
          ..write('id: $id, ')
          ..write('partId: $partId, ')
          ..write('timestamp: $timestamp, ')
          ..write('markedBy: $markedBy, ')
          ..write('contextTags: $contextTags, ')
          ..write('note: $note, ')
          ..write('remotePartName: $remotePartName, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ConsentProfilesTable extends ConsentProfiles
    with TableInfo<$ConsentProfilesTable, ConsentProfileData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConsentProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _partIdMeta = const VerificationMeta('partId');
  @override
  late final GeneratedColumn<String> partId = GeneratedColumn<String>(
    'part_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES parts (id)',
    ),
  );
  static const VerificationMeta _touchGeneralMeta = const VerificationMeta(
    'touchGeneral',
  );
  @override
  late final GeneratedColumn<String> touchGeneral = GeneratedColumn<String>(
    'touch_general',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Unknown'),
  );
  static const VerificationMeta _touchIntimateMeta = const VerificationMeta(
    'touchIntimate',
  );
  @override
  late final GeneratedColumn<String> touchIntimate = GeneratedColumn<String>(
    'touch_intimate',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Unknown'),
  );
  static const VerificationMeta _kissMeta = const VerificationMeta('kiss');
  @override
  late final GeneratedColumn<String> kiss = GeneratedColumn<String>(
    'kiss',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Unknown'),
  );
  static const VerificationMeta _petNamesMeta = const VerificationMeta(
    'petNames',
  );
  @override
  late final GeneratedColumn<String> petNames = GeneratedColumn<String>(
    'pet_names',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Unknown'),
  );
  static const VerificationMeta _sexualActivityMeta = const VerificationMeta(
    'sexualActivity',
  );
  @override
  late final GeneratedColumn<String> sexualActivity = GeneratedColumn<String>(
    'sexual_activity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Unknown'),
  );
  static const VerificationMeta _drivingMeta = const VerificationMeta(
    'driving',
  );
  @override
  late final GeneratedColumn<String> driving = GeneratedColumn<String>(
    'driving',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Unknown'),
  );
  static const VerificationMeta _alcoholMeta = const VerificationMeta(
    'alcohol',
  );
  @override
  late final GeneratedColumn<String> alcohol = GeneratedColumn<String>(
    'alcohol',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Unknown'),
  );
  static const VerificationMeta _decisionsFinancialMeta =
      const VerificationMeta('decisionsFinancial');
  @override
  late final GeneratedColumn<String> decisionsFinancial =
      GeneratedColumn<String>(
        'decisions_financial',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('Unknown'),
      );
  static const VerificationMeta _decisionsMedicalMeta = const VerificationMeta(
    'decisionsMedical',
  );
  @override
  late final GeneratedColumn<String> decisionsMedical = GeneratedColumn<String>(
    'decisions_medical',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Unknown'),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastReviewedMeta = const VerificationMeta(
    'lastReviewed',
  );
  @override
  late final GeneratedColumn<DateTime> lastReviewed = GeneratedColumn<DateTime>(
    'last_reviewed',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    partId,
    touchGeneral,
    touchIntimate,
    kiss,
    petNames,
    sexualActivity,
    driving,
    alcohol,
    decisionsFinancial,
    decisionsMedical,
    notes,
    lastReviewed,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'consent_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<ConsentProfileData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('part_id')) {
      context.handle(
        _partIdMeta,
        partId.isAcceptableOrUnknown(data['part_id']!, _partIdMeta),
      );
    } else if (isInserting) {
      context.missing(_partIdMeta);
    }
    if (data.containsKey('touch_general')) {
      context.handle(
        _touchGeneralMeta,
        touchGeneral.isAcceptableOrUnknown(
          data['touch_general']!,
          _touchGeneralMeta,
        ),
      );
    }
    if (data.containsKey('touch_intimate')) {
      context.handle(
        _touchIntimateMeta,
        touchIntimate.isAcceptableOrUnknown(
          data['touch_intimate']!,
          _touchIntimateMeta,
        ),
      );
    }
    if (data.containsKey('kiss')) {
      context.handle(
        _kissMeta,
        kiss.isAcceptableOrUnknown(data['kiss']!, _kissMeta),
      );
    }
    if (data.containsKey('pet_names')) {
      context.handle(
        _petNamesMeta,
        petNames.isAcceptableOrUnknown(data['pet_names']!, _petNamesMeta),
      );
    }
    if (data.containsKey('sexual_activity')) {
      context.handle(
        _sexualActivityMeta,
        sexualActivity.isAcceptableOrUnknown(
          data['sexual_activity']!,
          _sexualActivityMeta,
        ),
      );
    }
    if (data.containsKey('driving')) {
      context.handle(
        _drivingMeta,
        driving.isAcceptableOrUnknown(data['driving']!, _drivingMeta),
      );
    }
    if (data.containsKey('alcohol')) {
      context.handle(
        _alcoholMeta,
        alcohol.isAcceptableOrUnknown(data['alcohol']!, _alcoholMeta),
      );
    }
    if (data.containsKey('decisions_financial')) {
      context.handle(
        _decisionsFinancialMeta,
        decisionsFinancial.isAcceptableOrUnknown(
          data['decisions_financial']!,
          _decisionsFinancialMeta,
        ),
      );
    }
    if (data.containsKey('decisions_medical')) {
      context.handle(
        _decisionsMedicalMeta,
        decisionsMedical.isAcceptableOrUnknown(
          data['decisions_medical']!,
          _decisionsMedicalMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('last_reviewed')) {
      context.handle(
        _lastReviewedMeta,
        lastReviewed.isAcceptableOrUnknown(
          data['last_reviewed']!,
          _lastReviewedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {partId};
  @override
  ConsentProfileData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ConsentProfileData(
      partId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}part_id'],
      )!,
      touchGeneral: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}touch_general'],
      )!,
      touchIntimate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}touch_intimate'],
      )!,
      kiss: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kiss'],
      )!,
      petNames: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pet_names'],
      )!,
      sexualActivity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sexual_activity'],
      )!,
      driving: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}driving'],
      )!,
      alcohol: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}alcohol'],
      )!,
      decisionsFinancial: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}decisions_financial'],
      )!,
      decisionsMedical: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}decisions_medical'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      lastReviewed: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_reviewed'],
      )!,
    );
  }

  @override
  $ConsentProfilesTable createAlias(String alias) {
    return $ConsentProfilesTable(attachedDatabase, alias);
  }
}

class ConsentProfileData extends DataClass
    implements Insertable<ConsentProfileData> {
  final String partId;
  final String touchGeneral;
  final String touchIntimate;
  final String kiss;
  final String petNames;
  final String sexualActivity;
  final String driving;
  final String alcohol;
  final String decisionsFinancial;
  final String decisionsMedical;
  final String? notes;
  final DateTime lastReviewed;
  const ConsentProfileData({
    required this.partId,
    required this.touchGeneral,
    required this.touchIntimate,
    required this.kiss,
    required this.petNames,
    required this.sexualActivity,
    required this.driving,
    required this.alcohol,
    required this.decisionsFinancial,
    required this.decisionsMedical,
    this.notes,
    required this.lastReviewed,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['part_id'] = Variable<String>(partId);
    map['touch_general'] = Variable<String>(touchGeneral);
    map['touch_intimate'] = Variable<String>(touchIntimate);
    map['kiss'] = Variable<String>(kiss);
    map['pet_names'] = Variable<String>(petNames);
    map['sexual_activity'] = Variable<String>(sexualActivity);
    map['driving'] = Variable<String>(driving);
    map['alcohol'] = Variable<String>(alcohol);
    map['decisions_financial'] = Variable<String>(decisionsFinancial);
    map['decisions_medical'] = Variable<String>(decisionsMedical);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['last_reviewed'] = Variable<DateTime>(lastReviewed);
    return map;
  }

  ConsentProfilesCompanion toCompanion(bool nullToAbsent) {
    return ConsentProfilesCompanion(
      partId: Value(partId),
      touchGeneral: Value(touchGeneral),
      touchIntimate: Value(touchIntimate),
      kiss: Value(kiss),
      petNames: Value(petNames),
      sexualActivity: Value(sexualActivity),
      driving: Value(driving),
      alcohol: Value(alcohol),
      decisionsFinancial: Value(decisionsFinancial),
      decisionsMedical: Value(decisionsMedical),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      lastReviewed: Value(lastReviewed),
    );
  }

  factory ConsentProfileData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ConsentProfileData(
      partId: serializer.fromJson<String>(json['partId']),
      touchGeneral: serializer.fromJson<String>(json['touchGeneral']),
      touchIntimate: serializer.fromJson<String>(json['touchIntimate']),
      kiss: serializer.fromJson<String>(json['kiss']),
      petNames: serializer.fromJson<String>(json['petNames']),
      sexualActivity: serializer.fromJson<String>(json['sexualActivity']),
      driving: serializer.fromJson<String>(json['driving']),
      alcohol: serializer.fromJson<String>(json['alcohol']),
      decisionsFinancial: serializer.fromJson<String>(
        json['decisionsFinancial'],
      ),
      decisionsMedical: serializer.fromJson<String>(json['decisionsMedical']),
      notes: serializer.fromJson<String?>(json['notes']),
      lastReviewed: serializer.fromJson<DateTime>(json['lastReviewed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'partId': serializer.toJson<String>(partId),
      'touchGeneral': serializer.toJson<String>(touchGeneral),
      'touchIntimate': serializer.toJson<String>(touchIntimate),
      'kiss': serializer.toJson<String>(kiss),
      'petNames': serializer.toJson<String>(petNames),
      'sexualActivity': serializer.toJson<String>(sexualActivity),
      'driving': serializer.toJson<String>(driving),
      'alcohol': serializer.toJson<String>(alcohol),
      'decisionsFinancial': serializer.toJson<String>(decisionsFinancial),
      'decisionsMedical': serializer.toJson<String>(decisionsMedical),
      'notes': serializer.toJson<String?>(notes),
      'lastReviewed': serializer.toJson<DateTime>(lastReviewed),
    };
  }

  ConsentProfileData copyWith({
    String? partId,
    String? touchGeneral,
    String? touchIntimate,
    String? kiss,
    String? petNames,
    String? sexualActivity,
    String? driving,
    String? alcohol,
    String? decisionsFinancial,
    String? decisionsMedical,
    Value<String?> notes = const Value.absent(),
    DateTime? lastReviewed,
  }) => ConsentProfileData(
    partId: partId ?? this.partId,
    touchGeneral: touchGeneral ?? this.touchGeneral,
    touchIntimate: touchIntimate ?? this.touchIntimate,
    kiss: kiss ?? this.kiss,
    petNames: petNames ?? this.petNames,
    sexualActivity: sexualActivity ?? this.sexualActivity,
    driving: driving ?? this.driving,
    alcohol: alcohol ?? this.alcohol,
    decisionsFinancial: decisionsFinancial ?? this.decisionsFinancial,
    decisionsMedical: decisionsMedical ?? this.decisionsMedical,
    notes: notes.present ? notes.value : this.notes,
    lastReviewed: lastReviewed ?? this.lastReviewed,
  );
  ConsentProfileData copyWithCompanion(ConsentProfilesCompanion data) {
    return ConsentProfileData(
      partId: data.partId.present ? data.partId.value : this.partId,
      touchGeneral: data.touchGeneral.present
          ? data.touchGeneral.value
          : this.touchGeneral,
      touchIntimate: data.touchIntimate.present
          ? data.touchIntimate.value
          : this.touchIntimate,
      kiss: data.kiss.present ? data.kiss.value : this.kiss,
      petNames: data.petNames.present ? data.petNames.value : this.petNames,
      sexualActivity: data.sexualActivity.present
          ? data.sexualActivity.value
          : this.sexualActivity,
      driving: data.driving.present ? data.driving.value : this.driving,
      alcohol: data.alcohol.present ? data.alcohol.value : this.alcohol,
      decisionsFinancial: data.decisionsFinancial.present
          ? data.decisionsFinancial.value
          : this.decisionsFinancial,
      decisionsMedical: data.decisionsMedical.present
          ? data.decisionsMedical.value
          : this.decisionsMedical,
      notes: data.notes.present ? data.notes.value : this.notes,
      lastReviewed: data.lastReviewed.present
          ? data.lastReviewed.value
          : this.lastReviewed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ConsentProfileData(')
          ..write('partId: $partId, ')
          ..write('touchGeneral: $touchGeneral, ')
          ..write('touchIntimate: $touchIntimate, ')
          ..write('kiss: $kiss, ')
          ..write('petNames: $petNames, ')
          ..write('sexualActivity: $sexualActivity, ')
          ..write('driving: $driving, ')
          ..write('alcohol: $alcohol, ')
          ..write('decisionsFinancial: $decisionsFinancial, ')
          ..write('decisionsMedical: $decisionsMedical, ')
          ..write('notes: $notes, ')
          ..write('lastReviewed: $lastReviewed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    partId,
    touchGeneral,
    touchIntimate,
    kiss,
    petNames,
    sexualActivity,
    driving,
    alcohol,
    decisionsFinancial,
    decisionsMedical,
    notes,
    lastReviewed,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ConsentProfileData &&
          other.partId == this.partId &&
          other.touchGeneral == this.touchGeneral &&
          other.touchIntimate == this.touchIntimate &&
          other.kiss == this.kiss &&
          other.petNames == this.petNames &&
          other.sexualActivity == this.sexualActivity &&
          other.driving == this.driving &&
          other.alcohol == this.alcohol &&
          other.decisionsFinancial == this.decisionsFinancial &&
          other.decisionsMedical == this.decisionsMedical &&
          other.notes == this.notes &&
          other.lastReviewed == this.lastReviewed);
}

class ConsentProfilesCompanion extends UpdateCompanion<ConsentProfileData> {
  final Value<String> partId;
  final Value<String> touchGeneral;
  final Value<String> touchIntimate;
  final Value<String> kiss;
  final Value<String> petNames;
  final Value<String> sexualActivity;
  final Value<String> driving;
  final Value<String> alcohol;
  final Value<String> decisionsFinancial;
  final Value<String> decisionsMedical;
  final Value<String?> notes;
  final Value<DateTime> lastReviewed;
  final Value<int> rowid;
  const ConsentProfilesCompanion({
    this.partId = const Value.absent(),
    this.touchGeneral = const Value.absent(),
    this.touchIntimate = const Value.absent(),
    this.kiss = const Value.absent(),
    this.petNames = const Value.absent(),
    this.sexualActivity = const Value.absent(),
    this.driving = const Value.absent(),
    this.alcohol = const Value.absent(),
    this.decisionsFinancial = const Value.absent(),
    this.decisionsMedical = const Value.absent(),
    this.notes = const Value.absent(),
    this.lastReviewed = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ConsentProfilesCompanion.insert({
    required String partId,
    this.touchGeneral = const Value.absent(),
    this.touchIntimate = const Value.absent(),
    this.kiss = const Value.absent(),
    this.petNames = const Value.absent(),
    this.sexualActivity = const Value.absent(),
    this.driving = const Value.absent(),
    this.alcohol = const Value.absent(),
    this.decisionsFinancial = const Value.absent(),
    this.decisionsMedical = const Value.absent(),
    this.notes = const Value.absent(),
    this.lastReviewed = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : partId = Value(partId);
  static Insertable<ConsentProfileData> custom({
    Expression<String>? partId,
    Expression<String>? touchGeneral,
    Expression<String>? touchIntimate,
    Expression<String>? kiss,
    Expression<String>? petNames,
    Expression<String>? sexualActivity,
    Expression<String>? driving,
    Expression<String>? alcohol,
    Expression<String>? decisionsFinancial,
    Expression<String>? decisionsMedical,
    Expression<String>? notes,
    Expression<DateTime>? lastReviewed,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (partId != null) 'part_id': partId,
      if (touchGeneral != null) 'touch_general': touchGeneral,
      if (touchIntimate != null) 'touch_intimate': touchIntimate,
      if (kiss != null) 'kiss': kiss,
      if (petNames != null) 'pet_names': petNames,
      if (sexualActivity != null) 'sexual_activity': sexualActivity,
      if (driving != null) 'driving': driving,
      if (alcohol != null) 'alcohol': alcohol,
      if (decisionsFinancial != null) 'decisions_financial': decisionsFinancial,
      if (decisionsMedical != null) 'decisions_medical': decisionsMedical,
      if (notes != null) 'notes': notes,
      if (lastReviewed != null) 'last_reviewed': lastReviewed,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ConsentProfilesCompanion copyWith({
    Value<String>? partId,
    Value<String>? touchGeneral,
    Value<String>? touchIntimate,
    Value<String>? kiss,
    Value<String>? petNames,
    Value<String>? sexualActivity,
    Value<String>? driving,
    Value<String>? alcohol,
    Value<String>? decisionsFinancial,
    Value<String>? decisionsMedical,
    Value<String?>? notes,
    Value<DateTime>? lastReviewed,
    Value<int>? rowid,
  }) {
    return ConsentProfilesCompanion(
      partId: partId ?? this.partId,
      touchGeneral: touchGeneral ?? this.touchGeneral,
      touchIntimate: touchIntimate ?? this.touchIntimate,
      kiss: kiss ?? this.kiss,
      petNames: petNames ?? this.petNames,
      sexualActivity: sexualActivity ?? this.sexualActivity,
      driving: driving ?? this.driving,
      alcohol: alcohol ?? this.alcohol,
      decisionsFinancial: decisionsFinancial ?? this.decisionsFinancial,
      decisionsMedical: decisionsMedical ?? this.decisionsMedical,
      notes: notes ?? this.notes,
      lastReviewed: lastReviewed ?? this.lastReviewed,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (partId.present) {
      map['part_id'] = Variable<String>(partId.value);
    }
    if (touchGeneral.present) {
      map['touch_general'] = Variable<String>(touchGeneral.value);
    }
    if (touchIntimate.present) {
      map['touch_intimate'] = Variable<String>(touchIntimate.value);
    }
    if (kiss.present) {
      map['kiss'] = Variable<String>(kiss.value);
    }
    if (petNames.present) {
      map['pet_names'] = Variable<String>(petNames.value);
    }
    if (sexualActivity.present) {
      map['sexual_activity'] = Variable<String>(sexualActivity.value);
    }
    if (driving.present) {
      map['driving'] = Variable<String>(driving.value);
    }
    if (alcohol.present) {
      map['alcohol'] = Variable<String>(alcohol.value);
    }
    if (decisionsFinancial.present) {
      map['decisions_financial'] = Variable<String>(decisionsFinancial.value);
    }
    if (decisionsMedical.present) {
      map['decisions_medical'] = Variable<String>(decisionsMedical.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (lastReviewed.present) {
      map['last_reviewed'] = Variable<DateTime>(lastReviewed.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConsentProfilesCompanion(')
          ..write('partId: $partId, ')
          ..write('touchGeneral: $touchGeneral, ')
          ..write('touchIntimate: $touchIntimate, ')
          ..write('kiss: $kiss, ')
          ..write('petNames: $petNames, ')
          ..write('sexualActivity: $sexualActivity, ')
          ..write('driving: $driving, ')
          ..write('alcohol: $alcohol, ')
          ..write('decisionsFinancial: $decisionsFinancial, ')
          ..write('decisionsMedical: $decisionsMedical, ')
          ..write('notes: $notes, ')
          ..write('lastReviewed: $lastReviewed, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TriggerEntriesTable extends TriggerEntries
    with TableInfo<$TriggerEntriesTable, TriggerEntryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TriggerEntriesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _partIdMeta = const VerificationMeta('partId');
  @override
  late final GeneratedColumn<String> partId = GeneratedColumn<String>(
    'part_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES parts (id)',
    ),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Other'),
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _severityMeta = const VerificationMeta(
    'severity',
  );
  @override
  late final GeneratedColumn<String> severity = GeneratedColumn<String>(
    'severity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Moderate'),
  );
  static const VerificationMeta _copingSuggestionMeta = const VerificationMeta(
    'copingSuggestion',
  );
  @override
  late final GeneratedColumn<String> copingSuggestion = GeneratedColumn<String>(
    'coping_suggestion',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _appliesExternallyMeta = const VerificationMeta(
    'appliesExternally',
  );
  @override
  late final GeneratedColumn<bool> appliesExternally = GeneratedColumn<bool>(
    'applies_externally',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("applies_externally" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
    partId,
    type,
    description,
    severity,
    copingSuggestion,
    appliesExternally,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'trigger_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<TriggerEntryData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('part_id')) {
      context.handle(
        _partIdMeta,
        partId.isAcceptableOrUnknown(data['part_id']!, _partIdMeta),
      );
    } else if (isInserting) {
      context.missing(_partIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('severity')) {
      context.handle(
        _severityMeta,
        severity.isAcceptableOrUnknown(data['severity']!, _severityMeta),
      );
    }
    if (data.containsKey('coping_suggestion')) {
      context.handle(
        _copingSuggestionMeta,
        copingSuggestion.isAcceptableOrUnknown(
          data['coping_suggestion']!,
          _copingSuggestionMeta,
        ),
      );
    }
    if (data.containsKey('applies_externally')) {
      context.handle(
        _appliesExternallyMeta,
        appliesExternally.isAcceptableOrUnknown(
          data['applies_externally']!,
          _appliesExternallyMeta,
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
  TriggerEntryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TriggerEntryData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      partId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}part_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      severity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}severity'],
      )!,
      copingSuggestion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}coping_suggestion'],
      ),
      appliesExternally: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}applies_externally'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TriggerEntriesTable createAlias(String alias) {
    return $TriggerEntriesTable(attachedDatabase, alias);
  }
}

class TriggerEntryData extends DataClass
    implements Insertable<TriggerEntryData> {
  final String id;
  final String partId;
  final String type;
  final String description;
  final String severity;
  final String? copingSuggestion;
  final bool appliesExternally;
  final DateTime createdAt;
  const TriggerEntryData({
    required this.id,
    required this.partId,
    required this.type,
    required this.description,
    required this.severity,
    this.copingSuggestion,
    required this.appliesExternally,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['part_id'] = Variable<String>(partId);
    map['type'] = Variable<String>(type);
    map['description'] = Variable<String>(description);
    map['severity'] = Variable<String>(severity);
    if (!nullToAbsent || copingSuggestion != null) {
      map['coping_suggestion'] = Variable<String>(copingSuggestion);
    }
    map['applies_externally'] = Variable<bool>(appliesExternally);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TriggerEntriesCompanion toCompanion(bool nullToAbsent) {
    return TriggerEntriesCompanion(
      id: Value(id),
      partId: Value(partId),
      type: Value(type),
      description: Value(description),
      severity: Value(severity),
      copingSuggestion: copingSuggestion == null && nullToAbsent
          ? const Value.absent()
          : Value(copingSuggestion),
      appliesExternally: Value(appliesExternally),
      createdAt: Value(createdAt),
    );
  }

  factory TriggerEntryData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TriggerEntryData(
      id: serializer.fromJson<String>(json['id']),
      partId: serializer.fromJson<String>(json['partId']),
      type: serializer.fromJson<String>(json['type']),
      description: serializer.fromJson<String>(json['description']),
      severity: serializer.fromJson<String>(json['severity']),
      copingSuggestion: serializer.fromJson<String?>(json['copingSuggestion']),
      appliesExternally: serializer.fromJson<bool>(json['appliesExternally']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'partId': serializer.toJson<String>(partId),
      'type': serializer.toJson<String>(type),
      'description': serializer.toJson<String>(description),
      'severity': serializer.toJson<String>(severity),
      'copingSuggestion': serializer.toJson<String?>(copingSuggestion),
      'appliesExternally': serializer.toJson<bool>(appliesExternally),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  TriggerEntryData copyWith({
    String? id,
    String? partId,
    String? type,
    String? description,
    String? severity,
    Value<String?> copingSuggestion = const Value.absent(),
    bool? appliesExternally,
    DateTime? createdAt,
  }) => TriggerEntryData(
    id: id ?? this.id,
    partId: partId ?? this.partId,
    type: type ?? this.type,
    description: description ?? this.description,
    severity: severity ?? this.severity,
    copingSuggestion: copingSuggestion.present
        ? copingSuggestion.value
        : this.copingSuggestion,
    appliesExternally: appliesExternally ?? this.appliesExternally,
    createdAt: createdAt ?? this.createdAt,
  );
  TriggerEntryData copyWithCompanion(TriggerEntriesCompanion data) {
    return TriggerEntryData(
      id: data.id.present ? data.id.value : this.id,
      partId: data.partId.present ? data.partId.value : this.partId,
      type: data.type.present ? data.type.value : this.type,
      description: data.description.present
          ? data.description.value
          : this.description,
      severity: data.severity.present ? data.severity.value : this.severity,
      copingSuggestion: data.copingSuggestion.present
          ? data.copingSuggestion.value
          : this.copingSuggestion,
      appliesExternally: data.appliesExternally.present
          ? data.appliesExternally.value
          : this.appliesExternally,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TriggerEntryData(')
          ..write('id: $id, ')
          ..write('partId: $partId, ')
          ..write('type: $type, ')
          ..write('description: $description, ')
          ..write('severity: $severity, ')
          ..write('copingSuggestion: $copingSuggestion, ')
          ..write('appliesExternally: $appliesExternally, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    partId,
    type,
    description,
    severity,
    copingSuggestion,
    appliesExternally,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TriggerEntryData &&
          other.id == this.id &&
          other.partId == this.partId &&
          other.type == this.type &&
          other.description == this.description &&
          other.severity == this.severity &&
          other.copingSuggestion == this.copingSuggestion &&
          other.appliesExternally == this.appliesExternally &&
          other.createdAt == this.createdAt);
}

class TriggerEntriesCompanion extends UpdateCompanion<TriggerEntryData> {
  final Value<String> id;
  final Value<String> partId;
  final Value<String> type;
  final Value<String> description;
  final Value<String> severity;
  final Value<String?> copingSuggestion;
  final Value<bool> appliesExternally;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const TriggerEntriesCompanion({
    this.id = const Value.absent(),
    this.partId = const Value.absent(),
    this.type = const Value.absent(),
    this.description = const Value.absent(),
    this.severity = const Value.absent(),
    this.copingSuggestion = const Value.absent(),
    this.appliesExternally = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TriggerEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String partId,
    this.type = const Value.absent(),
    required String description,
    this.severity = const Value.absent(),
    this.copingSuggestion = const Value.absent(),
    this.appliesExternally = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : partId = Value(partId),
       description = Value(description);
  static Insertable<TriggerEntryData> custom({
    Expression<String>? id,
    Expression<String>? partId,
    Expression<String>? type,
    Expression<String>? description,
    Expression<String>? severity,
    Expression<String>? copingSuggestion,
    Expression<bool>? appliesExternally,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (partId != null) 'part_id': partId,
      if (type != null) 'type': type,
      if (description != null) 'description': description,
      if (severity != null) 'severity': severity,
      if (copingSuggestion != null) 'coping_suggestion': copingSuggestion,
      if (appliesExternally != null) 'applies_externally': appliesExternally,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TriggerEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? partId,
    Value<String>? type,
    Value<String>? description,
    Value<String>? severity,
    Value<String?>? copingSuggestion,
    Value<bool>? appliesExternally,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return TriggerEntriesCompanion(
      id: id ?? this.id,
      partId: partId ?? this.partId,
      type: type ?? this.type,
      description: description ?? this.description,
      severity: severity ?? this.severity,
      copingSuggestion: copingSuggestion ?? this.copingSuggestion,
      appliesExternally: appliesExternally ?? this.appliesExternally,
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
    if (partId.present) {
      map['part_id'] = Variable<String>(partId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (severity.present) {
      map['severity'] = Variable<String>(severity.value);
    }
    if (copingSuggestion.present) {
      map['coping_suggestion'] = Variable<String>(copingSuggestion.value);
    }
    if (appliesExternally.present) {
      map['applies_externally'] = Variable<bool>(appliesExternally.value);
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
    return (StringBuffer('TriggerEntriesCompanion(')
          ..write('id: $id, ')
          ..write('partId: $partId, ')
          ..write('type: $type, ')
          ..write('description: $description, ')
          ..write('severity: $severity, ')
          ..write('copingSuggestion: $copingSuggestion, ')
          ..write('appliesExternally: $appliesExternally, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EmergencyContactsTable extends EmergencyContacts
    with TableInfo<$EmergencyContactsTable, EmergencyContactData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmergencyContactsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _rankMeta = const VerificationMeta('rank');
  @override
  late final GeneratedColumn<int> rank = GeneratedColumn<int>(
    'rank',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _relationshipMeta = const VerificationMeta(
    'relationship',
  );
  @override
  late final GeneratedColumn<String> relationship = GeneratedColumn<String>(
    'relationship',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _knowsAboutDiagnosisMeta =
      const VerificationMeta('knowsAboutDiagnosis');
  @override
  late final GeneratedColumn<bool> knowsAboutDiagnosis = GeneratedColumn<bool>(
    'knows_about_diagnosis',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("knows_about_diagnosis" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _knowsAboutPartsMeta = const VerificationMeta(
    'knowsAboutParts',
  );
  @override
  late final GeneratedColumn<bool> knowsAboutParts = GeneratedColumn<bool>(
    'knows_about_parts',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("knows_about_parts" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _knowsAboutTraumaMeta = const VerificationMeta(
    'knowsAboutTrauma',
  );
  @override
  late final GeneratedColumn<bool> knowsAboutTrauma = GeneratedColumn<bool>(
    'knows_about_trauma',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("knows_about_trauma" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _preferredContactMethodMeta =
      const VerificationMeta('preferredContactMethod');
  @override
  late final GeneratedColumn<String> preferredContactMethod =
      GeneratedColumn<String>(
        'preferred_contact_method',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('Phone'),
      );
  static const VerificationMeta _availableHoursMeta = const VerificationMeta(
    'availableHours',
  );
  @override
  late final GeneratedColumn<String> availableHours = GeneratedColumn<String>(
    'available_hours',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    rank,
    name,
    relationship,
    phone,
    email,
    knowsAboutDiagnosis,
    knowsAboutParts,
    knowsAboutTrauma,
    preferredContactMethod,
    availableHours,
    notes,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'emergency_contacts';
  @override
  VerificationContext validateIntegrity(
    Insertable<EmergencyContactData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('rank')) {
      context.handle(
        _rankMeta,
        rank.isAcceptableOrUnknown(data['rank']!, _rankMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('relationship')) {
      context.handle(
        _relationshipMeta,
        relationship.isAcceptableOrUnknown(
          data['relationship']!,
          _relationshipMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_relationshipMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    } else if (isInserting) {
      context.missing(_phoneMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('knows_about_diagnosis')) {
      context.handle(
        _knowsAboutDiagnosisMeta,
        knowsAboutDiagnosis.isAcceptableOrUnknown(
          data['knows_about_diagnosis']!,
          _knowsAboutDiagnosisMeta,
        ),
      );
    }
    if (data.containsKey('knows_about_parts')) {
      context.handle(
        _knowsAboutPartsMeta,
        knowsAboutParts.isAcceptableOrUnknown(
          data['knows_about_parts']!,
          _knowsAboutPartsMeta,
        ),
      );
    }
    if (data.containsKey('knows_about_trauma')) {
      context.handle(
        _knowsAboutTraumaMeta,
        knowsAboutTrauma.isAcceptableOrUnknown(
          data['knows_about_trauma']!,
          _knowsAboutTraumaMeta,
        ),
      );
    }
    if (data.containsKey('preferred_contact_method')) {
      context.handle(
        _preferredContactMethodMeta,
        preferredContactMethod.isAcceptableOrUnknown(
          data['preferred_contact_method']!,
          _preferredContactMethodMeta,
        ),
      );
    }
    if (data.containsKey('available_hours')) {
      context.handle(
        _availableHoursMeta,
        availableHours.isAcceptableOrUnknown(
          data['available_hours']!,
          _availableHoursMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
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
  EmergencyContactData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EmergencyContactData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      rank: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rank'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      relationship: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}relationship'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      knowsAboutDiagnosis: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}knows_about_diagnosis'],
      )!,
      knowsAboutParts: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}knows_about_parts'],
      )!,
      knowsAboutTrauma: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}knows_about_trauma'],
      )!,
      preferredContactMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}preferred_contact_method'],
      )!,
      availableHours: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}available_hours'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $EmergencyContactsTable createAlias(String alias) {
    return $EmergencyContactsTable(attachedDatabase, alias);
  }
}

class EmergencyContactData extends DataClass
    implements Insertable<EmergencyContactData> {
  final String id;
  final int rank;
  final String name;
  final String relationship;
  final String phone;
  final String? email;
  final bool knowsAboutDiagnosis;
  final bool knowsAboutParts;
  final bool knowsAboutTrauma;
  final String preferredContactMethod;
  final String? availableHours;
  final String? notes;
  final DateTime createdAt;
  const EmergencyContactData({
    required this.id,
    required this.rank,
    required this.name,
    required this.relationship,
    required this.phone,
    this.email,
    required this.knowsAboutDiagnosis,
    required this.knowsAboutParts,
    required this.knowsAboutTrauma,
    required this.preferredContactMethod,
    this.availableHours,
    this.notes,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['rank'] = Variable<int>(rank);
    map['name'] = Variable<String>(name);
    map['relationship'] = Variable<String>(relationship);
    map['phone'] = Variable<String>(phone);
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    map['knows_about_diagnosis'] = Variable<bool>(knowsAboutDiagnosis);
    map['knows_about_parts'] = Variable<bool>(knowsAboutParts);
    map['knows_about_trauma'] = Variable<bool>(knowsAboutTrauma);
    map['preferred_contact_method'] = Variable<String>(preferredContactMethod);
    if (!nullToAbsent || availableHours != null) {
      map['available_hours'] = Variable<String>(availableHours);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  EmergencyContactsCompanion toCompanion(bool nullToAbsent) {
    return EmergencyContactsCompanion(
      id: Value(id),
      rank: Value(rank),
      name: Value(name),
      relationship: Value(relationship),
      phone: Value(phone),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      knowsAboutDiagnosis: Value(knowsAboutDiagnosis),
      knowsAboutParts: Value(knowsAboutParts),
      knowsAboutTrauma: Value(knowsAboutTrauma),
      preferredContactMethod: Value(preferredContactMethod),
      availableHours: availableHours == null && nullToAbsent
          ? const Value.absent()
          : Value(availableHours),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory EmergencyContactData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EmergencyContactData(
      id: serializer.fromJson<String>(json['id']),
      rank: serializer.fromJson<int>(json['rank']),
      name: serializer.fromJson<String>(json['name']),
      relationship: serializer.fromJson<String>(json['relationship']),
      phone: serializer.fromJson<String>(json['phone']),
      email: serializer.fromJson<String?>(json['email']),
      knowsAboutDiagnosis: serializer.fromJson<bool>(
        json['knowsAboutDiagnosis'],
      ),
      knowsAboutParts: serializer.fromJson<bool>(json['knowsAboutParts']),
      knowsAboutTrauma: serializer.fromJson<bool>(json['knowsAboutTrauma']),
      preferredContactMethod: serializer.fromJson<String>(
        json['preferredContactMethod'],
      ),
      availableHours: serializer.fromJson<String?>(json['availableHours']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'rank': serializer.toJson<int>(rank),
      'name': serializer.toJson<String>(name),
      'relationship': serializer.toJson<String>(relationship),
      'phone': serializer.toJson<String>(phone),
      'email': serializer.toJson<String?>(email),
      'knowsAboutDiagnosis': serializer.toJson<bool>(knowsAboutDiagnosis),
      'knowsAboutParts': serializer.toJson<bool>(knowsAboutParts),
      'knowsAboutTrauma': serializer.toJson<bool>(knowsAboutTrauma),
      'preferredContactMethod': serializer.toJson<String>(
        preferredContactMethod,
      ),
      'availableHours': serializer.toJson<String?>(availableHours),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  EmergencyContactData copyWith({
    String? id,
    int? rank,
    String? name,
    String? relationship,
    String? phone,
    Value<String?> email = const Value.absent(),
    bool? knowsAboutDiagnosis,
    bool? knowsAboutParts,
    bool? knowsAboutTrauma,
    String? preferredContactMethod,
    Value<String?> availableHours = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
  }) => EmergencyContactData(
    id: id ?? this.id,
    rank: rank ?? this.rank,
    name: name ?? this.name,
    relationship: relationship ?? this.relationship,
    phone: phone ?? this.phone,
    email: email.present ? email.value : this.email,
    knowsAboutDiagnosis: knowsAboutDiagnosis ?? this.knowsAboutDiagnosis,
    knowsAboutParts: knowsAboutParts ?? this.knowsAboutParts,
    knowsAboutTrauma: knowsAboutTrauma ?? this.knowsAboutTrauma,
    preferredContactMethod:
        preferredContactMethod ?? this.preferredContactMethod,
    availableHours: availableHours.present
        ? availableHours.value
        : this.availableHours,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
  );
  EmergencyContactData copyWithCompanion(EmergencyContactsCompanion data) {
    return EmergencyContactData(
      id: data.id.present ? data.id.value : this.id,
      rank: data.rank.present ? data.rank.value : this.rank,
      name: data.name.present ? data.name.value : this.name,
      relationship: data.relationship.present
          ? data.relationship.value
          : this.relationship,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
      knowsAboutDiagnosis: data.knowsAboutDiagnosis.present
          ? data.knowsAboutDiagnosis.value
          : this.knowsAboutDiagnosis,
      knowsAboutParts: data.knowsAboutParts.present
          ? data.knowsAboutParts.value
          : this.knowsAboutParts,
      knowsAboutTrauma: data.knowsAboutTrauma.present
          ? data.knowsAboutTrauma.value
          : this.knowsAboutTrauma,
      preferredContactMethod: data.preferredContactMethod.present
          ? data.preferredContactMethod.value
          : this.preferredContactMethod,
      availableHours: data.availableHours.present
          ? data.availableHours.value
          : this.availableHours,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EmergencyContactData(')
          ..write('id: $id, ')
          ..write('rank: $rank, ')
          ..write('name: $name, ')
          ..write('relationship: $relationship, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('knowsAboutDiagnosis: $knowsAboutDiagnosis, ')
          ..write('knowsAboutParts: $knowsAboutParts, ')
          ..write('knowsAboutTrauma: $knowsAboutTrauma, ')
          ..write('preferredContactMethod: $preferredContactMethod, ')
          ..write('availableHours: $availableHours, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    rank,
    name,
    relationship,
    phone,
    email,
    knowsAboutDiagnosis,
    knowsAboutParts,
    knowsAboutTrauma,
    preferredContactMethod,
    availableHours,
    notes,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EmergencyContactData &&
          other.id == this.id &&
          other.rank == this.rank &&
          other.name == this.name &&
          other.relationship == this.relationship &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.knowsAboutDiagnosis == this.knowsAboutDiagnosis &&
          other.knowsAboutParts == this.knowsAboutParts &&
          other.knowsAboutTrauma == this.knowsAboutTrauma &&
          other.preferredContactMethod == this.preferredContactMethod &&
          other.availableHours == this.availableHours &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class EmergencyContactsCompanion extends UpdateCompanion<EmergencyContactData> {
  final Value<String> id;
  final Value<int> rank;
  final Value<String> name;
  final Value<String> relationship;
  final Value<String> phone;
  final Value<String?> email;
  final Value<bool> knowsAboutDiagnosis;
  final Value<bool> knowsAboutParts;
  final Value<bool> knowsAboutTrauma;
  final Value<String> preferredContactMethod;
  final Value<String?> availableHours;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const EmergencyContactsCompanion({
    this.id = const Value.absent(),
    this.rank = const Value.absent(),
    this.name = const Value.absent(),
    this.relationship = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.knowsAboutDiagnosis = const Value.absent(),
    this.knowsAboutParts = const Value.absent(),
    this.knowsAboutTrauma = const Value.absent(),
    this.preferredContactMethod = const Value.absent(),
    this.availableHours = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EmergencyContactsCompanion.insert({
    this.id = const Value.absent(),
    this.rank = const Value.absent(),
    required String name,
    required String relationship,
    required String phone,
    this.email = const Value.absent(),
    this.knowsAboutDiagnosis = const Value.absent(),
    this.knowsAboutParts = const Value.absent(),
    this.knowsAboutTrauma = const Value.absent(),
    this.preferredContactMethod = const Value.absent(),
    this.availableHours = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : name = Value(name),
       relationship = Value(relationship),
       phone = Value(phone);
  static Insertable<EmergencyContactData> custom({
    Expression<String>? id,
    Expression<int>? rank,
    Expression<String>? name,
    Expression<String>? relationship,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<bool>? knowsAboutDiagnosis,
    Expression<bool>? knowsAboutParts,
    Expression<bool>? knowsAboutTrauma,
    Expression<String>? preferredContactMethod,
    Expression<String>? availableHours,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (rank != null) 'rank': rank,
      if (name != null) 'name': name,
      if (relationship != null) 'relationship': relationship,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (knowsAboutDiagnosis != null)
        'knows_about_diagnosis': knowsAboutDiagnosis,
      if (knowsAboutParts != null) 'knows_about_parts': knowsAboutParts,
      if (knowsAboutTrauma != null) 'knows_about_trauma': knowsAboutTrauma,
      if (preferredContactMethod != null)
        'preferred_contact_method': preferredContactMethod,
      if (availableHours != null) 'available_hours': availableHours,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EmergencyContactsCompanion copyWith({
    Value<String>? id,
    Value<int>? rank,
    Value<String>? name,
    Value<String>? relationship,
    Value<String>? phone,
    Value<String?>? email,
    Value<bool>? knowsAboutDiagnosis,
    Value<bool>? knowsAboutParts,
    Value<bool>? knowsAboutTrauma,
    Value<String>? preferredContactMethod,
    Value<String?>? availableHours,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return EmergencyContactsCompanion(
      id: id ?? this.id,
      rank: rank ?? this.rank,
      name: name ?? this.name,
      relationship: relationship ?? this.relationship,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      knowsAboutDiagnosis: knowsAboutDiagnosis ?? this.knowsAboutDiagnosis,
      knowsAboutParts: knowsAboutParts ?? this.knowsAboutParts,
      knowsAboutTrauma: knowsAboutTrauma ?? this.knowsAboutTrauma,
      preferredContactMethod:
          preferredContactMethod ?? this.preferredContactMethod,
      availableHours: availableHours ?? this.availableHours,
      notes: notes ?? this.notes,
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
    if (rank.present) {
      map['rank'] = Variable<int>(rank.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (relationship.present) {
      map['relationship'] = Variable<String>(relationship.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (knowsAboutDiagnosis.present) {
      map['knows_about_diagnosis'] = Variable<bool>(knowsAboutDiagnosis.value);
    }
    if (knowsAboutParts.present) {
      map['knows_about_parts'] = Variable<bool>(knowsAboutParts.value);
    }
    if (knowsAboutTrauma.present) {
      map['knows_about_trauma'] = Variable<bool>(knowsAboutTrauma.value);
    }
    if (preferredContactMethod.present) {
      map['preferred_contact_method'] = Variable<String>(
        preferredContactMethod.value,
      );
    }
    if (availableHours.present) {
      map['available_hours'] = Variable<String>(availableHours.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
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
    return (StringBuffer('EmergencyContactsCompanion(')
          ..write('id: $id, ')
          ..write('rank: $rank, ')
          ..write('name: $name, ')
          ..write('relationship: $relationship, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('knowsAboutDiagnosis: $knowsAboutDiagnosis, ')
          ..write('knowsAboutParts: $knowsAboutParts, ')
          ..write('knowsAboutTrauma: $knowsAboutTrauma, ')
          ..write('preferredContactMethod: $preferredContactMethod, ')
          ..write('availableHours: $availableHours, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MedicalRecordsTable extends MedicalRecords
    with TableInfo<$MedicalRecordsTable, MedicalRecordData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicalRecordsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _bloodTypeMeta = const VerificationMeta(
    'bloodType',
  );
  @override
  late final GeneratedColumn<String> bloodType = GeneratedColumn<String>(
    'blood_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _allergiesMeta = const VerificationMeta(
    'allergies',
  );
  @override
  late final GeneratedColumn<String> allergies = GeneratedColumn<String>(
    'allergies',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _medicationsMeta = const VerificationMeta(
    'medications',
  );
  @override
  late final GeneratedColumn<String> medications = GeneratedColumn<String>(
    'medications',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _diagnosesMeta = const VerificationMeta(
    'diagnoses',
  );
  @override
  late final GeneratedColumn<String> diagnoses = GeneratedColumn<String>(
    'diagnoses',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _primaryPhysicianMeta = const VerificationMeta(
    'primaryPhysician',
  );
  @override
  late final GeneratedColumn<String> primaryPhysician = GeneratedColumn<String>(
    'primary_physician',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _healthInsuranceProviderMeta =
      const VerificationMeta('healthInsuranceProvider');
  @override
  late final GeneratedColumn<String> healthInsuranceProvider =
      GeneratedColumn<String>(
        'health_insurance_provider',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _healthInsuranceMemberIdMeta =
      const VerificationMeta('healthInsuranceMemberId');
  @override
  late final GeneratedColumn<String> healthInsuranceMemberId =
      GeneratedColumn<String>(
        'health_insurance_member_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
    bloodType,
    allergies,
    medications,
    diagnoses,
    primaryPhysician,
    healthInsuranceProvider,
    healthInsuranceMemberId,
    notes,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medical_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<MedicalRecordData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('blood_type')) {
      context.handle(
        _bloodTypeMeta,
        bloodType.isAcceptableOrUnknown(data['blood_type']!, _bloodTypeMeta),
      );
    }
    if (data.containsKey('allergies')) {
      context.handle(
        _allergiesMeta,
        allergies.isAcceptableOrUnknown(data['allergies']!, _allergiesMeta),
      );
    }
    if (data.containsKey('medications')) {
      context.handle(
        _medicationsMeta,
        medications.isAcceptableOrUnknown(
          data['medications']!,
          _medicationsMeta,
        ),
      );
    }
    if (data.containsKey('diagnoses')) {
      context.handle(
        _diagnosesMeta,
        diagnoses.isAcceptableOrUnknown(data['diagnoses']!, _diagnosesMeta),
      );
    }
    if (data.containsKey('primary_physician')) {
      context.handle(
        _primaryPhysicianMeta,
        primaryPhysician.isAcceptableOrUnknown(
          data['primary_physician']!,
          _primaryPhysicianMeta,
        ),
      );
    }
    if (data.containsKey('health_insurance_provider')) {
      context.handle(
        _healthInsuranceProviderMeta,
        healthInsuranceProvider.isAcceptableOrUnknown(
          data['health_insurance_provider']!,
          _healthInsuranceProviderMeta,
        ),
      );
    }
    if (data.containsKey('health_insurance_member_id')) {
      context.handle(
        _healthInsuranceMemberIdMeta,
        healthInsuranceMemberId.isAcceptableOrUnknown(
          data['health_insurance_member_id']!,
          _healthInsuranceMemberIdMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
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
  MedicalRecordData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MedicalRecordData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      bloodType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}blood_type'],
      ),
      allergies: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}allergies'],
      ),
      medications: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}medications'],
      ),
      diagnoses: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}diagnoses'],
      ),
      primaryPhysician: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}primary_physician'],
      ),
      healthInsuranceProvider: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}health_insurance_provider'],
      ),
      healthInsuranceMemberId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}health_insurance_member_id'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $MedicalRecordsTable createAlias(String alias) {
    return $MedicalRecordsTable(attachedDatabase, alias);
  }
}

class MedicalRecordData extends DataClass
    implements Insertable<MedicalRecordData> {
  final String id;
  final String? bloodType;
  final String? allergies;
  final String? medications;
  final String? diagnoses;
  final String? primaryPhysician;
  final String? healthInsuranceProvider;
  final String? healthInsuranceMemberId;
  final String? notes;
  final DateTime updatedAt;
  const MedicalRecordData({
    required this.id,
    this.bloodType,
    this.allergies,
    this.medications,
    this.diagnoses,
    this.primaryPhysician,
    this.healthInsuranceProvider,
    this.healthInsuranceMemberId,
    this.notes,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || bloodType != null) {
      map['blood_type'] = Variable<String>(bloodType);
    }
    if (!nullToAbsent || allergies != null) {
      map['allergies'] = Variable<String>(allergies);
    }
    if (!nullToAbsent || medications != null) {
      map['medications'] = Variable<String>(medications);
    }
    if (!nullToAbsent || diagnoses != null) {
      map['diagnoses'] = Variable<String>(diagnoses);
    }
    if (!nullToAbsent || primaryPhysician != null) {
      map['primary_physician'] = Variable<String>(primaryPhysician);
    }
    if (!nullToAbsent || healthInsuranceProvider != null) {
      map['health_insurance_provider'] = Variable<String>(
        healthInsuranceProvider,
      );
    }
    if (!nullToAbsent || healthInsuranceMemberId != null) {
      map['health_insurance_member_id'] = Variable<String>(
        healthInsuranceMemberId,
      );
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  MedicalRecordsCompanion toCompanion(bool nullToAbsent) {
    return MedicalRecordsCompanion(
      id: Value(id),
      bloodType: bloodType == null && nullToAbsent
          ? const Value.absent()
          : Value(bloodType),
      allergies: allergies == null && nullToAbsent
          ? const Value.absent()
          : Value(allergies),
      medications: medications == null && nullToAbsent
          ? const Value.absent()
          : Value(medications),
      diagnoses: diagnoses == null && nullToAbsent
          ? const Value.absent()
          : Value(diagnoses),
      primaryPhysician: primaryPhysician == null && nullToAbsent
          ? const Value.absent()
          : Value(primaryPhysician),
      healthInsuranceProvider: healthInsuranceProvider == null && nullToAbsent
          ? const Value.absent()
          : Value(healthInsuranceProvider),
      healthInsuranceMemberId: healthInsuranceMemberId == null && nullToAbsent
          ? const Value.absent()
          : Value(healthInsuranceMemberId),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      updatedAt: Value(updatedAt),
    );
  }

  factory MedicalRecordData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MedicalRecordData(
      id: serializer.fromJson<String>(json['id']),
      bloodType: serializer.fromJson<String?>(json['bloodType']),
      allergies: serializer.fromJson<String?>(json['allergies']),
      medications: serializer.fromJson<String?>(json['medications']),
      diagnoses: serializer.fromJson<String?>(json['diagnoses']),
      primaryPhysician: serializer.fromJson<String?>(json['primaryPhysician']),
      healthInsuranceProvider: serializer.fromJson<String?>(
        json['healthInsuranceProvider'],
      ),
      healthInsuranceMemberId: serializer.fromJson<String?>(
        json['healthInsuranceMemberId'],
      ),
      notes: serializer.fromJson<String?>(json['notes']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'bloodType': serializer.toJson<String?>(bloodType),
      'allergies': serializer.toJson<String?>(allergies),
      'medications': serializer.toJson<String?>(medications),
      'diagnoses': serializer.toJson<String?>(diagnoses),
      'primaryPhysician': serializer.toJson<String?>(primaryPhysician),
      'healthInsuranceProvider': serializer.toJson<String?>(
        healthInsuranceProvider,
      ),
      'healthInsuranceMemberId': serializer.toJson<String?>(
        healthInsuranceMemberId,
      ),
      'notes': serializer.toJson<String?>(notes),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  MedicalRecordData copyWith({
    String? id,
    Value<String?> bloodType = const Value.absent(),
    Value<String?> allergies = const Value.absent(),
    Value<String?> medications = const Value.absent(),
    Value<String?> diagnoses = const Value.absent(),
    Value<String?> primaryPhysician = const Value.absent(),
    Value<String?> healthInsuranceProvider = const Value.absent(),
    Value<String?> healthInsuranceMemberId = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? updatedAt,
  }) => MedicalRecordData(
    id: id ?? this.id,
    bloodType: bloodType.present ? bloodType.value : this.bloodType,
    allergies: allergies.present ? allergies.value : this.allergies,
    medications: medications.present ? medications.value : this.medications,
    diagnoses: diagnoses.present ? diagnoses.value : this.diagnoses,
    primaryPhysician: primaryPhysician.present
        ? primaryPhysician.value
        : this.primaryPhysician,
    healthInsuranceProvider: healthInsuranceProvider.present
        ? healthInsuranceProvider.value
        : this.healthInsuranceProvider,
    healthInsuranceMemberId: healthInsuranceMemberId.present
        ? healthInsuranceMemberId.value
        : this.healthInsuranceMemberId,
    notes: notes.present ? notes.value : this.notes,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  MedicalRecordData copyWithCompanion(MedicalRecordsCompanion data) {
    return MedicalRecordData(
      id: data.id.present ? data.id.value : this.id,
      bloodType: data.bloodType.present ? data.bloodType.value : this.bloodType,
      allergies: data.allergies.present ? data.allergies.value : this.allergies,
      medications: data.medications.present
          ? data.medications.value
          : this.medications,
      diagnoses: data.diagnoses.present ? data.diagnoses.value : this.diagnoses,
      primaryPhysician: data.primaryPhysician.present
          ? data.primaryPhysician.value
          : this.primaryPhysician,
      healthInsuranceProvider: data.healthInsuranceProvider.present
          ? data.healthInsuranceProvider.value
          : this.healthInsuranceProvider,
      healthInsuranceMemberId: data.healthInsuranceMemberId.present
          ? data.healthInsuranceMemberId.value
          : this.healthInsuranceMemberId,
      notes: data.notes.present ? data.notes.value : this.notes,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MedicalRecordData(')
          ..write('id: $id, ')
          ..write('bloodType: $bloodType, ')
          ..write('allergies: $allergies, ')
          ..write('medications: $medications, ')
          ..write('diagnoses: $diagnoses, ')
          ..write('primaryPhysician: $primaryPhysician, ')
          ..write('healthInsuranceProvider: $healthInsuranceProvider, ')
          ..write('healthInsuranceMemberId: $healthInsuranceMemberId, ')
          ..write('notes: $notes, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    bloodType,
    allergies,
    medications,
    diagnoses,
    primaryPhysician,
    healthInsuranceProvider,
    healthInsuranceMemberId,
    notes,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MedicalRecordData &&
          other.id == this.id &&
          other.bloodType == this.bloodType &&
          other.allergies == this.allergies &&
          other.medications == this.medications &&
          other.diagnoses == this.diagnoses &&
          other.primaryPhysician == this.primaryPhysician &&
          other.healthInsuranceProvider == this.healthInsuranceProvider &&
          other.healthInsuranceMemberId == this.healthInsuranceMemberId &&
          other.notes == this.notes &&
          other.updatedAt == this.updatedAt);
}

class MedicalRecordsCompanion extends UpdateCompanion<MedicalRecordData> {
  final Value<String> id;
  final Value<String?> bloodType;
  final Value<String?> allergies;
  final Value<String?> medications;
  final Value<String?> diagnoses;
  final Value<String?> primaryPhysician;
  final Value<String?> healthInsuranceProvider;
  final Value<String?> healthInsuranceMemberId;
  final Value<String?> notes;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const MedicalRecordsCompanion({
    this.id = const Value.absent(),
    this.bloodType = const Value.absent(),
    this.allergies = const Value.absent(),
    this.medications = const Value.absent(),
    this.diagnoses = const Value.absent(),
    this.primaryPhysician = const Value.absent(),
    this.healthInsuranceProvider = const Value.absent(),
    this.healthInsuranceMemberId = const Value.absent(),
    this.notes = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MedicalRecordsCompanion.insert({
    this.id = const Value.absent(),
    this.bloodType = const Value.absent(),
    this.allergies = const Value.absent(),
    this.medications = const Value.absent(),
    this.diagnoses = const Value.absent(),
    this.primaryPhysician = const Value.absent(),
    this.healthInsuranceProvider = const Value.absent(),
    this.healthInsuranceMemberId = const Value.absent(),
    this.notes = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  static Insertable<MedicalRecordData> custom({
    Expression<String>? id,
    Expression<String>? bloodType,
    Expression<String>? allergies,
    Expression<String>? medications,
    Expression<String>? diagnoses,
    Expression<String>? primaryPhysician,
    Expression<String>? healthInsuranceProvider,
    Expression<String>? healthInsuranceMemberId,
    Expression<String>? notes,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bloodType != null) 'blood_type': bloodType,
      if (allergies != null) 'allergies': allergies,
      if (medications != null) 'medications': medications,
      if (diagnoses != null) 'diagnoses': diagnoses,
      if (primaryPhysician != null) 'primary_physician': primaryPhysician,
      if (healthInsuranceProvider != null)
        'health_insurance_provider': healthInsuranceProvider,
      if (healthInsuranceMemberId != null)
        'health_insurance_member_id': healthInsuranceMemberId,
      if (notes != null) 'notes': notes,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MedicalRecordsCompanion copyWith({
    Value<String>? id,
    Value<String?>? bloodType,
    Value<String?>? allergies,
    Value<String?>? medications,
    Value<String?>? diagnoses,
    Value<String?>? primaryPhysician,
    Value<String?>? healthInsuranceProvider,
    Value<String?>? healthInsuranceMemberId,
    Value<String?>? notes,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return MedicalRecordsCompanion(
      id: id ?? this.id,
      bloodType: bloodType ?? this.bloodType,
      allergies: allergies ?? this.allergies,
      medications: medications ?? this.medications,
      diagnoses: diagnoses ?? this.diagnoses,
      primaryPhysician: primaryPhysician ?? this.primaryPhysician,
      healthInsuranceProvider:
          healthInsuranceProvider ?? this.healthInsuranceProvider,
      healthInsuranceMemberId:
          healthInsuranceMemberId ?? this.healthInsuranceMemberId,
      notes: notes ?? this.notes,
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
    if (bloodType.present) {
      map['blood_type'] = Variable<String>(bloodType.value);
    }
    if (allergies.present) {
      map['allergies'] = Variable<String>(allergies.value);
    }
    if (medications.present) {
      map['medications'] = Variable<String>(medications.value);
    }
    if (diagnoses.present) {
      map['diagnoses'] = Variable<String>(diagnoses.value);
    }
    if (primaryPhysician.present) {
      map['primary_physician'] = Variable<String>(primaryPhysician.value);
    }
    if (healthInsuranceProvider.present) {
      map['health_insurance_provider'] = Variable<String>(
        healthInsuranceProvider.value,
      );
    }
    if (healthInsuranceMemberId.present) {
      map['health_insurance_member_id'] = Variable<String>(
        healthInsuranceMemberId.value,
      );
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
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
    return (StringBuffer('MedicalRecordsCompanion(')
          ..write('id: $id, ')
          ..write('bloodType: $bloodType, ')
          ..write('allergies: $allergies, ')
          ..write('medications: $medications, ')
          ..write('diagnoses: $diagnoses, ')
          ..write('primaryPhysician: $primaryPhysician, ')
          ..write('healthInsuranceProvider: $healthInsuranceProvider, ')
          ..write('healthInsuranceMemberId: $healthInsuranceMemberId, ')
          ..write('notes: $notes, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $JournalEntriesTable extends JournalEntries
    with TableInfo<$JournalEntriesTable, JournalEntryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JournalEntriesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _partIdMeta = const VerificationMeta('partId');
  @override
  late final GeneratedColumn<String> partId = GeneratedColumn<String>(
    'part_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES parts (id)',
    ),
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _moodMeta = const VerificationMeta('mood');
  @override
  late final GeneratedColumn<String> mood = GeneratedColumn<String>(
    'mood',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isPrivateMeta = const VerificationMeta(
    'isPrivate',
  );
  @override
  late final GeneratedColumn<bool> isPrivate = GeneratedColumn<bool>(
    'is_private',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_private" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
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
    partId,
    content,
    mood,
    isPrivate,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'journal_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<JournalEntryData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('part_id')) {
      context.handle(
        _partIdMeta,
        partId.isAcceptableOrUnknown(data['part_id']!, _partIdMeta),
      );
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('mood')) {
      context.handle(
        _moodMeta,
        mood.isAcceptableOrUnknown(data['mood']!, _moodMeta),
      );
    }
    if (data.containsKey('is_private')) {
      context.handle(
        _isPrivateMeta,
        isPrivate.isAcceptableOrUnknown(data['is_private']!, _isPrivateMeta),
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
  JournalEntryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JournalEntryData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      partId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}part_id'],
      ),
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      mood: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mood'],
      ),
      isPrivate: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_private'],
      )!,
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
  $JournalEntriesTable createAlias(String alias) {
    return $JournalEntriesTable(attachedDatabase, alias);
  }
}

class JournalEntryData extends DataClass
    implements Insertable<JournalEntryData> {
  final String id;
  final String? partId;
  final String content;
  final String? mood;
  final bool isPrivate;
  final DateTime createdAt;
  final DateTime updatedAt;
  const JournalEntryData({
    required this.id,
    this.partId,
    required this.content,
    this.mood,
    required this.isPrivate,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || partId != null) {
      map['part_id'] = Variable<String>(partId);
    }
    map['content'] = Variable<String>(content);
    if (!nullToAbsent || mood != null) {
      map['mood'] = Variable<String>(mood);
    }
    map['is_private'] = Variable<bool>(isPrivate);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  JournalEntriesCompanion toCompanion(bool nullToAbsent) {
    return JournalEntriesCompanion(
      id: Value(id),
      partId: partId == null && nullToAbsent
          ? const Value.absent()
          : Value(partId),
      content: Value(content),
      mood: mood == null && nullToAbsent ? const Value.absent() : Value(mood),
      isPrivate: Value(isPrivate),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory JournalEntryData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return JournalEntryData(
      id: serializer.fromJson<String>(json['id']),
      partId: serializer.fromJson<String?>(json['partId']),
      content: serializer.fromJson<String>(json['content']),
      mood: serializer.fromJson<String?>(json['mood']),
      isPrivate: serializer.fromJson<bool>(json['isPrivate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'partId': serializer.toJson<String?>(partId),
      'content': serializer.toJson<String>(content),
      'mood': serializer.toJson<String?>(mood),
      'isPrivate': serializer.toJson<bool>(isPrivate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  JournalEntryData copyWith({
    String? id,
    Value<String?> partId = const Value.absent(),
    String? content,
    Value<String?> mood = const Value.absent(),
    bool? isPrivate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => JournalEntryData(
    id: id ?? this.id,
    partId: partId.present ? partId.value : this.partId,
    content: content ?? this.content,
    mood: mood.present ? mood.value : this.mood,
    isPrivate: isPrivate ?? this.isPrivate,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  JournalEntryData copyWithCompanion(JournalEntriesCompanion data) {
    return JournalEntryData(
      id: data.id.present ? data.id.value : this.id,
      partId: data.partId.present ? data.partId.value : this.partId,
      content: data.content.present ? data.content.value : this.content,
      mood: data.mood.present ? data.mood.value : this.mood,
      isPrivate: data.isPrivate.present ? data.isPrivate.value : this.isPrivate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('JournalEntryData(')
          ..write('id: $id, ')
          ..write('partId: $partId, ')
          ..write('content: $content, ')
          ..write('mood: $mood, ')
          ..write('isPrivate: $isPrivate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, partId, content, mood, isPrivate, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is JournalEntryData &&
          other.id == this.id &&
          other.partId == this.partId &&
          other.content == this.content &&
          other.mood == this.mood &&
          other.isPrivate == this.isPrivate &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class JournalEntriesCompanion extends UpdateCompanion<JournalEntryData> {
  final Value<String> id;
  final Value<String?> partId;
  final Value<String> content;
  final Value<String?> mood;
  final Value<bool> isPrivate;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const JournalEntriesCompanion({
    this.id = const Value.absent(),
    this.partId = const Value.absent(),
    this.content = const Value.absent(),
    this.mood = const Value.absent(),
    this.isPrivate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  JournalEntriesCompanion.insert({
    this.id = const Value.absent(),
    this.partId = const Value.absent(),
    required String content,
    this.mood = const Value.absent(),
    this.isPrivate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : content = Value(content);
  static Insertable<JournalEntryData> custom({
    Expression<String>? id,
    Expression<String>? partId,
    Expression<String>? content,
    Expression<String>? mood,
    Expression<bool>? isPrivate,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (partId != null) 'part_id': partId,
      if (content != null) 'content': content,
      if (mood != null) 'mood': mood,
      if (isPrivate != null) 'is_private': isPrivate,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  JournalEntriesCompanion copyWith({
    Value<String>? id,
    Value<String?>? partId,
    Value<String>? content,
    Value<String?>? mood,
    Value<bool>? isPrivate,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return JournalEntriesCompanion(
      id: id ?? this.id,
      partId: partId ?? this.partId,
      content: content ?? this.content,
      mood: mood ?? this.mood,
      isPrivate: isPrivate ?? this.isPrivate,
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
    if (partId.present) {
      map['part_id'] = Variable<String>(partId.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (mood.present) {
      map['mood'] = Variable<String>(mood.value);
    }
    if (isPrivate.present) {
      map['is_private'] = Variable<bool>(isPrivate.value);
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
    return (StringBuffer('JournalEntriesCompanion(')
          ..write('id: $id, ')
          ..write('partId: $partId, ')
          ..write('content: $content, ')
          ..write('mood: $mood, ')
          ..write('isPrivate: $isPrivate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ConnectionsTable extends Connections
    with TableInfo<$ConnectionsTable, ConnectionData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConnectionsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _remoteDeviceIdMeta = const VerificationMeta(
    'remoteDeviceId',
  );
  @override
  late final GeneratedColumn<String> remoteDeviceId = GeneratedColumn<String>(
    'remote_device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _remoteDisplayNameMeta = const VerificationMeta(
    'remoteDisplayName',
  );
  @override
  late final GeneratedColumn<String> remoteDisplayName =
      GeneratedColumn<String>(
        'remote_display_name',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('partner'),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _pairedAtMeta = const VerificationMeta(
    'pairedAt',
  );
  @override
  late final GeneratedColumn<DateTime> pairedAt = GeneratedColumn<DateTime>(
    'paired_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _remoteDataMeta = const VerificationMeta(
    'remoteData',
  );
  @override
  late final GeneratedColumn<String> remoteData = GeneratedColumn<String>(
    'remote_data',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    remoteDeviceId,
    remoteDisplayName,
    role,
    isActive,
    pairedAt,
    remoteData,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'connections';
  @override
  VerificationContext validateIntegrity(
    Insertable<ConnectionData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('remote_device_id')) {
      context.handle(
        _remoteDeviceIdMeta,
        remoteDeviceId.isAcceptableOrUnknown(
          data['remote_device_id']!,
          _remoteDeviceIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_remoteDeviceIdMeta);
    }
    if (data.containsKey('remote_display_name')) {
      context.handle(
        _remoteDisplayNameMeta,
        remoteDisplayName.isAcceptableOrUnknown(
          data['remote_display_name']!,
          _remoteDisplayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_remoteDisplayNameMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('paired_at')) {
      context.handle(
        _pairedAtMeta,
        pairedAt.isAcceptableOrUnknown(data['paired_at']!, _pairedAtMeta),
      );
    }
    if (data.containsKey('remote_data')) {
      context.handle(
        _remoteDataMeta,
        remoteData.isAcceptableOrUnknown(data['remote_data']!, _remoteDataMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ConnectionData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ConnectionData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      remoteDeviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_device_id'],
      )!,
      remoteDisplayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_display_name'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      pairedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}paired_at'],
      )!,
      remoteData: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_data'],
      ),
    );
  }

  @override
  $ConnectionsTable createAlias(String alias) {
    return $ConnectionsTable(attachedDatabase, alias);
  }
}

class ConnectionData extends DataClass implements Insertable<ConnectionData> {
  final String id;
  final String remoteDeviceId;
  final String remoteDisplayName;
  final String role;
  final bool isActive;
  final DateTime pairedAt;
  final String? remoteData;
  const ConnectionData({
    required this.id,
    required this.remoteDeviceId,
    required this.remoteDisplayName,
    required this.role,
    required this.isActive,
    required this.pairedAt,
    this.remoteData,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['remote_device_id'] = Variable<String>(remoteDeviceId);
    map['remote_display_name'] = Variable<String>(remoteDisplayName);
    map['role'] = Variable<String>(role);
    map['is_active'] = Variable<bool>(isActive);
    map['paired_at'] = Variable<DateTime>(pairedAt);
    if (!nullToAbsent || remoteData != null) {
      map['remote_data'] = Variable<String>(remoteData);
    }
    return map;
  }

  ConnectionsCompanion toCompanion(bool nullToAbsent) {
    return ConnectionsCompanion(
      id: Value(id),
      remoteDeviceId: Value(remoteDeviceId),
      remoteDisplayName: Value(remoteDisplayName),
      role: Value(role),
      isActive: Value(isActive),
      pairedAt: Value(pairedAt),
      remoteData: remoteData == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteData),
    );
  }

  factory ConnectionData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ConnectionData(
      id: serializer.fromJson<String>(json['id']),
      remoteDeviceId: serializer.fromJson<String>(json['remoteDeviceId']),
      remoteDisplayName: serializer.fromJson<String>(json['remoteDisplayName']),
      role: serializer.fromJson<String>(json['role']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      pairedAt: serializer.fromJson<DateTime>(json['pairedAt']),
      remoteData: serializer.fromJson<String?>(json['remoteData']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'remoteDeviceId': serializer.toJson<String>(remoteDeviceId),
      'remoteDisplayName': serializer.toJson<String>(remoteDisplayName),
      'role': serializer.toJson<String>(role),
      'isActive': serializer.toJson<bool>(isActive),
      'pairedAt': serializer.toJson<DateTime>(pairedAt),
      'remoteData': serializer.toJson<String?>(remoteData),
    };
  }

  ConnectionData copyWith({
    String? id,
    String? remoteDeviceId,
    String? remoteDisplayName,
    String? role,
    bool? isActive,
    DateTime? pairedAt,
    Value<String?> remoteData = const Value.absent(),
  }) => ConnectionData(
    id: id ?? this.id,
    remoteDeviceId: remoteDeviceId ?? this.remoteDeviceId,
    remoteDisplayName: remoteDisplayName ?? this.remoteDisplayName,
    role: role ?? this.role,
    isActive: isActive ?? this.isActive,
    pairedAt: pairedAt ?? this.pairedAt,
    remoteData: remoteData.present ? remoteData.value : this.remoteData,
  );
  ConnectionData copyWithCompanion(ConnectionsCompanion data) {
    return ConnectionData(
      id: data.id.present ? data.id.value : this.id,
      remoteDeviceId: data.remoteDeviceId.present
          ? data.remoteDeviceId.value
          : this.remoteDeviceId,
      remoteDisplayName: data.remoteDisplayName.present
          ? data.remoteDisplayName.value
          : this.remoteDisplayName,
      role: data.role.present ? data.role.value : this.role,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      pairedAt: data.pairedAt.present ? data.pairedAt.value : this.pairedAt,
      remoteData: data.remoteData.present
          ? data.remoteData.value
          : this.remoteData,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ConnectionData(')
          ..write('id: $id, ')
          ..write('remoteDeviceId: $remoteDeviceId, ')
          ..write('remoteDisplayName: $remoteDisplayName, ')
          ..write('role: $role, ')
          ..write('isActive: $isActive, ')
          ..write('pairedAt: $pairedAt, ')
          ..write('remoteData: $remoteData')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    remoteDeviceId,
    remoteDisplayName,
    role,
    isActive,
    pairedAt,
    remoteData,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ConnectionData &&
          other.id == this.id &&
          other.remoteDeviceId == this.remoteDeviceId &&
          other.remoteDisplayName == this.remoteDisplayName &&
          other.role == this.role &&
          other.isActive == this.isActive &&
          other.pairedAt == this.pairedAt &&
          other.remoteData == this.remoteData);
}

class ConnectionsCompanion extends UpdateCompanion<ConnectionData> {
  final Value<String> id;
  final Value<String> remoteDeviceId;
  final Value<String> remoteDisplayName;
  final Value<String> role;
  final Value<bool> isActive;
  final Value<DateTime> pairedAt;
  final Value<String?> remoteData;
  final Value<int> rowid;
  const ConnectionsCompanion({
    this.id = const Value.absent(),
    this.remoteDeviceId = const Value.absent(),
    this.remoteDisplayName = const Value.absent(),
    this.role = const Value.absent(),
    this.isActive = const Value.absent(),
    this.pairedAt = const Value.absent(),
    this.remoteData = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ConnectionsCompanion.insert({
    this.id = const Value.absent(),
    required String remoteDeviceId,
    required String remoteDisplayName,
    this.role = const Value.absent(),
    this.isActive = const Value.absent(),
    this.pairedAt = const Value.absent(),
    this.remoteData = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : remoteDeviceId = Value(remoteDeviceId),
       remoteDisplayName = Value(remoteDisplayName);
  static Insertable<ConnectionData> custom({
    Expression<String>? id,
    Expression<String>? remoteDeviceId,
    Expression<String>? remoteDisplayName,
    Expression<String>? role,
    Expression<bool>? isActive,
    Expression<DateTime>? pairedAt,
    Expression<String>? remoteData,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (remoteDeviceId != null) 'remote_device_id': remoteDeviceId,
      if (remoteDisplayName != null) 'remote_display_name': remoteDisplayName,
      if (role != null) 'role': role,
      if (isActive != null) 'is_active': isActive,
      if (pairedAt != null) 'paired_at': pairedAt,
      if (remoteData != null) 'remote_data': remoteData,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ConnectionsCompanion copyWith({
    Value<String>? id,
    Value<String>? remoteDeviceId,
    Value<String>? remoteDisplayName,
    Value<String>? role,
    Value<bool>? isActive,
    Value<DateTime>? pairedAt,
    Value<String?>? remoteData,
    Value<int>? rowid,
  }) {
    return ConnectionsCompanion(
      id: id ?? this.id,
      remoteDeviceId: remoteDeviceId ?? this.remoteDeviceId,
      remoteDisplayName: remoteDisplayName ?? this.remoteDisplayName,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      pairedAt: pairedAt ?? this.pairedAt,
      remoteData: remoteData ?? this.remoteData,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (remoteDeviceId.present) {
      map['remote_device_id'] = Variable<String>(remoteDeviceId.value);
    }
    if (remoteDisplayName.present) {
      map['remote_display_name'] = Variable<String>(remoteDisplayName.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (pairedAt.present) {
      map['paired_at'] = Variable<DateTime>(pairedAt.value);
    }
    if (remoteData.present) {
      map['remote_data'] = Variable<String>(remoteData.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConnectionsCompanion(')
          ..write('id: $id, ')
          ..write('remoteDeviceId: $remoteDeviceId, ')
          ..write('remoteDisplayName: $remoteDisplayName, ')
          ..write('role: $role, ')
          ..write('isActive: $isActive, ')
          ..write('pairedAt: $pairedAt, ')
          ..write('remoteData: $remoteData, ')
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
  late final $SwitchEventsTable switchEvents = $SwitchEventsTable(this);
  late final $ConsentProfilesTable consentProfiles = $ConsentProfilesTable(
    this,
  );
  late final $TriggerEntriesTable triggerEntries = $TriggerEntriesTable(this);
  late final $EmergencyContactsTable emergencyContacts =
      $EmergencyContactsTable(this);
  late final $MedicalRecordsTable medicalRecords = $MedicalRecordsTable(this);
  late final $JournalEntriesTable journalEntries = $JournalEntriesTable(this);
  late final $ConnectionsTable connections = $ConnectionsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    systems,
    parts,
    switchEvents,
    consentProfiles,
    triggerEntries,
    emergencyContacts,
    medicalRecords,
    journalEntries,
    connections,
  ];
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

final class $$PartsTableReferences
    extends BaseReferences<_$AppDatabase, $PartsTable, PartsData> {
  $$PartsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ConsentProfilesTable, List<ConsentProfileData>>
  _consentProfilesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.consentProfiles,
    aliasName: $_aliasNameGenerator(db.parts.id, db.consentProfiles.partId),
  );

  $$ConsentProfilesTableProcessedTableManager get consentProfilesRefs {
    final manager = $$ConsentProfilesTableTableManager(
      $_db,
      $_db.consentProfiles,
    ).filter((f) => f.partId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _consentProfilesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TriggerEntriesTable, List<TriggerEntryData>>
  _triggerEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.triggerEntries,
    aliasName: $_aliasNameGenerator(db.parts.id, db.triggerEntries.partId),
  );

  $$TriggerEntriesTableProcessedTableManager get triggerEntriesRefs {
    final manager = $$TriggerEntriesTableTableManager(
      $_db,
      $_db.triggerEntries,
    ).filter((f) => f.partId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_triggerEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$JournalEntriesTable, List<JournalEntryData>>
  _journalEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.journalEntries,
    aliasName: $_aliasNameGenerator(db.parts.id, db.journalEntries.partId),
  );

  $$JournalEntriesTableProcessedTableManager get journalEntriesRefs {
    final manager = $$JournalEntriesTableTableManager(
      $_db,
      $_db.journalEntries,
    ).filter((f) => f.partId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_journalEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

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

  Expression<bool> consentProfilesRefs(
    Expression<bool> Function($$ConsentProfilesTableFilterComposer f) f,
  ) {
    final $$ConsentProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.consentProfiles,
      getReferencedColumn: (t) => t.partId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ConsentProfilesTableFilterComposer(
            $db: $db,
            $table: $db.consentProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> triggerEntriesRefs(
    Expression<bool> Function($$TriggerEntriesTableFilterComposer f) f,
  ) {
    final $$TriggerEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.triggerEntries,
      getReferencedColumn: (t) => t.partId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TriggerEntriesTableFilterComposer(
            $db: $db,
            $table: $db.triggerEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> journalEntriesRefs(
    Expression<bool> Function($$JournalEntriesTableFilterComposer f) f,
  ) {
    final $$JournalEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.journalEntries,
      getReferencedColumn: (t) => t.partId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalEntriesTableFilterComposer(
            $db: $db,
            $table: $db.journalEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
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

  Expression<T> consentProfilesRefs<T extends Object>(
    Expression<T> Function($$ConsentProfilesTableAnnotationComposer a) f,
  ) {
    final $$ConsentProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.consentProfiles,
      getReferencedColumn: (t) => t.partId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ConsentProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.consentProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> triggerEntriesRefs<T extends Object>(
    Expression<T> Function($$TriggerEntriesTableAnnotationComposer a) f,
  ) {
    final $$TriggerEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.triggerEntries,
      getReferencedColumn: (t) => t.partId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TriggerEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.triggerEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> journalEntriesRefs<T extends Object>(
    Expression<T> Function($$JournalEntriesTableAnnotationComposer a) f,
  ) {
    final $$JournalEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.journalEntries,
      getReferencedColumn: (t) => t.partId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.journalEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
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
          (PartsData, $$PartsTableReferences),
          PartsData,
          PrefetchHooks Function({
            bool consentProfilesRefs,
            bool triggerEntriesRefs,
            bool journalEntriesRefs,
          })
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
              .map(
                (e) =>
                    (e.readTable(table), $$PartsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                consentProfilesRefs = false,
                triggerEntriesRefs = false,
                journalEntriesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (consentProfilesRefs) db.consentProfiles,
                    if (triggerEntriesRefs) db.triggerEntries,
                    if (journalEntriesRefs) db.journalEntries,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (consentProfilesRefs)
                        await $_getPrefetchedData<
                          PartsData,
                          $PartsTable,
                          ConsentProfileData
                        >(
                          currentTable: table,
                          referencedTable: $$PartsTableReferences
                              ._consentProfilesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PartsTableReferences(
                                db,
                                table,
                                p0,
                              ).consentProfilesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.partId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (triggerEntriesRefs)
                        await $_getPrefetchedData<
                          PartsData,
                          $PartsTable,
                          TriggerEntryData
                        >(
                          currentTable: table,
                          referencedTable: $$PartsTableReferences
                              ._triggerEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PartsTableReferences(
                                db,
                                table,
                                p0,
                              ).triggerEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.partId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (journalEntriesRefs)
                        await $_getPrefetchedData<
                          PartsData,
                          $PartsTable,
                          JournalEntryData
                        >(
                          currentTable: table,
                          referencedTable: $$PartsTableReferences
                              ._journalEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PartsTableReferences(
                                db,
                                table,
                                p0,
                              ).journalEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.partId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
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
      (PartsData, $$PartsTableReferences),
      PartsData,
      PrefetchHooks Function({
        bool consentProfilesRefs,
        bool triggerEntriesRefs,
        bool journalEntriesRefs,
      })
    >;
typedef $$SwitchEventsTableCreateCompanionBuilder =
    SwitchEventsCompanion Function({
      Value<String> id,
      required String partId,
      Value<DateTime> timestamp,
      Value<String> markedBy,
      Value<String?> contextTags,
      Value<String?> note,
      Value<String?> remotePartName,
      Value<int> rowid,
    });
typedef $$SwitchEventsTableUpdateCompanionBuilder =
    SwitchEventsCompanion Function({
      Value<String> id,
      Value<String> partId,
      Value<DateTime> timestamp,
      Value<String> markedBy,
      Value<String?> contextTags,
      Value<String?> note,
      Value<String?> remotePartName,
      Value<int> rowid,
    });

class $$SwitchEventsTableFilterComposer
    extends Composer<_$AppDatabase, $SwitchEventsTable> {
  $$SwitchEventsTableFilterComposer({
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

  ColumnFilters<String> get partId => $composableBuilder(
    column: $table.partId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get markedBy => $composableBuilder(
    column: $table.markedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contextTags => $composableBuilder(
    column: $table.contextTags,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remotePartName => $composableBuilder(
    column: $table.remotePartName,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SwitchEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $SwitchEventsTable> {
  $$SwitchEventsTableOrderingComposer({
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

  ColumnOrderings<String> get partId => $composableBuilder(
    column: $table.partId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get markedBy => $composableBuilder(
    column: $table.markedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contextTags => $composableBuilder(
    column: $table.contextTags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remotePartName => $composableBuilder(
    column: $table.remotePartName,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SwitchEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SwitchEventsTable> {
  $$SwitchEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get partId =>
      $composableBuilder(column: $table.partId, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<String> get markedBy =>
      $composableBuilder(column: $table.markedBy, builder: (column) => column);

  GeneratedColumn<String> get contextTags => $composableBuilder(
    column: $table.contextTags,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get remotePartName => $composableBuilder(
    column: $table.remotePartName,
    builder: (column) => column,
  );
}

class $$SwitchEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SwitchEventsTable,
          SwitchEventsData,
          $$SwitchEventsTableFilterComposer,
          $$SwitchEventsTableOrderingComposer,
          $$SwitchEventsTableAnnotationComposer,
          $$SwitchEventsTableCreateCompanionBuilder,
          $$SwitchEventsTableUpdateCompanionBuilder,
          (
            SwitchEventsData,
            BaseReferences<_$AppDatabase, $SwitchEventsTable, SwitchEventsData>,
          ),
          SwitchEventsData,
          PrefetchHooks Function()
        > {
  $$SwitchEventsTableTableManager(_$AppDatabase db, $SwitchEventsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SwitchEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SwitchEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SwitchEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> partId = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<String> markedBy = const Value.absent(),
                Value<String?> contextTags = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> remotePartName = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SwitchEventsCompanion(
                id: id,
                partId: partId,
                timestamp: timestamp,
                markedBy: markedBy,
                contextTags: contextTags,
                note: note,
                remotePartName: remotePartName,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String partId,
                Value<DateTime> timestamp = const Value.absent(),
                Value<String> markedBy = const Value.absent(),
                Value<String?> contextTags = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> remotePartName = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SwitchEventsCompanion.insert(
                id: id,
                partId: partId,
                timestamp: timestamp,
                markedBy: markedBy,
                contextTags: contextTags,
                note: note,
                remotePartName: remotePartName,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SwitchEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SwitchEventsTable,
      SwitchEventsData,
      $$SwitchEventsTableFilterComposer,
      $$SwitchEventsTableOrderingComposer,
      $$SwitchEventsTableAnnotationComposer,
      $$SwitchEventsTableCreateCompanionBuilder,
      $$SwitchEventsTableUpdateCompanionBuilder,
      (
        SwitchEventsData,
        BaseReferences<_$AppDatabase, $SwitchEventsTable, SwitchEventsData>,
      ),
      SwitchEventsData,
      PrefetchHooks Function()
    >;
typedef $$ConsentProfilesTableCreateCompanionBuilder =
    ConsentProfilesCompanion Function({
      required String partId,
      Value<String> touchGeneral,
      Value<String> touchIntimate,
      Value<String> kiss,
      Value<String> petNames,
      Value<String> sexualActivity,
      Value<String> driving,
      Value<String> alcohol,
      Value<String> decisionsFinancial,
      Value<String> decisionsMedical,
      Value<String?> notes,
      Value<DateTime> lastReviewed,
      Value<int> rowid,
    });
typedef $$ConsentProfilesTableUpdateCompanionBuilder =
    ConsentProfilesCompanion Function({
      Value<String> partId,
      Value<String> touchGeneral,
      Value<String> touchIntimate,
      Value<String> kiss,
      Value<String> petNames,
      Value<String> sexualActivity,
      Value<String> driving,
      Value<String> alcohol,
      Value<String> decisionsFinancial,
      Value<String> decisionsMedical,
      Value<String?> notes,
      Value<DateTime> lastReviewed,
      Value<int> rowid,
    });

final class $$ConsentProfilesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ConsentProfilesTable,
          ConsentProfileData
        > {
  $$ConsentProfilesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PartsTable _partIdTable(_$AppDatabase db) => db.parts.createAlias(
    $_aliasNameGenerator(db.consentProfiles.partId, db.parts.id),
  );

  $$PartsTableProcessedTableManager get partId {
    final $_column = $_itemColumn<String>('part_id')!;

    final manager = $$PartsTableTableManager(
      $_db,
      $_db.parts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_partIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ConsentProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $ConsentProfilesTable> {
  $$ConsentProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get touchGeneral => $composableBuilder(
    column: $table.touchGeneral,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get touchIntimate => $composableBuilder(
    column: $table.touchIntimate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kiss => $composableBuilder(
    column: $table.kiss,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get petNames => $composableBuilder(
    column: $table.petNames,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sexualActivity => $composableBuilder(
    column: $table.sexualActivity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get driving => $composableBuilder(
    column: $table.driving,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get alcohol => $composableBuilder(
    column: $table.alcohol,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get decisionsFinancial => $composableBuilder(
    column: $table.decisionsFinancial,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get decisionsMedical => $composableBuilder(
    column: $table.decisionsMedical,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastReviewed => $composableBuilder(
    column: $table.lastReviewed,
    builder: (column) => ColumnFilters(column),
  );

  $$PartsTableFilterComposer get partId {
    final $$PartsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.partId,
      referencedTable: $db.parts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartsTableFilterComposer(
            $db: $db,
            $table: $db.parts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ConsentProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $ConsentProfilesTable> {
  $$ConsentProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get touchGeneral => $composableBuilder(
    column: $table.touchGeneral,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get touchIntimate => $composableBuilder(
    column: $table.touchIntimate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kiss => $composableBuilder(
    column: $table.kiss,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get petNames => $composableBuilder(
    column: $table.petNames,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sexualActivity => $composableBuilder(
    column: $table.sexualActivity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get driving => $composableBuilder(
    column: $table.driving,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get alcohol => $composableBuilder(
    column: $table.alcohol,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get decisionsFinancial => $composableBuilder(
    column: $table.decisionsFinancial,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get decisionsMedical => $composableBuilder(
    column: $table.decisionsMedical,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastReviewed => $composableBuilder(
    column: $table.lastReviewed,
    builder: (column) => ColumnOrderings(column),
  );

  $$PartsTableOrderingComposer get partId {
    final $$PartsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.partId,
      referencedTable: $db.parts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartsTableOrderingComposer(
            $db: $db,
            $table: $db.parts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ConsentProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ConsentProfilesTable> {
  $$ConsentProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get touchGeneral => $composableBuilder(
    column: $table.touchGeneral,
    builder: (column) => column,
  );

  GeneratedColumn<String> get touchIntimate => $composableBuilder(
    column: $table.touchIntimate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get kiss =>
      $composableBuilder(column: $table.kiss, builder: (column) => column);

  GeneratedColumn<String> get petNames =>
      $composableBuilder(column: $table.petNames, builder: (column) => column);

  GeneratedColumn<String> get sexualActivity => $composableBuilder(
    column: $table.sexualActivity,
    builder: (column) => column,
  );

  GeneratedColumn<String> get driving =>
      $composableBuilder(column: $table.driving, builder: (column) => column);

  GeneratedColumn<String> get alcohol =>
      $composableBuilder(column: $table.alcohol, builder: (column) => column);

  GeneratedColumn<String> get decisionsFinancial => $composableBuilder(
    column: $table.decisionsFinancial,
    builder: (column) => column,
  );

  GeneratedColumn<String> get decisionsMedical => $composableBuilder(
    column: $table.decisionsMedical,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get lastReviewed => $composableBuilder(
    column: $table.lastReviewed,
    builder: (column) => column,
  );

  $$PartsTableAnnotationComposer get partId {
    final $$PartsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.partId,
      referencedTable: $db.parts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartsTableAnnotationComposer(
            $db: $db,
            $table: $db.parts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ConsentProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ConsentProfilesTable,
          ConsentProfileData,
          $$ConsentProfilesTableFilterComposer,
          $$ConsentProfilesTableOrderingComposer,
          $$ConsentProfilesTableAnnotationComposer,
          $$ConsentProfilesTableCreateCompanionBuilder,
          $$ConsentProfilesTableUpdateCompanionBuilder,
          (ConsentProfileData, $$ConsentProfilesTableReferences),
          ConsentProfileData,
          PrefetchHooks Function({bool partId})
        > {
  $$ConsentProfilesTableTableManager(
    _$AppDatabase db,
    $ConsentProfilesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConsentProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ConsentProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ConsentProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> partId = const Value.absent(),
                Value<String> touchGeneral = const Value.absent(),
                Value<String> touchIntimate = const Value.absent(),
                Value<String> kiss = const Value.absent(),
                Value<String> petNames = const Value.absent(),
                Value<String> sexualActivity = const Value.absent(),
                Value<String> driving = const Value.absent(),
                Value<String> alcohol = const Value.absent(),
                Value<String> decisionsFinancial = const Value.absent(),
                Value<String> decisionsMedical = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> lastReviewed = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ConsentProfilesCompanion(
                partId: partId,
                touchGeneral: touchGeneral,
                touchIntimate: touchIntimate,
                kiss: kiss,
                petNames: petNames,
                sexualActivity: sexualActivity,
                driving: driving,
                alcohol: alcohol,
                decisionsFinancial: decisionsFinancial,
                decisionsMedical: decisionsMedical,
                notes: notes,
                lastReviewed: lastReviewed,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String partId,
                Value<String> touchGeneral = const Value.absent(),
                Value<String> touchIntimate = const Value.absent(),
                Value<String> kiss = const Value.absent(),
                Value<String> petNames = const Value.absent(),
                Value<String> sexualActivity = const Value.absent(),
                Value<String> driving = const Value.absent(),
                Value<String> alcohol = const Value.absent(),
                Value<String> decisionsFinancial = const Value.absent(),
                Value<String> decisionsMedical = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> lastReviewed = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ConsentProfilesCompanion.insert(
                partId: partId,
                touchGeneral: touchGeneral,
                touchIntimate: touchIntimate,
                kiss: kiss,
                petNames: petNames,
                sexualActivity: sexualActivity,
                driving: driving,
                alcohol: alcohol,
                decisionsFinancial: decisionsFinancial,
                decisionsMedical: decisionsMedical,
                notes: notes,
                lastReviewed: lastReviewed,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ConsentProfilesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({partId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (partId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.partId,
                                referencedTable:
                                    $$ConsentProfilesTableReferences
                                        ._partIdTable(db),
                                referencedColumn:
                                    $$ConsentProfilesTableReferences
                                        ._partIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ConsentProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ConsentProfilesTable,
      ConsentProfileData,
      $$ConsentProfilesTableFilterComposer,
      $$ConsentProfilesTableOrderingComposer,
      $$ConsentProfilesTableAnnotationComposer,
      $$ConsentProfilesTableCreateCompanionBuilder,
      $$ConsentProfilesTableUpdateCompanionBuilder,
      (ConsentProfileData, $$ConsentProfilesTableReferences),
      ConsentProfileData,
      PrefetchHooks Function({bool partId})
    >;
typedef $$TriggerEntriesTableCreateCompanionBuilder =
    TriggerEntriesCompanion Function({
      Value<String> id,
      required String partId,
      Value<String> type,
      required String description,
      Value<String> severity,
      Value<String?> copingSuggestion,
      Value<bool> appliesExternally,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$TriggerEntriesTableUpdateCompanionBuilder =
    TriggerEntriesCompanion Function({
      Value<String> id,
      Value<String> partId,
      Value<String> type,
      Value<String> description,
      Value<String> severity,
      Value<String?> copingSuggestion,
      Value<bool> appliesExternally,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$TriggerEntriesTableReferences
    extends
        BaseReferences<_$AppDatabase, $TriggerEntriesTable, TriggerEntryData> {
  $$TriggerEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PartsTable _partIdTable(_$AppDatabase db) => db.parts.createAlias(
    $_aliasNameGenerator(db.triggerEntries.partId, db.parts.id),
  );

  $$PartsTableProcessedTableManager get partId {
    final $_column = $_itemColumn<String>('part_id')!;

    final manager = $$PartsTableTableManager(
      $_db,
      $_db.parts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_partIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TriggerEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $TriggerEntriesTable> {
  $$TriggerEntriesTableFilterComposer({
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

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get severity => $composableBuilder(
    column: $table.severity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get copingSuggestion => $composableBuilder(
    column: $table.copingSuggestion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get appliesExternally => $composableBuilder(
    column: $table.appliesExternally,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$PartsTableFilterComposer get partId {
    final $$PartsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.partId,
      referencedTable: $db.parts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartsTableFilterComposer(
            $db: $db,
            $table: $db.parts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TriggerEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $TriggerEntriesTable> {
  $$TriggerEntriesTableOrderingComposer({
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

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get severity => $composableBuilder(
    column: $table.severity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get copingSuggestion => $composableBuilder(
    column: $table.copingSuggestion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get appliesExternally => $composableBuilder(
    column: $table.appliesExternally,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$PartsTableOrderingComposer get partId {
    final $$PartsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.partId,
      referencedTable: $db.parts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartsTableOrderingComposer(
            $db: $db,
            $table: $db.parts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TriggerEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TriggerEntriesTable> {
  $$TriggerEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get severity =>
      $composableBuilder(column: $table.severity, builder: (column) => column);

  GeneratedColumn<String> get copingSuggestion => $composableBuilder(
    column: $table.copingSuggestion,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get appliesExternally => $composableBuilder(
    column: $table.appliesExternally,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$PartsTableAnnotationComposer get partId {
    final $$PartsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.partId,
      referencedTable: $db.parts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartsTableAnnotationComposer(
            $db: $db,
            $table: $db.parts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TriggerEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TriggerEntriesTable,
          TriggerEntryData,
          $$TriggerEntriesTableFilterComposer,
          $$TriggerEntriesTableOrderingComposer,
          $$TriggerEntriesTableAnnotationComposer,
          $$TriggerEntriesTableCreateCompanionBuilder,
          $$TriggerEntriesTableUpdateCompanionBuilder,
          (TriggerEntryData, $$TriggerEntriesTableReferences),
          TriggerEntryData,
          PrefetchHooks Function({bool partId})
        > {
  $$TriggerEntriesTableTableManager(
    _$AppDatabase db,
    $TriggerEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TriggerEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TriggerEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TriggerEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> partId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> severity = const Value.absent(),
                Value<String?> copingSuggestion = const Value.absent(),
                Value<bool> appliesExternally = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TriggerEntriesCompanion(
                id: id,
                partId: partId,
                type: type,
                description: description,
                severity: severity,
                copingSuggestion: copingSuggestion,
                appliesExternally: appliesExternally,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String partId,
                Value<String> type = const Value.absent(),
                required String description,
                Value<String> severity = const Value.absent(),
                Value<String?> copingSuggestion = const Value.absent(),
                Value<bool> appliesExternally = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TriggerEntriesCompanion.insert(
                id: id,
                partId: partId,
                type: type,
                description: description,
                severity: severity,
                copingSuggestion: copingSuggestion,
                appliesExternally: appliesExternally,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TriggerEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({partId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (partId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.partId,
                                referencedTable: $$TriggerEntriesTableReferences
                                    ._partIdTable(db),
                                referencedColumn:
                                    $$TriggerEntriesTableReferences
                                        ._partIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TriggerEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TriggerEntriesTable,
      TriggerEntryData,
      $$TriggerEntriesTableFilterComposer,
      $$TriggerEntriesTableOrderingComposer,
      $$TriggerEntriesTableAnnotationComposer,
      $$TriggerEntriesTableCreateCompanionBuilder,
      $$TriggerEntriesTableUpdateCompanionBuilder,
      (TriggerEntryData, $$TriggerEntriesTableReferences),
      TriggerEntryData,
      PrefetchHooks Function({bool partId})
    >;
typedef $$EmergencyContactsTableCreateCompanionBuilder =
    EmergencyContactsCompanion Function({
      Value<String> id,
      Value<int> rank,
      required String name,
      required String relationship,
      required String phone,
      Value<String?> email,
      Value<bool> knowsAboutDiagnosis,
      Value<bool> knowsAboutParts,
      Value<bool> knowsAboutTrauma,
      Value<String> preferredContactMethod,
      Value<String?> availableHours,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$EmergencyContactsTableUpdateCompanionBuilder =
    EmergencyContactsCompanion Function({
      Value<String> id,
      Value<int> rank,
      Value<String> name,
      Value<String> relationship,
      Value<String> phone,
      Value<String?> email,
      Value<bool> knowsAboutDiagnosis,
      Value<bool> knowsAboutParts,
      Value<bool> knowsAboutTrauma,
      Value<String> preferredContactMethod,
      Value<String?> availableHours,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$EmergencyContactsTableFilterComposer
    extends Composer<_$AppDatabase, $EmergencyContactsTable> {
  $$EmergencyContactsTableFilterComposer({
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

  ColumnFilters<int> get rank => $composableBuilder(
    column: $table.rank,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get relationship => $composableBuilder(
    column: $table.relationship,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get knowsAboutDiagnosis => $composableBuilder(
    column: $table.knowsAboutDiagnosis,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get knowsAboutParts => $composableBuilder(
    column: $table.knowsAboutParts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get knowsAboutTrauma => $composableBuilder(
    column: $table.knowsAboutTrauma,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get preferredContactMethod => $composableBuilder(
    column: $table.preferredContactMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get availableHours => $composableBuilder(
    column: $table.availableHours,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EmergencyContactsTableOrderingComposer
    extends Composer<_$AppDatabase, $EmergencyContactsTable> {
  $$EmergencyContactsTableOrderingComposer({
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

  ColumnOrderings<int> get rank => $composableBuilder(
    column: $table.rank,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get relationship => $composableBuilder(
    column: $table.relationship,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get knowsAboutDiagnosis => $composableBuilder(
    column: $table.knowsAboutDiagnosis,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get knowsAboutParts => $composableBuilder(
    column: $table.knowsAboutParts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get knowsAboutTrauma => $composableBuilder(
    column: $table.knowsAboutTrauma,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get preferredContactMethod => $composableBuilder(
    column: $table.preferredContactMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get availableHours => $composableBuilder(
    column: $table.availableHours,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EmergencyContactsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EmergencyContactsTable> {
  $$EmergencyContactsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get rank =>
      $composableBuilder(column: $table.rank, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get relationship => $composableBuilder(
    column: $table.relationship,
    builder: (column) => column,
  );

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<bool> get knowsAboutDiagnosis => $composableBuilder(
    column: $table.knowsAboutDiagnosis,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get knowsAboutParts => $composableBuilder(
    column: $table.knowsAboutParts,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get knowsAboutTrauma => $composableBuilder(
    column: $table.knowsAboutTrauma,
    builder: (column) => column,
  );

  GeneratedColumn<String> get preferredContactMethod => $composableBuilder(
    column: $table.preferredContactMethod,
    builder: (column) => column,
  );

  GeneratedColumn<String> get availableHours => $composableBuilder(
    column: $table.availableHours,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$EmergencyContactsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EmergencyContactsTable,
          EmergencyContactData,
          $$EmergencyContactsTableFilterComposer,
          $$EmergencyContactsTableOrderingComposer,
          $$EmergencyContactsTableAnnotationComposer,
          $$EmergencyContactsTableCreateCompanionBuilder,
          $$EmergencyContactsTableUpdateCompanionBuilder,
          (
            EmergencyContactData,
            BaseReferences<
              _$AppDatabase,
              $EmergencyContactsTable,
              EmergencyContactData
            >,
          ),
          EmergencyContactData,
          PrefetchHooks Function()
        > {
  $$EmergencyContactsTableTableManager(
    _$AppDatabase db,
    $EmergencyContactsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmergencyContactsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EmergencyContactsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EmergencyContactsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> rank = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> relationship = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<bool> knowsAboutDiagnosis = const Value.absent(),
                Value<bool> knowsAboutParts = const Value.absent(),
                Value<bool> knowsAboutTrauma = const Value.absent(),
                Value<String> preferredContactMethod = const Value.absent(),
                Value<String?> availableHours = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EmergencyContactsCompanion(
                id: id,
                rank: rank,
                name: name,
                relationship: relationship,
                phone: phone,
                email: email,
                knowsAboutDiagnosis: knowsAboutDiagnosis,
                knowsAboutParts: knowsAboutParts,
                knowsAboutTrauma: knowsAboutTrauma,
                preferredContactMethod: preferredContactMethod,
                availableHours: availableHours,
                notes: notes,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> rank = const Value.absent(),
                required String name,
                required String relationship,
                required String phone,
                Value<String?> email = const Value.absent(),
                Value<bool> knowsAboutDiagnosis = const Value.absent(),
                Value<bool> knowsAboutParts = const Value.absent(),
                Value<bool> knowsAboutTrauma = const Value.absent(),
                Value<String> preferredContactMethod = const Value.absent(),
                Value<String?> availableHours = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EmergencyContactsCompanion.insert(
                id: id,
                rank: rank,
                name: name,
                relationship: relationship,
                phone: phone,
                email: email,
                knowsAboutDiagnosis: knowsAboutDiagnosis,
                knowsAboutParts: knowsAboutParts,
                knowsAboutTrauma: knowsAboutTrauma,
                preferredContactMethod: preferredContactMethod,
                availableHours: availableHours,
                notes: notes,
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

typedef $$EmergencyContactsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EmergencyContactsTable,
      EmergencyContactData,
      $$EmergencyContactsTableFilterComposer,
      $$EmergencyContactsTableOrderingComposer,
      $$EmergencyContactsTableAnnotationComposer,
      $$EmergencyContactsTableCreateCompanionBuilder,
      $$EmergencyContactsTableUpdateCompanionBuilder,
      (
        EmergencyContactData,
        BaseReferences<
          _$AppDatabase,
          $EmergencyContactsTable,
          EmergencyContactData
        >,
      ),
      EmergencyContactData,
      PrefetchHooks Function()
    >;
typedef $$MedicalRecordsTableCreateCompanionBuilder =
    MedicalRecordsCompanion Function({
      Value<String> id,
      Value<String?> bloodType,
      Value<String?> allergies,
      Value<String?> medications,
      Value<String?> diagnoses,
      Value<String?> primaryPhysician,
      Value<String?> healthInsuranceProvider,
      Value<String?> healthInsuranceMemberId,
      Value<String?> notes,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$MedicalRecordsTableUpdateCompanionBuilder =
    MedicalRecordsCompanion Function({
      Value<String> id,
      Value<String?> bloodType,
      Value<String?> allergies,
      Value<String?> medications,
      Value<String?> diagnoses,
      Value<String?> primaryPhysician,
      Value<String?> healthInsuranceProvider,
      Value<String?> healthInsuranceMemberId,
      Value<String?> notes,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$MedicalRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $MedicalRecordsTable> {
  $$MedicalRecordsTableFilterComposer({
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

  ColumnFilters<String> get bloodType => $composableBuilder(
    column: $table.bloodType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get allergies => $composableBuilder(
    column: $table.allergies,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get medications => $composableBuilder(
    column: $table.medications,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get diagnoses => $composableBuilder(
    column: $table.diagnoses,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get primaryPhysician => $composableBuilder(
    column: $table.primaryPhysician,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get healthInsuranceProvider => $composableBuilder(
    column: $table.healthInsuranceProvider,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get healthInsuranceMemberId => $composableBuilder(
    column: $table.healthInsuranceMemberId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MedicalRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $MedicalRecordsTable> {
  $$MedicalRecordsTableOrderingComposer({
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

  ColumnOrderings<String> get bloodType => $composableBuilder(
    column: $table.bloodType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get allergies => $composableBuilder(
    column: $table.allergies,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get medications => $composableBuilder(
    column: $table.medications,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get diagnoses => $composableBuilder(
    column: $table.diagnoses,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get primaryPhysician => $composableBuilder(
    column: $table.primaryPhysician,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get healthInsuranceProvider => $composableBuilder(
    column: $table.healthInsuranceProvider,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get healthInsuranceMemberId => $composableBuilder(
    column: $table.healthInsuranceMemberId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MedicalRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedicalRecordsTable> {
  $$MedicalRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get bloodType =>
      $composableBuilder(column: $table.bloodType, builder: (column) => column);

  GeneratedColumn<String> get allergies =>
      $composableBuilder(column: $table.allergies, builder: (column) => column);

  GeneratedColumn<String> get medications => $composableBuilder(
    column: $table.medications,
    builder: (column) => column,
  );

  GeneratedColumn<String> get diagnoses =>
      $composableBuilder(column: $table.diagnoses, builder: (column) => column);

  GeneratedColumn<String> get primaryPhysician => $composableBuilder(
    column: $table.primaryPhysician,
    builder: (column) => column,
  );

  GeneratedColumn<String> get healthInsuranceProvider => $composableBuilder(
    column: $table.healthInsuranceProvider,
    builder: (column) => column,
  );

  GeneratedColumn<String> get healthInsuranceMemberId => $composableBuilder(
    column: $table.healthInsuranceMemberId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$MedicalRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MedicalRecordsTable,
          MedicalRecordData,
          $$MedicalRecordsTableFilterComposer,
          $$MedicalRecordsTableOrderingComposer,
          $$MedicalRecordsTableAnnotationComposer,
          $$MedicalRecordsTableCreateCompanionBuilder,
          $$MedicalRecordsTableUpdateCompanionBuilder,
          (
            MedicalRecordData,
            BaseReferences<
              _$AppDatabase,
              $MedicalRecordsTable,
              MedicalRecordData
            >,
          ),
          MedicalRecordData,
          PrefetchHooks Function()
        > {
  $$MedicalRecordsTableTableManager(
    _$AppDatabase db,
    $MedicalRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicalRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MedicalRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MedicalRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> bloodType = const Value.absent(),
                Value<String?> allergies = const Value.absent(),
                Value<String?> medications = const Value.absent(),
                Value<String?> diagnoses = const Value.absent(),
                Value<String?> primaryPhysician = const Value.absent(),
                Value<String?> healthInsuranceProvider = const Value.absent(),
                Value<String?> healthInsuranceMemberId = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MedicalRecordsCompanion(
                id: id,
                bloodType: bloodType,
                allergies: allergies,
                medications: medications,
                diagnoses: diagnoses,
                primaryPhysician: primaryPhysician,
                healthInsuranceProvider: healthInsuranceProvider,
                healthInsuranceMemberId: healthInsuranceMemberId,
                notes: notes,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> bloodType = const Value.absent(),
                Value<String?> allergies = const Value.absent(),
                Value<String?> medications = const Value.absent(),
                Value<String?> diagnoses = const Value.absent(),
                Value<String?> primaryPhysician = const Value.absent(),
                Value<String?> healthInsuranceProvider = const Value.absent(),
                Value<String?> healthInsuranceMemberId = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MedicalRecordsCompanion.insert(
                id: id,
                bloodType: bloodType,
                allergies: allergies,
                medications: medications,
                diagnoses: diagnoses,
                primaryPhysician: primaryPhysician,
                healthInsuranceProvider: healthInsuranceProvider,
                healthInsuranceMemberId: healthInsuranceMemberId,
                notes: notes,
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

typedef $$MedicalRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MedicalRecordsTable,
      MedicalRecordData,
      $$MedicalRecordsTableFilterComposer,
      $$MedicalRecordsTableOrderingComposer,
      $$MedicalRecordsTableAnnotationComposer,
      $$MedicalRecordsTableCreateCompanionBuilder,
      $$MedicalRecordsTableUpdateCompanionBuilder,
      (
        MedicalRecordData,
        BaseReferences<_$AppDatabase, $MedicalRecordsTable, MedicalRecordData>,
      ),
      MedicalRecordData,
      PrefetchHooks Function()
    >;
typedef $$JournalEntriesTableCreateCompanionBuilder =
    JournalEntriesCompanion Function({
      Value<String> id,
      Value<String?> partId,
      required String content,
      Value<String?> mood,
      Value<bool> isPrivate,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$JournalEntriesTableUpdateCompanionBuilder =
    JournalEntriesCompanion Function({
      Value<String> id,
      Value<String?> partId,
      Value<String> content,
      Value<String?> mood,
      Value<bool> isPrivate,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$JournalEntriesTableReferences
    extends
        BaseReferences<_$AppDatabase, $JournalEntriesTable, JournalEntryData> {
  $$JournalEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PartsTable _partIdTable(_$AppDatabase db) => db.parts.createAlias(
    $_aliasNameGenerator(db.journalEntries.partId, db.parts.id),
  );

  $$PartsTableProcessedTableManager? get partId {
    final $_column = $_itemColumn<String>('part_id');
    if ($_column == null) return null;
    final manager = $$PartsTableTableManager(
      $_db,
      $_db.parts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_partIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$JournalEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $JournalEntriesTable> {
  $$JournalEntriesTableFilterComposer({
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

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mood => $composableBuilder(
    column: $table.mood,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPrivate => $composableBuilder(
    column: $table.isPrivate,
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

  $$PartsTableFilterComposer get partId {
    final $$PartsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.partId,
      referencedTable: $db.parts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartsTableFilterComposer(
            $db: $db,
            $table: $db.parts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$JournalEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $JournalEntriesTable> {
  $$JournalEntriesTableOrderingComposer({
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

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mood => $composableBuilder(
    column: $table.mood,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPrivate => $composableBuilder(
    column: $table.isPrivate,
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

  $$PartsTableOrderingComposer get partId {
    final $$PartsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.partId,
      referencedTable: $db.parts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartsTableOrderingComposer(
            $db: $db,
            $table: $db.parts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$JournalEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $JournalEntriesTable> {
  $$JournalEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get mood =>
      $composableBuilder(column: $table.mood, builder: (column) => column);

  GeneratedColumn<bool> get isPrivate =>
      $composableBuilder(column: $table.isPrivate, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$PartsTableAnnotationComposer get partId {
    final $$PartsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.partId,
      referencedTable: $db.parts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartsTableAnnotationComposer(
            $db: $db,
            $table: $db.parts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$JournalEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $JournalEntriesTable,
          JournalEntryData,
          $$JournalEntriesTableFilterComposer,
          $$JournalEntriesTableOrderingComposer,
          $$JournalEntriesTableAnnotationComposer,
          $$JournalEntriesTableCreateCompanionBuilder,
          $$JournalEntriesTableUpdateCompanionBuilder,
          (JournalEntryData, $$JournalEntriesTableReferences),
          JournalEntryData,
          PrefetchHooks Function({bool partId})
        > {
  $$JournalEntriesTableTableManager(
    _$AppDatabase db,
    $JournalEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$JournalEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$JournalEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$JournalEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> partId = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<String?> mood = const Value.absent(),
                Value<bool> isPrivate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => JournalEntriesCompanion(
                id: id,
                partId: partId,
                content: content,
                mood: mood,
                isPrivate: isPrivate,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> partId = const Value.absent(),
                required String content,
                Value<String?> mood = const Value.absent(),
                Value<bool> isPrivate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => JournalEntriesCompanion.insert(
                id: id,
                partId: partId,
                content: content,
                mood: mood,
                isPrivate: isPrivate,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$JournalEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({partId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (partId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.partId,
                                referencedTable: $$JournalEntriesTableReferences
                                    ._partIdTable(db),
                                referencedColumn:
                                    $$JournalEntriesTableReferences
                                        ._partIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$JournalEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $JournalEntriesTable,
      JournalEntryData,
      $$JournalEntriesTableFilterComposer,
      $$JournalEntriesTableOrderingComposer,
      $$JournalEntriesTableAnnotationComposer,
      $$JournalEntriesTableCreateCompanionBuilder,
      $$JournalEntriesTableUpdateCompanionBuilder,
      (JournalEntryData, $$JournalEntriesTableReferences),
      JournalEntryData,
      PrefetchHooks Function({bool partId})
    >;
typedef $$ConnectionsTableCreateCompanionBuilder =
    ConnectionsCompanion Function({
      Value<String> id,
      required String remoteDeviceId,
      required String remoteDisplayName,
      Value<String> role,
      Value<bool> isActive,
      Value<DateTime> pairedAt,
      Value<String?> remoteData,
      Value<int> rowid,
    });
typedef $$ConnectionsTableUpdateCompanionBuilder =
    ConnectionsCompanion Function({
      Value<String> id,
      Value<String> remoteDeviceId,
      Value<String> remoteDisplayName,
      Value<String> role,
      Value<bool> isActive,
      Value<DateTime> pairedAt,
      Value<String?> remoteData,
      Value<int> rowid,
    });

class $$ConnectionsTableFilterComposer
    extends Composer<_$AppDatabase, $ConnectionsTable> {
  $$ConnectionsTableFilterComposer({
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

  ColumnFilters<String> get remoteDeviceId => $composableBuilder(
    column: $table.remoteDeviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remoteDisplayName => $composableBuilder(
    column: $table.remoteDisplayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get pairedAt => $composableBuilder(
    column: $table.pairedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remoteData => $composableBuilder(
    column: $table.remoteData,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ConnectionsTableOrderingComposer
    extends Composer<_$AppDatabase, $ConnectionsTable> {
  $$ConnectionsTableOrderingComposer({
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

  ColumnOrderings<String> get remoteDeviceId => $composableBuilder(
    column: $table.remoteDeviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remoteDisplayName => $composableBuilder(
    column: $table.remoteDisplayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get pairedAt => $composableBuilder(
    column: $table.pairedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remoteData => $composableBuilder(
    column: $table.remoteData,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ConnectionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ConnectionsTable> {
  $$ConnectionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get remoteDeviceId => $composableBuilder(
    column: $table.remoteDeviceId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get remoteDisplayName => $composableBuilder(
    column: $table.remoteDisplayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get pairedAt =>
      $composableBuilder(column: $table.pairedAt, builder: (column) => column);

  GeneratedColumn<String> get remoteData => $composableBuilder(
    column: $table.remoteData,
    builder: (column) => column,
  );
}

class $$ConnectionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ConnectionsTable,
          ConnectionData,
          $$ConnectionsTableFilterComposer,
          $$ConnectionsTableOrderingComposer,
          $$ConnectionsTableAnnotationComposer,
          $$ConnectionsTableCreateCompanionBuilder,
          $$ConnectionsTableUpdateCompanionBuilder,
          (
            ConnectionData,
            BaseReferences<_$AppDatabase, $ConnectionsTable, ConnectionData>,
          ),
          ConnectionData,
          PrefetchHooks Function()
        > {
  $$ConnectionsTableTableManager(_$AppDatabase db, $ConnectionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConnectionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ConnectionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ConnectionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> remoteDeviceId = const Value.absent(),
                Value<String> remoteDisplayName = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> pairedAt = const Value.absent(),
                Value<String?> remoteData = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ConnectionsCompanion(
                id: id,
                remoteDeviceId: remoteDeviceId,
                remoteDisplayName: remoteDisplayName,
                role: role,
                isActive: isActive,
                pairedAt: pairedAt,
                remoteData: remoteData,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String remoteDeviceId,
                required String remoteDisplayName,
                Value<String> role = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> pairedAt = const Value.absent(),
                Value<String?> remoteData = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ConnectionsCompanion.insert(
                id: id,
                remoteDeviceId: remoteDeviceId,
                remoteDisplayName: remoteDisplayName,
                role: role,
                isActive: isActive,
                pairedAt: pairedAt,
                remoteData: remoteData,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ConnectionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ConnectionsTable,
      ConnectionData,
      $$ConnectionsTableFilterComposer,
      $$ConnectionsTableOrderingComposer,
      $$ConnectionsTableAnnotationComposer,
      $$ConnectionsTableCreateCompanionBuilder,
      $$ConnectionsTableUpdateCompanionBuilder,
      (
        ConnectionData,
        BaseReferences<_$AppDatabase, $ConnectionsTable, ConnectionData>,
      ),
      ConnectionData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SystemsTableTableManager get systems =>
      $$SystemsTableTableManager(_db, _db.systems);
  $$PartsTableTableManager get parts =>
      $$PartsTableTableManager(_db, _db.parts);
  $$SwitchEventsTableTableManager get switchEvents =>
      $$SwitchEventsTableTableManager(_db, _db.switchEvents);
  $$ConsentProfilesTableTableManager get consentProfiles =>
      $$ConsentProfilesTableTableManager(_db, _db.consentProfiles);
  $$TriggerEntriesTableTableManager get triggerEntries =>
      $$TriggerEntriesTableTableManager(_db, _db.triggerEntries);
  $$EmergencyContactsTableTableManager get emergencyContacts =>
      $$EmergencyContactsTableTableManager(_db, _db.emergencyContacts);
  $$MedicalRecordsTableTableManager get medicalRecords =>
      $$MedicalRecordsTableTableManager(_db, _db.medicalRecords);
  $$JournalEntriesTableTableManager get journalEntries =>
      $$JournalEntriesTableTableManager(_db, _db.journalEntries);
  $$ConnectionsTableTableManager get connections =>
      $$ConnectionsTableTableManager(_db, _db.connections);
}
