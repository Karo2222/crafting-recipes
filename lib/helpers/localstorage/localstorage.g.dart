// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'localstorage.dart';

// ignore_for_file: type=lint
class Categories extends Table with TableInfo<Categories, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Categories(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _createdByMeta =
      const VerificationMeta('createdBy');
  late final GeneratedColumn<int> createdBy = GeneratedColumn<int>(
      'created_by', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _updatedByMeta =
      const VerificationMeta('updatedBy');
  late final GeneratedColumn<int> updatedBy = GeneratedColumn<int>(
      'updated_by', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  static const VerificationMeta _deletedByMeta =
      const VerificationMeta('deletedBy');
  late final GeneratedColumn<int> deletedBy = GeneratedColumn<int>(
      'deleted_by', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        createdAt,
        createdBy,
        updatedAt,
        updatedBy,
        deletedAt,
        deletedBy
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(Insertable<Category> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('updated_by')) {
      context.handle(_updatedByMeta,
          updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta));
    } else if (isInserting) {
      context.missing(_updatedByMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('deleted_by')) {
      context.handle(_deletedByMeta,
          deletedBy.isAcceptableOrUnknown(data['deleted_by']!, _deletedByMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      createdBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_by'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      updatedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_by'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
      deletedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}deleted_by']),
    );
  }

  @override
  Categories createAlias(String alias) {
    return Categories(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints =>
      const ['CONSTRAINT category_pkey PRIMARY KEY(id)'];
  @override
  bool get dontWriteConstraints => true;
}

class Category extends DataClass implements Insertable<Category> {
  final int id;
  final String name;
  final DateTime createdAt;
  final int createdBy;
  final DateTime updatedAt;
  final int updatedBy;
  final DateTime? deletedAt;
  final int? deletedBy;
  const Category(
      {required this.id,
      required this.name,
      required this.createdAt,
      required this.createdBy,
      required this.updatedAt,
      required this.updatedBy,
      this.deletedAt,
      this.deletedBy});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['created_by'] = Variable<int>(createdBy);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['updated_by'] = Variable<int>(updatedBy);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || deletedBy != null) {
      map['deleted_by'] = Variable<int>(deletedBy);
    }
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      name: Value(name),
      createdAt: Value(createdAt),
      createdBy: Value(createdBy),
      updatedAt: Value(updatedAt),
      updatedBy: Value(updatedBy),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deletedBy: deletedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedBy),
    );
  }

  factory Category.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      createdBy: serializer.fromJson<int>(json['created_by']),
      updatedAt: serializer.fromJson<DateTime>(json['updated_at']),
      updatedBy: serializer.fromJson<int>(json['updated_by']),
      deletedAt: serializer.fromJson<DateTime?>(json['deleted_at']),
      deletedBy: serializer.fromJson<int?>(json['deleted_by']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'created_by': serializer.toJson<int>(createdBy),
      'updated_at': serializer.toJson<DateTime>(updatedAt),
      'updated_by': serializer.toJson<int>(updatedBy),
      'deleted_at': serializer.toJson<DateTime?>(deletedAt),
      'deleted_by': serializer.toJson<int?>(deletedBy),
    };
  }

  Category copyWith(
          {int? id,
          String? name,
          DateTime? createdAt,
          int? createdBy,
          DateTime? updatedAt,
          int? updatedBy,
          Value<DateTime?> deletedAt = const Value.absent(),
          Value<int?> deletedBy = const Value.absent()}) =>
      Category(
        id: id ?? this.id,
        name: name ?? this.name,
        createdAt: createdAt ?? this.createdAt,
        createdBy: createdBy ?? this.createdBy,
        updatedAt: updatedAt ?? this.updatedAt,
        updatedBy: updatedBy ?? this.updatedBy,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        deletedBy: deletedBy.present ? deletedBy.value : this.deletedBy,
      );
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deletedBy: data.deletedBy.present ? data.deletedBy.value : this.deletedBy,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deletedBy: $deletedBy')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, createdAt, createdBy, updatedAt,
      updatedBy, deletedAt, deletedBy);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.name == this.name &&
          other.createdAt == this.createdAt &&
          other.createdBy == this.createdBy &&
          other.updatedAt == this.updatedAt &&
          other.updatedBy == this.updatedBy &&
          other.deletedAt == this.deletedAt &&
          other.deletedBy == this.deletedBy);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<int> id;
  final Value<String> name;
  final Value<DateTime> createdAt;
  final Value<int> createdBy;
  final Value<DateTime> updatedAt;
  final Value<int> updatedBy;
  final Value<DateTime?> deletedAt;
  final Value<int?> deletedBy;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deletedBy = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required DateTime createdAt,
    required int createdBy,
    required DateTime updatedAt,
    required int updatedBy,
    this.deletedAt = const Value.absent(),
    this.deletedBy = const Value.absent(),
  })  : name = Value(name),
        createdAt = Value(createdAt),
        createdBy = Value(createdBy),
        updatedAt = Value(updatedAt),
        updatedBy = Value(updatedBy);
  static Insertable<Category> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<DateTime>? createdAt,
    Expression<int>? createdBy,
    Expression<DateTime>? updatedAt,
    Expression<int>? updatedBy,
    Expression<DateTime>? deletedAt,
    Expression<int>? deletedBy,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
      if (createdBy != null) 'created_by': createdBy,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deletedBy != null) 'deleted_by': deletedBy,
    });
  }

  CategoriesCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<DateTime>? createdAt,
      Value<int>? createdBy,
      Value<DateTime>? updatedAt,
      Value<int>? updatedBy,
      Value<DateTime?>? deletedAt,
      Value<int?>? deletedBy}) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      deletedAt: deletedAt ?? this.deletedAt,
      deletedBy: deletedBy ?? this.deletedBy,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<int>(createdBy.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<int>(updatedBy.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (deletedBy.present) {
      map['deleted_by'] = Variable<int>(deletedBy.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deletedBy: $deletedBy')
          ..write(')'))
        .toString();
  }
}

class Recipes extends Table with TableInfo<Recipes, Recipe> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Recipes(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: '');
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _imageMeta = const VerificationMeta('image');
  late final GeneratedColumn<String> image = GeneratedColumn<String>(
      'image', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  static const VerificationMeta _totalTimeMinutesMeta =
      const VerificationMeta('totalTimeMinutes');
  late final GeneratedColumn<int> totalTimeMinutes = GeneratedColumn<int>(
      'total_time_minutes', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  static const VerificationMeta _servingsMeta =
      const VerificationMeta('servings');
  late final GeneratedColumn<int> servings = GeneratedColumn<int>(
      'servings', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  static const VerificationMeta _revisionMeta =
      const VerificationMeta('revision');
  late final GeneratedColumn<int> revision = GeneratedColumn<int>(
      'revision', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL DEFAULT 1',
      defaultValue: const CustomExpression('1'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _createdByMeta =
      const VerificationMeta('createdBy');
  late final GeneratedColumn<int> createdBy = GeneratedColumn<int>(
      'created_by', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _updatedByMeta =
      const VerificationMeta('updatedBy');
  late final GeneratedColumn<int> updatedBy = GeneratedColumn<int>(
      'updated_by', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  static const VerificationMeta _deletedByMeta =
      const VerificationMeta('deletedBy');
  late final GeneratedColumn<int> deletedBy = GeneratedColumn<int>(
      'deleted_by', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        image,
        description,
        notes,
        totalTimeMinutes,
        servings,
        revision,
        createdAt,
        createdBy,
        updatedAt,
        updatedBy,
        deletedAt,
        deletedBy
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipes';
  @override
  VerificationContext validateIntegrity(Insertable<Recipe> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('image')) {
      context.handle(
          _imageMeta, image.isAcceptableOrUnknown(data['image']!, _imageMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('total_time_minutes')) {
      context.handle(
          _totalTimeMinutesMeta,
          totalTimeMinutes.isAcceptableOrUnknown(
              data['total_time_minutes']!, _totalTimeMinutesMeta));
    }
    if (data.containsKey('servings')) {
      context.handle(_servingsMeta,
          servings.isAcceptableOrUnknown(data['servings']!, _servingsMeta));
    }
    if (data.containsKey('revision')) {
      context.handle(_revisionMeta,
          revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('updated_by')) {
      context.handle(_updatedByMeta,
          updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta));
    } else if (isInserting) {
      context.missing(_updatedByMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('deleted_by')) {
      context.handle(_deletedByMeta,
          deletedBy.isAcceptableOrUnknown(data['deleted_by']!, _deletedByMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Recipe map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Recipe(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      image: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image']),
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      totalTimeMinutes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_time_minutes']),
      servings: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}servings']),
      revision: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}revision'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      createdBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_by'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      updatedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_by'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
      deletedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}deleted_by']),
    );
  }

  @override
  Recipes createAlias(String alias) {
    return Recipes(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints =>
      const ['CONSTRAINT recipe_pkey PRIMARY KEY(id)'];
  @override
  bool get dontWriteConstraints => true;
}

class Recipe extends DataClass implements Insertable<Recipe> {
  final int id;
  final String title;
  final String? image;
  final String? description;
  final String? notes;
  final int? totalTimeMinutes;
  final int? servings;
  final int revision;
  final DateTime createdAt;
  final int createdBy;
  final DateTime updatedAt;
  final int updatedBy;
  final DateTime? deletedAt;
  final int? deletedBy;
  const Recipe(
      {required this.id,
      required this.title,
      this.image,
      this.description,
      this.notes,
      this.totalTimeMinutes,
      this.servings,
      required this.revision,
      required this.createdAt,
      required this.createdBy,
      required this.updatedAt,
      required this.updatedBy,
      this.deletedAt,
      this.deletedBy});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || image != null) {
      map['image'] = Variable<String>(image);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || totalTimeMinutes != null) {
      map['total_time_minutes'] = Variable<int>(totalTimeMinutes);
    }
    if (!nullToAbsent || servings != null) {
      map['servings'] = Variable<int>(servings);
    }
    map['revision'] = Variable<int>(revision);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['created_by'] = Variable<int>(createdBy);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['updated_by'] = Variable<int>(updatedBy);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || deletedBy != null) {
      map['deleted_by'] = Variable<int>(deletedBy);
    }
    return map;
  }

  RecipesCompanion toCompanion(bool nullToAbsent) {
    return RecipesCompanion(
      id: Value(id),
      title: Value(title),
      image:
          image == null && nullToAbsent ? const Value.absent() : Value(image),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      totalTimeMinutes: totalTimeMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(totalTimeMinutes),
      servings: servings == null && nullToAbsent
          ? const Value.absent()
          : Value(servings),
      revision: Value(revision),
      createdAt: Value(createdAt),
      createdBy: Value(createdBy),
      updatedAt: Value(updatedAt),
      updatedBy: Value(updatedBy),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deletedBy: deletedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedBy),
    );
  }

  factory Recipe.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Recipe(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      image: serializer.fromJson<String?>(json['image']),
      description: serializer.fromJson<String?>(json['description']),
      notes: serializer.fromJson<String?>(json['notes']),
      totalTimeMinutes: serializer.fromJson<int?>(json['total_time_minutes']),
      servings: serializer.fromJson<int?>(json['servings']),
      revision: serializer.fromJson<int>(json['revision']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      createdBy: serializer.fromJson<int>(json['created_by']),
      updatedAt: serializer.fromJson<DateTime>(json['updated_at']),
      updatedBy: serializer.fromJson<int>(json['updated_by']),
      deletedAt: serializer.fromJson<DateTime?>(json['deleted_at']),
      deletedBy: serializer.fromJson<int?>(json['deleted_by']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'image': serializer.toJson<String?>(image),
      'description': serializer.toJson<String?>(description),
      'notes': serializer.toJson<String?>(notes),
      'total_time_minutes': serializer.toJson<int?>(totalTimeMinutes),
      'servings': serializer.toJson<int?>(servings),
      'revision': serializer.toJson<int>(revision),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'created_by': serializer.toJson<int>(createdBy),
      'updated_at': serializer.toJson<DateTime>(updatedAt),
      'updated_by': serializer.toJson<int>(updatedBy),
      'deleted_at': serializer.toJson<DateTime?>(deletedAt),
      'deleted_by': serializer.toJson<int?>(deletedBy),
    };
  }

  Recipe copyWith(
          {int? id,
          String? title,
          Value<String?> image = const Value.absent(),
          Value<String?> description = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          Value<int?> totalTimeMinutes = const Value.absent(),
          Value<int?> servings = const Value.absent(),
          int? revision,
          DateTime? createdAt,
          int? createdBy,
          DateTime? updatedAt,
          int? updatedBy,
          Value<DateTime?> deletedAt = const Value.absent(),
          Value<int?> deletedBy = const Value.absent()}) =>
      Recipe(
        id: id ?? this.id,
        title: title ?? this.title,
        image: image.present ? image.value : this.image,
        description: description.present ? description.value : this.description,
        notes: notes.present ? notes.value : this.notes,
        totalTimeMinutes: totalTimeMinutes.present
            ? totalTimeMinutes.value
            : this.totalTimeMinutes,
        servings: servings.present ? servings.value : this.servings,
        revision: revision ?? this.revision,
        createdAt: createdAt ?? this.createdAt,
        createdBy: createdBy ?? this.createdBy,
        updatedAt: updatedAt ?? this.updatedAt,
        updatedBy: updatedBy ?? this.updatedBy,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        deletedBy: deletedBy.present ? deletedBy.value : this.deletedBy,
      );
  Recipe copyWithCompanion(RecipesCompanion data) {
    return Recipe(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      image: data.image.present ? data.image.value : this.image,
      description:
          data.description.present ? data.description.value : this.description,
      notes: data.notes.present ? data.notes.value : this.notes,
      totalTimeMinutes: data.totalTimeMinutes.present
          ? data.totalTimeMinutes.value
          : this.totalTimeMinutes,
      servings: data.servings.present ? data.servings.value : this.servings,
      revision: data.revision.present ? data.revision.value : this.revision,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deletedBy: data.deletedBy.present ? data.deletedBy.value : this.deletedBy,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Recipe(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('image: $image, ')
          ..write('description: $description, ')
          ..write('notes: $notes, ')
          ..write('totalTimeMinutes: $totalTimeMinutes, ')
          ..write('servings: $servings, ')
          ..write('revision: $revision, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deletedBy: $deletedBy')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      title,
      image,
      description,
      notes,
      totalTimeMinutes,
      servings,
      revision,
      createdAt,
      createdBy,
      updatedAt,
      updatedBy,
      deletedAt,
      deletedBy);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Recipe &&
          other.id == this.id &&
          other.title == this.title &&
          other.image == this.image &&
          other.description == this.description &&
          other.notes == this.notes &&
          other.totalTimeMinutes == this.totalTimeMinutes &&
          other.servings == this.servings &&
          other.revision == this.revision &&
          other.createdAt == this.createdAt &&
          other.createdBy == this.createdBy &&
          other.updatedAt == this.updatedAt &&
          other.updatedBy == this.updatedBy &&
          other.deletedAt == this.deletedAt &&
          other.deletedBy == this.deletedBy);
}

class RecipesCompanion extends UpdateCompanion<Recipe> {
  final Value<int> id;
  final Value<String> title;
  final Value<String?> image;
  final Value<String?> description;
  final Value<String?> notes;
  final Value<int?> totalTimeMinutes;
  final Value<int?> servings;
  final Value<int> revision;
  final Value<DateTime> createdAt;
  final Value<int> createdBy;
  final Value<DateTime> updatedAt;
  final Value<int> updatedBy;
  final Value<DateTime?> deletedAt;
  final Value<int?> deletedBy;
  const RecipesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.image = const Value.absent(),
    this.description = const Value.absent(),
    this.notes = const Value.absent(),
    this.totalTimeMinutes = const Value.absent(),
    this.servings = const Value.absent(),
    this.revision = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deletedBy = const Value.absent(),
  });
  RecipesCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    this.image = const Value.absent(),
    this.description = const Value.absent(),
    this.notes = const Value.absent(),
    this.totalTimeMinutes = const Value.absent(),
    this.servings = const Value.absent(),
    this.revision = const Value.absent(),
    required DateTime createdAt,
    required int createdBy,
    required DateTime updatedAt,
    required int updatedBy,
    this.deletedAt = const Value.absent(),
    this.deletedBy = const Value.absent(),
  })  : title = Value(title),
        createdAt = Value(createdAt),
        createdBy = Value(createdBy),
        updatedAt = Value(updatedAt),
        updatedBy = Value(updatedBy);
  static Insertable<Recipe> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? image,
    Expression<String>? description,
    Expression<String>? notes,
    Expression<int>? totalTimeMinutes,
    Expression<int>? servings,
    Expression<int>? revision,
    Expression<DateTime>? createdAt,
    Expression<int>? createdBy,
    Expression<DateTime>? updatedAt,
    Expression<int>? updatedBy,
    Expression<DateTime>? deletedAt,
    Expression<int>? deletedBy,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (image != null) 'image': image,
      if (description != null) 'description': description,
      if (notes != null) 'notes': notes,
      if (totalTimeMinutes != null) 'total_time_minutes': totalTimeMinutes,
      if (servings != null) 'servings': servings,
      if (revision != null) 'revision': revision,
      if (createdAt != null) 'created_at': createdAt,
      if (createdBy != null) 'created_by': createdBy,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deletedBy != null) 'deleted_by': deletedBy,
    });
  }

  RecipesCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<String?>? image,
      Value<String?>? description,
      Value<String?>? notes,
      Value<int?>? totalTimeMinutes,
      Value<int?>? servings,
      Value<int>? revision,
      Value<DateTime>? createdAt,
      Value<int>? createdBy,
      Value<DateTime>? updatedAt,
      Value<int>? updatedBy,
      Value<DateTime?>? deletedAt,
      Value<int?>? deletedBy}) {
    return RecipesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      image: image ?? this.image,
      description: description ?? this.description,
      notes: notes ?? this.notes,
      totalTimeMinutes: totalTimeMinutes ?? this.totalTimeMinutes,
      servings: servings ?? this.servings,
      revision: revision ?? this.revision,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      deletedAt: deletedAt ?? this.deletedAt,
      deletedBy: deletedBy ?? this.deletedBy,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (image.present) {
      map['image'] = Variable<String>(image.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (totalTimeMinutes.present) {
      map['total_time_minutes'] = Variable<int>(totalTimeMinutes.value);
    }
    if (servings.present) {
      map['servings'] = Variable<int>(servings.value);
    }
    if (revision.present) {
      map['revision'] = Variable<int>(revision.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<int>(createdBy.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<int>(updatedBy.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (deletedBy.present) {
      map['deleted_by'] = Variable<int>(deletedBy.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecipesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('image: $image, ')
          ..write('description: $description, ')
          ..write('notes: $notes, ')
          ..write('totalTimeMinutes: $totalTimeMinutes, ')
          ..write('servings: $servings, ')
          ..write('revision: $revision, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deletedBy: $deletedBy')
          ..write(')'))
        .toString();
  }
}

class ShoppingCategories extends Table
    with TableInfo<ShoppingCategories, ShoppingCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  ShoppingCategories(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
      'name_en', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _nameDeMeta = const VerificationMeta('nameDe');
  late final GeneratedColumn<String> nameDe = GeneratedColumn<String>(
      'name_de', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _createdByMeta =
      const VerificationMeta('createdBy');
  late final GeneratedColumn<int> createdBy = GeneratedColumn<int>(
      'created_by', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _updatedByMeta =
      const VerificationMeta('updatedBy');
  late final GeneratedColumn<int> updatedBy = GeneratedColumn<int>(
      'updated_by', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  static const VerificationMeta _deletedByMeta =
      const VerificationMeta('deletedBy');
  late final GeneratedColumn<int> deletedBy = GeneratedColumn<int>(
      'deleted_by', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  @override
  List<GeneratedColumn> get $columns => [
        code,
        nameEn,
        nameDe,
        sortOrder,
        createdAt,
        createdBy,
        updatedAt,
        updatedBy,
        deletedAt,
        deletedBy
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shopping_categories';
  @override
  VerificationContext validateIntegrity(Insertable<ShoppingCategory> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('name_en')) {
      context.handle(_nameEnMeta,
          nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta));
    } else if (isInserting) {
      context.missing(_nameEnMeta);
    }
    if (data.containsKey('name_de')) {
      context.handle(_nameDeMeta,
          nameDe.isAcceptableOrUnknown(data['name_de']!, _nameDeMeta));
    } else if (isInserting) {
      context.missing(_nameDeMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('updated_by')) {
      context.handle(_updatedByMeta,
          updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta));
    } else if (isInserting) {
      context.missing(_updatedByMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('deleted_by')) {
      context.handle(_deletedByMeta,
          deletedBy.isAcceptableOrUnknown(data['deleted_by']!, _deletedByMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {code};
  @override
  ShoppingCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShoppingCategory(
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code'])!,
      nameEn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_en'])!,
      nameDe: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_de'])!,
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      createdBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_by'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      updatedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_by'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
      deletedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}deleted_by']),
    );
  }

  @override
  ShoppingCategories createAlias(String alias) {
    return ShoppingCategories(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints =>
      const ['CONSTRAINT shopping_category_pkey PRIMARY KEY(code)'];
  @override
  bool get dontWriteConstraints => true;
}

class ShoppingCategory extends DataClass
    implements Insertable<ShoppingCategory> {
  final String code;
  final String nameEn;
  final String nameDe;
  final int sortOrder;
  final DateTime createdAt;
  final int createdBy;
  final DateTime updatedAt;
  final int updatedBy;
  final DateTime? deletedAt;
  final int? deletedBy;
  const ShoppingCategory(
      {required this.code,
      required this.nameEn,
      required this.nameDe,
      required this.sortOrder,
      required this.createdAt,
      required this.createdBy,
      required this.updatedAt,
      required this.updatedBy,
      this.deletedAt,
      this.deletedBy});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['code'] = Variable<String>(code);
    map['name_en'] = Variable<String>(nameEn);
    map['name_de'] = Variable<String>(nameDe);
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['created_by'] = Variable<int>(createdBy);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['updated_by'] = Variable<int>(updatedBy);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || deletedBy != null) {
      map['deleted_by'] = Variable<int>(deletedBy);
    }
    return map;
  }

  ShoppingCategoriesCompanion toCompanion(bool nullToAbsent) {
    return ShoppingCategoriesCompanion(
      code: Value(code),
      nameEn: Value(nameEn),
      nameDe: Value(nameDe),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
      createdBy: Value(createdBy),
      updatedAt: Value(updatedAt),
      updatedBy: Value(updatedBy),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deletedBy: deletedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedBy),
    );
  }

  factory ShoppingCategory.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShoppingCategory(
      code: serializer.fromJson<String>(json['code']),
      nameEn: serializer.fromJson<String>(json['name_en']),
      nameDe: serializer.fromJson<String>(json['name_de']),
      sortOrder: serializer.fromJson<int>(json['sort_order']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      createdBy: serializer.fromJson<int>(json['created_by']),
      updatedAt: serializer.fromJson<DateTime>(json['updated_at']),
      updatedBy: serializer.fromJson<int>(json['updated_by']),
      deletedAt: serializer.fromJson<DateTime?>(json['deleted_at']),
      deletedBy: serializer.fromJson<int?>(json['deleted_by']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'code': serializer.toJson<String>(code),
      'name_en': serializer.toJson<String>(nameEn),
      'name_de': serializer.toJson<String>(nameDe),
      'sort_order': serializer.toJson<int>(sortOrder),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'created_by': serializer.toJson<int>(createdBy),
      'updated_at': serializer.toJson<DateTime>(updatedAt),
      'updated_by': serializer.toJson<int>(updatedBy),
      'deleted_at': serializer.toJson<DateTime?>(deletedAt),
      'deleted_by': serializer.toJson<int?>(deletedBy),
    };
  }

  ShoppingCategory copyWith(
          {String? code,
          String? nameEn,
          String? nameDe,
          int? sortOrder,
          DateTime? createdAt,
          int? createdBy,
          DateTime? updatedAt,
          int? updatedBy,
          Value<DateTime?> deletedAt = const Value.absent(),
          Value<int?> deletedBy = const Value.absent()}) =>
      ShoppingCategory(
        code: code ?? this.code,
        nameEn: nameEn ?? this.nameEn,
        nameDe: nameDe ?? this.nameDe,
        sortOrder: sortOrder ?? this.sortOrder,
        createdAt: createdAt ?? this.createdAt,
        createdBy: createdBy ?? this.createdBy,
        updatedAt: updatedAt ?? this.updatedAt,
        updatedBy: updatedBy ?? this.updatedBy,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        deletedBy: deletedBy.present ? deletedBy.value : this.deletedBy,
      );
  ShoppingCategory copyWithCompanion(ShoppingCategoriesCompanion data) {
    return ShoppingCategory(
      code: data.code.present ? data.code.value : this.code,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
      nameDe: data.nameDe.present ? data.nameDe.value : this.nameDe,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deletedBy: data.deletedBy.present ? data.deletedBy.value : this.deletedBy,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingCategory(')
          ..write('code: $code, ')
          ..write('nameEn: $nameEn, ')
          ..write('nameDe: $nameDe, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deletedBy: $deletedBy')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(code, nameEn, nameDe, sortOrder, createdAt,
      createdBy, updatedAt, updatedBy, deletedAt, deletedBy);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShoppingCategory &&
          other.code == this.code &&
          other.nameEn == this.nameEn &&
          other.nameDe == this.nameDe &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt &&
          other.createdBy == this.createdBy &&
          other.updatedAt == this.updatedAt &&
          other.updatedBy == this.updatedBy &&
          other.deletedAt == this.deletedAt &&
          other.deletedBy == this.deletedBy);
}

class ShoppingCategoriesCompanion extends UpdateCompanion<ShoppingCategory> {
  final Value<String> code;
  final Value<String> nameEn;
  final Value<String> nameDe;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  final Value<int> createdBy;
  final Value<DateTime> updatedAt;
  final Value<int> updatedBy;
  final Value<DateTime?> deletedAt;
  final Value<int?> deletedBy;
  final Value<int> rowid;
  const ShoppingCategoriesCompanion({
    this.code = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.nameDe = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deletedBy = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShoppingCategoriesCompanion.insert({
    required String code,
    required String nameEn,
    required String nameDe,
    required int sortOrder,
    required DateTime createdAt,
    required int createdBy,
    required DateTime updatedAt,
    required int updatedBy,
    this.deletedAt = const Value.absent(),
    this.deletedBy = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : code = Value(code),
        nameEn = Value(nameEn),
        nameDe = Value(nameDe),
        sortOrder = Value(sortOrder),
        createdAt = Value(createdAt),
        createdBy = Value(createdBy),
        updatedAt = Value(updatedAt),
        updatedBy = Value(updatedBy);
  static Insertable<ShoppingCategory> custom({
    Expression<String>? code,
    Expression<String>? nameEn,
    Expression<String>? nameDe,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
    Expression<int>? createdBy,
    Expression<DateTime>? updatedAt,
    Expression<int>? updatedBy,
    Expression<DateTime>? deletedAt,
    Expression<int>? deletedBy,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (code != null) 'code': code,
      if (nameEn != null) 'name_en': nameEn,
      if (nameDe != null) 'name_de': nameDe,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (createdBy != null) 'created_by': createdBy,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deletedBy != null) 'deleted_by': deletedBy,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShoppingCategoriesCompanion copyWith(
      {Value<String>? code,
      Value<String>? nameEn,
      Value<String>? nameDe,
      Value<int>? sortOrder,
      Value<DateTime>? createdAt,
      Value<int>? createdBy,
      Value<DateTime>? updatedAt,
      Value<int>? updatedBy,
      Value<DateTime?>? deletedAt,
      Value<int?>? deletedBy,
      Value<int>? rowid}) {
    return ShoppingCategoriesCompanion(
      code: code ?? this.code,
      nameEn: nameEn ?? this.nameEn,
      nameDe: nameDe ?? this.nameDe,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      deletedAt: deletedAt ?? this.deletedAt,
      deletedBy: deletedBy ?? this.deletedBy,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    if (nameDe.present) {
      map['name_de'] = Variable<String>(nameDe.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<int>(createdBy.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<int>(updatedBy.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (deletedBy.present) {
      map['deleted_by'] = Variable<int>(deletedBy.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingCategoriesCompanion(')
          ..write('code: $code, ')
          ..write('nameEn: $nameEn, ')
          ..write('nameDe: $nameDe, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deletedBy: $deletedBy, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Ingredients extends Table with TableInfo<Ingredients, Ingredient> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Ingredients(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: '');
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _shoppingCategoryCodeMeta =
      const VerificationMeta('shoppingCategoryCode');
  late final GeneratedColumn<String> shoppingCategoryCode =
      GeneratedColumn<String>('shopping_category_code', aliasedName, true,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          $customConstraints: 'NULL');
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _createdByMeta =
      const VerificationMeta('createdBy');
  late final GeneratedColumn<int> createdBy = GeneratedColumn<int>(
      'created_by', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _updatedByMeta =
      const VerificationMeta('updatedBy');
  late final GeneratedColumn<int> updatedBy = GeneratedColumn<int>(
      'updated_by', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  static const VerificationMeta _deletedByMeta =
      const VerificationMeta('deletedBy');
  late final GeneratedColumn<int> deletedBy = GeneratedColumn<int>(
      'deleted_by', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        shoppingCategoryCode,
        createdAt,
        createdBy,
        updatedAt,
        updatedBy,
        deletedAt,
        deletedBy
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ingredients';
  @override
  VerificationContext validateIntegrity(Insertable<Ingredient> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('shopping_category_code')) {
      context.handle(
          _shoppingCategoryCodeMeta,
          shoppingCategoryCode.isAcceptableOrUnknown(
              data['shopping_category_code']!, _shoppingCategoryCodeMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('updated_by')) {
      context.handle(_updatedByMeta,
          updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta));
    } else if (isInserting) {
      context.missing(_updatedByMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('deleted_by')) {
      context.handle(_deletedByMeta,
          deletedBy.isAcceptableOrUnknown(data['deleted_by']!, _deletedByMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Ingredient map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Ingredient(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      shoppingCategoryCode: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}shopping_category_code']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      createdBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_by'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      updatedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_by'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
      deletedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}deleted_by']),
    );
  }

  @override
  Ingredients createAlias(String alias) {
    return Ingredients(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
        'CONSTRAINT ingredient_pkey PRIMARY KEY(id)',
        'CONSTRAINT ingredient_shopping_category_fkey FOREIGN KEY(shopping_category_code)REFERENCES shopping_categories(code)ON UPDATE CASCADE'
      ];
  @override
  bool get dontWriteConstraints => true;
}

class Ingredient extends DataClass implements Insertable<Ingredient> {
  final int id;
  final String name;
  final String? shoppingCategoryCode;
  final DateTime createdAt;
  final int createdBy;
  final DateTime updatedAt;
  final int updatedBy;
  final DateTime? deletedAt;
  final int? deletedBy;
  const Ingredient(
      {required this.id,
      required this.name,
      this.shoppingCategoryCode,
      required this.createdAt,
      required this.createdBy,
      required this.updatedAt,
      required this.updatedBy,
      this.deletedAt,
      this.deletedBy});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || shoppingCategoryCode != null) {
      map['shopping_category_code'] = Variable<String>(shoppingCategoryCode);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['created_by'] = Variable<int>(createdBy);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['updated_by'] = Variable<int>(updatedBy);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || deletedBy != null) {
      map['deleted_by'] = Variable<int>(deletedBy);
    }
    return map;
  }

  IngredientsCompanion toCompanion(bool nullToAbsent) {
    return IngredientsCompanion(
      id: Value(id),
      name: Value(name),
      shoppingCategoryCode: shoppingCategoryCode == null && nullToAbsent
          ? const Value.absent()
          : Value(shoppingCategoryCode),
      createdAt: Value(createdAt),
      createdBy: Value(createdBy),
      updatedAt: Value(updatedAt),
      updatedBy: Value(updatedBy),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deletedBy: deletedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedBy),
    );
  }

  factory Ingredient.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Ingredient(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      shoppingCategoryCode:
          serializer.fromJson<String?>(json['shopping_category_code']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      createdBy: serializer.fromJson<int>(json['created_by']),
      updatedAt: serializer.fromJson<DateTime>(json['updated_at']),
      updatedBy: serializer.fromJson<int>(json['updated_by']),
      deletedAt: serializer.fromJson<DateTime?>(json['deleted_at']),
      deletedBy: serializer.fromJson<int?>(json['deleted_by']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'shopping_category_code':
          serializer.toJson<String?>(shoppingCategoryCode),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'created_by': serializer.toJson<int>(createdBy),
      'updated_at': serializer.toJson<DateTime>(updatedAt),
      'updated_by': serializer.toJson<int>(updatedBy),
      'deleted_at': serializer.toJson<DateTime?>(deletedAt),
      'deleted_by': serializer.toJson<int?>(deletedBy),
    };
  }

  Ingredient copyWith(
          {int? id,
          String? name,
          Value<String?> shoppingCategoryCode = const Value.absent(),
          DateTime? createdAt,
          int? createdBy,
          DateTime? updatedAt,
          int? updatedBy,
          Value<DateTime?> deletedAt = const Value.absent(),
          Value<int?> deletedBy = const Value.absent()}) =>
      Ingredient(
        id: id ?? this.id,
        name: name ?? this.name,
        shoppingCategoryCode: shoppingCategoryCode.present
            ? shoppingCategoryCode.value
            : this.shoppingCategoryCode,
        createdAt: createdAt ?? this.createdAt,
        createdBy: createdBy ?? this.createdBy,
        updatedAt: updatedAt ?? this.updatedAt,
        updatedBy: updatedBy ?? this.updatedBy,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        deletedBy: deletedBy.present ? deletedBy.value : this.deletedBy,
      );
  Ingredient copyWithCompanion(IngredientsCompanion data) {
    return Ingredient(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      shoppingCategoryCode: data.shoppingCategoryCode.present
          ? data.shoppingCategoryCode.value
          : this.shoppingCategoryCode,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deletedBy: data.deletedBy.present ? data.deletedBy.value : this.deletedBy,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Ingredient(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('shoppingCategoryCode: $shoppingCategoryCode, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deletedBy: $deletedBy')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, shoppingCategoryCode, createdAt,
      createdBy, updatedAt, updatedBy, deletedAt, deletedBy);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Ingredient &&
          other.id == this.id &&
          other.name == this.name &&
          other.shoppingCategoryCode == this.shoppingCategoryCode &&
          other.createdAt == this.createdAt &&
          other.createdBy == this.createdBy &&
          other.updatedAt == this.updatedAt &&
          other.updatedBy == this.updatedBy &&
          other.deletedAt == this.deletedAt &&
          other.deletedBy == this.deletedBy);
}

class IngredientsCompanion extends UpdateCompanion<Ingredient> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> shoppingCategoryCode;
  final Value<DateTime> createdAt;
  final Value<int> createdBy;
  final Value<DateTime> updatedAt;
  final Value<int> updatedBy;
  final Value<DateTime?> deletedAt;
  final Value<int?> deletedBy;
  const IngredientsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.shoppingCategoryCode = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deletedBy = const Value.absent(),
  });
  IngredientsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.shoppingCategoryCode = const Value.absent(),
    required DateTime createdAt,
    required int createdBy,
    required DateTime updatedAt,
    required int updatedBy,
    this.deletedAt = const Value.absent(),
    this.deletedBy = const Value.absent(),
  })  : name = Value(name),
        createdAt = Value(createdAt),
        createdBy = Value(createdBy),
        updatedAt = Value(updatedAt),
        updatedBy = Value(updatedBy);
  static Insertable<Ingredient> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? shoppingCategoryCode,
    Expression<DateTime>? createdAt,
    Expression<int>? createdBy,
    Expression<DateTime>? updatedAt,
    Expression<int>? updatedBy,
    Expression<DateTime>? deletedAt,
    Expression<int>? deletedBy,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (shoppingCategoryCode != null)
        'shopping_category_code': shoppingCategoryCode,
      if (createdAt != null) 'created_at': createdAt,
      if (createdBy != null) 'created_by': createdBy,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deletedBy != null) 'deleted_by': deletedBy,
    });
  }

  IngredientsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? shoppingCategoryCode,
      Value<DateTime>? createdAt,
      Value<int>? createdBy,
      Value<DateTime>? updatedAt,
      Value<int>? updatedBy,
      Value<DateTime?>? deletedAt,
      Value<int?>? deletedBy}) {
    return IngredientsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      shoppingCategoryCode: shoppingCategoryCode ?? this.shoppingCategoryCode,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      deletedAt: deletedAt ?? this.deletedAt,
      deletedBy: deletedBy ?? this.deletedBy,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (shoppingCategoryCode.present) {
      map['shopping_category_code'] =
          Variable<String>(shoppingCategoryCode.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<int>(createdBy.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<int>(updatedBy.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (deletedBy.present) {
      map['deleted_by'] = Variable<int>(deletedBy.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IngredientsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('shoppingCategoryCode: $shoppingCategoryCode, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deletedBy: $deletedBy')
          ..write(')'))
        .toString();
  }
}

class MeasurementUnits extends Table
    with TableInfo<MeasurementUnits, MeasurementUnit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  MeasurementUnits(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
      'name_en', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _nameDeMeta = const VerificationMeta('nameDe');
  late final GeneratedColumn<String> nameDe = GeneratedColumn<String>(
      'name_de', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _selectableMeta =
      const VerificationMeta('selectable');
  late final GeneratedColumn<bool> selectable = GeneratedColumn<bool>(
      'selectable', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _createdByMeta =
      const VerificationMeta('createdBy');
  late final GeneratedColumn<int> createdBy = GeneratedColumn<int>(
      'created_by', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _updatedByMeta =
      const VerificationMeta('updatedBy');
  late final GeneratedColumn<int> updatedBy = GeneratedColumn<int>(
      'updated_by', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  static const VerificationMeta _deletedByMeta =
      const VerificationMeta('deletedBy');
  late final GeneratedColumn<int> deletedBy = GeneratedColumn<int>(
      'deleted_by', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  @override
  List<GeneratedColumn> get $columns => [
        code,
        nameEn,
        nameDe,
        sortOrder,
        selectable,
        createdAt,
        createdBy,
        updatedAt,
        updatedBy,
        deletedAt,
        deletedBy
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'measurement_units';
  @override
  VerificationContext validateIntegrity(Insertable<MeasurementUnit> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('name_en')) {
      context.handle(_nameEnMeta,
          nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta));
    } else if (isInserting) {
      context.missing(_nameEnMeta);
    }
    if (data.containsKey('name_de')) {
      context.handle(_nameDeMeta,
          nameDe.isAcceptableOrUnknown(data['name_de']!, _nameDeMeta));
    } else if (isInserting) {
      context.missing(_nameDeMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('selectable')) {
      context.handle(
          _selectableMeta,
          selectable.isAcceptableOrUnknown(
              data['selectable']!, _selectableMeta));
    } else if (isInserting) {
      context.missing(_selectableMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('updated_by')) {
      context.handle(_updatedByMeta,
          updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta));
    } else if (isInserting) {
      context.missing(_updatedByMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('deleted_by')) {
      context.handle(_deletedByMeta,
          deletedBy.isAcceptableOrUnknown(data['deleted_by']!, _deletedByMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {code};
  @override
  MeasurementUnit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MeasurementUnit(
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code'])!,
      nameEn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_en'])!,
      nameDe: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_de'])!,
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
      selectable: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}selectable'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      createdBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_by'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      updatedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_by'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
      deletedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}deleted_by']),
    );
  }

  @override
  MeasurementUnits createAlias(String alias) {
    return MeasurementUnits(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints =>
      const ['CONSTRAINT measurement_unit_pkey PRIMARY KEY(code)'];
  @override
  bool get dontWriteConstraints => true;
}

class MeasurementUnit extends DataClass implements Insertable<MeasurementUnit> {
  final String code;
  final String nameEn;
  final String nameDe;
  final int sortOrder;
  final bool selectable;
  final DateTime createdAt;
  final int createdBy;
  final DateTime updatedAt;
  final int updatedBy;
  final DateTime? deletedAt;
  final int? deletedBy;
  const MeasurementUnit(
      {required this.code,
      required this.nameEn,
      required this.nameDe,
      required this.sortOrder,
      required this.selectable,
      required this.createdAt,
      required this.createdBy,
      required this.updatedAt,
      required this.updatedBy,
      this.deletedAt,
      this.deletedBy});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['code'] = Variable<String>(code);
    map['name_en'] = Variable<String>(nameEn);
    map['name_de'] = Variable<String>(nameDe);
    map['sort_order'] = Variable<int>(sortOrder);
    map['selectable'] = Variable<bool>(selectable);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['created_by'] = Variable<int>(createdBy);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['updated_by'] = Variable<int>(updatedBy);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || deletedBy != null) {
      map['deleted_by'] = Variable<int>(deletedBy);
    }
    return map;
  }

  MeasurementUnitsCompanion toCompanion(bool nullToAbsent) {
    return MeasurementUnitsCompanion(
      code: Value(code),
      nameEn: Value(nameEn),
      nameDe: Value(nameDe),
      sortOrder: Value(sortOrder),
      selectable: Value(selectable),
      createdAt: Value(createdAt),
      createdBy: Value(createdBy),
      updatedAt: Value(updatedAt),
      updatedBy: Value(updatedBy),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deletedBy: deletedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedBy),
    );
  }

  factory MeasurementUnit.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MeasurementUnit(
      code: serializer.fromJson<String>(json['code']),
      nameEn: serializer.fromJson<String>(json['name_en']),
      nameDe: serializer.fromJson<String>(json['name_de']),
      sortOrder: serializer.fromJson<int>(json['sort_order']),
      selectable: serializer.fromJson<bool>(json['selectable']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      createdBy: serializer.fromJson<int>(json['created_by']),
      updatedAt: serializer.fromJson<DateTime>(json['updated_at']),
      updatedBy: serializer.fromJson<int>(json['updated_by']),
      deletedAt: serializer.fromJson<DateTime?>(json['deleted_at']),
      deletedBy: serializer.fromJson<int?>(json['deleted_by']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'code': serializer.toJson<String>(code),
      'name_en': serializer.toJson<String>(nameEn),
      'name_de': serializer.toJson<String>(nameDe),
      'sort_order': serializer.toJson<int>(sortOrder),
      'selectable': serializer.toJson<bool>(selectable),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'created_by': serializer.toJson<int>(createdBy),
      'updated_at': serializer.toJson<DateTime>(updatedAt),
      'updated_by': serializer.toJson<int>(updatedBy),
      'deleted_at': serializer.toJson<DateTime?>(deletedAt),
      'deleted_by': serializer.toJson<int?>(deletedBy),
    };
  }

  MeasurementUnit copyWith(
          {String? code,
          String? nameEn,
          String? nameDe,
          int? sortOrder,
          bool? selectable,
          DateTime? createdAt,
          int? createdBy,
          DateTime? updatedAt,
          int? updatedBy,
          Value<DateTime?> deletedAt = const Value.absent(),
          Value<int?> deletedBy = const Value.absent()}) =>
      MeasurementUnit(
        code: code ?? this.code,
        nameEn: nameEn ?? this.nameEn,
        nameDe: nameDe ?? this.nameDe,
        sortOrder: sortOrder ?? this.sortOrder,
        selectable: selectable ?? this.selectable,
        createdAt: createdAt ?? this.createdAt,
        createdBy: createdBy ?? this.createdBy,
        updatedAt: updatedAt ?? this.updatedAt,
        updatedBy: updatedBy ?? this.updatedBy,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        deletedBy: deletedBy.present ? deletedBy.value : this.deletedBy,
      );
  MeasurementUnit copyWithCompanion(MeasurementUnitsCompanion data) {
    return MeasurementUnit(
      code: data.code.present ? data.code.value : this.code,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
      nameDe: data.nameDe.present ? data.nameDe.value : this.nameDe,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      selectable:
          data.selectable.present ? data.selectable.value : this.selectable,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deletedBy: data.deletedBy.present ? data.deletedBy.value : this.deletedBy,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MeasurementUnit(')
          ..write('code: $code, ')
          ..write('nameEn: $nameEn, ')
          ..write('nameDe: $nameDe, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('selectable: $selectable, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deletedBy: $deletedBy')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(code, nameEn, nameDe, sortOrder, selectable,
      createdAt, createdBy, updatedAt, updatedBy, deletedAt, deletedBy);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MeasurementUnit &&
          other.code == this.code &&
          other.nameEn == this.nameEn &&
          other.nameDe == this.nameDe &&
          other.sortOrder == this.sortOrder &&
          other.selectable == this.selectable &&
          other.createdAt == this.createdAt &&
          other.createdBy == this.createdBy &&
          other.updatedAt == this.updatedAt &&
          other.updatedBy == this.updatedBy &&
          other.deletedAt == this.deletedAt &&
          other.deletedBy == this.deletedBy);
}

class MeasurementUnitsCompanion extends UpdateCompanion<MeasurementUnit> {
  final Value<String> code;
  final Value<String> nameEn;
  final Value<String> nameDe;
  final Value<int> sortOrder;
  final Value<bool> selectable;
  final Value<DateTime> createdAt;
  final Value<int> createdBy;
  final Value<DateTime> updatedAt;
  final Value<int> updatedBy;
  final Value<DateTime?> deletedAt;
  final Value<int?> deletedBy;
  final Value<int> rowid;
  const MeasurementUnitsCompanion({
    this.code = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.nameDe = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.selectable = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deletedBy = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MeasurementUnitsCompanion.insert({
    required String code,
    required String nameEn,
    required String nameDe,
    required int sortOrder,
    required bool selectable,
    required DateTime createdAt,
    required int createdBy,
    required DateTime updatedAt,
    required int updatedBy,
    this.deletedAt = const Value.absent(),
    this.deletedBy = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : code = Value(code),
        nameEn = Value(nameEn),
        nameDe = Value(nameDe),
        sortOrder = Value(sortOrder),
        selectable = Value(selectable),
        createdAt = Value(createdAt),
        createdBy = Value(createdBy),
        updatedAt = Value(updatedAt),
        updatedBy = Value(updatedBy);
  static Insertable<MeasurementUnit> custom({
    Expression<String>? code,
    Expression<String>? nameEn,
    Expression<String>? nameDe,
    Expression<int>? sortOrder,
    Expression<bool>? selectable,
    Expression<DateTime>? createdAt,
    Expression<int>? createdBy,
    Expression<DateTime>? updatedAt,
    Expression<int>? updatedBy,
    Expression<DateTime>? deletedAt,
    Expression<int>? deletedBy,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (code != null) 'code': code,
      if (nameEn != null) 'name_en': nameEn,
      if (nameDe != null) 'name_de': nameDe,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (selectable != null) 'selectable': selectable,
      if (createdAt != null) 'created_at': createdAt,
      if (createdBy != null) 'created_by': createdBy,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deletedBy != null) 'deleted_by': deletedBy,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MeasurementUnitsCompanion copyWith(
      {Value<String>? code,
      Value<String>? nameEn,
      Value<String>? nameDe,
      Value<int>? sortOrder,
      Value<bool>? selectable,
      Value<DateTime>? createdAt,
      Value<int>? createdBy,
      Value<DateTime>? updatedAt,
      Value<int>? updatedBy,
      Value<DateTime?>? deletedAt,
      Value<int?>? deletedBy,
      Value<int>? rowid}) {
    return MeasurementUnitsCompanion(
      code: code ?? this.code,
      nameEn: nameEn ?? this.nameEn,
      nameDe: nameDe ?? this.nameDe,
      sortOrder: sortOrder ?? this.sortOrder,
      selectable: selectable ?? this.selectable,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      deletedAt: deletedAt ?? this.deletedAt,
      deletedBy: deletedBy ?? this.deletedBy,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    if (nameDe.present) {
      map['name_de'] = Variable<String>(nameDe.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (selectable.present) {
      map['selectable'] = Variable<bool>(selectable.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<int>(createdBy.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<int>(updatedBy.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (deletedBy.present) {
      map['deleted_by'] = Variable<int>(deletedBy.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MeasurementUnitsCompanion(')
          ..write('code: $code, ')
          ..write('nameEn: $nameEn, ')
          ..write('nameDe: $nameDe, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('selectable: $selectable, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deletedBy: $deletedBy, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class RecipeIngredients extends Table
    with TableInfo<RecipeIngredients, RecipeIngredient> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  RecipeIngredients(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _recipeIdMeta =
      const VerificationMeta('recipeId');
  late final GeneratedColumn<int> recipeId = GeneratedColumn<int>(
      'recipe_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _ingredientIdMeta =
      const VerificationMeta('ingredientId');
  late final GeneratedColumn<int> ingredientId = GeneratedColumn<int>(
      'ingredient_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, true,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  static const VerificationMeta _quantityNoteMeta =
      const VerificationMeta('quantityNote');
  late final GeneratedColumn<String> quantityNote = GeneratedColumn<String>(
      'quantity_note', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  static const VerificationMeta _sectionNameMeta =
      const VerificationMeta('sectionName');
  late final GeneratedColumn<String> sectionName = GeneratedColumn<String>(
      'section_name', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL DEFAULT 0',
      defaultValue: const CustomExpression('0'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _createdByMeta =
      const VerificationMeta('createdBy');
  late final GeneratedColumn<int> createdBy = GeneratedColumn<int>(
      'created_by', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _updatedByMeta =
      const VerificationMeta('updatedBy');
  late final GeneratedColumn<int> updatedBy = GeneratedColumn<int>(
      'updated_by', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  static const VerificationMeta _deletedByMeta =
      const VerificationMeta('deletedBy');
  late final GeneratedColumn<int> deletedBy = GeneratedColumn<int>(
      'deleted_by', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  @override
  List<GeneratedColumn> get $columns => [
        recipeId,
        ingredientId,
        amount,
        unit,
        quantityNote,
        sectionName,
        sortOrder,
        createdAt,
        createdBy,
        updatedAt,
        updatedBy,
        deletedAt,
        deletedBy
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipe_ingredients';
  @override
  VerificationContext validateIntegrity(Insertable<RecipeIngredient> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('recipe_id')) {
      context.handle(_recipeIdMeta,
          recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta));
    } else if (isInserting) {
      context.missing(_recipeIdMeta);
    }
    if (data.containsKey('ingredient_id')) {
      context.handle(
          _ingredientIdMeta,
          ingredientId.isAcceptableOrUnknown(
              data['ingredient_id']!, _ingredientIdMeta));
    } else if (isInserting) {
      context.missing(_ingredientIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    }
    if (data.containsKey('quantity_note')) {
      context.handle(
          _quantityNoteMeta,
          quantityNote.isAcceptableOrUnknown(
              data['quantity_note']!, _quantityNoteMeta));
    }
    if (data.containsKey('section_name')) {
      context.handle(
          _sectionNameMeta,
          sectionName.isAcceptableOrUnknown(
              data['section_name']!, _sectionNameMeta));
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('updated_by')) {
      context.handle(_updatedByMeta,
          updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta));
    } else if (isInserting) {
      context.missing(_updatedByMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('deleted_by')) {
      context.handle(_deletedByMeta,
          deletedBy.isAcceptableOrUnknown(data['deleted_by']!, _deletedByMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {recipeId, ingredientId};
  @override
  RecipeIngredient map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecipeIngredient(
      recipeId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}recipe_id'])!,
      ingredientId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ingredient_id'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount']),
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit']),
      quantityNote: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}quantity_note']),
      sectionName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}section_name']),
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      createdBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_by'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      updatedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_by'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
      deletedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}deleted_by']),
    );
  }

  @override
  RecipeIngredients createAlias(String alias) {
    return RecipeIngredients(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
        'CONSTRAINT recipe_ingredient_pkey PRIMARY KEY(recipe_id, ingredient_id)',
        'CONSTRAINT recipe_ingredient_recipe_id_fkey FOREIGN KEY(recipe_id)REFERENCES recipes(id)ON DELETE CASCADE',
        'CONSTRAINT recipe_ingredient_ingredient_id_fkey FOREIGN KEY(ingredient_id)REFERENCES ingredients(id)ON DELETE CASCADE'
      ];
  @override
  bool get dontWriteConstraints => true;
}

class RecipeIngredient extends DataClass
    implements Insertable<RecipeIngredient> {
  final int recipeId;
  final int ingredientId;
  final double? amount;
  final String? unit;
  final String? quantityNote;
  final String? sectionName;
  final int sortOrder;
  final DateTime createdAt;
  final int createdBy;
  final DateTime updatedAt;
  final int updatedBy;
  final DateTime? deletedAt;
  final int? deletedBy;
  const RecipeIngredient(
      {required this.recipeId,
      required this.ingredientId,
      this.amount,
      this.unit,
      this.quantityNote,
      this.sectionName,
      required this.sortOrder,
      required this.createdAt,
      required this.createdBy,
      required this.updatedAt,
      required this.updatedBy,
      this.deletedAt,
      this.deletedBy});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['recipe_id'] = Variable<int>(recipeId);
    map['ingredient_id'] = Variable<int>(ingredientId);
    if (!nullToAbsent || amount != null) {
      map['amount'] = Variable<double>(amount);
    }
    if (!nullToAbsent || unit != null) {
      map['unit'] = Variable<String>(unit);
    }
    if (!nullToAbsent || quantityNote != null) {
      map['quantity_note'] = Variable<String>(quantityNote);
    }
    if (!nullToAbsent || sectionName != null) {
      map['section_name'] = Variable<String>(sectionName);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['created_by'] = Variable<int>(createdBy);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['updated_by'] = Variable<int>(updatedBy);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || deletedBy != null) {
      map['deleted_by'] = Variable<int>(deletedBy);
    }
    return map;
  }

  RecipeIngredientsCompanion toCompanion(bool nullToAbsent) {
    return RecipeIngredientsCompanion(
      recipeId: Value(recipeId),
      ingredientId: Value(ingredientId),
      amount:
          amount == null && nullToAbsent ? const Value.absent() : Value(amount),
      unit: unit == null && nullToAbsent ? const Value.absent() : Value(unit),
      quantityNote: quantityNote == null && nullToAbsent
          ? const Value.absent()
          : Value(quantityNote),
      sectionName: sectionName == null && nullToAbsent
          ? const Value.absent()
          : Value(sectionName),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
      createdBy: Value(createdBy),
      updatedAt: Value(updatedAt),
      updatedBy: Value(updatedBy),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deletedBy: deletedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedBy),
    );
  }

  factory RecipeIngredient.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecipeIngredient(
      recipeId: serializer.fromJson<int>(json['recipe_id']),
      ingredientId: serializer.fromJson<int>(json['ingredient_id']),
      amount: serializer.fromJson<double?>(json['amount']),
      unit: serializer.fromJson<String?>(json['unit']),
      quantityNote: serializer.fromJson<String?>(json['quantity_note']),
      sectionName: serializer.fromJson<String?>(json['section_name']),
      sortOrder: serializer.fromJson<int>(json['sort_order']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      createdBy: serializer.fromJson<int>(json['created_by']),
      updatedAt: serializer.fromJson<DateTime>(json['updated_at']),
      updatedBy: serializer.fromJson<int>(json['updated_by']),
      deletedAt: serializer.fromJson<DateTime?>(json['deleted_at']),
      deletedBy: serializer.fromJson<int?>(json['deleted_by']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'recipe_id': serializer.toJson<int>(recipeId),
      'ingredient_id': serializer.toJson<int>(ingredientId),
      'amount': serializer.toJson<double?>(amount),
      'unit': serializer.toJson<String?>(unit),
      'quantity_note': serializer.toJson<String?>(quantityNote),
      'section_name': serializer.toJson<String?>(sectionName),
      'sort_order': serializer.toJson<int>(sortOrder),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'created_by': serializer.toJson<int>(createdBy),
      'updated_at': serializer.toJson<DateTime>(updatedAt),
      'updated_by': serializer.toJson<int>(updatedBy),
      'deleted_at': serializer.toJson<DateTime?>(deletedAt),
      'deleted_by': serializer.toJson<int?>(deletedBy),
    };
  }

  RecipeIngredient copyWith(
          {int? recipeId,
          int? ingredientId,
          Value<double?> amount = const Value.absent(),
          Value<String?> unit = const Value.absent(),
          Value<String?> quantityNote = const Value.absent(),
          Value<String?> sectionName = const Value.absent(),
          int? sortOrder,
          DateTime? createdAt,
          int? createdBy,
          DateTime? updatedAt,
          int? updatedBy,
          Value<DateTime?> deletedAt = const Value.absent(),
          Value<int?> deletedBy = const Value.absent()}) =>
      RecipeIngredient(
        recipeId: recipeId ?? this.recipeId,
        ingredientId: ingredientId ?? this.ingredientId,
        amount: amount.present ? amount.value : this.amount,
        unit: unit.present ? unit.value : this.unit,
        quantityNote:
            quantityNote.present ? quantityNote.value : this.quantityNote,
        sectionName: sectionName.present ? sectionName.value : this.sectionName,
        sortOrder: sortOrder ?? this.sortOrder,
        createdAt: createdAt ?? this.createdAt,
        createdBy: createdBy ?? this.createdBy,
        updatedAt: updatedAt ?? this.updatedAt,
        updatedBy: updatedBy ?? this.updatedBy,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        deletedBy: deletedBy.present ? deletedBy.value : this.deletedBy,
      );
  RecipeIngredient copyWithCompanion(RecipeIngredientsCompanion data) {
    return RecipeIngredient(
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
      ingredientId: data.ingredientId.present
          ? data.ingredientId.value
          : this.ingredientId,
      amount: data.amount.present ? data.amount.value : this.amount,
      unit: data.unit.present ? data.unit.value : this.unit,
      quantityNote: data.quantityNote.present
          ? data.quantityNote.value
          : this.quantityNote,
      sectionName:
          data.sectionName.present ? data.sectionName.value : this.sectionName,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deletedBy: data.deletedBy.present ? data.deletedBy.value : this.deletedBy,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecipeIngredient(')
          ..write('recipeId: $recipeId, ')
          ..write('ingredientId: $ingredientId, ')
          ..write('amount: $amount, ')
          ..write('unit: $unit, ')
          ..write('quantityNote: $quantityNote, ')
          ..write('sectionName: $sectionName, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deletedBy: $deletedBy')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      recipeId,
      ingredientId,
      amount,
      unit,
      quantityNote,
      sectionName,
      sortOrder,
      createdAt,
      createdBy,
      updatedAt,
      updatedBy,
      deletedAt,
      deletedBy);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecipeIngredient &&
          other.recipeId == this.recipeId &&
          other.ingredientId == this.ingredientId &&
          other.amount == this.amount &&
          other.unit == this.unit &&
          other.quantityNote == this.quantityNote &&
          other.sectionName == this.sectionName &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt &&
          other.createdBy == this.createdBy &&
          other.updatedAt == this.updatedAt &&
          other.updatedBy == this.updatedBy &&
          other.deletedAt == this.deletedAt &&
          other.deletedBy == this.deletedBy);
}

class RecipeIngredientsCompanion extends UpdateCompanion<RecipeIngredient> {
  final Value<int> recipeId;
  final Value<int> ingredientId;
  final Value<double?> amount;
  final Value<String?> unit;
  final Value<String?> quantityNote;
  final Value<String?> sectionName;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  final Value<int> createdBy;
  final Value<DateTime> updatedAt;
  final Value<int> updatedBy;
  final Value<DateTime?> deletedAt;
  final Value<int?> deletedBy;
  final Value<int> rowid;
  const RecipeIngredientsCompanion({
    this.recipeId = const Value.absent(),
    this.ingredientId = const Value.absent(),
    this.amount = const Value.absent(),
    this.unit = const Value.absent(),
    this.quantityNote = const Value.absent(),
    this.sectionName = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deletedBy = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecipeIngredientsCompanion.insert({
    required int recipeId,
    required int ingredientId,
    this.amount = const Value.absent(),
    this.unit = const Value.absent(),
    this.quantityNote = const Value.absent(),
    this.sectionName = const Value.absent(),
    this.sortOrder = const Value.absent(),
    required DateTime createdAt,
    required int createdBy,
    required DateTime updatedAt,
    required int updatedBy,
    this.deletedAt = const Value.absent(),
    this.deletedBy = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : recipeId = Value(recipeId),
        ingredientId = Value(ingredientId),
        createdAt = Value(createdAt),
        createdBy = Value(createdBy),
        updatedAt = Value(updatedAt),
        updatedBy = Value(updatedBy);
  static Insertable<RecipeIngredient> custom({
    Expression<int>? recipeId,
    Expression<int>? ingredientId,
    Expression<double>? amount,
    Expression<String>? unit,
    Expression<String>? quantityNote,
    Expression<String>? sectionName,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
    Expression<int>? createdBy,
    Expression<DateTime>? updatedAt,
    Expression<int>? updatedBy,
    Expression<DateTime>? deletedAt,
    Expression<int>? deletedBy,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (recipeId != null) 'recipe_id': recipeId,
      if (ingredientId != null) 'ingredient_id': ingredientId,
      if (amount != null) 'amount': amount,
      if (unit != null) 'unit': unit,
      if (quantityNote != null) 'quantity_note': quantityNote,
      if (sectionName != null) 'section_name': sectionName,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (createdBy != null) 'created_by': createdBy,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deletedBy != null) 'deleted_by': deletedBy,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecipeIngredientsCompanion copyWith(
      {Value<int>? recipeId,
      Value<int>? ingredientId,
      Value<double?>? amount,
      Value<String?>? unit,
      Value<String?>? quantityNote,
      Value<String?>? sectionName,
      Value<int>? sortOrder,
      Value<DateTime>? createdAt,
      Value<int>? createdBy,
      Value<DateTime>? updatedAt,
      Value<int>? updatedBy,
      Value<DateTime?>? deletedAt,
      Value<int?>? deletedBy,
      Value<int>? rowid}) {
    return RecipeIngredientsCompanion(
      recipeId: recipeId ?? this.recipeId,
      ingredientId: ingredientId ?? this.ingredientId,
      amount: amount ?? this.amount,
      unit: unit ?? this.unit,
      quantityNote: quantityNote ?? this.quantityNote,
      sectionName: sectionName ?? this.sectionName,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      deletedAt: deletedAt ?? this.deletedAt,
      deletedBy: deletedBy ?? this.deletedBy,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (recipeId.present) {
      map['recipe_id'] = Variable<int>(recipeId.value);
    }
    if (ingredientId.present) {
      map['ingredient_id'] = Variable<int>(ingredientId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (quantityNote.present) {
      map['quantity_note'] = Variable<String>(quantityNote.value);
    }
    if (sectionName.present) {
      map['section_name'] = Variable<String>(sectionName.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<int>(createdBy.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<int>(updatedBy.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (deletedBy.present) {
      map['deleted_by'] = Variable<int>(deletedBy.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecipeIngredientsCompanion(')
          ..write('recipeId: $recipeId, ')
          ..write('ingredientId: $ingredientId, ')
          ..write('amount: $amount, ')
          ..write('unit: $unit, ')
          ..write('quantityNote: $quantityNote, ')
          ..write('sectionName: $sectionName, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deletedBy: $deletedBy, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Roles extends Table with TableInfo<Roles, Role> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Roles(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: '');
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _createdByMeta =
      const VerificationMeta('createdBy');
  late final GeneratedColumn<int> createdBy = GeneratedColumn<int>(
      'created_by', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _updatedByMeta =
      const VerificationMeta('updatedBy');
  late final GeneratedColumn<int> updatedBy = GeneratedColumn<int>(
      'updated_by', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  static const VerificationMeta _deletedByMeta =
      const VerificationMeta('deletedBy');
  late final GeneratedColumn<int> deletedBy = GeneratedColumn<int>(
      'deleted_by', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        createdAt,
        createdBy,
        updatedAt,
        updatedBy,
        deletedAt,
        deletedBy
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'roles';
  @override
  VerificationContext validateIntegrity(Insertable<Role> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('updated_by')) {
      context.handle(_updatedByMeta,
          updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta));
    } else if (isInserting) {
      context.missing(_updatedByMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('deleted_by')) {
      context.handle(_deletedByMeta,
          deletedBy.isAcceptableOrUnknown(data['deleted_by']!, _deletedByMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Role map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Role(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      createdBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_by'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      updatedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_by'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
      deletedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}deleted_by']),
    );
  }

  @override
  Roles createAlias(String alias) {
    return Roles(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints =>
      const ['CONSTRAINT role_pkey PRIMARY KEY(id)'];
  @override
  bool get dontWriteConstraints => true;
}

class Role extends DataClass implements Insertable<Role> {
  final int id;
  final String name;
  final DateTime createdAt;
  final int createdBy;
  final DateTime updatedAt;
  final int updatedBy;
  final DateTime? deletedAt;
  final int? deletedBy;
  const Role(
      {required this.id,
      required this.name,
      required this.createdAt,
      required this.createdBy,
      required this.updatedAt,
      required this.updatedBy,
      this.deletedAt,
      this.deletedBy});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['created_by'] = Variable<int>(createdBy);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['updated_by'] = Variable<int>(updatedBy);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || deletedBy != null) {
      map['deleted_by'] = Variable<int>(deletedBy);
    }
    return map;
  }

  RolesCompanion toCompanion(bool nullToAbsent) {
    return RolesCompanion(
      id: Value(id),
      name: Value(name),
      createdAt: Value(createdAt),
      createdBy: Value(createdBy),
      updatedAt: Value(updatedAt),
      updatedBy: Value(updatedBy),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deletedBy: deletedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedBy),
    );
  }

  factory Role.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Role(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      createdBy: serializer.fromJson<int>(json['created_by']),
      updatedAt: serializer.fromJson<DateTime>(json['updated_at']),
      updatedBy: serializer.fromJson<int>(json['updated_by']),
      deletedAt: serializer.fromJson<DateTime?>(json['deleted_at']),
      deletedBy: serializer.fromJson<int?>(json['deleted_by']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'created_by': serializer.toJson<int>(createdBy),
      'updated_at': serializer.toJson<DateTime>(updatedAt),
      'updated_by': serializer.toJson<int>(updatedBy),
      'deleted_at': serializer.toJson<DateTime?>(deletedAt),
      'deleted_by': serializer.toJson<int?>(deletedBy),
    };
  }

  Role copyWith(
          {int? id,
          String? name,
          DateTime? createdAt,
          int? createdBy,
          DateTime? updatedAt,
          int? updatedBy,
          Value<DateTime?> deletedAt = const Value.absent(),
          Value<int?> deletedBy = const Value.absent()}) =>
      Role(
        id: id ?? this.id,
        name: name ?? this.name,
        createdAt: createdAt ?? this.createdAt,
        createdBy: createdBy ?? this.createdBy,
        updatedAt: updatedAt ?? this.updatedAt,
        updatedBy: updatedBy ?? this.updatedBy,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        deletedBy: deletedBy.present ? deletedBy.value : this.deletedBy,
      );
  Role copyWithCompanion(RolesCompanion data) {
    return Role(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deletedBy: data.deletedBy.present ? data.deletedBy.value : this.deletedBy,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Role(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deletedBy: $deletedBy')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, createdAt, createdBy, updatedAt,
      updatedBy, deletedAt, deletedBy);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Role &&
          other.id == this.id &&
          other.name == this.name &&
          other.createdAt == this.createdAt &&
          other.createdBy == this.createdBy &&
          other.updatedAt == this.updatedAt &&
          other.updatedBy == this.updatedBy &&
          other.deletedAt == this.deletedAt &&
          other.deletedBy == this.deletedBy);
}

class RolesCompanion extends UpdateCompanion<Role> {
  final Value<int> id;
  final Value<String> name;
  final Value<DateTime> createdAt;
  final Value<int> createdBy;
  final Value<DateTime> updatedAt;
  final Value<int> updatedBy;
  final Value<DateTime?> deletedAt;
  final Value<int?> deletedBy;
  const RolesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deletedBy = const Value.absent(),
  });
  RolesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required DateTime createdAt,
    required int createdBy,
    required DateTime updatedAt,
    required int updatedBy,
    this.deletedAt = const Value.absent(),
    this.deletedBy = const Value.absent(),
  })  : name = Value(name),
        createdAt = Value(createdAt),
        createdBy = Value(createdBy),
        updatedAt = Value(updatedAt),
        updatedBy = Value(updatedBy);
  static Insertable<Role> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<DateTime>? createdAt,
    Expression<int>? createdBy,
    Expression<DateTime>? updatedAt,
    Expression<int>? updatedBy,
    Expression<DateTime>? deletedAt,
    Expression<int>? deletedBy,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
      if (createdBy != null) 'created_by': createdBy,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deletedBy != null) 'deleted_by': deletedBy,
    });
  }

  RolesCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<DateTime>? createdAt,
      Value<int>? createdBy,
      Value<DateTime>? updatedAt,
      Value<int>? updatedBy,
      Value<DateTime?>? deletedAt,
      Value<int?>? deletedBy}) {
    return RolesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      deletedAt: deletedAt ?? this.deletedAt,
      deletedBy: deletedBy ?? this.deletedBy,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<int>(createdBy.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<int>(updatedBy.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (deletedBy.present) {
      map['deleted_by'] = Variable<int>(deletedBy.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RolesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deletedBy: $deletedBy')
          ..write(')'))
        .toString();
  }
}

class Accounts extends Table with TableInfo<Accounts, Account> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Accounts(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: '');
  static const VerificationMeta _accountNameMeta =
      const VerificationMeta('accountName');
  late final GeneratedColumn<String> accountName = GeneratedColumn<String>(
      'account_name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _profileImageMeta =
      const VerificationMeta('profileImage');
  late final GeneratedColumn<String> profileImage = GeneratedColumn<String>(
      'profile_image', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  static const VerificationMeta _bioMeta = const VerificationMeta('bio');
  late final GeneratedColumn<String> bio = GeneratedColumn<String>(
      'bio', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  static const VerificationMeta _roleIdMeta = const VerificationMeta('roleId');
  late final GeneratedColumn<int> roleId = GeneratedColumn<int>(
      'role_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _hostCodeMeta =
      const VerificationMeta('hostCode');
  late final GeneratedColumn<String> hostCode = GeneratedColumn<String>(
      'host_code', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _createdByMeta =
      const VerificationMeta('createdBy');
  late final GeneratedColumn<int> createdBy = GeneratedColumn<int>(
      'created_by', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _updatedByMeta =
      const VerificationMeta('updatedBy');
  late final GeneratedColumn<int> updatedBy = GeneratedColumn<int>(
      'updated_by', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  static const VerificationMeta _deletedByMeta =
      const VerificationMeta('deletedBy');
  late final GeneratedColumn<int> deletedBy = GeneratedColumn<int>(
      'deleted_by', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  @override
  List<GeneratedColumn> get $columns => [
        id,
        accountName,
        profileImage,
        bio,
        roleId,
        hostCode,
        createdAt,
        createdBy,
        updatedAt,
        updatedBy,
        deletedAt,
        deletedBy
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accounts';
  @override
  VerificationContext validateIntegrity(Insertable<Account> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('account_name')) {
      context.handle(
          _accountNameMeta,
          accountName.isAcceptableOrUnknown(
              data['account_name']!, _accountNameMeta));
    } else if (isInserting) {
      context.missing(_accountNameMeta);
    }
    if (data.containsKey('profile_image')) {
      context.handle(
          _profileImageMeta,
          profileImage.isAcceptableOrUnknown(
              data['profile_image']!, _profileImageMeta));
    }
    if (data.containsKey('bio')) {
      context.handle(
          _bioMeta, bio.isAcceptableOrUnknown(data['bio']!, _bioMeta));
    }
    if (data.containsKey('role_id')) {
      context.handle(_roleIdMeta,
          roleId.isAcceptableOrUnknown(data['role_id']!, _roleIdMeta));
    } else if (isInserting) {
      context.missing(_roleIdMeta);
    }
    if (data.containsKey('host_code')) {
      context.handle(_hostCodeMeta,
          hostCode.isAcceptableOrUnknown(data['host_code']!, _hostCodeMeta));
    } else if (isInserting) {
      context.missing(_hostCodeMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('updated_by')) {
      context.handle(_updatedByMeta,
          updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta));
    } else if (isInserting) {
      context.missing(_updatedByMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('deleted_by')) {
      context.handle(_deletedByMeta,
          deletedBy.isAcceptableOrUnknown(data['deleted_by']!, _deletedByMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Account map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Account(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      accountName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}account_name'])!,
      profileImage: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}profile_image']),
      bio: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bio']),
      roleId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}role_id'])!,
      hostCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}host_code'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      createdBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_by'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      updatedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_by'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
      deletedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}deleted_by']),
    );
  }

  @override
  Accounts createAlias(String alias) {
    return Accounts(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
        'CONSTRAINT account_pkey PRIMARY KEY(id)',
        'CONSTRAINT account_role_id_fkey FOREIGN KEY(role_id)REFERENCES roles(id)ON DELETE CASCADE'
      ];
  @override
  bool get dontWriteConstraints => true;
}

class Account extends DataClass implements Insertable<Account> {
  final int id;
  final String accountName;
  final String? profileImage;
  final String? bio;
  final int roleId;
  final String hostCode;
  final DateTime createdAt;
  final int createdBy;
  final DateTime updatedAt;
  final int updatedBy;
  final DateTime? deletedAt;
  final int? deletedBy;
  const Account(
      {required this.id,
      required this.accountName,
      this.profileImage,
      this.bio,
      required this.roleId,
      required this.hostCode,
      required this.createdAt,
      required this.createdBy,
      required this.updatedAt,
      required this.updatedBy,
      this.deletedAt,
      this.deletedBy});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['account_name'] = Variable<String>(accountName);
    if (!nullToAbsent || profileImage != null) {
      map['profile_image'] = Variable<String>(profileImage);
    }
    if (!nullToAbsent || bio != null) {
      map['bio'] = Variable<String>(bio);
    }
    map['role_id'] = Variable<int>(roleId);
    map['host_code'] = Variable<String>(hostCode);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['created_by'] = Variable<int>(createdBy);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['updated_by'] = Variable<int>(updatedBy);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || deletedBy != null) {
      map['deleted_by'] = Variable<int>(deletedBy);
    }
    return map;
  }

  AccountsCompanion toCompanion(bool nullToAbsent) {
    return AccountsCompanion(
      id: Value(id),
      accountName: Value(accountName),
      profileImage: profileImage == null && nullToAbsent
          ? const Value.absent()
          : Value(profileImage),
      bio: bio == null && nullToAbsent ? const Value.absent() : Value(bio),
      roleId: Value(roleId),
      hostCode: Value(hostCode),
      createdAt: Value(createdAt),
      createdBy: Value(createdBy),
      updatedAt: Value(updatedAt),
      updatedBy: Value(updatedBy),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deletedBy: deletedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedBy),
    );
  }

  factory Account.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Account(
      id: serializer.fromJson<int>(json['id']),
      accountName: serializer.fromJson<String>(json['account_name']),
      profileImage: serializer.fromJson<String?>(json['profile_image']),
      bio: serializer.fromJson<String?>(json['bio']),
      roleId: serializer.fromJson<int>(json['role_id']),
      hostCode: serializer.fromJson<String>(json['host_code']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      createdBy: serializer.fromJson<int>(json['created_by']),
      updatedAt: serializer.fromJson<DateTime>(json['updated_at']),
      updatedBy: serializer.fromJson<int>(json['updated_by']),
      deletedAt: serializer.fromJson<DateTime?>(json['deleted_at']),
      deletedBy: serializer.fromJson<int?>(json['deleted_by']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'account_name': serializer.toJson<String>(accountName),
      'profile_image': serializer.toJson<String?>(profileImage),
      'bio': serializer.toJson<String?>(bio),
      'role_id': serializer.toJson<int>(roleId),
      'host_code': serializer.toJson<String>(hostCode),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'created_by': serializer.toJson<int>(createdBy),
      'updated_at': serializer.toJson<DateTime>(updatedAt),
      'updated_by': serializer.toJson<int>(updatedBy),
      'deleted_at': serializer.toJson<DateTime?>(deletedAt),
      'deleted_by': serializer.toJson<int?>(deletedBy),
    };
  }

  Account copyWith(
          {int? id,
          String? accountName,
          Value<String?> profileImage = const Value.absent(),
          Value<String?> bio = const Value.absent(),
          int? roleId,
          String? hostCode,
          DateTime? createdAt,
          int? createdBy,
          DateTime? updatedAt,
          int? updatedBy,
          Value<DateTime?> deletedAt = const Value.absent(),
          Value<int?> deletedBy = const Value.absent()}) =>
      Account(
        id: id ?? this.id,
        accountName: accountName ?? this.accountName,
        profileImage:
            profileImage.present ? profileImage.value : this.profileImage,
        bio: bio.present ? bio.value : this.bio,
        roleId: roleId ?? this.roleId,
        hostCode: hostCode ?? this.hostCode,
        createdAt: createdAt ?? this.createdAt,
        createdBy: createdBy ?? this.createdBy,
        updatedAt: updatedAt ?? this.updatedAt,
        updatedBy: updatedBy ?? this.updatedBy,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        deletedBy: deletedBy.present ? deletedBy.value : this.deletedBy,
      );
  Account copyWithCompanion(AccountsCompanion data) {
    return Account(
      id: data.id.present ? data.id.value : this.id,
      accountName:
          data.accountName.present ? data.accountName.value : this.accountName,
      profileImage: data.profileImage.present
          ? data.profileImage.value
          : this.profileImage,
      bio: data.bio.present ? data.bio.value : this.bio,
      roleId: data.roleId.present ? data.roleId.value : this.roleId,
      hostCode: data.hostCode.present ? data.hostCode.value : this.hostCode,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deletedBy: data.deletedBy.present ? data.deletedBy.value : this.deletedBy,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Account(')
          ..write('id: $id, ')
          ..write('accountName: $accountName, ')
          ..write('profileImage: $profileImage, ')
          ..write('bio: $bio, ')
          ..write('roleId: $roleId, ')
          ..write('hostCode: $hostCode, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deletedBy: $deletedBy')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      accountName,
      profileImage,
      bio,
      roleId,
      hostCode,
      createdAt,
      createdBy,
      updatedAt,
      updatedBy,
      deletedAt,
      deletedBy);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Account &&
          other.id == this.id &&
          other.accountName == this.accountName &&
          other.profileImage == this.profileImage &&
          other.bio == this.bio &&
          other.roleId == this.roleId &&
          other.hostCode == this.hostCode &&
          other.createdAt == this.createdAt &&
          other.createdBy == this.createdBy &&
          other.updatedAt == this.updatedAt &&
          other.updatedBy == this.updatedBy &&
          other.deletedAt == this.deletedAt &&
          other.deletedBy == this.deletedBy);
}

class AccountsCompanion extends UpdateCompanion<Account> {
  final Value<int> id;
  final Value<String> accountName;
  final Value<String?> profileImage;
  final Value<String?> bio;
  final Value<int> roleId;
  final Value<String> hostCode;
  final Value<DateTime> createdAt;
  final Value<int> createdBy;
  final Value<DateTime> updatedAt;
  final Value<int> updatedBy;
  final Value<DateTime?> deletedAt;
  final Value<int?> deletedBy;
  const AccountsCompanion({
    this.id = const Value.absent(),
    this.accountName = const Value.absent(),
    this.profileImage = const Value.absent(),
    this.bio = const Value.absent(),
    this.roleId = const Value.absent(),
    this.hostCode = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deletedBy = const Value.absent(),
  });
  AccountsCompanion.insert({
    this.id = const Value.absent(),
    required String accountName,
    this.profileImage = const Value.absent(),
    this.bio = const Value.absent(),
    required int roleId,
    required String hostCode,
    required DateTime createdAt,
    required int createdBy,
    required DateTime updatedAt,
    required int updatedBy,
    this.deletedAt = const Value.absent(),
    this.deletedBy = const Value.absent(),
  })  : accountName = Value(accountName),
        roleId = Value(roleId),
        hostCode = Value(hostCode),
        createdAt = Value(createdAt),
        createdBy = Value(createdBy),
        updatedAt = Value(updatedAt),
        updatedBy = Value(updatedBy);
  static Insertable<Account> custom({
    Expression<int>? id,
    Expression<String>? accountName,
    Expression<String>? profileImage,
    Expression<String>? bio,
    Expression<int>? roleId,
    Expression<String>? hostCode,
    Expression<DateTime>? createdAt,
    Expression<int>? createdBy,
    Expression<DateTime>? updatedAt,
    Expression<int>? updatedBy,
    Expression<DateTime>? deletedAt,
    Expression<int>? deletedBy,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountName != null) 'account_name': accountName,
      if (profileImage != null) 'profile_image': profileImage,
      if (bio != null) 'bio': bio,
      if (roleId != null) 'role_id': roleId,
      if (hostCode != null) 'host_code': hostCode,
      if (createdAt != null) 'created_at': createdAt,
      if (createdBy != null) 'created_by': createdBy,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deletedBy != null) 'deleted_by': deletedBy,
    });
  }

  AccountsCompanion copyWith(
      {Value<int>? id,
      Value<String>? accountName,
      Value<String?>? profileImage,
      Value<String?>? bio,
      Value<int>? roleId,
      Value<String>? hostCode,
      Value<DateTime>? createdAt,
      Value<int>? createdBy,
      Value<DateTime>? updatedAt,
      Value<int>? updatedBy,
      Value<DateTime?>? deletedAt,
      Value<int?>? deletedBy}) {
    return AccountsCompanion(
      id: id ?? this.id,
      accountName: accountName ?? this.accountName,
      profileImage: profileImage ?? this.profileImage,
      bio: bio ?? this.bio,
      roleId: roleId ?? this.roleId,
      hostCode: hostCode ?? this.hostCode,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      deletedAt: deletedAt ?? this.deletedAt,
      deletedBy: deletedBy ?? this.deletedBy,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (accountName.present) {
      map['account_name'] = Variable<String>(accountName.value);
    }
    if (profileImage.present) {
      map['profile_image'] = Variable<String>(profileImage.value);
    }
    if (bio.present) {
      map['bio'] = Variable<String>(bio.value);
    }
    if (roleId.present) {
      map['role_id'] = Variable<int>(roleId.value);
    }
    if (hostCode.present) {
      map['host_code'] = Variable<String>(hostCode.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<int>(createdBy.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<int>(updatedBy.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (deletedBy.present) {
      map['deleted_by'] = Variable<int>(deletedBy.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountsCompanion(')
          ..write('id: $id, ')
          ..write('accountName: $accountName, ')
          ..write('profileImage: $profileImage, ')
          ..write('bio: $bio, ')
          ..write('roleId: $roleId, ')
          ..write('hostCode: $hostCode, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deletedBy: $deletedBy')
          ..write(')'))
        .toString();
  }
}

class Comments extends Table with TableInfo<Comments, Comment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Comments(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _recipeIdMeta =
      const VerificationMeta('recipeId');
  late final GeneratedColumn<int> recipeId = GeneratedColumn<int>(
      'recipe_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _accountIdMeta =
      const VerificationMeta('accountId');
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
      'account_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _messageMeta =
      const VerificationMeta('message');
  late final GeneratedColumn<String> message = GeneratedColumn<String>(
      'message', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _createdByMeta =
      const VerificationMeta('createdBy');
  late final GeneratedColumn<int> createdBy = GeneratedColumn<int>(
      'created_by', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _updatedByMeta =
      const VerificationMeta('updatedBy');
  late final GeneratedColumn<int> updatedBy = GeneratedColumn<int>(
      'updated_by', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  static const VerificationMeta _deletedByMeta =
      const VerificationMeta('deletedBy');
  late final GeneratedColumn<int> deletedBy = GeneratedColumn<int>(
      'deleted_by', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  @override
  List<GeneratedColumn> get $columns => [
        id,
        recipeId,
        accountId,
        message,
        createdAt,
        createdBy,
        updatedAt,
        updatedBy,
        deletedAt,
        deletedBy
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'comments';
  @override
  VerificationContext validateIntegrity(Insertable<Comment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('recipe_id')) {
      context.handle(_recipeIdMeta,
          recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta));
    } else if (isInserting) {
      context.missing(_recipeIdMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta,
          accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('message')) {
      context.handle(_messageMeta,
          message.isAcceptableOrUnknown(data['message']!, _messageMeta));
    } else if (isInserting) {
      context.missing(_messageMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('updated_by')) {
      context.handle(_updatedByMeta,
          updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta));
    } else if (isInserting) {
      context.missing(_updatedByMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('deleted_by')) {
      context.handle(_deletedByMeta,
          deletedBy.isAcceptableOrUnknown(data['deleted_by']!, _deletedByMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Comment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Comment(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      recipeId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}recipe_id'])!,
      accountId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}account_id'])!,
      message: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}message'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      createdBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_by'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      updatedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_by'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
      deletedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}deleted_by']),
    );
  }

  @override
  Comments createAlias(String alias) {
    return Comments(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
        'CONSTRAINT comment_pkey PRIMARY KEY(id)',
        'CONSTRAINT comment_recipe_id_fkey FOREIGN KEY(recipe_id)REFERENCES recipes(id)ON DELETE CASCADE',
        'CONSTRAINT comment_account_id_fkey FOREIGN KEY(account_id)REFERENCES accounts(id)'
      ];
  @override
  bool get dontWriteConstraints => true;
}

class Comment extends DataClass implements Insertable<Comment> {
  final int id;
  final int recipeId;
  final int accountId;
  final String message;
  final DateTime createdAt;
  final int createdBy;
  final DateTime updatedAt;
  final int updatedBy;
  final DateTime? deletedAt;
  final int? deletedBy;
  const Comment(
      {required this.id,
      required this.recipeId,
      required this.accountId,
      required this.message,
      required this.createdAt,
      required this.createdBy,
      required this.updatedAt,
      required this.updatedBy,
      this.deletedAt,
      this.deletedBy});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['recipe_id'] = Variable<int>(recipeId);
    map['account_id'] = Variable<int>(accountId);
    map['message'] = Variable<String>(message);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['created_by'] = Variable<int>(createdBy);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['updated_by'] = Variable<int>(updatedBy);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || deletedBy != null) {
      map['deleted_by'] = Variable<int>(deletedBy);
    }
    return map;
  }

  CommentsCompanion toCompanion(bool nullToAbsent) {
    return CommentsCompanion(
      id: Value(id),
      recipeId: Value(recipeId),
      accountId: Value(accountId),
      message: Value(message),
      createdAt: Value(createdAt),
      createdBy: Value(createdBy),
      updatedAt: Value(updatedAt),
      updatedBy: Value(updatedBy),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deletedBy: deletedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedBy),
    );
  }

  factory Comment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Comment(
      id: serializer.fromJson<int>(json['id']),
      recipeId: serializer.fromJson<int>(json['recipe_id']),
      accountId: serializer.fromJson<int>(json['account_id']),
      message: serializer.fromJson<String>(json['message']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      createdBy: serializer.fromJson<int>(json['created_by']),
      updatedAt: serializer.fromJson<DateTime>(json['updated_at']),
      updatedBy: serializer.fromJson<int>(json['updated_by']),
      deletedAt: serializer.fromJson<DateTime?>(json['deleted_at']),
      deletedBy: serializer.fromJson<int?>(json['deleted_by']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'recipe_id': serializer.toJson<int>(recipeId),
      'account_id': serializer.toJson<int>(accountId),
      'message': serializer.toJson<String>(message),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'created_by': serializer.toJson<int>(createdBy),
      'updated_at': serializer.toJson<DateTime>(updatedAt),
      'updated_by': serializer.toJson<int>(updatedBy),
      'deleted_at': serializer.toJson<DateTime?>(deletedAt),
      'deleted_by': serializer.toJson<int?>(deletedBy),
    };
  }

  Comment copyWith(
          {int? id,
          int? recipeId,
          int? accountId,
          String? message,
          DateTime? createdAt,
          int? createdBy,
          DateTime? updatedAt,
          int? updatedBy,
          Value<DateTime?> deletedAt = const Value.absent(),
          Value<int?> deletedBy = const Value.absent()}) =>
      Comment(
        id: id ?? this.id,
        recipeId: recipeId ?? this.recipeId,
        accountId: accountId ?? this.accountId,
        message: message ?? this.message,
        createdAt: createdAt ?? this.createdAt,
        createdBy: createdBy ?? this.createdBy,
        updatedAt: updatedAt ?? this.updatedAt,
        updatedBy: updatedBy ?? this.updatedBy,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        deletedBy: deletedBy.present ? deletedBy.value : this.deletedBy,
      );
  Comment copyWithCompanion(CommentsCompanion data) {
    return Comment(
      id: data.id.present ? data.id.value : this.id,
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      message: data.message.present ? data.message.value : this.message,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deletedBy: data.deletedBy.present ? data.deletedBy.value : this.deletedBy,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Comment(')
          ..write('id: $id, ')
          ..write('recipeId: $recipeId, ')
          ..write('accountId: $accountId, ')
          ..write('message: $message, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deletedBy: $deletedBy')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, recipeId, accountId, message, createdAt,
      createdBy, updatedAt, updatedBy, deletedAt, deletedBy);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Comment &&
          other.id == this.id &&
          other.recipeId == this.recipeId &&
          other.accountId == this.accountId &&
          other.message == this.message &&
          other.createdAt == this.createdAt &&
          other.createdBy == this.createdBy &&
          other.updatedAt == this.updatedAt &&
          other.updatedBy == this.updatedBy &&
          other.deletedAt == this.deletedAt &&
          other.deletedBy == this.deletedBy);
}

class CommentsCompanion extends UpdateCompanion<Comment> {
  final Value<int> id;
  final Value<int> recipeId;
  final Value<int> accountId;
  final Value<String> message;
  final Value<DateTime> createdAt;
  final Value<int> createdBy;
  final Value<DateTime> updatedAt;
  final Value<int> updatedBy;
  final Value<DateTime?> deletedAt;
  final Value<int?> deletedBy;
  const CommentsCompanion({
    this.id = const Value.absent(),
    this.recipeId = const Value.absent(),
    this.accountId = const Value.absent(),
    this.message = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deletedBy = const Value.absent(),
  });
  CommentsCompanion.insert({
    this.id = const Value.absent(),
    required int recipeId,
    required int accountId,
    required String message,
    required DateTime createdAt,
    required int createdBy,
    required DateTime updatedAt,
    required int updatedBy,
    this.deletedAt = const Value.absent(),
    this.deletedBy = const Value.absent(),
  })  : recipeId = Value(recipeId),
        accountId = Value(accountId),
        message = Value(message),
        createdAt = Value(createdAt),
        createdBy = Value(createdBy),
        updatedAt = Value(updatedAt),
        updatedBy = Value(updatedBy);
  static Insertable<Comment> custom({
    Expression<int>? id,
    Expression<int>? recipeId,
    Expression<int>? accountId,
    Expression<String>? message,
    Expression<DateTime>? createdAt,
    Expression<int>? createdBy,
    Expression<DateTime>? updatedAt,
    Expression<int>? updatedBy,
    Expression<DateTime>? deletedAt,
    Expression<int>? deletedBy,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recipeId != null) 'recipe_id': recipeId,
      if (accountId != null) 'account_id': accountId,
      if (message != null) 'message': message,
      if (createdAt != null) 'created_at': createdAt,
      if (createdBy != null) 'created_by': createdBy,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deletedBy != null) 'deleted_by': deletedBy,
    });
  }

  CommentsCompanion copyWith(
      {Value<int>? id,
      Value<int>? recipeId,
      Value<int>? accountId,
      Value<String>? message,
      Value<DateTime>? createdAt,
      Value<int>? createdBy,
      Value<DateTime>? updatedAt,
      Value<int>? updatedBy,
      Value<DateTime?>? deletedAt,
      Value<int?>? deletedBy}) {
    return CommentsCompanion(
      id: id ?? this.id,
      recipeId: recipeId ?? this.recipeId,
      accountId: accountId ?? this.accountId,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      deletedAt: deletedAt ?? this.deletedAt,
      deletedBy: deletedBy ?? this.deletedBy,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (recipeId.present) {
      map['recipe_id'] = Variable<int>(recipeId.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<int>(createdBy.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<int>(updatedBy.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (deletedBy.present) {
      map['deleted_by'] = Variable<int>(deletedBy.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CommentsCompanion(')
          ..write('id: $id, ')
          ..write('recipeId: $recipeId, ')
          ..write('accountId: $accountId, ')
          ..write('message: $message, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deletedBy: $deletedBy')
          ..write(')'))
        .toString();
  }
}

class Histories extends Table with TableInfo<Histories, History> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Histories(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _accountIdMeta =
      const VerificationMeta('accountId');
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
      'account_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _recipeIdMeta =
      const VerificationMeta('recipeId');
  late final GeneratedColumn<int> recipeId = GeneratedColumn<int>(
      'recipe_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _createdByMeta =
      const VerificationMeta('createdBy');
  late final GeneratedColumn<int> createdBy = GeneratedColumn<int>(
      'created_by', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _updatedByMeta =
      const VerificationMeta('updatedBy');
  late final GeneratedColumn<int> updatedBy = GeneratedColumn<int>(
      'updated_by', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  static const VerificationMeta _deletedByMeta =
      const VerificationMeta('deletedBy');
  late final GeneratedColumn<int> deletedBy = GeneratedColumn<int>(
      'deleted_by', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  static const VerificationMeta _stepNrMeta = const VerificationMeta('stepNr');
  late final GeneratedColumn<int> stepNr = GeneratedColumn<int>(
      'step_nr', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  static const VerificationMeta _openMeta = const VerificationMeta('open');
  late final GeneratedColumn<bool> open = GeneratedColumn<bool>(
      'open', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _additionalDataMeta =
      const VerificationMeta('additionalData');
  late final GeneratedColumn<String> additionalData = GeneratedColumn<String>(
      'additional_data', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  @override
  List<GeneratedColumn> get $columns => [
        accountId,
        recipeId,
        createdAt,
        createdBy,
        updatedAt,
        updatedBy,
        deletedAt,
        deletedBy,
        stepNr,
        open,
        additionalData
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'histories';
  @override
  VerificationContext validateIntegrity(Insertable<History> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta,
          accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('recipe_id')) {
      context.handle(_recipeIdMeta,
          recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta));
    } else if (isInserting) {
      context.missing(_recipeIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('updated_by')) {
      context.handle(_updatedByMeta,
          updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta));
    } else if (isInserting) {
      context.missing(_updatedByMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('deleted_by')) {
      context.handle(_deletedByMeta,
          deletedBy.isAcceptableOrUnknown(data['deleted_by']!, _deletedByMeta));
    }
    if (data.containsKey('step_nr')) {
      context.handle(_stepNrMeta,
          stepNr.isAcceptableOrUnknown(data['step_nr']!, _stepNrMeta));
    }
    if (data.containsKey('open')) {
      context.handle(
          _openMeta, open.isAcceptableOrUnknown(data['open']!, _openMeta));
    } else if (isInserting) {
      context.missing(_openMeta);
    }
    if (data.containsKey('additional_data')) {
      context.handle(
          _additionalDataMeta,
          additionalData.isAcceptableOrUnknown(
              data['additional_data']!, _additionalDataMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {accountId, recipeId};
  @override
  History map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return History(
      accountId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}account_id'])!,
      recipeId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}recipe_id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      createdBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_by'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      updatedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_by'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
      deletedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}deleted_by']),
      stepNr: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}step_nr']),
      open: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}open'])!,
      additionalData: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}additional_data']),
    );
  }

  @override
  Histories createAlias(String alias) {
    return Histories(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
        'CONSTRAINT history_pkey PRIMARY KEY(account_id, recipe_id)',
        'CONSTRAINT history_recipe_id_fkey FOREIGN KEY(recipe_id)REFERENCES recipes(id)ON DELETE CASCADE',
        'CONSTRAINT history_account_id_fkey FOREIGN KEY(account_id)REFERENCES accounts(id)ON DELETE CASCADE'
      ];
  @override
  bool get dontWriteConstraints => true;
}

class History extends DataClass implements Insertable<History> {
  final int accountId;
  final int recipeId;
  final DateTime createdAt;
  final int createdBy;
  final DateTime updatedAt;
  final int updatedBy;
  final DateTime? deletedAt;
  final int? deletedBy;
  final int? stepNr;
  final bool open;
  final String? additionalData;
  const History(
      {required this.accountId,
      required this.recipeId,
      required this.createdAt,
      required this.createdBy,
      required this.updatedAt,
      required this.updatedBy,
      this.deletedAt,
      this.deletedBy,
      this.stepNr,
      required this.open,
      this.additionalData});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['account_id'] = Variable<int>(accountId);
    map['recipe_id'] = Variable<int>(recipeId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['created_by'] = Variable<int>(createdBy);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['updated_by'] = Variable<int>(updatedBy);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || deletedBy != null) {
      map['deleted_by'] = Variable<int>(deletedBy);
    }
    if (!nullToAbsent || stepNr != null) {
      map['step_nr'] = Variable<int>(stepNr);
    }
    map['open'] = Variable<bool>(open);
    if (!nullToAbsent || additionalData != null) {
      map['additional_data'] = Variable<String>(additionalData);
    }
    return map;
  }

  HistoriesCompanion toCompanion(bool nullToAbsent) {
    return HistoriesCompanion(
      accountId: Value(accountId),
      recipeId: Value(recipeId),
      createdAt: Value(createdAt),
      createdBy: Value(createdBy),
      updatedAt: Value(updatedAt),
      updatedBy: Value(updatedBy),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deletedBy: deletedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedBy),
      stepNr:
          stepNr == null && nullToAbsent ? const Value.absent() : Value(stepNr),
      open: Value(open),
      additionalData: additionalData == null && nullToAbsent
          ? const Value.absent()
          : Value(additionalData),
    );
  }

  factory History.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return History(
      accountId: serializer.fromJson<int>(json['account_id']),
      recipeId: serializer.fromJson<int>(json['recipe_id']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      createdBy: serializer.fromJson<int>(json['created_by']),
      updatedAt: serializer.fromJson<DateTime>(json['updated_at']),
      updatedBy: serializer.fromJson<int>(json['updated_by']),
      deletedAt: serializer.fromJson<DateTime?>(json['deleted_at']),
      deletedBy: serializer.fromJson<int?>(json['deleted_by']),
      stepNr: serializer.fromJson<int?>(json['step_nr']),
      open: serializer.fromJson<bool>(json['open']),
      additionalData: serializer.fromJson<String?>(json['additional_data']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'account_id': serializer.toJson<int>(accountId),
      'recipe_id': serializer.toJson<int>(recipeId),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'created_by': serializer.toJson<int>(createdBy),
      'updated_at': serializer.toJson<DateTime>(updatedAt),
      'updated_by': serializer.toJson<int>(updatedBy),
      'deleted_at': serializer.toJson<DateTime?>(deletedAt),
      'deleted_by': serializer.toJson<int?>(deletedBy),
      'step_nr': serializer.toJson<int?>(stepNr),
      'open': serializer.toJson<bool>(open),
      'additional_data': serializer.toJson<String?>(additionalData),
    };
  }

  History copyWith(
          {int? accountId,
          int? recipeId,
          DateTime? createdAt,
          int? createdBy,
          DateTime? updatedAt,
          int? updatedBy,
          Value<DateTime?> deletedAt = const Value.absent(),
          Value<int?> deletedBy = const Value.absent(),
          Value<int?> stepNr = const Value.absent(),
          bool? open,
          Value<String?> additionalData = const Value.absent()}) =>
      History(
        accountId: accountId ?? this.accountId,
        recipeId: recipeId ?? this.recipeId,
        createdAt: createdAt ?? this.createdAt,
        createdBy: createdBy ?? this.createdBy,
        updatedAt: updatedAt ?? this.updatedAt,
        updatedBy: updatedBy ?? this.updatedBy,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        deletedBy: deletedBy.present ? deletedBy.value : this.deletedBy,
        stepNr: stepNr.present ? stepNr.value : this.stepNr,
        open: open ?? this.open,
        additionalData:
            additionalData.present ? additionalData.value : this.additionalData,
      );
  History copyWithCompanion(HistoriesCompanion data) {
    return History(
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deletedBy: data.deletedBy.present ? data.deletedBy.value : this.deletedBy,
      stepNr: data.stepNr.present ? data.stepNr.value : this.stepNr,
      open: data.open.present ? data.open.value : this.open,
      additionalData: data.additionalData.present
          ? data.additionalData.value
          : this.additionalData,
    );
  }

  @override
  String toString() {
    return (StringBuffer('History(')
          ..write('accountId: $accountId, ')
          ..write('recipeId: $recipeId, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deletedBy: $deletedBy, ')
          ..write('stepNr: $stepNr, ')
          ..write('open: $open, ')
          ..write('additionalData: $additionalData')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(accountId, recipeId, createdAt, createdBy,
      updatedAt, updatedBy, deletedAt, deletedBy, stepNr, open, additionalData);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is History &&
          other.accountId == this.accountId &&
          other.recipeId == this.recipeId &&
          other.createdAt == this.createdAt &&
          other.createdBy == this.createdBy &&
          other.updatedAt == this.updatedAt &&
          other.updatedBy == this.updatedBy &&
          other.deletedAt == this.deletedAt &&
          other.deletedBy == this.deletedBy &&
          other.stepNr == this.stepNr &&
          other.open == this.open &&
          other.additionalData == this.additionalData);
}

class HistoriesCompanion extends UpdateCompanion<History> {
  final Value<int> accountId;
  final Value<int> recipeId;
  final Value<DateTime> createdAt;
  final Value<int> createdBy;
  final Value<DateTime> updatedAt;
  final Value<int> updatedBy;
  final Value<DateTime?> deletedAt;
  final Value<int?> deletedBy;
  final Value<int?> stepNr;
  final Value<bool> open;
  final Value<String?> additionalData;
  final Value<int> rowid;
  const HistoriesCompanion({
    this.accountId = const Value.absent(),
    this.recipeId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deletedBy = const Value.absent(),
    this.stepNr = const Value.absent(),
    this.open = const Value.absent(),
    this.additionalData = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HistoriesCompanion.insert({
    required int accountId,
    required int recipeId,
    required DateTime createdAt,
    required int createdBy,
    required DateTime updatedAt,
    required int updatedBy,
    this.deletedAt = const Value.absent(),
    this.deletedBy = const Value.absent(),
    this.stepNr = const Value.absent(),
    required bool open,
    this.additionalData = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : accountId = Value(accountId),
        recipeId = Value(recipeId),
        createdAt = Value(createdAt),
        createdBy = Value(createdBy),
        updatedAt = Value(updatedAt),
        updatedBy = Value(updatedBy),
        open = Value(open);
  static Insertable<History> custom({
    Expression<int>? accountId,
    Expression<int>? recipeId,
    Expression<DateTime>? createdAt,
    Expression<int>? createdBy,
    Expression<DateTime>? updatedAt,
    Expression<int>? updatedBy,
    Expression<DateTime>? deletedAt,
    Expression<int>? deletedBy,
    Expression<int>? stepNr,
    Expression<bool>? open,
    Expression<String>? additionalData,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (accountId != null) 'account_id': accountId,
      if (recipeId != null) 'recipe_id': recipeId,
      if (createdAt != null) 'created_at': createdAt,
      if (createdBy != null) 'created_by': createdBy,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deletedBy != null) 'deleted_by': deletedBy,
      if (stepNr != null) 'step_nr': stepNr,
      if (open != null) 'open': open,
      if (additionalData != null) 'additional_data': additionalData,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HistoriesCompanion copyWith(
      {Value<int>? accountId,
      Value<int>? recipeId,
      Value<DateTime>? createdAt,
      Value<int>? createdBy,
      Value<DateTime>? updatedAt,
      Value<int>? updatedBy,
      Value<DateTime?>? deletedAt,
      Value<int?>? deletedBy,
      Value<int?>? stepNr,
      Value<bool>? open,
      Value<String?>? additionalData,
      Value<int>? rowid}) {
    return HistoriesCompanion(
      accountId: accountId ?? this.accountId,
      recipeId: recipeId ?? this.recipeId,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      deletedAt: deletedAt ?? this.deletedAt,
      deletedBy: deletedBy ?? this.deletedBy,
      stepNr: stepNr ?? this.stepNr,
      open: open ?? this.open,
      additionalData: additionalData ?? this.additionalData,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (recipeId.present) {
      map['recipe_id'] = Variable<int>(recipeId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<int>(createdBy.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<int>(updatedBy.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (deletedBy.present) {
      map['deleted_by'] = Variable<int>(deletedBy.value);
    }
    if (stepNr.present) {
      map['step_nr'] = Variable<int>(stepNr.value);
    }
    if (open.present) {
      map['open'] = Variable<bool>(open.value);
    }
    if (additionalData.present) {
      map['additional_data'] = Variable<String>(additionalData.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HistoriesCompanion(')
          ..write('accountId: $accountId, ')
          ..write('recipeId: $recipeId, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deletedBy: $deletedBy, ')
          ..write('stepNr: $stepNr, ')
          ..write('open: $open, ')
          ..write('additionalData: $additionalData, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Profiles extends Table with TableInfo<Profiles, Profile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Profiles(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _accountIdMeta =
      const VerificationMeta('accountId');
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
      'account_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _roleIdMeta = const VerificationMeta('roleId');
  late final GeneratedColumn<int> roleId = GeneratedColumn<int>(
      'role_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _createdByMeta =
      const VerificationMeta('createdBy');
  late final GeneratedColumn<int> createdBy = GeneratedColumn<int>(
      'created_by', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _updatedByMeta =
      const VerificationMeta('updatedBy');
  late final GeneratedColumn<int> updatedBy = GeneratedColumn<int>(
      'updated_by', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  static const VerificationMeta _deletedByMeta =
      const VerificationMeta('deletedBy');
  late final GeneratedColumn<int> deletedBy = GeneratedColumn<int>(
      'deleted_by', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  @override
  List<GeneratedColumn> get $columns => [
        id,
        accountId,
        name,
        roleId,
        createdAt,
        createdBy,
        updatedAt,
        updatedBy,
        deletedAt,
        deletedBy
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'profiles';
  @override
  VerificationContext validateIntegrity(Insertable<Profile> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta,
          accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('role_id')) {
      context.handle(_roleIdMeta,
          roleId.isAcceptableOrUnknown(data['role_id']!, _roleIdMeta));
    } else if (isInserting) {
      context.missing(_roleIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('updated_by')) {
      context.handle(_updatedByMeta,
          updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta));
    } else if (isInserting) {
      context.missing(_updatedByMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('deleted_by')) {
      context.handle(_deletedByMeta,
          deletedBy.isAcceptableOrUnknown(data['deleted_by']!, _deletedByMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Profile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Profile(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      accountId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}account_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      roleId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}role_id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      createdBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_by'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      updatedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_by'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
      deletedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}deleted_by']),
    );
  }

  @override
  Profiles createAlias(String alias) {
    return Profiles(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
        'CONSTRAINT profile_pkey PRIMARY KEY(id)',
        'CONSTRAINT profile_account_id_fkey FOREIGN KEY(account_id)REFERENCES accounts(id)ON DELETE CASCADE',
        'CONSTRAINT profile_role_id_fkey FOREIGN KEY(role_id)REFERENCES roles(id)'
      ];
  @override
  bool get dontWriteConstraints => true;
}

class Profile extends DataClass implements Insertable<Profile> {
  final int id;
  final int accountId;
  final String name;
  final int roleId;
  final DateTime createdAt;
  final int createdBy;
  final DateTime updatedAt;
  final int updatedBy;
  final DateTime? deletedAt;
  final int? deletedBy;
  const Profile(
      {required this.id,
      required this.accountId,
      required this.name,
      required this.roleId,
      required this.createdAt,
      required this.createdBy,
      required this.updatedAt,
      required this.updatedBy,
      this.deletedAt,
      this.deletedBy});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['account_id'] = Variable<int>(accountId);
    map['name'] = Variable<String>(name);
    map['role_id'] = Variable<int>(roleId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['created_by'] = Variable<int>(createdBy);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['updated_by'] = Variable<int>(updatedBy);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || deletedBy != null) {
      map['deleted_by'] = Variable<int>(deletedBy);
    }
    return map;
  }

  ProfilesCompanion toCompanion(bool nullToAbsent) {
    return ProfilesCompanion(
      id: Value(id),
      accountId: Value(accountId),
      name: Value(name),
      roleId: Value(roleId),
      createdAt: Value(createdAt),
      createdBy: Value(createdBy),
      updatedAt: Value(updatedAt),
      updatedBy: Value(updatedBy),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deletedBy: deletedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedBy),
    );
  }

  factory Profile.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Profile(
      id: serializer.fromJson<int>(json['id']),
      accountId: serializer.fromJson<int>(json['account_id']),
      name: serializer.fromJson<String>(json['name']),
      roleId: serializer.fromJson<int>(json['role_id']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      createdBy: serializer.fromJson<int>(json['created_by']),
      updatedAt: serializer.fromJson<DateTime>(json['updated_at']),
      updatedBy: serializer.fromJson<int>(json['updated_by']),
      deletedAt: serializer.fromJson<DateTime?>(json['deleted_at']),
      deletedBy: serializer.fromJson<int?>(json['deleted_by']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'account_id': serializer.toJson<int>(accountId),
      'name': serializer.toJson<String>(name),
      'role_id': serializer.toJson<int>(roleId),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'created_by': serializer.toJson<int>(createdBy),
      'updated_at': serializer.toJson<DateTime>(updatedAt),
      'updated_by': serializer.toJson<int>(updatedBy),
      'deleted_at': serializer.toJson<DateTime?>(deletedAt),
      'deleted_by': serializer.toJson<int?>(deletedBy),
    };
  }

  Profile copyWith(
          {int? id,
          int? accountId,
          String? name,
          int? roleId,
          DateTime? createdAt,
          int? createdBy,
          DateTime? updatedAt,
          int? updatedBy,
          Value<DateTime?> deletedAt = const Value.absent(),
          Value<int?> deletedBy = const Value.absent()}) =>
      Profile(
        id: id ?? this.id,
        accountId: accountId ?? this.accountId,
        name: name ?? this.name,
        roleId: roleId ?? this.roleId,
        createdAt: createdAt ?? this.createdAt,
        createdBy: createdBy ?? this.createdBy,
        updatedAt: updatedAt ?? this.updatedAt,
        updatedBy: updatedBy ?? this.updatedBy,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        deletedBy: deletedBy.present ? deletedBy.value : this.deletedBy,
      );
  Profile copyWithCompanion(ProfilesCompanion data) {
    return Profile(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      name: data.name.present ? data.name.value : this.name,
      roleId: data.roleId.present ? data.roleId.value : this.roleId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deletedBy: data.deletedBy.present ? data.deletedBy.value : this.deletedBy,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Profile(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('name: $name, ')
          ..write('roleId: $roleId, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deletedBy: $deletedBy')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, accountId, name, roleId, createdAt,
      createdBy, updatedAt, updatedBy, deletedAt, deletedBy);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Profile &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.name == this.name &&
          other.roleId == this.roleId &&
          other.createdAt == this.createdAt &&
          other.createdBy == this.createdBy &&
          other.updatedAt == this.updatedAt &&
          other.updatedBy == this.updatedBy &&
          other.deletedAt == this.deletedAt &&
          other.deletedBy == this.deletedBy);
}

class ProfilesCompanion extends UpdateCompanion<Profile> {
  final Value<int> id;
  final Value<int> accountId;
  final Value<String> name;
  final Value<int> roleId;
  final Value<DateTime> createdAt;
  final Value<int> createdBy;
  final Value<DateTime> updatedAt;
  final Value<int> updatedBy;
  final Value<DateTime?> deletedAt;
  final Value<int?> deletedBy;
  const ProfilesCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.name = const Value.absent(),
    this.roleId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deletedBy = const Value.absent(),
  });
  ProfilesCompanion.insert({
    this.id = const Value.absent(),
    required int accountId,
    required String name,
    required int roleId,
    required DateTime createdAt,
    required int createdBy,
    required DateTime updatedAt,
    required int updatedBy,
    this.deletedAt = const Value.absent(),
    this.deletedBy = const Value.absent(),
  })  : accountId = Value(accountId),
        name = Value(name),
        roleId = Value(roleId),
        createdAt = Value(createdAt),
        createdBy = Value(createdBy),
        updatedAt = Value(updatedAt),
        updatedBy = Value(updatedBy);
  static Insertable<Profile> custom({
    Expression<int>? id,
    Expression<int>? accountId,
    Expression<String>? name,
    Expression<int>? roleId,
    Expression<DateTime>? createdAt,
    Expression<int>? createdBy,
    Expression<DateTime>? updatedAt,
    Expression<int>? updatedBy,
    Expression<DateTime>? deletedAt,
    Expression<int>? deletedBy,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (name != null) 'name': name,
      if (roleId != null) 'role_id': roleId,
      if (createdAt != null) 'created_at': createdAt,
      if (createdBy != null) 'created_by': createdBy,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deletedBy != null) 'deleted_by': deletedBy,
    });
  }

  ProfilesCompanion copyWith(
      {Value<int>? id,
      Value<int>? accountId,
      Value<String>? name,
      Value<int>? roleId,
      Value<DateTime>? createdAt,
      Value<int>? createdBy,
      Value<DateTime>? updatedAt,
      Value<int>? updatedBy,
      Value<DateTime?>? deletedAt,
      Value<int?>? deletedBy}) {
    return ProfilesCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      name: name ?? this.name,
      roleId: roleId ?? this.roleId,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      deletedAt: deletedAt ?? this.deletedAt,
      deletedBy: deletedBy ?? this.deletedBy,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (roleId.present) {
      map['role_id'] = Variable<int>(roleId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<int>(createdBy.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<int>(updatedBy.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (deletedBy.present) {
      map['deleted_by'] = Variable<int>(deletedBy.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProfilesCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('name: $name, ')
          ..write('roleId: $roleId, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deletedBy: $deletedBy')
          ..write(')'))
        .toString();
  }
}

class AccountFollows extends Table
    with TableInfo<AccountFollows, AccountFollow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  AccountFollows(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _followerAccountIdMeta =
      const VerificationMeta('followerAccountId');
  late final GeneratedColumn<int> followerAccountId = GeneratedColumn<int>(
      'follower_account_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _followedAccountIdMeta =
      const VerificationMeta('followedAccountId');
  late final GeneratedColumn<int> followedAccountId = GeneratedColumn<int>(
      'followed_account_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _createdByMeta =
      const VerificationMeta('createdBy');
  late final GeneratedColumn<int> createdBy = GeneratedColumn<int>(
      'created_by', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _updatedByMeta =
      const VerificationMeta('updatedBy');
  late final GeneratedColumn<int> updatedBy = GeneratedColumn<int>(
      'updated_by', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  static const VerificationMeta _deletedByMeta =
      const VerificationMeta('deletedBy');
  late final GeneratedColumn<int> deletedBy = GeneratedColumn<int>(
      'deleted_by', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  @override
  List<GeneratedColumn> get $columns => [
        followerAccountId,
        followedAccountId,
        createdAt,
        createdBy,
        updatedAt,
        updatedBy,
        deletedAt,
        deletedBy
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'account_follows';
  @override
  VerificationContext validateIntegrity(Insertable<AccountFollow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('follower_account_id')) {
      context.handle(
          _followerAccountIdMeta,
          followerAccountId.isAcceptableOrUnknown(
              data['follower_account_id']!, _followerAccountIdMeta));
    } else if (isInserting) {
      context.missing(_followerAccountIdMeta);
    }
    if (data.containsKey('followed_account_id')) {
      context.handle(
          _followedAccountIdMeta,
          followedAccountId.isAcceptableOrUnknown(
              data['followed_account_id']!, _followedAccountIdMeta));
    } else if (isInserting) {
      context.missing(_followedAccountIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('updated_by')) {
      context.handle(_updatedByMeta,
          updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta));
    } else if (isInserting) {
      context.missing(_updatedByMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('deleted_by')) {
      context.handle(_deletedByMeta,
          deletedBy.isAcceptableOrUnknown(data['deleted_by']!, _deletedByMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey =>
      {followerAccountId, followedAccountId};
  @override
  AccountFollow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AccountFollow(
      followerAccountId: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}follower_account_id'])!,
      followedAccountId: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}followed_account_id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      createdBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_by'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      updatedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_by'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
      deletedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}deleted_by']),
    );
  }

  @override
  AccountFollows createAlias(String alias) {
    return AccountFollows(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
        'CONSTRAINT account_follow_pkey PRIMARY KEY(follower_account_id, followed_account_id)',
        'CONSTRAINT account_follow_follower_fkey FOREIGN KEY(follower_account_id)REFERENCES accounts(id)ON DELETE CASCADE',
        'CONSTRAINT account_follow_followed_fkey FOREIGN KEY(followed_account_id)REFERENCES accounts(id)ON DELETE CASCADE'
      ];
  @override
  bool get dontWriteConstraints => true;
}

class AccountFollow extends DataClass implements Insertable<AccountFollow> {
  final int followerAccountId;
  final int followedAccountId;
  final DateTime createdAt;
  final int createdBy;
  final DateTime updatedAt;
  final int updatedBy;
  final DateTime? deletedAt;
  final int? deletedBy;
  const AccountFollow(
      {required this.followerAccountId,
      required this.followedAccountId,
      required this.createdAt,
      required this.createdBy,
      required this.updatedAt,
      required this.updatedBy,
      this.deletedAt,
      this.deletedBy});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['follower_account_id'] = Variable<int>(followerAccountId);
    map['followed_account_id'] = Variable<int>(followedAccountId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['created_by'] = Variable<int>(createdBy);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['updated_by'] = Variable<int>(updatedBy);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || deletedBy != null) {
      map['deleted_by'] = Variable<int>(deletedBy);
    }
    return map;
  }

  AccountFollowsCompanion toCompanion(bool nullToAbsent) {
    return AccountFollowsCompanion(
      followerAccountId: Value(followerAccountId),
      followedAccountId: Value(followedAccountId),
      createdAt: Value(createdAt),
      createdBy: Value(createdBy),
      updatedAt: Value(updatedAt),
      updatedBy: Value(updatedBy),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deletedBy: deletedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedBy),
    );
  }

  factory AccountFollow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AccountFollow(
      followerAccountId: serializer.fromJson<int>(json['follower_account_id']),
      followedAccountId: serializer.fromJson<int>(json['followed_account_id']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      createdBy: serializer.fromJson<int>(json['created_by']),
      updatedAt: serializer.fromJson<DateTime>(json['updated_at']),
      updatedBy: serializer.fromJson<int>(json['updated_by']),
      deletedAt: serializer.fromJson<DateTime?>(json['deleted_at']),
      deletedBy: serializer.fromJson<int?>(json['deleted_by']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'follower_account_id': serializer.toJson<int>(followerAccountId),
      'followed_account_id': serializer.toJson<int>(followedAccountId),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'created_by': serializer.toJson<int>(createdBy),
      'updated_at': serializer.toJson<DateTime>(updatedAt),
      'updated_by': serializer.toJson<int>(updatedBy),
      'deleted_at': serializer.toJson<DateTime?>(deletedAt),
      'deleted_by': serializer.toJson<int?>(deletedBy),
    };
  }

  AccountFollow copyWith(
          {int? followerAccountId,
          int? followedAccountId,
          DateTime? createdAt,
          int? createdBy,
          DateTime? updatedAt,
          int? updatedBy,
          Value<DateTime?> deletedAt = const Value.absent(),
          Value<int?> deletedBy = const Value.absent()}) =>
      AccountFollow(
        followerAccountId: followerAccountId ?? this.followerAccountId,
        followedAccountId: followedAccountId ?? this.followedAccountId,
        createdAt: createdAt ?? this.createdAt,
        createdBy: createdBy ?? this.createdBy,
        updatedAt: updatedAt ?? this.updatedAt,
        updatedBy: updatedBy ?? this.updatedBy,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        deletedBy: deletedBy.present ? deletedBy.value : this.deletedBy,
      );
  AccountFollow copyWithCompanion(AccountFollowsCompanion data) {
    return AccountFollow(
      followerAccountId: data.followerAccountId.present
          ? data.followerAccountId.value
          : this.followerAccountId,
      followedAccountId: data.followedAccountId.present
          ? data.followedAccountId.value
          : this.followedAccountId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deletedBy: data.deletedBy.present ? data.deletedBy.value : this.deletedBy,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AccountFollow(')
          ..write('followerAccountId: $followerAccountId, ')
          ..write('followedAccountId: $followedAccountId, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deletedBy: $deletedBy')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(followerAccountId, followedAccountId,
      createdAt, createdBy, updatedAt, updatedBy, deletedAt, deletedBy);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AccountFollow &&
          other.followerAccountId == this.followerAccountId &&
          other.followedAccountId == this.followedAccountId &&
          other.createdAt == this.createdAt &&
          other.createdBy == this.createdBy &&
          other.updatedAt == this.updatedAt &&
          other.updatedBy == this.updatedBy &&
          other.deletedAt == this.deletedAt &&
          other.deletedBy == this.deletedBy);
}

class AccountFollowsCompanion extends UpdateCompanion<AccountFollow> {
  final Value<int> followerAccountId;
  final Value<int> followedAccountId;
  final Value<DateTime> createdAt;
  final Value<int> createdBy;
  final Value<DateTime> updatedAt;
  final Value<int> updatedBy;
  final Value<DateTime?> deletedAt;
  final Value<int?> deletedBy;
  final Value<int> rowid;
  const AccountFollowsCompanion({
    this.followerAccountId = const Value.absent(),
    this.followedAccountId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deletedBy = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AccountFollowsCompanion.insert({
    required int followerAccountId,
    required int followedAccountId,
    required DateTime createdAt,
    required int createdBy,
    required DateTime updatedAt,
    required int updatedBy,
    this.deletedAt = const Value.absent(),
    this.deletedBy = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : followerAccountId = Value(followerAccountId),
        followedAccountId = Value(followedAccountId),
        createdAt = Value(createdAt),
        createdBy = Value(createdBy),
        updatedAt = Value(updatedAt),
        updatedBy = Value(updatedBy);
  static Insertable<AccountFollow> custom({
    Expression<int>? followerAccountId,
    Expression<int>? followedAccountId,
    Expression<DateTime>? createdAt,
    Expression<int>? createdBy,
    Expression<DateTime>? updatedAt,
    Expression<int>? updatedBy,
    Expression<DateTime>? deletedAt,
    Expression<int>? deletedBy,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (followerAccountId != null) 'follower_account_id': followerAccountId,
      if (followedAccountId != null) 'followed_account_id': followedAccountId,
      if (createdAt != null) 'created_at': createdAt,
      if (createdBy != null) 'created_by': createdBy,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deletedBy != null) 'deleted_by': deletedBy,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AccountFollowsCompanion copyWith(
      {Value<int>? followerAccountId,
      Value<int>? followedAccountId,
      Value<DateTime>? createdAt,
      Value<int>? createdBy,
      Value<DateTime>? updatedAt,
      Value<int>? updatedBy,
      Value<DateTime?>? deletedAt,
      Value<int?>? deletedBy,
      Value<int>? rowid}) {
    return AccountFollowsCompanion(
      followerAccountId: followerAccountId ?? this.followerAccountId,
      followedAccountId: followedAccountId ?? this.followedAccountId,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      deletedAt: deletedAt ?? this.deletedAt,
      deletedBy: deletedBy ?? this.deletedBy,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (followerAccountId.present) {
      map['follower_account_id'] = Variable<int>(followerAccountId.value);
    }
    if (followedAccountId.present) {
      map['followed_account_id'] = Variable<int>(followedAccountId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<int>(createdBy.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<int>(updatedBy.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (deletedBy.present) {
      map['deleted_by'] = Variable<int>(deletedBy.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountFollowsCompanion(')
          ..write('followerAccountId: $followerAccountId, ')
          ..write('followedAccountId: $followedAccountId, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deletedBy: $deletedBy, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class AccountFriends extends Table
    with TableInfo<AccountFriends, AccountFriend> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  AccountFriends(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _firstAccountIdMeta =
      const VerificationMeta('firstAccountId');
  late final GeneratedColumn<int> firstAccountId = GeneratedColumn<int>(
      'first_account_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _secondAccountIdMeta =
      const VerificationMeta('secondAccountId');
  late final GeneratedColumn<int> secondAccountId = GeneratedColumn<int>(
      'second_account_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _requestedByMeta =
      const VerificationMeta('requestedBy');
  late final GeneratedColumn<int> requestedBy = GeneratedColumn<int>(
      'requested_by', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL DEFAULT \'pending\'',
      defaultValue: const CustomExpression('\'pending\''));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _createdByMeta =
      const VerificationMeta('createdBy');
  late final GeneratedColumn<int> createdBy = GeneratedColumn<int>(
      'created_by', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _updatedByMeta =
      const VerificationMeta('updatedBy');
  late final GeneratedColumn<int> updatedBy = GeneratedColumn<int>(
      'updated_by', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  static const VerificationMeta _deletedByMeta =
      const VerificationMeta('deletedBy');
  late final GeneratedColumn<int> deletedBy = GeneratedColumn<int>(
      'deleted_by', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  @override
  List<GeneratedColumn> get $columns => [
        firstAccountId,
        secondAccountId,
        requestedBy,
        status,
        createdAt,
        createdBy,
        updatedAt,
        updatedBy,
        deletedAt,
        deletedBy
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'account_friends';
  @override
  VerificationContext validateIntegrity(Insertable<AccountFriend> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('first_account_id')) {
      context.handle(
          _firstAccountIdMeta,
          firstAccountId.isAcceptableOrUnknown(
              data['first_account_id']!, _firstAccountIdMeta));
    } else if (isInserting) {
      context.missing(_firstAccountIdMeta);
    }
    if (data.containsKey('second_account_id')) {
      context.handle(
          _secondAccountIdMeta,
          secondAccountId.isAcceptableOrUnknown(
              data['second_account_id']!, _secondAccountIdMeta));
    } else if (isInserting) {
      context.missing(_secondAccountIdMeta);
    }
    if (data.containsKey('requested_by')) {
      context.handle(
          _requestedByMeta,
          requestedBy.isAcceptableOrUnknown(
              data['requested_by']!, _requestedByMeta));
    } else if (isInserting) {
      context.missing(_requestedByMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('updated_by')) {
      context.handle(_updatedByMeta,
          updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta));
    } else if (isInserting) {
      context.missing(_updatedByMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('deleted_by')) {
      context.handle(_deletedByMeta,
          deletedBy.isAcceptableOrUnknown(data['deleted_by']!, _deletedByMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {firstAccountId, secondAccountId};
  @override
  AccountFriend map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AccountFriend(
      firstAccountId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}first_account_id'])!,
      secondAccountId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}second_account_id'])!,
      requestedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}requested_by'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      createdBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_by'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      updatedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_by'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
      deletedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}deleted_by']),
    );
  }

  @override
  AccountFriends createAlias(String alias) {
    return AccountFriends(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
        'CONSTRAINT account_friend_pkey PRIMARY KEY(first_account_id, second_account_id)',
        'CONSTRAINT account_friend_first_fkey FOREIGN KEY(first_account_id)REFERENCES accounts(id)ON DELETE CASCADE',
        'CONSTRAINT account_friend_second_fkey FOREIGN KEY(second_account_id)REFERENCES accounts(id)ON DELETE CASCADE'
      ];
  @override
  bool get dontWriteConstraints => true;
}

class AccountFriend extends DataClass implements Insertable<AccountFriend> {
  final int firstAccountId;
  final int secondAccountId;
  final int requestedBy;
  final String status;
  final DateTime createdAt;
  final int createdBy;
  final DateTime updatedAt;
  final int updatedBy;
  final DateTime? deletedAt;
  final int? deletedBy;
  const AccountFriend(
      {required this.firstAccountId,
      required this.secondAccountId,
      required this.requestedBy,
      required this.status,
      required this.createdAt,
      required this.createdBy,
      required this.updatedAt,
      required this.updatedBy,
      this.deletedAt,
      this.deletedBy});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['first_account_id'] = Variable<int>(firstAccountId);
    map['second_account_id'] = Variable<int>(secondAccountId);
    map['requested_by'] = Variable<int>(requestedBy);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['created_by'] = Variable<int>(createdBy);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['updated_by'] = Variable<int>(updatedBy);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || deletedBy != null) {
      map['deleted_by'] = Variable<int>(deletedBy);
    }
    return map;
  }

  AccountFriendsCompanion toCompanion(bool nullToAbsent) {
    return AccountFriendsCompanion(
      firstAccountId: Value(firstAccountId),
      secondAccountId: Value(secondAccountId),
      requestedBy: Value(requestedBy),
      status: Value(status),
      createdAt: Value(createdAt),
      createdBy: Value(createdBy),
      updatedAt: Value(updatedAt),
      updatedBy: Value(updatedBy),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deletedBy: deletedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedBy),
    );
  }

  factory AccountFriend.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AccountFriend(
      firstAccountId: serializer.fromJson<int>(json['first_account_id']),
      secondAccountId: serializer.fromJson<int>(json['second_account_id']),
      requestedBy: serializer.fromJson<int>(json['requested_by']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      createdBy: serializer.fromJson<int>(json['created_by']),
      updatedAt: serializer.fromJson<DateTime>(json['updated_at']),
      updatedBy: serializer.fromJson<int>(json['updated_by']),
      deletedAt: serializer.fromJson<DateTime?>(json['deleted_at']),
      deletedBy: serializer.fromJson<int?>(json['deleted_by']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'first_account_id': serializer.toJson<int>(firstAccountId),
      'second_account_id': serializer.toJson<int>(secondAccountId),
      'requested_by': serializer.toJson<int>(requestedBy),
      'status': serializer.toJson<String>(status),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'created_by': serializer.toJson<int>(createdBy),
      'updated_at': serializer.toJson<DateTime>(updatedAt),
      'updated_by': serializer.toJson<int>(updatedBy),
      'deleted_at': serializer.toJson<DateTime?>(deletedAt),
      'deleted_by': serializer.toJson<int?>(deletedBy),
    };
  }

  AccountFriend copyWith(
          {int? firstAccountId,
          int? secondAccountId,
          int? requestedBy,
          String? status,
          DateTime? createdAt,
          int? createdBy,
          DateTime? updatedAt,
          int? updatedBy,
          Value<DateTime?> deletedAt = const Value.absent(),
          Value<int?> deletedBy = const Value.absent()}) =>
      AccountFriend(
        firstAccountId: firstAccountId ?? this.firstAccountId,
        secondAccountId: secondAccountId ?? this.secondAccountId,
        requestedBy: requestedBy ?? this.requestedBy,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        createdBy: createdBy ?? this.createdBy,
        updatedAt: updatedAt ?? this.updatedAt,
        updatedBy: updatedBy ?? this.updatedBy,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        deletedBy: deletedBy.present ? deletedBy.value : this.deletedBy,
      );
  AccountFriend copyWithCompanion(AccountFriendsCompanion data) {
    return AccountFriend(
      firstAccountId: data.firstAccountId.present
          ? data.firstAccountId.value
          : this.firstAccountId,
      secondAccountId: data.secondAccountId.present
          ? data.secondAccountId.value
          : this.secondAccountId,
      requestedBy:
          data.requestedBy.present ? data.requestedBy.value : this.requestedBy,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deletedBy: data.deletedBy.present ? data.deletedBy.value : this.deletedBy,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AccountFriend(')
          ..write('firstAccountId: $firstAccountId, ')
          ..write('secondAccountId: $secondAccountId, ')
          ..write('requestedBy: $requestedBy, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deletedBy: $deletedBy')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(firstAccountId, secondAccountId, requestedBy,
      status, createdAt, createdBy, updatedAt, updatedBy, deletedAt, deletedBy);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AccountFriend &&
          other.firstAccountId == this.firstAccountId &&
          other.secondAccountId == this.secondAccountId &&
          other.requestedBy == this.requestedBy &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.createdBy == this.createdBy &&
          other.updatedAt == this.updatedAt &&
          other.updatedBy == this.updatedBy &&
          other.deletedAt == this.deletedAt &&
          other.deletedBy == this.deletedBy);
}

class AccountFriendsCompanion extends UpdateCompanion<AccountFriend> {
  final Value<int> firstAccountId;
  final Value<int> secondAccountId;
  final Value<int> requestedBy;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<int> createdBy;
  final Value<DateTime> updatedAt;
  final Value<int> updatedBy;
  final Value<DateTime?> deletedAt;
  final Value<int?> deletedBy;
  final Value<int> rowid;
  const AccountFriendsCompanion({
    this.firstAccountId = const Value.absent(),
    this.secondAccountId = const Value.absent(),
    this.requestedBy = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deletedBy = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AccountFriendsCompanion.insert({
    required int firstAccountId,
    required int secondAccountId,
    required int requestedBy,
    this.status = const Value.absent(),
    required DateTime createdAt,
    required int createdBy,
    required DateTime updatedAt,
    required int updatedBy,
    this.deletedAt = const Value.absent(),
    this.deletedBy = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : firstAccountId = Value(firstAccountId),
        secondAccountId = Value(secondAccountId),
        requestedBy = Value(requestedBy),
        createdAt = Value(createdAt),
        createdBy = Value(createdBy),
        updatedAt = Value(updatedAt),
        updatedBy = Value(updatedBy);
  static Insertable<AccountFriend> custom({
    Expression<int>? firstAccountId,
    Expression<int>? secondAccountId,
    Expression<int>? requestedBy,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<int>? createdBy,
    Expression<DateTime>? updatedAt,
    Expression<int>? updatedBy,
    Expression<DateTime>? deletedAt,
    Expression<int>? deletedBy,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (firstAccountId != null) 'first_account_id': firstAccountId,
      if (secondAccountId != null) 'second_account_id': secondAccountId,
      if (requestedBy != null) 'requested_by': requestedBy,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (createdBy != null) 'created_by': createdBy,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deletedBy != null) 'deleted_by': deletedBy,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AccountFriendsCompanion copyWith(
      {Value<int>? firstAccountId,
      Value<int>? secondAccountId,
      Value<int>? requestedBy,
      Value<String>? status,
      Value<DateTime>? createdAt,
      Value<int>? createdBy,
      Value<DateTime>? updatedAt,
      Value<int>? updatedBy,
      Value<DateTime?>? deletedAt,
      Value<int?>? deletedBy,
      Value<int>? rowid}) {
    return AccountFriendsCompanion(
      firstAccountId: firstAccountId ?? this.firstAccountId,
      secondAccountId: secondAccountId ?? this.secondAccountId,
      requestedBy: requestedBy ?? this.requestedBy,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      deletedAt: deletedAt ?? this.deletedAt,
      deletedBy: deletedBy ?? this.deletedBy,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (firstAccountId.present) {
      map['first_account_id'] = Variable<int>(firstAccountId.value);
    }
    if (secondAccountId.present) {
      map['second_account_id'] = Variable<int>(secondAccountId.value);
    }
    if (requestedBy.present) {
      map['requested_by'] = Variable<int>(requestedBy.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<int>(createdBy.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<int>(updatedBy.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (deletedBy.present) {
      map['deleted_by'] = Variable<int>(deletedBy.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountFriendsCompanion(')
          ..write('firstAccountId: $firstAccountId, ')
          ..write('secondAccountId: $secondAccountId, ')
          ..write('requestedBy: $requestedBy, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deletedBy: $deletedBy, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class ChatConversations extends Table
    with TableInfo<ChatConversations, ChatConversation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  ChatConversations(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _firstAccountIdMeta =
      const VerificationMeta('firstAccountId');
  late final GeneratedColumn<int> firstAccountId = GeneratedColumn<int>(
      'first_account_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _secondAccountIdMeta =
      const VerificationMeta('secondAccountId');
  late final GeneratedColumn<int> secondAccountId = GeneratedColumn<int>(
      'second_account_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _createdByMeta =
      const VerificationMeta('createdBy');
  late final GeneratedColumn<int> createdBy = GeneratedColumn<int>(
      'created_by', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _updatedByMeta =
      const VerificationMeta('updatedBy');
  late final GeneratedColumn<int> updatedBy = GeneratedColumn<int>(
      'updated_by', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  static const VerificationMeta _deletedByMeta =
      const VerificationMeta('deletedBy');
  late final GeneratedColumn<int> deletedBy = GeneratedColumn<int>(
      'deleted_by', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  @override
  List<GeneratedColumn> get $columns => [
        firstAccountId,
        secondAccountId,
        createdAt,
        createdBy,
        updatedAt,
        updatedBy,
        deletedAt,
        deletedBy
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chat_conversations';
  @override
  VerificationContext validateIntegrity(Insertable<ChatConversation> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('first_account_id')) {
      context.handle(
          _firstAccountIdMeta,
          firstAccountId.isAcceptableOrUnknown(
              data['first_account_id']!, _firstAccountIdMeta));
    } else if (isInserting) {
      context.missing(_firstAccountIdMeta);
    }
    if (data.containsKey('second_account_id')) {
      context.handle(
          _secondAccountIdMeta,
          secondAccountId.isAcceptableOrUnknown(
              data['second_account_id']!, _secondAccountIdMeta));
    } else if (isInserting) {
      context.missing(_secondAccountIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('updated_by')) {
      context.handle(_updatedByMeta,
          updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta));
    } else if (isInserting) {
      context.missing(_updatedByMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('deleted_by')) {
      context.handle(_deletedByMeta,
          deletedBy.isAcceptableOrUnknown(data['deleted_by']!, _deletedByMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {firstAccountId, secondAccountId};
  @override
  ChatConversation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChatConversation(
      firstAccountId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}first_account_id'])!,
      secondAccountId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}second_account_id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      createdBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_by'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      updatedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_by'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
      deletedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}deleted_by']),
    );
  }

  @override
  ChatConversations createAlias(String alias) {
    return ChatConversations(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
        'CONSTRAINT chat_conversation_pkey PRIMARY KEY(first_account_id, second_account_id)',
        'CONSTRAINT chat_conversation_first_fkey FOREIGN KEY(first_account_id)REFERENCES accounts(id)ON DELETE CASCADE',
        'CONSTRAINT chat_conversation_second_fkey FOREIGN KEY(second_account_id)REFERENCES accounts(id)ON DELETE CASCADE'
      ];
  @override
  bool get dontWriteConstraints => true;
}

class ChatConversation extends DataClass
    implements Insertable<ChatConversation> {
  final int firstAccountId;
  final int secondAccountId;
  final DateTime createdAt;
  final int createdBy;
  final DateTime updatedAt;
  final int updatedBy;
  final DateTime? deletedAt;
  final int? deletedBy;
  const ChatConversation(
      {required this.firstAccountId,
      required this.secondAccountId,
      required this.createdAt,
      required this.createdBy,
      required this.updatedAt,
      required this.updatedBy,
      this.deletedAt,
      this.deletedBy});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['first_account_id'] = Variable<int>(firstAccountId);
    map['second_account_id'] = Variable<int>(secondAccountId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['created_by'] = Variable<int>(createdBy);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['updated_by'] = Variable<int>(updatedBy);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || deletedBy != null) {
      map['deleted_by'] = Variable<int>(deletedBy);
    }
    return map;
  }

  ChatConversationsCompanion toCompanion(bool nullToAbsent) {
    return ChatConversationsCompanion(
      firstAccountId: Value(firstAccountId),
      secondAccountId: Value(secondAccountId),
      createdAt: Value(createdAt),
      createdBy: Value(createdBy),
      updatedAt: Value(updatedAt),
      updatedBy: Value(updatedBy),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deletedBy: deletedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedBy),
    );
  }

  factory ChatConversation.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChatConversation(
      firstAccountId: serializer.fromJson<int>(json['first_account_id']),
      secondAccountId: serializer.fromJson<int>(json['second_account_id']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      createdBy: serializer.fromJson<int>(json['created_by']),
      updatedAt: serializer.fromJson<DateTime>(json['updated_at']),
      updatedBy: serializer.fromJson<int>(json['updated_by']),
      deletedAt: serializer.fromJson<DateTime?>(json['deleted_at']),
      deletedBy: serializer.fromJson<int?>(json['deleted_by']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'first_account_id': serializer.toJson<int>(firstAccountId),
      'second_account_id': serializer.toJson<int>(secondAccountId),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'created_by': serializer.toJson<int>(createdBy),
      'updated_at': serializer.toJson<DateTime>(updatedAt),
      'updated_by': serializer.toJson<int>(updatedBy),
      'deleted_at': serializer.toJson<DateTime?>(deletedAt),
      'deleted_by': serializer.toJson<int?>(deletedBy),
    };
  }

  ChatConversation copyWith(
          {int? firstAccountId,
          int? secondAccountId,
          DateTime? createdAt,
          int? createdBy,
          DateTime? updatedAt,
          int? updatedBy,
          Value<DateTime?> deletedAt = const Value.absent(),
          Value<int?> deletedBy = const Value.absent()}) =>
      ChatConversation(
        firstAccountId: firstAccountId ?? this.firstAccountId,
        secondAccountId: secondAccountId ?? this.secondAccountId,
        createdAt: createdAt ?? this.createdAt,
        createdBy: createdBy ?? this.createdBy,
        updatedAt: updatedAt ?? this.updatedAt,
        updatedBy: updatedBy ?? this.updatedBy,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        deletedBy: deletedBy.present ? deletedBy.value : this.deletedBy,
      );
  ChatConversation copyWithCompanion(ChatConversationsCompanion data) {
    return ChatConversation(
      firstAccountId: data.firstAccountId.present
          ? data.firstAccountId.value
          : this.firstAccountId,
      secondAccountId: data.secondAccountId.present
          ? data.secondAccountId.value
          : this.secondAccountId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deletedBy: data.deletedBy.present ? data.deletedBy.value : this.deletedBy,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChatConversation(')
          ..write('firstAccountId: $firstAccountId, ')
          ..write('secondAccountId: $secondAccountId, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deletedBy: $deletedBy')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(firstAccountId, secondAccountId, createdAt,
      createdBy, updatedAt, updatedBy, deletedAt, deletedBy);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatConversation &&
          other.firstAccountId == this.firstAccountId &&
          other.secondAccountId == this.secondAccountId &&
          other.createdAt == this.createdAt &&
          other.createdBy == this.createdBy &&
          other.updatedAt == this.updatedAt &&
          other.updatedBy == this.updatedBy &&
          other.deletedAt == this.deletedAt &&
          other.deletedBy == this.deletedBy);
}

class ChatConversationsCompanion extends UpdateCompanion<ChatConversation> {
  final Value<int> firstAccountId;
  final Value<int> secondAccountId;
  final Value<DateTime> createdAt;
  final Value<int> createdBy;
  final Value<DateTime> updatedAt;
  final Value<int> updatedBy;
  final Value<DateTime?> deletedAt;
  final Value<int?> deletedBy;
  final Value<int> rowid;
  const ChatConversationsCompanion({
    this.firstAccountId = const Value.absent(),
    this.secondAccountId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deletedBy = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChatConversationsCompanion.insert({
    required int firstAccountId,
    required int secondAccountId,
    required DateTime createdAt,
    required int createdBy,
    required DateTime updatedAt,
    required int updatedBy,
    this.deletedAt = const Value.absent(),
    this.deletedBy = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : firstAccountId = Value(firstAccountId),
        secondAccountId = Value(secondAccountId),
        createdAt = Value(createdAt),
        createdBy = Value(createdBy),
        updatedAt = Value(updatedAt),
        updatedBy = Value(updatedBy);
  static Insertable<ChatConversation> custom({
    Expression<int>? firstAccountId,
    Expression<int>? secondAccountId,
    Expression<DateTime>? createdAt,
    Expression<int>? createdBy,
    Expression<DateTime>? updatedAt,
    Expression<int>? updatedBy,
    Expression<DateTime>? deletedAt,
    Expression<int>? deletedBy,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (firstAccountId != null) 'first_account_id': firstAccountId,
      if (secondAccountId != null) 'second_account_id': secondAccountId,
      if (createdAt != null) 'created_at': createdAt,
      if (createdBy != null) 'created_by': createdBy,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deletedBy != null) 'deleted_by': deletedBy,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChatConversationsCompanion copyWith(
      {Value<int>? firstAccountId,
      Value<int>? secondAccountId,
      Value<DateTime>? createdAt,
      Value<int>? createdBy,
      Value<DateTime>? updatedAt,
      Value<int>? updatedBy,
      Value<DateTime?>? deletedAt,
      Value<int?>? deletedBy,
      Value<int>? rowid}) {
    return ChatConversationsCompanion(
      firstAccountId: firstAccountId ?? this.firstAccountId,
      secondAccountId: secondAccountId ?? this.secondAccountId,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      deletedAt: deletedAt ?? this.deletedAt,
      deletedBy: deletedBy ?? this.deletedBy,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (firstAccountId.present) {
      map['first_account_id'] = Variable<int>(firstAccountId.value);
    }
    if (secondAccountId.present) {
      map['second_account_id'] = Variable<int>(secondAccountId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<int>(createdBy.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<int>(updatedBy.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (deletedBy.present) {
      map['deleted_by'] = Variable<int>(deletedBy.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatConversationsCompanion(')
          ..write('firstAccountId: $firstAccountId, ')
          ..write('secondAccountId: $secondAccountId, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deletedBy: $deletedBy, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class ChatMessages extends Table with TableInfo<ChatMessages, ChatMessage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  ChatMessages(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _firstAccountIdMeta =
      const VerificationMeta('firstAccountId');
  late final GeneratedColumn<int> firstAccountId = GeneratedColumn<int>(
      'first_account_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _secondAccountIdMeta =
      const VerificationMeta('secondAccountId');
  late final GeneratedColumn<int> secondAccountId = GeneratedColumn<int>(
      'second_account_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _senderAccountIdMeta =
      const VerificationMeta('senderAccountId');
  late final GeneratedColumn<int> senderAccountId = GeneratedColumn<int>(
      'sender_account_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _messageMeta =
      const VerificationMeta('message');
  late final GeneratedColumn<String> message = GeneratedColumn<String>(
      'message', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  static const VerificationMeta _recipeIdMeta =
      const VerificationMeta('recipeId');
  late final GeneratedColumn<int> recipeId = GeneratedColumn<int>(
      'recipe_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  static const VerificationMeta _recipeTitleSnapshotMeta =
      const VerificationMeta('recipeTitleSnapshot');
  late final GeneratedColumn<String> recipeTitleSnapshot =
      GeneratedColumn<String>('recipe_title_snapshot', aliasedName, true,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          $customConstraints: 'NULL');
  static const VerificationMeta _shoppingListIdMeta =
      const VerificationMeta('shoppingListId');
  late final GeneratedColumn<int> shoppingListId = GeneratedColumn<int>(
      'shopping_list_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  static const VerificationMeta _shoppingListNameSnapshotMeta =
      const VerificationMeta('shoppingListNameSnapshot');
  late final GeneratedColumn<String> shoppingListNameSnapshot =
      GeneratedColumn<String>('shopping_list_name_snapshot', aliasedName, true,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          $customConstraints: 'NULL');
  static const VerificationMeta _replyToMessageIdMeta =
      const VerificationMeta('replyToMessageId');
  late final GeneratedColumn<int> replyToMessageId = GeneratedColumn<int>(
      'reply_to_message_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  static const VerificationMeta _replyMessageSnapshotMeta =
      const VerificationMeta('replyMessageSnapshot');
  late final GeneratedColumn<String> replyMessageSnapshot =
      GeneratedColumn<String>('reply_message_snapshot', aliasedName, true,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          $customConstraints: 'NULL');
  static const VerificationMeta _readAtMeta = const VerificationMeta('readAt');
  late final GeneratedColumn<DateTime> readAt = GeneratedColumn<DateTime>(
      'read_at', aliasedName, true,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _createdByMeta =
      const VerificationMeta('createdBy');
  late final GeneratedColumn<int> createdBy = GeneratedColumn<int>(
      'created_by', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _updatedByMeta =
      const VerificationMeta('updatedBy');
  late final GeneratedColumn<int> updatedBy = GeneratedColumn<int>(
      'updated_by', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  static const VerificationMeta _deletedByMeta =
      const VerificationMeta('deletedBy');
  late final GeneratedColumn<int> deletedBy = GeneratedColumn<int>(
      'deleted_by', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  @override
  List<GeneratedColumn> get $columns => [
        id,
        firstAccountId,
        secondAccountId,
        senderAccountId,
        message,
        recipeId,
        recipeTitleSnapshot,
        shoppingListId,
        shoppingListNameSnapshot,
        replyToMessageId,
        replyMessageSnapshot,
        readAt,
        createdAt,
        createdBy,
        updatedAt,
        updatedBy,
        deletedAt,
        deletedBy
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chat_messages';
  @override
  VerificationContext validateIntegrity(Insertable<ChatMessage> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('first_account_id')) {
      context.handle(
          _firstAccountIdMeta,
          firstAccountId.isAcceptableOrUnknown(
              data['first_account_id']!, _firstAccountIdMeta));
    } else if (isInserting) {
      context.missing(_firstAccountIdMeta);
    }
    if (data.containsKey('second_account_id')) {
      context.handle(
          _secondAccountIdMeta,
          secondAccountId.isAcceptableOrUnknown(
              data['second_account_id']!, _secondAccountIdMeta));
    } else if (isInserting) {
      context.missing(_secondAccountIdMeta);
    }
    if (data.containsKey('sender_account_id')) {
      context.handle(
          _senderAccountIdMeta,
          senderAccountId.isAcceptableOrUnknown(
              data['sender_account_id']!, _senderAccountIdMeta));
    } else if (isInserting) {
      context.missing(_senderAccountIdMeta);
    }
    if (data.containsKey('message')) {
      context.handle(_messageMeta,
          message.isAcceptableOrUnknown(data['message']!, _messageMeta));
    }
    if (data.containsKey('recipe_id')) {
      context.handle(_recipeIdMeta,
          recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta));
    }
    if (data.containsKey('recipe_title_snapshot')) {
      context.handle(
          _recipeTitleSnapshotMeta,
          recipeTitleSnapshot.isAcceptableOrUnknown(
              data['recipe_title_snapshot']!, _recipeTitleSnapshotMeta));
    }
    if (data.containsKey('shopping_list_id')) {
      context.handle(
          _shoppingListIdMeta,
          shoppingListId.isAcceptableOrUnknown(
              data['shopping_list_id']!, _shoppingListIdMeta));
    }
    if (data.containsKey('shopping_list_name_snapshot')) {
      context.handle(
          _shoppingListNameSnapshotMeta,
          shoppingListNameSnapshot.isAcceptableOrUnknown(
              data['shopping_list_name_snapshot']!,
              _shoppingListNameSnapshotMeta));
    }
    if (data.containsKey('reply_to_message_id')) {
      context.handle(
          _replyToMessageIdMeta,
          replyToMessageId.isAcceptableOrUnknown(
              data['reply_to_message_id']!, _replyToMessageIdMeta));
    }
    if (data.containsKey('reply_message_snapshot')) {
      context.handle(
          _replyMessageSnapshotMeta,
          replyMessageSnapshot.isAcceptableOrUnknown(
              data['reply_message_snapshot']!, _replyMessageSnapshotMeta));
    }
    if (data.containsKey('read_at')) {
      context.handle(_readAtMeta,
          readAt.isAcceptableOrUnknown(data['read_at']!, _readAtMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('updated_by')) {
      context.handle(_updatedByMeta,
          updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta));
    } else if (isInserting) {
      context.missing(_updatedByMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('deleted_by')) {
      context.handle(_deletedByMeta,
          deletedBy.isAcceptableOrUnknown(data['deleted_by']!, _deletedByMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChatMessage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChatMessage(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      firstAccountId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}first_account_id'])!,
      secondAccountId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}second_account_id'])!,
      senderAccountId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sender_account_id'])!,
      message: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}message']),
      recipeId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}recipe_id']),
      recipeTitleSnapshot: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}recipe_title_snapshot']),
      shoppingListId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}shopping_list_id']),
      shoppingListNameSnapshot: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}shopping_list_name_snapshot']),
      replyToMessageId: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}reply_to_message_id']),
      replyMessageSnapshot: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}reply_message_snapshot']),
      readAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}read_at']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      createdBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_by'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      updatedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_by'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
      deletedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}deleted_by']),
    );
  }

  @override
  ChatMessages createAlias(String alias) {
    return ChatMessages(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
        'CONSTRAINT chat_message_pkey PRIMARY KEY(id)',
        'CONSTRAINT chat_message_conversation_fkey FOREIGN KEY(first_account_id, second_account_id)REFERENCES chat_conversations(first_account_id, second_account_id)ON DELETE CASCADE',
        'CONSTRAINT chat_message_sender_fkey FOREIGN KEY(sender_account_id)REFERENCES accounts(id)ON DELETE CASCADE'
      ];
  @override
  bool get dontWriteConstraints => true;
}

class ChatMessage extends DataClass implements Insertable<ChatMessage> {
  final int id;
  final int firstAccountId;
  final int secondAccountId;
  final int senderAccountId;
  final String? message;
  final int? recipeId;
  final String? recipeTitleSnapshot;
  final int? shoppingListId;
  final String? shoppingListNameSnapshot;
  final int? replyToMessageId;
  final String? replyMessageSnapshot;
  final DateTime? readAt;
  final DateTime createdAt;
  final int createdBy;
  final DateTime updatedAt;
  final int updatedBy;
  final DateTime? deletedAt;
  final int? deletedBy;
  const ChatMessage(
      {required this.id,
      required this.firstAccountId,
      required this.secondAccountId,
      required this.senderAccountId,
      this.message,
      this.recipeId,
      this.recipeTitleSnapshot,
      this.shoppingListId,
      this.shoppingListNameSnapshot,
      this.replyToMessageId,
      this.replyMessageSnapshot,
      this.readAt,
      required this.createdAt,
      required this.createdBy,
      required this.updatedAt,
      required this.updatedBy,
      this.deletedAt,
      this.deletedBy});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['first_account_id'] = Variable<int>(firstAccountId);
    map['second_account_id'] = Variable<int>(secondAccountId);
    map['sender_account_id'] = Variable<int>(senderAccountId);
    if (!nullToAbsent || message != null) {
      map['message'] = Variable<String>(message);
    }
    if (!nullToAbsent || recipeId != null) {
      map['recipe_id'] = Variable<int>(recipeId);
    }
    if (!nullToAbsent || recipeTitleSnapshot != null) {
      map['recipe_title_snapshot'] = Variable<String>(recipeTitleSnapshot);
    }
    if (!nullToAbsent || shoppingListId != null) {
      map['shopping_list_id'] = Variable<int>(shoppingListId);
    }
    if (!nullToAbsent || shoppingListNameSnapshot != null) {
      map['shopping_list_name_snapshot'] =
          Variable<String>(shoppingListNameSnapshot);
    }
    if (!nullToAbsent || replyToMessageId != null) {
      map['reply_to_message_id'] = Variable<int>(replyToMessageId);
    }
    if (!nullToAbsent || replyMessageSnapshot != null) {
      map['reply_message_snapshot'] = Variable<String>(replyMessageSnapshot);
    }
    if (!nullToAbsent || readAt != null) {
      map['read_at'] = Variable<DateTime>(readAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['created_by'] = Variable<int>(createdBy);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['updated_by'] = Variable<int>(updatedBy);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || deletedBy != null) {
      map['deleted_by'] = Variable<int>(deletedBy);
    }
    return map;
  }

  ChatMessagesCompanion toCompanion(bool nullToAbsent) {
    return ChatMessagesCompanion(
      id: Value(id),
      firstAccountId: Value(firstAccountId),
      secondAccountId: Value(secondAccountId),
      senderAccountId: Value(senderAccountId),
      message: message == null && nullToAbsent
          ? const Value.absent()
          : Value(message),
      recipeId: recipeId == null && nullToAbsent
          ? const Value.absent()
          : Value(recipeId),
      recipeTitleSnapshot: recipeTitleSnapshot == null && nullToAbsent
          ? const Value.absent()
          : Value(recipeTitleSnapshot),
      shoppingListId: shoppingListId == null && nullToAbsent
          ? const Value.absent()
          : Value(shoppingListId),
      shoppingListNameSnapshot: shoppingListNameSnapshot == null && nullToAbsent
          ? const Value.absent()
          : Value(shoppingListNameSnapshot),
      replyToMessageId: replyToMessageId == null && nullToAbsent
          ? const Value.absent()
          : Value(replyToMessageId),
      replyMessageSnapshot: replyMessageSnapshot == null && nullToAbsent
          ? const Value.absent()
          : Value(replyMessageSnapshot),
      readAt:
          readAt == null && nullToAbsent ? const Value.absent() : Value(readAt),
      createdAt: Value(createdAt),
      createdBy: Value(createdBy),
      updatedAt: Value(updatedAt),
      updatedBy: Value(updatedBy),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deletedBy: deletedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedBy),
    );
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChatMessage(
      id: serializer.fromJson<int>(json['id']),
      firstAccountId: serializer.fromJson<int>(json['first_account_id']),
      secondAccountId: serializer.fromJson<int>(json['second_account_id']),
      senderAccountId: serializer.fromJson<int>(json['sender_account_id']),
      message: serializer.fromJson<String?>(json['message']),
      recipeId: serializer.fromJson<int?>(json['recipe_id']),
      recipeTitleSnapshot:
          serializer.fromJson<String?>(json['recipe_title_snapshot']),
      shoppingListId: serializer.fromJson<int?>(json['shopping_list_id']),
      shoppingListNameSnapshot:
          serializer.fromJson<String?>(json['shopping_list_name_snapshot']),
      replyToMessageId: serializer.fromJson<int?>(json['reply_to_message_id']),
      replyMessageSnapshot:
          serializer.fromJson<String?>(json['reply_message_snapshot']),
      readAt: serializer.fromJson<DateTime?>(json['read_at']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      createdBy: serializer.fromJson<int>(json['created_by']),
      updatedAt: serializer.fromJson<DateTime>(json['updated_at']),
      updatedBy: serializer.fromJson<int>(json['updated_by']),
      deletedAt: serializer.fromJson<DateTime?>(json['deleted_at']),
      deletedBy: serializer.fromJson<int?>(json['deleted_by']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'first_account_id': serializer.toJson<int>(firstAccountId),
      'second_account_id': serializer.toJson<int>(secondAccountId),
      'sender_account_id': serializer.toJson<int>(senderAccountId),
      'message': serializer.toJson<String?>(message),
      'recipe_id': serializer.toJson<int?>(recipeId),
      'recipe_title_snapshot': serializer.toJson<String?>(recipeTitleSnapshot),
      'shopping_list_id': serializer.toJson<int?>(shoppingListId),
      'shopping_list_name_snapshot':
          serializer.toJson<String?>(shoppingListNameSnapshot),
      'reply_to_message_id': serializer.toJson<int?>(replyToMessageId),
      'reply_message_snapshot':
          serializer.toJson<String?>(replyMessageSnapshot),
      'read_at': serializer.toJson<DateTime?>(readAt),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'created_by': serializer.toJson<int>(createdBy),
      'updated_at': serializer.toJson<DateTime>(updatedAt),
      'updated_by': serializer.toJson<int>(updatedBy),
      'deleted_at': serializer.toJson<DateTime?>(deletedAt),
      'deleted_by': serializer.toJson<int?>(deletedBy),
    };
  }

  ChatMessage copyWith(
          {int? id,
          int? firstAccountId,
          int? secondAccountId,
          int? senderAccountId,
          Value<String?> message = const Value.absent(),
          Value<int?> recipeId = const Value.absent(),
          Value<String?> recipeTitleSnapshot = const Value.absent(),
          Value<int?> shoppingListId = const Value.absent(),
          Value<String?> shoppingListNameSnapshot = const Value.absent(),
          Value<int?> replyToMessageId = const Value.absent(),
          Value<String?> replyMessageSnapshot = const Value.absent(),
          Value<DateTime?> readAt = const Value.absent(),
          DateTime? createdAt,
          int? createdBy,
          DateTime? updatedAt,
          int? updatedBy,
          Value<DateTime?> deletedAt = const Value.absent(),
          Value<int?> deletedBy = const Value.absent()}) =>
      ChatMessage(
        id: id ?? this.id,
        firstAccountId: firstAccountId ?? this.firstAccountId,
        secondAccountId: secondAccountId ?? this.secondAccountId,
        senderAccountId: senderAccountId ?? this.senderAccountId,
        message: message.present ? message.value : this.message,
        recipeId: recipeId.present ? recipeId.value : this.recipeId,
        recipeTitleSnapshot: recipeTitleSnapshot.present
            ? recipeTitleSnapshot.value
            : this.recipeTitleSnapshot,
        shoppingListId:
            shoppingListId.present ? shoppingListId.value : this.shoppingListId,
        shoppingListNameSnapshot: shoppingListNameSnapshot.present
            ? shoppingListNameSnapshot.value
            : this.shoppingListNameSnapshot,
        replyToMessageId: replyToMessageId.present
            ? replyToMessageId.value
            : this.replyToMessageId,
        replyMessageSnapshot: replyMessageSnapshot.present
            ? replyMessageSnapshot.value
            : this.replyMessageSnapshot,
        readAt: readAt.present ? readAt.value : this.readAt,
        createdAt: createdAt ?? this.createdAt,
        createdBy: createdBy ?? this.createdBy,
        updatedAt: updatedAt ?? this.updatedAt,
        updatedBy: updatedBy ?? this.updatedBy,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        deletedBy: deletedBy.present ? deletedBy.value : this.deletedBy,
      );
  ChatMessage copyWithCompanion(ChatMessagesCompanion data) {
    return ChatMessage(
      id: data.id.present ? data.id.value : this.id,
      firstAccountId: data.firstAccountId.present
          ? data.firstAccountId.value
          : this.firstAccountId,
      secondAccountId: data.secondAccountId.present
          ? data.secondAccountId.value
          : this.secondAccountId,
      senderAccountId: data.senderAccountId.present
          ? data.senderAccountId.value
          : this.senderAccountId,
      message: data.message.present ? data.message.value : this.message,
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
      recipeTitleSnapshot: data.recipeTitleSnapshot.present
          ? data.recipeTitleSnapshot.value
          : this.recipeTitleSnapshot,
      shoppingListId: data.shoppingListId.present
          ? data.shoppingListId.value
          : this.shoppingListId,
      shoppingListNameSnapshot: data.shoppingListNameSnapshot.present
          ? data.shoppingListNameSnapshot.value
          : this.shoppingListNameSnapshot,
      replyToMessageId: data.replyToMessageId.present
          ? data.replyToMessageId.value
          : this.replyToMessageId,
      replyMessageSnapshot: data.replyMessageSnapshot.present
          ? data.replyMessageSnapshot.value
          : this.replyMessageSnapshot,
      readAt: data.readAt.present ? data.readAt.value : this.readAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deletedBy: data.deletedBy.present ? data.deletedBy.value : this.deletedBy,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChatMessage(')
          ..write('id: $id, ')
          ..write('firstAccountId: $firstAccountId, ')
          ..write('secondAccountId: $secondAccountId, ')
          ..write('senderAccountId: $senderAccountId, ')
          ..write('message: $message, ')
          ..write('recipeId: $recipeId, ')
          ..write('recipeTitleSnapshot: $recipeTitleSnapshot, ')
          ..write('shoppingListId: $shoppingListId, ')
          ..write('shoppingListNameSnapshot: $shoppingListNameSnapshot, ')
          ..write('replyToMessageId: $replyToMessageId, ')
          ..write('replyMessageSnapshot: $replyMessageSnapshot, ')
          ..write('readAt: $readAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deletedBy: $deletedBy')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      firstAccountId,
      secondAccountId,
      senderAccountId,
      message,
      recipeId,
      recipeTitleSnapshot,
      shoppingListId,
      shoppingListNameSnapshot,
      replyToMessageId,
      replyMessageSnapshot,
      readAt,
      createdAt,
      createdBy,
      updatedAt,
      updatedBy,
      deletedAt,
      deletedBy);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatMessage &&
          other.id == this.id &&
          other.firstAccountId == this.firstAccountId &&
          other.secondAccountId == this.secondAccountId &&
          other.senderAccountId == this.senderAccountId &&
          other.message == this.message &&
          other.recipeId == this.recipeId &&
          other.recipeTitleSnapshot == this.recipeTitleSnapshot &&
          other.shoppingListId == this.shoppingListId &&
          other.shoppingListNameSnapshot == this.shoppingListNameSnapshot &&
          other.replyToMessageId == this.replyToMessageId &&
          other.replyMessageSnapshot == this.replyMessageSnapshot &&
          other.readAt == this.readAt &&
          other.createdAt == this.createdAt &&
          other.createdBy == this.createdBy &&
          other.updatedAt == this.updatedAt &&
          other.updatedBy == this.updatedBy &&
          other.deletedAt == this.deletedAt &&
          other.deletedBy == this.deletedBy);
}

class ChatMessagesCompanion extends UpdateCompanion<ChatMessage> {
  final Value<int> id;
  final Value<int> firstAccountId;
  final Value<int> secondAccountId;
  final Value<int> senderAccountId;
  final Value<String?> message;
  final Value<int?> recipeId;
  final Value<String?> recipeTitleSnapshot;
  final Value<int?> shoppingListId;
  final Value<String?> shoppingListNameSnapshot;
  final Value<int?> replyToMessageId;
  final Value<String?> replyMessageSnapshot;
  final Value<DateTime?> readAt;
  final Value<DateTime> createdAt;
  final Value<int> createdBy;
  final Value<DateTime> updatedAt;
  final Value<int> updatedBy;
  final Value<DateTime?> deletedAt;
  final Value<int?> deletedBy;
  const ChatMessagesCompanion({
    this.id = const Value.absent(),
    this.firstAccountId = const Value.absent(),
    this.secondAccountId = const Value.absent(),
    this.senderAccountId = const Value.absent(),
    this.message = const Value.absent(),
    this.recipeId = const Value.absent(),
    this.recipeTitleSnapshot = const Value.absent(),
    this.shoppingListId = const Value.absent(),
    this.shoppingListNameSnapshot = const Value.absent(),
    this.replyToMessageId = const Value.absent(),
    this.replyMessageSnapshot = const Value.absent(),
    this.readAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deletedBy = const Value.absent(),
  });
  ChatMessagesCompanion.insert({
    this.id = const Value.absent(),
    required int firstAccountId,
    required int secondAccountId,
    required int senderAccountId,
    this.message = const Value.absent(),
    this.recipeId = const Value.absent(),
    this.recipeTitleSnapshot = const Value.absent(),
    this.shoppingListId = const Value.absent(),
    this.shoppingListNameSnapshot = const Value.absent(),
    this.replyToMessageId = const Value.absent(),
    this.replyMessageSnapshot = const Value.absent(),
    this.readAt = const Value.absent(),
    required DateTime createdAt,
    required int createdBy,
    required DateTime updatedAt,
    required int updatedBy,
    this.deletedAt = const Value.absent(),
    this.deletedBy = const Value.absent(),
  })  : firstAccountId = Value(firstAccountId),
        secondAccountId = Value(secondAccountId),
        senderAccountId = Value(senderAccountId),
        createdAt = Value(createdAt),
        createdBy = Value(createdBy),
        updatedAt = Value(updatedAt),
        updatedBy = Value(updatedBy);
  static Insertable<ChatMessage> custom({
    Expression<int>? id,
    Expression<int>? firstAccountId,
    Expression<int>? secondAccountId,
    Expression<int>? senderAccountId,
    Expression<String>? message,
    Expression<int>? recipeId,
    Expression<String>? recipeTitleSnapshot,
    Expression<int>? shoppingListId,
    Expression<String>? shoppingListNameSnapshot,
    Expression<int>? replyToMessageId,
    Expression<String>? replyMessageSnapshot,
    Expression<DateTime>? readAt,
    Expression<DateTime>? createdAt,
    Expression<int>? createdBy,
    Expression<DateTime>? updatedAt,
    Expression<int>? updatedBy,
    Expression<DateTime>? deletedAt,
    Expression<int>? deletedBy,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (firstAccountId != null) 'first_account_id': firstAccountId,
      if (secondAccountId != null) 'second_account_id': secondAccountId,
      if (senderAccountId != null) 'sender_account_id': senderAccountId,
      if (message != null) 'message': message,
      if (recipeId != null) 'recipe_id': recipeId,
      if (recipeTitleSnapshot != null)
        'recipe_title_snapshot': recipeTitleSnapshot,
      if (shoppingListId != null) 'shopping_list_id': shoppingListId,
      if (shoppingListNameSnapshot != null)
        'shopping_list_name_snapshot': shoppingListNameSnapshot,
      if (replyToMessageId != null) 'reply_to_message_id': replyToMessageId,
      if (replyMessageSnapshot != null)
        'reply_message_snapshot': replyMessageSnapshot,
      if (readAt != null) 'read_at': readAt,
      if (createdAt != null) 'created_at': createdAt,
      if (createdBy != null) 'created_by': createdBy,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deletedBy != null) 'deleted_by': deletedBy,
    });
  }

  ChatMessagesCompanion copyWith(
      {Value<int>? id,
      Value<int>? firstAccountId,
      Value<int>? secondAccountId,
      Value<int>? senderAccountId,
      Value<String?>? message,
      Value<int?>? recipeId,
      Value<String?>? recipeTitleSnapshot,
      Value<int?>? shoppingListId,
      Value<String?>? shoppingListNameSnapshot,
      Value<int?>? replyToMessageId,
      Value<String?>? replyMessageSnapshot,
      Value<DateTime?>? readAt,
      Value<DateTime>? createdAt,
      Value<int>? createdBy,
      Value<DateTime>? updatedAt,
      Value<int>? updatedBy,
      Value<DateTime?>? deletedAt,
      Value<int?>? deletedBy}) {
    return ChatMessagesCompanion(
      id: id ?? this.id,
      firstAccountId: firstAccountId ?? this.firstAccountId,
      secondAccountId: secondAccountId ?? this.secondAccountId,
      senderAccountId: senderAccountId ?? this.senderAccountId,
      message: message ?? this.message,
      recipeId: recipeId ?? this.recipeId,
      recipeTitleSnapshot: recipeTitleSnapshot ?? this.recipeTitleSnapshot,
      shoppingListId: shoppingListId ?? this.shoppingListId,
      shoppingListNameSnapshot:
          shoppingListNameSnapshot ?? this.shoppingListNameSnapshot,
      replyToMessageId: replyToMessageId ?? this.replyToMessageId,
      replyMessageSnapshot: replyMessageSnapshot ?? this.replyMessageSnapshot,
      readAt: readAt ?? this.readAt,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      deletedAt: deletedAt ?? this.deletedAt,
      deletedBy: deletedBy ?? this.deletedBy,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (firstAccountId.present) {
      map['first_account_id'] = Variable<int>(firstAccountId.value);
    }
    if (secondAccountId.present) {
      map['second_account_id'] = Variable<int>(secondAccountId.value);
    }
    if (senderAccountId.present) {
      map['sender_account_id'] = Variable<int>(senderAccountId.value);
    }
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    if (recipeId.present) {
      map['recipe_id'] = Variable<int>(recipeId.value);
    }
    if (recipeTitleSnapshot.present) {
      map['recipe_title_snapshot'] =
          Variable<String>(recipeTitleSnapshot.value);
    }
    if (shoppingListId.present) {
      map['shopping_list_id'] = Variable<int>(shoppingListId.value);
    }
    if (shoppingListNameSnapshot.present) {
      map['shopping_list_name_snapshot'] =
          Variable<String>(shoppingListNameSnapshot.value);
    }
    if (replyToMessageId.present) {
      map['reply_to_message_id'] = Variable<int>(replyToMessageId.value);
    }
    if (replyMessageSnapshot.present) {
      map['reply_message_snapshot'] =
          Variable<String>(replyMessageSnapshot.value);
    }
    if (readAt.present) {
      map['read_at'] = Variable<DateTime>(readAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<int>(createdBy.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<int>(updatedBy.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (deletedBy.present) {
      map['deleted_by'] = Variable<int>(deletedBy.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatMessagesCompanion(')
          ..write('id: $id, ')
          ..write('firstAccountId: $firstAccountId, ')
          ..write('secondAccountId: $secondAccountId, ')
          ..write('senderAccountId: $senderAccountId, ')
          ..write('message: $message, ')
          ..write('recipeId: $recipeId, ')
          ..write('recipeTitleSnapshot: $recipeTitleSnapshot, ')
          ..write('shoppingListId: $shoppingListId, ')
          ..write('shoppingListNameSnapshot: $shoppingListNameSnapshot, ')
          ..write('replyToMessageId: $replyToMessageId, ')
          ..write('replyMessageSnapshot: $replyMessageSnapshot, ')
          ..write('readAt: $readAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deletedBy: $deletedBy')
          ..write(')'))
        .toString();
  }
}

class ChatMessageReactions extends Table
    with TableInfo<ChatMessageReactions, ChatMessageReaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  ChatMessageReactions(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _messageIdMeta =
      const VerificationMeta('messageId');
  late final GeneratedColumn<int> messageId = GeneratedColumn<int>(
      'message_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _accountIdMeta =
      const VerificationMeta('accountId');
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
      'account_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _reactionMeta =
      const VerificationMeta('reaction');
  late final GeneratedColumn<String> reaction = GeneratedColumn<String>(
      'reaction', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _createdByMeta =
      const VerificationMeta('createdBy');
  late final GeneratedColumn<int> createdBy = GeneratedColumn<int>(
      'created_by', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _updatedByMeta =
      const VerificationMeta('updatedBy');
  late final GeneratedColumn<int> updatedBy = GeneratedColumn<int>(
      'updated_by', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  static const VerificationMeta _deletedByMeta =
      const VerificationMeta('deletedBy');
  late final GeneratedColumn<int> deletedBy = GeneratedColumn<int>(
      'deleted_by', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  @override
  List<GeneratedColumn> get $columns => [
        messageId,
        accountId,
        reaction,
        createdAt,
        createdBy,
        updatedAt,
        updatedBy,
        deletedAt,
        deletedBy
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chat_message_reactions';
  @override
  VerificationContext validateIntegrity(
      Insertable<ChatMessageReaction> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('message_id')) {
      context.handle(_messageIdMeta,
          messageId.isAcceptableOrUnknown(data['message_id']!, _messageIdMeta));
    } else if (isInserting) {
      context.missing(_messageIdMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta,
          accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('reaction')) {
      context.handle(_reactionMeta,
          reaction.isAcceptableOrUnknown(data['reaction']!, _reactionMeta));
    } else if (isInserting) {
      context.missing(_reactionMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('updated_by')) {
      context.handle(_updatedByMeta,
          updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta));
    } else if (isInserting) {
      context.missing(_updatedByMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('deleted_by')) {
      context.handle(_deletedByMeta,
          deletedBy.isAcceptableOrUnknown(data['deleted_by']!, _deletedByMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {messageId, accountId};
  @override
  ChatMessageReaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChatMessageReaction(
      messageId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}message_id'])!,
      accountId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}account_id'])!,
      reaction: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reaction'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      createdBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_by'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      updatedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_by'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
      deletedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}deleted_by']),
    );
  }

  @override
  ChatMessageReactions createAlias(String alias) {
    return ChatMessageReactions(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
        'CONSTRAINT chat_message_reaction_pkey PRIMARY KEY(message_id, account_id)',
        'CONSTRAINT chat_message_reaction_message_fkey FOREIGN KEY(message_id)REFERENCES chat_messages(id)ON DELETE CASCADE',
        'CONSTRAINT chat_message_reaction_account_fkey FOREIGN KEY(account_id)REFERENCES accounts(id)ON DELETE CASCADE'
      ];
  @override
  bool get dontWriteConstraints => true;
}

class ChatMessageReaction extends DataClass
    implements Insertable<ChatMessageReaction> {
  final int messageId;
  final int accountId;
  final String reaction;
  final DateTime createdAt;
  final int createdBy;
  final DateTime updatedAt;
  final int updatedBy;
  final DateTime? deletedAt;
  final int? deletedBy;
  const ChatMessageReaction(
      {required this.messageId,
      required this.accountId,
      required this.reaction,
      required this.createdAt,
      required this.createdBy,
      required this.updatedAt,
      required this.updatedBy,
      this.deletedAt,
      this.deletedBy});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['message_id'] = Variable<int>(messageId);
    map['account_id'] = Variable<int>(accountId);
    map['reaction'] = Variable<String>(reaction);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['created_by'] = Variable<int>(createdBy);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['updated_by'] = Variable<int>(updatedBy);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || deletedBy != null) {
      map['deleted_by'] = Variable<int>(deletedBy);
    }
    return map;
  }

  ChatMessageReactionsCompanion toCompanion(bool nullToAbsent) {
    return ChatMessageReactionsCompanion(
      messageId: Value(messageId),
      accountId: Value(accountId),
      reaction: Value(reaction),
      createdAt: Value(createdAt),
      createdBy: Value(createdBy),
      updatedAt: Value(updatedAt),
      updatedBy: Value(updatedBy),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deletedBy: deletedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedBy),
    );
  }

  factory ChatMessageReaction.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChatMessageReaction(
      messageId: serializer.fromJson<int>(json['message_id']),
      accountId: serializer.fromJson<int>(json['account_id']),
      reaction: serializer.fromJson<String>(json['reaction']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      createdBy: serializer.fromJson<int>(json['created_by']),
      updatedAt: serializer.fromJson<DateTime>(json['updated_at']),
      updatedBy: serializer.fromJson<int>(json['updated_by']),
      deletedAt: serializer.fromJson<DateTime?>(json['deleted_at']),
      deletedBy: serializer.fromJson<int?>(json['deleted_by']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'message_id': serializer.toJson<int>(messageId),
      'account_id': serializer.toJson<int>(accountId),
      'reaction': serializer.toJson<String>(reaction),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'created_by': serializer.toJson<int>(createdBy),
      'updated_at': serializer.toJson<DateTime>(updatedAt),
      'updated_by': serializer.toJson<int>(updatedBy),
      'deleted_at': serializer.toJson<DateTime?>(deletedAt),
      'deleted_by': serializer.toJson<int?>(deletedBy),
    };
  }

  ChatMessageReaction copyWith(
          {int? messageId,
          int? accountId,
          String? reaction,
          DateTime? createdAt,
          int? createdBy,
          DateTime? updatedAt,
          int? updatedBy,
          Value<DateTime?> deletedAt = const Value.absent(),
          Value<int?> deletedBy = const Value.absent()}) =>
      ChatMessageReaction(
        messageId: messageId ?? this.messageId,
        accountId: accountId ?? this.accountId,
        reaction: reaction ?? this.reaction,
        createdAt: createdAt ?? this.createdAt,
        createdBy: createdBy ?? this.createdBy,
        updatedAt: updatedAt ?? this.updatedAt,
        updatedBy: updatedBy ?? this.updatedBy,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        deletedBy: deletedBy.present ? deletedBy.value : this.deletedBy,
      );
  ChatMessageReaction copyWithCompanion(ChatMessageReactionsCompanion data) {
    return ChatMessageReaction(
      messageId: data.messageId.present ? data.messageId.value : this.messageId,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      reaction: data.reaction.present ? data.reaction.value : this.reaction,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deletedBy: data.deletedBy.present ? data.deletedBy.value : this.deletedBy,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChatMessageReaction(')
          ..write('messageId: $messageId, ')
          ..write('accountId: $accountId, ')
          ..write('reaction: $reaction, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deletedBy: $deletedBy')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(messageId, accountId, reaction, createdAt,
      createdBy, updatedAt, updatedBy, deletedAt, deletedBy);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatMessageReaction &&
          other.messageId == this.messageId &&
          other.accountId == this.accountId &&
          other.reaction == this.reaction &&
          other.createdAt == this.createdAt &&
          other.createdBy == this.createdBy &&
          other.updatedAt == this.updatedAt &&
          other.updatedBy == this.updatedBy &&
          other.deletedAt == this.deletedAt &&
          other.deletedBy == this.deletedBy);
}

class ChatMessageReactionsCompanion
    extends UpdateCompanion<ChatMessageReaction> {
  final Value<int> messageId;
  final Value<int> accountId;
  final Value<String> reaction;
  final Value<DateTime> createdAt;
  final Value<int> createdBy;
  final Value<DateTime> updatedAt;
  final Value<int> updatedBy;
  final Value<DateTime?> deletedAt;
  final Value<int?> deletedBy;
  final Value<int> rowid;
  const ChatMessageReactionsCompanion({
    this.messageId = const Value.absent(),
    this.accountId = const Value.absent(),
    this.reaction = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deletedBy = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChatMessageReactionsCompanion.insert({
    required int messageId,
    required int accountId,
    required String reaction,
    required DateTime createdAt,
    required int createdBy,
    required DateTime updatedAt,
    required int updatedBy,
    this.deletedAt = const Value.absent(),
    this.deletedBy = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : messageId = Value(messageId),
        accountId = Value(accountId),
        reaction = Value(reaction),
        createdAt = Value(createdAt),
        createdBy = Value(createdBy),
        updatedAt = Value(updatedAt),
        updatedBy = Value(updatedBy);
  static Insertable<ChatMessageReaction> custom({
    Expression<int>? messageId,
    Expression<int>? accountId,
    Expression<String>? reaction,
    Expression<DateTime>? createdAt,
    Expression<int>? createdBy,
    Expression<DateTime>? updatedAt,
    Expression<int>? updatedBy,
    Expression<DateTime>? deletedAt,
    Expression<int>? deletedBy,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (messageId != null) 'message_id': messageId,
      if (accountId != null) 'account_id': accountId,
      if (reaction != null) 'reaction': reaction,
      if (createdAt != null) 'created_at': createdAt,
      if (createdBy != null) 'created_by': createdBy,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deletedBy != null) 'deleted_by': deletedBy,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChatMessageReactionsCompanion copyWith(
      {Value<int>? messageId,
      Value<int>? accountId,
      Value<String>? reaction,
      Value<DateTime>? createdAt,
      Value<int>? createdBy,
      Value<DateTime>? updatedAt,
      Value<int>? updatedBy,
      Value<DateTime?>? deletedAt,
      Value<int?>? deletedBy,
      Value<int>? rowid}) {
    return ChatMessageReactionsCompanion(
      messageId: messageId ?? this.messageId,
      accountId: accountId ?? this.accountId,
      reaction: reaction ?? this.reaction,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      deletedAt: deletedAt ?? this.deletedAt,
      deletedBy: deletedBy ?? this.deletedBy,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (messageId.present) {
      map['message_id'] = Variable<int>(messageId.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (reaction.present) {
      map['reaction'] = Variable<String>(reaction.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<int>(createdBy.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<int>(updatedBy.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (deletedBy.present) {
      map['deleted_by'] = Variable<int>(deletedBy.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatMessageReactionsCompanion(')
          ..write('messageId: $messageId, ')
          ..write('accountId: $accountId, ')
          ..write('reaction: $reaction, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deletedBy: $deletedBy, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class RecipeLikes extends Table with TableInfo<RecipeLikes, RecipeLike> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  RecipeLikes(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _accountIdMeta =
      const VerificationMeta('accountId');
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
      'account_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _recipeIdMeta =
      const VerificationMeta('recipeId');
  late final GeneratedColumn<int> recipeId = GeneratedColumn<int>(
      'recipe_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _createdByMeta =
      const VerificationMeta('createdBy');
  late final GeneratedColumn<int> createdBy = GeneratedColumn<int>(
      'created_by', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _updatedByMeta =
      const VerificationMeta('updatedBy');
  late final GeneratedColumn<int> updatedBy = GeneratedColumn<int>(
      'updated_by', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  static const VerificationMeta _deletedByMeta =
      const VerificationMeta('deletedBy');
  late final GeneratedColumn<int> deletedBy = GeneratedColumn<int>(
      'deleted_by', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  @override
  List<GeneratedColumn> get $columns => [
        accountId,
        recipeId,
        createdAt,
        createdBy,
        updatedAt,
        updatedBy,
        deletedAt,
        deletedBy
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipe_likes';
  @override
  VerificationContext validateIntegrity(Insertable<RecipeLike> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta,
          accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('recipe_id')) {
      context.handle(_recipeIdMeta,
          recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta));
    } else if (isInserting) {
      context.missing(_recipeIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('updated_by')) {
      context.handle(_updatedByMeta,
          updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta));
    } else if (isInserting) {
      context.missing(_updatedByMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('deleted_by')) {
      context.handle(_deletedByMeta,
          deletedBy.isAcceptableOrUnknown(data['deleted_by']!, _deletedByMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {accountId, recipeId};
  @override
  RecipeLike map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecipeLike(
      accountId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}account_id'])!,
      recipeId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}recipe_id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      createdBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_by'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      updatedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_by'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
      deletedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}deleted_by']),
    );
  }

  @override
  RecipeLikes createAlias(String alias) {
    return RecipeLikes(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
        'CONSTRAINT recipe_like_pkey PRIMARY KEY(account_id, recipe_id)',
        'CONSTRAINT recipe_like_account_id_fkey FOREIGN KEY(account_id)REFERENCES accounts(id)ON DELETE CASCADE',
        'CONSTRAINT recipe_like_recipe_id_fkey FOREIGN KEY(recipe_id)REFERENCES recipes(id)ON DELETE CASCADE'
      ];
  @override
  bool get dontWriteConstraints => true;
}

class RecipeLike extends DataClass implements Insertable<RecipeLike> {
  final int accountId;
  final int recipeId;
  final DateTime createdAt;
  final int createdBy;
  final DateTime updatedAt;
  final int updatedBy;
  final DateTime? deletedAt;
  final int? deletedBy;
  const RecipeLike(
      {required this.accountId,
      required this.recipeId,
      required this.createdAt,
      required this.createdBy,
      required this.updatedAt,
      required this.updatedBy,
      this.deletedAt,
      this.deletedBy});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['account_id'] = Variable<int>(accountId);
    map['recipe_id'] = Variable<int>(recipeId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['created_by'] = Variable<int>(createdBy);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['updated_by'] = Variable<int>(updatedBy);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || deletedBy != null) {
      map['deleted_by'] = Variable<int>(deletedBy);
    }
    return map;
  }

  RecipeLikesCompanion toCompanion(bool nullToAbsent) {
    return RecipeLikesCompanion(
      accountId: Value(accountId),
      recipeId: Value(recipeId),
      createdAt: Value(createdAt),
      createdBy: Value(createdBy),
      updatedAt: Value(updatedAt),
      updatedBy: Value(updatedBy),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deletedBy: deletedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedBy),
    );
  }

  factory RecipeLike.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecipeLike(
      accountId: serializer.fromJson<int>(json['account_id']),
      recipeId: serializer.fromJson<int>(json['recipe_id']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      createdBy: serializer.fromJson<int>(json['created_by']),
      updatedAt: serializer.fromJson<DateTime>(json['updated_at']),
      updatedBy: serializer.fromJson<int>(json['updated_by']),
      deletedAt: serializer.fromJson<DateTime?>(json['deleted_at']),
      deletedBy: serializer.fromJson<int?>(json['deleted_by']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'account_id': serializer.toJson<int>(accountId),
      'recipe_id': serializer.toJson<int>(recipeId),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'created_by': serializer.toJson<int>(createdBy),
      'updated_at': serializer.toJson<DateTime>(updatedAt),
      'updated_by': serializer.toJson<int>(updatedBy),
      'deleted_at': serializer.toJson<DateTime?>(deletedAt),
      'deleted_by': serializer.toJson<int?>(deletedBy),
    };
  }

  RecipeLike copyWith(
          {int? accountId,
          int? recipeId,
          DateTime? createdAt,
          int? createdBy,
          DateTime? updatedAt,
          int? updatedBy,
          Value<DateTime?> deletedAt = const Value.absent(),
          Value<int?> deletedBy = const Value.absent()}) =>
      RecipeLike(
        accountId: accountId ?? this.accountId,
        recipeId: recipeId ?? this.recipeId,
        createdAt: createdAt ?? this.createdAt,
        createdBy: createdBy ?? this.createdBy,
        updatedAt: updatedAt ?? this.updatedAt,
        updatedBy: updatedBy ?? this.updatedBy,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        deletedBy: deletedBy.present ? deletedBy.value : this.deletedBy,
      );
  RecipeLike copyWithCompanion(RecipeLikesCompanion data) {
    return RecipeLike(
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deletedBy: data.deletedBy.present ? data.deletedBy.value : this.deletedBy,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecipeLike(')
          ..write('accountId: $accountId, ')
          ..write('recipeId: $recipeId, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deletedBy: $deletedBy')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(accountId, recipeId, createdAt, createdBy,
      updatedAt, updatedBy, deletedAt, deletedBy);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecipeLike &&
          other.accountId == this.accountId &&
          other.recipeId == this.recipeId &&
          other.createdAt == this.createdAt &&
          other.createdBy == this.createdBy &&
          other.updatedAt == this.updatedAt &&
          other.updatedBy == this.updatedBy &&
          other.deletedAt == this.deletedAt &&
          other.deletedBy == this.deletedBy);
}

class RecipeLikesCompanion extends UpdateCompanion<RecipeLike> {
  final Value<int> accountId;
  final Value<int> recipeId;
  final Value<DateTime> createdAt;
  final Value<int> createdBy;
  final Value<DateTime> updatedAt;
  final Value<int> updatedBy;
  final Value<DateTime?> deletedAt;
  final Value<int?> deletedBy;
  final Value<int> rowid;
  const RecipeLikesCompanion({
    this.accountId = const Value.absent(),
    this.recipeId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deletedBy = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecipeLikesCompanion.insert({
    required int accountId,
    required int recipeId,
    required DateTime createdAt,
    required int createdBy,
    required DateTime updatedAt,
    required int updatedBy,
    this.deletedAt = const Value.absent(),
    this.deletedBy = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : accountId = Value(accountId),
        recipeId = Value(recipeId),
        createdAt = Value(createdAt),
        createdBy = Value(createdBy),
        updatedAt = Value(updatedAt),
        updatedBy = Value(updatedBy);
  static Insertable<RecipeLike> custom({
    Expression<int>? accountId,
    Expression<int>? recipeId,
    Expression<DateTime>? createdAt,
    Expression<int>? createdBy,
    Expression<DateTime>? updatedAt,
    Expression<int>? updatedBy,
    Expression<DateTime>? deletedAt,
    Expression<int>? deletedBy,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (accountId != null) 'account_id': accountId,
      if (recipeId != null) 'recipe_id': recipeId,
      if (createdAt != null) 'created_at': createdAt,
      if (createdBy != null) 'created_by': createdBy,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deletedBy != null) 'deleted_by': deletedBy,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecipeLikesCompanion copyWith(
      {Value<int>? accountId,
      Value<int>? recipeId,
      Value<DateTime>? createdAt,
      Value<int>? createdBy,
      Value<DateTime>? updatedAt,
      Value<int>? updatedBy,
      Value<DateTime?>? deletedAt,
      Value<int?>? deletedBy,
      Value<int>? rowid}) {
    return RecipeLikesCompanion(
      accountId: accountId ?? this.accountId,
      recipeId: recipeId ?? this.recipeId,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      deletedAt: deletedAt ?? this.deletedAt,
      deletedBy: deletedBy ?? this.deletedBy,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (recipeId.present) {
      map['recipe_id'] = Variable<int>(recipeId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<int>(createdBy.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<int>(updatedBy.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (deletedBy.present) {
      map['deleted_by'] = Variable<int>(deletedBy.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecipeLikesCompanion(')
          ..write('accountId: $accountId, ')
          ..write('recipeId: $recipeId, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deletedBy: $deletedBy, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class ShoppingLists extends Table with TableInfo<ShoppingLists, ShoppingList> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  ShoppingLists(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _accountIdMeta =
      const VerificationMeta('accountId');
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
      'account_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _createdByMeta =
      const VerificationMeta('createdBy');
  late final GeneratedColumn<int> createdBy = GeneratedColumn<int>(
      'created_by', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _updatedByMeta =
      const VerificationMeta('updatedBy');
  late final GeneratedColumn<int> updatedBy = GeneratedColumn<int>(
      'updated_by', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  static const VerificationMeta _deletedByMeta =
      const VerificationMeta('deletedBy');
  late final GeneratedColumn<int> deletedBy = GeneratedColumn<int>(
      'deleted_by', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  @override
  List<GeneratedColumn> get $columns => [
        id,
        accountId,
        name,
        createdAt,
        createdBy,
        updatedAt,
        updatedBy,
        deletedAt,
        deletedBy
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shopping_lists';
  @override
  VerificationContext validateIntegrity(Insertable<ShoppingList> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta,
          accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('updated_by')) {
      context.handle(_updatedByMeta,
          updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta));
    } else if (isInserting) {
      context.missing(_updatedByMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('deleted_by')) {
      context.handle(_deletedByMeta,
          deletedBy.isAcceptableOrUnknown(data['deleted_by']!, _deletedByMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShoppingList map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShoppingList(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      accountId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}account_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      createdBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_by'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      updatedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_by'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
      deletedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}deleted_by']),
    );
  }

  @override
  ShoppingLists createAlias(String alias) {
    return ShoppingLists(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
        'CONSTRAINT shopping_list_pkey PRIMARY KEY(id)',
        'CONSTRAINT shopping_list_account_id_fkey FOREIGN KEY(account_id)REFERENCES accounts(id)ON DELETE CASCADE'
      ];
  @override
  bool get dontWriteConstraints => true;
}

class ShoppingList extends DataClass implements Insertable<ShoppingList> {
  final int id;
  final int accountId;
  final String name;
  final DateTime createdAt;
  final int createdBy;
  final DateTime updatedAt;
  final int updatedBy;
  final DateTime? deletedAt;
  final int? deletedBy;
  const ShoppingList(
      {required this.id,
      required this.accountId,
      required this.name,
      required this.createdAt,
      required this.createdBy,
      required this.updatedAt,
      required this.updatedBy,
      this.deletedAt,
      this.deletedBy});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['account_id'] = Variable<int>(accountId);
    map['name'] = Variable<String>(name);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['created_by'] = Variable<int>(createdBy);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['updated_by'] = Variable<int>(updatedBy);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || deletedBy != null) {
      map['deleted_by'] = Variable<int>(deletedBy);
    }
    return map;
  }

  ShoppingListsCompanion toCompanion(bool nullToAbsent) {
    return ShoppingListsCompanion(
      id: Value(id),
      accountId: Value(accountId),
      name: Value(name),
      createdAt: Value(createdAt),
      createdBy: Value(createdBy),
      updatedAt: Value(updatedAt),
      updatedBy: Value(updatedBy),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deletedBy: deletedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedBy),
    );
  }

  factory ShoppingList.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShoppingList(
      id: serializer.fromJson<int>(json['id']),
      accountId: serializer.fromJson<int>(json['account_id']),
      name: serializer.fromJson<String>(json['name']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      createdBy: serializer.fromJson<int>(json['created_by']),
      updatedAt: serializer.fromJson<DateTime>(json['updated_at']),
      updatedBy: serializer.fromJson<int>(json['updated_by']),
      deletedAt: serializer.fromJson<DateTime?>(json['deleted_at']),
      deletedBy: serializer.fromJson<int?>(json['deleted_by']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'account_id': serializer.toJson<int>(accountId),
      'name': serializer.toJson<String>(name),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'created_by': serializer.toJson<int>(createdBy),
      'updated_at': serializer.toJson<DateTime>(updatedAt),
      'updated_by': serializer.toJson<int>(updatedBy),
      'deleted_at': serializer.toJson<DateTime?>(deletedAt),
      'deleted_by': serializer.toJson<int?>(deletedBy),
    };
  }

  ShoppingList copyWith(
          {int? id,
          int? accountId,
          String? name,
          DateTime? createdAt,
          int? createdBy,
          DateTime? updatedAt,
          int? updatedBy,
          Value<DateTime?> deletedAt = const Value.absent(),
          Value<int?> deletedBy = const Value.absent()}) =>
      ShoppingList(
        id: id ?? this.id,
        accountId: accountId ?? this.accountId,
        name: name ?? this.name,
        createdAt: createdAt ?? this.createdAt,
        createdBy: createdBy ?? this.createdBy,
        updatedAt: updatedAt ?? this.updatedAt,
        updatedBy: updatedBy ?? this.updatedBy,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        deletedBy: deletedBy.present ? deletedBy.value : this.deletedBy,
      );
  ShoppingList copyWithCompanion(ShoppingListsCompanion data) {
    return ShoppingList(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      name: data.name.present ? data.name.value : this.name,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deletedBy: data.deletedBy.present ? data.deletedBy.value : this.deletedBy,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingList(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deletedBy: $deletedBy')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, accountId, name, createdAt, createdBy,
      updatedAt, updatedBy, deletedAt, deletedBy);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShoppingList &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.name == this.name &&
          other.createdAt == this.createdAt &&
          other.createdBy == this.createdBy &&
          other.updatedAt == this.updatedAt &&
          other.updatedBy == this.updatedBy &&
          other.deletedAt == this.deletedAt &&
          other.deletedBy == this.deletedBy);
}

class ShoppingListsCompanion extends UpdateCompanion<ShoppingList> {
  final Value<int> id;
  final Value<int> accountId;
  final Value<String> name;
  final Value<DateTime> createdAt;
  final Value<int> createdBy;
  final Value<DateTime> updatedAt;
  final Value<int> updatedBy;
  final Value<DateTime?> deletedAt;
  final Value<int?> deletedBy;
  const ShoppingListsCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deletedBy = const Value.absent(),
  });
  ShoppingListsCompanion.insert({
    this.id = const Value.absent(),
    required int accountId,
    required String name,
    required DateTime createdAt,
    required int createdBy,
    required DateTime updatedAt,
    required int updatedBy,
    this.deletedAt = const Value.absent(),
    this.deletedBy = const Value.absent(),
  })  : accountId = Value(accountId),
        name = Value(name),
        createdAt = Value(createdAt),
        createdBy = Value(createdBy),
        updatedAt = Value(updatedAt),
        updatedBy = Value(updatedBy);
  static Insertable<ShoppingList> custom({
    Expression<int>? id,
    Expression<int>? accountId,
    Expression<String>? name,
    Expression<DateTime>? createdAt,
    Expression<int>? createdBy,
    Expression<DateTime>? updatedAt,
    Expression<int>? updatedBy,
    Expression<DateTime>? deletedAt,
    Expression<int>? deletedBy,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
      if (createdBy != null) 'created_by': createdBy,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deletedBy != null) 'deleted_by': deletedBy,
    });
  }

  ShoppingListsCompanion copyWith(
      {Value<int>? id,
      Value<int>? accountId,
      Value<String>? name,
      Value<DateTime>? createdAt,
      Value<int>? createdBy,
      Value<DateTime>? updatedAt,
      Value<int>? updatedBy,
      Value<DateTime?>? deletedAt,
      Value<int?>? deletedBy}) {
    return ShoppingListsCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      deletedAt: deletedAt ?? this.deletedAt,
      deletedBy: deletedBy ?? this.deletedBy,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<int>(createdBy.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<int>(updatedBy.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (deletedBy.present) {
      map['deleted_by'] = Variable<int>(deletedBy.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingListsCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deletedBy: $deletedBy')
          ..write(')'))
        .toString();
  }
}

class ShoppingListSections extends Table
    with TableInfo<ShoppingListSections, ShoppingListSection> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  ShoppingListSections(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _shoppingListIdMeta =
      const VerificationMeta('shoppingListId');
  late final GeneratedColumn<int> shoppingListId = GeneratedColumn<int>(
      'shopping_list_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL DEFAULT 0',
      defaultValue: const CustomExpression('0'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _createdByMeta =
      const VerificationMeta('createdBy');
  late final GeneratedColumn<int> createdBy = GeneratedColumn<int>(
      'created_by', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _updatedByMeta =
      const VerificationMeta('updatedBy');
  late final GeneratedColumn<int> updatedBy = GeneratedColumn<int>(
      'updated_by', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  static const VerificationMeta _deletedByMeta =
      const VerificationMeta('deletedBy');
  late final GeneratedColumn<int> deletedBy = GeneratedColumn<int>(
      'deleted_by', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  @override
  List<GeneratedColumn> get $columns => [
        id,
        shoppingListId,
        name,
        sortOrder,
        createdAt,
        createdBy,
        updatedAt,
        updatedBy,
        deletedAt,
        deletedBy
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shopping_list_sections';
  @override
  VerificationContext validateIntegrity(
      Insertable<ShoppingListSection> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('shopping_list_id')) {
      context.handle(
          _shoppingListIdMeta,
          shoppingListId.isAcceptableOrUnknown(
              data['shopping_list_id']!, _shoppingListIdMeta));
    } else if (isInserting) {
      context.missing(_shoppingListIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('updated_by')) {
      context.handle(_updatedByMeta,
          updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta));
    } else if (isInserting) {
      context.missing(_updatedByMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('deleted_by')) {
      context.handle(_deletedByMeta,
          deletedBy.isAcceptableOrUnknown(data['deleted_by']!, _deletedByMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShoppingListSection map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShoppingListSection(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      shoppingListId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}shopping_list_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      createdBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_by'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      updatedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_by'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
      deletedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}deleted_by']),
    );
  }

  @override
  ShoppingListSections createAlias(String alias) {
    return ShoppingListSections(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
        'CONSTRAINT shopping_list_section_pkey PRIMARY KEY(id)',
        'CONSTRAINT shopping_list_section_list_id_fkey FOREIGN KEY(shopping_list_id)REFERENCES shopping_lists(id)ON DELETE CASCADE'
      ];
  @override
  bool get dontWriteConstraints => true;
}

class ShoppingListSection extends DataClass
    implements Insertable<ShoppingListSection> {
  final int id;
  final int shoppingListId;
  final String name;
  final int sortOrder;
  final DateTime createdAt;
  final int createdBy;
  final DateTime updatedAt;
  final int updatedBy;
  final DateTime? deletedAt;
  final int? deletedBy;
  const ShoppingListSection(
      {required this.id,
      required this.shoppingListId,
      required this.name,
      required this.sortOrder,
      required this.createdAt,
      required this.createdBy,
      required this.updatedAt,
      required this.updatedBy,
      this.deletedAt,
      this.deletedBy});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['shopping_list_id'] = Variable<int>(shoppingListId);
    map['name'] = Variable<String>(name);
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['created_by'] = Variable<int>(createdBy);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['updated_by'] = Variable<int>(updatedBy);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || deletedBy != null) {
      map['deleted_by'] = Variable<int>(deletedBy);
    }
    return map;
  }

  ShoppingListSectionsCompanion toCompanion(bool nullToAbsent) {
    return ShoppingListSectionsCompanion(
      id: Value(id),
      shoppingListId: Value(shoppingListId),
      name: Value(name),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
      createdBy: Value(createdBy),
      updatedAt: Value(updatedAt),
      updatedBy: Value(updatedBy),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deletedBy: deletedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedBy),
    );
  }

  factory ShoppingListSection.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShoppingListSection(
      id: serializer.fromJson<int>(json['id']),
      shoppingListId: serializer.fromJson<int>(json['shopping_list_id']),
      name: serializer.fromJson<String>(json['name']),
      sortOrder: serializer.fromJson<int>(json['sort_order']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      createdBy: serializer.fromJson<int>(json['created_by']),
      updatedAt: serializer.fromJson<DateTime>(json['updated_at']),
      updatedBy: serializer.fromJson<int>(json['updated_by']),
      deletedAt: serializer.fromJson<DateTime?>(json['deleted_at']),
      deletedBy: serializer.fromJson<int?>(json['deleted_by']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'shopping_list_id': serializer.toJson<int>(shoppingListId),
      'name': serializer.toJson<String>(name),
      'sort_order': serializer.toJson<int>(sortOrder),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'created_by': serializer.toJson<int>(createdBy),
      'updated_at': serializer.toJson<DateTime>(updatedAt),
      'updated_by': serializer.toJson<int>(updatedBy),
      'deleted_at': serializer.toJson<DateTime?>(deletedAt),
      'deleted_by': serializer.toJson<int?>(deletedBy),
    };
  }

  ShoppingListSection copyWith(
          {int? id,
          int? shoppingListId,
          String? name,
          int? sortOrder,
          DateTime? createdAt,
          int? createdBy,
          DateTime? updatedAt,
          int? updatedBy,
          Value<DateTime?> deletedAt = const Value.absent(),
          Value<int?> deletedBy = const Value.absent()}) =>
      ShoppingListSection(
        id: id ?? this.id,
        shoppingListId: shoppingListId ?? this.shoppingListId,
        name: name ?? this.name,
        sortOrder: sortOrder ?? this.sortOrder,
        createdAt: createdAt ?? this.createdAt,
        createdBy: createdBy ?? this.createdBy,
        updatedAt: updatedAt ?? this.updatedAt,
        updatedBy: updatedBy ?? this.updatedBy,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        deletedBy: deletedBy.present ? deletedBy.value : this.deletedBy,
      );
  ShoppingListSection copyWithCompanion(ShoppingListSectionsCompanion data) {
    return ShoppingListSection(
      id: data.id.present ? data.id.value : this.id,
      shoppingListId: data.shoppingListId.present
          ? data.shoppingListId.value
          : this.shoppingListId,
      name: data.name.present ? data.name.value : this.name,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deletedBy: data.deletedBy.present ? data.deletedBy.value : this.deletedBy,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingListSection(')
          ..write('id: $id, ')
          ..write('shoppingListId: $shoppingListId, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deletedBy: $deletedBy')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, shoppingListId, name, sortOrder,
      createdAt, createdBy, updatedAt, updatedBy, deletedAt, deletedBy);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShoppingListSection &&
          other.id == this.id &&
          other.shoppingListId == this.shoppingListId &&
          other.name == this.name &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt &&
          other.createdBy == this.createdBy &&
          other.updatedAt == this.updatedAt &&
          other.updatedBy == this.updatedBy &&
          other.deletedAt == this.deletedAt &&
          other.deletedBy == this.deletedBy);
}

class ShoppingListSectionsCompanion
    extends UpdateCompanion<ShoppingListSection> {
  final Value<int> id;
  final Value<int> shoppingListId;
  final Value<String> name;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  final Value<int> createdBy;
  final Value<DateTime> updatedAt;
  final Value<int> updatedBy;
  final Value<DateTime?> deletedAt;
  final Value<int?> deletedBy;
  const ShoppingListSectionsCompanion({
    this.id = const Value.absent(),
    this.shoppingListId = const Value.absent(),
    this.name = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deletedBy = const Value.absent(),
  });
  ShoppingListSectionsCompanion.insert({
    this.id = const Value.absent(),
    required int shoppingListId,
    required String name,
    this.sortOrder = const Value.absent(),
    required DateTime createdAt,
    required int createdBy,
    required DateTime updatedAt,
    required int updatedBy,
    this.deletedAt = const Value.absent(),
    this.deletedBy = const Value.absent(),
  })  : shoppingListId = Value(shoppingListId),
        name = Value(name),
        createdAt = Value(createdAt),
        createdBy = Value(createdBy),
        updatedAt = Value(updatedAt),
        updatedBy = Value(updatedBy);
  static Insertable<ShoppingListSection> custom({
    Expression<int>? id,
    Expression<int>? shoppingListId,
    Expression<String>? name,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
    Expression<int>? createdBy,
    Expression<DateTime>? updatedAt,
    Expression<int>? updatedBy,
    Expression<DateTime>? deletedAt,
    Expression<int>? deletedBy,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (shoppingListId != null) 'shopping_list_id': shoppingListId,
      if (name != null) 'name': name,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (createdBy != null) 'created_by': createdBy,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deletedBy != null) 'deleted_by': deletedBy,
    });
  }

  ShoppingListSectionsCompanion copyWith(
      {Value<int>? id,
      Value<int>? shoppingListId,
      Value<String>? name,
      Value<int>? sortOrder,
      Value<DateTime>? createdAt,
      Value<int>? createdBy,
      Value<DateTime>? updatedAt,
      Value<int>? updatedBy,
      Value<DateTime?>? deletedAt,
      Value<int?>? deletedBy}) {
    return ShoppingListSectionsCompanion(
      id: id ?? this.id,
      shoppingListId: shoppingListId ?? this.shoppingListId,
      name: name ?? this.name,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      deletedAt: deletedAt ?? this.deletedAt,
      deletedBy: deletedBy ?? this.deletedBy,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (shoppingListId.present) {
      map['shopping_list_id'] = Variable<int>(shoppingListId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<int>(createdBy.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<int>(updatedBy.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (deletedBy.present) {
      map['deleted_by'] = Variable<int>(deletedBy.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingListSectionsCompanion(')
          ..write('id: $id, ')
          ..write('shoppingListId: $shoppingListId, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deletedBy: $deletedBy')
          ..write(')'))
        .toString();
  }
}

class ShoppingListItems extends Table
    with TableInfo<ShoppingListItems, ShoppingListItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  ShoppingListItems(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _shoppingListIdMeta =
      const VerificationMeta('shoppingListId');
  late final GeneratedColumn<int> shoppingListId = GeneratedColumn<int>(
      'shopping_list_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _sectionIdMeta =
      const VerificationMeta('sectionId');
  late final GeneratedColumn<int> sectionId = GeneratedColumn<int>(
      'section_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  static const VerificationMeta _ingredientIdMeta =
      const VerificationMeta('ingredientId');
  late final GeneratedColumn<int> ingredientId = GeneratedColumn<int>(
      'ingredient_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, true,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  static const VerificationMeta _shoppingCategoryCodeMeta =
      const VerificationMeta('shoppingCategoryCode');
  late final GeneratedColumn<String> shoppingCategoryCode =
      GeneratedColumn<String>('shopping_category_code', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          $customConstraints: 'NOT NULL DEFAULT \'other\'',
          defaultValue: const CustomExpression('\'other\''));
  static const VerificationMeta _checkedMeta =
      const VerificationMeta('checked');
  late final GeneratedColumn<bool> checked = GeneratedColumn<bool>(
      'checked', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _createdByMeta =
      const VerificationMeta('createdBy');
  late final GeneratedColumn<int> createdBy = GeneratedColumn<int>(
      'created_by', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _updatedByMeta =
      const VerificationMeta('updatedBy');
  late final GeneratedColumn<int> updatedBy = GeneratedColumn<int>(
      'updated_by', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  static const VerificationMeta _deletedByMeta =
      const VerificationMeta('deletedBy');
  late final GeneratedColumn<int> deletedBy = GeneratedColumn<int>(
      'deleted_by', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  @override
  List<GeneratedColumn> get $columns => [
        id,
        shoppingListId,
        sectionId,
        ingredientId,
        name,
        amount,
        unit,
        note,
        shoppingCategoryCode,
        checked,
        createdAt,
        createdBy,
        updatedAt,
        updatedBy,
        deletedAt,
        deletedBy
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shopping_list_items';
  @override
  VerificationContext validateIntegrity(Insertable<ShoppingListItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('shopping_list_id')) {
      context.handle(
          _shoppingListIdMeta,
          shoppingListId.isAcceptableOrUnknown(
              data['shopping_list_id']!, _shoppingListIdMeta));
    } else if (isInserting) {
      context.missing(_shoppingListIdMeta);
    }
    if (data.containsKey('section_id')) {
      context.handle(_sectionIdMeta,
          sectionId.isAcceptableOrUnknown(data['section_id']!, _sectionIdMeta));
    }
    if (data.containsKey('ingredient_id')) {
      context.handle(
          _ingredientIdMeta,
          ingredientId.isAcceptableOrUnknown(
              data['ingredient_id']!, _ingredientIdMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('shopping_category_code')) {
      context.handle(
          _shoppingCategoryCodeMeta,
          shoppingCategoryCode.isAcceptableOrUnknown(
              data['shopping_category_code']!, _shoppingCategoryCodeMeta));
    }
    if (data.containsKey('checked')) {
      context.handle(_checkedMeta,
          checked.isAcceptableOrUnknown(data['checked']!, _checkedMeta));
    } else if (isInserting) {
      context.missing(_checkedMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('updated_by')) {
      context.handle(_updatedByMeta,
          updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta));
    } else if (isInserting) {
      context.missing(_updatedByMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('deleted_by')) {
      context.handle(_deletedByMeta,
          deletedBy.isAcceptableOrUnknown(data['deleted_by']!, _deletedByMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShoppingListItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShoppingListItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      shoppingListId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}shopping_list_id'])!,
      sectionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}section_id']),
      ingredientId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ingredient_id']),
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount']),
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit']),
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      shoppingCategoryCode: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}shopping_category_code'])!,
      checked: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}checked'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      createdBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_by'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      updatedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_by'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
      deletedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}deleted_by']),
    );
  }

  @override
  ShoppingListItems createAlias(String alias) {
    return ShoppingListItems(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
        'CONSTRAINT shopping_list_item_pkey PRIMARY KEY(id)',
        'CONSTRAINT shopping_list_item_list_id_fkey FOREIGN KEY(shopping_list_id)REFERENCES shopping_lists(id)ON DELETE CASCADE',
        'CONSTRAINT shopping_list_item_section_id_fkey FOREIGN KEY(section_id)REFERENCES shopping_list_sections(id)',
        'CONSTRAINT shopping_list_item_ingredient_id_fkey FOREIGN KEY(ingredient_id)REFERENCES ingredients(id)ON DELETE SET NULL',
        'CONSTRAINT shopping_list_item_category_fkey FOREIGN KEY(shopping_category_code)REFERENCES shopping_categories(code)ON UPDATE CASCADE'
      ];
  @override
  bool get dontWriteConstraints => true;
}

class ShoppingListItem extends DataClass
    implements Insertable<ShoppingListItem> {
  final int id;
  final int shoppingListId;
  final int? sectionId;
  final int? ingredientId;
  final String name;
  final double? amount;
  final String? unit;
  final String? note;
  final String shoppingCategoryCode;
  final bool checked;
  final DateTime createdAt;
  final int createdBy;
  final DateTime updatedAt;
  final int updatedBy;
  final DateTime? deletedAt;
  final int? deletedBy;
  const ShoppingListItem(
      {required this.id,
      required this.shoppingListId,
      this.sectionId,
      this.ingredientId,
      required this.name,
      this.amount,
      this.unit,
      this.note,
      required this.shoppingCategoryCode,
      required this.checked,
      required this.createdAt,
      required this.createdBy,
      required this.updatedAt,
      required this.updatedBy,
      this.deletedAt,
      this.deletedBy});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['shopping_list_id'] = Variable<int>(shoppingListId);
    if (!nullToAbsent || sectionId != null) {
      map['section_id'] = Variable<int>(sectionId);
    }
    if (!nullToAbsent || ingredientId != null) {
      map['ingredient_id'] = Variable<int>(ingredientId);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || amount != null) {
      map['amount'] = Variable<double>(amount);
    }
    if (!nullToAbsent || unit != null) {
      map['unit'] = Variable<String>(unit);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['shopping_category_code'] = Variable<String>(shoppingCategoryCode);
    map['checked'] = Variable<bool>(checked);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['created_by'] = Variable<int>(createdBy);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['updated_by'] = Variable<int>(updatedBy);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || deletedBy != null) {
      map['deleted_by'] = Variable<int>(deletedBy);
    }
    return map;
  }

  ShoppingListItemsCompanion toCompanion(bool nullToAbsent) {
    return ShoppingListItemsCompanion(
      id: Value(id),
      shoppingListId: Value(shoppingListId),
      sectionId: sectionId == null && nullToAbsent
          ? const Value.absent()
          : Value(sectionId),
      ingredientId: ingredientId == null && nullToAbsent
          ? const Value.absent()
          : Value(ingredientId),
      name: Value(name),
      amount:
          amount == null && nullToAbsent ? const Value.absent() : Value(amount),
      unit: unit == null && nullToAbsent ? const Value.absent() : Value(unit),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      shoppingCategoryCode: Value(shoppingCategoryCode),
      checked: Value(checked),
      createdAt: Value(createdAt),
      createdBy: Value(createdBy),
      updatedAt: Value(updatedAt),
      updatedBy: Value(updatedBy),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deletedBy: deletedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedBy),
    );
  }

  factory ShoppingListItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShoppingListItem(
      id: serializer.fromJson<int>(json['id']),
      shoppingListId: serializer.fromJson<int>(json['shopping_list_id']),
      sectionId: serializer.fromJson<int?>(json['section_id']),
      ingredientId: serializer.fromJson<int?>(json['ingredient_id']),
      name: serializer.fromJson<String>(json['name']),
      amount: serializer.fromJson<double?>(json['amount']),
      unit: serializer.fromJson<String?>(json['unit']),
      note: serializer.fromJson<String?>(json['note']),
      shoppingCategoryCode:
          serializer.fromJson<String>(json['shopping_category_code']),
      checked: serializer.fromJson<bool>(json['checked']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      createdBy: serializer.fromJson<int>(json['created_by']),
      updatedAt: serializer.fromJson<DateTime>(json['updated_at']),
      updatedBy: serializer.fromJson<int>(json['updated_by']),
      deletedAt: serializer.fromJson<DateTime?>(json['deleted_at']),
      deletedBy: serializer.fromJson<int?>(json['deleted_by']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'shopping_list_id': serializer.toJson<int>(shoppingListId),
      'section_id': serializer.toJson<int?>(sectionId),
      'ingredient_id': serializer.toJson<int?>(ingredientId),
      'name': serializer.toJson<String>(name),
      'amount': serializer.toJson<double?>(amount),
      'unit': serializer.toJson<String?>(unit),
      'note': serializer.toJson<String?>(note),
      'shopping_category_code': serializer.toJson<String>(shoppingCategoryCode),
      'checked': serializer.toJson<bool>(checked),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'created_by': serializer.toJson<int>(createdBy),
      'updated_at': serializer.toJson<DateTime>(updatedAt),
      'updated_by': serializer.toJson<int>(updatedBy),
      'deleted_at': serializer.toJson<DateTime?>(deletedAt),
      'deleted_by': serializer.toJson<int?>(deletedBy),
    };
  }

  ShoppingListItem copyWith(
          {int? id,
          int? shoppingListId,
          Value<int?> sectionId = const Value.absent(),
          Value<int?> ingredientId = const Value.absent(),
          String? name,
          Value<double?> amount = const Value.absent(),
          Value<String?> unit = const Value.absent(),
          Value<String?> note = const Value.absent(),
          String? shoppingCategoryCode,
          bool? checked,
          DateTime? createdAt,
          int? createdBy,
          DateTime? updatedAt,
          int? updatedBy,
          Value<DateTime?> deletedAt = const Value.absent(),
          Value<int?> deletedBy = const Value.absent()}) =>
      ShoppingListItem(
        id: id ?? this.id,
        shoppingListId: shoppingListId ?? this.shoppingListId,
        sectionId: sectionId.present ? sectionId.value : this.sectionId,
        ingredientId:
            ingredientId.present ? ingredientId.value : this.ingredientId,
        name: name ?? this.name,
        amount: amount.present ? amount.value : this.amount,
        unit: unit.present ? unit.value : this.unit,
        note: note.present ? note.value : this.note,
        shoppingCategoryCode: shoppingCategoryCode ?? this.shoppingCategoryCode,
        checked: checked ?? this.checked,
        createdAt: createdAt ?? this.createdAt,
        createdBy: createdBy ?? this.createdBy,
        updatedAt: updatedAt ?? this.updatedAt,
        updatedBy: updatedBy ?? this.updatedBy,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        deletedBy: deletedBy.present ? deletedBy.value : this.deletedBy,
      );
  ShoppingListItem copyWithCompanion(ShoppingListItemsCompanion data) {
    return ShoppingListItem(
      id: data.id.present ? data.id.value : this.id,
      shoppingListId: data.shoppingListId.present
          ? data.shoppingListId.value
          : this.shoppingListId,
      sectionId: data.sectionId.present ? data.sectionId.value : this.sectionId,
      ingredientId: data.ingredientId.present
          ? data.ingredientId.value
          : this.ingredientId,
      name: data.name.present ? data.name.value : this.name,
      amount: data.amount.present ? data.amount.value : this.amount,
      unit: data.unit.present ? data.unit.value : this.unit,
      note: data.note.present ? data.note.value : this.note,
      shoppingCategoryCode: data.shoppingCategoryCode.present
          ? data.shoppingCategoryCode.value
          : this.shoppingCategoryCode,
      checked: data.checked.present ? data.checked.value : this.checked,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deletedBy: data.deletedBy.present ? data.deletedBy.value : this.deletedBy,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingListItem(')
          ..write('id: $id, ')
          ..write('shoppingListId: $shoppingListId, ')
          ..write('sectionId: $sectionId, ')
          ..write('ingredientId: $ingredientId, ')
          ..write('name: $name, ')
          ..write('amount: $amount, ')
          ..write('unit: $unit, ')
          ..write('note: $note, ')
          ..write('shoppingCategoryCode: $shoppingCategoryCode, ')
          ..write('checked: $checked, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deletedBy: $deletedBy')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      shoppingListId,
      sectionId,
      ingredientId,
      name,
      amount,
      unit,
      note,
      shoppingCategoryCode,
      checked,
      createdAt,
      createdBy,
      updatedAt,
      updatedBy,
      deletedAt,
      deletedBy);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShoppingListItem &&
          other.id == this.id &&
          other.shoppingListId == this.shoppingListId &&
          other.sectionId == this.sectionId &&
          other.ingredientId == this.ingredientId &&
          other.name == this.name &&
          other.amount == this.amount &&
          other.unit == this.unit &&
          other.note == this.note &&
          other.shoppingCategoryCode == this.shoppingCategoryCode &&
          other.checked == this.checked &&
          other.createdAt == this.createdAt &&
          other.createdBy == this.createdBy &&
          other.updatedAt == this.updatedAt &&
          other.updatedBy == this.updatedBy &&
          other.deletedAt == this.deletedAt &&
          other.deletedBy == this.deletedBy);
}

class ShoppingListItemsCompanion extends UpdateCompanion<ShoppingListItem> {
  final Value<int> id;
  final Value<int> shoppingListId;
  final Value<int?> sectionId;
  final Value<int?> ingredientId;
  final Value<String> name;
  final Value<double?> amount;
  final Value<String?> unit;
  final Value<String?> note;
  final Value<String> shoppingCategoryCode;
  final Value<bool> checked;
  final Value<DateTime> createdAt;
  final Value<int> createdBy;
  final Value<DateTime> updatedAt;
  final Value<int> updatedBy;
  final Value<DateTime?> deletedAt;
  final Value<int?> deletedBy;
  const ShoppingListItemsCompanion({
    this.id = const Value.absent(),
    this.shoppingListId = const Value.absent(),
    this.sectionId = const Value.absent(),
    this.ingredientId = const Value.absent(),
    this.name = const Value.absent(),
    this.amount = const Value.absent(),
    this.unit = const Value.absent(),
    this.note = const Value.absent(),
    this.shoppingCategoryCode = const Value.absent(),
    this.checked = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deletedBy = const Value.absent(),
  });
  ShoppingListItemsCompanion.insert({
    this.id = const Value.absent(),
    required int shoppingListId,
    this.sectionId = const Value.absent(),
    this.ingredientId = const Value.absent(),
    required String name,
    this.amount = const Value.absent(),
    this.unit = const Value.absent(),
    this.note = const Value.absent(),
    this.shoppingCategoryCode = const Value.absent(),
    required bool checked,
    required DateTime createdAt,
    required int createdBy,
    required DateTime updatedAt,
    required int updatedBy,
    this.deletedAt = const Value.absent(),
    this.deletedBy = const Value.absent(),
  })  : shoppingListId = Value(shoppingListId),
        name = Value(name),
        checked = Value(checked),
        createdAt = Value(createdAt),
        createdBy = Value(createdBy),
        updatedAt = Value(updatedAt),
        updatedBy = Value(updatedBy);
  static Insertable<ShoppingListItem> custom({
    Expression<int>? id,
    Expression<int>? shoppingListId,
    Expression<int>? sectionId,
    Expression<int>? ingredientId,
    Expression<String>? name,
    Expression<double>? amount,
    Expression<String>? unit,
    Expression<String>? note,
    Expression<String>? shoppingCategoryCode,
    Expression<bool>? checked,
    Expression<DateTime>? createdAt,
    Expression<int>? createdBy,
    Expression<DateTime>? updatedAt,
    Expression<int>? updatedBy,
    Expression<DateTime>? deletedAt,
    Expression<int>? deletedBy,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (shoppingListId != null) 'shopping_list_id': shoppingListId,
      if (sectionId != null) 'section_id': sectionId,
      if (ingredientId != null) 'ingredient_id': ingredientId,
      if (name != null) 'name': name,
      if (amount != null) 'amount': amount,
      if (unit != null) 'unit': unit,
      if (note != null) 'note': note,
      if (shoppingCategoryCode != null)
        'shopping_category_code': shoppingCategoryCode,
      if (checked != null) 'checked': checked,
      if (createdAt != null) 'created_at': createdAt,
      if (createdBy != null) 'created_by': createdBy,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deletedBy != null) 'deleted_by': deletedBy,
    });
  }

  ShoppingListItemsCompanion copyWith(
      {Value<int>? id,
      Value<int>? shoppingListId,
      Value<int?>? sectionId,
      Value<int?>? ingredientId,
      Value<String>? name,
      Value<double?>? amount,
      Value<String?>? unit,
      Value<String?>? note,
      Value<String>? shoppingCategoryCode,
      Value<bool>? checked,
      Value<DateTime>? createdAt,
      Value<int>? createdBy,
      Value<DateTime>? updatedAt,
      Value<int>? updatedBy,
      Value<DateTime?>? deletedAt,
      Value<int?>? deletedBy}) {
    return ShoppingListItemsCompanion(
      id: id ?? this.id,
      shoppingListId: shoppingListId ?? this.shoppingListId,
      sectionId: sectionId ?? this.sectionId,
      ingredientId: ingredientId ?? this.ingredientId,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      unit: unit ?? this.unit,
      note: note ?? this.note,
      shoppingCategoryCode: shoppingCategoryCode ?? this.shoppingCategoryCode,
      checked: checked ?? this.checked,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      deletedAt: deletedAt ?? this.deletedAt,
      deletedBy: deletedBy ?? this.deletedBy,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (shoppingListId.present) {
      map['shopping_list_id'] = Variable<int>(shoppingListId.value);
    }
    if (sectionId.present) {
      map['section_id'] = Variable<int>(sectionId.value);
    }
    if (ingredientId.present) {
      map['ingredient_id'] = Variable<int>(ingredientId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (shoppingCategoryCode.present) {
      map['shopping_category_code'] =
          Variable<String>(shoppingCategoryCode.value);
    }
    if (checked.present) {
      map['checked'] = Variable<bool>(checked.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<int>(createdBy.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<int>(updatedBy.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (deletedBy.present) {
      map['deleted_by'] = Variable<int>(deletedBy.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingListItemsCompanion(')
          ..write('id: $id, ')
          ..write('shoppingListId: $shoppingListId, ')
          ..write('sectionId: $sectionId, ')
          ..write('ingredientId: $ingredientId, ')
          ..write('name: $name, ')
          ..write('amount: $amount, ')
          ..write('unit: $unit, ')
          ..write('note: $note, ')
          ..write('shoppingCategoryCode: $shoppingCategoryCode, ')
          ..write('checked: $checked, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deletedBy: $deletedBy')
          ..write(')'))
        .toString();
  }
}

class ShoppingListMembers extends Table
    with TableInfo<ShoppingListMembers, ShoppingListMember> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  ShoppingListMembers(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _shoppingListIdMeta =
      const VerificationMeta('shoppingListId');
  late final GeneratedColumn<int> shoppingListId = GeneratedColumn<int>(
      'shopping_list_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _accountIdMeta =
      const VerificationMeta('accountId');
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
      'account_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _permissionMeta =
      const VerificationMeta('permission');
  late final GeneratedColumn<String> permission = GeneratedColumn<String>(
      'permission', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL DEFAULT \'accepted\'',
      defaultValue: const CustomExpression('\'accepted\''));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _createdByMeta =
      const VerificationMeta('createdBy');
  late final GeneratedColumn<int> createdBy = GeneratedColumn<int>(
      'created_by', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _updatedByMeta =
      const VerificationMeta('updatedBy');
  late final GeneratedColumn<int> updatedBy = GeneratedColumn<int>(
      'updated_by', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  static const VerificationMeta _deletedByMeta =
      const VerificationMeta('deletedBy');
  late final GeneratedColumn<int> deletedBy = GeneratedColumn<int>(
      'deleted_by', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  @override
  List<GeneratedColumn> get $columns => [
        shoppingListId,
        accountId,
        permission,
        status,
        createdAt,
        createdBy,
        updatedAt,
        updatedBy,
        deletedAt,
        deletedBy
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shopping_list_members';
  @override
  VerificationContext validateIntegrity(Insertable<ShoppingListMember> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('shopping_list_id')) {
      context.handle(
          _shoppingListIdMeta,
          shoppingListId.isAcceptableOrUnknown(
              data['shopping_list_id']!, _shoppingListIdMeta));
    } else if (isInserting) {
      context.missing(_shoppingListIdMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta,
          accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('permission')) {
      context.handle(
          _permissionMeta,
          permission.isAcceptableOrUnknown(
              data['permission']!, _permissionMeta));
    } else if (isInserting) {
      context.missing(_permissionMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('updated_by')) {
      context.handle(_updatedByMeta,
          updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta));
    } else if (isInserting) {
      context.missing(_updatedByMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('deleted_by')) {
      context.handle(_deletedByMeta,
          deletedBy.isAcceptableOrUnknown(data['deleted_by']!, _deletedByMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {shoppingListId, accountId};
  @override
  ShoppingListMember map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShoppingListMember(
      shoppingListId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}shopping_list_id'])!,
      accountId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}account_id'])!,
      permission: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}permission'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      createdBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_by'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      updatedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_by'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
      deletedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}deleted_by']),
    );
  }

  @override
  ShoppingListMembers createAlias(String alias) {
    return ShoppingListMembers(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
        'CONSTRAINT shopping_list_member_pkey PRIMARY KEY(shopping_list_id, account_id)',
        'CONSTRAINT shopping_list_member_list_fkey FOREIGN KEY(shopping_list_id)REFERENCES shopping_lists(id)ON DELETE CASCADE',
        'CONSTRAINT shopping_list_member_account_fkey FOREIGN KEY(account_id)REFERENCES accounts(id)ON DELETE CASCADE'
      ];
  @override
  bool get dontWriteConstraints => true;
}

class ShoppingListMember extends DataClass
    implements Insertable<ShoppingListMember> {
  final int shoppingListId;
  final int accountId;
  final String permission;
  final String status;
  final DateTime createdAt;
  final int createdBy;
  final DateTime updatedAt;
  final int updatedBy;
  final DateTime? deletedAt;
  final int? deletedBy;
  const ShoppingListMember(
      {required this.shoppingListId,
      required this.accountId,
      required this.permission,
      required this.status,
      required this.createdAt,
      required this.createdBy,
      required this.updatedAt,
      required this.updatedBy,
      this.deletedAt,
      this.deletedBy});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['shopping_list_id'] = Variable<int>(shoppingListId);
    map['account_id'] = Variable<int>(accountId);
    map['permission'] = Variable<String>(permission);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['created_by'] = Variable<int>(createdBy);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['updated_by'] = Variable<int>(updatedBy);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || deletedBy != null) {
      map['deleted_by'] = Variable<int>(deletedBy);
    }
    return map;
  }

  ShoppingListMembersCompanion toCompanion(bool nullToAbsent) {
    return ShoppingListMembersCompanion(
      shoppingListId: Value(shoppingListId),
      accountId: Value(accountId),
      permission: Value(permission),
      status: Value(status),
      createdAt: Value(createdAt),
      createdBy: Value(createdBy),
      updatedAt: Value(updatedAt),
      updatedBy: Value(updatedBy),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deletedBy: deletedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedBy),
    );
  }

  factory ShoppingListMember.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShoppingListMember(
      shoppingListId: serializer.fromJson<int>(json['shopping_list_id']),
      accountId: serializer.fromJson<int>(json['account_id']),
      permission: serializer.fromJson<String>(json['permission']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      createdBy: serializer.fromJson<int>(json['created_by']),
      updatedAt: serializer.fromJson<DateTime>(json['updated_at']),
      updatedBy: serializer.fromJson<int>(json['updated_by']),
      deletedAt: serializer.fromJson<DateTime?>(json['deleted_at']),
      deletedBy: serializer.fromJson<int?>(json['deleted_by']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'shopping_list_id': serializer.toJson<int>(shoppingListId),
      'account_id': serializer.toJson<int>(accountId),
      'permission': serializer.toJson<String>(permission),
      'status': serializer.toJson<String>(status),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'created_by': serializer.toJson<int>(createdBy),
      'updated_at': serializer.toJson<DateTime>(updatedAt),
      'updated_by': serializer.toJson<int>(updatedBy),
      'deleted_at': serializer.toJson<DateTime?>(deletedAt),
      'deleted_by': serializer.toJson<int?>(deletedBy),
    };
  }

  ShoppingListMember copyWith(
          {int? shoppingListId,
          int? accountId,
          String? permission,
          String? status,
          DateTime? createdAt,
          int? createdBy,
          DateTime? updatedAt,
          int? updatedBy,
          Value<DateTime?> deletedAt = const Value.absent(),
          Value<int?> deletedBy = const Value.absent()}) =>
      ShoppingListMember(
        shoppingListId: shoppingListId ?? this.shoppingListId,
        accountId: accountId ?? this.accountId,
        permission: permission ?? this.permission,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        createdBy: createdBy ?? this.createdBy,
        updatedAt: updatedAt ?? this.updatedAt,
        updatedBy: updatedBy ?? this.updatedBy,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        deletedBy: deletedBy.present ? deletedBy.value : this.deletedBy,
      );
  ShoppingListMember copyWithCompanion(ShoppingListMembersCompanion data) {
    return ShoppingListMember(
      shoppingListId: data.shoppingListId.present
          ? data.shoppingListId.value
          : this.shoppingListId,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      permission:
          data.permission.present ? data.permission.value : this.permission,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deletedBy: data.deletedBy.present ? data.deletedBy.value : this.deletedBy,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingListMember(')
          ..write('shoppingListId: $shoppingListId, ')
          ..write('accountId: $accountId, ')
          ..write('permission: $permission, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deletedBy: $deletedBy')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(shoppingListId, accountId, permission, status,
      createdAt, createdBy, updatedAt, updatedBy, deletedAt, deletedBy);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShoppingListMember &&
          other.shoppingListId == this.shoppingListId &&
          other.accountId == this.accountId &&
          other.permission == this.permission &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.createdBy == this.createdBy &&
          other.updatedAt == this.updatedAt &&
          other.updatedBy == this.updatedBy &&
          other.deletedAt == this.deletedAt &&
          other.deletedBy == this.deletedBy);
}

class ShoppingListMembersCompanion extends UpdateCompanion<ShoppingListMember> {
  final Value<int> shoppingListId;
  final Value<int> accountId;
  final Value<String> permission;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<int> createdBy;
  final Value<DateTime> updatedAt;
  final Value<int> updatedBy;
  final Value<DateTime?> deletedAt;
  final Value<int?> deletedBy;
  final Value<int> rowid;
  const ShoppingListMembersCompanion({
    this.shoppingListId = const Value.absent(),
    this.accountId = const Value.absent(),
    this.permission = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deletedBy = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShoppingListMembersCompanion.insert({
    required int shoppingListId,
    required int accountId,
    required String permission,
    this.status = const Value.absent(),
    required DateTime createdAt,
    required int createdBy,
    required DateTime updatedAt,
    required int updatedBy,
    this.deletedAt = const Value.absent(),
    this.deletedBy = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : shoppingListId = Value(shoppingListId),
        accountId = Value(accountId),
        permission = Value(permission),
        createdAt = Value(createdAt),
        createdBy = Value(createdBy),
        updatedAt = Value(updatedAt),
        updatedBy = Value(updatedBy);
  static Insertable<ShoppingListMember> custom({
    Expression<int>? shoppingListId,
    Expression<int>? accountId,
    Expression<String>? permission,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<int>? createdBy,
    Expression<DateTime>? updatedAt,
    Expression<int>? updatedBy,
    Expression<DateTime>? deletedAt,
    Expression<int>? deletedBy,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (shoppingListId != null) 'shopping_list_id': shoppingListId,
      if (accountId != null) 'account_id': accountId,
      if (permission != null) 'permission': permission,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (createdBy != null) 'created_by': createdBy,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deletedBy != null) 'deleted_by': deletedBy,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShoppingListMembersCompanion copyWith(
      {Value<int>? shoppingListId,
      Value<int>? accountId,
      Value<String>? permission,
      Value<String>? status,
      Value<DateTime>? createdAt,
      Value<int>? createdBy,
      Value<DateTime>? updatedAt,
      Value<int>? updatedBy,
      Value<DateTime?>? deletedAt,
      Value<int?>? deletedBy,
      Value<int>? rowid}) {
    return ShoppingListMembersCompanion(
      shoppingListId: shoppingListId ?? this.shoppingListId,
      accountId: accountId ?? this.accountId,
      permission: permission ?? this.permission,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      deletedAt: deletedAt ?? this.deletedAt,
      deletedBy: deletedBy ?? this.deletedBy,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (shoppingListId.present) {
      map['shopping_list_id'] = Variable<int>(shoppingListId.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (permission.present) {
      map['permission'] = Variable<String>(permission.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<int>(createdBy.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<int>(updatedBy.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (deletedBy.present) {
      map['deleted_by'] = Variable<int>(deletedBy.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingListMembersCompanion(')
          ..write('shoppingListId: $shoppingListId, ')
          ..write('accountId: $accountId, ')
          ..write('permission: $permission, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deletedBy: $deletedBy, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class MealPlans extends Table with TableInfo<MealPlans, MealPlan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  MealPlans(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _accountIdMeta =
      const VerificationMeta('accountId');
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
      'account_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _createdByMeta =
      const VerificationMeta('createdBy');
  late final GeneratedColumn<int> createdBy = GeneratedColumn<int>(
      'created_by', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _updatedByMeta =
      const VerificationMeta('updatedBy');
  late final GeneratedColumn<int> updatedBy = GeneratedColumn<int>(
      'updated_by', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  static const VerificationMeta _deletedByMeta =
      const VerificationMeta('deletedBy');
  late final GeneratedColumn<int> deletedBy = GeneratedColumn<int>(
      'deleted_by', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  @override
  List<GeneratedColumn> get $columns => [
        id,
        accountId,
        name,
        createdAt,
        createdBy,
        updatedAt,
        updatedBy,
        deletedAt,
        deletedBy
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meal_plans';
  @override
  VerificationContext validateIntegrity(Insertable<MealPlan> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta,
          accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('updated_by')) {
      context.handle(_updatedByMeta,
          updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta));
    } else if (isInserting) {
      context.missing(_updatedByMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('deleted_by')) {
      context.handle(_deletedByMeta,
          deletedBy.isAcceptableOrUnknown(data['deleted_by']!, _deletedByMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MealPlan map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MealPlan(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      accountId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}account_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      createdBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_by'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      updatedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_by'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
      deletedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}deleted_by']),
    );
  }

  @override
  MealPlans createAlias(String alias) {
    return MealPlans(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
        'CONSTRAINT meal_plan_pkey PRIMARY KEY(id)',
        'CONSTRAINT meal_plan_account_fkey FOREIGN KEY(account_id)REFERENCES accounts(id)ON DELETE CASCADE'
      ];
  @override
  bool get dontWriteConstraints => true;
}

class MealPlan extends DataClass implements Insertable<MealPlan> {
  final int id;
  final int accountId;
  final String name;
  final DateTime createdAt;
  final int createdBy;
  final DateTime updatedAt;
  final int updatedBy;
  final DateTime? deletedAt;
  final int? deletedBy;
  const MealPlan(
      {required this.id,
      required this.accountId,
      required this.name,
      required this.createdAt,
      required this.createdBy,
      required this.updatedAt,
      required this.updatedBy,
      this.deletedAt,
      this.deletedBy});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['account_id'] = Variable<int>(accountId);
    map['name'] = Variable<String>(name);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['created_by'] = Variable<int>(createdBy);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['updated_by'] = Variable<int>(updatedBy);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || deletedBy != null) {
      map['deleted_by'] = Variable<int>(deletedBy);
    }
    return map;
  }

  MealPlansCompanion toCompanion(bool nullToAbsent) {
    return MealPlansCompanion(
      id: Value(id),
      accountId: Value(accountId),
      name: Value(name),
      createdAt: Value(createdAt),
      createdBy: Value(createdBy),
      updatedAt: Value(updatedAt),
      updatedBy: Value(updatedBy),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deletedBy: deletedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedBy),
    );
  }

  factory MealPlan.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MealPlan(
      id: serializer.fromJson<int>(json['id']),
      accountId: serializer.fromJson<int>(json['account_id']),
      name: serializer.fromJson<String>(json['name']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      createdBy: serializer.fromJson<int>(json['created_by']),
      updatedAt: serializer.fromJson<DateTime>(json['updated_at']),
      updatedBy: serializer.fromJson<int>(json['updated_by']),
      deletedAt: serializer.fromJson<DateTime?>(json['deleted_at']),
      deletedBy: serializer.fromJson<int?>(json['deleted_by']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'account_id': serializer.toJson<int>(accountId),
      'name': serializer.toJson<String>(name),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'created_by': serializer.toJson<int>(createdBy),
      'updated_at': serializer.toJson<DateTime>(updatedAt),
      'updated_by': serializer.toJson<int>(updatedBy),
      'deleted_at': serializer.toJson<DateTime?>(deletedAt),
      'deleted_by': serializer.toJson<int?>(deletedBy),
    };
  }

  MealPlan copyWith(
          {int? id,
          int? accountId,
          String? name,
          DateTime? createdAt,
          int? createdBy,
          DateTime? updatedAt,
          int? updatedBy,
          Value<DateTime?> deletedAt = const Value.absent(),
          Value<int?> deletedBy = const Value.absent()}) =>
      MealPlan(
        id: id ?? this.id,
        accountId: accountId ?? this.accountId,
        name: name ?? this.name,
        createdAt: createdAt ?? this.createdAt,
        createdBy: createdBy ?? this.createdBy,
        updatedAt: updatedAt ?? this.updatedAt,
        updatedBy: updatedBy ?? this.updatedBy,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        deletedBy: deletedBy.present ? deletedBy.value : this.deletedBy,
      );
  MealPlan copyWithCompanion(MealPlansCompanion data) {
    return MealPlan(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      name: data.name.present ? data.name.value : this.name,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deletedBy: data.deletedBy.present ? data.deletedBy.value : this.deletedBy,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MealPlan(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deletedBy: $deletedBy')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, accountId, name, createdAt, createdBy,
      updatedAt, updatedBy, deletedAt, deletedBy);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MealPlan &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.name == this.name &&
          other.createdAt == this.createdAt &&
          other.createdBy == this.createdBy &&
          other.updatedAt == this.updatedAt &&
          other.updatedBy == this.updatedBy &&
          other.deletedAt == this.deletedAt &&
          other.deletedBy == this.deletedBy);
}

class MealPlansCompanion extends UpdateCompanion<MealPlan> {
  final Value<int> id;
  final Value<int> accountId;
  final Value<String> name;
  final Value<DateTime> createdAt;
  final Value<int> createdBy;
  final Value<DateTime> updatedAt;
  final Value<int> updatedBy;
  final Value<DateTime?> deletedAt;
  final Value<int?> deletedBy;
  const MealPlansCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deletedBy = const Value.absent(),
  });
  MealPlansCompanion.insert({
    this.id = const Value.absent(),
    required int accountId,
    required String name,
    required DateTime createdAt,
    required int createdBy,
    required DateTime updatedAt,
    required int updatedBy,
    this.deletedAt = const Value.absent(),
    this.deletedBy = const Value.absent(),
  })  : accountId = Value(accountId),
        name = Value(name),
        createdAt = Value(createdAt),
        createdBy = Value(createdBy),
        updatedAt = Value(updatedAt),
        updatedBy = Value(updatedBy);
  static Insertable<MealPlan> custom({
    Expression<int>? id,
    Expression<int>? accountId,
    Expression<String>? name,
    Expression<DateTime>? createdAt,
    Expression<int>? createdBy,
    Expression<DateTime>? updatedAt,
    Expression<int>? updatedBy,
    Expression<DateTime>? deletedAt,
    Expression<int>? deletedBy,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
      if (createdBy != null) 'created_by': createdBy,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deletedBy != null) 'deleted_by': deletedBy,
    });
  }

  MealPlansCompanion copyWith(
      {Value<int>? id,
      Value<int>? accountId,
      Value<String>? name,
      Value<DateTime>? createdAt,
      Value<int>? createdBy,
      Value<DateTime>? updatedAt,
      Value<int>? updatedBy,
      Value<DateTime?>? deletedAt,
      Value<int?>? deletedBy}) {
    return MealPlansCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      deletedAt: deletedAt ?? this.deletedAt,
      deletedBy: deletedBy ?? this.deletedBy,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<int>(createdBy.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<int>(updatedBy.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (deletedBy.present) {
      map['deleted_by'] = Variable<int>(deletedBy.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MealPlansCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deletedBy: $deletedBy')
          ..write(')'))
        .toString();
  }
}

class MealPlanMembers extends Table
    with TableInfo<MealPlanMembers, MealPlanMember> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  MealPlanMembers(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _mealPlanIdMeta =
      const VerificationMeta('mealPlanId');
  late final GeneratedColumn<int> mealPlanId = GeneratedColumn<int>(
      'meal_plan_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _accountIdMeta =
      const VerificationMeta('accountId');
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
      'account_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _permissionMeta =
      const VerificationMeta('permission');
  late final GeneratedColumn<String> permission = GeneratedColumn<String>(
      'permission', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL DEFAULT \'accepted\'',
      defaultValue: const CustomExpression('\'accepted\''));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _createdByMeta =
      const VerificationMeta('createdBy');
  late final GeneratedColumn<int> createdBy = GeneratedColumn<int>(
      'created_by', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _updatedByMeta =
      const VerificationMeta('updatedBy');
  late final GeneratedColumn<int> updatedBy = GeneratedColumn<int>(
      'updated_by', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  static const VerificationMeta _deletedByMeta =
      const VerificationMeta('deletedBy');
  late final GeneratedColumn<int> deletedBy = GeneratedColumn<int>(
      'deleted_by', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  @override
  List<GeneratedColumn> get $columns => [
        mealPlanId,
        accountId,
        permission,
        status,
        createdAt,
        createdBy,
        updatedAt,
        updatedBy,
        deletedAt,
        deletedBy
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meal_plan_members';
  @override
  VerificationContext validateIntegrity(Insertable<MealPlanMember> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('meal_plan_id')) {
      context.handle(
          _mealPlanIdMeta,
          mealPlanId.isAcceptableOrUnknown(
              data['meal_plan_id']!, _mealPlanIdMeta));
    } else if (isInserting) {
      context.missing(_mealPlanIdMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta,
          accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('permission')) {
      context.handle(
          _permissionMeta,
          permission.isAcceptableOrUnknown(
              data['permission']!, _permissionMeta));
    } else if (isInserting) {
      context.missing(_permissionMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('updated_by')) {
      context.handle(_updatedByMeta,
          updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta));
    } else if (isInserting) {
      context.missing(_updatedByMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('deleted_by')) {
      context.handle(_deletedByMeta,
          deletedBy.isAcceptableOrUnknown(data['deleted_by']!, _deletedByMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {mealPlanId, accountId};
  @override
  MealPlanMember map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MealPlanMember(
      mealPlanId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}meal_plan_id'])!,
      accountId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}account_id'])!,
      permission: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}permission'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      createdBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_by'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      updatedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_by'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
      deletedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}deleted_by']),
    );
  }

  @override
  MealPlanMembers createAlias(String alias) {
    return MealPlanMembers(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
        'CONSTRAINT meal_plan_member_pkey PRIMARY KEY(meal_plan_id, account_id)',
        'CONSTRAINT meal_plan_member_plan_fkey FOREIGN KEY(meal_plan_id)REFERENCES meal_plans(id)ON DELETE CASCADE',
        'CONSTRAINT meal_plan_member_account_fkey FOREIGN KEY(account_id)REFERENCES accounts(id)ON DELETE CASCADE'
      ];
  @override
  bool get dontWriteConstraints => true;
}

class MealPlanMember extends DataClass implements Insertable<MealPlanMember> {
  final int mealPlanId;
  final int accountId;
  final String permission;
  final String status;
  final DateTime createdAt;
  final int createdBy;
  final DateTime updatedAt;
  final int updatedBy;
  final DateTime? deletedAt;
  final int? deletedBy;
  const MealPlanMember(
      {required this.mealPlanId,
      required this.accountId,
      required this.permission,
      required this.status,
      required this.createdAt,
      required this.createdBy,
      required this.updatedAt,
      required this.updatedBy,
      this.deletedAt,
      this.deletedBy});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['meal_plan_id'] = Variable<int>(mealPlanId);
    map['account_id'] = Variable<int>(accountId);
    map['permission'] = Variable<String>(permission);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['created_by'] = Variable<int>(createdBy);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['updated_by'] = Variable<int>(updatedBy);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || deletedBy != null) {
      map['deleted_by'] = Variable<int>(deletedBy);
    }
    return map;
  }

  MealPlanMembersCompanion toCompanion(bool nullToAbsent) {
    return MealPlanMembersCompanion(
      mealPlanId: Value(mealPlanId),
      accountId: Value(accountId),
      permission: Value(permission),
      status: Value(status),
      createdAt: Value(createdAt),
      createdBy: Value(createdBy),
      updatedAt: Value(updatedAt),
      updatedBy: Value(updatedBy),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deletedBy: deletedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedBy),
    );
  }

  factory MealPlanMember.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MealPlanMember(
      mealPlanId: serializer.fromJson<int>(json['meal_plan_id']),
      accountId: serializer.fromJson<int>(json['account_id']),
      permission: serializer.fromJson<String>(json['permission']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      createdBy: serializer.fromJson<int>(json['created_by']),
      updatedAt: serializer.fromJson<DateTime>(json['updated_at']),
      updatedBy: serializer.fromJson<int>(json['updated_by']),
      deletedAt: serializer.fromJson<DateTime?>(json['deleted_at']),
      deletedBy: serializer.fromJson<int?>(json['deleted_by']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'meal_plan_id': serializer.toJson<int>(mealPlanId),
      'account_id': serializer.toJson<int>(accountId),
      'permission': serializer.toJson<String>(permission),
      'status': serializer.toJson<String>(status),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'created_by': serializer.toJson<int>(createdBy),
      'updated_at': serializer.toJson<DateTime>(updatedAt),
      'updated_by': serializer.toJson<int>(updatedBy),
      'deleted_at': serializer.toJson<DateTime?>(deletedAt),
      'deleted_by': serializer.toJson<int?>(deletedBy),
    };
  }

  MealPlanMember copyWith(
          {int? mealPlanId,
          int? accountId,
          String? permission,
          String? status,
          DateTime? createdAt,
          int? createdBy,
          DateTime? updatedAt,
          int? updatedBy,
          Value<DateTime?> deletedAt = const Value.absent(),
          Value<int?> deletedBy = const Value.absent()}) =>
      MealPlanMember(
        mealPlanId: mealPlanId ?? this.mealPlanId,
        accountId: accountId ?? this.accountId,
        permission: permission ?? this.permission,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        createdBy: createdBy ?? this.createdBy,
        updatedAt: updatedAt ?? this.updatedAt,
        updatedBy: updatedBy ?? this.updatedBy,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        deletedBy: deletedBy.present ? deletedBy.value : this.deletedBy,
      );
  MealPlanMember copyWithCompanion(MealPlanMembersCompanion data) {
    return MealPlanMember(
      mealPlanId:
          data.mealPlanId.present ? data.mealPlanId.value : this.mealPlanId,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      permission:
          data.permission.present ? data.permission.value : this.permission,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deletedBy: data.deletedBy.present ? data.deletedBy.value : this.deletedBy,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MealPlanMember(')
          ..write('mealPlanId: $mealPlanId, ')
          ..write('accountId: $accountId, ')
          ..write('permission: $permission, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deletedBy: $deletedBy')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(mealPlanId, accountId, permission, status,
      createdAt, createdBy, updatedAt, updatedBy, deletedAt, deletedBy);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MealPlanMember &&
          other.mealPlanId == this.mealPlanId &&
          other.accountId == this.accountId &&
          other.permission == this.permission &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.createdBy == this.createdBy &&
          other.updatedAt == this.updatedAt &&
          other.updatedBy == this.updatedBy &&
          other.deletedAt == this.deletedAt &&
          other.deletedBy == this.deletedBy);
}

class MealPlanMembersCompanion extends UpdateCompanion<MealPlanMember> {
  final Value<int> mealPlanId;
  final Value<int> accountId;
  final Value<String> permission;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<int> createdBy;
  final Value<DateTime> updatedAt;
  final Value<int> updatedBy;
  final Value<DateTime?> deletedAt;
  final Value<int?> deletedBy;
  final Value<int> rowid;
  const MealPlanMembersCompanion({
    this.mealPlanId = const Value.absent(),
    this.accountId = const Value.absent(),
    this.permission = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deletedBy = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MealPlanMembersCompanion.insert({
    required int mealPlanId,
    required int accountId,
    required String permission,
    this.status = const Value.absent(),
    required DateTime createdAt,
    required int createdBy,
    required DateTime updatedAt,
    required int updatedBy,
    this.deletedAt = const Value.absent(),
    this.deletedBy = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : mealPlanId = Value(mealPlanId),
        accountId = Value(accountId),
        permission = Value(permission),
        createdAt = Value(createdAt),
        createdBy = Value(createdBy),
        updatedAt = Value(updatedAt),
        updatedBy = Value(updatedBy);
  static Insertable<MealPlanMember> custom({
    Expression<int>? mealPlanId,
    Expression<int>? accountId,
    Expression<String>? permission,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<int>? createdBy,
    Expression<DateTime>? updatedAt,
    Expression<int>? updatedBy,
    Expression<DateTime>? deletedAt,
    Expression<int>? deletedBy,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (mealPlanId != null) 'meal_plan_id': mealPlanId,
      if (accountId != null) 'account_id': accountId,
      if (permission != null) 'permission': permission,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (createdBy != null) 'created_by': createdBy,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deletedBy != null) 'deleted_by': deletedBy,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MealPlanMembersCompanion copyWith(
      {Value<int>? mealPlanId,
      Value<int>? accountId,
      Value<String>? permission,
      Value<String>? status,
      Value<DateTime>? createdAt,
      Value<int>? createdBy,
      Value<DateTime>? updatedAt,
      Value<int>? updatedBy,
      Value<DateTime?>? deletedAt,
      Value<int?>? deletedBy,
      Value<int>? rowid}) {
    return MealPlanMembersCompanion(
      mealPlanId: mealPlanId ?? this.mealPlanId,
      accountId: accountId ?? this.accountId,
      permission: permission ?? this.permission,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      deletedAt: deletedAt ?? this.deletedAt,
      deletedBy: deletedBy ?? this.deletedBy,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (mealPlanId.present) {
      map['meal_plan_id'] = Variable<int>(mealPlanId.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (permission.present) {
      map['permission'] = Variable<String>(permission.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<int>(createdBy.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<int>(updatedBy.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (deletedBy.present) {
      map['deleted_by'] = Variable<int>(deletedBy.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MealPlanMembersCompanion(')
          ..write('mealPlanId: $mealPlanId, ')
          ..write('accountId: $accountId, ')
          ..write('permission: $permission, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deletedBy: $deletedBy, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class MealPlanEntries extends Table
    with TableInfo<MealPlanEntries, MealPlanEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  MealPlanEntries(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _mealPlanIdMeta =
      const VerificationMeta('mealPlanId');
  late final GeneratedColumn<int> mealPlanId = GeneratedColumn<int>(
      'meal_plan_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _plannedDateMeta =
      const VerificationMeta('plannedDate');
  late final GeneratedColumn<DateTime> plannedDate = GeneratedColumn<DateTime>(
      'planned_date', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _mealSlotMeta =
      const VerificationMeta('mealSlot');
  late final GeneratedColumn<String> mealSlot = GeneratedColumn<String>(
      'meal_slot', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _recipeIdMeta =
      const VerificationMeta('recipeId');
  late final GeneratedColumn<int> recipeId = GeneratedColumn<int>(
      'recipe_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  static const VerificationMeta _recipeTitleSnapshotMeta =
      const VerificationMeta('recipeTitleSnapshot');
  late final GeneratedColumn<String> recipeTitleSnapshot =
      GeneratedColumn<String>('recipe_title_snapshot', aliasedName, true,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          $customConstraints: 'NULL');
  static const VerificationMeta _customTitleMeta =
      const VerificationMeta('customTitle');
  late final GeneratedColumn<String> customTitle = GeneratedColumn<String>(
      'custom_title', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  static const VerificationMeta _servingsMeta =
      const VerificationMeta('servings');
  late final GeneratedColumn<int> servings = GeneratedColumn<int>(
      'servings', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL DEFAULT 0',
      defaultValue: const CustomExpression('0'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _createdByMeta =
      const VerificationMeta('createdBy');
  late final GeneratedColumn<int> createdBy = GeneratedColumn<int>(
      'created_by', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _updatedByMeta =
      const VerificationMeta('updatedBy');
  late final GeneratedColumn<int> updatedBy = GeneratedColumn<int>(
      'updated_by', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  static const VerificationMeta _deletedByMeta =
      const VerificationMeta('deletedBy');
  late final GeneratedColumn<int> deletedBy = GeneratedColumn<int>(
      'deleted_by', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  @override
  List<GeneratedColumn> get $columns => [
        id,
        mealPlanId,
        plannedDate,
        mealSlot,
        recipeId,
        recipeTitleSnapshot,
        customTitle,
        note,
        servings,
        sortOrder,
        createdAt,
        createdBy,
        updatedAt,
        updatedBy,
        deletedAt,
        deletedBy
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meal_plan_entries';
  @override
  VerificationContext validateIntegrity(Insertable<MealPlanEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('meal_plan_id')) {
      context.handle(
          _mealPlanIdMeta,
          mealPlanId.isAcceptableOrUnknown(
              data['meal_plan_id']!, _mealPlanIdMeta));
    } else if (isInserting) {
      context.missing(_mealPlanIdMeta);
    }
    if (data.containsKey('planned_date')) {
      context.handle(
          _plannedDateMeta,
          plannedDate.isAcceptableOrUnknown(
              data['planned_date']!, _plannedDateMeta));
    } else if (isInserting) {
      context.missing(_plannedDateMeta);
    }
    if (data.containsKey('meal_slot')) {
      context.handle(_mealSlotMeta,
          mealSlot.isAcceptableOrUnknown(data['meal_slot']!, _mealSlotMeta));
    } else if (isInserting) {
      context.missing(_mealSlotMeta);
    }
    if (data.containsKey('recipe_id')) {
      context.handle(_recipeIdMeta,
          recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta));
    }
    if (data.containsKey('recipe_title_snapshot')) {
      context.handle(
          _recipeTitleSnapshotMeta,
          recipeTitleSnapshot.isAcceptableOrUnknown(
              data['recipe_title_snapshot']!, _recipeTitleSnapshotMeta));
    }
    if (data.containsKey('custom_title')) {
      context.handle(
          _customTitleMeta,
          customTitle.isAcceptableOrUnknown(
              data['custom_title']!, _customTitleMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('servings')) {
      context.handle(_servingsMeta,
          servings.isAcceptableOrUnknown(data['servings']!, _servingsMeta));
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('updated_by')) {
      context.handle(_updatedByMeta,
          updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta));
    } else if (isInserting) {
      context.missing(_updatedByMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('deleted_by')) {
      context.handle(_deletedByMeta,
          deletedBy.isAcceptableOrUnknown(data['deleted_by']!, _deletedByMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MealPlanEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MealPlanEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      mealPlanId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}meal_plan_id'])!,
      plannedDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}planned_date'])!,
      mealSlot: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}meal_slot'])!,
      recipeId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}recipe_id']),
      recipeTitleSnapshot: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}recipe_title_snapshot']),
      customTitle: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}custom_title']),
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      servings: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}servings']),
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      createdBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_by'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      updatedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_by'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
      deletedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}deleted_by']),
    );
  }

  @override
  MealPlanEntries createAlias(String alias) {
    return MealPlanEntries(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
        'CONSTRAINT meal_plan_entry_pkey PRIMARY KEY(id)',
        'CONSTRAINT meal_plan_entry_plan_fkey FOREIGN KEY(meal_plan_id)REFERENCES meal_plans(id)ON DELETE CASCADE',
        'CONSTRAINT meal_plan_entry_recipe_id_fkey FOREIGN KEY(recipe_id)REFERENCES recipes(id)ON DELETE SET NULL'
      ];
  @override
  bool get dontWriteConstraints => true;
}

class MealPlanEntry extends DataClass implements Insertable<MealPlanEntry> {
  final int id;
  final int mealPlanId;
  final DateTime plannedDate;
  final String mealSlot;
  final int? recipeId;
  final String? recipeTitleSnapshot;
  final String? customTitle;
  final String? note;
  final int? servings;
  final int sortOrder;
  final DateTime createdAt;
  final int createdBy;
  final DateTime updatedAt;
  final int updatedBy;
  final DateTime? deletedAt;
  final int? deletedBy;
  const MealPlanEntry(
      {required this.id,
      required this.mealPlanId,
      required this.plannedDate,
      required this.mealSlot,
      this.recipeId,
      this.recipeTitleSnapshot,
      this.customTitle,
      this.note,
      this.servings,
      required this.sortOrder,
      required this.createdAt,
      required this.createdBy,
      required this.updatedAt,
      required this.updatedBy,
      this.deletedAt,
      this.deletedBy});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['meal_plan_id'] = Variable<int>(mealPlanId);
    map['planned_date'] = Variable<DateTime>(plannedDate);
    map['meal_slot'] = Variable<String>(mealSlot);
    if (!nullToAbsent || recipeId != null) {
      map['recipe_id'] = Variable<int>(recipeId);
    }
    if (!nullToAbsent || recipeTitleSnapshot != null) {
      map['recipe_title_snapshot'] = Variable<String>(recipeTitleSnapshot);
    }
    if (!nullToAbsent || customTitle != null) {
      map['custom_title'] = Variable<String>(customTitle);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || servings != null) {
      map['servings'] = Variable<int>(servings);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['created_by'] = Variable<int>(createdBy);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['updated_by'] = Variable<int>(updatedBy);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || deletedBy != null) {
      map['deleted_by'] = Variable<int>(deletedBy);
    }
    return map;
  }

  MealPlanEntriesCompanion toCompanion(bool nullToAbsent) {
    return MealPlanEntriesCompanion(
      id: Value(id),
      mealPlanId: Value(mealPlanId),
      plannedDate: Value(plannedDate),
      mealSlot: Value(mealSlot),
      recipeId: recipeId == null && nullToAbsent
          ? const Value.absent()
          : Value(recipeId),
      recipeTitleSnapshot: recipeTitleSnapshot == null && nullToAbsent
          ? const Value.absent()
          : Value(recipeTitleSnapshot),
      customTitle: customTitle == null && nullToAbsent
          ? const Value.absent()
          : Value(customTitle),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      servings: servings == null && nullToAbsent
          ? const Value.absent()
          : Value(servings),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
      createdBy: Value(createdBy),
      updatedAt: Value(updatedAt),
      updatedBy: Value(updatedBy),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deletedBy: deletedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedBy),
    );
  }

  factory MealPlanEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MealPlanEntry(
      id: serializer.fromJson<int>(json['id']),
      mealPlanId: serializer.fromJson<int>(json['meal_plan_id']),
      plannedDate: serializer.fromJson<DateTime>(json['planned_date']),
      mealSlot: serializer.fromJson<String>(json['meal_slot']),
      recipeId: serializer.fromJson<int?>(json['recipe_id']),
      recipeTitleSnapshot:
          serializer.fromJson<String?>(json['recipe_title_snapshot']),
      customTitle: serializer.fromJson<String?>(json['custom_title']),
      note: serializer.fromJson<String?>(json['note']),
      servings: serializer.fromJson<int?>(json['servings']),
      sortOrder: serializer.fromJson<int>(json['sort_order']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      createdBy: serializer.fromJson<int>(json['created_by']),
      updatedAt: serializer.fromJson<DateTime>(json['updated_at']),
      updatedBy: serializer.fromJson<int>(json['updated_by']),
      deletedAt: serializer.fromJson<DateTime?>(json['deleted_at']),
      deletedBy: serializer.fromJson<int?>(json['deleted_by']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'meal_plan_id': serializer.toJson<int>(mealPlanId),
      'planned_date': serializer.toJson<DateTime>(plannedDate),
      'meal_slot': serializer.toJson<String>(mealSlot),
      'recipe_id': serializer.toJson<int?>(recipeId),
      'recipe_title_snapshot': serializer.toJson<String?>(recipeTitleSnapshot),
      'custom_title': serializer.toJson<String?>(customTitle),
      'note': serializer.toJson<String?>(note),
      'servings': serializer.toJson<int?>(servings),
      'sort_order': serializer.toJson<int>(sortOrder),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'created_by': serializer.toJson<int>(createdBy),
      'updated_at': serializer.toJson<DateTime>(updatedAt),
      'updated_by': serializer.toJson<int>(updatedBy),
      'deleted_at': serializer.toJson<DateTime?>(deletedAt),
      'deleted_by': serializer.toJson<int?>(deletedBy),
    };
  }

  MealPlanEntry copyWith(
          {int? id,
          int? mealPlanId,
          DateTime? plannedDate,
          String? mealSlot,
          Value<int?> recipeId = const Value.absent(),
          Value<String?> recipeTitleSnapshot = const Value.absent(),
          Value<String?> customTitle = const Value.absent(),
          Value<String?> note = const Value.absent(),
          Value<int?> servings = const Value.absent(),
          int? sortOrder,
          DateTime? createdAt,
          int? createdBy,
          DateTime? updatedAt,
          int? updatedBy,
          Value<DateTime?> deletedAt = const Value.absent(),
          Value<int?> deletedBy = const Value.absent()}) =>
      MealPlanEntry(
        id: id ?? this.id,
        mealPlanId: mealPlanId ?? this.mealPlanId,
        plannedDate: plannedDate ?? this.plannedDate,
        mealSlot: mealSlot ?? this.mealSlot,
        recipeId: recipeId.present ? recipeId.value : this.recipeId,
        recipeTitleSnapshot: recipeTitleSnapshot.present
            ? recipeTitleSnapshot.value
            : this.recipeTitleSnapshot,
        customTitle: customTitle.present ? customTitle.value : this.customTitle,
        note: note.present ? note.value : this.note,
        servings: servings.present ? servings.value : this.servings,
        sortOrder: sortOrder ?? this.sortOrder,
        createdAt: createdAt ?? this.createdAt,
        createdBy: createdBy ?? this.createdBy,
        updatedAt: updatedAt ?? this.updatedAt,
        updatedBy: updatedBy ?? this.updatedBy,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        deletedBy: deletedBy.present ? deletedBy.value : this.deletedBy,
      );
  MealPlanEntry copyWithCompanion(MealPlanEntriesCompanion data) {
    return MealPlanEntry(
      id: data.id.present ? data.id.value : this.id,
      mealPlanId:
          data.mealPlanId.present ? data.mealPlanId.value : this.mealPlanId,
      plannedDate:
          data.plannedDate.present ? data.plannedDate.value : this.plannedDate,
      mealSlot: data.mealSlot.present ? data.mealSlot.value : this.mealSlot,
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
      recipeTitleSnapshot: data.recipeTitleSnapshot.present
          ? data.recipeTitleSnapshot.value
          : this.recipeTitleSnapshot,
      customTitle:
          data.customTitle.present ? data.customTitle.value : this.customTitle,
      note: data.note.present ? data.note.value : this.note,
      servings: data.servings.present ? data.servings.value : this.servings,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deletedBy: data.deletedBy.present ? data.deletedBy.value : this.deletedBy,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MealPlanEntry(')
          ..write('id: $id, ')
          ..write('mealPlanId: $mealPlanId, ')
          ..write('plannedDate: $plannedDate, ')
          ..write('mealSlot: $mealSlot, ')
          ..write('recipeId: $recipeId, ')
          ..write('recipeTitleSnapshot: $recipeTitleSnapshot, ')
          ..write('customTitle: $customTitle, ')
          ..write('note: $note, ')
          ..write('servings: $servings, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deletedBy: $deletedBy')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      mealPlanId,
      plannedDate,
      mealSlot,
      recipeId,
      recipeTitleSnapshot,
      customTitle,
      note,
      servings,
      sortOrder,
      createdAt,
      createdBy,
      updatedAt,
      updatedBy,
      deletedAt,
      deletedBy);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MealPlanEntry &&
          other.id == this.id &&
          other.mealPlanId == this.mealPlanId &&
          other.plannedDate == this.plannedDate &&
          other.mealSlot == this.mealSlot &&
          other.recipeId == this.recipeId &&
          other.recipeTitleSnapshot == this.recipeTitleSnapshot &&
          other.customTitle == this.customTitle &&
          other.note == this.note &&
          other.servings == this.servings &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt &&
          other.createdBy == this.createdBy &&
          other.updatedAt == this.updatedAt &&
          other.updatedBy == this.updatedBy &&
          other.deletedAt == this.deletedAt &&
          other.deletedBy == this.deletedBy);
}

class MealPlanEntriesCompanion extends UpdateCompanion<MealPlanEntry> {
  final Value<int> id;
  final Value<int> mealPlanId;
  final Value<DateTime> plannedDate;
  final Value<String> mealSlot;
  final Value<int?> recipeId;
  final Value<String?> recipeTitleSnapshot;
  final Value<String?> customTitle;
  final Value<String?> note;
  final Value<int?> servings;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  final Value<int> createdBy;
  final Value<DateTime> updatedAt;
  final Value<int> updatedBy;
  final Value<DateTime?> deletedAt;
  final Value<int?> deletedBy;
  const MealPlanEntriesCompanion({
    this.id = const Value.absent(),
    this.mealPlanId = const Value.absent(),
    this.plannedDate = const Value.absent(),
    this.mealSlot = const Value.absent(),
    this.recipeId = const Value.absent(),
    this.recipeTitleSnapshot = const Value.absent(),
    this.customTitle = const Value.absent(),
    this.note = const Value.absent(),
    this.servings = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deletedBy = const Value.absent(),
  });
  MealPlanEntriesCompanion.insert({
    this.id = const Value.absent(),
    required int mealPlanId,
    required DateTime plannedDate,
    required String mealSlot,
    this.recipeId = const Value.absent(),
    this.recipeTitleSnapshot = const Value.absent(),
    this.customTitle = const Value.absent(),
    this.note = const Value.absent(),
    this.servings = const Value.absent(),
    this.sortOrder = const Value.absent(),
    required DateTime createdAt,
    required int createdBy,
    required DateTime updatedAt,
    required int updatedBy,
    this.deletedAt = const Value.absent(),
    this.deletedBy = const Value.absent(),
  })  : mealPlanId = Value(mealPlanId),
        plannedDate = Value(plannedDate),
        mealSlot = Value(mealSlot),
        createdAt = Value(createdAt),
        createdBy = Value(createdBy),
        updatedAt = Value(updatedAt),
        updatedBy = Value(updatedBy);
  static Insertable<MealPlanEntry> custom({
    Expression<int>? id,
    Expression<int>? mealPlanId,
    Expression<DateTime>? plannedDate,
    Expression<String>? mealSlot,
    Expression<int>? recipeId,
    Expression<String>? recipeTitleSnapshot,
    Expression<String>? customTitle,
    Expression<String>? note,
    Expression<int>? servings,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
    Expression<int>? createdBy,
    Expression<DateTime>? updatedAt,
    Expression<int>? updatedBy,
    Expression<DateTime>? deletedAt,
    Expression<int>? deletedBy,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (mealPlanId != null) 'meal_plan_id': mealPlanId,
      if (plannedDate != null) 'planned_date': plannedDate,
      if (mealSlot != null) 'meal_slot': mealSlot,
      if (recipeId != null) 'recipe_id': recipeId,
      if (recipeTitleSnapshot != null)
        'recipe_title_snapshot': recipeTitleSnapshot,
      if (customTitle != null) 'custom_title': customTitle,
      if (note != null) 'note': note,
      if (servings != null) 'servings': servings,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (createdBy != null) 'created_by': createdBy,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deletedBy != null) 'deleted_by': deletedBy,
    });
  }

  MealPlanEntriesCompanion copyWith(
      {Value<int>? id,
      Value<int>? mealPlanId,
      Value<DateTime>? plannedDate,
      Value<String>? mealSlot,
      Value<int?>? recipeId,
      Value<String?>? recipeTitleSnapshot,
      Value<String?>? customTitle,
      Value<String?>? note,
      Value<int?>? servings,
      Value<int>? sortOrder,
      Value<DateTime>? createdAt,
      Value<int>? createdBy,
      Value<DateTime>? updatedAt,
      Value<int>? updatedBy,
      Value<DateTime?>? deletedAt,
      Value<int?>? deletedBy}) {
    return MealPlanEntriesCompanion(
      id: id ?? this.id,
      mealPlanId: mealPlanId ?? this.mealPlanId,
      plannedDate: plannedDate ?? this.plannedDate,
      mealSlot: mealSlot ?? this.mealSlot,
      recipeId: recipeId ?? this.recipeId,
      recipeTitleSnapshot: recipeTitleSnapshot ?? this.recipeTitleSnapshot,
      customTitle: customTitle ?? this.customTitle,
      note: note ?? this.note,
      servings: servings ?? this.servings,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      deletedAt: deletedAt ?? this.deletedAt,
      deletedBy: deletedBy ?? this.deletedBy,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (mealPlanId.present) {
      map['meal_plan_id'] = Variable<int>(mealPlanId.value);
    }
    if (plannedDate.present) {
      map['planned_date'] = Variable<DateTime>(plannedDate.value);
    }
    if (mealSlot.present) {
      map['meal_slot'] = Variable<String>(mealSlot.value);
    }
    if (recipeId.present) {
      map['recipe_id'] = Variable<int>(recipeId.value);
    }
    if (recipeTitleSnapshot.present) {
      map['recipe_title_snapshot'] =
          Variable<String>(recipeTitleSnapshot.value);
    }
    if (customTitle.present) {
      map['custom_title'] = Variable<String>(customTitle.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (servings.present) {
      map['servings'] = Variable<int>(servings.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<int>(createdBy.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<int>(updatedBy.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (deletedBy.present) {
      map['deleted_by'] = Variable<int>(deletedBy.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MealPlanEntriesCompanion(')
          ..write('id: $id, ')
          ..write('mealPlanId: $mealPlanId, ')
          ..write('plannedDate: $plannedDate, ')
          ..write('mealSlot: $mealSlot, ')
          ..write('recipeId: $recipeId, ')
          ..write('recipeTitleSnapshot: $recipeTitleSnapshot, ')
          ..write('customTitle: $customTitle, ')
          ..write('note: $note, ')
          ..write('servings: $servings, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deletedBy: $deletedBy')
          ..write(')'))
        .toString();
  }
}

class MealPlanTemplates extends Table
    with TableInfo<MealPlanTemplates, MealPlanTemplate> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  MealPlanTemplates(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _accountIdMeta =
      const VerificationMeta('accountId');
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
      'account_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _createdByMeta =
      const VerificationMeta('createdBy');
  late final GeneratedColumn<int> createdBy = GeneratedColumn<int>(
      'created_by', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _updatedByMeta =
      const VerificationMeta('updatedBy');
  late final GeneratedColumn<int> updatedBy = GeneratedColumn<int>(
      'updated_by', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  static const VerificationMeta _deletedByMeta =
      const VerificationMeta('deletedBy');
  late final GeneratedColumn<int> deletedBy = GeneratedColumn<int>(
      'deleted_by', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  @override
  List<GeneratedColumn> get $columns => [
        id,
        accountId,
        name,
        createdAt,
        createdBy,
        updatedAt,
        updatedBy,
        deletedAt,
        deletedBy
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meal_plan_templates';
  @override
  VerificationContext validateIntegrity(Insertable<MealPlanTemplate> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta,
          accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('updated_by')) {
      context.handle(_updatedByMeta,
          updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta));
    } else if (isInserting) {
      context.missing(_updatedByMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('deleted_by')) {
      context.handle(_deletedByMeta,
          deletedBy.isAcceptableOrUnknown(data['deleted_by']!, _deletedByMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MealPlanTemplate map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MealPlanTemplate(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      accountId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}account_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      createdBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_by'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      updatedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_by'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
      deletedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}deleted_by']),
    );
  }

  @override
  MealPlanTemplates createAlias(String alias) {
    return MealPlanTemplates(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
        'CONSTRAINT meal_plan_template_pkey PRIMARY KEY(id)',
        'CONSTRAINT meal_plan_template_account_id_fkey FOREIGN KEY(account_id)REFERENCES accounts(id)ON DELETE CASCADE'
      ];
  @override
  bool get dontWriteConstraints => true;
}

class MealPlanTemplate extends DataClass
    implements Insertable<MealPlanTemplate> {
  final int id;
  final int accountId;
  final String name;
  final DateTime createdAt;
  final int createdBy;
  final DateTime updatedAt;
  final int updatedBy;
  final DateTime? deletedAt;
  final int? deletedBy;
  const MealPlanTemplate(
      {required this.id,
      required this.accountId,
      required this.name,
      required this.createdAt,
      required this.createdBy,
      required this.updatedAt,
      required this.updatedBy,
      this.deletedAt,
      this.deletedBy});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['account_id'] = Variable<int>(accountId);
    map['name'] = Variable<String>(name);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['created_by'] = Variable<int>(createdBy);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['updated_by'] = Variable<int>(updatedBy);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || deletedBy != null) {
      map['deleted_by'] = Variable<int>(deletedBy);
    }
    return map;
  }

  MealPlanTemplatesCompanion toCompanion(bool nullToAbsent) {
    return MealPlanTemplatesCompanion(
      id: Value(id),
      accountId: Value(accountId),
      name: Value(name),
      createdAt: Value(createdAt),
      createdBy: Value(createdBy),
      updatedAt: Value(updatedAt),
      updatedBy: Value(updatedBy),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deletedBy: deletedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedBy),
    );
  }

  factory MealPlanTemplate.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MealPlanTemplate(
      id: serializer.fromJson<int>(json['id']),
      accountId: serializer.fromJson<int>(json['account_id']),
      name: serializer.fromJson<String>(json['name']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      createdBy: serializer.fromJson<int>(json['created_by']),
      updatedAt: serializer.fromJson<DateTime>(json['updated_at']),
      updatedBy: serializer.fromJson<int>(json['updated_by']),
      deletedAt: serializer.fromJson<DateTime?>(json['deleted_at']),
      deletedBy: serializer.fromJson<int?>(json['deleted_by']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'account_id': serializer.toJson<int>(accountId),
      'name': serializer.toJson<String>(name),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'created_by': serializer.toJson<int>(createdBy),
      'updated_at': serializer.toJson<DateTime>(updatedAt),
      'updated_by': serializer.toJson<int>(updatedBy),
      'deleted_at': serializer.toJson<DateTime?>(deletedAt),
      'deleted_by': serializer.toJson<int?>(deletedBy),
    };
  }

  MealPlanTemplate copyWith(
          {int? id,
          int? accountId,
          String? name,
          DateTime? createdAt,
          int? createdBy,
          DateTime? updatedAt,
          int? updatedBy,
          Value<DateTime?> deletedAt = const Value.absent(),
          Value<int?> deletedBy = const Value.absent()}) =>
      MealPlanTemplate(
        id: id ?? this.id,
        accountId: accountId ?? this.accountId,
        name: name ?? this.name,
        createdAt: createdAt ?? this.createdAt,
        createdBy: createdBy ?? this.createdBy,
        updatedAt: updatedAt ?? this.updatedAt,
        updatedBy: updatedBy ?? this.updatedBy,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        deletedBy: deletedBy.present ? deletedBy.value : this.deletedBy,
      );
  MealPlanTemplate copyWithCompanion(MealPlanTemplatesCompanion data) {
    return MealPlanTemplate(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      name: data.name.present ? data.name.value : this.name,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deletedBy: data.deletedBy.present ? data.deletedBy.value : this.deletedBy,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MealPlanTemplate(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deletedBy: $deletedBy')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, accountId, name, createdAt, createdBy,
      updatedAt, updatedBy, deletedAt, deletedBy);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MealPlanTemplate &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.name == this.name &&
          other.createdAt == this.createdAt &&
          other.createdBy == this.createdBy &&
          other.updatedAt == this.updatedAt &&
          other.updatedBy == this.updatedBy &&
          other.deletedAt == this.deletedAt &&
          other.deletedBy == this.deletedBy);
}

class MealPlanTemplatesCompanion extends UpdateCompanion<MealPlanTemplate> {
  final Value<int> id;
  final Value<int> accountId;
  final Value<String> name;
  final Value<DateTime> createdAt;
  final Value<int> createdBy;
  final Value<DateTime> updatedAt;
  final Value<int> updatedBy;
  final Value<DateTime?> deletedAt;
  final Value<int?> deletedBy;
  const MealPlanTemplatesCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deletedBy = const Value.absent(),
  });
  MealPlanTemplatesCompanion.insert({
    this.id = const Value.absent(),
    required int accountId,
    required String name,
    required DateTime createdAt,
    required int createdBy,
    required DateTime updatedAt,
    required int updatedBy,
    this.deletedAt = const Value.absent(),
    this.deletedBy = const Value.absent(),
  })  : accountId = Value(accountId),
        name = Value(name),
        createdAt = Value(createdAt),
        createdBy = Value(createdBy),
        updatedAt = Value(updatedAt),
        updatedBy = Value(updatedBy);
  static Insertable<MealPlanTemplate> custom({
    Expression<int>? id,
    Expression<int>? accountId,
    Expression<String>? name,
    Expression<DateTime>? createdAt,
    Expression<int>? createdBy,
    Expression<DateTime>? updatedAt,
    Expression<int>? updatedBy,
    Expression<DateTime>? deletedAt,
    Expression<int>? deletedBy,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
      if (createdBy != null) 'created_by': createdBy,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deletedBy != null) 'deleted_by': deletedBy,
    });
  }

  MealPlanTemplatesCompanion copyWith(
      {Value<int>? id,
      Value<int>? accountId,
      Value<String>? name,
      Value<DateTime>? createdAt,
      Value<int>? createdBy,
      Value<DateTime>? updatedAt,
      Value<int>? updatedBy,
      Value<DateTime?>? deletedAt,
      Value<int?>? deletedBy}) {
    return MealPlanTemplatesCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      deletedAt: deletedAt ?? this.deletedAt,
      deletedBy: deletedBy ?? this.deletedBy,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<int>(createdBy.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<int>(updatedBy.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (deletedBy.present) {
      map['deleted_by'] = Variable<int>(deletedBy.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MealPlanTemplatesCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deletedBy: $deletedBy')
          ..write(')'))
        .toString();
  }
}

class MealPlanTemplateEntries extends Table
    with TableInfo<MealPlanTemplateEntries, MealPlanTemplateEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  MealPlanTemplateEntries(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _templateIdMeta =
      const VerificationMeta('templateId');
  late final GeneratedColumn<int> templateId = GeneratedColumn<int>(
      'template_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _dayOffsetMeta =
      const VerificationMeta('dayOffset');
  late final GeneratedColumn<int> dayOffset = GeneratedColumn<int>(
      'day_offset', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _mealSlotMeta =
      const VerificationMeta('mealSlot');
  late final GeneratedColumn<String> mealSlot = GeneratedColumn<String>(
      'meal_slot', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _recipeIdMeta =
      const VerificationMeta('recipeId');
  late final GeneratedColumn<int> recipeId = GeneratedColumn<int>(
      'recipe_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  static const VerificationMeta _recipeTitleSnapshotMeta =
      const VerificationMeta('recipeTitleSnapshot');
  late final GeneratedColumn<String> recipeTitleSnapshot =
      GeneratedColumn<String>('recipe_title_snapshot', aliasedName, true,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          $customConstraints: 'NULL');
  static const VerificationMeta _customTitleMeta =
      const VerificationMeta('customTitle');
  late final GeneratedColumn<String> customTitle = GeneratedColumn<String>(
      'custom_title', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  static const VerificationMeta _servingsMeta =
      const VerificationMeta('servings');
  late final GeneratedColumn<int> servings = GeneratedColumn<int>(
      'servings', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL DEFAULT 0',
      defaultValue: const CustomExpression('0'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _createdByMeta =
      const VerificationMeta('createdBy');
  late final GeneratedColumn<int> createdBy = GeneratedColumn<int>(
      'created_by', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _updatedByMeta =
      const VerificationMeta('updatedBy');
  late final GeneratedColumn<int> updatedBy = GeneratedColumn<int>(
      'updated_by', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  static const VerificationMeta _deletedByMeta =
      const VerificationMeta('deletedBy');
  late final GeneratedColumn<int> deletedBy = GeneratedColumn<int>(
      'deleted_by', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  @override
  List<GeneratedColumn> get $columns => [
        id,
        templateId,
        dayOffset,
        mealSlot,
        recipeId,
        recipeTitleSnapshot,
        customTitle,
        note,
        servings,
        sortOrder,
        createdAt,
        createdBy,
        updatedAt,
        updatedBy,
        deletedAt,
        deletedBy
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meal_plan_template_entries';
  @override
  VerificationContext validateIntegrity(
      Insertable<MealPlanTemplateEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('template_id')) {
      context.handle(
          _templateIdMeta,
          templateId.isAcceptableOrUnknown(
              data['template_id']!, _templateIdMeta));
    } else if (isInserting) {
      context.missing(_templateIdMeta);
    }
    if (data.containsKey('day_offset')) {
      context.handle(_dayOffsetMeta,
          dayOffset.isAcceptableOrUnknown(data['day_offset']!, _dayOffsetMeta));
    } else if (isInserting) {
      context.missing(_dayOffsetMeta);
    }
    if (data.containsKey('meal_slot')) {
      context.handle(_mealSlotMeta,
          mealSlot.isAcceptableOrUnknown(data['meal_slot']!, _mealSlotMeta));
    } else if (isInserting) {
      context.missing(_mealSlotMeta);
    }
    if (data.containsKey('recipe_id')) {
      context.handle(_recipeIdMeta,
          recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta));
    }
    if (data.containsKey('recipe_title_snapshot')) {
      context.handle(
          _recipeTitleSnapshotMeta,
          recipeTitleSnapshot.isAcceptableOrUnknown(
              data['recipe_title_snapshot']!, _recipeTitleSnapshotMeta));
    }
    if (data.containsKey('custom_title')) {
      context.handle(
          _customTitleMeta,
          customTitle.isAcceptableOrUnknown(
              data['custom_title']!, _customTitleMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('servings')) {
      context.handle(_servingsMeta,
          servings.isAcceptableOrUnknown(data['servings']!, _servingsMeta));
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('updated_by')) {
      context.handle(_updatedByMeta,
          updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta));
    } else if (isInserting) {
      context.missing(_updatedByMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('deleted_by')) {
      context.handle(_deletedByMeta,
          deletedBy.isAcceptableOrUnknown(data['deleted_by']!, _deletedByMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MealPlanTemplateEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MealPlanTemplateEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      templateId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}template_id'])!,
      dayOffset: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}day_offset'])!,
      mealSlot: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}meal_slot'])!,
      recipeId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}recipe_id']),
      recipeTitleSnapshot: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}recipe_title_snapshot']),
      customTitle: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}custom_title']),
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      servings: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}servings']),
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      createdBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_by'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      updatedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_by'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
      deletedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}deleted_by']),
    );
  }

  @override
  MealPlanTemplateEntries createAlias(String alias) {
    return MealPlanTemplateEntries(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
        'CONSTRAINT meal_plan_template_entry_pkey PRIMARY KEY(id)',
        'CONSTRAINT meal_plan_template_entry_template_id_fkey FOREIGN KEY(template_id)REFERENCES meal_plan_templates(id)ON DELETE CASCADE',
        'CONSTRAINT meal_plan_template_entry_recipe_id_fkey FOREIGN KEY(recipe_id)REFERENCES recipes(id)ON DELETE SET NULL'
      ];
  @override
  bool get dontWriteConstraints => true;
}

class MealPlanTemplateEntry extends DataClass
    implements Insertable<MealPlanTemplateEntry> {
  final int id;
  final int templateId;
  final int dayOffset;
  final String mealSlot;
  final int? recipeId;
  final String? recipeTitleSnapshot;
  final String? customTitle;
  final String? note;
  final int? servings;
  final int sortOrder;
  final DateTime createdAt;
  final int createdBy;
  final DateTime updatedAt;
  final int updatedBy;
  final DateTime? deletedAt;
  final int? deletedBy;
  const MealPlanTemplateEntry(
      {required this.id,
      required this.templateId,
      required this.dayOffset,
      required this.mealSlot,
      this.recipeId,
      this.recipeTitleSnapshot,
      this.customTitle,
      this.note,
      this.servings,
      required this.sortOrder,
      required this.createdAt,
      required this.createdBy,
      required this.updatedAt,
      required this.updatedBy,
      this.deletedAt,
      this.deletedBy});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['template_id'] = Variable<int>(templateId);
    map['day_offset'] = Variable<int>(dayOffset);
    map['meal_slot'] = Variable<String>(mealSlot);
    if (!nullToAbsent || recipeId != null) {
      map['recipe_id'] = Variable<int>(recipeId);
    }
    if (!nullToAbsent || recipeTitleSnapshot != null) {
      map['recipe_title_snapshot'] = Variable<String>(recipeTitleSnapshot);
    }
    if (!nullToAbsent || customTitle != null) {
      map['custom_title'] = Variable<String>(customTitle);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || servings != null) {
      map['servings'] = Variable<int>(servings);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['created_by'] = Variable<int>(createdBy);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['updated_by'] = Variable<int>(updatedBy);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || deletedBy != null) {
      map['deleted_by'] = Variable<int>(deletedBy);
    }
    return map;
  }

  MealPlanTemplateEntriesCompanion toCompanion(bool nullToAbsent) {
    return MealPlanTemplateEntriesCompanion(
      id: Value(id),
      templateId: Value(templateId),
      dayOffset: Value(dayOffset),
      mealSlot: Value(mealSlot),
      recipeId: recipeId == null && nullToAbsent
          ? const Value.absent()
          : Value(recipeId),
      recipeTitleSnapshot: recipeTitleSnapshot == null && nullToAbsent
          ? const Value.absent()
          : Value(recipeTitleSnapshot),
      customTitle: customTitle == null && nullToAbsent
          ? const Value.absent()
          : Value(customTitle),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      servings: servings == null && nullToAbsent
          ? const Value.absent()
          : Value(servings),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
      createdBy: Value(createdBy),
      updatedAt: Value(updatedAt),
      updatedBy: Value(updatedBy),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deletedBy: deletedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedBy),
    );
  }

  factory MealPlanTemplateEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MealPlanTemplateEntry(
      id: serializer.fromJson<int>(json['id']),
      templateId: serializer.fromJson<int>(json['template_id']),
      dayOffset: serializer.fromJson<int>(json['day_offset']),
      mealSlot: serializer.fromJson<String>(json['meal_slot']),
      recipeId: serializer.fromJson<int?>(json['recipe_id']),
      recipeTitleSnapshot:
          serializer.fromJson<String?>(json['recipe_title_snapshot']),
      customTitle: serializer.fromJson<String?>(json['custom_title']),
      note: serializer.fromJson<String?>(json['note']),
      servings: serializer.fromJson<int?>(json['servings']),
      sortOrder: serializer.fromJson<int>(json['sort_order']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      createdBy: serializer.fromJson<int>(json['created_by']),
      updatedAt: serializer.fromJson<DateTime>(json['updated_at']),
      updatedBy: serializer.fromJson<int>(json['updated_by']),
      deletedAt: serializer.fromJson<DateTime?>(json['deleted_at']),
      deletedBy: serializer.fromJson<int?>(json['deleted_by']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'template_id': serializer.toJson<int>(templateId),
      'day_offset': serializer.toJson<int>(dayOffset),
      'meal_slot': serializer.toJson<String>(mealSlot),
      'recipe_id': serializer.toJson<int?>(recipeId),
      'recipe_title_snapshot': serializer.toJson<String?>(recipeTitleSnapshot),
      'custom_title': serializer.toJson<String?>(customTitle),
      'note': serializer.toJson<String?>(note),
      'servings': serializer.toJson<int?>(servings),
      'sort_order': serializer.toJson<int>(sortOrder),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'created_by': serializer.toJson<int>(createdBy),
      'updated_at': serializer.toJson<DateTime>(updatedAt),
      'updated_by': serializer.toJson<int>(updatedBy),
      'deleted_at': serializer.toJson<DateTime?>(deletedAt),
      'deleted_by': serializer.toJson<int?>(deletedBy),
    };
  }

  MealPlanTemplateEntry copyWith(
          {int? id,
          int? templateId,
          int? dayOffset,
          String? mealSlot,
          Value<int?> recipeId = const Value.absent(),
          Value<String?> recipeTitleSnapshot = const Value.absent(),
          Value<String?> customTitle = const Value.absent(),
          Value<String?> note = const Value.absent(),
          Value<int?> servings = const Value.absent(),
          int? sortOrder,
          DateTime? createdAt,
          int? createdBy,
          DateTime? updatedAt,
          int? updatedBy,
          Value<DateTime?> deletedAt = const Value.absent(),
          Value<int?> deletedBy = const Value.absent()}) =>
      MealPlanTemplateEntry(
        id: id ?? this.id,
        templateId: templateId ?? this.templateId,
        dayOffset: dayOffset ?? this.dayOffset,
        mealSlot: mealSlot ?? this.mealSlot,
        recipeId: recipeId.present ? recipeId.value : this.recipeId,
        recipeTitleSnapshot: recipeTitleSnapshot.present
            ? recipeTitleSnapshot.value
            : this.recipeTitleSnapshot,
        customTitle: customTitle.present ? customTitle.value : this.customTitle,
        note: note.present ? note.value : this.note,
        servings: servings.present ? servings.value : this.servings,
        sortOrder: sortOrder ?? this.sortOrder,
        createdAt: createdAt ?? this.createdAt,
        createdBy: createdBy ?? this.createdBy,
        updatedAt: updatedAt ?? this.updatedAt,
        updatedBy: updatedBy ?? this.updatedBy,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        deletedBy: deletedBy.present ? deletedBy.value : this.deletedBy,
      );
  MealPlanTemplateEntry copyWithCompanion(
      MealPlanTemplateEntriesCompanion data) {
    return MealPlanTemplateEntry(
      id: data.id.present ? data.id.value : this.id,
      templateId:
          data.templateId.present ? data.templateId.value : this.templateId,
      dayOffset: data.dayOffset.present ? data.dayOffset.value : this.dayOffset,
      mealSlot: data.mealSlot.present ? data.mealSlot.value : this.mealSlot,
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
      recipeTitleSnapshot: data.recipeTitleSnapshot.present
          ? data.recipeTitleSnapshot.value
          : this.recipeTitleSnapshot,
      customTitle:
          data.customTitle.present ? data.customTitle.value : this.customTitle,
      note: data.note.present ? data.note.value : this.note,
      servings: data.servings.present ? data.servings.value : this.servings,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deletedBy: data.deletedBy.present ? data.deletedBy.value : this.deletedBy,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MealPlanTemplateEntry(')
          ..write('id: $id, ')
          ..write('templateId: $templateId, ')
          ..write('dayOffset: $dayOffset, ')
          ..write('mealSlot: $mealSlot, ')
          ..write('recipeId: $recipeId, ')
          ..write('recipeTitleSnapshot: $recipeTitleSnapshot, ')
          ..write('customTitle: $customTitle, ')
          ..write('note: $note, ')
          ..write('servings: $servings, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deletedBy: $deletedBy')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      templateId,
      dayOffset,
      mealSlot,
      recipeId,
      recipeTitleSnapshot,
      customTitle,
      note,
      servings,
      sortOrder,
      createdAt,
      createdBy,
      updatedAt,
      updatedBy,
      deletedAt,
      deletedBy);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MealPlanTemplateEntry &&
          other.id == this.id &&
          other.templateId == this.templateId &&
          other.dayOffset == this.dayOffset &&
          other.mealSlot == this.mealSlot &&
          other.recipeId == this.recipeId &&
          other.recipeTitleSnapshot == this.recipeTitleSnapshot &&
          other.customTitle == this.customTitle &&
          other.note == this.note &&
          other.servings == this.servings &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt &&
          other.createdBy == this.createdBy &&
          other.updatedAt == this.updatedAt &&
          other.updatedBy == this.updatedBy &&
          other.deletedAt == this.deletedAt &&
          other.deletedBy == this.deletedBy);
}

class MealPlanTemplateEntriesCompanion
    extends UpdateCompanion<MealPlanTemplateEntry> {
  final Value<int> id;
  final Value<int> templateId;
  final Value<int> dayOffset;
  final Value<String> mealSlot;
  final Value<int?> recipeId;
  final Value<String?> recipeTitleSnapshot;
  final Value<String?> customTitle;
  final Value<String?> note;
  final Value<int?> servings;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  final Value<int> createdBy;
  final Value<DateTime> updatedAt;
  final Value<int> updatedBy;
  final Value<DateTime?> deletedAt;
  final Value<int?> deletedBy;
  const MealPlanTemplateEntriesCompanion({
    this.id = const Value.absent(),
    this.templateId = const Value.absent(),
    this.dayOffset = const Value.absent(),
    this.mealSlot = const Value.absent(),
    this.recipeId = const Value.absent(),
    this.recipeTitleSnapshot = const Value.absent(),
    this.customTitle = const Value.absent(),
    this.note = const Value.absent(),
    this.servings = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deletedBy = const Value.absent(),
  });
  MealPlanTemplateEntriesCompanion.insert({
    this.id = const Value.absent(),
    required int templateId,
    required int dayOffset,
    required String mealSlot,
    this.recipeId = const Value.absent(),
    this.recipeTitleSnapshot = const Value.absent(),
    this.customTitle = const Value.absent(),
    this.note = const Value.absent(),
    this.servings = const Value.absent(),
    this.sortOrder = const Value.absent(),
    required DateTime createdAt,
    required int createdBy,
    required DateTime updatedAt,
    required int updatedBy,
    this.deletedAt = const Value.absent(),
    this.deletedBy = const Value.absent(),
  })  : templateId = Value(templateId),
        dayOffset = Value(dayOffset),
        mealSlot = Value(mealSlot),
        createdAt = Value(createdAt),
        createdBy = Value(createdBy),
        updatedAt = Value(updatedAt),
        updatedBy = Value(updatedBy);
  static Insertable<MealPlanTemplateEntry> custom({
    Expression<int>? id,
    Expression<int>? templateId,
    Expression<int>? dayOffset,
    Expression<String>? mealSlot,
    Expression<int>? recipeId,
    Expression<String>? recipeTitleSnapshot,
    Expression<String>? customTitle,
    Expression<String>? note,
    Expression<int>? servings,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
    Expression<int>? createdBy,
    Expression<DateTime>? updatedAt,
    Expression<int>? updatedBy,
    Expression<DateTime>? deletedAt,
    Expression<int>? deletedBy,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (templateId != null) 'template_id': templateId,
      if (dayOffset != null) 'day_offset': dayOffset,
      if (mealSlot != null) 'meal_slot': mealSlot,
      if (recipeId != null) 'recipe_id': recipeId,
      if (recipeTitleSnapshot != null)
        'recipe_title_snapshot': recipeTitleSnapshot,
      if (customTitle != null) 'custom_title': customTitle,
      if (note != null) 'note': note,
      if (servings != null) 'servings': servings,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (createdBy != null) 'created_by': createdBy,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deletedBy != null) 'deleted_by': deletedBy,
    });
  }

  MealPlanTemplateEntriesCompanion copyWith(
      {Value<int>? id,
      Value<int>? templateId,
      Value<int>? dayOffset,
      Value<String>? mealSlot,
      Value<int?>? recipeId,
      Value<String?>? recipeTitleSnapshot,
      Value<String?>? customTitle,
      Value<String?>? note,
      Value<int?>? servings,
      Value<int>? sortOrder,
      Value<DateTime>? createdAt,
      Value<int>? createdBy,
      Value<DateTime>? updatedAt,
      Value<int>? updatedBy,
      Value<DateTime?>? deletedAt,
      Value<int?>? deletedBy}) {
    return MealPlanTemplateEntriesCompanion(
      id: id ?? this.id,
      templateId: templateId ?? this.templateId,
      dayOffset: dayOffset ?? this.dayOffset,
      mealSlot: mealSlot ?? this.mealSlot,
      recipeId: recipeId ?? this.recipeId,
      recipeTitleSnapshot: recipeTitleSnapshot ?? this.recipeTitleSnapshot,
      customTitle: customTitle ?? this.customTitle,
      note: note ?? this.note,
      servings: servings ?? this.servings,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      deletedAt: deletedAt ?? this.deletedAt,
      deletedBy: deletedBy ?? this.deletedBy,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (templateId.present) {
      map['template_id'] = Variable<int>(templateId.value);
    }
    if (dayOffset.present) {
      map['day_offset'] = Variable<int>(dayOffset.value);
    }
    if (mealSlot.present) {
      map['meal_slot'] = Variable<String>(mealSlot.value);
    }
    if (recipeId.present) {
      map['recipe_id'] = Variable<int>(recipeId.value);
    }
    if (recipeTitleSnapshot.present) {
      map['recipe_title_snapshot'] =
          Variable<String>(recipeTitleSnapshot.value);
    }
    if (customTitle.present) {
      map['custom_title'] = Variable<String>(customTitle.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (servings.present) {
      map['servings'] = Variable<int>(servings.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<int>(createdBy.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<int>(updatedBy.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (deletedBy.present) {
      map['deleted_by'] = Variable<int>(deletedBy.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MealPlanTemplateEntriesCompanion(')
          ..write('id: $id, ')
          ..write('templateId: $templateId, ')
          ..write('dayOffset: $dayOffset, ')
          ..write('mealSlot: $mealSlot, ')
          ..write('recipeId: $recipeId, ')
          ..write('recipeTitleSnapshot: $recipeTitleSnapshot, ')
          ..write('customTitle: $customTitle, ')
          ..write('note: $note, ')
          ..write('servings: $servings, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deletedBy: $deletedBy')
          ..write(')'))
        .toString();
  }
}

class PendingMutations extends Table
    with TableInfo<PendingMutations, PendingMutation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  PendingMutations(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _accountIdMeta =
      const VerificationMeta('accountId');
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
      'account_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  static const VerificationMeta _mutationTypeMeta =
      const VerificationMeta('mutationType');
  late final GeneratedColumn<String> mutationType = GeneratedColumn<String>(
      'mutation_type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _payloadMeta =
      const VerificationMeta('payload');
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
      'payload', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _attemptsMeta =
      const VerificationMeta('attempts');
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
      'attempts', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL DEFAULT 0',
      defaultValue: const CustomExpression('0'));
  static const VerificationMeta _lastErrorMeta =
      const VerificationMeta('lastError');
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
      'last_error', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  static const VerificationMeta _blockedMeta =
      const VerificationMeta('blocked');
  late final GeneratedColumn<bool> blocked = GeneratedColumn<bool>(
      'blocked', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL DEFAULT FALSE',
      defaultValue: const CustomExpression('FALSE'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        accountId,
        mutationType,
        payload,
        createdAt,
        attempts,
        lastError,
        blocked
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pending_mutations';
  @override
  VerificationContext validateIntegrity(Insertable<PendingMutation> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta,
          accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    }
    if (data.containsKey('mutation_type')) {
      context.handle(
          _mutationTypeMeta,
          mutationType.isAcceptableOrUnknown(
              data['mutation_type']!, _mutationTypeMeta));
    } else if (isInserting) {
      context.missing(_mutationTypeMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(_payloadMeta,
          payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta));
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('attempts')) {
      context.handle(_attemptsMeta,
          attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta));
    }
    if (data.containsKey('last_error')) {
      context.handle(_lastErrorMeta,
          lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta));
    }
    if (data.containsKey('blocked')) {
      context.handle(_blockedMeta,
          blocked.isAcceptableOrUnknown(data['blocked']!, _blockedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PendingMutation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PendingMutation(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      accountId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}account_id']),
      mutationType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mutation_type'])!,
      payload: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payload'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      attempts: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}attempts'])!,
      lastError: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_error']),
      blocked: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}blocked'])!,
    );
  }

  @override
  PendingMutations createAlias(String alias) {
    return PendingMutations(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints =>
      const ['CONSTRAINT pending_mutation_pkey PRIMARY KEY(id)'];
  @override
  bool get dontWriteConstraints => true;
}

class PendingMutation extends DataClass implements Insertable<PendingMutation> {
  final String id;
  final int? accountId;
  final String mutationType;
  final String payload;
  final DateTime createdAt;
  final int attempts;
  final String? lastError;
  final bool blocked;
  const PendingMutation(
      {required this.id,
      this.accountId,
      required this.mutationType,
      required this.payload,
      required this.createdAt,
      required this.attempts,
      this.lastError,
      required this.blocked});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || accountId != null) {
      map['account_id'] = Variable<int>(accountId);
    }
    map['mutation_type'] = Variable<String>(mutationType);
    map['payload'] = Variable<String>(payload);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['attempts'] = Variable<int>(attempts);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    map['blocked'] = Variable<bool>(blocked);
    return map;
  }

  PendingMutationsCompanion toCompanion(bool nullToAbsent) {
    return PendingMutationsCompanion(
      id: Value(id),
      accountId: accountId == null && nullToAbsent
          ? const Value.absent()
          : Value(accountId),
      mutationType: Value(mutationType),
      payload: Value(payload),
      createdAt: Value(createdAt),
      attempts: Value(attempts),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      blocked: Value(blocked),
    );
  }

  factory PendingMutation.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PendingMutation(
      id: serializer.fromJson<String>(json['id']),
      accountId: serializer.fromJson<int?>(json['account_id']),
      mutationType: serializer.fromJson<String>(json['mutation_type']),
      payload: serializer.fromJson<String>(json['payload']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      attempts: serializer.fromJson<int>(json['attempts']),
      lastError: serializer.fromJson<String?>(json['last_error']),
      blocked: serializer.fromJson<bool>(json['blocked']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'account_id': serializer.toJson<int?>(accountId),
      'mutation_type': serializer.toJson<String>(mutationType),
      'payload': serializer.toJson<String>(payload),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'attempts': serializer.toJson<int>(attempts),
      'last_error': serializer.toJson<String?>(lastError),
      'blocked': serializer.toJson<bool>(blocked),
    };
  }

  PendingMutation copyWith(
          {String? id,
          Value<int?> accountId = const Value.absent(),
          String? mutationType,
          String? payload,
          DateTime? createdAt,
          int? attempts,
          Value<String?> lastError = const Value.absent(),
          bool? blocked}) =>
      PendingMutation(
        id: id ?? this.id,
        accountId: accountId.present ? accountId.value : this.accountId,
        mutationType: mutationType ?? this.mutationType,
        payload: payload ?? this.payload,
        createdAt: createdAt ?? this.createdAt,
        attempts: attempts ?? this.attempts,
        lastError: lastError.present ? lastError.value : this.lastError,
        blocked: blocked ?? this.blocked,
      );
  PendingMutation copyWithCompanion(PendingMutationsCompanion data) {
    return PendingMutation(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      mutationType: data.mutationType.present
          ? data.mutationType.value
          : this.mutationType,
      payload: data.payload.present ? data.payload.value : this.payload,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      blocked: data.blocked.present ? data.blocked.value : this.blocked,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PendingMutation(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('mutationType: $mutationType, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('attempts: $attempts, ')
          ..write('lastError: $lastError, ')
          ..write('blocked: $blocked')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, accountId, mutationType, payload,
      createdAt, attempts, lastError, blocked);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PendingMutation &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.mutationType == this.mutationType &&
          other.payload == this.payload &&
          other.createdAt == this.createdAt &&
          other.attempts == this.attempts &&
          other.lastError == this.lastError &&
          other.blocked == this.blocked);
}

class PendingMutationsCompanion extends UpdateCompanion<PendingMutation> {
  final Value<String> id;
  final Value<int?> accountId;
  final Value<String> mutationType;
  final Value<String> payload;
  final Value<DateTime> createdAt;
  final Value<int> attempts;
  final Value<String?> lastError;
  final Value<bool> blocked;
  final Value<int> rowid;
  const PendingMutationsCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.mutationType = const Value.absent(),
    this.payload = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.attempts = const Value.absent(),
    this.lastError = const Value.absent(),
    this.blocked = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PendingMutationsCompanion.insert({
    required String id,
    this.accountId = const Value.absent(),
    required String mutationType,
    required String payload,
    required DateTime createdAt,
    this.attempts = const Value.absent(),
    this.lastError = const Value.absent(),
    this.blocked = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        mutationType = Value(mutationType),
        payload = Value(payload),
        createdAt = Value(createdAt);
  static Insertable<PendingMutation> custom({
    Expression<String>? id,
    Expression<int>? accountId,
    Expression<String>? mutationType,
    Expression<String>? payload,
    Expression<DateTime>? createdAt,
    Expression<int>? attempts,
    Expression<String>? lastError,
    Expression<bool>? blocked,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (mutationType != null) 'mutation_type': mutationType,
      if (payload != null) 'payload': payload,
      if (createdAt != null) 'created_at': createdAt,
      if (attempts != null) 'attempts': attempts,
      if (lastError != null) 'last_error': lastError,
      if (blocked != null) 'blocked': blocked,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PendingMutationsCompanion copyWith(
      {Value<String>? id,
      Value<int?>? accountId,
      Value<String>? mutationType,
      Value<String>? payload,
      Value<DateTime>? createdAt,
      Value<int>? attempts,
      Value<String?>? lastError,
      Value<bool>? blocked,
      Value<int>? rowid}) {
    return PendingMutationsCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      mutationType: mutationType ?? this.mutationType,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
      attempts: attempts ?? this.attempts,
      lastError: lastError ?? this.lastError,
      blocked: blocked ?? this.blocked,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (mutationType.present) {
      map['mutation_type'] = Variable<String>(mutationType.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (blocked.present) {
      map['blocked'] = Variable<bool>(blocked.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PendingMutationsCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('mutationType: $mutationType, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('attempts: $attempts, ')
          ..write('lastError: $lastError, ')
          ..write('blocked: $blocked, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class RecipeSteps extends Table with TableInfo<RecipeSteps, RecipeStep> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  RecipeSteps(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: '');
  static const VerificationMeta _recipeIdMeta =
      const VerificationMeta('recipeId');
  late final GeneratedColumn<int> recipeId = GeneratedColumn<int>(
      'recipe_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _stepNrMeta = const VerificationMeta('stepNr');
  late final GeneratedColumn<int> stepNr = GeneratedColumn<int>(
      'step_nr', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _imageMeta = const VerificationMeta('image');
  late final GeneratedColumn<String> image = GeneratedColumn<String>(
      'image', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _createdByMeta =
      const VerificationMeta('createdBy');
  late final GeneratedColumn<int> createdBy = GeneratedColumn<int>(
      'created_by', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _updatedByMeta =
      const VerificationMeta('updatedBy');
  late final GeneratedColumn<int> updatedBy = GeneratedColumn<int>(
      'updated_by', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  static const VerificationMeta _deletedByMeta =
      const VerificationMeta('deletedBy');
  late final GeneratedColumn<int> deletedBy = GeneratedColumn<int>(
      'deleted_by', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  @override
  List<GeneratedColumn> get $columns => [
        id,
        recipeId,
        stepNr,
        description,
        image,
        createdAt,
        createdBy,
        updatedAt,
        updatedBy,
        deletedAt,
        deletedBy
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipe_steps';
  @override
  VerificationContext validateIntegrity(Insertable<RecipeStep> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('recipe_id')) {
      context.handle(_recipeIdMeta,
          recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta));
    } else if (isInserting) {
      context.missing(_recipeIdMeta);
    }
    if (data.containsKey('step_nr')) {
      context.handle(_stepNrMeta,
          stepNr.isAcceptableOrUnknown(data['step_nr']!, _stepNrMeta));
    } else if (isInserting) {
      context.missing(_stepNrMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('image')) {
      context.handle(
          _imageMeta, image.isAcceptableOrUnknown(data['image']!, _imageMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('updated_by')) {
      context.handle(_updatedByMeta,
          updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta));
    } else if (isInserting) {
      context.missing(_updatedByMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('deleted_by')) {
      context.handle(_deletedByMeta,
          deletedBy.isAcceptableOrUnknown(data['deleted_by']!, _deletedByMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecipeStep map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecipeStep(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      recipeId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}recipe_id'])!,
      stepNr: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}step_nr'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      image: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      createdBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_by'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      updatedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_by'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
      deletedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}deleted_by']),
    );
  }

  @override
  RecipeSteps createAlias(String alias) {
    return RecipeSteps(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
        'CONSTRAINT recipe_steps_pkey PRIMARY KEY(id)',
        'CONSTRAINT recipe_step_recipe_id_fkey FOREIGN KEY(recipe_id)REFERENCES recipes(id)ON DELETE CASCADE'
      ];
  @override
  bool get dontWriteConstraints => true;
}

class RecipeStep extends DataClass implements Insertable<RecipeStep> {
  final int id;
  final int recipeId;
  final int stepNr;
  final String description;
  final String? image;
  final DateTime createdAt;
  final int createdBy;
  final DateTime updatedAt;
  final int updatedBy;
  final DateTime? deletedAt;
  final int? deletedBy;
  const RecipeStep(
      {required this.id,
      required this.recipeId,
      required this.stepNr,
      required this.description,
      this.image,
      required this.createdAt,
      required this.createdBy,
      required this.updatedAt,
      required this.updatedBy,
      this.deletedAt,
      this.deletedBy});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['recipe_id'] = Variable<int>(recipeId);
    map['step_nr'] = Variable<int>(stepNr);
    map['description'] = Variable<String>(description);
    if (!nullToAbsent || image != null) {
      map['image'] = Variable<String>(image);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['created_by'] = Variable<int>(createdBy);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['updated_by'] = Variable<int>(updatedBy);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || deletedBy != null) {
      map['deleted_by'] = Variable<int>(deletedBy);
    }
    return map;
  }

  RecipeStepsCompanion toCompanion(bool nullToAbsent) {
    return RecipeStepsCompanion(
      id: Value(id),
      recipeId: Value(recipeId),
      stepNr: Value(stepNr),
      description: Value(description),
      image:
          image == null && nullToAbsent ? const Value.absent() : Value(image),
      createdAt: Value(createdAt),
      createdBy: Value(createdBy),
      updatedAt: Value(updatedAt),
      updatedBy: Value(updatedBy),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deletedBy: deletedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedBy),
    );
  }

  factory RecipeStep.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecipeStep(
      id: serializer.fromJson<int>(json['id']),
      recipeId: serializer.fromJson<int>(json['recipe_id']),
      stepNr: serializer.fromJson<int>(json['step_nr']),
      description: serializer.fromJson<String>(json['description']),
      image: serializer.fromJson<String?>(json['image']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      createdBy: serializer.fromJson<int>(json['created_by']),
      updatedAt: serializer.fromJson<DateTime>(json['updated_at']),
      updatedBy: serializer.fromJson<int>(json['updated_by']),
      deletedAt: serializer.fromJson<DateTime?>(json['deleted_at']),
      deletedBy: serializer.fromJson<int?>(json['deleted_by']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'recipe_id': serializer.toJson<int>(recipeId),
      'step_nr': serializer.toJson<int>(stepNr),
      'description': serializer.toJson<String>(description),
      'image': serializer.toJson<String?>(image),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'created_by': serializer.toJson<int>(createdBy),
      'updated_at': serializer.toJson<DateTime>(updatedAt),
      'updated_by': serializer.toJson<int>(updatedBy),
      'deleted_at': serializer.toJson<DateTime?>(deletedAt),
      'deleted_by': serializer.toJson<int?>(deletedBy),
    };
  }

  RecipeStep copyWith(
          {int? id,
          int? recipeId,
          int? stepNr,
          String? description,
          Value<String?> image = const Value.absent(),
          DateTime? createdAt,
          int? createdBy,
          DateTime? updatedAt,
          int? updatedBy,
          Value<DateTime?> deletedAt = const Value.absent(),
          Value<int?> deletedBy = const Value.absent()}) =>
      RecipeStep(
        id: id ?? this.id,
        recipeId: recipeId ?? this.recipeId,
        stepNr: stepNr ?? this.stepNr,
        description: description ?? this.description,
        image: image.present ? image.value : this.image,
        createdAt: createdAt ?? this.createdAt,
        createdBy: createdBy ?? this.createdBy,
        updatedAt: updatedAt ?? this.updatedAt,
        updatedBy: updatedBy ?? this.updatedBy,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        deletedBy: deletedBy.present ? deletedBy.value : this.deletedBy,
      );
  RecipeStep copyWithCompanion(RecipeStepsCompanion data) {
    return RecipeStep(
      id: data.id.present ? data.id.value : this.id,
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
      stepNr: data.stepNr.present ? data.stepNr.value : this.stepNr,
      description:
          data.description.present ? data.description.value : this.description,
      image: data.image.present ? data.image.value : this.image,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deletedBy: data.deletedBy.present ? data.deletedBy.value : this.deletedBy,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecipeStep(')
          ..write('id: $id, ')
          ..write('recipeId: $recipeId, ')
          ..write('stepNr: $stepNr, ')
          ..write('description: $description, ')
          ..write('image: $image, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deletedBy: $deletedBy')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, recipeId, stepNr, description, image,
      createdAt, createdBy, updatedAt, updatedBy, deletedAt, deletedBy);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecipeStep &&
          other.id == this.id &&
          other.recipeId == this.recipeId &&
          other.stepNr == this.stepNr &&
          other.description == this.description &&
          other.image == this.image &&
          other.createdAt == this.createdAt &&
          other.createdBy == this.createdBy &&
          other.updatedAt == this.updatedAt &&
          other.updatedBy == this.updatedBy &&
          other.deletedAt == this.deletedAt &&
          other.deletedBy == this.deletedBy);
}

class RecipeStepsCompanion extends UpdateCompanion<RecipeStep> {
  final Value<int> id;
  final Value<int> recipeId;
  final Value<int> stepNr;
  final Value<String> description;
  final Value<String?> image;
  final Value<DateTime> createdAt;
  final Value<int> createdBy;
  final Value<DateTime> updatedAt;
  final Value<int> updatedBy;
  final Value<DateTime?> deletedAt;
  final Value<int?> deletedBy;
  const RecipeStepsCompanion({
    this.id = const Value.absent(),
    this.recipeId = const Value.absent(),
    this.stepNr = const Value.absent(),
    this.description = const Value.absent(),
    this.image = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deletedBy = const Value.absent(),
  });
  RecipeStepsCompanion.insert({
    this.id = const Value.absent(),
    required int recipeId,
    required int stepNr,
    required String description,
    this.image = const Value.absent(),
    required DateTime createdAt,
    required int createdBy,
    required DateTime updatedAt,
    required int updatedBy,
    this.deletedAt = const Value.absent(),
    this.deletedBy = const Value.absent(),
  })  : recipeId = Value(recipeId),
        stepNr = Value(stepNr),
        description = Value(description),
        createdAt = Value(createdAt),
        createdBy = Value(createdBy),
        updatedAt = Value(updatedAt),
        updatedBy = Value(updatedBy);
  static Insertable<RecipeStep> custom({
    Expression<int>? id,
    Expression<int>? recipeId,
    Expression<int>? stepNr,
    Expression<String>? description,
    Expression<String>? image,
    Expression<DateTime>? createdAt,
    Expression<int>? createdBy,
    Expression<DateTime>? updatedAt,
    Expression<int>? updatedBy,
    Expression<DateTime>? deletedAt,
    Expression<int>? deletedBy,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recipeId != null) 'recipe_id': recipeId,
      if (stepNr != null) 'step_nr': stepNr,
      if (description != null) 'description': description,
      if (image != null) 'image': image,
      if (createdAt != null) 'created_at': createdAt,
      if (createdBy != null) 'created_by': createdBy,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deletedBy != null) 'deleted_by': deletedBy,
    });
  }

  RecipeStepsCompanion copyWith(
      {Value<int>? id,
      Value<int>? recipeId,
      Value<int>? stepNr,
      Value<String>? description,
      Value<String?>? image,
      Value<DateTime>? createdAt,
      Value<int>? createdBy,
      Value<DateTime>? updatedAt,
      Value<int>? updatedBy,
      Value<DateTime?>? deletedAt,
      Value<int?>? deletedBy}) {
    return RecipeStepsCompanion(
      id: id ?? this.id,
      recipeId: recipeId ?? this.recipeId,
      stepNr: stepNr ?? this.stepNr,
      description: description ?? this.description,
      image: image ?? this.image,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      deletedAt: deletedAt ?? this.deletedAt,
      deletedBy: deletedBy ?? this.deletedBy,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (recipeId.present) {
      map['recipe_id'] = Variable<int>(recipeId.value);
    }
    if (stepNr.present) {
      map['step_nr'] = Variable<int>(stepNr.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (image.present) {
      map['image'] = Variable<String>(image.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<int>(createdBy.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<int>(updatedBy.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (deletedBy.present) {
      map['deleted_by'] = Variable<int>(deletedBy.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecipeStepsCompanion(')
          ..write('id: $id, ')
          ..write('recipeId: $recipeId, ')
          ..write('stepNr: $stepNr, ')
          ..write('description: $description, ')
          ..write('image: $image, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deletedBy: $deletedBy')
          ..write(')'))
        .toString();
  }
}

class RecipeStepIngredients extends Table
    with TableInfo<RecipeStepIngredients, RecipeStepIngredient> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  RecipeStepIngredients(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _recipeStepIdMeta =
      const VerificationMeta('recipeStepId');
  late final GeneratedColumn<int> recipeStepId = GeneratedColumn<int>(
      'recipe_step_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _ingredientIdMeta =
      const VerificationMeta('ingredientId');
  late final GeneratedColumn<int> ingredientId = GeneratedColumn<int>(
      'ingredient_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _createdByMeta =
      const VerificationMeta('createdBy');
  late final GeneratedColumn<int> createdBy = GeneratedColumn<int>(
      'created_by', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _updatedByMeta =
      const VerificationMeta('updatedBy');
  late final GeneratedColumn<int> updatedBy = GeneratedColumn<int>(
      'updated_by', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  static const VerificationMeta _deletedByMeta =
      const VerificationMeta('deletedBy');
  late final GeneratedColumn<int> deletedBy = GeneratedColumn<int>(
      'deleted_by', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  @override
  List<GeneratedColumn> get $columns => [
        recipeStepId,
        ingredientId,
        createdAt,
        createdBy,
        updatedAt,
        updatedBy,
        deletedAt,
        deletedBy
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipe_step_ingredients';
  @override
  VerificationContext validateIntegrity(
      Insertable<RecipeStepIngredient> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('recipe_step_id')) {
      context.handle(
          _recipeStepIdMeta,
          recipeStepId.isAcceptableOrUnknown(
              data['recipe_step_id']!, _recipeStepIdMeta));
    } else if (isInserting) {
      context.missing(_recipeStepIdMeta);
    }
    if (data.containsKey('ingredient_id')) {
      context.handle(
          _ingredientIdMeta,
          ingredientId.isAcceptableOrUnknown(
              data['ingredient_id']!, _ingredientIdMeta));
    } else if (isInserting) {
      context.missing(_ingredientIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('updated_by')) {
      context.handle(_updatedByMeta,
          updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta));
    } else if (isInserting) {
      context.missing(_updatedByMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('deleted_by')) {
      context.handle(_deletedByMeta,
          deletedBy.isAcceptableOrUnknown(data['deleted_by']!, _deletedByMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {recipeStepId, ingredientId};
  @override
  RecipeStepIngredient map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecipeStepIngredient(
      recipeStepId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}recipe_step_id'])!,
      ingredientId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ingredient_id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      createdBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_by'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      updatedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_by'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
      deletedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}deleted_by']),
    );
  }

  @override
  RecipeStepIngredients createAlias(String alias) {
    return RecipeStepIngredients(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
        'CONSTRAINT recipe_step_ingredient_pkey PRIMARY KEY(recipe_step_id, ingredient_id)',
        'CONSTRAINT recipe_step_ingredient_recipe_step_id_fkey FOREIGN KEY(recipe_step_id)REFERENCES recipe_steps(id)ON DELETE CASCADE',
        'CONSTRAINT recipe_step_ingredient_ingredient_id_fkey FOREIGN KEY(ingredient_id)REFERENCES ingredients(id)ON DELETE CASCADE'
      ];
  @override
  bool get dontWriteConstraints => true;
}

class RecipeStepIngredient extends DataClass
    implements Insertable<RecipeStepIngredient> {
  final int recipeStepId;
  final int ingredientId;
  final DateTime createdAt;
  final int createdBy;
  final DateTime updatedAt;
  final int updatedBy;
  final DateTime? deletedAt;
  final int? deletedBy;
  const RecipeStepIngredient(
      {required this.recipeStepId,
      required this.ingredientId,
      required this.createdAt,
      required this.createdBy,
      required this.updatedAt,
      required this.updatedBy,
      this.deletedAt,
      this.deletedBy});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['recipe_step_id'] = Variable<int>(recipeStepId);
    map['ingredient_id'] = Variable<int>(ingredientId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['created_by'] = Variable<int>(createdBy);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['updated_by'] = Variable<int>(updatedBy);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || deletedBy != null) {
      map['deleted_by'] = Variable<int>(deletedBy);
    }
    return map;
  }

  RecipeStepIngredientsCompanion toCompanion(bool nullToAbsent) {
    return RecipeStepIngredientsCompanion(
      recipeStepId: Value(recipeStepId),
      ingredientId: Value(ingredientId),
      createdAt: Value(createdAt),
      createdBy: Value(createdBy),
      updatedAt: Value(updatedAt),
      updatedBy: Value(updatedBy),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deletedBy: deletedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedBy),
    );
  }

  factory RecipeStepIngredient.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecipeStepIngredient(
      recipeStepId: serializer.fromJson<int>(json['recipe_step_id']),
      ingredientId: serializer.fromJson<int>(json['ingredient_id']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      createdBy: serializer.fromJson<int>(json['created_by']),
      updatedAt: serializer.fromJson<DateTime>(json['updated_at']),
      updatedBy: serializer.fromJson<int>(json['updated_by']),
      deletedAt: serializer.fromJson<DateTime?>(json['deleted_at']),
      deletedBy: serializer.fromJson<int?>(json['deleted_by']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'recipe_step_id': serializer.toJson<int>(recipeStepId),
      'ingredient_id': serializer.toJson<int>(ingredientId),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'created_by': serializer.toJson<int>(createdBy),
      'updated_at': serializer.toJson<DateTime>(updatedAt),
      'updated_by': serializer.toJson<int>(updatedBy),
      'deleted_at': serializer.toJson<DateTime?>(deletedAt),
      'deleted_by': serializer.toJson<int?>(deletedBy),
    };
  }

  RecipeStepIngredient copyWith(
          {int? recipeStepId,
          int? ingredientId,
          DateTime? createdAt,
          int? createdBy,
          DateTime? updatedAt,
          int? updatedBy,
          Value<DateTime?> deletedAt = const Value.absent(),
          Value<int?> deletedBy = const Value.absent()}) =>
      RecipeStepIngredient(
        recipeStepId: recipeStepId ?? this.recipeStepId,
        ingredientId: ingredientId ?? this.ingredientId,
        createdAt: createdAt ?? this.createdAt,
        createdBy: createdBy ?? this.createdBy,
        updatedAt: updatedAt ?? this.updatedAt,
        updatedBy: updatedBy ?? this.updatedBy,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        deletedBy: deletedBy.present ? deletedBy.value : this.deletedBy,
      );
  RecipeStepIngredient copyWithCompanion(RecipeStepIngredientsCompanion data) {
    return RecipeStepIngredient(
      recipeStepId: data.recipeStepId.present
          ? data.recipeStepId.value
          : this.recipeStepId,
      ingredientId: data.ingredientId.present
          ? data.ingredientId.value
          : this.ingredientId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deletedBy: data.deletedBy.present ? data.deletedBy.value : this.deletedBy,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecipeStepIngredient(')
          ..write('recipeStepId: $recipeStepId, ')
          ..write('ingredientId: $ingredientId, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deletedBy: $deletedBy')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(recipeStepId, ingredientId, createdAt,
      createdBy, updatedAt, updatedBy, deletedAt, deletedBy);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecipeStepIngredient &&
          other.recipeStepId == this.recipeStepId &&
          other.ingredientId == this.ingredientId &&
          other.createdAt == this.createdAt &&
          other.createdBy == this.createdBy &&
          other.updatedAt == this.updatedAt &&
          other.updatedBy == this.updatedBy &&
          other.deletedAt == this.deletedAt &&
          other.deletedBy == this.deletedBy);
}

class RecipeStepIngredientsCompanion
    extends UpdateCompanion<RecipeStepIngredient> {
  final Value<int> recipeStepId;
  final Value<int> ingredientId;
  final Value<DateTime> createdAt;
  final Value<int> createdBy;
  final Value<DateTime> updatedAt;
  final Value<int> updatedBy;
  final Value<DateTime?> deletedAt;
  final Value<int?> deletedBy;
  final Value<int> rowid;
  const RecipeStepIngredientsCompanion({
    this.recipeStepId = const Value.absent(),
    this.ingredientId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deletedBy = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecipeStepIngredientsCompanion.insert({
    required int recipeStepId,
    required int ingredientId,
    required DateTime createdAt,
    required int createdBy,
    required DateTime updatedAt,
    required int updatedBy,
    this.deletedAt = const Value.absent(),
    this.deletedBy = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : recipeStepId = Value(recipeStepId),
        ingredientId = Value(ingredientId),
        createdAt = Value(createdAt),
        createdBy = Value(createdBy),
        updatedAt = Value(updatedAt),
        updatedBy = Value(updatedBy);
  static Insertable<RecipeStepIngredient> custom({
    Expression<int>? recipeStepId,
    Expression<int>? ingredientId,
    Expression<DateTime>? createdAt,
    Expression<int>? createdBy,
    Expression<DateTime>? updatedAt,
    Expression<int>? updatedBy,
    Expression<DateTime>? deletedAt,
    Expression<int>? deletedBy,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (recipeStepId != null) 'recipe_step_id': recipeStepId,
      if (ingredientId != null) 'ingredient_id': ingredientId,
      if (createdAt != null) 'created_at': createdAt,
      if (createdBy != null) 'created_by': createdBy,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deletedBy != null) 'deleted_by': deletedBy,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecipeStepIngredientsCompanion copyWith(
      {Value<int>? recipeStepId,
      Value<int>? ingredientId,
      Value<DateTime>? createdAt,
      Value<int>? createdBy,
      Value<DateTime>? updatedAt,
      Value<int>? updatedBy,
      Value<DateTime?>? deletedAt,
      Value<int?>? deletedBy,
      Value<int>? rowid}) {
    return RecipeStepIngredientsCompanion(
      recipeStepId: recipeStepId ?? this.recipeStepId,
      ingredientId: ingredientId ?? this.ingredientId,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      deletedAt: deletedAt ?? this.deletedAt,
      deletedBy: deletedBy ?? this.deletedBy,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (recipeStepId.present) {
      map['recipe_step_id'] = Variable<int>(recipeStepId.value);
    }
    if (ingredientId.present) {
      map['ingredient_id'] = Variable<int>(ingredientId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<int>(createdBy.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<int>(updatedBy.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (deletedBy.present) {
      map['deleted_by'] = Variable<int>(deletedBy.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecipeStepIngredientsCompanion(')
          ..write('recipeStepId: $recipeStepId, ')
          ..write('ingredientId: $ingredientId, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deletedBy: $deletedBy, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class RecipesCategories extends Table
    with TableInfo<RecipesCategories, RecipeCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  RecipesCategories(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
      'category_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _recipeIdMeta =
      const VerificationMeta('recipeId');
  late final GeneratedColumn<int> recipeId = GeneratedColumn<int>(
      'recipe_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _createdByMeta =
      const VerificationMeta('createdBy');
  late final GeneratedColumn<int> createdBy = GeneratedColumn<int>(
      'created_by', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _updatedByMeta =
      const VerificationMeta('updatedBy');
  late final GeneratedColumn<int> updatedBy = GeneratedColumn<int>(
      'updated_by', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  static const VerificationMeta _deletedByMeta =
      const VerificationMeta('deletedBy');
  late final GeneratedColumn<int> deletedBy = GeneratedColumn<int>(
      'deleted_by', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  @override
  List<GeneratedColumn> get $columns => [
        categoryId,
        recipeId,
        createdAt,
        createdBy,
        updatedAt,
        updatedBy,
        deletedAt,
        deletedBy
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'RecipesCategories';
  @override
  VerificationContext validateIntegrity(Insertable<RecipeCategory> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('recipe_id')) {
      context.handle(_recipeIdMeta,
          recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta));
    } else if (isInserting) {
      context.missing(_recipeIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('updated_by')) {
      context.handle(_updatedByMeta,
          updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta));
    } else if (isInserting) {
      context.missing(_updatedByMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('deleted_by')) {
      context.handle(_deletedByMeta,
          deletedBy.isAcceptableOrUnknown(data['deleted_by']!, _deletedByMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {categoryId, recipeId};
  @override
  RecipeCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecipeCategory(
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}category_id'])!,
      recipeId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}recipe_id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      createdBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_by'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      updatedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_by'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
      deletedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}deleted_by']),
    );
  }

  @override
  RecipesCategories createAlias(String alias) {
    return RecipesCategories(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
        'CONSTRAINT recipe_category_pkey PRIMARY KEY(category_id, recipe_id)',
        'CONSTRAINT recipe_category_category_id_fkey FOREIGN KEY(category_id)REFERENCES categories(id)ON DELETE CASCADE',
        'CONSTRAINT recipe_category_recipe_id_fkey FOREIGN KEY(recipe_id)REFERENCES recipes(id)ON DELETE CASCADE'
      ];
  @override
  bool get dontWriteConstraints => true;
}

class RecipeCategory extends DataClass implements Insertable<RecipeCategory> {
  final int categoryId;
  final int recipeId;
  final DateTime createdAt;
  final int createdBy;
  final DateTime updatedAt;
  final int updatedBy;
  final DateTime? deletedAt;
  final int? deletedBy;
  const RecipeCategory(
      {required this.categoryId,
      required this.recipeId,
      required this.createdAt,
      required this.createdBy,
      required this.updatedAt,
      required this.updatedBy,
      this.deletedAt,
      this.deletedBy});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['category_id'] = Variable<int>(categoryId);
    map['recipe_id'] = Variable<int>(recipeId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['created_by'] = Variable<int>(createdBy);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['updated_by'] = Variable<int>(updatedBy);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || deletedBy != null) {
      map['deleted_by'] = Variable<int>(deletedBy);
    }
    return map;
  }

  RecipesCategoriesCompanion toCompanion(bool nullToAbsent) {
    return RecipesCategoriesCompanion(
      categoryId: Value(categoryId),
      recipeId: Value(recipeId),
      createdAt: Value(createdAt),
      createdBy: Value(createdBy),
      updatedAt: Value(updatedAt),
      updatedBy: Value(updatedBy),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deletedBy: deletedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedBy),
    );
  }

  factory RecipeCategory.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecipeCategory(
      categoryId: serializer.fromJson<int>(json['category_id']),
      recipeId: serializer.fromJson<int>(json['recipe_id']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      createdBy: serializer.fromJson<int>(json['created_by']),
      updatedAt: serializer.fromJson<DateTime>(json['updated_at']),
      updatedBy: serializer.fromJson<int>(json['updated_by']),
      deletedAt: serializer.fromJson<DateTime?>(json['deleted_at']),
      deletedBy: serializer.fromJson<int?>(json['deleted_by']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'category_id': serializer.toJson<int>(categoryId),
      'recipe_id': serializer.toJson<int>(recipeId),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'created_by': serializer.toJson<int>(createdBy),
      'updated_at': serializer.toJson<DateTime>(updatedAt),
      'updated_by': serializer.toJson<int>(updatedBy),
      'deleted_at': serializer.toJson<DateTime?>(deletedAt),
      'deleted_by': serializer.toJson<int?>(deletedBy),
    };
  }

  RecipeCategory copyWith(
          {int? categoryId,
          int? recipeId,
          DateTime? createdAt,
          int? createdBy,
          DateTime? updatedAt,
          int? updatedBy,
          Value<DateTime?> deletedAt = const Value.absent(),
          Value<int?> deletedBy = const Value.absent()}) =>
      RecipeCategory(
        categoryId: categoryId ?? this.categoryId,
        recipeId: recipeId ?? this.recipeId,
        createdAt: createdAt ?? this.createdAt,
        createdBy: createdBy ?? this.createdBy,
        updatedAt: updatedAt ?? this.updatedAt,
        updatedBy: updatedBy ?? this.updatedBy,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        deletedBy: deletedBy.present ? deletedBy.value : this.deletedBy,
      );
  RecipeCategory copyWithCompanion(RecipesCategoriesCompanion data) {
    return RecipeCategory(
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deletedBy: data.deletedBy.present ? data.deletedBy.value : this.deletedBy,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecipeCategory(')
          ..write('categoryId: $categoryId, ')
          ..write('recipeId: $recipeId, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deletedBy: $deletedBy')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(categoryId, recipeId, createdAt, createdBy,
      updatedAt, updatedBy, deletedAt, deletedBy);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecipeCategory &&
          other.categoryId == this.categoryId &&
          other.recipeId == this.recipeId &&
          other.createdAt == this.createdAt &&
          other.createdBy == this.createdBy &&
          other.updatedAt == this.updatedAt &&
          other.updatedBy == this.updatedBy &&
          other.deletedAt == this.deletedAt &&
          other.deletedBy == this.deletedBy);
}

class RecipesCategoriesCompanion extends UpdateCompanion<RecipeCategory> {
  final Value<int> categoryId;
  final Value<int> recipeId;
  final Value<DateTime> createdAt;
  final Value<int> createdBy;
  final Value<DateTime> updatedAt;
  final Value<int> updatedBy;
  final Value<DateTime?> deletedAt;
  final Value<int?> deletedBy;
  final Value<int> rowid;
  const RecipesCategoriesCompanion({
    this.categoryId = const Value.absent(),
    this.recipeId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deletedBy = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecipesCategoriesCompanion.insert({
    required int categoryId,
    required int recipeId,
    required DateTime createdAt,
    required int createdBy,
    required DateTime updatedAt,
    required int updatedBy,
    this.deletedAt = const Value.absent(),
    this.deletedBy = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : categoryId = Value(categoryId),
        recipeId = Value(recipeId),
        createdAt = Value(createdAt),
        createdBy = Value(createdBy),
        updatedAt = Value(updatedAt),
        updatedBy = Value(updatedBy);
  static Insertable<RecipeCategory> custom({
    Expression<int>? categoryId,
    Expression<int>? recipeId,
    Expression<DateTime>? createdAt,
    Expression<int>? createdBy,
    Expression<DateTime>? updatedAt,
    Expression<int>? updatedBy,
    Expression<DateTime>? deletedAt,
    Expression<int>? deletedBy,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (categoryId != null) 'category_id': categoryId,
      if (recipeId != null) 'recipe_id': recipeId,
      if (createdAt != null) 'created_at': createdAt,
      if (createdBy != null) 'created_by': createdBy,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deletedBy != null) 'deleted_by': deletedBy,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecipesCategoriesCompanion copyWith(
      {Value<int>? categoryId,
      Value<int>? recipeId,
      Value<DateTime>? createdAt,
      Value<int>? createdBy,
      Value<DateTime>? updatedAt,
      Value<int>? updatedBy,
      Value<DateTime?>? deletedAt,
      Value<int?>? deletedBy,
      Value<int>? rowid}) {
    return RecipesCategoriesCompanion(
      categoryId: categoryId ?? this.categoryId,
      recipeId: recipeId ?? this.recipeId,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      deletedAt: deletedAt ?? this.deletedAt,
      deletedBy: deletedBy ?? this.deletedBy,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (recipeId.present) {
      map['recipe_id'] = Variable<int>(recipeId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<int>(createdBy.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<int>(updatedBy.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (deletedBy.present) {
      map['deleted_by'] = Variable<int>(deletedBy.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecipesCategoriesCompanion(')
          ..write('categoryId: $categoryId, ')
          ..write('recipeId: $recipeId, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deletedBy: $deletedBy, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Settings extends Table with TableInfo<Settings, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Settings(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _accountIdMeta =
      const VerificationMeta('accountId');
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
      'account_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: '');
  static const VerificationMeta _languageMeta =
      const VerificationMeta('language');
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
      'language', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _createdByMeta =
      const VerificationMeta('createdBy');
  late final GeneratedColumn<int> createdBy = GeneratedColumn<int>(
      'created_by', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _updatedByMeta =
      const VerificationMeta('updatedBy');
  late final GeneratedColumn<int> updatedBy = GeneratedColumn<int>(
      'updated_by', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  static const VerificationMeta _deletedByMeta =
      const VerificationMeta('deletedBy');
  late final GeneratedColumn<int> deletedBy = GeneratedColumn<int>(
      'deleted_by', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  static const VerificationMeta _realtimeMeta =
      const VerificationMeta('realtime');
  late final GeneratedColumn<bool> realtime = GeneratedColumn<bool>(
      'realtime', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _lightmodeMeta =
      const VerificationMeta('lightmode');
  late final GeneratedColumn<bool> lightmode = GeneratedColumn<bool>(
      'lightmode', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  @override
  List<GeneratedColumn> get $columns => [
        accountId,
        language,
        createdAt,
        createdBy,
        updatedAt,
        updatedBy,
        deletedAt,
        deletedBy,
        realtime,
        lightmode
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(Insertable<Setting> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta,
          accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    }
    if (data.containsKey('language')) {
      context.handle(_languageMeta,
          language.isAcceptableOrUnknown(data['language']!, _languageMeta));
    } else if (isInserting) {
      context.missing(_languageMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('updated_by')) {
      context.handle(_updatedByMeta,
          updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta));
    } else if (isInserting) {
      context.missing(_updatedByMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('deleted_by')) {
      context.handle(_deletedByMeta,
          deletedBy.isAcceptableOrUnknown(data['deleted_by']!, _deletedByMeta));
    }
    if (data.containsKey('realtime')) {
      context.handle(_realtimeMeta,
          realtime.isAcceptableOrUnknown(data['realtime']!, _realtimeMeta));
    } else if (isInserting) {
      context.missing(_realtimeMeta);
    }
    if (data.containsKey('lightmode')) {
      context.handle(_lightmodeMeta,
          lightmode.isAcceptableOrUnknown(data['lightmode']!, _lightmodeMeta));
    } else if (isInserting) {
      context.missing(_lightmodeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {accountId};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      accountId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}account_id'])!,
      language: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}language'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      createdBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_by'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      updatedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_by'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
      deletedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}deleted_by']),
      realtime: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}realtime'])!,
      lightmode: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}lightmode'])!,
    );
  }

  @override
  Settings createAlias(String alias) {
    return Settings(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
        'CONSTRAINT setting_pkey PRIMARY KEY(account_id)',
        'CONSTRAINT setting_account_id_fkey FOREIGN KEY(account_id)REFERENCES accounts(id)ON DELETE CASCADE'
      ];
  @override
  bool get dontWriteConstraints => true;
}

class Setting extends DataClass implements Insertable<Setting> {
  final int accountId;
  final String language;
  final DateTime createdAt;
  final int createdBy;
  final DateTime updatedAt;
  final int updatedBy;
  final DateTime? deletedAt;
  final int? deletedBy;
  final bool realtime;
  final bool lightmode;
  const Setting(
      {required this.accountId,
      required this.language,
      required this.createdAt,
      required this.createdBy,
      required this.updatedAt,
      required this.updatedBy,
      this.deletedAt,
      this.deletedBy,
      required this.realtime,
      required this.lightmode});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['account_id'] = Variable<int>(accountId);
    map['language'] = Variable<String>(language);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['created_by'] = Variable<int>(createdBy);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['updated_by'] = Variable<int>(updatedBy);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || deletedBy != null) {
      map['deleted_by'] = Variable<int>(deletedBy);
    }
    map['realtime'] = Variable<bool>(realtime);
    map['lightmode'] = Variable<bool>(lightmode);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(
      accountId: Value(accountId),
      language: Value(language),
      createdAt: Value(createdAt),
      createdBy: Value(createdBy),
      updatedAt: Value(updatedAt),
      updatedBy: Value(updatedBy),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deletedBy: deletedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedBy),
      realtime: Value(realtime),
      lightmode: Value(lightmode),
    );
  }

  factory Setting.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      accountId: serializer.fromJson<int>(json['account_id']),
      language: serializer.fromJson<String>(json['language']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      createdBy: serializer.fromJson<int>(json['created_by']),
      updatedAt: serializer.fromJson<DateTime>(json['updated_at']),
      updatedBy: serializer.fromJson<int>(json['updated_by']),
      deletedAt: serializer.fromJson<DateTime?>(json['deleted_at']),
      deletedBy: serializer.fromJson<int?>(json['deleted_by']),
      realtime: serializer.fromJson<bool>(json['realtime']),
      lightmode: serializer.fromJson<bool>(json['lightmode']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'account_id': serializer.toJson<int>(accountId),
      'language': serializer.toJson<String>(language),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'created_by': serializer.toJson<int>(createdBy),
      'updated_at': serializer.toJson<DateTime>(updatedAt),
      'updated_by': serializer.toJson<int>(updatedBy),
      'deleted_at': serializer.toJson<DateTime?>(deletedAt),
      'deleted_by': serializer.toJson<int?>(deletedBy),
      'realtime': serializer.toJson<bool>(realtime),
      'lightmode': serializer.toJson<bool>(lightmode),
    };
  }

  Setting copyWith(
          {int? accountId,
          String? language,
          DateTime? createdAt,
          int? createdBy,
          DateTime? updatedAt,
          int? updatedBy,
          Value<DateTime?> deletedAt = const Value.absent(),
          Value<int?> deletedBy = const Value.absent(),
          bool? realtime,
          bool? lightmode}) =>
      Setting(
        accountId: accountId ?? this.accountId,
        language: language ?? this.language,
        createdAt: createdAt ?? this.createdAt,
        createdBy: createdBy ?? this.createdBy,
        updatedAt: updatedAt ?? this.updatedAt,
        updatedBy: updatedBy ?? this.updatedBy,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        deletedBy: deletedBy.present ? deletedBy.value : this.deletedBy,
        realtime: realtime ?? this.realtime,
        lightmode: lightmode ?? this.lightmode,
      );
  Setting copyWithCompanion(SettingsCompanion data) {
    return Setting(
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      language: data.language.present ? data.language.value : this.language,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deletedBy: data.deletedBy.present ? data.deletedBy.value : this.deletedBy,
      realtime: data.realtime.present ? data.realtime.value : this.realtime,
      lightmode: data.lightmode.present ? data.lightmode.value : this.lightmode,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('accountId: $accountId, ')
          ..write('language: $language, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deletedBy: $deletedBy, ')
          ..write('realtime: $realtime, ')
          ..write('lightmode: $lightmode')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(accountId, language, createdAt, createdBy,
      updatedAt, updatedBy, deletedAt, deletedBy, realtime, lightmode);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting &&
          other.accountId == this.accountId &&
          other.language == this.language &&
          other.createdAt == this.createdAt &&
          other.createdBy == this.createdBy &&
          other.updatedAt == this.updatedAt &&
          other.updatedBy == this.updatedBy &&
          other.deletedAt == this.deletedAt &&
          other.deletedBy == this.deletedBy &&
          other.realtime == this.realtime &&
          other.lightmode == this.lightmode);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<int> accountId;
  final Value<String> language;
  final Value<DateTime> createdAt;
  final Value<int> createdBy;
  final Value<DateTime> updatedAt;
  final Value<int> updatedBy;
  final Value<DateTime?> deletedAt;
  final Value<int?> deletedBy;
  final Value<bool> realtime;
  final Value<bool> lightmode;
  const SettingsCompanion({
    this.accountId = const Value.absent(),
    this.language = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deletedBy = const Value.absent(),
    this.realtime = const Value.absent(),
    this.lightmode = const Value.absent(),
  });
  SettingsCompanion.insert({
    this.accountId = const Value.absent(),
    required String language,
    required DateTime createdAt,
    required int createdBy,
    required DateTime updatedAt,
    required int updatedBy,
    this.deletedAt = const Value.absent(),
    this.deletedBy = const Value.absent(),
    required bool realtime,
    required bool lightmode,
  })  : language = Value(language),
        createdAt = Value(createdAt),
        createdBy = Value(createdBy),
        updatedAt = Value(updatedAt),
        updatedBy = Value(updatedBy),
        realtime = Value(realtime),
        lightmode = Value(lightmode);
  static Insertable<Setting> custom({
    Expression<int>? accountId,
    Expression<String>? language,
    Expression<DateTime>? createdAt,
    Expression<int>? createdBy,
    Expression<DateTime>? updatedAt,
    Expression<int>? updatedBy,
    Expression<DateTime>? deletedAt,
    Expression<int>? deletedBy,
    Expression<bool>? realtime,
    Expression<bool>? lightmode,
  }) {
    return RawValuesInsertable({
      if (accountId != null) 'account_id': accountId,
      if (language != null) 'language': language,
      if (createdAt != null) 'created_at': createdAt,
      if (createdBy != null) 'created_by': createdBy,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deletedBy != null) 'deleted_by': deletedBy,
      if (realtime != null) 'realtime': realtime,
      if (lightmode != null) 'lightmode': lightmode,
    });
  }

  SettingsCompanion copyWith(
      {Value<int>? accountId,
      Value<String>? language,
      Value<DateTime>? createdAt,
      Value<int>? createdBy,
      Value<DateTime>? updatedAt,
      Value<int>? updatedBy,
      Value<DateTime?>? deletedAt,
      Value<int?>? deletedBy,
      Value<bool>? realtime,
      Value<bool>? lightmode}) {
    return SettingsCompanion(
      accountId: accountId ?? this.accountId,
      language: language ?? this.language,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      deletedAt: deletedAt ?? this.deletedAt,
      deletedBy: deletedBy ?? this.deletedBy,
      realtime: realtime ?? this.realtime,
      lightmode: lightmode ?? this.lightmode,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<int>(createdBy.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<int>(updatedBy.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (deletedBy.present) {
      map['deleted_by'] = Variable<int>(deletedBy.value);
    }
    if (realtime.present) {
      map['realtime'] = Variable<bool>(realtime.value);
    }
    if (lightmode.present) {
      map['lightmode'] = Variable<bool>(lightmode.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('accountId: $accountId, ')
          ..write('language: $language, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deletedBy: $deletedBy, ')
          ..write('realtime: $realtime, ')
          ..write('lightmode: $lightmode')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final Categories categories = Categories(this);
  late final Recipes recipes = Recipes(this);
  late final ShoppingCategories shoppingCategories = ShoppingCategories(this);
  late final Ingredients ingredients = Ingredients(this);
  late final MeasurementUnits measurementUnits = MeasurementUnits(this);
  late final RecipeIngredients recipeIngredients = RecipeIngredients(this);
  late final Roles roles = Roles(this);
  late final Accounts accounts = Accounts(this);
  late final Comments comments = Comments(this);
  late final Histories histories = Histories(this);
  late final Profiles profiles = Profiles(this);
  late final AccountFollows accountFollows = AccountFollows(this);
  late final AccountFriends accountFriends = AccountFriends(this);
  late final ChatConversations chatConversations = ChatConversations(this);
  late final ChatMessages chatMessages = ChatMessages(this);
  late final ChatMessageReactions chatMessageReactions =
      ChatMessageReactions(this);
  late final RecipeLikes recipeLikes = RecipeLikes(this);
  late final ShoppingLists shoppingLists = ShoppingLists(this);
  late final ShoppingListSections shoppingListSections =
      ShoppingListSections(this);
  late final ShoppingListItems shoppingListItems = ShoppingListItems(this);
  late final ShoppingListMembers shoppingListMembers =
      ShoppingListMembers(this);
  late final MealPlans mealPlans = MealPlans(this);
  late final MealPlanMembers mealPlanMembers = MealPlanMembers(this);
  late final MealPlanEntries mealPlanEntries = MealPlanEntries(this);
  late final MealPlanTemplates mealPlanTemplates = MealPlanTemplates(this);
  late final MealPlanTemplateEntries mealPlanTemplateEntries =
      MealPlanTemplateEntries(this);
  late final PendingMutations pendingMutations = PendingMutations(this);
  late final RecipeSteps recipeSteps = RecipeSteps(this);
  late final RecipeStepIngredients recipeStepIngredients =
      RecipeStepIngredients(this);
  late final RecipesCategories recipesCategories = RecipesCategories(this);
  late final Settings settings = Settings(this);
  Future<int> updateHistoryEntry(int recipeId, DateTime updatedAt,
      int accountId, int createdBy, DateTime createdAt, int updatedBy) {
    return customInsert(
      'WITH new_id AS (SELECT ?1 AS recipe_id, ?2 AS updated_at) INSERT INTO histories (account_id, recipe_id, created_by, created_at, updated_at, updated_by, step_nr, open) VALUES (?3, (SELECT recipe_id FROM new_id), ?4, ?5, ?2, ?6, (SELECT i.step_nr FROM recipe_steps AS i WHERE i.step_nr = (SELECT MIN(j.step_nr) FROM recipe_steps AS j WHERE j.recipe_id = (SELECT recipe_id FROM new_id)) AND i.recipe_id = (SELECT recipe_id FROM new_id)), FALSE) ON CONFLICT (account_id, recipe_id) DO UPDATE SET updated_at = (SELECT updated_at FROM new_id), open = FALSE',
      variables: [
        Variable<int>(recipeId),
        Variable<DateTime>(updatedAt),
        Variable<int>(accountId),
        Variable<int>(createdBy),
        Variable<DateTime>(createdAt),
        Variable<int>(updatedBy)
      ],
      updates: {histories},
    );
  }

  Selectable<OpenRecipeResult> openRecipe(int accountId) {
    return customSelect(
        'SELECT * FROM recipes INNER JOIN histories ON recipes.id = histories.recipe_id WHERE histories.account_id = ?1 AND histories.updated_at = (SELECT MAX(updated_at) FROM histories WHERE account_id = ?1) AND recipes.deleted_at IS NULL AND histories.open = TRUE',
        variables: [
          Variable<int>(accountId)
        ],
        readsFrom: {
          recipes,
          histories,
        }).map((QueryRow row) => OpenRecipeResult(
          id: row.read<int>('id'),
          title: row.read<String>('title'),
          image: row.readNullable<String>('image'),
          description: row.readNullable<String>('description'),
          notes: row.readNullable<String>('notes'),
          totalTimeMinutes: row.readNullable<int>('total_time_minutes'),
          servings: row.readNullable<int>('servings'),
          revision: row.read<int>('revision'),
          createdAt: row.read<DateTime>('created_at'),
          createdBy: row.read<int>('created_by'),
          updatedAt: row.read<DateTime>('updated_at'),
          updatedBy: row.read<int>('updated_by'),
          deletedAt: row.readNullable<DateTime>('deleted_at'),
          deletedBy: row.readNullable<int>('deleted_by'),
          accountId: row.read<int>('account_id'),
          recipeId: row.read<int>('recipe_id'),
          createdAt1: row.read<DateTime>('created_at'),
          createdBy1: row.read<int>('created_by'),
          updatedAt1: row.read<DateTime>('updated_at'),
          updatedBy1: row.read<int>('updated_by'),
          deletedAt1: row.readNullable<DateTime>('deleted_at'),
          deletedBy1: row.readNullable<int>('deleted_by'),
          stepNr: row.readNullable<int>('step_nr'),
          open: row.read<bool>('open'),
          additionalData: row.readNullable<String>('additional_data'),
        ));
  }

  Selectable<IngredientsOfRecipeResult> ingredientsOfRecipe(int recipeId) {
    return customSelect(
        'SELECT ingredients.*, recipe_ingredients.amount, recipe_ingredients.unit, recipe_ingredients.quantity_note, recipe_ingredients.section_name, recipe_ingredients.sort_order FROM ingredients INNER JOIN recipe_ingredients ON ingredients.id = recipe_ingredients.ingredient_id WHERE recipe_ingredients.recipe_id = ?1 AND ingredients.deleted_at IS NULL AND recipe_ingredients.deleted_at IS NULL ORDER BY recipe_ingredients.sort_order, recipe_ingredients.created_at, recipe_ingredients.ingredient_id',
        variables: [
          Variable<int>(recipeId)
        ],
        readsFrom: {
          recipeIngredients,
          ingredients,
        }).map((QueryRow row) => IngredientsOfRecipeResult(
          id: row.read<int>('id'),
          name: row.read<String>('name'),
          shoppingCategoryCode:
              row.readNullable<String>('shopping_category_code'),
          createdAt: row.read<DateTime>('created_at'),
          createdBy: row.read<int>('created_by'),
          updatedAt: row.read<DateTime>('updated_at'),
          updatedBy: row.read<int>('updated_by'),
          deletedAt: row.readNullable<DateTime>('deleted_at'),
          deletedBy: row.readNullable<int>('deleted_by'),
          amount: row.readNullable<double>('amount'),
          unit: row.readNullable<String>('unit'),
          quantityNote: row.readNullable<String>('quantity_note'),
          sectionName: row.readNullable<String>('section_name'),
          sortOrder: row.read<int>('sort_order'),
        ));
  }

  Selectable<IngredientsOfRecipeStepResult> ingredientsOfRecipeStep(
      int recipeStepId) {
    return customSelect(
        'SELECT ingredients.*, recipe_ingredients.amount, recipe_ingredients.unit, recipe_ingredients.quantity_note, recipe_ingredients.section_name, recipe_ingredients.sort_order FROM recipe_step_ingredients INNER JOIN ingredients ON ingredients.id = recipe_step_ingredients.ingredient_id INNER JOIN recipe_steps ON recipe_steps.id = recipe_step_ingredients.recipe_step_id INNER JOIN recipe_ingredients ON recipe_ingredients.recipe_id = recipe_steps.recipe_id AND recipe_ingredients.ingredient_id = ingredients.id WHERE recipe_step_ingredients.recipe_step_id = ?1 AND recipe_step_ingredients.deleted_at IS NULL AND ingredients.deleted_at IS NULL AND recipe_ingredients.deleted_at IS NULL ORDER BY recipe_ingredients.sort_order, recipe_ingredients.created_at, recipe_ingredients.ingredient_id',
        variables: [
          Variable<int>(recipeStepId)
        ],
        readsFrom: {
          recipeIngredients,
          recipeStepIngredients,
          ingredients,
          recipeSteps,
        }).map((QueryRow row) => IngredientsOfRecipeStepResult(
          id: row.read<int>('id'),
          name: row.read<String>('name'),
          shoppingCategoryCode:
              row.readNullable<String>('shopping_category_code'),
          createdAt: row.read<DateTime>('created_at'),
          createdBy: row.read<int>('created_by'),
          updatedAt: row.read<DateTime>('updated_at'),
          updatedBy: row.read<int>('updated_by'),
          deletedAt: row.readNullable<DateTime>('deleted_at'),
          deletedBy: row.readNullable<int>('deleted_by'),
          amount: row.readNullable<double>('amount'),
          unit: row.readNullable<String>('unit'),
          quantityNote: row.readNullable<String>('quantity_note'),
          sectionName: row.readNullable<String>('section_name'),
          sortOrder: row.read<int>('sort_order'),
        ));
  }

  Selectable<HistoryEntriesOfAccountAsRecipesResult>
      historyEntriesOfAccountAsRecipes(int accountId) {
    return customSelect(
        'SELECT recipes.*, coalesce(q.number_of_steps, 0) AS number_of_steps FROM recipes LEFT JOIN (SELECT recipe_id, COUNT(*) AS number_of_steps FROM recipe_steps WHERE deleted_at IS NULL GROUP BY recipe_id) AS q ON q.recipe_id = recipes.id INNER JOIN (SELECT * FROM histories WHERE account_id = ?1 AND deleted_at IS NULL) AS r ON r.recipe_id = recipes.id WHERE recipes.deleted_at IS NULL ORDER BY r.updated_at DESC',
        variables: [
          Variable<int>(accountId)
        ],
        readsFrom: {
          recipes,
          recipeSteps,
          histories,
        }).map((QueryRow row) => HistoryEntriesOfAccountAsRecipesResult(
          id: row.read<int>('id'),
          title: row.read<String>('title'),
          image: row.readNullable<String>('image'),
          description: row.readNullable<String>('description'),
          notes: row.readNullable<String>('notes'),
          totalTimeMinutes: row.readNullable<int>('total_time_minutes'),
          servings: row.readNullable<int>('servings'),
          revision: row.read<int>('revision'),
          createdAt: row.read<DateTime>('created_at'),
          createdBy: row.read<int>('created_by'),
          updatedAt: row.read<DateTime>('updated_at'),
          updatedBy: row.read<int>('updated_by'),
          deletedAt: row.readNullable<DateTime>('deleted_at'),
          deletedBy: row.readNullable<int>('deleted_by'),
          numberOfSteps: row.read<int>('number_of_steps'),
        ));
  }

  Selectable<AllRecipesResult> allRecipes() {
    return customSelect(
        'SELECT recipes.*, coalesce(q.number_of_steps, 0) AS number_of_steps FROM recipes LEFT JOIN (SELECT recipe_id, COUNT(*) AS number_of_steps FROM recipe_steps WHERE deleted_at IS NULL GROUP BY recipe_id) AS q ON q.recipe_id = recipes.id WHERE recipes.deleted_at IS NULL ORDER BY id',
        variables: [],
        readsFrom: {
          recipes,
          recipeSteps,
        }).map((QueryRow row) => AllRecipesResult(
          id: row.read<int>('id'),
          title: row.read<String>('title'),
          image: row.readNullable<String>('image'),
          description: row.readNullable<String>('description'),
          notes: row.readNullable<String>('notes'),
          totalTimeMinutes: row.readNullable<int>('total_time_minutes'),
          servings: row.readNullable<int>('servings'),
          revision: row.read<int>('revision'),
          createdAt: row.read<DateTime>('created_at'),
          createdBy: row.read<int>('created_by'),
          updatedAt: row.read<DateTime>('updated_at'),
          updatedBy: row.read<int>('updated_by'),
          deletedAt: row.readNullable<DateTime>('deleted_at'),
          deletedBy: row.readNullable<int>('deleted_by'),
          numberOfSteps: row.read<int>('number_of_steps'),
        ));
  }

  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        categories,
        recipes,
        shoppingCategories,
        ingredients,
        measurementUnits,
        recipeIngredients,
        roles,
        accounts,
        comments,
        histories,
        profiles,
        accountFollows,
        accountFriends,
        chatConversations,
        chatMessages,
        chatMessageReactions,
        recipeLikes,
        shoppingLists,
        shoppingListSections,
        shoppingListItems,
        shoppingListMembers,
        mealPlans,
        mealPlanMembers,
        mealPlanEntries,
        mealPlanTemplates,
        mealPlanTemplateEntries,
        pendingMutations,
        recipeSteps,
        recipeStepIngredients,
        recipesCategories,
        settings
      ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('shopping_categories',
                limitUpdateKind: UpdateKind.update),
            result: [
              TableUpdate('ingredients', kind: UpdateKind.update),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('recipes',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('recipe_ingredients', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('ingredients',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('recipe_ingredients', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('roles',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('accounts', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('recipes',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('comments', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('recipes',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('histories', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('accounts',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('histories', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('accounts',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('profiles', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('accounts',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('account_follows', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('accounts',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('account_follows', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('accounts',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('account_friends', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('accounts',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('account_friends', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('accounts',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('chat_conversations', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('accounts',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('chat_conversations', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('chat_conversations',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('chat_messages', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('accounts',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('chat_messages', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('chat_messages',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('chat_message_reactions', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('accounts',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('chat_message_reactions', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('accounts',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('recipe_likes', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('recipes',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('recipe_likes', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('accounts',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('shopping_lists', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('shopping_lists',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('shopping_list_sections', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('shopping_lists',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('shopping_list_items', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('ingredients',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('shopping_list_items', kind: UpdateKind.update),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('shopping_categories',
                limitUpdateKind: UpdateKind.update),
            result: [
              TableUpdate('shopping_list_items', kind: UpdateKind.update),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('shopping_lists',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('shopping_list_members', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('accounts',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('shopping_list_members', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('accounts',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('meal_plans', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('meal_plans',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('meal_plan_members', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('accounts',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('meal_plan_members', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('meal_plans',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('meal_plan_entries', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('recipes',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('meal_plan_entries', kind: UpdateKind.update),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('accounts',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('meal_plan_templates', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('meal_plan_templates',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('meal_plan_template_entries',
                  kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('recipes',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('meal_plan_template_entries',
                  kind: UpdateKind.update),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('recipes',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('recipe_steps', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('recipe_steps',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('recipe_step_ingredients', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('ingredients',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('recipe_step_ingredients', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('categories',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('RecipesCategories', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('recipes',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('RecipesCategories', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('accounts',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('settings', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}

typedef $CategoriesCreateCompanionBuilder = CategoriesCompanion Function({
  Value<int> id,
  required String name,
  required DateTime createdAt,
  required int createdBy,
  required DateTime updatedAt,
  required int updatedBy,
  Value<DateTime?> deletedAt,
  Value<int?> deletedBy,
});
typedef $CategoriesUpdateCompanionBuilder = CategoriesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<DateTime> createdAt,
  Value<int> createdBy,
  Value<DateTime> updatedAt,
  Value<int> updatedBy,
  Value<DateTime?> deletedAt,
  Value<int?> deletedBy,
});

class $CategoriesFilterComposer extends Composer<_$AppDatabase, Categories> {
  $CategoriesFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get deletedBy => $composableBuilder(
      column: $table.deletedBy, builder: (column) => ColumnFilters(column));
}

class $CategoriesOrderingComposer extends Composer<_$AppDatabase, Categories> {
  $CategoriesOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get deletedBy => $composableBuilder(
      column: $table.deletedBy, builder: (column) => ColumnOrderings(column));
}

class $CategoriesAnnotationComposer
    extends Composer<_$AppDatabase, Categories> {
  $CategoriesAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedBy =>
      $composableBuilder(column: $table.deletedBy, builder: (column) => column);
}

class $CategoriesTableManager extends RootTableManager<
    _$AppDatabase,
    Categories,
    Category,
    $CategoriesFilterComposer,
    $CategoriesOrderingComposer,
    $CategoriesAnnotationComposer,
    $CategoriesCreateCompanionBuilder,
    $CategoriesUpdateCompanionBuilder,
    (Category, BaseReferences<_$AppDatabase, Categories, Category>),
    Category,
    PrefetchHooks Function()> {
  $CategoriesTableManager(_$AppDatabase db, Categories table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $CategoriesFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $CategoriesOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $CategoriesAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> createdBy = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> updatedBy = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int?> deletedBy = const Value.absent(),
          }) =>
              CategoriesCompanion(
            id: id,
            name: name,
            createdAt: createdAt,
            createdBy: createdBy,
            updatedAt: updatedAt,
            updatedBy: updatedBy,
            deletedAt: deletedAt,
            deletedBy: deletedBy,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required DateTime createdAt,
            required int createdBy,
            required DateTime updatedAt,
            required int updatedBy,
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int?> deletedBy = const Value.absent(),
          }) =>
              CategoriesCompanion.insert(
            id: id,
            name: name,
            createdAt: createdAt,
            createdBy: createdBy,
            updatedAt: updatedAt,
            updatedBy: updatedBy,
            deletedAt: deletedAt,
            deletedBy: deletedBy,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $CategoriesProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    Categories,
    Category,
    $CategoriesFilterComposer,
    $CategoriesOrderingComposer,
    $CategoriesAnnotationComposer,
    $CategoriesCreateCompanionBuilder,
    $CategoriesUpdateCompanionBuilder,
    (Category, BaseReferences<_$AppDatabase, Categories, Category>),
    Category,
    PrefetchHooks Function()>;
typedef $RecipesCreateCompanionBuilder = RecipesCompanion Function({
  Value<int> id,
  required String title,
  Value<String?> image,
  Value<String?> description,
  Value<String?> notes,
  Value<int?> totalTimeMinutes,
  Value<int?> servings,
  Value<int> revision,
  required DateTime createdAt,
  required int createdBy,
  required DateTime updatedAt,
  required int updatedBy,
  Value<DateTime?> deletedAt,
  Value<int?> deletedBy,
});
typedef $RecipesUpdateCompanionBuilder = RecipesCompanion Function({
  Value<int> id,
  Value<String> title,
  Value<String?> image,
  Value<String?> description,
  Value<String?> notes,
  Value<int?> totalTimeMinutes,
  Value<int?> servings,
  Value<int> revision,
  Value<DateTime> createdAt,
  Value<int> createdBy,
  Value<DateTime> updatedAt,
  Value<int> updatedBy,
  Value<DateTime?> deletedAt,
  Value<int?> deletedBy,
});

class $RecipesFilterComposer extends Composer<_$AppDatabase, Recipes> {
  $RecipesFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get image => $composableBuilder(
      column: $table.image, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalTimeMinutes => $composableBuilder(
      column: $table.totalTimeMinutes,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get servings => $composableBuilder(
      column: $table.servings, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get revision => $composableBuilder(
      column: $table.revision, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get deletedBy => $composableBuilder(
      column: $table.deletedBy, builder: (column) => ColumnFilters(column));
}

class $RecipesOrderingComposer extends Composer<_$AppDatabase, Recipes> {
  $RecipesOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get image => $composableBuilder(
      column: $table.image, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalTimeMinutes => $composableBuilder(
      column: $table.totalTimeMinutes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get servings => $composableBuilder(
      column: $table.servings, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get revision => $composableBuilder(
      column: $table.revision, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get deletedBy => $composableBuilder(
      column: $table.deletedBy, builder: (column) => ColumnOrderings(column));
}

class $RecipesAnnotationComposer extends Composer<_$AppDatabase, Recipes> {
  $RecipesAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get image =>
      $composableBuilder(column: $table.image, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get totalTimeMinutes => $composableBuilder(
      column: $table.totalTimeMinutes, builder: (column) => column);

  GeneratedColumn<int> get servings =>
      $composableBuilder(column: $table.servings, builder: (column) => column);

  GeneratedColumn<int> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedBy =>
      $composableBuilder(column: $table.deletedBy, builder: (column) => column);
}

class $RecipesTableManager extends RootTableManager<
    _$AppDatabase,
    Recipes,
    Recipe,
    $RecipesFilterComposer,
    $RecipesOrderingComposer,
    $RecipesAnnotationComposer,
    $RecipesCreateCompanionBuilder,
    $RecipesUpdateCompanionBuilder,
    (Recipe, BaseReferences<_$AppDatabase, Recipes, Recipe>),
    Recipe,
    PrefetchHooks Function()> {
  $RecipesTableManager(_$AppDatabase db, Recipes table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $RecipesFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $RecipesOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $RecipesAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> image = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<int?> totalTimeMinutes = const Value.absent(),
            Value<int?> servings = const Value.absent(),
            Value<int> revision = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> createdBy = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> updatedBy = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int?> deletedBy = const Value.absent(),
          }) =>
              RecipesCompanion(
            id: id,
            title: title,
            image: image,
            description: description,
            notes: notes,
            totalTimeMinutes: totalTimeMinutes,
            servings: servings,
            revision: revision,
            createdAt: createdAt,
            createdBy: createdBy,
            updatedAt: updatedAt,
            updatedBy: updatedBy,
            deletedAt: deletedAt,
            deletedBy: deletedBy,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String title,
            Value<String?> image = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<int?> totalTimeMinutes = const Value.absent(),
            Value<int?> servings = const Value.absent(),
            Value<int> revision = const Value.absent(),
            required DateTime createdAt,
            required int createdBy,
            required DateTime updatedAt,
            required int updatedBy,
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int?> deletedBy = const Value.absent(),
          }) =>
              RecipesCompanion.insert(
            id: id,
            title: title,
            image: image,
            description: description,
            notes: notes,
            totalTimeMinutes: totalTimeMinutes,
            servings: servings,
            revision: revision,
            createdAt: createdAt,
            createdBy: createdBy,
            updatedAt: updatedAt,
            updatedBy: updatedBy,
            deletedAt: deletedAt,
            deletedBy: deletedBy,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $RecipesProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    Recipes,
    Recipe,
    $RecipesFilterComposer,
    $RecipesOrderingComposer,
    $RecipesAnnotationComposer,
    $RecipesCreateCompanionBuilder,
    $RecipesUpdateCompanionBuilder,
    (Recipe, BaseReferences<_$AppDatabase, Recipes, Recipe>),
    Recipe,
    PrefetchHooks Function()>;
typedef $ShoppingCategoriesCreateCompanionBuilder = ShoppingCategoriesCompanion
    Function({
  required String code,
  required String nameEn,
  required String nameDe,
  required int sortOrder,
  required DateTime createdAt,
  required int createdBy,
  required DateTime updatedAt,
  required int updatedBy,
  Value<DateTime?> deletedAt,
  Value<int?> deletedBy,
  Value<int> rowid,
});
typedef $ShoppingCategoriesUpdateCompanionBuilder = ShoppingCategoriesCompanion
    Function({
  Value<String> code,
  Value<String> nameEn,
  Value<String> nameDe,
  Value<int> sortOrder,
  Value<DateTime> createdAt,
  Value<int> createdBy,
  Value<DateTime> updatedAt,
  Value<int> updatedBy,
  Value<DateTime?> deletedAt,
  Value<int?> deletedBy,
  Value<int> rowid,
});

class $ShoppingCategoriesFilterComposer
    extends Composer<_$AppDatabase, ShoppingCategories> {
  $ShoppingCategoriesFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameEn => $composableBuilder(
      column: $table.nameEn, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameDe => $composableBuilder(
      column: $table.nameDe, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get deletedBy => $composableBuilder(
      column: $table.deletedBy, builder: (column) => ColumnFilters(column));
}

class $ShoppingCategoriesOrderingComposer
    extends Composer<_$AppDatabase, ShoppingCategories> {
  $ShoppingCategoriesOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameEn => $composableBuilder(
      column: $table.nameEn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameDe => $composableBuilder(
      column: $table.nameDe, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get deletedBy => $composableBuilder(
      column: $table.deletedBy, builder: (column) => ColumnOrderings(column));
}

class $ShoppingCategoriesAnnotationComposer
    extends Composer<_$AppDatabase, ShoppingCategories> {
  $ShoppingCategoriesAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);

  GeneratedColumn<String> get nameDe =>
      $composableBuilder(column: $table.nameDe, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedBy =>
      $composableBuilder(column: $table.deletedBy, builder: (column) => column);
}

class $ShoppingCategoriesTableManager extends RootTableManager<
    _$AppDatabase,
    ShoppingCategories,
    ShoppingCategory,
    $ShoppingCategoriesFilterComposer,
    $ShoppingCategoriesOrderingComposer,
    $ShoppingCategoriesAnnotationComposer,
    $ShoppingCategoriesCreateCompanionBuilder,
    $ShoppingCategoriesUpdateCompanionBuilder,
    (
      ShoppingCategory,
      BaseReferences<_$AppDatabase, ShoppingCategories, ShoppingCategory>
    ),
    ShoppingCategory,
    PrefetchHooks Function()> {
  $ShoppingCategoriesTableManager(_$AppDatabase db, ShoppingCategories table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $ShoppingCategoriesFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $ShoppingCategoriesOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $ShoppingCategoriesAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> code = const Value.absent(),
            Value<String> nameEn = const Value.absent(),
            Value<String> nameDe = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> createdBy = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> updatedBy = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int?> deletedBy = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ShoppingCategoriesCompanion(
            code: code,
            nameEn: nameEn,
            nameDe: nameDe,
            sortOrder: sortOrder,
            createdAt: createdAt,
            createdBy: createdBy,
            updatedAt: updatedAt,
            updatedBy: updatedBy,
            deletedAt: deletedAt,
            deletedBy: deletedBy,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String code,
            required String nameEn,
            required String nameDe,
            required int sortOrder,
            required DateTime createdAt,
            required int createdBy,
            required DateTime updatedAt,
            required int updatedBy,
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int?> deletedBy = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ShoppingCategoriesCompanion.insert(
            code: code,
            nameEn: nameEn,
            nameDe: nameDe,
            sortOrder: sortOrder,
            createdAt: createdAt,
            createdBy: createdBy,
            updatedAt: updatedAt,
            updatedBy: updatedBy,
            deletedAt: deletedAt,
            deletedBy: deletedBy,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $ShoppingCategoriesProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    ShoppingCategories,
    ShoppingCategory,
    $ShoppingCategoriesFilterComposer,
    $ShoppingCategoriesOrderingComposer,
    $ShoppingCategoriesAnnotationComposer,
    $ShoppingCategoriesCreateCompanionBuilder,
    $ShoppingCategoriesUpdateCompanionBuilder,
    (
      ShoppingCategory,
      BaseReferences<_$AppDatabase, ShoppingCategories, ShoppingCategory>
    ),
    ShoppingCategory,
    PrefetchHooks Function()>;
typedef $IngredientsCreateCompanionBuilder = IngredientsCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> shoppingCategoryCode,
  required DateTime createdAt,
  required int createdBy,
  required DateTime updatedAt,
  required int updatedBy,
  Value<DateTime?> deletedAt,
  Value<int?> deletedBy,
});
typedef $IngredientsUpdateCompanionBuilder = IngredientsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> shoppingCategoryCode,
  Value<DateTime> createdAt,
  Value<int> createdBy,
  Value<DateTime> updatedAt,
  Value<int> updatedBy,
  Value<DateTime?> deletedAt,
  Value<int?> deletedBy,
});

class $IngredientsFilterComposer extends Composer<_$AppDatabase, Ingredients> {
  $IngredientsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get shoppingCategoryCode => $composableBuilder(
      column: $table.shoppingCategoryCode,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get deletedBy => $composableBuilder(
      column: $table.deletedBy, builder: (column) => ColumnFilters(column));
}

class $IngredientsOrderingComposer
    extends Composer<_$AppDatabase, Ingredients> {
  $IngredientsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get shoppingCategoryCode => $composableBuilder(
      column: $table.shoppingCategoryCode,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get deletedBy => $composableBuilder(
      column: $table.deletedBy, builder: (column) => ColumnOrderings(column));
}

class $IngredientsAnnotationComposer
    extends Composer<_$AppDatabase, Ingredients> {
  $IngredientsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get shoppingCategoryCode => $composableBuilder(
      column: $table.shoppingCategoryCode, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedBy =>
      $composableBuilder(column: $table.deletedBy, builder: (column) => column);
}

class $IngredientsTableManager extends RootTableManager<
    _$AppDatabase,
    Ingredients,
    Ingredient,
    $IngredientsFilterComposer,
    $IngredientsOrderingComposer,
    $IngredientsAnnotationComposer,
    $IngredientsCreateCompanionBuilder,
    $IngredientsUpdateCompanionBuilder,
    (Ingredient, BaseReferences<_$AppDatabase, Ingredients, Ingredient>),
    Ingredient,
    PrefetchHooks Function()> {
  $IngredientsTableManager(_$AppDatabase db, Ingredients table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $IngredientsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $IngredientsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $IngredientsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> shoppingCategoryCode = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> createdBy = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> updatedBy = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int?> deletedBy = const Value.absent(),
          }) =>
              IngredientsCompanion(
            id: id,
            name: name,
            shoppingCategoryCode: shoppingCategoryCode,
            createdAt: createdAt,
            createdBy: createdBy,
            updatedAt: updatedAt,
            updatedBy: updatedBy,
            deletedAt: deletedAt,
            deletedBy: deletedBy,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String?> shoppingCategoryCode = const Value.absent(),
            required DateTime createdAt,
            required int createdBy,
            required DateTime updatedAt,
            required int updatedBy,
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int?> deletedBy = const Value.absent(),
          }) =>
              IngredientsCompanion.insert(
            id: id,
            name: name,
            shoppingCategoryCode: shoppingCategoryCode,
            createdAt: createdAt,
            createdBy: createdBy,
            updatedAt: updatedAt,
            updatedBy: updatedBy,
            deletedAt: deletedAt,
            deletedBy: deletedBy,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $IngredientsProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    Ingredients,
    Ingredient,
    $IngredientsFilterComposer,
    $IngredientsOrderingComposer,
    $IngredientsAnnotationComposer,
    $IngredientsCreateCompanionBuilder,
    $IngredientsUpdateCompanionBuilder,
    (Ingredient, BaseReferences<_$AppDatabase, Ingredients, Ingredient>),
    Ingredient,
    PrefetchHooks Function()>;
typedef $MeasurementUnitsCreateCompanionBuilder = MeasurementUnitsCompanion
    Function({
  required String code,
  required String nameEn,
  required String nameDe,
  required int sortOrder,
  required bool selectable,
  required DateTime createdAt,
  required int createdBy,
  required DateTime updatedAt,
  required int updatedBy,
  Value<DateTime?> deletedAt,
  Value<int?> deletedBy,
  Value<int> rowid,
});
typedef $MeasurementUnitsUpdateCompanionBuilder = MeasurementUnitsCompanion
    Function({
  Value<String> code,
  Value<String> nameEn,
  Value<String> nameDe,
  Value<int> sortOrder,
  Value<bool> selectable,
  Value<DateTime> createdAt,
  Value<int> createdBy,
  Value<DateTime> updatedAt,
  Value<int> updatedBy,
  Value<DateTime?> deletedAt,
  Value<int?> deletedBy,
  Value<int> rowid,
});

class $MeasurementUnitsFilterComposer
    extends Composer<_$AppDatabase, MeasurementUnits> {
  $MeasurementUnitsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameEn => $composableBuilder(
      column: $table.nameEn, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameDe => $composableBuilder(
      column: $table.nameDe, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get selectable => $composableBuilder(
      column: $table.selectable, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get deletedBy => $composableBuilder(
      column: $table.deletedBy, builder: (column) => ColumnFilters(column));
}

class $MeasurementUnitsOrderingComposer
    extends Composer<_$AppDatabase, MeasurementUnits> {
  $MeasurementUnitsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameEn => $composableBuilder(
      column: $table.nameEn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameDe => $composableBuilder(
      column: $table.nameDe, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get selectable => $composableBuilder(
      column: $table.selectable, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get deletedBy => $composableBuilder(
      column: $table.deletedBy, builder: (column) => ColumnOrderings(column));
}

class $MeasurementUnitsAnnotationComposer
    extends Composer<_$AppDatabase, MeasurementUnits> {
  $MeasurementUnitsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);

  GeneratedColumn<String> get nameDe =>
      $composableBuilder(column: $table.nameDe, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get selectable => $composableBuilder(
      column: $table.selectable, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedBy =>
      $composableBuilder(column: $table.deletedBy, builder: (column) => column);
}

class $MeasurementUnitsTableManager extends RootTableManager<
    _$AppDatabase,
    MeasurementUnits,
    MeasurementUnit,
    $MeasurementUnitsFilterComposer,
    $MeasurementUnitsOrderingComposer,
    $MeasurementUnitsAnnotationComposer,
    $MeasurementUnitsCreateCompanionBuilder,
    $MeasurementUnitsUpdateCompanionBuilder,
    (
      MeasurementUnit,
      BaseReferences<_$AppDatabase, MeasurementUnits, MeasurementUnit>
    ),
    MeasurementUnit,
    PrefetchHooks Function()> {
  $MeasurementUnitsTableManager(_$AppDatabase db, MeasurementUnits table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $MeasurementUnitsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $MeasurementUnitsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $MeasurementUnitsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> code = const Value.absent(),
            Value<String> nameEn = const Value.absent(),
            Value<String> nameDe = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<bool> selectable = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> createdBy = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> updatedBy = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int?> deletedBy = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MeasurementUnitsCompanion(
            code: code,
            nameEn: nameEn,
            nameDe: nameDe,
            sortOrder: sortOrder,
            selectable: selectable,
            createdAt: createdAt,
            createdBy: createdBy,
            updatedAt: updatedAt,
            updatedBy: updatedBy,
            deletedAt: deletedAt,
            deletedBy: deletedBy,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String code,
            required String nameEn,
            required String nameDe,
            required int sortOrder,
            required bool selectable,
            required DateTime createdAt,
            required int createdBy,
            required DateTime updatedAt,
            required int updatedBy,
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int?> deletedBy = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MeasurementUnitsCompanion.insert(
            code: code,
            nameEn: nameEn,
            nameDe: nameDe,
            sortOrder: sortOrder,
            selectable: selectable,
            createdAt: createdAt,
            createdBy: createdBy,
            updatedAt: updatedAt,
            updatedBy: updatedBy,
            deletedAt: deletedAt,
            deletedBy: deletedBy,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $MeasurementUnitsProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    MeasurementUnits,
    MeasurementUnit,
    $MeasurementUnitsFilterComposer,
    $MeasurementUnitsOrderingComposer,
    $MeasurementUnitsAnnotationComposer,
    $MeasurementUnitsCreateCompanionBuilder,
    $MeasurementUnitsUpdateCompanionBuilder,
    (
      MeasurementUnit,
      BaseReferences<_$AppDatabase, MeasurementUnits, MeasurementUnit>
    ),
    MeasurementUnit,
    PrefetchHooks Function()>;
typedef $RecipeIngredientsCreateCompanionBuilder = RecipeIngredientsCompanion
    Function({
  required int recipeId,
  required int ingredientId,
  Value<double?> amount,
  Value<String?> unit,
  Value<String?> quantityNote,
  Value<String?> sectionName,
  Value<int> sortOrder,
  required DateTime createdAt,
  required int createdBy,
  required DateTime updatedAt,
  required int updatedBy,
  Value<DateTime?> deletedAt,
  Value<int?> deletedBy,
  Value<int> rowid,
});
typedef $RecipeIngredientsUpdateCompanionBuilder = RecipeIngredientsCompanion
    Function({
  Value<int> recipeId,
  Value<int> ingredientId,
  Value<double?> amount,
  Value<String?> unit,
  Value<String?> quantityNote,
  Value<String?> sectionName,
  Value<int> sortOrder,
  Value<DateTime> createdAt,
  Value<int> createdBy,
  Value<DateTime> updatedAt,
  Value<int> updatedBy,
  Value<DateTime?> deletedAt,
  Value<int?> deletedBy,
  Value<int> rowid,
});

class $RecipeIngredientsFilterComposer
    extends Composer<_$AppDatabase, RecipeIngredients> {
  $RecipeIngredientsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get recipeId => $composableBuilder(
      column: $table.recipeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get ingredientId => $composableBuilder(
      column: $table.ingredientId, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get quantityNote => $composableBuilder(
      column: $table.quantityNote, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sectionName => $composableBuilder(
      column: $table.sectionName, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get deletedBy => $composableBuilder(
      column: $table.deletedBy, builder: (column) => ColumnFilters(column));
}

class $RecipeIngredientsOrderingComposer
    extends Composer<_$AppDatabase, RecipeIngredients> {
  $RecipeIngredientsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get recipeId => $composableBuilder(
      column: $table.recipeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get ingredientId => $composableBuilder(
      column: $table.ingredientId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get quantityNote => $composableBuilder(
      column: $table.quantityNote,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sectionName => $composableBuilder(
      column: $table.sectionName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get deletedBy => $composableBuilder(
      column: $table.deletedBy, builder: (column) => ColumnOrderings(column));
}

class $RecipeIngredientsAnnotationComposer
    extends Composer<_$AppDatabase, RecipeIngredients> {
  $RecipeIngredientsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get recipeId =>
      $composableBuilder(column: $table.recipeId, builder: (column) => column);

  GeneratedColumn<int> get ingredientId => $composableBuilder(
      column: $table.ingredientId, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get quantityNote => $composableBuilder(
      column: $table.quantityNote, builder: (column) => column);

  GeneratedColumn<String> get sectionName => $composableBuilder(
      column: $table.sectionName, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedBy =>
      $composableBuilder(column: $table.deletedBy, builder: (column) => column);
}

class $RecipeIngredientsTableManager extends RootTableManager<
    _$AppDatabase,
    RecipeIngredients,
    RecipeIngredient,
    $RecipeIngredientsFilterComposer,
    $RecipeIngredientsOrderingComposer,
    $RecipeIngredientsAnnotationComposer,
    $RecipeIngredientsCreateCompanionBuilder,
    $RecipeIngredientsUpdateCompanionBuilder,
    (
      RecipeIngredient,
      BaseReferences<_$AppDatabase, RecipeIngredients, RecipeIngredient>
    ),
    RecipeIngredient,
    PrefetchHooks Function()> {
  $RecipeIngredientsTableManager(_$AppDatabase db, RecipeIngredients table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $RecipeIngredientsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $RecipeIngredientsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $RecipeIngredientsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> recipeId = const Value.absent(),
            Value<int> ingredientId = const Value.absent(),
            Value<double?> amount = const Value.absent(),
            Value<String?> unit = const Value.absent(),
            Value<String?> quantityNote = const Value.absent(),
            Value<String?> sectionName = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> createdBy = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> updatedBy = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int?> deletedBy = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RecipeIngredientsCompanion(
            recipeId: recipeId,
            ingredientId: ingredientId,
            amount: amount,
            unit: unit,
            quantityNote: quantityNote,
            sectionName: sectionName,
            sortOrder: sortOrder,
            createdAt: createdAt,
            createdBy: createdBy,
            updatedAt: updatedAt,
            updatedBy: updatedBy,
            deletedAt: deletedAt,
            deletedBy: deletedBy,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int recipeId,
            required int ingredientId,
            Value<double?> amount = const Value.absent(),
            Value<String?> unit = const Value.absent(),
            Value<String?> quantityNote = const Value.absent(),
            Value<String?> sectionName = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            required DateTime createdAt,
            required int createdBy,
            required DateTime updatedAt,
            required int updatedBy,
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int?> deletedBy = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RecipeIngredientsCompanion.insert(
            recipeId: recipeId,
            ingredientId: ingredientId,
            amount: amount,
            unit: unit,
            quantityNote: quantityNote,
            sectionName: sectionName,
            sortOrder: sortOrder,
            createdAt: createdAt,
            createdBy: createdBy,
            updatedAt: updatedAt,
            updatedBy: updatedBy,
            deletedAt: deletedAt,
            deletedBy: deletedBy,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $RecipeIngredientsProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    RecipeIngredients,
    RecipeIngredient,
    $RecipeIngredientsFilterComposer,
    $RecipeIngredientsOrderingComposer,
    $RecipeIngredientsAnnotationComposer,
    $RecipeIngredientsCreateCompanionBuilder,
    $RecipeIngredientsUpdateCompanionBuilder,
    (
      RecipeIngredient,
      BaseReferences<_$AppDatabase, RecipeIngredients, RecipeIngredient>
    ),
    RecipeIngredient,
    PrefetchHooks Function()>;
typedef $RolesCreateCompanionBuilder = RolesCompanion Function({
  Value<int> id,
  required String name,
  required DateTime createdAt,
  required int createdBy,
  required DateTime updatedAt,
  required int updatedBy,
  Value<DateTime?> deletedAt,
  Value<int?> deletedBy,
});
typedef $RolesUpdateCompanionBuilder = RolesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<DateTime> createdAt,
  Value<int> createdBy,
  Value<DateTime> updatedAt,
  Value<int> updatedBy,
  Value<DateTime?> deletedAt,
  Value<int?> deletedBy,
});

class $RolesFilterComposer extends Composer<_$AppDatabase, Roles> {
  $RolesFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get deletedBy => $composableBuilder(
      column: $table.deletedBy, builder: (column) => ColumnFilters(column));
}

class $RolesOrderingComposer extends Composer<_$AppDatabase, Roles> {
  $RolesOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get deletedBy => $composableBuilder(
      column: $table.deletedBy, builder: (column) => ColumnOrderings(column));
}

class $RolesAnnotationComposer extends Composer<_$AppDatabase, Roles> {
  $RolesAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedBy =>
      $composableBuilder(column: $table.deletedBy, builder: (column) => column);
}

class $RolesTableManager extends RootTableManager<
    _$AppDatabase,
    Roles,
    Role,
    $RolesFilterComposer,
    $RolesOrderingComposer,
    $RolesAnnotationComposer,
    $RolesCreateCompanionBuilder,
    $RolesUpdateCompanionBuilder,
    (Role, BaseReferences<_$AppDatabase, Roles, Role>),
    Role,
    PrefetchHooks Function()> {
  $RolesTableManager(_$AppDatabase db, Roles table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $RolesFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $RolesOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $RolesAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> createdBy = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> updatedBy = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int?> deletedBy = const Value.absent(),
          }) =>
              RolesCompanion(
            id: id,
            name: name,
            createdAt: createdAt,
            createdBy: createdBy,
            updatedAt: updatedAt,
            updatedBy: updatedBy,
            deletedAt: deletedAt,
            deletedBy: deletedBy,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required DateTime createdAt,
            required int createdBy,
            required DateTime updatedAt,
            required int updatedBy,
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int?> deletedBy = const Value.absent(),
          }) =>
              RolesCompanion.insert(
            id: id,
            name: name,
            createdAt: createdAt,
            createdBy: createdBy,
            updatedAt: updatedAt,
            updatedBy: updatedBy,
            deletedAt: deletedAt,
            deletedBy: deletedBy,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $RolesProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    Roles,
    Role,
    $RolesFilterComposer,
    $RolesOrderingComposer,
    $RolesAnnotationComposer,
    $RolesCreateCompanionBuilder,
    $RolesUpdateCompanionBuilder,
    (Role, BaseReferences<_$AppDatabase, Roles, Role>),
    Role,
    PrefetchHooks Function()>;
typedef $AccountsCreateCompanionBuilder = AccountsCompanion Function({
  Value<int> id,
  required String accountName,
  Value<String?> profileImage,
  Value<String?> bio,
  required int roleId,
  required String hostCode,
  required DateTime createdAt,
  required int createdBy,
  required DateTime updatedAt,
  required int updatedBy,
  Value<DateTime?> deletedAt,
  Value<int?> deletedBy,
});
typedef $AccountsUpdateCompanionBuilder = AccountsCompanion Function({
  Value<int> id,
  Value<String> accountName,
  Value<String?> profileImage,
  Value<String?> bio,
  Value<int> roleId,
  Value<String> hostCode,
  Value<DateTime> createdAt,
  Value<int> createdBy,
  Value<DateTime> updatedAt,
  Value<int> updatedBy,
  Value<DateTime?> deletedAt,
  Value<int?> deletedBy,
});

class $AccountsFilterComposer extends Composer<_$AppDatabase, Accounts> {
  $AccountsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get accountName => $composableBuilder(
      column: $table.accountName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get profileImage => $composableBuilder(
      column: $table.profileImage, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bio => $composableBuilder(
      column: $table.bio, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get roleId => $composableBuilder(
      column: $table.roleId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get hostCode => $composableBuilder(
      column: $table.hostCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get deletedBy => $composableBuilder(
      column: $table.deletedBy, builder: (column) => ColumnFilters(column));
}

class $AccountsOrderingComposer extends Composer<_$AppDatabase, Accounts> {
  $AccountsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get accountName => $composableBuilder(
      column: $table.accountName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get profileImage => $composableBuilder(
      column: $table.profileImage,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bio => $composableBuilder(
      column: $table.bio, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get roleId => $composableBuilder(
      column: $table.roleId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get hostCode => $composableBuilder(
      column: $table.hostCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get deletedBy => $composableBuilder(
      column: $table.deletedBy, builder: (column) => ColumnOrderings(column));
}

class $AccountsAnnotationComposer extends Composer<_$AppDatabase, Accounts> {
  $AccountsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get accountName => $composableBuilder(
      column: $table.accountName, builder: (column) => column);

  GeneratedColumn<String> get profileImage => $composableBuilder(
      column: $table.profileImage, builder: (column) => column);

  GeneratedColumn<String> get bio =>
      $composableBuilder(column: $table.bio, builder: (column) => column);

  GeneratedColumn<int> get roleId =>
      $composableBuilder(column: $table.roleId, builder: (column) => column);

  GeneratedColumn<String> get hostCode =>
      $composableBuilder(column: $table.hostCode, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedBy =>
      $composableBuilder(column: $table.deletedBy, builder: (column) => column);
}

class $AccountsTableManager extends RootTableManager<
    _$AppDatabase,
    Accounts,
    Account,
    $AccountsFilterComposer,
    $AccountsOrderingComposer,
    $AccountsAnnotationComposer,
    $AccountsCreateCompanionBuilder,
    $AccountsUpdateCompanionBuilder,
    (Account, BaseReferences<_$AppDatabase, Accounts, Account>),
    Account,
    PrefetchHooks Function()> {
  $AccountsTableManager(_$AppDatabase db, Accounts table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $AccountsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $AccountsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $AccountsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> accountName = const Value.absent(),
            Value<String?> profileImage = const Value.absent(),
            Value<String?> bio = const Value.absent(),
            Value<int> roleId = const Value.absent(),
            Value<String> hostCode = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> createdBy = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> updatedBy = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int?> deletedBy = const Value.absent(),
          }) =>
              AccountsCompanion(
            id: id,
            accountName: accountName,
            profileImage: profileImage,
            bio: bio,
            roleId: roleId,
            hostCode: hostCode,
            createdAt: createdAt,
            createdBy: createdBy,
            updatedAt: updatedAt,
            updatedBy: updatedBy,
            deletedAt: deletedAt,
            deletedBy: deletedBy,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String accountName,
            Value<String?> profileImage = const Value.absent(),
            Value<String?> bio = const Value.absent(),
            required int roleId,
            required String hostCode,
            required DateTime createdAt,
            required int createdBy,
            required DateTime updatedAt,
            required int updatedBy,
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int?> deletedBy = const Value.absent(),
          }) =>
              AccountsCompanion.insert(
            id: id,
            accountName: accountName,
            profileImage: profileImage,
            bio: bio,
            roleId: roleId,
            hostCode: hostCode,
            createdAt: createdAt,
            createdBy: createdBy,
            updatedAt: updatedAt,
            updatedBy: updatedBy,
            deletedAt: deletedAt,
            deletedBy: deletedBy,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $AccountsProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    Accounts,
    Account,
    $AccountsFilterComposer,
    $AccountsOrderingComposer,
    $AccountsAnnotationComposer,
    $AccountsCreateCompanionBuilder,
    $AccountsUpdateCompanionBuilder,
    (Account, BaseReferences<_$AppDatabase, Accounts, Account>),
    Account,
    PrefetchHooks Function()>;
typedef $CommentsCreateCompanionBuilder = CommentsCompanion Function({
  Value<int> id,
  required int recipeId,
  required int accountId,
  required String message,
  required DateTime createdAt,
  required int createdBy,
  required DateTime updatedAt,
  required int updatedBy,
  Value<DateTime?> deletedAt,
  Value<int?> deletedBy,
});
typedef $CommentsUpdateCompanionBuilder = CommentsCompanion Function({
  Value<int> id,
  Value<int> recipeId,
  Value<int> accountId,
  Value<String> message,
  Value<DateTime> createdAt,
  Value<int> createdBy,
  Value<DateTime> updatedAt,
  Value<int> updatedBy,
  Value<DateTime?> deletedAt,
  Value<int?> deletedBy,
});

class $CommentsFilterComposer extends Composer<_$AppDatabase, Comments> {
  $CommentsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get recipeId => $composableBuilder(
      column: $table.recipeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get message => $composableBuilder(
      column: $table.message, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get deletedBy => $composableBuilder(
      column: $table.deletedBy, builder: (column) => ColumnFilters(column));
}

class $CommentsOrderingComposer extends Composer<_$AppDatabase, Comments> {
  $CommentsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get recipeId => $composableBuilder(
      column: $table.recipeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get message => $composableBuilder(
      column: $table.message, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get deletedBy => $composableBuilder(
      column: $table.deletedBy, builder: (column) => ColumnOrderings(column));
}

class $CommentsAnnotationComposer extends Composer<_$AppDatabase, Comments> {
  $CommentsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get recipeId =>
      $composableBuilder(column: $table.recipeId, builder: (column) => column);

  GeneratedColumn<int> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<String> get message =>
      $composableBuilder(column: $table.message, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedBy =>
      $composableBuilder(column: $table.deletedBy, builder: (column) => column);
}

class $CommentsTableManager extends RootTableManager<
    _$AppDatabase,
    Comments,
    Comment,
    $CommentsFilterComposer,
    $CommentsOrderingComposer,
    $CommentsAnnotationComposer,
    $CommentsCreateCompanionBuilder,
    $CommentsUpdateCompanionBuilder,
    (Comment, BaseReferences<_$AppDatabase, Comments, Comment>),
    Comment,
    PrefetchHooks Function()> {
  $CommentsTableManager(_$AppDatabase db, Comments table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $CommentsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $CommentsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $CommentsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> recipeId = const Value.absent(),
            Value<int> accountId = const Value.absent(),
            Value<String> message = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> createdBy = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> updatedBy = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int?> deletedBy = const Value.absent(),
          }) =>
              CommentsCompanion(
            id: id,
            recipeId: recipeId,
            accountId: accountId,
            message: message,
            createdAt: createdAt,
            createdBy: createdBy,
            updatedAt: updatedAt,
            updatedBy: updatedBy,
            deletedAt: deletedAt,
            deletedBy: deletedBy,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int recipeId,
            required int accountId,
            required String message,
            required DateTime createdAt,
            required int createdBy,
            required DateTime updatedAt,
            required int updatedBy,
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int?> deletedBy = const Value.absent(),
          }) =>
              CommentsCompanion.insert(
            id: id,
            recipeId: recipeId,
            accountId: accountId,
            message: message,
            createdAt: createdAt,
            createdBy: createdBy,
            updatedAt: updatedAt,
            updatedBy: updatedBy,
            deletedAt: deletedAt,
            deletedBy: deletedBy,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $CommentsProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    Comments,
    Comment,
    $CommentsFilterComposer,
    $CommentsOrderingComposer,
    $CommentsAnnotationComposer,
    $CommentsCreateCompanionBuilder,
    $CommentsUpdateCompanionBuilder,
    (Comment, BaseReferences<_$AppDatabase, Comments, Comment>),
    Comment,
    PrefetchHooks Function()>;
typedef $HistoriesCreateCompanionBuilder = HistoriesCompanion Function({
  required int accountId,
  required int recipeId,
  required DateTime createdAt,
  required int createdBy,
  required DateTime updatedAt,
  required int updatedBy,
  Value<DateTime?> deletedAt,
  Value<int?> deletedBy,
  Value<int?> stepNr,
  required bool open,
  Value<String?> additionalData,
  Value<int> rowid,
});
typedef $HistoriesUpdateCompanionBuilder = HistoriesCompanion Function({
  Value<int> accountId,
  Value<int> recipeId,
  Value<DateTime> createdAt,
  Value<int> createdBy,
  Value<DateTime> updatedAt,
  Value<int> updatedBy,
  Value<DateTime?> deletedAt,
  Value<int?> deletedBy,
  Value<int?> stepNr,
  Value<bool> open,
  Value<String?> additionalData,
  Value<int> rowid,
});

class $HistoriesFilterComposer extends Composer<_$AppDatabase, Histories> {
  $HistoriesFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get recipeId => $composableBuilder(
      column: $table.recipeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get deletedBy => $composableBuilder(
      column: $table.deletedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get stepNr => $composableBuilder(
      column: $table.stepNr, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get open => $composableBuilder(
      column: $table.open, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get additionalData => $composableBuilder(
      column: $table.additionalData,
      builder: (column) => ColumnFilters(column));
}

class $HistoriesOrderingComposer extends Composer<_$AppDatabase, Histories> {
  $HistoriesOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get recipeId => $composableBuilder(
      column: $table.recipeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get deletedBy => $composableBuilder(
      column: $table.deletedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get stepNr => $composableBuilder(
      column: $table.stepNr, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get open => $composableBuilder(
      column: $table.open, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get additionalData => $composableBuilder(
      column: $table.additionalData,
      builder: (column) => ColumnOrderings(column));
}

class $HistoriesAnnotationComposer extends Composer<_$AppDatabase, Histories> {
  $HistoriesAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<int> get recipeId =>
      $composableBuilder(column: $table.recipeId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedBy =>
      $composableBuilder(column: $table.deletedBy, builder: (column) => column);

  GeneratedColumn<int> get stepNr =>
      $composableBuilder(column: $table.stepNr, builder: (column) => column);

  GeneratedColumn<bool> get open =>
      $composableBuilder(column: $table.open, builder: (column) => column);

  GeneratedColumn<String> get additionalData => $composableBuilder(
      column: $table.additionalData, builder: (column) => column);
}

class $HistoriesTableManager extends RootTableManager<
    _$AppDatabase,
    Histories,
    History,
    $HistoriesFilterComposer,
    $HistoriesOrderingComposer,
    $HistoriesAnnotationComposer,
    $HistoriesCreateCompanionBuilder,
    $HistoriesUpdateCompanionBuilder,
    (History, BaseReferences<_$AppDatabase, Histories, History>),
    History,
    PrefetchHooks Function()> {
  $HistoriesTableManager(_$AppDatabase db, Histories table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $HistoriesFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $HistoriesOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $HistoriesAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> accountId = const Value.absent(),
            Value<int> recipeId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> createdBy = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> updatedBy = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int?> deletedBy = const Value.absent(),
            Value<int?> stepNr = const Value.absent(),
            Value<bool> open = const Value.absent(),
            Value<String?> additionalData = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              HistoriesCompanion(
            accountId: accountId,
            recipeId: recipeId,
            createdAt: createdAt,
            createdBy: createdBy,
            updatedAt: updatedAt,
            updatedBy: updatedBy,
            deletedAt: deletedAt,
            deletedBy: deletedBy,
            stepNr: stepNr,
            open: open,
            additionalData: additionalData,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int accountId,
            required int recipeId,
            required DateTime createdAt,
            required int createdBy,
            required DateTime updatedAt,
            required int updatedBy,
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int?> deletedBy = const Value.absent(),
            Value<int?> stepNr = const Value.absent(),
            required bool open,
            Value<String?> additionalData = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              HistoriesCompanion.insert(
            accountId: accountId,
            recipeId: recipeId,
            createdAt: createdAt,
            createdBy: createdBy,
            updatedAt: updatedAt,
            updatedBy: updatedBy,
            deletedAt: deletedAt,
            deletedBy: deletedBy,
            stepNr: stepNr,
            open: open,
            additionalData: additionalData,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $HistoriesProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    Histories,
    History,
    $HistoriesFilterComposer,
    $HistoriesOrderingComposer,
    $HistoriesAnnotationComposer,
    $HistoriesCreateCompanionBuilder,
    $HistoriesUpdateCompanionBuilder,
    (History, BaseReferences<_$AppDatabase, Histories, History>),
    History,
    PrefetchHooks Function()>;
typedef $ProfilesCreateCompanionBuilder = ProfilesCompanion Function({
  Value<int> id,
  required int accountId,
  required String name,
  required int roleId,
  required DateTime createdAt,
  required int createdBy,
  required DateTime updatedAt,
  required int updatedBy,
  Value<DateTime?> deletedAt,
  Value<int?> deletedBy,
});
typedef $ProfilesUpdateCompanionBuilder = ProfilesCompanion Function({
  Value<int> id,
  Value<int> accountId,
  Value<String> name,
  Value<int> roleId,
  Value<DateTime> createdAt,
  Value<int> createdBy,
  Value<DateTime> updatedAt,
  Value<int> updatedBy,
  Value<DateTime?> deletedAt,
  Value<int?> deletedBy,
});

class $ProfilesFilterComposer extends Composer<_$AppDatabase, Profiles> {
  $ProfilesFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get roleId => $composableBuilder(
      column: $table.roleId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get deletedBy => $composableBuilder(
      column: $table.deletedBy, builder: (column) => ColumnFilters(column));
}

class $ProfilesOrderingComposer extends Composer<_$AppDatabase, Profiles> {
  $ProfilesOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get roleId => $composableBuilder(
      column: $table.roleId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get deletedBy => $composableBuilder(
      column: $table.deletedBy, builder: (column) => ColumnOrderings(column));
}

class $ProfilesAnnotationComposer extends Composer<_$AppDatabase, Profiles> {
  $ProfilesAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get roleId =>
      $composableBuilder(column: $table.roleId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedBy =>
      $composableBuilder(column: $table.deletedBy, builder: (column) => column);
}

class $ProfilesTableManager extends RootTableManager<
    _$AppDatabase,
    Profiles,
    Profile,
    $ProfilesFilterComposer,
    $ProfilesOrderingComposer,
    $ProfilesAnnotationComposer,
    $ProfilesCreateCompanionBuilder,
    $ProfilesUpdateCompanionBuilder,
    (Profile, BaseReferences<_$AppDatabase, Profiles, Profile>),
    Profile,
    PrefetchHooks Function()> {
  $ProfilesTableManager(_$AppDatabase db, Profiles table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $ProfilesFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $ProfilesOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $ProfilesAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> accountId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> roleId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> createdBy = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> updatedBy = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int?> deletedBy = const Value.absent(),
          }) =>
              ProfilesCompanion(
            id: id,
            accountId: accountId,
            name: name,
            roleId: roleId,
            createdAt: createdAt,
            createdBy: createdBy,
            updatedAt: updatedAt,
            updatedBy: updatedBy,
            deletedAt: deletedAt,
            deletedBy: deletedBy,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int accountId,
            required String name,
            required int roleId,
            required DateTime createdAt,
            required int createdBy,
            required DateTime updatedAt,
            required int updatedBy,
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int?> deletedBy = const Value.absent(),
          }) =>
              ProfilesCompanion.insert(
            id: id,
            accountId: accountId,
            name: name,
            roleId: roleId,
            createdAt: createdAt,
            createdBy: createdBy,
            updatedAt: updatedAt,
            updatedBy: updatedBy,
            deletedAt: deletedAt,
            deletedBy: deletedBy,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $ProfilesProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    Profiles,
    Profile,
    $ProfilesFilterComposer,
    $ProfilesOrderingComposer,
    $ProfilesAnnotationComposer,
    $ProfilesCreateCompanionBuilder,
    $ProfilesUpdateCompanionBuilder,
    (Profile, BaseReferences<_$AppDatabase, Profiles, Profile>),
    Profile,
    PrefetchHooks Function()>;
typedef $AccountFollowsCreateCompanionBuilder = AccountFollowsCompanion
    Function({
  required int followerAccountId,
  required int followedAccountId,
  required DateTime createdAt,
  required int createdBy,
  required DateTime updatedAt,
  required int updatedBy,
  Value<DateTime?> deletedAt,
  Value<int?> deletedBy,
  Value<int> rowid,
});
typedef $AccountFollowsUpdateCompanionBuilder = AccountFollowsCompanion
    Function({
  Value<int> followerAccountId,
  Value<int> followedAccountId,
  Value<DateTime> createdAt,
  Value<int> createdBy,
  Value<DateTime> updatedAt,
  Value<int> updatedBy,
  Value<DateTime?> deletedAt,
  Value<int?> deletedBy,
  Value<int> rowid,
});

class $AccountFollowsFilterComposer
    extends Composer<_$AppDatabase, AccountFollows> {
  $AccountFollowsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get followerAccountId => $composableBuilder(
      column: $table.followerAccountId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get followedAccountId => $composableBuilder(
      column: $table.followedAccountId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get deletedBy => $composableBuilder(
      column: $table.deletedBy, builder: (column) => ColumnFilters(column));
}

class $AccountFollowsOrderingComposer
    extends Composer<_$AppDatabase, AccountFollows> {
  $AccountFollowsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get followerAccountId => $composableBuilder(
      column: $table.followerAccountId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get followedAccountId => $composableBuilder(
      column: $table.followedAccountId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get deletedBy => $composableBuilder(
      column: $table.deletedBy, builder: (column) => ColumnOrderings(column));
}

class $AccountFollowsAnnotationComposer
    extends Composer<_$AppDatabase, AccountFollows> {
  $AccountFollowsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get followerAccountId => $composableBuilder(
      column: $table.followerAccountId, builder: (column) => column);

  GeneratedColumn<int> get followedAccountId => $composableBuilder(
      column: $table.followedAccountId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedBy =>
      $composableBuilder(column: $table.deletedBy, builder: (column) => column);
}

class $AccountFollowsTableManager extends RootTableManager<
    _$AppDatabase,
    AccountFollows,
    AccountFollow,
    $AccountFollowsFilterComposer,
    $AccountFollowsOrderingComposer,
    $AccountFollowsAnnotationComposer,
    $AccountFollowsCreateCompanionBuilder,
    $AccountFollowsUpdateCompanionBuilder,
    (
      AccountFollow,
      BaseReferences<_$AppDatabase, AccountFollows, AccountFollow>
    ),
    AccountFollow,
    PrefetchHooks Function()> {
  $AccountFollowsTableManager(_$AppDatabase db, AccountFollows table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $AccountFollowsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $AccountFollowsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $AccountFollowsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> followerAccountId = const Value.absent(),
            Value<int> followedAccountId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> createdBy = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> updatedBy = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int?> deletedBy = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AccountFollowsCompanion(
            followerAccountId: followerAccountId,
            followedAccountId: followedAccountId,
            createdAt: createdAt,
            createdBy: createdBy,
            updatedAt: updatedAt,
            updatedBy: updatedBy,
            deletedAt: deletedAt,
            deletedBy: deletedBy,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int followerAccountId,
            required int followedAccountId,
            required DateTime createdAt,
            required int createdBy,
            required DateTime updatedAt,
            required int updatedBy,
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int?> deletedBy = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AccountFollowsCompanion.insert(
            followerAccountId: followerAccountId,
            followedAccountId: followedAccountId,
            createdAt: createdAt,
            createdBy: createdBy,
            updatedAt: updatedAt,
            updatedBy: updatedBy,
            deletedAt: deletedAt,
            deletedBy: deletedBy,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $AccountFollowsProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    AccountFollows,
    AccountFollow,
    $AccountFollowsFilterComposer,
    $AccountFollowsOrderingComposer,
    $AccountFollowsAnnotationComposer,
    $AccountFollowsCreateCompanionBuilder,
    $AccountFollowsUpdateCompanionBuilder,
    (
      AccountFollow,
      BaseReferences<_$AppDatabase, AccountFollows, AccountFollow>
    ),
    AccountFollow,
    PrefetchHooks Function()>;
typedef $AccountFriendsCreateCompanionBuilder = AccountFriendsCompanion
    Function({
  required int firstAccountId,
  required int secondAccountId,
  required int requestedBy,
  Value<String> status,
  required DateTime createdAt,
  required int createdBy,
  required DateTime updatedAt,
  required int updatedBy,
  Value<DateTime?> deletedAt,
  Value<int?> deletedBy,
  Value<int> rowid,
});
typedef $AccountFriendsUpdateCompanionBuilder = AccountFriendsCompanion
    Function({
  Value<int> firstAccountId,
  Value<int> secondAccountId,
  Value<int> requestedBy,
  Value<String> status,
  Value<DateTime> createdAt,
  Value<int> createdBy,
  Value<DateTime> updatedAt,
  Value<int> updatedBy,
  Value<DateTime?> deletedAt,
  Value<int?> deletedBy,
  Value<int> rowid,
});

class $AccountFriendsFilterComposer
    extends Composer<_$AppDatabase, AccountFriends> {
  $AccountFriendsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get firstAccountId => $composableBuilder(
      column: $table.firstAccountId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get secondAccountId => $composableBuilder(
      column: $table.secondAccountId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get requestedBy => $composableBuilder(
      column: $table.requestedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get deletedBy => $composableBuilder(
      column: $table.deletedBy, builder: (column) => ColumnFilters(column));
}

class $AccountFriendsOrderingComposer
    extends Composer<_$AppDatabase, AccountFriends> {
  $AccountFriendsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get firstAccountId => $composableBuilder(
      column: $table.firstAccountId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get secondAccountId => $composableBuilder(
      column: $table.secondAccountId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get requestedBy => $composableBuilder(
      column: $table.requestedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get deletedBy => $composableBuilder(
      column: $table.deletedBy, builder: (column) => ColumnOrderings(column));
}

class $AccountFriendsAnnotationComposer
    extends Composer<_$AppDatabase, AccountFriends> {
  $AccountFriendsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get firstAccountId => $composableBuilder(
      column: $table.firstAccountId, builder: (column) => column);

  GeneratedColumn<int> get secondAccountId => $composableBuilder(
      column: $table.secondAccountId, builder: (column) => column);

  GeneratedColumn<int> get requestedBy => $composableBuilder(
      column: $table.requestedBy, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedBy =>
      $composableBuilder(column: $table.deletedBy, builder: (column) => column);
}

class $AccountFriendsTableManager extends RootTableManager<
    _$AppDatabase,
    AccountFriends,
    AccountFriend,
    $AccountFriendsFilterComposer,
    $AccountFriendsOrderingComposer,
    $AccountFriendsAnnotationComposer,
    $AccountFriendsCreateCompanionBuilder,
    $AccountFriendsUpdateCompanionBuilder,
    (
      AccountFriend,
      BaseReferences<_$AppDatabase, AccountFriends, AccountFriend>
    ),
    AccountFriend,
    PrefetchHooks Function()> {
  $AccountFriendsTableManager(_$AppDatabase db, AccountFriends table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $AccountFriendsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $AccountFriendsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $AccountFriendsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> firstAccountId = const Value.absent(),
            Value<int> secondAccountId = const Value.absent(),
            Value<int> requestedBy = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> createdBy = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> updatedBy = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int?> deletedBy = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AccountFriendsCompanion(
            firstAccountId: firstAccountId,
            secondAccountId: secondAccountId,
            requestedBy: requestedBy,
            status: status,
            createdAt: createdAt,
            createdBy: createdBy,
            updatedAt: updatedAt,
            updatedBy: updatedBy,
            deletedAt: deletedAt,
            deletedBy: deletedBy,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int firstAccountId,
            required int secondAccountId,
            required int requestedBy,
            Value<String> status = const Value.absent(),
            required DateTime createdAt,
            required int createdBy,
            required DateTime updatedAt,
            required int updatedBy,
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int?> deletedBy = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AccountFriendsCompanion.insert(
            firstAccountId: firstAccountId,
            secondAccountId: secondAccountId,
            requestedBy: requestedBy,
            status: status,
            createdAt: createdAt,
            createdBy: createdBy,
            updatedAt: updatedAt,
            updatedBy: updatedBy,
            deletedAt: deletedAt,
            deletedBy: deletedBy,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $AccountFriendsProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    AccountFriends,
    AccountFriend,
    $AccountFriendsFilterComposer,
    $AccountFriendsOrderingComposer,
    $AccountFriendsAnnotationComposer,
    $AccountFriendsCreateCompanionBuilder,
    $AccountFriendsUpdateCompanionBuilder,
    (
      AccountFriend,
      BaseReferences<_$AppDatabase, AccountFriends, AccountFriend>
    ),
    AccountFriend,
    PrefetchHooks Function()>;
typedef $ChatConversationsCreateCompanionBuilder = ChatConversationsCompanion
    Function({
  required int firstAccountId,
  required int secondAccountId,
  required DateTime createdAt,
  required int createdBy,
  required DateTime updatedAt,
  required int updatedBy,
  Value<DateTime?> deletedAt,
  Value<int?> deletedBy,
  Value<int> rowid,
});
typedef $ChatConversationsUpdateCompanionBuilder = ChatConversationsCompanion
    Function({
  Value<int> firstAccountId,
  Value<int> secondAccountId,
  Value<DateTime> createdAt,
  Value<int> createdBy,
  Value<DateTime> updatedAt,
  Value<int> updatedBy,
  Value<DateTime?> deletedAt,
  Value<int?> deletedBy,
  Value<int> rowid,
});

class $ChatConversationsFilterComposer
    extends Composer<_$AppDatabase, ChatConversations> {
  $ChatConversationsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get firstAccountId => $composableBuilder(
      column: $table.firstAccountId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get secondAccountId => $composableBuilder(
      column: $table.secondAccountId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get deletedBy => $composableBuilder(
      column: $table.deletedBy, builder: (column) => ColumnFilters(column));
}

class $ChatConversationsOrderingComposer
    extends Composer<_$AppDatabase, ChatConversations> {
  $ChatConversationsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get firstAccountId => $composableBuilder(
      column: $table.firstAccountId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get secondAccountId => $composableBuilder(
      column: $table.secondAccountId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get deletedBy => $composableBuilder(
      column: $table.deletedBy, builder: (column) => ColumnOrderings(column));
}

class $ChatConversationsAnnotationComposer
    extends Composer<_$AppDatabase, ChatConversations> {
  $ChatConversationsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get firstAccountId => $composableBuilder(
      column: $table.firstAccountId, builder: (column) => column);

  GeneratedColumn<int> get secondAccountId => $composableBuilder(
      column: $table.secondAccountId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedBy =>
      $composableBuilder(column: $table.deletedBy, builder: (column) => column);
}

class $ChatConversationsTableManager extends RootTableManager<
    _$AppDatabase,
    ChatConversations,
    ChatConversation,
    $ChatConversationsFilterComposer,
    $ChatConversationsOrderingComposer,
    $ChatConversationsAnnotationComposer,
    $ChatConversationsCreateCompanionBuilder,
    $ChatConversationsUpdateCompanionBuilder,
    (
      ChatConversation,
      BaseReferences<_$AppDatabase, ChatConversations, ChatConversation>
    ),
    ChatConversation,
    PrefetchHooks Function()> {
  $ChatConversationsTableManager(_$AppDatabase db, ChatConversations table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $ChatConversationsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $ChatConversationsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $ChatConversationsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> firstAccountId = const Value.absent(),
            Value<int> secondAccountId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> createdBy = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> updatedBy = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int?> deletedBy = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ChatConversationsCompanion(
            firstAccountId: firstAccountId,
            secondAccountId: secondAccountId,
            createdAt: createdAt,
            createdBy: createdBy,
            updatedAt: updatedAt,
            updatedBy: updatedBy,
            deletedAt: deletedAt,
            deletedBy: deletedBy,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int firstAccountId,
            required int secondAccountId,
            required DateTime createdAt,
            required int createdBy,
            required DateTime updatedAt,
            required int updatedBy,
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int?> deletedBy = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ChatConversationsCompanion.insert(
            firstAccountId: firstAccountId,
            secondAccountId: secondAccountId,
            createdAt: createdAt,
            createdBy: createdBy,
            updatedAt: updatedAt,
            updatedBy: updatedBy,
            deletedAt: deletedAt,
            deletedBy: deletedBy,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $ChatConversationsProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    ChatConversations,
    ChatConversation,
    $ChatConversationsFilterComposer,
    $ChatConversationsOrderingComposer,
    $ChatConversationsAnnotationComposer,
    $ChatConversationsCreateCompanionBuilder,
    $ChatConversationsUpdateCompanionBuilder,
    (
      ChatConversation,
      BaseReferences<_$AppDatabase, ChatConversations, ChatConversation>
    ),
    ChatConversation,
    PrefetchHooks Function()>;
typedef $ChatMessagesCreateCompanionBuilder = ChatMessagesCompanion Function({
  Value<int> id,
  required int firstAccountId,
  required int secondAccountId,
  required int senderAccountId,
  Value<String?> message,
  Value<int?> recipeId,
  Value<String?> recipeTitleSnapshot,
  Value<int?> shoppingListId,
  Value<String?> shoppingListNameSnapshot,
  Value<int?> replyToMessageId,
  Value<String?> replyMessageSnapshot,
  Value<DateTime?> readAt,
  required DateTime createdAt,
  required int createdBy,
  required DateTime updatedAt,
  required int updatedBy,
  Value<DateTime?> deletedAt,
  Value<int?> deletedBy,
});
typedef $ChatMessagesUpdateCompanionBuilder = ChatMessagesCompanion Function({
  Value<int> id,
  Value<int> firstAccountId,
  Value<int> secondAccountId,
  Value<int> senderAccountId,
  Value<String?> message,
  Value<int?> recipeId,
  Value<String?> recipeTitleSnapshot,
  Value<int?> shoppingListId,
  Value<String?> shoppingListNameSnapshot,
  Value<int?> replyToMessageId,
  Value<String?> replyMessageSnapshot,
  Value<DateTime?> readAt,
  Value<DateTime> createdAt,
  Value<int> createdBy,
  Value<DateTime> updatedAt,
  Value<int> updatedBy,
  Value<DateTime?> deletedAt,
  Value<int?> deletedBy,
});

class $ChatMessagesFilterComposer
    extends Composer<_$AppDatabase, ChatMessages> {
  $ChatMessagesFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get firstAccountId => $composableBuilder(
      column: $table.firstAccountId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get secondAccountId => $composableBuilder(
      column: $table.secondAccountId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get senderAccountId => $composableBuilder(
      column: $table.senderAccountId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get message => $composableBuilder(
      column: $table.message, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get recipeId => $composableBuilder(
      column: $table.recipeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recipeTitleSnapshot => $composableBuilder(
      column: $table.recipeTitleSnapshot,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get shoppingListId => $composableBuilder(
      column: $table.shoppingListId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get shoppingListNameSnapshot => $composableBuilder(
      column: $table.shoppingListNameSnapshot,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get replyToMessageId => $composableBuilder(
      column: $table.replyToMessageId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get replyMessageSnapshot => $composableBuilder(
      column: $table.replyMessageSnapshot,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get readAt => $composableBuilder(
      column: $table.readAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get deletedBy => $composableBuilder(
      column: $table.deletedBy, builder: (column) => ColumnFilters(column));
}

class $ChatMessagesOrderingComposer
    extends Composer<_$AppDatabase, ChatMessages> {
  $ChatMessagesOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get firstAccountId => $composableBuilder(
      column: $table.firstAccountId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get secondAccountId => $composableBuilder(
      column: $table.secondAccountId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get senderAccountId => $composableBuilder(
      column: $table.senderAccountId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get message => $composableBuilder(
      column: $table.message, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get recipeId => $composableBuilder(
      column: $table.recipeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recipeTitleSnapshot => $composableBuilder(
      column: $table.recipeTitleSnapshot,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get shoppingListId => $composableBuilder(
      column: $table.shoppingListId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get shoppingListNameSnapshot => $composableBuilder(
      column: $table.shoppingListNameSnapshot,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get replyToMessageId => $composableBuilder(
      column: $table.replyToMessageId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get replyMessageSnapshot => $composableBuilder(
      column: $table.replyMessageSnapshot,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get readAt => $composableBuilder(
      column: $table.readAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get deletedBy => $composableBuilder(
      column: $table.deletedBy, builder: (column) => ColumnOrderings(column));
}

class $ChatMessagesAnnotationComposer
    extends Composer<_$AppDatabase, ChatMessages> {
  $ChatMessagesAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get firstAccountId => $composableBuilder(
      column: $table.firstAccountId, builder: (column) => column);

  GeneratedColumn<int> get secondAccountId => $composableBuilder(
      column: $table.secondAccountId, builder: (column) => column);

  GeneratedColumn<int> get senderAccountId => $composableBuilder(
      column: $table.senderAccountId, builder: (column) => column);

  GeneratedColumn<String> get message =>
      $composableBuilder(column: $table.message, builder: (column) => column);

  GeneratedColumn<int> get recipeId =>
      $composableBuilder(column: $table.recipeId, builder: (column) => column);

  GeneratedColumn<String> get recipeTitleSnapshot => $composableBuilder(
      column: $table.recipeTitleSnapshot, builder: (column) => column);

  GeneratedColumn<int> get shoppingListId => $composableBuilder(
      column: $table.shoppingListId, builder: (column) => column);

  GeneratedColumn<String> get shoppingListNameSnapshot => $composableBuilder(
      column: $table.shoppingListNameSnapshot, builder: (column) => column);

  GeneratedColumn<int> get replyToMessageId => $composableBuilder(
      column: $table.replyToMessageId, builder: (column) => column);

  GeneratedColumn<String> get replyMessageSnapshot => $composableBuilder(
      column: $table.replyMessageSnapshot, builder: (column) => column);

  GeneratedColumn<DateTime> get readAt =>
      $composableBuilder(column: $table.readAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedBy =>
      $composableBuilder(column: $table.deletedBy, builder: (column) => column);
}

class $ChatMessagesTableManager extends RootTableManager<
    _$AppDatabase,
    ChatMessages,
    ChatMessage,
    $ChatMessagesFilterComposer,
    $ChatMessagesOrderingComposer,
    $ChatMessagesAnnotationComposer,
    $ChatMessagesCreateCompanionBuilder,
    $ChatMessagesUpdateCompanionBuilder,
    (ChatMessage, BaseReferences<_$AppDatabase, ChatMessages, ChatMessage>),
    ChatMessage,
    PrefetchHooks Function()> {
  $ChatMessagesTableManager(_$AppDatabase db, ChatMessages table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $ChatMessagesFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $ChatMessagesOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $ChatMessagesAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> firstAccountId = const Value.absent(),
            Value<int> secondAccountId = const Value.absent(),
            Value<int> senderAccountId = const Value.absent(),
            Value<String?> message = const Value.absent(),
            Value<int?> recipeId = const Value.absent(),
            Value<String?> recipeTitleSnapshot = const Value.absent(),
            Value<int?> shoppingListId = const Value.absent(),
            Value<String?> shoppingListNameSnapshot = const Value.absent(),
            Value<int?> replyToMessageId = const Value.absent(),
            Value<String?> replyMessageSnapshot = const Value.absent(),
            Value<DateTime?> readAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> createdBy = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> updatedBy = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int?> deletedBy = const Value.absent(),
          }) =>
              ChatMessagesCompanion(
            id: id,
            firstAccountId: firstAccountId,
            secondAccountId: secondAccountId,
            senderAccountId: senderAccountId,
            message: message,
            recipeId: recipeId,
            recipeTitleSnapshot: recipeTitleSnapshot,
            shoppingListId: shoppingListId,
            shoppingListNameSnapshot: shoppingListNameSnapshot,
            replyToMessageId: replyToMessageId,
            replyMessageSnapshot: replyMessageSnapshot,
            readAt: readAt,
            createdAt: createdAt,
            createdBy: createdBy,
            updatedAt: updatedAt,
            updatedBy: updatedBy,
            deletedAt: deletedAt,
            deletedBy: deletedBy,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int firstAccountId,
            required int secondAccountId,
            required int senderAccountId,
            Value<String?> message = const Value.absent(),
            Value<int?> recipeId = const Value.absent(),
            Value<String?> recipeTitleSnapshot = const Value.absent(),
            Value<int?> shoppingListId = const Value.absent(),
            Value<String?> shoppingListNameSnapshot = const Value.absent(),
            Value<int?> replyToMessageId = const Value.absent(),
            Value<String?> replyMessageSnapshot = const Value.absent(),
            Value<DateTime?> readAt = const Value.absent(),
            required DateTime createdAt,
            required int createdBy,
            required DateTime updatedAt,
            required int updatedBy,
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int?> deletedBy = const Value.absent(),
          }) =>
              ChatMessagesCompanion.insert(
            id: id,
            firstAccountId: firstAccountId,
            secondAccountId: secondAccountId,
            senderAccountId: senderAccountId,
            message: message,
            recipeId: recipeId,
            recipeTitleSnapshot: recipeTitleSnapshot,
            shoppingListId: shoppingListId,
            shoppingListNameSnapshot: shoppingListNameSnapshot,
            replyToMessageId: replyToMessageId,
            replyMessageSnapshot: replyMessageSnapshot,
            readAt: readAt,
            createdAt: createdAt,
            createdBy: createdBy,
            updatedAt: updatedAt,
            updatedBy: updatedBy,
            deletedAt: deletedAt,
            deletedBy: deletedBy,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $ChatMessagesProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    ChatMessages,
    ChatMessage,
    $ChatMessagesFilterComposer,
    $ChatMessagesOrderingComposer,
    $ChatMessagesAnnotationComposer,
    $ChatMessagesCreateCompanionBuilder,
    $ChatMessagesUpdateCompanionBuilder,
    (ChatMessage, BaseReferences<_$AppDatabase, ChatMessages, ChatMessage>),
    ChatMessage,
    PrefetchHooks Function()>;
typedef $ChatMessageReactionsCreateCompanionBuilder
    = ChatMessageReactionsCompanion Function({
  required int messageId,
  required int accountId,
  required String reaction,
  required DateTime createdAt,
  required int createdBy,
  required DateTime updatedAt,
  required int updatedBy,
  Value<DateTime?> deletedAt,
  Value<int?> deletedBy,
  Value<int> rowid,
});
typedef $ChatMessageReactionsUpdateCompanionBuilder
    = ChatMessageReactionsCompanion Function({
  Value<int> messageId,
  Value<int> accountId,
  Value<String> reaction,
  Value<DateTime> createdAt,
  Value<int> createdBy,
  Value<DateTime> updatedAt,
  Value<int> updatedBy,
  Value<DateTime?> deletedAt,
  Value<int?> deletedBy,
  Value<int> rowid,
});

class $ChatMessageReactionsFilterComposer
    extends Composer<_$AppDatabase, ChatMessageReactions> {
  $ChatMessageReactionsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get messageId => $composableBuilder(
      column: $table.messageId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reaction => $composableBuilder(
      column: $table.reaction, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get deletedBy => $composableBuilder(
      column: $table.deletedBy, builder: (column) => ColumnFilters(column));
}

class $ChatMessageReactionsOrderingComposer
    extends Composer<_$AppDatabase, ChatMessageReactions> {
  $ChatMessageReactionsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get messageId => $composableBuilder(
      column: $table.messageId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reaction => $composableBuilder(
      column: $table.reaction, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get deletedBy => $composableBuilder(
      column: $table.deletedBy, builder: (column) => ColumnOrderings(column));
}

class $ChatMessageReactionsAnnotationComposer
    extends Composer<_$AppDatabase, ChatMessageReactions> {
  $ChatMessageReactionsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get messageId =>
      $composableBuilder(column: $table.messageId, builder: (column) => column);

  GeneratedColumn<int> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<String> get reaction =>
      $composableBuilder(column: $table.reaction, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedBy =>
      $composableBuilder(column: $table.deletedBy, builder: (column) => column);
}

class $ChatMessageReactionsTableManager extends RootTableManager<
    _$AppDatabase,
    ChatMessageReactions,
    ChatMessageReaction,
    $ChatMessageReactionsFilterComposer,
    $ChatMessageReactionsOrderingComposer,
    $ChatMessageReactionsAnnotationComposer,
    $ChatMessageReactionsCreateCompanionBuilder,
    $ChatMessageReactionsUpdateCompanionBuilder,
    (
      ChatMessageReaction,
      BaseReferences<_$AppDatabase, ChatMessageReactions, ChatMessageReaction>
    ),
    ChatMessageReaction,
    PrefetchHooks Function()> {
  $ChatMessageReactionsTableManager(
      _$AppDatabase db, ChatMessageReactions table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $ChatMessageReactionsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $ChatMessageReactionsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $ChatMessageReactionsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> messageId = const Value.absent(),
            Value<int> accountId = const Value.absent(),
            Value<String> reaction = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> createdBy = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> updatedBy = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int?> deletedBy = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ChatMessageReactionsCompanion(
            messageId: messageId,
            accountId: accountId,
            reaction: reaction,
            createdAt: createdAt,
            createdBy: createdBy,
            updatedAt: updatedAt,
            updatedBy: updatedBy,
            deletedAt: deletedAt,
            deletedBy: deletedBy,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int messageId,
            required int accountId,
            required String reaction,
            required DateTime createdAt,
            required int createdBy,
            required DateTime updatedAt,
            required int updatedBy,
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int?> deletedBy = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ChatMessageReactionsCompanion.insert(
            messageId: messageId,
            accountId: accountId,
            reaction: reaction,
            createdAt: createdAt,
            createdBy: createdBy,
            updatedAt: updatedAt,
            updatedBy: updatedBy,
            deletedAt: deletedAt,
            deletedBy: deletedBy,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $ChatMessageReactionsProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    ChatMessageReactions,
    ChatMessageReaction,
    $ChatMessageReactionsFilterComposer,
    $ChatMessageReactionsOrderingComposer,
    $ChatMessageReactionsAnnotationComposer,
    $ChatMessageReactionsCreateCompanionBuilder,
    $ChatMessageReactionsUpdateCompanionBuilder,
    (
      ChatMessageReaction,
      BaseReferences<_$AppDatabase, ChatMessageReactions, ChatMessageReaction>
    ),
    ChatMessageReaction,
    PrefetchHooks Function()>;
typedef $RecipeLikesCreateCompanionBuilder = RecipeLikesCompanion Function({
  required int accountId,
  required int recipeId,
  required DateTime createdAt,
  required int createdBy,
  required DateTime updatedAt,
  required int updatedBy,
  Value<DateTime?> deletedAt,
  Value<int?> deletedBy,
  Value<int> rowid,
});
typedef $RecipeLikesUpdateCompanionBuilder = RecipeLikesCompanion Function({
  Value<int> accountId,
  Value<int> recipeId,
  Value<DateTime> createdAt,
  Value<int> createdBy,
  Value<DateTime> updatedAt,
  Value<int> updatedBy,
  Value<DateTime?> deletedAt,
  Value<int?> deletedBy,
  Value<int> rowid,
});

class $RecipeLikesFilterComposer extends Composer<_$AppDatabase, RecipeLikes> {
  $RecipeLikesFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get recipeId => $composableBuilder(
      column: $table.recipeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get deletedBy => $composableBuilder(
      column: $table.deletedBy, builder: (column) => ColumnFilters(column));
}

class $RecipeLikesOrderingComposer
    extends Composer<_$AppDatabase, RecipeLikes> {
  $RecipeLikesOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get recipeId => $composableBuilder(
      column: $table.recipeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get deletedBy => $composableBuilder(
      column: $table.deletedBy, builder: (column) => ColumnOrderings(column));
}

class $RecipeLikesAnnotationComposer
    extends Composer<_$AppDatabase, RecipeLikes> {
  $RecipeLikesAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<int> get recipeId =>
      $composableBuilder(column: $table.recipeId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedBy =>
      $composableBuilder(column: $table.deletedBy, builder: (column) => column);
}

class $RecipeLikesTableManager extends RootTableManager<
    _$AppDatabase,
    RecipeLikes,
    RecipeLike,
    $RecipeLikesFilterComposer,
    $RecipeLikesOrderingComposer,
    $RecipeLikesAnnotationComposer,
    $RecipeLikesCreateCompanionBuilder,
    $RecipeLikesUpdateCompanionBuilder,
    (RecipeLike, BaseReferences<_$AppDatabase, RecipeLikes, RecipeLike>),
    RecipeLike,
    PrefetchHooks Function()> {
  $RecipeLikesTableManager(_$AppDatabase db, RecipeLikes table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $RecipeLikesFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $RecipeLikesOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $RecipeLikesAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> accountId = const Value.absent(),
            Value<int> recipeId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> createdBy = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> updatedBy = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int?> deletedBy = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RecipeLikesCompanion(
            accountId: accountId,
            recipeId: recipeId,
            createdAt: createdAt,
            createdBy: createdBy,
            updatedAt: updatedAt,
            updatedBy: updatedBy,
            deletedAt: deletedAt,
            deletedBy: deletedBy,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int accountId,
            required int recipeId,
            required DateTime createdAt,
            required int createdBy,
            required DateTime updatedAt,
            required int updatedBy,
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int?> deletedBy = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RecipeLikesCompanion.insert(
            accountId: accountId,
            recipeId: recipeId,
            createdAt: createdAt,
            createdBy: createdBy,
            updatedAt: updatedAt,
            updatedBy: updatedBy,
            deletedAt: deletedAt,
            deletedBy: deletedBy,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $RecipeLikesProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    RecipeLikes,
    RecipeLike,
    $RecipeLikesFilterComposer,
    $RecipeLikesOrderingComposer,
    $RecipeLikesAnnotationComposer,
    $RecipeLikesCreateCompanionBuilder,
    $RecipeLikesUpdateCompanionBuilder,
    (RecipeLike, BaseReferences<_$AppDatabase, RecipeLikes, RecipeLike>),
    RecipeLike,
    PrefetchHooks Function()>;
typedef $ShoppingListsCreateCompanionBuilder = ShoppingListsCompanion Function({
  Value<int> id,
  required int accountId,
  required String name,
  required DateTime createdAt,
  required int createdBy,
  required DateTime updatedAt,
  required int updatedBy,
  Value<DateTime?> deletedAt,
  Value<int?> deletedBy,
});
typedef $ShoppingListsUpdateCompanionBuilder = ShoppingListsCompanion Function({
  Value<int> id,
  Value<int> accountId,
  Value<String> name,
  Value<DateTime> createdAt,
  Value<int> createdBy,
  Value<DateTime> updatedAt,
  Value<int> updatedBy,
  Value<DateTime?> deletedAt,
  Value<int?> deletedBy,
});

class $ShoppingListsFilterComposer
    extends Composer<_$AppDatabase, ShoppingLists> {
  $ShoppingListsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get deletedBy => $composableBuilder(
      column: $table.deletedBy, builder: (column) => ColumnFilters(column));
}

class $ShoppingListsOrderingComposer
    extends Composer<_$AppDatabase, ShoppingLists> {
  $ShoppingListsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get deletedBy => $composableBuilder(
      column: $table.deletedBy, builder: (column) => ColumnOrderings(column));
}

class $ShoppingListsAnnotationComposer
    extends Composer<_$AppDatabase, ShoppingLists> {
  $ShoppingListsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedBy =>
      $composableBuilder(column: $table.deletedBy, builder: (column) => column);
}

class $ShoppingListsTableManager extends RootTableManager<
    _$AppDatabase,
    ShoppingLists,
    ShoppingList,
    $ShoppingListsFilterComposer,
    $ShoppingListsOrderingComposer,
    $ShoppingListsAnnotationComposer,
    $ShoppingListsCreateCompanionBuilder,
    $ShoppingListsUpdateCompanionBuilder,
    (ShoppingList, BaseReferences<_$AppDatabase, ShoppingLists, ShoppingList>),
    ShoppingList,
    PrefetchHooks Function()> {
  $ShoppingListsTableManager(_$AppDatabase db, ShoppingLists table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $ShoppingListsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $ShoppingListsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $ShoppingListsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> accountId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> createdBy = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> updatedBy = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int?> deletedBy = const Value.absent(),
          }) =>
              ShoppingListsCompanion(
            id: id,
            accountId: accountId,
            name: name,
            createdAt: createdAt,
            createdBy: createdBy,
            updatedAt: updatedAt,
            updatedBy: updatedBy,
            deletedAt: deletedAt,
            deletedBy: deletedBy,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int accountId,
            required String name,
            required DateTime createdAt,
            required int createdBy,
            required DateTime updatedAt,
            required int updatedBy,
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int?> deletedBy = const Value.absent(),
          }) =>
              ShoppingListsCompanion.insert(
            id: id,
            accountId: accountId,
            name: name,
            createdAt: createdAt,
            createdBy: createdBy,
            updatedAt: updatedAt,
            updatedBy: updatedBy,
            deletedAt: deletedAt,
            deletedBy: deletedBy,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $ShoppingListsProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    ShoppingLists,
    ShoppingList,
    $ShoppingListsFilterComposer,
    $ShoppingListsOrderingComposer,
    $ShoppingListsAnnotationComposer,
    $ShoppingListsCreateCompanionBuilder,
    $ShoppingListsUpdateCompanionBuilder,
    (ShoppingList, BaseReferences<_$AppDatabase, ShoppingLists, ShoppingList>),
    ShoppingList,
    PrefetchHooks Function()>;
typedef $ShoppingListSectionsCreateCompanionBuilder
    = ShoppingListSectionsCompanion Function({
  Value<int> id,
  required int shoppingListId,
  required String name,
  Value<int> sortOrder,
  required DateTime createdAt,
  required int createdBy,
  required DateTime updatedAt,
  required int updatedBy,
  Value<DateTime?> deletedAt,
  Value<int?> deletedBy,
});
typedef $ShoppingListSectionsUpdateCompanionBuilder
    = ShoppingListSectionsCompanion Function({
  Value<int> id,
  Value<int> shoppingListId,
  Value<String> name,
  Value<int> sortOrder,
  Value<DateTime> createdAt,
  Value<int> createdBy,
  Value<DateTime> updatedAt,
  Value<int> updatedBy,
  Value<DateTime?> deletedAt,
  Value<int?> deletedBy,
});

class $ShoppingListSectionsFilterComposer
    extends Composer<_$AppDatabase, ShoppingListSections> {
  $ShoppingListSectionsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get shoppingListId => $composableBuilder(
      column: $table.shoppingListId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get deletedBy => $composableBuilder(
      column: $table.deletedBy, builder: (column) => ColumnFilters(column));
}

class $ShoppingListSectionsOrderingComposer
    extends Composer<_$AppDatabase, ShoppingListSections> {
  $ShoppingListSectionsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get shoppingListId => $composableBuilder(
      column: $table.shoppingListId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get deletedBy => $composableBuilder(
      column: $table.deletedBy, builder: (column) => ColumnOrderings(column));
}

class $ShoppingListSectionsAnnotationComposer
    extends Composer<_$AppDatabase, ShoppingListSections> {
  $ShoppingListSectionsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get shoppingListId => $composableBuilder(
      column: $table.shoppingListId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedBy =>
      $composableBuilder(column: $table.deletedBy, builder: (column) => column);
}

class $ShoppingListSectionsTableManager extends RootTableManager<
    _$AppDatabase,
    ShoppingListSections,
    ShoppingListSection,
    $ShoppingListSectionsFilterComposer,
    $ShoppingListSectionsOrderingComposer,
    $ShoppingListSectionsAnnotationComposer,
    $ShoppingListSectionsCreateCompanionBuilder,
    $ShoppingListSectionsUpdateCompanionBuilder,
    (
      ShoppingListSection,
      BaseReferences<_$AppDatabase, ShoppingListSections, ShoppingListSection>
    ),
    ShoppingListSection,
    PrefetchHooks Function()> {
  $ShoppingListSectionsTableManager(
      _$AppDatabase db, ShoppingListSections table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $ShoppingListSectionsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $ShoppingListSectionsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $ShoppingListSectionsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> shoppingListId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> createdBy = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> updatedBy = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int?> deletedBy = const Value.absent(),
          }) =>
              ShoppingListSectionsCompanion(
            id: id,
            shoppingListId: shoppingListId,
            name: name,
            sortOrder: sortOrder,
            createdAt: createdAt,
            createdBy: createdBy,
            updatedAt: updatedAt,
            updatedBy: updatedBy,
            deletedAt: deletedAt,
            deletedBy: deletedBy,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int shoppingListId,
            required String name,
            Value<int> sortOrder = const Value.absent(),
            required DateTime createdAt,
            required int createdBy,
            required DateTime updatedAt,
            required int updatedBy,
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int?> deletedBy = const Value.absent(),
          }) =>
              ShoppingListSectionsCompanion.insert(
            id: id,
            shoppingListId: shoppingListId,
            name: name,
            sortOrder: sortOrder,
            createdAt: createdAt,
            createdBy: createdBy,
            updatedAt: updatedAt,
            updatedBy: updatedBy,
            deletedAt: deletedAt,
            deletedBy: deletedBy,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $ShoppingListSectionsProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    ShoppingListSections,
    ShoppingListSection,
    $ShoppingListSectionsFilterComposer,
    $ShoppingListSectionsOrderingComposer,
    $ShoppingListSectionsAnnotationComposer,
    $ShoppingListSectionsCreateCompanionBuilder,
    $ShoppingListSectionsUpdateCompanionBuilder,
    (
      ShoppingListSection,
      BaseReferences<_$AppDatabase, ShoppingListSections, ShoppingListSection>
    ),
    ShoppingListSection,
    PrefetchHooks Function()>;
typedef $ShoppingListItemsCreateCompanionBuilder = ShoppingListItemsCompanion
    Function({
  Value<int> id,
  required int shoppingListId,
  Value<int?> sectionId,
  Value<int?> ingredientId,
  required String name,
  Value<double?> amount,
  Value<String?> unit,
  Value<String?> note,
  Value<String> shoppingCategoryCode,
  required bool checked,
  required DateTime createdAt,
  required int createdBy,
  required DateTime updatedAt,
  required int updatedBy,
  Value<DateTime?> deletedAt,
  Value<int?> deletedBy,
});
typedef $ShoppingListItemsUpdateCompanionBuilder = ShoppingListItemsCompanion
    Function({
  Value<int> id,
  Value<int> shoppingListId,
  Value<int?> sectionId,
  Value<int?> ingredientId,
  Value<String> name,
  Value<double?> amount,
  Value<String?> unit,
  Value<String?> note,
  Value<String> shoppingCategoryCode,
  Value<bool> checked,
  Value<DateTime> createdAt,
  Value<int> createdBy,
  Value<DateTime> updatedAt,
  Value<int> updatedBy,
  Value<DateTime?> deletedAt,
  Value<int?> deletedBy,
});

class $ShoppingListItemsFilterComposer
    extends Composer<_$AppDatabase, ShoppingListItems> {
  $ShoppingListItemsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get shoppingListId => $composableBuilder(
      column: $table.shoppingListId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sectionId => $composableBuilder(
      column: $table.sectionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get ingredientId => $composableBuilder(
      column: $table.ingredientId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get shoppingCategoryCode => $composableBuilder(
      column: $table.shoppingCategoryCode,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get checked => $composableBuilder(
      column: $table.checked, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get deletedBy => $composableBuilder(
      column: $table.deletedBy, builder: (column) => ColumnFilters(column));
}

class $ShoppingListItemsOrderingComposer
    extends Composer<_$AppDatabase, ShoppingListItems> {
  $ShoppingListItemsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get shoppingListId => $composableBuilder(
      column: $table.shoppingListId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sectionId => $composableBuilder(
      column: $table.sectionId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get ingredientId => $composableBuilder(
      column: $table.ingredientId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get shoppingCategoryCode => $composableBuilder(
      column: $table.shoppingCategoryCode,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get checked => $composableBuilder(
      column: $table.checked, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get deletedBy => $composableBuilder(
      column: $table.deletedBy, builder: (column) => ColumnOrderings(column));
}

class $ShoppingListItemsAnnotationComposer
    extends Composer<_$AppDatabase, ShoppingListItems> {
  $ShoppingListItemsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get shoppingListId => $composableBuilder(
      column: $table.shoppingListId, builder: (column) => column);

  GeneratedColumn<int> get sectionId =>
      $composableBuilder(column: $table.sectionId, builder: (column) => column);

  GeneratedColumn<int> get ingredientId => $composableBuilder(
      column: $table.ingredientId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get shoppingCategoryCode => $composableBuilder(
      column: $table.shoppingCategoryCode, builder: (column) => column);

  GeneratedColumn<bool> get checked =>
      $composableBuilder(column: $table.checked, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedBy =>
      $composableBuilder(column: $table.deletedBy, builder: (column) => column);
}

class $ShoppingListItemsTableManager extends RootTableManager<
    _$AppDatabase,
    ShoppingListItems,
    ShoppingListItem,
    $ShoppingListItemsFilterComposer,
    $ShoppingListItemsOrderingComposer,
    $ShoppingListItemsAnnotationComposer,
    $ShoppingListItemsCreateCompanionBuilder,
    $ShoppingListItemsUpdateCompanionBuilder,
    (
      ShoppingListItem,
      BaseReferences<_$AppDatabase, ShoppingListItems, ShoppingListItem>
    ),
    ShoppingListItem,
    PrefetchHooks Function()> {
  $ShoppingListItemsTableManager(_$AppDatabase db, ShoppingListItems table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $ShoppingListItemsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $ShoppingListItemsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $ShoppingListItemsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> shoppingListId = const Value.absent(),
            Value<int?> sectionId = const Value.absent(),
            Value<int?> ingredientId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<double?> amount = const Value.absent(),
            Value<String?> unit = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<String> shoppingCategoryCode = const Value.absent(),
            Value<bool> checked = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> createdBy = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> updatedBy = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int?> deletedBy = const Value.absent(),
          }) =>
              ShoppingListItemsCompanion(
            id: id,
            shoppingListId: shoppingListId,
            sectionId: sectionId,
            ingredientId: ingredientId,
            name: name,
            amount: amount,
            unit: unit,
            note: note,
            shoppingCategoryCode: shoppingCategoryCode,
            checked: checked,
            createdAt: createdAt,
            createdBy: createdBy,
            updatedAt: updatedAt,
            updatedBy: updatedBy,
            deletedAt: deletedAt,
            deletedBy: deletedBy,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int shoppingListId,
            Value<int?> sectionId = const Value.absent(),
            Value<int?> ingredientId = const Value.absent(),
            required String name,
            Value<double?> amount = const Value.absent(),
            Value<String?> unit = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<String> shoppingCategoryCode = const Value.absent(),
            required bool checked,
            required DateTime createdAt,
            required int createdBy,
            required DateTime updatedAt,
            required int updatedBy,
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int?> deletedBy = const Value.absent(),
          }) =>
              ShoppingListItemsCompanion.insert(
            id: id,
            shoppingListId: shoppingListId,
            sectionId: sectionId,
            ingredientId: ingredientId,
            name: name,
            amount: amount,
            unit: unit,
            note: note,
            shoppingCategoryCode: shoppingCategoryCode,
            checked: checked,
            createdAt: createdAt,
            createdBy: createdBy,
            updatedAt: updatedAt,
            updatedBy: updatedBy,
            deletedAt: deletedAt,
            deletedBy: deletedBy,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $ShoppingListItemsProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    ShoppingListItems,
    ShoppingListItem,
    $ShoppingListItemsFilterComposer,
    $ShoppingListItemsOrderingComposer,
    $ShoppingListItemsAnnotationComposer,
    $ShoppingListItemsCreateCompanionBuilder,
    $ShoppingListItemsUpdateCompanionBuilder,
    (
      ShoppingListItem,
      BaseReferences<_$AppDatabase, ShoppingListItems, ShoppingListItem>
    ),
    ShoppingListItem,
    PrefetchHooks Function()>;
typedef $ShoppingListMembersCreateCompanionBuilder
    = ShoppingListMembersCompanion Function({
  required int shoppingListId,
  required int accountId,
  required String permission,
  Value<String> status,
  required DateTime createdAt,
  required int createdBy,
  required DateTime updatedAt,
  required int updatedBy,
  Value<DateTime?> deletedAt,
  Value<int?> deletedBy,
  Value<int> rowid,
});
typedef $ShoppingListMembersUpdateCompanionBuilder
    = ShoppingListMembersCompanion Function({
  Value<int> shoppingListId,
  Value<int> accountId,
  Value<String> permission,
  Value<String> status,
  Value<DateTime> createdAt,
  Value<int> createdBy,
  Value<DateTime> updatedAt,
  Value<int> updatedBy,
  Value<DateTime?> deletedAt,
  Value<int?> deletedBy,
  Value<int> rowid,
});

class $ShoppingListMembersFilterComposer
    extends Composer<_$AppDatabase, ShoppingListMembers> {
  $ShoppingListMembersFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get shoppingListId => $composableBuilder(
      column: $table.shoppingListId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get permission => $composableBuilder(
      column: $table.permission, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get deletedBy => $composableBuilder(
      column: $table.deletedBy, builder: (column) => ColumnFilters(column));
}

class $ShoppingListMembersOrderingComposer
    extends Composer<_$AppDatabase, ShoppingListMembers> {
  $ShoppingListMembersOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get shoppingListId => $composableBuilder(
      column: $table.shoppingListId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get permission => $composableBuilder(
      column: $table.permission, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get deletedBy => $composableBuilder(
      column: $table.deletedBy, builder: (column) => ColumnOrderings(column));
}

class $ShoppingListMembersAnnotationComposer
    extends Composer<_$AppDatabase, ShoppingListMembers> {
  $ShoppingListMembersAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get shoppingListId => $composableBuilder(
      column: $table.shoppingListId, builder: (column) => column);

  GeneratedColumn<int> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<String> get permission => $composableBuilder(
      column: $table.permission, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedBy =>
      $composableBuilder(column: $table.deletedBy, builder: (column) => column);
}

class $ShoppingListMembersTableManager extends RootTableManager<
    _$AppDatabase,
    ShoppingListMembers,
    ShoppingListMember,
    $ShoppingListMembersFilterComposer,
    $ShoppingListMembersOrderingComposer,
    $ShoppingListMembersAnnotationComposer,
    $ShoppingListMembersCreateCompanionBuilder,
    $ShoppingListMembersUpdateCompanionBuilder,
    (
      ShoppingListMember,
      BaseReferences<_$AppDatabase, ShoppingListMembers, ShoppingListMember>
    ),
    ShoppingListMember,
    PrefetchHooks Function()> {
  $ShoppingListMembersTableManager(_$AppDatabase db, ShoppingListMembers table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $ShoppingListMembersFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $ShoppingListMembersOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $ShoppingListMembersAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> shoppingListId = const Value.absent(),
            Value<int> accountId = const Value.absent(),
            Value<String> permission = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> createdBy = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> updatedBy = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int?> deletedBy = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ShoppingListMembersCompanion(
            shoppingListId: shoppingListId,
            accountId: accountId,
            permission: permission,
            status: status,
            createdAt: createdAt,
            createdBy: createdBy,
            updatedAt: updatedAt,
            updatedBy: updatedBy,
            deletedAt: deletedAt,
            deletedBy: deletedBy,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int shoppingListId,
            required int accountId,
            required String permission,
            Value<String> status = const Value.absent(),
            required DateTime createdAt,
            required int createdBy,
            required DateTime updatedAt,
            required int updatedBy,
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int?> deletedBy = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ShoppingListMembersCompanion.insert(
            shoppingListId: shoppingListId,
            accountId: accountId,
            permission: permission,
            status: status,
            createdAt: createdAt,
            createdBy: createdBy,
            updatedAt: updatedAt,
            updatedBy: updatedBy,
            deletedAt: deletedAt,
            deletedBy: deletedBy,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $ShoppingListMembersProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    ShoppingListMembers,
    ShoppingListMember,
    $ShoppingListMembersFilterComposer,
    $ShoppingListMembersOrderingComposer,
    $ShoppingListMembersAnnotationComposer,
    $ShoppingListMembersCreateCompanionBuilder,
    $ShoppingListMembersUpdateCompanionBuilder,
    (
      ShoppingListMember,
      BaseReferences<_$AppDatabase, ShoppingListMembers, ShoppingListMember>
    ),
    ShoppingListMember,
    PrefetchHooks Function()>;
typedef $MealPlansCreateCompanionBuilder = MealPlansCompanion Function({
  Value<int> id,
  required int accountId,
  required String name,
  required DateTime createdAt,
  required int createdBy,
  required DateTime updatedAt,
  required int updatedBy,
  Value<DateTime?> deletedAt,
  Value<int?> deletedBy,
});
typedef $MealPlansUpdateCompanionBuilder = MealPlansCompanion Function({
  Value<int> id,
  Value<int> accountId,
  Value<String> name,
  Value<DateTime> createdAt,
  Value<int> createdBy,
  Value<DateTime> updatedAt,
  Value<int> updatedBy,
  Value<DateTime?> deletedAt,
  Value<int?> deletedBy,
});

class $MealPlansFilterComposer extends Composer<_$AppDatabase, MealPlans> {
  $MealPlansFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get deletedBy => $composableBuilder(
      column: $table.deletedBy, builder: (column) => ColumnFilters(column));
}

class $MealPlansOrderingComposer extends Composer<_$AppDatabase, MealPlans> {
  $MealPlansOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get deletedBy => $composableBuilder(
      column: $table.deletedBy, builder: (column) => ColumnOrderings(column));
}

class $MealPlansAnnotationComposer extends Composer<_$AppDatabase, MealPlans> {
  $MealPlansAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedBy =>
      $composableBuilder(column: $table.deletedBy, builder: (column) => column);
}

class $MealPlansTableManager extends RootTableManager<
    _$AppDatabase,
    MealPlans,
    MealPlan,
    $MealPlansFilterComposer,
    $MealPlansOrderingComposer,
    $MealPlansAnnotationComposer,
    $MealPlansCreateCompanionBuilder,
    $MealPlansUpdateCompanionBuilder,
    (MealPlan, BaseReferences<_$AppDatabase, MealPlans, MealPlan>),
    MealPlan,
    PrefetchHooks Function()> {
  $MealPlansTableManager(_$AppDatabase db, MealPlans table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $MealPlansFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $MealPlansOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $MealPlansAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> accountId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> createdBy = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> updatedBy = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int?> deletedBy = const Value.absent(),
          }) =>
              MealPlansCompanion(
            id: id,
            accountId: accountId,
            name: name,
            createdAt: createdAt,
            createdBy: createdBy,
            updatedAt: updatedAt,
            updatedBy: updatedBy,
            deletedAt: deletedAt,
            deletedBy: deletedBy,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int accountId,
            required String name,
            required DateTime createdAt,
            required int createdBy,
            required DateTime updatedAt,
            required int updatedBy,
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int?> deletedBy = const Value.absent(),
          }) =>
              MealPlansCompanion.insert(
            id: id,
            accountId: accountId,
            name: name,
            createdAt: createdAt,
            createdBy: createdBy,
            updatedAt: updatedAt,
            updatedBy: updatedBy,
            deletedAt: deletedAt,
            deletedBy: deletedBy,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $MealPlansProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    MealPlans,
    MealPlan,
    $MealPlansFilterComposer,
    $MealPlansOrderingComposer,
    $MealPlansAnnotationComposer,
    $MealPlansCreateCompanionBuilder,
    $MealPlansUpdateCompanionBuilder,
    (MealPlan, BaseReferences<_$AppDatabase, MealPlans, MealPlan>),
    MealPlan,
    PrefetchHooks Function()>;
typedef $MealPlanMembersCreateCompanionBuilder = MealPlanMembersCompanion
    Function({
  required int mealPlanId,
  required int accountId,
  required String permission,
  Value<String> status,
  required DateTime createdAt,
  required int createdBy,
  required DateTime updatedAt,
  required int updatedBy,
  Value<DateTime?> deletedAt,
  Value<int?> deletedBy,
  Value<int> rowid,
});
typedef $MealPlanMembersUpdateCompanionBuilder = MealPlanMembersCompanion
    Function({
  Value<int> mealPlanId,
  Value<int> accountId,
  Value<String> permission,
  Value<String> status,
  Value<DateTime> createdAt,
  Value<int> createdBy,
  Value<DateTime> updatedAt,
  Value<int> updatedBy,
  Value<DateTime?> deletedAt,
  Value<int?> deletedBy,
  Value<int> rowid,
});

class $MealPlanMembersFilterComposer
    extends Composer<_$AppDatabase, MealPlanMembers> {
  $MealPlanMembersFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get mealPlanId => $composableBuilder(
      column: $table.mealPlanId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get permission => $composableBuilder(
      column: $table.permission, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get deletedBy => $composableBuilder(
      column: $table.deletedBy, builder: (column) => ColumnFilters(column));
}

class $MealPlanMembersOrderingComposer
    extends Composer<_$AppDatabase, MealPlanMembers> {
  $MealPlanMembersOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get mealPlanId => $composableBuilder(
      column: $table.mealPlanId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get permission => $composableBuilder(
      column: $table.permission, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get deletedBy => $composableBuilder(
      column: $table.deletedBy, builder: (column) => ColumnOrderings(column));
}

class $MealPlanMembersAnnotationComposer
    extends Composer<_$AppDatabase, MealPlanMembers> {
  $MealPlanMembersAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get mealPlanId => $composableBuilder(
      column: $table.mealPlanId, builder: (column) => column);

  GeneratedColumn<int> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<String> get permission => $composableBuilder(
      column: $table.permission, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedBy =>
      $composableBuilder(column: $table.deletedBy, builder: (column) => column);
}

class $MealPlanMembersTableManager extends RootTableManager<
    _$AppDatabase,
    MealPlanMembers,
    MealPlanMember,
    $MealPlanMembersFilterComposer,
    $MealPlanMembersOrderingComposer,
    $MealPlanMembersAnnotationComposer,
    $MealPlanMembersCreateCompanionBuilder,
    $MealPlanMembersUpdateCompanionBuilder,
    (
      MealPlanMember,
      BaseReferences<_$AppDatabase, MealPlanMembers, MealPlanMember>
    ),
    MealPlanMember,
    PrefetchHooks Function()> {
  $MealPlanMembersTableManager(_$AppDatabase db, MealPlanMembers table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $MealPlanMembersFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $MealPlanMembersOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $MealPlanMembersAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> mealPlanId = const Value.absent(),
            Value<int> accountId = const Value.absent(),
            Value<String> permission = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> createdBy = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> updatedBy = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int?> deletedBy = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MealPlanMembersCompanion(
            mealPlanId: mealPlanId,
            accountId: accountId,
            permission: permission,
            status: status,
            createdAt: createdAt,
            createdBy: createdBy,
            updatedAt: updatedAt,
            updatedBy: updatedBy,
            deletedAt: deletedAt,
            deletedBy: deletedBy,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int mealPlanId,
            required int accountId,
            required String permission,
            Value<String> status = const Value.absent(),
            required DateTime createdAt,
            required int createdBy,
            required DateTime updatedAt,
            required int updatedBy,
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int?> deletedBy = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MealPlanMembersCompanion.insert(
            mealPlanId: mealPlanId,
            accountId: accountId,
            permission: permission,
            status: status,
            createdAt: createdAt,
            createdBy: createdBy,
            updatedAt: updatedAt,
            updatedBy: updatedBy,
            deletedAt: deletedAt,
            deletedBy: deletedBy,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $MealPlanMembersProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    MealPlanMembers,
    MealPlanMember,
    $MealPlanMembersFilterComposer,
    $MealPlanMembersOrderingComposer,
    $MealPlanMembersAnnotationComposer,
    $MealPlanMembersCreateCompanionBuilder,
    $MealPlanMembersUpdateCompanionBuilder,
    (
      MealPlanMember,
      BaseReferences<_$AppDatabase, MealPlanMembers, MealPlanMember>
    ),
    MealPlanMember,
    PrefetchHooks Function()>;
typedef $MealPlanEntriesCreateCompanionBuilder = MealPlanEntriesCompanion
    Function({
  Value<int> id,
  required int mealPlanId,
  required DateTime plannedDate,
  required String mealSlot,
  Value<int?> recipeId,
  Value<String?> recipeTitleSnapshot,
  Value<String?> customTitle,
  Value<String?> note,
  Value<int?> servings,
  Value<int> sortOrder,
  required DateTime createdAt,
  required int createdBy,
  required DateTime updatedAt,
  required int updatedBy,
  Value<DateTime?> deletedAt,
  Value<int?> deletedBy,
});
typedef $MealPlanEntriesUpdateCompanionBuilder = MealPlanEntriesCompanion
    Function({
  Value<int> id,
  Value<int> mealPlanId,
  Value<DateTime> plannedDate,
  Value<String> mealSlot,
  Value<int?> recipeId,
  Value<String?> recipeTitleSnapshot,
  Value<String?> customTitle,
  Value<String?> note,
  Value<int?> servings,
  Value<int> sortOrder,
  Value<DateTime> createdAt,
  Value<int> createdBy,
  Value<DateTime> updatedAt,
  Value<int> updatedBy,
  Value<DateTime?> deletedAt,
  Value<int?> deletedBy,
});

class $MealPlanEntriesFilterComposer
    extends Composer<_$AppDatabase, MealPlanEntries> {
  $MealPlanEntriesFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get mealPlanId => $composableBuilder(
      column: $table.mealPlanId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get plannedDate => $composableBuilder(
      column: $table.plannedDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mealSlot => $composableBuilder(
      column: $table.mealSlot, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get recipeId => $composableBuilder(
      column: $table.recipeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recipeTitleSnapshot => $composableBuilder(
      column: $table.recipeTitleSnapshot,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get customTitle => $composableBuilder(
      column: $table.customTitle, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get servings => $composableBuilder(
      column: $table.servings, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get deletedBy => $composableBuilder(
      column: $table.deletedBy, builder: (column) => ColumnFilters(column));
}

class $MealPlanEntriesOrderingComposer
    extends Composer<_$AppDatabase, MealPlanEntries> {
  $MealPlanEntriesOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get mealPlanId => $composableBuilder(
      column: $table.mealPlanId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get plannedDate => $composableBuilder(
      column: $table.plannedDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mealSlot => $composableBuilder(
      column: $table.mealSlot, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get recipeId => $composableBuilder(
      column: $table.recipeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recipeTitleSnapshot => $composableBuilder(
      column: $table.recipeTitleSnapshot,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get customTitle => $composableBuilder(
      column: $table.customTitle, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get servings => $composableBuilder(
      column: $table.servings, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get deletedBy => $composableBuilder(
      column: $table.deletedBy, builder: (column) => ColumnOrderings(column));
}

class $MealPlanEntriesAnnotationComposer
    extends Composer<_$AppDatabase, MealPlanEntries> {
  $MealPlanEntriesAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get mealPlanId => $composableBuilder(
      column: $table.mealPlanId, builder: (column) => column);

  GeneratedColumn<DateTime> get plannedDate => $composableBuilder(
      column: $table.plannedDate, builder: (column) => column);

  GeneratedColumn<String> get mealSlot =>
      $composableBuilder(column: $table.mealSlot, builder: (column) => column);

  GeneratedColumn<int> get recipeId =>
      $composableBuilder(column: $table.recipeId, builder: (column) => column);

  GeneratedColumn<String> get recipeTitleSnapshot => $composableBuilder(
      column: $table.recipeTitleSnapshot, builder: (column) => column);

  GeneratedColumn<String> get customTitle => $composableBuilder(
      column: $table.customTitle, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<int> get servings =>
      $composableBuilder(column: $table.servings, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedBy =>
      $composableBuilder(column: $table.deletedBy, builder: (column) => column);
}

class $MealPlanEntriesTableManager extends RootTableManager<
    _$AppDatabase,
    MealPlanEntries,
    MealPlanEntry,
    $MealPlanEntriesFilterComposer,
    $MealPlanEntriesOrderingComposer,
    $MealPlanEntriesAnnotationComposer,
    $MealPlanEntriesCreateCompanionBuilder,
    $MealPlanEntriesUpdateCompanionBuilder,
    (
      MealPlanEntry,
      BaseReferences<_$AppDatabase, MealPlanEntries, MealPlanEntry>
    ),
    MealPlanEntry,
    PrefetchHooks Function()> {
  $MealPlanEntriesTableManager(_$AppDatabase db, MealPlanEntries table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $MealPlanEntriesFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $MealPlanEntriesOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $MealPlanEntriesAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> mealPlanId = const Value.absent(),
            Value<DateTime> plannedDate = const Value.absent(),
            Value<String> mealSlot = const Value.absent(),
            Value<int?> recipeId = const Value.absent(),
            Value<String?> recipeTitleSnapshot = const Value.absent(),
            Value<String?> customTitle = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<int?> servings = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> createdBy = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> updatedBy = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int?> deletedBy = const Value.absent(),
          }) =>
              MealPlanEntriesCompanion(
            id: id,
            mealPlanId: mealPlanId,
            plannedDate: plannedDate,
            mealSlot: mealSlot,
            recipeId: recipeId,
            recipeTitleSnapshot: recipeTitleSnapshot,
            customTitle: customTitle,
            note: note,
            servings: servings,
            sortOrder: sortOrder,
            createdAt: createdAt,
            createdBy: createdBy,
            updatedAt: updatedAt,
            updatedBy: updatedBy,
            deletedAt: deletedAt,
            deletedBy: deletedBy,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int mealPlanId,
            required DateTime plannedDate,
            required String mealSlot,
            Value<int?> recipeId = const Value.absent(),
            Value<String?> recipeTitleSnapshot = const Value.absent(),
            Value<String?> customTitle = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<int?> servings = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            required DateTime createdAt,
            required int createdBy,
            required DateTime updatedAt,
            required int updatedBy,
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int?> deletedBy = const Value.absent(),
          }) =>
              MealPlanEntriesCompanion.insert(
            id: id,
            mealPlanId: mealPlanId,
            plannedDate: plannedDate,
            mealSlot: mealSlot,
            recipeId: recipeId,
            recipeTitleSnapshot: recipeTitleSnapshot,
            customTitle: customTitle,
            note: note,
            servings: servings,
            sortOrder: sortOrder,
            createdAt: createdAt,
            createdBy: createdBy,
            updatedAt: updatedAt,
            updatedBy: updatedBy,
            deletedAt: deletedAt,
            deletedBy: deletedBy,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $MealPlanEntriesProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    MealPlanEntries,
    MealPlanEntry,
    $MealPlanEntriesFilterComposer,
    $MealPlanEntriesOrderingComposer,
    $MealPlanEntriesAnnotationComposer,
    $MealPlanEntriesCreateCompanionBuilder,
    $MealPlanEntriesUpdateCompanionBuilder,
    (
      MealPlanEntry,
      BaseReferences<_$AppDatabase, MealPlanEntries, MealPlanEntry>
    ),
    MealPlanEntry,
    PrefetchHooks Function()>;
typedef $MealPlanTemplatesCreateCompanionBuilder = MealPlanTemplatesCompanion
    Function({
  Value<int> id,
  required int accountId,
  required String name,
  required DateTime createdAt,
  required int createdBy,
  required DateTime updatedAt,
  required int updatedBy,
  Value<DateTime?> deletedAt,
  Value<int?> deletedBy,
});
typedef $MealPlanTemplatesUpdateCompanionBuilder = MealPlanTemplatesCompanion
    Function({
  Value<int> id,
  Value<int> accountId,
  Value<String> name,
  Value<DateTime> createdAt,
  Value<int> createdBy,
  Value<DateTime> updatedAt,
  Value<int> updatedBy,
  Value<DateTime?> deletedAt,
  Value<int?> deletedBy,
});

class $MealPlanTemplatesFilterComposer
    extends Composer<_$AppDatabase, MealPlanTemplates> {
  $MealPlanTemplatesFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get deletedBy => $composableBuilder(
      column: $table.deletedBy, builder: (column) => ColumnFilters(column));
}

class $MealPlanTemplatesOrderingComposer
    extends Composer<_$AppDatabase, MealPlanTemplates> {
  $MealPlanTemplatesOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get deletedBy => $composableBuilder(
      column: $table.deletedBy, builder: (column) => ColumnOrderings(column));
}

class $MealPlanTemplatesAnnotationComposer
    extends Composer<_$AppDatabase, MealPlanTemplates> {
  $MealPlanTemplatesAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedBy =>
      $composableBuilder(column: $table.deletedBy, builder: (column) => column);
}

class $MealPlanTemplatesTableManager extends RootTableManager<
    _$AppDatabase,
    MealPlanTemplates,
    MealPlanTemplate,
    $MealPlanTemplatesFilterComposer,
    $MealPlanTemplatesOrderingComposer,
    $MealPlanTemplatesAnnotationComposer,
    $MealPlanTemplatesCreateCompanionBuilder,
    $MealPlanTemplatesUpdateCompanionBuilder,
    (
      MealPlanTemplate,
      BaseReferences<_$AppDatabase, MealPlanTemplates, MealPlanTemplate>
    ),
    MealPlanTemplate,
    PrefetchHooks Function()> {
  $MealPlanTemplatesTableManager(_$AppDatabase db, MealPlanTemplates table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $MealPlanTemplatesFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $MealPlanTemplatesOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $MealPlanTemplatesAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> accountId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> createdBy = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> updatedBy = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int?> deletedBy = const Value.absent(),
          }) =>
              MealPlanTemplatesCompanion(
            id: id,
            accountId: accountId,
            name: name,
            createdAt: createdAt,
            createdBy: createdBy,
            updatedAt: updatedAt,
            updatedBy: updatedBy,
            deletedAt: deletedAt,
            deletedBy: deletedBy,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int accountId,
            required String name,
            required DateTime createdAt,
            required int createdBy,
            required DateTime updatedAt,
            required int updatedBy,
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int?> deletedBy = const Value.absent(),
          }) =>
              MealPlanTemplatesCompanion.insert(
            id: id,
            accountId: accountId,
            name: name,
            createdAt: createdAt,
            createdBy: createdBy,
            updatedAt: updatedAt,
            updatedBy: updatedBy,
            deletedAt: deletedAt,
            deletedBy: deletedBy,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $MealPlanTemplatesProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    MealPlanTemplates,
    MealPlanTemplate,
    $MealPlanTemplatesFilterComposer,
    $MealPlanTemplatesOrderingComposer,
    $MealPlanTemplatesAnnotationComposer,
    $MealPlanTemplatesCreateCompanionBuilder,
    $MealPlanTemplatesUpdateCompanionBuilder,
    (
      MealPlanTemplate,
      BaseReferences<_$AppDatabase, MealPlanTemplates, MealPlanTemplate>
    ),
    MealPlanTemplate,
    PrefetchHooks Function()>;
typedef $MealPlanTemplateEntriesCreateCompanionBuilder
    = MealPlanTemplateEntriesCompanion Function({
  Value<int> id,
  required int templateId,
  required int dayOffset,
  required String mealSlot,
  Value<int?> recipeId,
  Value<String?> recipeTitleSnapshot,
  Value<String?> customTitle,
  Value<String?> note,
  Value<int?> servings,
  Value<int> sortOrder,
  required DateTime createdAt,
  required int createdBy,
  required DateTime updatedAt,
  required int updatedBy,
  Value<DateTime?> deletedAt,
  Value<int?> deletedBy,
});
typedef $MealPlanTemplateEntriesUpdateCompanionBuilder
    = MealPlanTemplateEntriesCompanion Function({
  Value<int> id,
  Value<int> templateId,
  Value<int> dayOffset,
  Value<String> mealSlot,
  Value<int?> recipeId,
  Value<String?> recipeTitleSnapshot,
  Value<String?> customTitle,
  Value<String?> note,
  Value<int?> servings,
  Value<int> sortOrder,
  Value<DateTime> createdAt,
  Value<int> createdBy,
  Value<DateTime> updatedAt,
  Value<int> updatedBy,
  Value<DateTime?> deletedAt,
  Value<int?> deletedBy,
});

class $MealPlanTemplateEntriesFilterComposer
    extends Composer<_$AppDatabase, MealPlanTemplateEntries> {
  $MealPlanTemplateEntriesFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get templateId => $composableBuilder(
      column: $table.templateId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get dayOffset => $composableBuilder(
      column: $table.dayOffset, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mealSlot => $composableBuilder(
      column: $table.mealSlot, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get recipeId => $composableBuilder(
      column: $table.recipeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recipeTitleSnapshot => $composableBuilder(
      column: $table.recipeTitleSnapshot,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get customTitle => $composableBuilder(
      column: $table.customTitle, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get servings => $composableBuilder(
      column: $table.servings, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get deletedBy => $composableBuilder(
      column: $table.deletedBy, builder: (column) => ColumnFilters(column));
}

class $MealPlanTemplateEntriesOrderingComposer
    extends Composer<_$AppDatabase, MealPlanTemplateEntries> {
  $MealPlanTemplateEntriesOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get templateId => $composableBuilder(
      column: $table.templateId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get dayOffset => $composableBuilder(
      column: $table.dayOffset, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mealSlot => $composableBuilder(
      column: $table.mealSlot, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get recipeId => $composableBuilder(
      column: $table.recipeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recipeTitleSnapshot => $composableBuilder(
      column: $table.recipeTitleSnapshot,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get customTitle => $composableBuilder(
      column: $table.customTitle, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get servings => $composableBuilder(
      column: $table.servings, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get deletedBy => $composableBuilder(
      column: $table.deletedBy, builder: (column) => ColumnOrderings(column));
}

class $MealPlanTemplateEntriesAnnotationComposer
    extends Composer<_$AppDatabase, MealPlanTemplateEntries> {
  $MealPlanTemplateEntriesAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get templateId => $composableBuilder(
      column: $table.templateId, builder: (column) => column);

  GeneratedColumn<int> get dayOffset =>
      $composableBuilder(column: $table.dayOffset, builder: (column) => column);

  GeneratedColumn<String> get mealSlot =>
      $composableBuilder(column: $table.mealSlot, builder: (column) => column);

  GeneratedColumn<int> get recipeId =>
      $composableBuilder(column: $table.recipeId, builder: (column) => column);

  GeneratedColumn<String> get recipeTitleSnapshot => $composableBuilder(
      column: $table.recipeTitleSnapshot, builder: (column) => column);

  GeneratedColumn<String> get customTitle => $composableBuilder(
      column: $table.customTitle, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<int> get servings =>
      $composableBuilder(column: $table.servings, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedBy =>
      $composableBuilder(column: $table.deletedBy, builder: (column) => column);
}

class $MealPlanTemplateEntriesTableManager extends RootTableManager<
    _$AppDatabase,
    MealPlanTemplateEntries,
    MealPlanTemplateEntry,
    $MealPlanTemplateEntriesFilterComposer,
    $MealPlanTemplateEntriesOrderingComposer,
    $MealPlanTemplateEntriesAnnotationComposer,
    $MealPlanTemplateEntriesCreateCompanionBuilder,
    $MealPlanTemplateEntriesUpdateCompanionBuilder,
    (
      MealPlanTemplateEntry,
      BaseReferences<_$AppDatabase, MealPlanTemplateEntries,
          MealPlanTemplateEntry>
    ),
    MealPlanTemplateEntry,
    PrefetchHooks Function()> {
  $MealPlanTemplateEntriesTableManager(
      _$AppDatabase db, MealPlanTemplateEntries table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $MealPlanTemplateEntriesFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $MealPlanTemplateEntriesOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $MealPlanTemplateEntriesAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> templateId = const Value.absent(),
            Value<int> dayOffset = const Value.absent(),
            Value<String> mealSlot = const Value.absent(),
            Value<int?> recipeId = const Value.absent(),
            Value<String?> recipeTitleSnapshot = const Value.absent(),
            Value<String?> customTitle = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<int?> servings = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> createdBy = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> updatedBy = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int?> deletedBy = const Value.absent(),
          }) =>
              MealPlanTemplateEntriesCompanion(
            id: id,
            templateId: templateId,
            dayOffset: dayOffset,
            mealSlot: mealSlot,
            recipeId: recipeId,
            recipeTitleSnapshot: recipeTitleSnapshot,
            customTitle: customTitle,
            note: note,
            servings: servings,
            sortOrder: sortOrder,
            createdAt: createdAt,
            createdBy: createdBy,
            updatedAt: updatedAt,
            updatedBy: updatedBy,
            deletedAt: deletedAt,
            deletedBy: deletedBy,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int templateId,
            required int dayOffset,
            required String mealSlot,
            Value<int?> recipeId = const Value.absent(),
            Value<String?> recipeTitleSnapshot = const Value.absent(),
            Value<String?> customTitle = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<int?> servings = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            required DateTime createdAt,
            required int createdBy,
            required DateTime updatedAt,
            required int updatedBy,
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int?> deletedBy = const Value.absent(),
          }) =>
              MealPlanTemplateEntriesCompanion.insert(
            id: id,
            templateId: templateId,
            dayOffset: dayOffset,
            mealSlot: mealSlot,
            recipeId: recipeId,
            recipeTitleSnapshot: recipeTitleSnapshot,
            customTitle: customTitle,
            note: note,
            servings: servings,
            sortOrder: sortOrder,
            createdAt: createdAt,
            createdBy: createdBy,
            updatedAt: updatedAt,
            updatedBy: updatedBy,
            deletedAt: deletedAt,
            deletedBy: deletedBy,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $MealPlanTemplateEntriesProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    MealPlanTemplateEntries,
    MealPlanTemplateEntry,
    $MealPlanTemplateEntriesFilterComposer,
    $MealPlanTemplateEntriesOrderingComposer,
    $MealPlanTemplateEntriesAnnotationComposer,
    $MealPlanTemplateEntriesCreateCompanionBuilder,
    $MealPlanTemplateEntriesUpdateCompanionBuilder,
    (
      MealPlanTemplateEntry,
      BaseReferences<_$AppDatabase, MealPlanTemplateEntries,
          MealPlanTemplateEntry>
    ),
    MealPlanTemplateEntry,
    PrefetchHooks Function()>;
typedef $PendingMutationsCreateCompanionBuilder = PendingMutationsCompanion
    Function({
  required String id,
  Value<int?> accountId,
  required String mutationType,
  required String payload,
  required DateTime createdAt,
  Value<int> attempts,
  Value<String?> lastError,
  Value<bool> blocked,
  Value<int> rowid,
});
typedef $PendingMutationsUpdateCompanionBuilder = PendingMutationsCompanion
    Function({
  Value<String> id,
  Value<int?> accountId,
  Value<String> mutationType,
  Value<String> payload,
  Value<DateTime> createdAt,
  Value<int> attempts,
  Value<String?> lastError,
  Value<bool> blocked,
  Value<int> rowid,
});

class $PendingMutationsFilterComposer
    extends Composer<_$AppDatabase, PendingMutations> {
  $PendingMutationsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mutationType => $composableBuilder(
      column: $table.mutationType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get payload => $composableBuilder(
      column: $table.payload, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get attempts => $composableBuilder(
      column: $table.attempts, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastError => $composableBuilder(
      column: $table.lastError, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get blocked => $composableBuilder(
      column: $table.blocked, builder: (column) => ColumnFilters(column));
}

class $PendingMutationsOrderingComposer
    extends Composer<_$AppDatabase, PendingMutations> {
  $PendingMutationsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mutationType => $composableBuilder(
      column: $table.mutationType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get payload => $composableBuilder(
      column: $table.payload, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get attempts => $composableBuilder(
      column: $table.attempts, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastError => $composableBuilder(
      column: $table.lastError, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get blocked => $composableBuilder(
      column: $table.blocked, builder: (column) => ColumnOrderings(column));
}

class $PendingMutationsAnnotationComposer
    extends Composer<_$AppDatabase, PendingMutations> {
  $PendingMutationsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<String> get mutationType => $composableBuilder(
      column: $table.mutationType, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<bool> get blocked =>
      $composableBuilder(column: $table.blocked, builder: (column) => column);
}

class $PendingMutationsTableManager extends RootTableManager<
    _$AppDatabase,
    PendingMutations,
    PendingMutation,
    $PendingMutationsFilterComposer,
    $PendingMutationsOrderingComposer,
    $PendingMutationsAnnotationComposer,
    $PendingMutationsCreateCompanionBuilder,
    $PendingMutationsUpdateCompanionBuilder,
    (
      PendingMutation,
      BaseReferences<_$AppDatabase, PendingMutations, PendingMutation>
    ),
    PendingMutation,
    PrefetchHooks Function()> {
  $PendingMutationsTableManager(_$AppDatabase db, PendingMutations table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $PendingMutationsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $PendingMutationsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $PendingMutationsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<int?> accountId = const Value.absent(),
            Value<String> mutationType = const Value.absent(),
            Value<String> payload = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> attempts = const Value.absent(),
            Value<String?> lastError = const Value.absent(),
            Value<bool> blocked = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PendingMutationsCompanion(
            id: id,
            accountId: accountId,
            mutationType: mutationType,
            payload: payload,
            createdAt: createdAt,
            attempts: attempts,
            lastError: lastError,
            blocked: blocked,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<int?> accountId = const Value.absent(),
            required String mutationType,
            required String payload,
            required DateTime createdAt,
            Value<int> attempts = const Value.absent(),
            Value<String?> lastError = const Value.absent(),
            Value<bool> blocked = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PendingMutationsCompanion.insert(
            id: id,
            accountId: accountId,
            mutationType: mutationType,
            payload: payload,
            createdAt: createdAt,
            attempts: attempts,
            lastError: lastError,
            blocked: blocked,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $PendingMutationsProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    PendingMutations,
    PendingMutation,
    $PendingMutationsFilterComposer,
    $PendingMutationsOrderingComposer,
    $PendingMutationsAnnotationComposer,
    $PendingMutationsCreateCompanionBuilder,
    $PendingMutationsUpdateCompanionBuilder,
    (
      PendingMutation,
      BaseReferences<_$AppDatabase, PendingMutations, PendingMutation>
    ),
    PendingMutation,
    PrefetchHooks Function()>;
typedef $RecipeStepsCreateCompanionBuilder = RecipeStepsCompanion Function({
  Value<int> id,
  required int recipeId,
  required int stepNr,
  required String description,
  Value<String?> image,
  required DateTime createdAt,
  required int createdBy,
  required DateTime updatedAt,
  required int updatedBy,
  Value<DateTime?> deletedAt,
  Value<int?> deletedBy,
});
typedef $RecipeStepsUpdateCompanionBuilder = RecipeStepsCompanion Function({
  Value<int> id,
  Value<int> recipeId,
  Value<int> stepNr,
  Value<String> description,
  Value<String?> image,
  Value<DateTime> createdAt,
  Value<int> createdBy,
  Value<DateTime> updatedAt,
  Value<int> updatedBy,
  Value<DateTime?> deletedAt,
  Value<int?> deletedBy,
});

class $RecipeStepsFilterComposer extends Composer<_$AppDatabase, RecipeSteps> {
  $RecipeStepsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get recipeId => $composableBuilder(
      column: $table.recipeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get stepNr => $composableBuilder(
      column: $table.stepNr, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get image => $composableBuilder(
      column: $table.image, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get deletedBy => $composableBuilder(
      column: $table.deletedBy, builder: (column) => ColumnFilters(column));
}

class $RecipeStepsOrderingComposer
    extends Composer<_$AppDatabase, RecipeSteps> {
  $RecipeStepsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get recipeId => $composableBuilder(
      column: $table.recipeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get stepNr => $composableBuilder(
      column: $table.stepNr, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get image => $composableBuilder(
      column: $table.image, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get deletedBy => $composableBuilder(
      column: $table.deletedBy, builder: (column) => ColumnOrderings(column));
}

class $RecipeStepsAnnotationComposer
    extends Composer<_$AppDatabase, RecipeSteps> {
  $RecipeStepsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get recipeId =>
      $composableBuilder(column: $table.recipeId, builder: (column) => column);

  GeneratedColumn<int> get stepNr =>
      $composableBuilder(column: $table.stepNr, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get image =>
      $composableBuilder(column: $table.image, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedBy =>
      $composableBuilder(column: $table.deletedBy, builder: (column) => column);
}

class $RecipeStepsTableManager extends RootTableManager<
    _$AppDatabase,
    RecipeSteps,
    RecipeStep,
    $RecipeStepsFilterComposer,
    $RecipeStepsOrderingComposer,
    $RecipeStepsAnnotationComposer,
    $RecipeStepsCreateCompanionBuilder,
    $RecipeStepsUpdateCompanionBuilder,
    (RecipeStep, BaseReferences<_$AppDatabase, RecipeSteps, RecipeStep>),
    RecipeStep,
    PrefetchHooks Function()> {
  $RecipeStepsTableManager(_$AppDatabase db, RecipeSteps table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $RecipeStepsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $RecipeStepsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $RecipeStepsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> recipeId = const Value.absent(),
            Value<int> stepNr = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<String?> image = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> createdBy = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> updatedBy = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int?> deletedBy = const Value.absent(),
          }) =>
              RecipeStepsCompanion(
            id: id,
            recipeId: recipeId,
            stepNr: stepNr,
            description: description,
            image: image,
            createdAt: createdAt,
            createdBy: createdBy,
            updatedAt: updatedAt,
            updatedBy: updatedBy,
            deletedAt: deletedAt,
            deletedBy: deletedBy,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int recipeId,
            required int stepNr,
            required String description,
            Value<String?> image = const Value.absent(),
            required DateTime createdAt,
            required int createdBy,
            required DateTime updatedAt,
            required int updatedBy,
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int?> deletedBy = const Value.absent(),
          }) =>
              RecipeStepsCompanion.insert(
            id: id,
            recipeId: recipeId,
            stepNr: stepNr,
            description: description,
            image: image,
            createdAt: createdAt,
            createdBy: createdBy,
            updatedAt: updatedAt,
            updatedBy: updatedBy,
            deletedAt: deletedAt,
            deletedBy: deletedBy,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $RecipeStepsProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    RecipeSteps,
    RecipeStep,
    $RecipeStepsFilterComposer,
    $RecipeStepsOrderingComposer,
    $RecipeStepsAnnotationComposer,
    $RecipeStepsCreateCompanionBuilder,
    $RecipeStepsUpdateCompanionBuilder,
    (RecipeStep, BaseReferences<_$AppDatabase, RecipeSteps, RecipeStep>),
    RecipeStep,
    PrefetchHooks Function()>;
typedef $RecipeStepIngredientsCreateCompanionBuilder
    = RecipeStepIngredientsCompanion Function({
  required int recipeStepId,
  required int ingredientId,
  required DateTime createdAt,
  required int createdBy,
  required DateTime updatedAt,
  required int updatedBy,
  Value<DateTime?> deletedAt,
  Value<int?> deletedBy,
  Value<int> rowid,
});
typedef $RecipeStepIngredientsUpdateCompanionBuilder
    = RecipeStepIngredientsCompanion Function({
  Value<int> recipeStepId,
  Value<int> ingredientId,
  Value<DateTime> createdAt,
  Value<int> createdBy,
  Value<DateTime> updatedAt,
  Value<int> updatedBy,
  Value<DateTime?> deletedAt,
  Value<int?> deletedBy,
  Value<int> rowid,
});

class $RecipeStepIngredientsFilterComposer
    extends Composer<_$AppDatabase, RecipeStepIngredients> {
  $RecipeStepIngredientsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get recipeStepId => $composableBuilder(
      column: $table.recipeStepId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get ingredientId => $composableBuilder(
      column: $table.ingredientId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get deletedBy => $composableBuilder(
      column: $table.deletedBy, builder: (column) => ColumnFilters(column));
}

class $RecipeStepIngredientsOrderingComposer
    extends Composer<_$AppDatabase, RecipeStepIngredients> {
  $RecipeStepIngredientsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get recipeStepId => $composableBuilder(
      column: $table.recipeStepId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get ingredientId => $composableBuilder(
      column: $table.ingredientId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get deletedBy => $composableBuilder(
      column: $table.deletedBy, builder: (column) => ColumnOrderings(column));
}

class $RecipeStepIngredientsAnnotationComposer
    extends Composer<_$AppDatabase, RecipeStepIngredients> {
  $RecipeStepIngredientsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get recipeStepId => $composableBuilder(
      column: $table.recipeStepId, builder: (column) => column);

  GeneratedColumn<int> get ingredientId => $composableBuilder(
      column: $table.ingredientId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedBy =>
      $composableBuilder(column: $table.deletedBy, builder: (column) => column);
}

class $RecipeStepIngredientsTableManager extends RootTableManager<
    _$AppDatabase,
    RecipeStepIngredients,
    RecipeStepIngredient,
    $RecipeStepIngredientsFilterComposer,
    $RecipeStepIngredientsOrderingComposer,
    $RecipeStepIngredientsAnnotationComposer,
    $RecipeStepIngredientsCreateCompanionBuilder,
    $RecipeStepIngredientsUpdateCompanionBuilder,
    (
      RecipeStepIngredient,
      BaseReferences<_$AppDatabase, RecipeStepIngredients, RecipeStepIngredient>
    ),
    RecipeStepIngredient,
    PrefetchHooks Function()> {
  $RecipeStepIngredientsTableManager(
      _$AppDatabase db, RecipeStepIngredients table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $RecipeStepIngredientsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $RecipeStepIngredientsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $RecipeStepIngredientsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> recipeStepId = const Value.absent(),
            Value<int> ingredientId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> createdBy = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> updatedBy = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int?> deletedBy = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RecipeStepIngredientsCompanion(
            recipeStepId: recipeStepId,
            ingredientId: ingredientId,
            createdAt: createdAt,
            createdBy: createdBy,
            updatedAt: updatedAt,
            updatedBy: updatedBy,
            deletedAt: deletedAt,
            deletedBy: deletedBy,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int recipeStepId,
            required int ingredientId,
            required DateTime createdAt,
            required int createdBy,
            required DateTime updatedAt,
            required int updatedBy,
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int?> deletedBy = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RecipeStepIngredientsCompanion.insert(
            recipeStepId: recipeStepId,
            ingredientId: ingredientId,
            createdAt: createdAt,
            createdBy: createdBy,
            updatedAt: updatedAt,
            updatedBy: updatedBy,
            deletedAt: deletedAt,
            deletedBy: deletedBy,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $RecipeStepIngredientsProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    RecipeStepIngredients,
    RecipeStepIngredient,
    $RecipeStepIngredientsFilterComposer,
    $RecipeStepIngredientsOrderingComposer,
    $RecipeStepIngredientsAnnotationComposer,
    $RecipeStepIngredientsCreateCompanionBuilder,
    $RecipeStepIngredientsUpdateCompanionBuilder,
    (
      RecipeStepIngredient,
      BaseReferences<_$AppDatabase, RecipeStepIngredients, RecipeStepIngredient>
    ),
    RecipeStepIngredient,
    PrefetchHooks Function()>;
typedef $RecipesCategoriesCreateCompanionBuilder = RecipesCategoriesCompanion
    Function({
  required int categoryId,
  required int recipeId,
  required DateTime createdAt,
  required int createdBy,
  required DateTime updatedAt,
  required int updatedBy,
  Value<DateTime?> deletedAt,
  Value<int?> deletedBy,
  Value<int> rowid,
});
typedef $RecipesCategoriesUpdateCompanionBuilder = RecipesCategoriesCompanion
    Function({
  Value<int> categoryId,
  Value<int> recipeId,
  Value<DateTime> createdAt,
  Value<int> createdBy,
  Value<DateTime> updatedAt,
  Value<int> updatedBy,
  Value<DateTime?> deletedAt,
  Value<int?> deletedBy,
  Value<int> rowid,
});

class $RecipesCategoriesFilterComposer
    extends Composer<_$AppDatabase, RecipesCategories> {
  $RecipesCategoriesFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get recipeId => $composableBuilder(
      column: $table.recipeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get deletedBy => $composableBuilder(
      column: $table.deletedBy, builder: (column) => ColumnFilters(column));
}

class $RecipesCategoriesOrderingComposer
    extends Composer<_$AppDatabase, RecipesCategories> {
  $RecipesCategoriesOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get recipeId => $composableBuilder(
      column: $table.recipeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get deletedBy => $composableBuilder(
      column: $table.deletedBy, builder: (column) => ColumnOrderings(column));
}

class $RecipesCategoriesAnnotationComposer
    extends Composer<_$AppDatabase, RecipesCategories> {
  $RecipesCategoriesAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => column);

  GeneratedColumn<int> get recipeId =>
      $composableBuilder(column: $table.recipeId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedBy =>
      $composableBuilder(column: $table.deletedBy, builder: (column) => column);
}

class $RecipesCategoriesTableManager extends RootTableManager<
    _$AppDatabase,
    RecipesCategories,
    RecipeCategory,
    $RecipesCategoriesFilterComposer,
    $RecipesCategoriesOrderingComposer,
    $RecipesCategoriesAnnotationComposer,
    $RecipesCategoriesCreateCompanionBuilder,
    $RecipesCategoriesUpdateCompanionBuilder,
    (
      RecipeCategory,
      BaseReferences<_$AppDatabase, RecipesCategories, RecipeCategory>
    ),
    RecipeCategory,
    PrefetchHooks Function()> {
  $RecipesCategoriesTableManager(_$AppDatabase db, RecipesCategories table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $RecipesCategoriesFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $RecipesCategoriesOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $RecipesCategoriesAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> categoryId = const Value.absent(),
            Value<int> recipeId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> createdBy = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> updatedBy = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int?> deletedBy = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RecipesCategoriesCompanion(
            categoryId: categoryId,
            recipeId: recipeId,
            createdAt: createdAt,
            createdBy: createdBy,
            updatedAt: updatedAt,
            updatedBy: updatedBy,
            deletedAt: deletedAt,
            deletedBy: deletedBy,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int categoryId,
            required int recipeId,
            required DateTime createdAt,
            required int createdBy,
            required DateTime updatedAt,
            required int updatedBy,
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int?> deletedBy = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RecipesCategoriesCompanion.insert(
            categoryId: categoryId,
            recipeId: recipeId,
            createdAt: createdAt,
            createdBy: createdBy,
            updatedAt: updatedAt,
            updatedBy: updatedBy,
            deletedAt: deletedAt,
            deletedBy: deletedBy,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $RecipesCategoriesProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    RecipesCategories,
    RecipeCategory,
    $RecipesCategoriesFilterComposer,
    $RecipesCategoriesOrderingComposer,
    $RecipesCategoriesAnnotationComposer,
    $RecipesCategoriesCreateCompanionBuilder,
    $RecipesCategoriesUpdateCompanionBuilder,
    (
      RecipeCategory,
      BaseReferences<_$AppDatabase, RecipesCategories, RecipeCategory>
    ),
    RecipeCategory,
    PrefetchHooks Function()>;
typedef $SettingsCreateCompanionBuilder = SettingsCompanion Function({
  Value<int> accountId,
  required String language,
  required DateTime createdAt,
  required int createdBy,
  required DateTime updatedAt,
  required int updatedBy,
  Value<DateTime?> deletedAt,
  Value<int?> deletedBy,
  required bool realtime,
  required bool lightmode,
});
typedef $SettingsUpdateCompanionBuilder = SettingsCompanion Function({
  Value<int> accountId,
  Value<String> language,
  Value<DateTime> createdAt,
  Value<int> createdBy,
  Value<DateTime> updatedAt,
  Value<int> updatedBy,
  Value<DateTime?> deletedAt,
  Value<int?> deletedBy,
  Value<bool> realtime,
  Value<bool> lightmode,
});

class $SettingsFilterComposer extends Composer<_$AppDatabase, Settings> {
  $SettingsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get language => $composableBuilder(
      column: $table.language, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get deletedBy => $composableBuilder(
      column: $table.deletedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get realtime => $composableBuilder(
      column: $table.realtime, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get lightmode => $composableBuilder(
      column: $table.lightmode, builder: (column) => ColumnFilters(column));
}

class $SettingsOrderingComposer extends Composer<_$AppDatabase, Settings> {
  $SettingsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get language => $composableBuilder(
      column: $table.language, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get deletedBy => $composableBuilder(
      column: $table.deletedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get realtime => $composableBuilder(
      column: $table.realtime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get lightmode => $composableBuilder(
      column: $table.lightmode, builder: (column) => ColumnOrderings(column));
}

class $SettingsAnnotationComposer extends Composer<_$AppDatabase, Settings> {
  $SettingsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedBy =>
      $composableBuilder(column: $table.deletedBy, builder: (column) => column);

  GeneratedColumn<bool> get realtime =>
      $composableBuilder(column: $table.realtime, builder: (column) => column);

  GeneratedColumn<bool> get lightmode =>
      $composableBuilder(column: $table.lightmode, builder: (column) => column);
}

class $SettingsTableManager extends RootTableManager<
    _$AppDatabase,
    Settings,
    Setting,
    $SettingsFilterComposer,
    $SettingsOrderingComposer,
    $SettingsAnnotationComposer,
    $SettingsCreateCompanionBuilder,
    $SettingsUpdateCompanionBuilder,
    (Setting, BaseReferences<_$AppDatabase, Settings, Setting>),
    Setting,
    PrefetchHooks Function()> {
  $SettingsTableManager(_$AppDatabase db, Settings table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $SettingsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $SettingsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $SettingsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> accountId = const Value.absent(),
            Value<String> language = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> createdBy = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> updatedBy = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int?> deletedBy = const Value.absent(),
            Value<bool> realtime = const Value.absent(),
            Value<bool> lightmode = const Value.absent(),
          }) =>
              SettingsCompanion(
            accountId: accountId,
            language: language,
            createdAt: createdAt,
            createdBy: createdBy,
            updatedAt: updatedAt,
            updatedBy: updatedBy,
            deletedAt: deletedAt,
            deletedBy: deletedBy,
            realtime: realtime,
            lightmode: lightmode,
          ),
          createCompanionCallback: ({
            Value<int> accountId = const Value.absent(),
            required String language,
            required DateTime createdAt,
            required int createdBy,
            required DateTime updatedAt,
            required int updatedBy,
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int?> deletedBy = const Value.absent(),
            required bool realtime,
            required bool lightmode,
          }) =>
              SettingsCompanion.insert(
            accountId: accountId,
            language: language,
            createdAt: createdAt,
            createdBy: createdBy,
            updatedAt: updatedAt,
            updatedBy: updatedBy,
            deletedAt: deletedAt,
            deletedBy: deletedBy,
            realtime: realtime,
            lightmode: lightmode,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $SettingsProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    Settings,
    Setting,
    $SettingsFilterComposer,
    $SettingsOrderingComposer,
    $SettingsAnnotationComposer,
    $SettingsCreateCompanionBuilder,
    $SettingsUpdateCompanionBuilder,
    (Setting, BaseReferences<_$AppDatabase, Settings, Setting>),
    Setting,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $CategoriesTableManager get categories =>
      $CategoriesTableManager(_db, _db.categories);
  $RecipesTableManager get recipes => $RecipesTableManager(_db, _db.recipes);
  $ShoppingCategoriesTableManager get shoppingCategories =>
      $ShoppingCategoriesTableManager(_db, _db.shoppingCategories);
  $IngredientsTableManager get ingredients =>
      $IngredientsTableManager(_db, _db.ingredients);
  $MeasurementUnitsTableManager get measurementUnits =>
      $MeasurementUnitsTableManager(_db, _db.measurementUnits);
  $RecipeIngredientsTableManager get recipeIngredients =>
      $RecipeIngredientsTableManager(_db, _db.recipeIngredients);
  $RolesTableManager get roles => $RolesTableManager(_db, _db.roles);
  $AccountsTableManager get accounts =>
      $AccountsTableManager(_db, _db.accounts);
  $CommentsTableManager get comments =>
      $CommentsTableManager(_db, _db.comments);
  $HistoriesTableManager get histories =>
      $HistoriesTableManager(_db, _db.histories);
  $ProfilesTableManager get profiles =>
      $ProfilesTableManager(_db, _db.profiles);
  $AccountFollowsTableManager get accountFollows =>
      $AccountFollowsTableManager(_db, _db.accountFollows);
  $AccountFriendsTableManager get accountFriends =>
      $AccountFriendsTableManager(_db, _db.accountFriends);
  $ChatConversationsTableManager get chatConversations =>
      $ChatConversationsTableManager(_db, _db.chatConversations);
  $ChatMessagesTableManager get chatMessages =>
      $ChatMessagesTableManager(_db, _db.chatMessages);
  $ChatMessageReactionsTableManager get chatMessageReactions =>
      $ChatMessageReactionsTableManager(_db, _db.chatMessageReactions);
  $RecipeLikesTableManager get recipeLikes =>
      $RecipeLikesTableManager(_db, _db.recipeLikes);
  $ShoppingListsTableManager get shoppingLists =>
      $ShoppingListsTableManager(_db, _db.shoppingLists);
  $ShoppingListSectionsTableManager get shoppingListSections =>
      $ShoppingListSectionsTableManager(_db, _db.shoppingListSections);
  $ShoppingListItemsTableManager get shoppingListItems =>
      $ShoppingListItemsTableManager(_db, _db.shoppingListItems);
  $ShoppingListMembersTableManager get shoppingListMembers =>
      $ShoppingListMembersTableManager(_db, _db.shoppingListMembers);
  $MealPlansTableManager get mealPlans =>
      $MealPlansTableManager(_db, _db.mealPlans);
  $MealPlanMembersTableManager get mealPlanMembers =>
      $MealPlanMembersTableManager(_db, _db.mealPlanMembers);
  $MealPlanEntriesTableManager get mealPlanEntries =>
      $MealPlanEntriesTableManager(_db, _db.mealPlanEntries);
  $MealPlanTemplatesTableManager get mealPlanTemplates =>
      $MealPlanTemplatesTableManager(_db, _db.mealPlanTemplates);
  $MealPlanTemplateEntriesTableManager get mealPlanTemplateEntries =>
      $MealPlanTemplateEntriesTableManager(_db, _db.mealPlanTemplateEntries);
  $PendingMutationsTableManager get pendingMutations =>
      $PendingMutationsTableManager(_db, _db.pendingMutations);
  $RecipeStepsTableManager get recipeSteps =>
      $RecipeStepsTableManager(_db, _db.recipeSteps);
  $RecipeStepIngredientsTableManager get recipeStepIngredients =>
      $RecipeStepIngredientsTableManager(_db, _db.recipeStepIngredients);
  $RecipesCategoriesTableManager get recipesCategories =>
      $RecipesCategoriesTableManager(_db, _db.recipesCategories);
  $SettingsTableManager get settings =>
      $SettingsTableManager(_db, _db.settings);
}

class OpenRecipeResult {
  final int id;
  final String title;
  final String? image;
  final String? description;
  final String? notes;
  final int? totalTimeMinutes;
  final int? servings;
  final int revision;
  final DateTime createdAt;
  final int createdBy;
  final DateTime updatedAt;
  final int updatedBy;
  final DateTime? deletedAt;
  final int? deletedBy;
  final int accountId;
  final int recipeId;
  final DateTime createdAt1;
  final int createdBy1;
  final DateTime updatedAt1;
  final int updatedBy1;
  final DateTime? deletedAt1;
  final int? deletedBy1;
  final int? stepNr;
  final bool open;
  final String? additionalData;
  OpenRecipeResult({
    required this.id,
    required this.title,
    this.image,
    this.description,
    this.notes,
    this.totalTimeMinutes,
    this.servings,
    required this.revision,
    required this.createdAt,
    required this.createdBy,
    required this.updatedAt,
    required this.updatedBy,
    this.deletedAt,
    this.deletedBy,
    required this.accountId,
    required this.recipeId,
    required this.createdAt1,
    required this.createdBy1,
    required this.updatedAt1,
    required this.updatedBy1,
    this.deletedAt1,
    this.deletedBy1,
    this.stepNr,
    required this.open,
    this.additionalData,
  });
}

class IngredientsOfRecipeResult {
  final int id;
  final String name;
  final String? shoppingCategoryCode;
  final DateTime createdAt;
  final int createdBy;
  final DateTime updatedAt;
  final int updatedBy;
  final DateTime? deletedAt;
  final int? deletedBy;
  final double? amount;
  final String? unit;
  final String? quantityNote;
  final String? sectionName;
  final int sortOrder;
  IngredientsOfRecipeResult({
    required this.id,
    required this.name,
    this.shoppingCategoryCode,
    required this.createdAt,
    required this.createdBy,
    required this.updatedAt,
    required this.updatedBy,
    this.deletedAt,
    this.deletedBy,
    this.amount,
    this.unit,
    this.quantityNote,
    this.sectionName,
    required this.sortOrder,
  });
}

class IngredientsOfRecipeStepResult {
  final int id;
  final String name;
  final String? shoppingCategoryCode;
  final DateTime createdAt;
  final int createdBy;
  final DateTime updatedAt;
  final int updatedBy;
  final DateTime? deletedAt;
  final int? deletedBy;
  final double? amount;
  final String? unit;
  final String? quantityNote;
  final String? sectionName;
  final int sortOrder;
  IngredientsOfRecipeStepResult({
    required this.id,
    required this.name,
    this.shoppingCategoryCode,
    required this.createdAt,
    required this.createdBy,
    required this.updatedAt,
    required this.updatedBy,
    this.deletedAt,
    this.deletedBy,
    this.amount,
    this.unit,
    this.quantityNote,
    this.sectionName,
    required this.sortOrder,
  });
}

class HistoryEntriesOfAccountAsRecipesResult {
  final int id;
  final String title;
  final String? image;
  final String? description;
  final String? notes;
  final int? totalTimeMinutes;
  final int? servings;
  final int revision;
  final DateTime createdAt;
  final int createdBy;
  final DateTime updatedAt;
  final int updatedBy;
  final DateTime? deletedAt;
  final int? deletedBy;
  final int numberOfSteps;
  HistoryEntriesOfAccountAsRecipesResult({
    required this.id,
    required this.title,
    this.image,
    this.description,
    this.notes,
    this.totalTimeMinutes,
    this.servings,
    required this.revision,
    required this.createdAt,
    required this.createdBy,
    required this.updatedAt,
    required this.updatedBy,
    this.deletedAt,
    this.deletedBy,
    required this.numberOfSteps,
  });
}

class AllRecipesResult {
  final int id;
  final String title;
  final String? image;
  final String? description;
  final String? notes;
  final int? totalTimeMinutes;
  final int? servings;
  final int revision;
  final DateTime createdAt;
  final int createdBy;
  final DateTime updatedAt;
  final int updatedBy;
  final DateTime? deletedAt;
  final int? deletedBy;
  final int numberOfSteps;
  AllRecipesResult({
    required this.id,
    required this.title,
    this.image,
    this.description,
    this.notes,
    this.totalTimeMinutes,
    this.servings,
    required this.revision,
    required this.createdAt,
    required this.createdBy,
    required this.updatedAt,
    required this.updatedBy,
    this.deletedAt,
    this.deletedBy,
    required this.numberOfSteps,
  });
}
