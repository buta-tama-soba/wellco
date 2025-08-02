// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $MealTableTable extends MealTable
    with TableInfo<$MealTableTable, MealTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MealTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _recordedAtMeta =
      const VerificationMeta('recordedAt');
  @override
  late final GeneratedColumn<DateTime> recordedAt = GeneratedColumn<DateTime>(
      'recorded_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _mealTypeMeta =
      const VerificationMeta('mealType');
  @override
  late final GeneratedColumn<String> mealType = GeneratedColumn<String>(
      'meal_type', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 20),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _memoMeta = const VerificationMeta('memo');
  @override
  late final GeneratedColumn<String> memo = GeneratedColumn<String>(
      'memo', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _totalCaloriesMeta =
      const VerificationMeta('totalCalories');
  @override
  late final GeneratedColumn<double> totalCalories = GeneratedColumn<double>(
      'total_calories', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _totalProteinMeta =
      const VerificationMeta('totalProtein');
  @override
  late final GeneratedColumn<double> totalProtein = GeneratedColumn<double>(
      'total_protein', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _totalFatMeta =
      const VerificationMeta('totalFat');
  @override
  late final GeneratedColumn<double> totalFat = GeneratedColumn<double>(
      'total_fat', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _totalCarbsMeta =
      const VerificationMeta('totalCarbs');
  @override
  late final GeneratedColumn<double> totalCarbs = GeneratedColumn<double>(
      'total_carbs', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        recordedAt,
        mealType,
        memo,
        totalCalories,
        totalProtein,
        totalFat,
        totalCarbs,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meal_table';
  @override
  VerificationContext validateIntegrity(Insertable<MealTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('recorded_at')) {
      context.handle(
          _recordedAtMeta,
          recordedAt.isAcceptableOrUnknown(
              data['recorded_at']!, _recordedAtMeta));
    } else if (isInserting) {
      context.missing(_recordedAtMeta);
    }
    if (data.containsKey('meal_type')) {
      context.handle(_mealTypeMeta,
          mealType.isAcceptableOrUnknown(data['meal_type']!, _mealTypeMeta));
    } else if (isInserting) {
      context.missing(_mealTypeMeta);
    }
    if (data.containsKey('memo')) {
      context.handle(
          _memoMeta, memo.isAcceptableOrUnknown(data['memo']!, _memoMeta));
    }
    if (data.containsKey('total_calories')) {
      context.handle(
          _totalCaloriesMeta,
          totalCalories.isAcceptableOrUnknown(
              data['total_calories']!, _totalCaloriesMeta));
    }
    if (data.containsKey('total_protein')) {
      context.handle(
          _totalProteinMeta,
          totalProtein.isAcceptableOrUnknown(
              data['total_protein']!, _totalProteinMeta));
    }
    if (data.containsKey('total_fat')) {
      context.handle(_totalFatMeta,
          totalFat.isAcceptableOrUnknown(data['total_fat']!, _totalFatMeta));
    }
    if (data.containsKey('total_carbs')) {
      context.handle(
          _totalCarbsMeta,
          totalCarbs.isAcceptableOrUnknown(
              data['total_carbs']!, _totalCarbsMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MealTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MealTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      recordedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}recorded_at'])!,
      mealType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}meal_type'])!,
      memo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}memo']),
      totalCalories: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_calories'])!,
      totalProtein: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_protein'])!,
      totalFat: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_fat'])!,
      totalCarbs: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_carbs'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $MealTableTable createAlias(String alias) {
    return $MealTableTable(attachedDatabase, alias);
  }
}

class MealTableData extends DataClass implements Insertable<MealTableData> {
  /// 主キー
  final int id;

  /// 記録日時
  final DateTime recordedAt;

  /// 食事タイプ（朝食、昼食、夕食、間食）
  final String mealType;

  /// メモ（任意）
  final String? memo;

  /// 合計カロリー（kcal）
  final double totalCalories;

  /// 合計タンパク質（g）
  final double totalProtein;

  /// 合計脂質（g）
  final double totalFat;

  /// 合計炭水化物（g）
  final double totalCarbs;

  /// 作成日時
  final DateTime createdAt;

  /// 更新日時
  final DateTime updatedAt;
  const MealTableData(
      {required this.id,
      required this.recordedAt,
      required this.mealType,
      this.memo,
      required this.totalCalories,
      required this.totalProtein,
      required this.totalFat,
      required this.totalCarbs,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['recorded_at'] = Variable<DateTime>(recordedAt);
    map['meal_type'] = Variable<String>(mealType);
    if (!nullToAbsent || memo != null) {
      map['memo'] = Variable<String>(memo);
    }
    map['total_calories'] = Variable<double>(totalCalories);
    map['total_protein'] = Variable<double>(totalProtein);
    map['total_fat'] = Variable<double>(totalFat);
    map['total_carbs'] = Variable<double>(totalCarbs);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  MealTableCompanion toCompanion(bool nullToAbsent) {
    return MealTableCompanion(
      id: Value(id),
      recordedAt: Value(recordedAt),
      mealType: Value(mealType),
      memo: memo == null && nullToAbsent ? const Value.absent() : Value(memo),
      totalCalories: Value(totalCalories),
      totalProtein: Value(totalProtein),
      totalFat: Value(totalFat),
      totalCarbs: Value(totalCarbs),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory MealTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MealTableData(
      id: serializer.fromJson<int>(json['id']),
      recordedAt: serializer.fromJson<DateTime>(json['recordedAt']),
      mealType: serializer.fromJson<String>(json['mealType']),
      memo: serializer.fromJson<String?>(json['memo']),
      totalCalories: serializer.fromJson<double>(json['totalCalories']),
      totalProtein: serializer.fromJson<double>(json['totalProtein']),
      totalFat: serializer.fromJson<double>(json['totalFat']),
      totalCarbs: serializer.fromJson<double>(json['totalCarbs']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'recordedAt': serializer.toJson<DateTime>(recordedAt),
      'mealType': serializer.toJson<String>(mealType),
      'memo': serializer.toJson<String?>(memo),
      'totalCalories': serializer.toJson<double>(totalCalories),
      'totalProtein': serializer.toJson<double>(totalProtein),
      'totalFat': serializer.toJson<double>(totalFat),
      'totalCarbs': serializer.toJson<double>(totalCarbs),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  MealTableData copyWith(
          {int? id,
          DateTime? recordedAt,
          String? mealType,
          Value<String?> memo = const Value.absent(),
          double? totalCalories,
          double? totalProtein,
          double? totalFat,
          double? totalCarbs,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      MealTableData(
        id: id ?? this.id,
        recordedAt: recordedAt ?? this.recordedAt,
        mealType: mealType ?? this.mealType,
        memo: memo.present ? memo.value : this.memo,
        totalCalories: totalCalories ?? this.totalCalories,
        totalProtein: totalProtein ?? this.totalProtein,
        totalFat: totalFat ?? this.totalFat,
        totalCarbs: totalCarbs ?? this.totalCarbs,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  MealTableData copyWithCompanion(MealTableCompanion data) {
    return MealTableData(
      id: data.id.present ? data.id.value : this.id,
      recordedAt:
          data.recordedAt.present ? data.recordedAt.value : this.recordedAt,
      mealType: data.mealType.present ? data.mealType.value : this.mealType,
      memo: data.memo.present ? data.memo.value : this.memo,
      totalCalories: data.totalCalories.present
          ? data.totalCalories.value
          : this.totalCalories,
      totalProtein: data.totalProtein.present
          ? data.totalProtein.value
          : this.totalProtein,
      totalFat: data.totalFat.present ? data.totalFat.value : this.totalFat,
      totalCarbs:
          data.totalCarbs.present ? data.totalCarbs.value : this.totalCarbs,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MealTableData(')
          ..write('id: $id, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('mealType: $mealType, ')
          ..write('memo: $memo, ')
          ..write('totalCalories: $totalCalories, ')
          ..write('totalProtein: $totalProtein, ')
          ..write('totalFat: $totalFat, ')
          ..write('totalCarbs: $totalCarbs, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, recordedAt, mealType, memo, totalCalories,
      totalProtein, totalFat, totalCarbs, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MealTableData &&
          other.id == this.id &&
          other.recordedAt == this.recordedAt &&
          other.mealType == this.mealType &&
          other.memo == this.memo &&
          other.totalCalories == this.totalCalories &&
          other.totalProtein == this.totalProtein &&
          other.totalFat == this.totalFat &&
          other.totalCarbs == this.totalCarbs &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class MealTableCompanion extends UpdateCompanion<MealTableData> {
  final Value<int> id;
  final Value<DateTime> recordedAt;
  final Value<String> mealType;
  final Value<String?> memo;
  final Value<double> totalCalories;
  final Value<double> totalProtein;
  final Value<double> totalFat;
  final Value<double> totalCarbs;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const MealTableCompanion({
    this.id = const Value.absent(),
    this.recordedAt = const Value.absent(),
    this.mealType = const Value.absent(),
    this.memo = const Value.absent(),
    this.totalCalories = const Value.absent(),
    this.totalProtein = const Value.absent(),
    this.totalFat = const Value.absent(),
    this.totalCarbs = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  MealTableCompanion.insert({
    this.id = const Value.absent(),
    required DateTime recordedAt,
    required String mealType,
    this.memo = const Value.absent(),
    this.totalCalories = const Value.absent(),
    this.totalProtein = const Value.absent(),
    this.totalFat = const Value.absent(),
    this.totalCarbs = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : recordedAt = Value(recordedAt),
        mealType = Value(mealType);
  static Insertable<MealTableData> custom({
    Expression<int>? id,
    Expression<DateTime>? recordedAt,
    Expression<String>? mealType,
    Expression<String>? memo,
    Expression<double>? totalCalories,
    Expression<double>? totalProtein,
    Expression<double>? totalFat,
    Expression<double>? totalCarbs,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recordedAt != null) 'recorded_at': recordedAt,
      if (mealType != null) 'meal_type': mealType,
      if (memo != null) 'memo': memo,
      if (totalCalories != null) 'total_calories': totalCalories,
      if (totalProtein != null) 'total_protein': totalProtein,
      if (totalFat != null) 'total_fat': totalFat,
      if (totalCarbs != null) 'total_carbs': totalCarbs,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  MealTableCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? recordedAt,
      Value<String>? mealType,
      Value<String?>? memo,
      Value<double>? totalCalories,
      Value<double>? totalProtein,
      Value<double>? totalFat,
      Value<double>? totalCarbs,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return MealTableCompanion(
      id: id ?? this.id,
      recordedAt: recordedAt ?? this.recordedAt,
      mealType: mealType ?? this.mealType,
      memo: memo ?? this.memo,
      totalCalories: totalCalories ?? this.totalCalories,
      totalProtein: totalProtein ?? this.totalProtein,
      totalFat: totalFat ?? this.totalFat,
      totalCarbs: totalCarbs ?? this.totalCarbs,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<DateTime>(recordedAt.value);
    }
    if (mealType.present) {
      map['meal_type'] = Variable<String>(mealType.value);
    }
    if (memo.present) {
      map['memo'] = Variable<String>(memo.value);
    }
    if (totalCalories.present) {
      map['total_calories'] = Variable<double>(totalCalories.value);
    }
    if (totalProtein.present) {
      map['total_protein'] = Variable<double>(totalProtein.value);
    }
    if (totalFat.present) {
      map['total_fat'] = Variable<double>(totalFat.value);
    }
    if (totalCarbs.present) {
      map['total_carbs'] = Variable<double>(totalCarbs.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MealTableCompanion(')
          ..write('id: $id, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('mealType: $mealType, ')
          ..write('memo: $memo, ')
          ..write('totalCalories: $totalCalories, ')
          ..write('totalProtein: $totalProtein, ')
          ..write('totalFat: $totalFat, ')
          ..write('totalCarbs: $totalCarbs, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ExternalRecipeTableTable extends ExternalRecipeTable
    with TableInfo<$ExternalRecipeTableTable, ExternalRecipeTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExternalRecipeTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
      'url', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 500),
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 200),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _imageUrlMeta =
      const VerificationMeta('imageUrl');
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
      'image_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _siteNameMeta =
      const VerificationMeta('siteName');
  @override
  late final GeneratedColumn<String> siteName = GeneratedColumn<String>(
      'site_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isFavoriteMeta =
      const VerificationMeta('isFavorite');
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
      'is_favorite', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_favorite" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
      'tags', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _memoMeta = const VerificationMeta('memo');
  @override
  late final GeneratedColumn<String> memo = GeneratedColumn<String>(
      'memo', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _ingredientsJsonMeta =
      const VerificationMeta('ingredientsJson');
  @override
  late final GeneratedColumn<String> ingredientsJson = GeneratedColumn<String>(
      'ingredients_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _ingredientsRawTextMeta =
      const VerificationMeta('ingredientsRawText');
  @override
  late final GeneratedColumn<String> ingredientsRawText =
      GeneratedColumn<String>('ingredients_raw_text', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _caloriesMeta =
      const VerificationMeta('calories');
  @override
  late final GeneratedColumn<double> calories = GeneratedColumn<double>(
      'calories', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _proteinMeta =
      const VerificationMeta('protein');
  @override
  late final GeneratedColumn<double> protein = GeneratedColumn<double>(
      'protein', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _fatMeta = const VerificationMeta('fat');
  @override
  late final GeneratedColumn<double> fat = GeneratedColumn<double>(
      'fat', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _carbohydrateMeta =
      const VerificationMeta('carbohydrate');
  @override
  late final GeneratedColumn<double> carbohydrate = GeneratedColumn<double>(
      'carbohydrate', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _saltMeta = const VerificationMeta('salt');
  @override
  late final GeneratedColumn<double> salt = GeneratedColumn<double>(
      'salt', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _fiberMeta = const VerificationMeta('fiber');
  @override
  late final GeneratedColumn<double> fiber = GeneratedColumn<double>(
      'fiber', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _vitaminCMeta =
      const VerificationMeta('vitaminC');
  @override
  late final GeneratedColumn<double> vitaminC = GeneratedColumn<double>(
      'vitamin_c', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _isNutritionAutoExtractedMeta =
      const VerificationMeta('isNutritionAutoExtracted');
  @override
  late final GeneratedColumn<bool> isNutritionAutoExtracted =
      GeneratedColumn<bool>(
          'is_nutrition_auto_extracted', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintIsAlways(
              'CHECK ("is_nutrition_auto_extracted" IN (0, 1))'),
          defaultValue: const Constant(false));
  static const VerificationMeta _servingsMeta =
      const VerificationMeta('servings');
  @override
  late final GeneratedColumn<int> servings = GeneratedColumn<int>(
      'servings', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _lastAccessedAtMeta =
      const VerificationMeta('lastAccessedAt');
  @override
  late final GeneratedColumn<DateTime> lastAccessedAt =
      GeneratedColumn<DateTime>('last_accessed_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        url,
        title,
        description,
        imageUrl,
        siteName,
        isFavorite,
        tags,
        memo,
        ingredientsJson,
        ingredientsRawText,
        calories,
        protein,
        fat,
        carbohydrate,
        salt,
        fiber,
        vitaminC,
        isNutritionAutoExtracted,
        servings,
        lastAccessedAt,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'external_recipe_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<ExternalRecipeTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('url')) {
      context.handle(
          _urlMeta, url.isAcceptableOrUnknown(data['url']!, _urlMeta));
    } else if (isInserting) {
      context.missing(_urlMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('image_url')) {
      context.handle(_imageUrlMeta,
          imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta));
    }
    if (data.containsKey('site_name')) {
      context.handle(_siteNameMeta,
          siteName.isAcceptableOrUnknown(data['site_name']!, _siteNameMeta));
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
          _isFavoriteMeta,
          isFavorite.isAcceptableOrUnknown(
              data['is_favorite']!, _isFavoriteMeta));
    }
    if (data.containsKey('tags')) {
      context.handle(
          _tagsMeta, tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta));
    }
    if (data.containsKey('memo')) {
      context.handle(
          _memoMeta, memo.isAcceptableOrUnknown(data['memo']!, _memoMeta));
    }
    if (data.containsKey('ingredients_json')) {
      context.handle(
          _ingredientsJsonMeta,
          ingredientsJson.isAcceptableOrUnknown(
              data['ingredients_json']!, _ingredientsJsonMeta));
    }
    if (data.containsKey('ingredients_raw_text')) {
      context.handle(
          _ingredientsRawTextMeta,
          ingredientsRawText.isAcceptableOrUnknown(
              data['ingredients_raw_text']!, _ingredientsRawTextMeta));
    }
    if (data.containsKey('calories')) {
      context.handle(_caloriesMeta,
          calories.isAcceptableOrUnknown(data['calories']!, _caloriesMeta));
    }
    if (data.containsKey('protein')) {
      context.handle(_proteinMeta,
          protein.isAcceptableOrUnknown(data['protein']!, _proteinMeta));
    }
    if (data.containsKey('fat')) {
      context.handle(
          _fatMeta, fat.isAcceptableOrUnknown(data['fat']!, _fatMeta));
    }
    if (data.containsKey('carbohydrate')) {
      context.handle(
          _carbohydrateMeta,
          carbohydrate.isAcceptableOrUnknown(
              data['carbohydrate']!, _carbohydrateMeta));
    }
    if (data.containsKey('salt')) {
      context.handle(
          _saltMeta, salt.isAcceptableOrUnknown(data['salt']!, _saltMeta));
    }
    if (data.containsKey('fiber')) {
      context.handle(
          _fiberMeta, fiber.isAcceptableOrUnknown(data['fiber']!, _fiberMeta));
    }
    if (data.containsKey('vitamin_c')) {
      context.handle(_vitaminCMeta,
          vitaminC.isAcceptableOrUnknown(data['vitamin_c']!, _vitaminCMeta));
    }
    if (data.containsKey('is_nutrition_auto_extracted')) {
      context.handle(
          _isNutritionAutoExtractedMeta,
          isNutritionAutoExtracted.isAcceptableOrUnknown(
              data['is_nutrition_auto_extracted']!,
              _isNutritionAutoExtractedMeta));
    }
    if (data.containsKey('servings')) {
      context.handle(_servingsMeta,
          servings.isAcceptableOrUnknown(data['servings']!, _servingsMeta));
    }
    if (data.containsKey('last_accessed_at')) {
      context.handle(
          _lastAccessedAtMeta,
          lastAccessedAt.isAcceptableOrUnknown(
              data['last_accessed_at']!, _lastAccessedAtMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExternalRecipeTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExternalRecipeTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      url: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}url'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      imageUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_url']),
      siteName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}site_name']),
      isFavorite: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_favorite'])!,
      tags: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tags']),
      memo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}memo']),
      ingredientsJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}ingredients_json']),
      ingredientsRawText: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}ingredients_raw_text']),
      calories: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}calories']),
      protein: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}protein']),
      fat: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}fat']),
      carbohydrate: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}carbohydrate']),
      salt: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}salt']),
      fiber: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}fiber']),
      vitaminC: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}vitamin_c']),
      isNutritionAutoExtracted: attachedDatabase.typeMapping.read(
          DriftSqlType.bool,
          data['${effectivePrefix}is_nutrition_auto_extracted'])!,
      servings: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}servings'])!,
      lastAccessedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_accessed_at']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $ExternalRecipeTableTable createAlias(String alias) {
    return $ExternalRecipeTableTable(attachedDatabase, alias);
  }
}

class ExternalRecipeTableData extends DataClass
    implements Insertable<ExternalRecipeTableData> {
  /// 主キー
  final int id;

  /// レシピURL
  final String url;

  /// タイトル（OGPから取得）
  final String title;

  /// 説明（OGPから取得）
  final String? description;

  /// 画像URL（OGPから取得）
  final String? imageUrl;

  /// サイト名（OGPから取得）
  final String? siteName;

  /// お気に入りフラグ
  final bool isFavorite;

  /// タグ（カンマ区切り）
  final String? tags;

  /// メモ
  final String? memo;

  /// 材料情報（JSON形式）
  final String? ingredientsJson;

  /// 抽出された材料の生テキスト
  final String? ingredientsRawText;

  /// 栄養情報（カロリー/1人前）
  final double? calories;

  /// タンパク質（g/1人前）
  final double? protein;

  /// 脂質（g/1人前）
  final double? fat;

  /// 炭水化物（g/1人前）
  final double? carbohydrate;

  /// 食塩相当量（g/1人前）
  final double? salt;

  /// 食物繊維（g/1人前）
  final double? fiber;

  /// ビタミンC（mg/1人前）
  final double? vitaminC;

  /// 材料・栄養情報が自動推測されたかのフラグ
  final bool isNutritionAutoExtracted;

  /// 人数（栄養計算の基準）
  final int servings;

  /// 最終アクセス日時
  final DateTime? lastAccessedAt;

  /// 作成日時
  final DateTime createdAt;

  /// 更新日時
  final DateTime updatedAt;
  const ExternalRecipeTableData(
      {required this.id,
      required this.url,
      required this.title,
      this.description,
      this.imageUrl,
      this.siteName,
      required this.isFavorite,
      this.tags,
      this.memo,
      this.ingredientsJson,
      this.ingredientsRawText,
      this.calories,
      this.protein,
      this.fat,
      this.carbohydrate,
      this.salt,
      this.fiber,
      this.vitaminC,
      required this.isNutritionAutoExtracted,
      required this.servings,
      this.lastAccessedAt,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['url'] = Variable<String>(url);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    if (!nullToAbsent || siteName != null) {
      map['site_name'] = Variable<String>(siteName);
    }
    map['is_favorite'] = Variable<bool>(isFavorite);
    if (!nullToAbsent || tags != null) {
      map['tags'] = Variable<String>(tags);
    }
    if (!nullToAbsent || memo != null) {
      map['memo'] = Variable<String>(memo);
    }
    if (!nullToAbsent || ingredientsJson != null) {
      map['ingredients_json'] = Variable<String>(ingredientsJson);
    }
    if (!nullToAbsent || ingredientsRawText != null) {
      map['ingredients_raw_text'] = Variable<String>(ingredientsRawText);
    }
    if (!nullToAbsent || calories != null) {
      map['calories'] = Variable<double>(calories);
    }
    if (!nullToAbsent || protein != null) {
      map['protein'] = Variable<double>(protein);
    }
    if (!nullToAbsent || fat != null) {
      map['fat'] = Variable<double>(fat);
    }
    if (!nullToAbsent || carbohydrate != null) {
      map['carbohydrate'] = Variable<double>(carbohydrate);
    }
    if (!nullToAbsent || salt != null) {
      map['salt'] = Variable<double>(salt);
    }
    if (!nullToAbsent || fiber != null) {
      map['fiber'] = Variable<double>(fiber);
    }
    if (!nullToAbsent || vitaminC != null) {
      map['vitamin_c'] = Variable<double>(vitaminC);
    }
    map['is_nutrition_auto_extracted'] =
        Variable<bool>(isNutritionAutoExtracted);
    map['servings'] = Variable<int>(servings);
    if (!nullToAbsent || lastAccessedAt != null) {
      map['last_accessed_at'] = Variable<DateTime>(lastAccessedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ExternalRecipeTableCompanion toCompanion(bool nullToAbsent) {
    return ExternalRecipeTableCompanion(
      id: Value(id),
      url: Value(url),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      siteName: siteName == null && nullToAbsent
          ? const Value.absent()
          : Value(siteName),
      isFavorite: Value(isFavorite),
      tags: tags == null && nullToAbsent ? const Value.absent() : Value(tags),
      memo: memo == null && nullToAbsent ? const Value.absent() : Value(memo),
      ingredientsJson: ingredientsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(ingredientsJson),
      ingredientsRawText: ingredientsRawText == null && nullToAbsent
          ? const Value.absent()
          : Value(ingredientsRawText),
      calories: calories == null && nullToAbsent
          ? const Value.absent()
          : Value(calories),
      protein: protein == null && nullToAbsent
          ? const Value.absent()
          : Value(protein),
      fat: fat == null && nullToAbsent ? const Value.absent() : Value(fat),
      carbohydrate: carbohydrate == null && nullToAbsent
          ? const Value.absent()
          : Value(carbohydrate),
      salt: salt == null && nullToAbsent ? const Value.absent() : Value(salt),
      fiber:
          fiber == null && nullToAbsent ? const Value.absent() : Value(fiber),
      vitaminC: vitaminC == null && nullToAbsent
          ? const Value.absent()
          : Value(vitaminC),
      isNutritionAutoExtracted: Value(isNutritionAutoExtracted),
      servings: Value(servings),
      lastAccessedAt: lastAccessedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastAccessedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ExternalRecipeTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExternalRecipeTableData(
      id: serializer.fromJson<int>(json['id']),
      url: serializer.fromJson<String>(json['url']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      siteName: serializer.fromJson<String?>(json['siteName']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      tags: serializer.fromJson<String?>(json['tags']),
      memo: serializer.fromJson<String?>(json['memo']),
      ingredientsJson: serializer.fromJson<String?>(json['ingredientsJson']),
      ingredientsRawText:
          serializer.fromJson<String?>(json['ingredientsRawText']),
      calories: serializer.fromJson<double?>(json['calories']),
      protein: serializer.fromJson<double?>(json['protein']),
      fat: serializer.fromJson<double?>(json['fat']),
      carbohydrate: serializer.fromJson<double?>(json['carbohydrate']),
      salt: serializer.fromJson<double?>(json['salt']),
      fiber: serializer.fromJson<double?>(json['fiber']),
      vitaminC: serializer.fromJson<double?>(json['vitaminC']),
      isNutritionAutoExtracted:
          serializer.fromJson<bool>(json['isNutritionAutoExtracted']),
      servings: serializer.fromJson<int>(json['servings']),
      lastAccessedAt: serializer.fromJson<DateTime?>(json['lastAccessedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'url': serializer.toJson<String>(url),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'siteName': serializer.toJson<String?>(siteName),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'tags': serializer.toJson<String?>(tags),
      'memo': serializer.toJson<String?>(memo),
      'ingredientsJson': serializer.toJson<String?>(ingredientsJson),
      'ingredientsRawText': serializer.toJson<String?>(ingredientsRawText),
      'calories': serializer.toJson<double?>(calories),
      'protein': serializer.toJson<double?>(protein),
      'fat': serializer.toJson<double?>(fat),
      'carbohydrate': serializer.toJson<double?>(carbohydrate),
      'salt': serializer.toJson<double?>(salt),
      'fiber': serializer.toJson<double?>(fiber),
      'vitaminC': serializer.toJson<double?>(vitaminC),
      'isNutritionAutoExtracted':
          serializer.toJson<bool>(isNutritionAutoExtracted),
      'servings': serializer.toJson<int>(servings),
      'lastAccessedAt': serializer.toJson<DateTime?>(lastAccessedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ExternalRecipeTableData copyWith(
          {int? id,
          String? url,
          String? title,
          Value<String?> description = const Value.absent(),
          Value<String?> imageUrl = const Value.absent(),
          Value<String?> siteName = const Value.absent(),
          bool? isFavorite,
          Value<String?> tags = const Value.absent(),
          Value<String?> memo = const Value.absent(),
          Value<String?> ingredientsJson = const Value.absent(),
          Value<String?> ingredientsRawText = const Value.absent(),
          Value<double?> calories = const Value.absent(),
          Value<double?> protein = const Value.absent(),
          Value<double?> fat = const Value.absent(),
          Value<double?> carbohydrate = const Value.absent(),
          Value<double?> salt = const Value.absent(),
          Value<double?> fiber = const Value.absent(),
          Value<double?> vitaminC = const Value.absent(),
          bool? isNutritionAutoExtracted,
          int? servings,
          Value<DateTime?> lastAccessedAt = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      ExternalRecipeTableData(
        id: id ?? this.id,
        url: url ?? this.url,
        title: title ?? this.title,
        description: description.present ? description.value : this.description,
        imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
        siteName: siteName.present ? siteName.value : this.siteName,
        isFavorite: isFavorite ?? this.isFavorite,
        tags: tags.present ? tags.value : this.tags,
        memo: memo.present ? memo.value : this.memo,
        ingredientsJson: ingredientsJson.present
            ? ingredientsJson.value
            : this.ingredientsJson,
        ingredientsRawText: ingredientsRawText.present
            ? ingredientsRawText.value
            : this.ingredientsRawText,
        calories: calories.present ? calories.value : this.calories,
        protein: protein.present ? protein.value : this.protein,
        fat: fat.present ? fat.value : this.fat,
        carbohydrate:
            carbohydrate.present ? carbohydrate.value : this.carbohydrate,
        salt: salt.present ? salt.value : this.salt,
        fiber: fiber.present ? fiber.value : this.fiber,
        vitaminC: vitaminC.present ? vitaminC.value : this.vitaminC,
        isNutritionAutoExtracted:
            isNutritionAutoExtracted ?? this.isNutritionAutoExtracted,
        servings: servings ?? this.servings,
        lastAccessedAt:
            lastAccessedAt.present ? lastAccessedAt.value : this.lastAccessedAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  ExternalRecipeTableData copyWithCompanion(ExternalRecipeTableCompanion data) {
    return ExternalRecipeTableData(
      id: data.id.present ? data.id.value : this.id,
      url: data.url.present ? data.url.value : this.url,
      title: data.title.present ? data.title.value : this.title,
      description:
          data.description.present ? data.description.value : this.description,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      siteName: data.siteName.present ? data.siteName.value : this.siteName,
      isFavorite:
          data.isFavorite.present ? data.isFavorite.value : this.isFavorite,
      tags: data.tags.present ? data.tags.value : this.tags,
      memo: data.memo.present ? data.memo.value : this.memo,
      ingredientsJson: data.ingredientsJson.present
          ? data.ingredientsJson.value
          : this.ingredientsJson,
      ingredientsRawText: data.ingredientsRawText.present
          ? data.ingredientsRawText.value
          : this.ingredientsRawText,
      calories: data.calories.present ? data.calories.value : this.calories,
      protein: data.protein.present ? data.protein.value : this.protein,
      fat: data.fat.present ? data.fat.value : this.fat,
      carbohydrate: data.carbohydrate.present
          ? data.carbohydrate.value
          : this.carbohydrate,
      salt: data.salt.present ? data.salt.value : this.salt,
      fiber: data.fiber.present ? data.fiber.value : this.fiber,
      vitaminC: data.vitaminC.present ? data.vitaminC.value : this.vitaminC,
      isNutritionAutoExtracted: data.isNutritionAutoExtracted.present
          ? data.isNutritionAutoExtracted.value
          : this.isNutritionAutoExtracted,
      servings: data.servings.present ? data.servings.value : this.servings,
      lastAccessedAt: data.lastAccessedAt.present
          ? data.lastAccessedAt.value
          : this.lastAccessedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExternalRecipeTableData(')
          ..write('id: $id, ')
          ..write('url: $url, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('siteName: $siteName, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('tags: $tags, ')
          ..write('memo: $memo, ')
          ..write('ingredientsJson: $ingredientsJson, ')
          ..write('ingredientsRawText: $ingredientsRawText, ')
          ..write('calories: $calories, ')
          ..write('protein: $protein, ')
          ..write('fat: $fat, ')
          ..write('carbohydrate: $carbohydrate, ')
          ..write('salt: $salt, ')
          ..write('fiber: $fiber, ')
          ..write('vitaminC: $vitaminC, ')
          ..write('isNutritionAutoExtracted: $isNutritionAutoExtracted, ')
          ..write('servings: $servings, ')
          ..write('lastAccessedAt: $lastAccessedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        url,
        title,
        description,
        imageUrl,
        siteName,
        isFavorite,
        tags,
        memo,
        ingredientsJson,
        ingredientsRawText,
        calories,
        protein,
        fat,
        carbohydrate,
        salt,
        fiber,
        vitaminC,
        isNutritionAutoExtracted,
        servings,
        lastAccessedAt,
        createdAt,
        updatedAt
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExternalRecipeTableData &&
          other.id == this.id &&
          other.url == this.url &&
          other.title == this.title &&
          other.description == this.description &&
          other.imageUrl == this.imageUrl &&
          other.siteName == this.siteName &&
          other.isFavorite == this.isFavorite &&
          other.tags == this.tags &&
          other.memo == this.memo &&
          other.ingredientsJson == this.ingredientsJson &&
          other.ingredientsRawText == this.ingredientsRawText &&
          other.calories == this.calories &&
          other.protein == this.protein &&
          other.fat == this.fat &&
          other.carbohydrate == this.carbohydrate &&
          other.salt == this.salt &&
          other.fiber == this.fiber &&
          other.vitaminC == this.vitaminC &&
          other.isNutritionAutoExtracted == this.isNutritionAutoExtracted &&
          other.servings == this.servings &&
          other.lastAccessedAt == this.lastAccessedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ExternalRecipeTableCompanion
    extends UpdateCompanion<ExternalRecipeTableData> {
  final Value<int> id;
  final Value<String> url;
  final Value<String> title;
  final Value<String?> description;
  final Value<String?> imageUrl;
  final Value<String?> siteName;
  final Value<bool> isFavorite;
  final Value<String?> tags;
  final Value<String?> memo;
  final Value<String?> ingredientsJson;
  final Value<String?> ingredientsRawText;
  final Value<double?> calories;
  final Value<double?> protein;
  final Value<double?> fat;
  final Value<double?> carbohydrate;
  final Value<double?> salt;
  final Value<double?> fiber;
  final Value<double?> vitaminC;
  final Value<bool> isNutritionAutoExtracted;
  final Value<int> servings;
  final Value<DateTime?> lastAccessedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const ExternalRecipeTableCompanion({
    this.id = const Value.absent(),
    this.url = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.siteName = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.tags = const Value.absent(),
    this.memo = const Value.absent(),
    this.ingredientsJson = const Value.absent(),
    this.ingredientsRawText = const Value.absent(),
    this.calories = const Value.absent(),
    this.protein = const Value.absent(),
    this.fat = const Value.absent(),
    this.carbohydrate = const Value.absent(),
    this.salt = const Value.absent(),
    this.fiber = const Value.absent(),
    this.vitaminC = const Value.absent(),
    this.isNutritionAutoExtracted = const Value.absent(),
    this.servings = const Value.absent(),
    this.lastAccessedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ExternalRecipeTableCompanion.insert({
    this.id = const Value.absent(),
    required String url,
    required String title,
    this.description = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.siteName = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.tags = const Value.absent(),
    this.memo = const Value.absent(),
    this.ingredientsJson = const Value.absent(),
    this.ingredientsRawText = const Value.absent(),
    this.calories = const Value.absent(),
    this.protein = const Value.absent(),
    this.fat = const Value.absent(),
    this.carbohydrate = const Value.absent(),
    this.salt = const Value.absent(),
    this.fiber = const Value.absent(),
    this.vitaminC = const Value.absent(),
    this.isNutritionAutoExtracted = const Value.absent(),
    this.servings = const Value.absent(),
    this.lastAccessedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : url = Value(url),
        title = Value(title);
  static Insertable<ExternalRecipeTableData> custom({
    Expression<int>? id,
    Expression<String>? url,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? imageUrl,
    Expression<String>? siteName,
    Expression<bool>? isFavorite,
    Expression<String>? tags,
    Expression<String>? memo,
    Expression<String>? ingredientsJson,
    Expression<String>? ingredientsRawText,
    Expression<double>? calories,
    Expression<double>? protein,
    Expression<double>? fat,
    Expression<double>? carbohydrate,
    Expression<double>? salt,
    Expression<double>? fiber,
    Expression<double>? vitaminC,
    Expression<bool>? isNutritionAutoExtracted,
    Expression<int>? servings,
    Expression<DateTime>? lastAccessedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (url != null) 'url': url,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (imageUrl != null) 'image_url': imageUrl,
      if (siteName != null) 'site_name': siteName,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (tags != null) 'tags': tags,
      if (memo != null) 'memo': memo,
      if (ingredientsJson != null) 'ingredients_json': ingredientsJson,
      if (ingredientsRawText != null)
        'ingredients_raw_text': ingredientsRawText,
      if (calories != null) 'calories': calories,
      if (protein != null) 'protein': protein,
      if (fat != null) 'fat': fat,
      if (carbohydrate != null) 'carbohydrate': carbohydrate,
      if (salt != null) 'salt': salt,
      if (fiber != null) 'fiber': fiber,
      if (vitaminC != null) 'vitamin_c': vitaminC,
      if (isNutritionAutoExtracted != null)
        'is_nutrition_auto_extracted': isNutritionAutoExtracted,
      if (servings != null) 'servings': servings,
      if (lastAccessedAt != null) 'last_accessed_at': lastAccessedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ExternalRecipeTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? url,
      Value<String>? title,
      Value<String?>? description,
      Value<String?>? imageUrl,
      Value<String?>? siteName,
      Value<bool>? isFavorite,
      Value<String?>? tags,
      Value<String?>? memo,
      Value<String?>? ingredientsJson,
      Value<String?>? ingredientsRawText,
      Value<double?>? calories,
      Value<double?>? protein,
      Value<double?>? fat,
      Value<double?>? carbohydrate,
      Value<double?>? salt,
      Value<double?>? fiber,
      Value<double?>? vitaminC,
      Value<bool>? isNutritionAutoExtracted,
      Value<int>? servings,
      Value<DateTime?>? lastAccessedAt,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return ExternalRecipeTableCompanion(
      id: id ?? this.id,
      url: url ?? this.url,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      siteName: siteName ?? this.siteName,
      isFavorite: isFavorite ?? this.isFavorite,
      tags: tags ?? this.tags,
      memo: memo ?? this.memo,
      ingredientsJson: ingredientsJson ?? this.ingredientsJson,
      ingredientsRawText: ingredientsRawText ?? this.ingredientsRawText,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      fat: fat ?? this.fat,
      carbohydrate: carbohydrate ?? this.carbohydrate,
      salt: salt ?? this.salt,
      fiber: fiber ?? this.fiber,
      vitaminC: vitaminC ?? this.vitaminC,
      isNutritionAutoExtracted:
          isNutritionAutoExtracted ?? this.isNutritionAutoExtracted,
      servings: servings ?? this.servings,
      lastAccessedAt: lastAccessedAt ?? this.lastAccessedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (siteName.present) {
      map['site_name'] = Variable<String>(siteName.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (memo.present) {
      map['memo'] = Variable<String>(memo.value);
    }
    if (ingredientsJson.present) {
      map['ingredients_json'] = Variable<String>(ingredientsJson.value);
    }
    if (ingredientsRawText.present) {
      map['ingredients_raw_text'] = Variable<String>(ingredientsRawText.value);
    }
    if (calories.present) {
      map['calories'] = Variable<double>(calories.value);
    }
    if (protein.present) {
      map['protein'] = Variable<double>(protein.value);
    }
    if (fat.present) {
      map['fat'] = Variable<double>(fat.value);
    }
    if (carbohydrate.present) {
      map['carbohydrate'] = Variable<double>(carbohydrate.value);
    }
    if (salt.present) {
      map['salt'] = Variable<double>(salt.value);
    }
    if (fiber.present) {
      map['fiber'] = Variable<double>(fiber.value);
    }
    if (vitaminC.present) {
      map['vitamin_c'] = Variable<double>(vitaminC.value);
    }
    if (isNutritionAutoExtracted.present) {
      map['is_nutrition_auto_extracted'] =
          Variable<bool>(isNutritionAutoExtracted.value);
    }
    if (servings.present) {
      map['servings'] = Variable<int>(servings.value);
    }
    if (lastAccessedAt.present) {
      map['last_accessed_at'] = Variable<DateTime>(lastAccessedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExternalRecipeTableCompanion(')
          ..write('id: $id, ')
          ..write('url: $url, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('siteName: $siteName, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('tags: $tags, ')
          ..write('memo: $memo, ')
          ..write('ingredientsJson: $ingredientsJson, ')
          ..write('ingredientsRawText: $ingredientsRawText, ')
          ..write('calories: $calories, ')
          ..write('protein: $protein, ')
          ..write('fat: $fat, ')
          ..write('carbohydrate: $carbohydrate, ')
          ..write('salt: $salt, ')
          ..write('fiber: $fiber, ')
          ..write('vitaminC: $vitaminC, ')
          ..write('isNutritionAutoExtracted: $isNutritionAutoExtracted, ')
          ..write('servings: $servings, ')
          ..write('lastAccessedAt: $lastAccessedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $MealItemTableTable extends MealItemTable
    with TableInfo<$MealItemTableTable, MealItemTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MealItemTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _mealIdMeta = const VerificationMeta('mealId');
  @override
  late final GeneratedColumn<int> mealId = GeneratedColumn<int>(
      'meal_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES meal_table (id) ON DELETE CASCADE'));
  static const VerificationMeta _foodNameMeta =
      const VerificationMeta('foodName');
  @override
  late final GeneratedColumn<String> foodName = GeneratedColumn<String>(
      'food_name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
      'quantity', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(1.0));
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 20),
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('g'));
  static const VerificationMeta _caloriesMeta =
      const VerificationMeta('calories');
  @override
  late final GeneratedColumn<double> calories = GeneratedColumn<double>(
      'calories', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _proteinMeta =
      const VerificationMeta('protein');
  @override
  late final GeneratedColumn<double> protein = GeneratedColumn<double>(
      'protein', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _fatMeta = const VerificationMeta('fat');
  @override
  late final GeneratedColumn<double> fat = GeneratedColumn<double>(
      'fat', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _carbsMeta = const VerificationMeta('carbs');
  @override
  late final GeneratedColumn<double> carbs = GeneratedColumn<double>(
      'carbs', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _externalRecipeIdMeta =
      const VerificationMeta('externalRecipeId');
  @override
  late final GeneratedColumn<int> externalRecipeId = GeneratedColumn<int>(
      'external_recipe_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES external_recipe_table (id) ON DELETE SET NULL'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        mealId,
        foodName,
        quantity,
        unit,
        calories,
        protein,
        fat,
        carbs,
        externalRecipeId,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meal_item_table';
  @override
  VerificationContext validateIntegrity(Insertable<MealItemTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('meal_id')) {
      context.handle(_mealIdMeta,
          mealId.isAcceptableOrUnknown(data['meal_id']!, _mealIdMeta));
    } else if (isInserting) {
      context.missing(_mealIdMeta);
    }
    if (data.containsKey('food_name')) {
      context.handle(_foodNameMeta,
          foodName.isAcceptableOrUnknown(data['food_name']!, _foodNameMeta));
    } else if (isInserting) {
      context.missing(_foodNameMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    }
    if (data.containsKey('calories')) {
      context.handle(_caloriesMeta,
          calories.isAcceptableOrUnknown(data['calories']!, _caloriesMeta));
    }
    if (data.containsKey('protein')) {
      context.handle(_proteinMeta,
          protein.isAcceptableOrUnknown(data['protein']!, _proteinMeta));
    }
    if (data.containsKey('fat')) {
      context.handle(
          _fatMeta, fat.isAcceptableOrUnknown(data['fat']!, _fatMeta));
    }
    if (data.containsKey('carbs')) {
      context.handle(
          _carbsMeta, carbs.isAcceptableOrUnknown(data['carbs']!, _carbsMeta));
    }
    if (data.containsKey('external_recipe_id')) {
      context.handle(
          _externalRecipeIdMeta,
          externalRecipeId.isAcceptableOrUnknown(
              data['external_recipe_id']!, _externalRecipeIdMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MealItemTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MealItemTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      mealId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}meal_id'])!,
      foodName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}food_name'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}quantity'])!,
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit'])!,
      calories: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}calories'])!,
      protein: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}protein'])!,
      fat: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}fat'])!,
      carbs: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}carbs'])!,
      externalRecipeId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}external_recipe_id']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $MealItemTableTable createAlias(String alias) {
    return $MealItemTableTable(attachedDatabase, alias);
  }
}

class MealItemTableData extends DataClass
    implements Insertable<MealItemTableData> {
  /// 主キー
  final int id;

  /// 食事ID（外部キー）
  final int mealId;

  /// 食品名
  final String foodName;

  /// 量
  final double quantity;

  /// 単位（g, ml, 個など）
  final String unit;

  /// カロリー（kcal）
  final double calories;

  /// タンパク質（g）
  final double protein;

  /// 脂質（g）
  final double fat;

  /// 炭水化物（g）
  final double carbs;

  /// 外部レシピID（任意）
  final int? externalRecipeId;

  /// 作成日時
  final DateTime createdAt;

  /// 更新日時
  final DateTime updatedAt;
  const MealItemTableData(
      {required this.id,
      required this.mealId,
      required this.foodName,
      required this.quantity,
      required this.unit,
      required this.calories,
      required this.protein,
      required this.fat,
      required this.carbs,
      this.externalRecipeId,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['meal_id'] = Variable<int>(mealId);
    map['food_name'] = Variable<String>(foodName);
    map['quantity'] = Variable<double>(quantity);
    map['unit'] = Variable<String>(unit);
    map['calories'] = Variable<double>(calories);
    map['protein'] = Variable<double>(protein);
    map['fat'] = Variable<double>(fat);
    map['carbs'] = Variable<double>(carbs);
    if (!nullToAbsent || externalRecipeId != null) {
      map['external_recipe_id'] = Variable<int>(externalRecipeId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  MealItemTableCompanion toCompanion(bool nullToAbsent) {
    return MealItemTableCompanion(
      id: Value(id),
      mealId: Value(mealId),
      foodName: Value(foodName),
      quantity: Value(quantity),
      unit: Value(unit),
      calories: Value(calories),
      protein: Value(protein),
      fat: Value(fat),
      carbs: Value(carbs),
      externalRecipeId: externalRecipeId == null && nullToAbsent
          ? const Value.absent()
          : Value(externalRecipeId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory MealItemTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MealItemTableData(
      id: serializer.fromJson<int>(json['id']),
      mealId: serializer.fromJson<int>(json['mealId']),
      foodName: serializer.fromJson<String>(json['foodName']),
      quantity: serializer.fromJson<double>(json['quantity']),
      unit: serializer.fromJson<String>(json['unit']),
      calories: serializer.fromJson<double>(json['calories']),
      protein: serializer.fromJson<double>(json['protein']),
      fat: serializer.fromJson<double>(json['fat']),
      carbs: serializer.fromJson<double>(json['carbs']),
      externalRecipeId: serializer.fromJson<int?>(json['externalRecipeId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'mealId': serializer.toJson<int>(mealId),
      'foodName': serializer.toJson<String>(foodName),
      'quantity': serializer.toJson<double>(quantity),
      'unit': serializer.toJson<String>(unit),
      'calories': serializer.toJson<double>(calories),
      'protein': serializer.toJson<double>(protein),
      'fat': serializer.toJson<double>(fat),
      'carbs': serializer.toJson<double>(carbs),
      'externalRecipeId': serializer.toJson<int?>(externalRecipeId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  MealItemTableData copyWith(
          {int? id,
          int? mealId,
          String? foodName,
          double? quantity,
          String? unit,
          double? calories,
          double? protein,
          double? fat,
          double? carbs,
          Value<int?> externalRecipeId = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      MealItemTableData(
        id: id ?? this.id,
        mealId: mealId ?? this.mealId,
        foodName: foodName ?? this.foodName,
        quantity: quantity ?? this.quantity,
        unit: unit ?? this.unit,
        calories: calories ?? this.calories,
        protein: protein ?? this.protein,
        fat: fat ?? this.fat,
        carbs: carbs ?? this.carbs,
        externalRecipeId: externalRecipeId.present
            ? externalRecipeId.value
            : this.externalRecipeId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  MealItemTableData copyWithCompanion(MealItemTableCompanion data) {
    return MealItemTableData(
      id: data.id.present ? data.id.value : this.id,
      mealId: data.mealId.present ? data.mealId.value : this.mealId,
      foodName: data.foodName.present ? data.foodName.value : this.foodName,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unit: data.unit.present ? data.unit.value : this.unit,
      calories: data.calories.present ? data.calories.value : this.calories,
      protein: data.protein.present ? data.protein.value : this.protein,
      fat: data.fat.present ? data.fat.value : this.fat,
      carbs: data.carbs.present ? data.carbs.value : this.carbs,
      externalRecipeId: data.externalRecipeId.present
          ? data.externalRecipeId.value
          : this.externalRecipeId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MealItemTableData(')
          ..write('id: $id, ')
          ..write('mealId: $mealId, ')
          ..write('foodName: $foodName, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('calories: $calories, ')
          ..write('protein: $protein, ')
          ..write('fat: $fat, ')
          ..write('carbs: $carbs, ')
          ..write('externalRecipeId: $externalRecipeId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, mealId, foodName, quantity, unit,
      calories, protein, fat, carbs, externalRecipeId, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MealItemTableData &&
          other.id == this.id &&
          other.mealId == this.mealId &&
          other.foodName == this.foodName &&
          other.quantity == this.quantity &&
          other.unit == this.unit &&
          other.calories == this.calories &&
          other.protein == this.protein &&
          other.fat == this.fat &&
          other.carbs == this.carbs &&
          other.externalRecipeId == this.externalRecipeId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class MealItemTableCompanion extends UpdateCompanion<MealItemTableData> {
  final Value<int> id;
  final Value<int> mealId;
  final Value<String> foodName;
  final Value<double> quantity;
  final Value<String> unit;
  final Value<double> calories;
  final Value<double> protein;
  final Value<double> fat;
  final Value<double> carbs;
  final Value<int?> externalRecipeId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const MealItemTableCompanion({
    this.id = const Value.absent(),
    this.mealId = const Value.absent(),
    this.foodName = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unit = const Value.absent(),
    this.calories = const Value.absent(),
    this.protein = const Value.absent(),
    this.fat = const Value.absent(),
    this.carbs = const Value.absent(),
    this.externalRecipeId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  MealItemTableCompanion.insert({
    this.id = const Value.absent(),
    required int mealId,
    required String foodName,
    this.quantity = const Value.absent(),
    this.unit = const Value.absent(),
    this.calories = const Value.absent(),
    this.protein = const Value.absent(),
    this.fat = const Value.absent(),
    this.carbs = const Value.absent(),
    this.externalRecipeId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : mealId = Value(mealId),
        foodName = Value(foodName);
  static Insertable<MealItemTableData> custom({
    Expression<int>? id,
    Expression<int>? mealId,
    Expression<String>? foodName,
    Expression<double>? quantity,
    Expression<String>? unit,
    Expression<double>? calories,
    Expression<double>? protein,
    Expression<double>? fat,
    Expression<double>? carbs,
    Expression<int>? externalRecipeId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (mealId != null) 'meal_id': mealId,
      if (foodName != null) 'food_name': foodName,
      if (quantity != null) 'quantity': quantity,
      if (unit != null) 'unit': unit,
      if (calories != null) 'calories': calories,
      if (protein != null) 'protein': protein,
      if (fat != null) 'fat': fat,
      if (carbs != null) 'carbs': carbs,
      if (externalRecipeId != null) 'external_recipe_id': externalRecipeId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  MealItemTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? mealId,
      Value<String>? foodName,
      Value<double>? quantity,
      Value<String>? unit,
      Value<double>? calories,
      Value<double>? protein,
      Value<double>? fat,
      Value<double>? carbs,
      Value<int?>? externalRecipeId,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return MealItemTableCompanion(
      id: id ?? this.id,
      mealId: mealId ?? this.mealId,
      foodName: foodName ?? this.foodName,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      fat: fat ?? this.fat,
      carbs: carbs ?? this.carbs,
      externalRecipeId: externalRecipeId ?? this.externalRecipeId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (mealId.present) {
      map['meal_id'] = Variable<int>(mealId.value);
    }
    if (foodName.present) {
      map['food_name'] = Variable<String>(foodName.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (calories.present) {
      map['calories'] = Variable<double>(calories.value);
    }
    if (protein.present) {
      map['protein'] = Variable<double>(protein.value);
    }
    if (fat.present) {
      map['fat'] = Variable<double>(fat.value);
    }
    if (carbs.present) {
      map['carbs'] = Variable<double>(carbs.value);
    }
    if (externalRecipeId.present) {
      map['external_recipe_id'] = Variable<int>(externalRecipeId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MealItemTableCompanion(')
          ..write('id: $id, ')
          ..write('mealId: $mealId, ')
          ..write('foodName: $foodName, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('calories: $calories, ')
          ..write('protein: $protein, ')
          ..write('fat: $fat, ')
          ..write('carbs: $carbs, ')
          ..write('externalRecipeId: $externalRecipeId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $PersonalDataTableTable extends PersonalDataTable
    with TableInfo<$PersonalDataTableTable, PersonalDataTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PersonalDataTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _recordedDateMeta =
      const VerificationMeta('recordedDate');
  @override
  late final GeneratedColumn<DateTime> recordedDate = GeneratedColumn<DateTime>(
      'recorded_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  @override
  late final GeneratedColumn<double> weight = GeneratedColumn<double>(
      'weight', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _bodyFatPercentageMeta =
      const VerificationMeta('bodyFatPercentage');
  @override
  late final GeneratedColumn<double> bodyFatPercentage =
      GeneratedColumn<double>('body_fat_percentage', aliasedName, true,
          type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _stepsMeta = const VerificationMeta('steps');
  @override
  late final GeneratedColumn<int> steps = GeneratedColumn<int>(
      'steps', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _activeEnergyMeta =
      const VerificationMeta('activeEnergy');
  @override
  late final GeneratedColumn<double> activeEnergy = GeneratedColumn<double>(
      'active_energy', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _exerciseTimeMeta =
      const VerificationMeta('exerciseTime');
  @override
  late final GeneratedColumn<int> exerciseTime = GeneratedColumn<int>(
      'exercise_time', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _sleepHoursMeta =
      const VerificationMeta('sleepHours');
  @override
  late final GeneratedColumn<double> sleepHours = GeneratedColumn<double>(
      'sleep_hours', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _dataSourceMeta =
      const VerificationMeta('dataSource');
  @override
  late final GeneratedColumn<String> dataSource = GeneratedColumn<String>(
      'data_source', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('manual'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        recordedDate,
        weight,
        bodyFatPercentage,
        steps,
        activeEnergy,
        exerciseTime,
        sleepHours,
        dataSource,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'personal_data_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<PersonalDataTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('recorded_date')) {
      context.handle(
          _recordedDateMeta,
          recordedDate.isAcceptableOrUnknown(
              data['recorded_date']!, _recordedDateMeta));
    } else if (isInserting) {
      context.missing(_recordedDateMeta);
    }
    if (data.containsKey('weight')) {
      context.handle(_weightMeta,
          weight.isAcceptableOrUnknown(data['weight']!, _weightMeta));
    }
    if (data.containsKey('body_fat_percentage')) {
      context.handle(
          _bodyFatPercentageMeta,
          bodyFatPercentage.isAcceptableOrUnknown(
              data['body_fat_percentage']!, _bodyFatPercentageMeta));
    }
    if (data.containsKey('steps')) {
      context.handle(
          _stepsMeta, steps.isAcceptableOrUnknown(data['steps']!, _stepsMeta));
    }
    if (data.containsKey('active_energy')) {
      context.handle(
          _activeEnergyMeta,
          activeEnergy.isAcceptableOrUnknown(
              data['active_energy']!, _activeEnergyMeta));
    }
    if (data.containsKey('exercise_time')) {
      context.handle(
          _exerciseTimeMeta,
          exerciseTime.isAcceptableOrUnknown(
              data['exercise_time']!, _exerciseTimeMeta));
    }
    if (data.containsKey('sleep_hours')) {
      context.handle(
          _sleepHoursMeta,
          sleepHours.isAcceptableOrUnknown(
              data['sleep_hours']!, _sleepHoursMeta));
    }
    if (data.containsKey('data_source')) {
      context.handle(
          _dataSourceMeta,
          dataSource.isAcceptableOrUnknown(
              data['data_source']!, _dataSourceMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {recordedDate};
  @override
  PersonalDataTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PersonalDataTableData(
      recordedDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}recorded_date'])!,
      weight: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}weight']),
      bodyFatPercentage: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}body_fat_percentage']),
      steps: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}steps']),
      activeEnergy: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}active_energy']),
      exerciseTime: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}exercise_time']),
      sleepHours: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}sleep_hours']),
      dataSource: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}data_source'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $PersonalDataTableTable createAlias(String alias) {
    return $PersonalDataTableTable(attachedDatabase, alias);
  }
}

class PersonalDataTableData extends DataClass
    implements Insertable<PersonalDataTableData> {
  /// 主キー（記録日をそのまま主キーとして使用）
  final DateTime recordedDate;

  /// 体重（kg）
  final double? weight;

  /// 体脂肪率（%）
  final double? bodyFatPercentage;

  /// 歩数
  final int? steps;

  /// 消費カロリー（kcal）
  final double? activeEnergy;

  /// 運動時間（分）
  final int? exerciseTime;

  /// 睡眠時間（時間）
  final double? sleepHours;

  /// データソース（manual, healthkit）
  final String dataSource;

  /// 作成日時
  final DateTime createdAt;

  /// 更新日時
  final DateTime updatedAt;
  const PersonalDataTableData(
      {required this.recordedDate,
      this.weight,
      this.bodyFatPercentage,
      this.steps,
      this.activeEnergy,
      this.exerciseTime,
      this.sleepHours,
      required this.dataSource,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['recorded_date'] = Variable<DateTime>(recordedDate);
    if (!nullToAbsent || weight != null) {
      map['weight'] = Variable<double>(weight);
    }
    if (!nullToAbsent || bodyFatPercentage != null) {
      map['body_fat_percentage'] = Variable<double>(bodyFatPercentage);
    }
    if (!nullToAbsent || steps != null) {
      map['steps'] = Variable<int>(steps);
    }
    if (!nullToAbsent || activeEnergy != null) {
      map['active_energy'] = Variable<double>(activeEnergy);
    }
    if (!nullToAbsent || exerciseTime != null) {
      map['exercise_time'] = Variable<int>(exerciseTime);
    }
    if (!nullToAbsent || sleepHours != null) {
      map['sleep_hours'] = Variable<double>(sleepHours);
    }
    map['data_source'] = Variable<String>(dataSource);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PersonalDataTableCompanion toCompanion(bool nullToAbsent) {
    return PersonalDataTableCompanion(
      recordedDate: Value(recordedDate),
      weight:
          weight == null && nullToAbsent ? const Value.absent() : Value(weight),
      bodyFatPercentage: bodyFatPercentage == null && nullToAbsent
          ? const Value.absent()
          : Value(bodyFatPercentage),
      steps:
          steps == null && nullToAbsent ? const Value.absent() : Value(steps),
      activeEnergy: activeEnergy == null && nullToAbsent
          ? const Value.absent()
          : Value(activeEnergy),
      exerciseTime: exerciseTime == null && nullToAbsent
          ? const Value.absent()
          : Value(exerciseTime),
      sleepHours: sleepHours == null && nullToAbsent
          ? const Value.absent()
          : Value(sleepHours),
      dataSource: Value(dataSource),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory PersonalDataTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PersonalDataTableData(
      recordedDate: serializer.fromJson<DateTime>(json['recordedDate']),
      weight: serializer.fromJson<double?>(json['weight']),
      bodyFatPercentage:
          serializer.fromJson<double?>(json['bodyFatPercentage']),
      steps: serializer.fromJson<int?>(json['steps']),
      activeEnergy: serializer.fromJson<double?>(json['activeEnergy']),
      exerciseTime: serializer.fromJson<int?>(json['exerciseTime']),
      sleepHours: serializer.fromJson<double?>(json['sleepHours']),
      dataSource: serializer.fromJson<String>(json['dataSource']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'recordedDate': serializer.toJson<DateTime>(recordedDate),
      'weight': serializer.toJson<double?>(weight),
      'bodyFatPercentage': serializer.toJson<double?>(bodyFatPercentage),
      'steps': serializer.toJson<int?>(steps),
      'activeEnergy': serializer.toJson<double?>(activeEnergy),
      'exerciseTime': serializer.toJson<int?>(exerciseTime),
      'sleepHours': serializer.toJson<double?>(sleepHours),
      'dataSource': serializer.toJson<String>(dataSource),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PersonalDataTableData copyWith(
          {DateTime? recordedDate,
          Value<double?> weight = const Value.absent(),
          Value<double?> bodyFatPercentage = const Value.absent(),
          Value<int?> steps = const Value.absent(),
          Value<double?> activeEnergy = const Value.absent(),
          Value<int?> exerciseTime = const Value.absent(),
          Value<double?> sleepHours = const Value.absent(),
          String? dataSource,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      PersonalDataTableData(
        recordedDate: recordedDate ?? this.recordedDate,
        weight: weight.present ? weight.value : this.weight,
        bodyFatPercentage: bodyFatPercentage.present
            ? bodyFatPercentage.value
            : this.bodyFatPercentage,
        steps: steps.present ? steps.value : this.steps,
        activeEnergy:
            activeEnergy.present ? activeEnergy.value : this.activeEnergy,
        exerciseTime:
            exerciseTime.present ? exerciseTime.value : this.exerciseTime,
        sleepHours: sleepHours.present ? sleepHours.value : this.sleepHours,
        dataSource: dataSource ?? this.dataSource,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  PersonalDataTableData copyWithCompanion(PersonalDataTableCompanion data) {
    return PersonalDataTableData(
      recordedDate: data.recordedDate.present
          ? data.recordedDate.value
          : this.recordedDate,
      weight: data.weight.present ? data.weight.value : this.weight,
      bodyFatPercentage: data.bodyFatPercentage.present
          ? data.bodyFatPercentage.value
          : this.bodyFatPercentage,
      steps: data.steps.present ? data.steps.value : this.steps,
      activeEnergy: data.activeEnergy.present
          ? data.activeEnergy.value
          : this.activeEnergy,
      exerciseTime: data.exerciseTime.present
          ? data.exerciseTime.value
          : this.exerciseTime,
      sleepHours:
          data.sleepHours.present ? data.sleepHours.value : this.sleepHours,
      dataSource:
          data.dataSource.present ? data.dataSource.value : this.dataSource,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PersonalDataTableData(')
          ..write('recordedDate: $recordedDate, ')
          ..write('weight: $weight, ')
          ..write('bodyFatPercentage: $bodyFatPercentage, ')
          ..write('steps: $steps, ')
          ..write('activeEnergy: $activeEnergy, ')
          ..write('exerciseTime: $exerciseTime, ')
          ..write('sleepHours: $sleepHours, ')
          ..write('dataSource: $dataSource, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      recordedDate,
      weight,
      bodyFatPercentage,
      steps,
      activeEnergy,
      exerciseTime,
      sleepHours,
      dataSource,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PersonalDataTableData &&
          other.recordedDate == this.recordedDate &&
          other.weight == this.weight &&
          other.bodyFatPercentage == this.bodyFatPercentage &&
          other.steps == this.steps &&
          other.activeEnergy == this.activeEnergy &&
          other.exerciseTime == this.exerciseTime &&
          other.sleepHours == this.sleepHours &&
          other.dataSource == this.dataSource &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PersonalDataTableCompanion
    extends UpdateCompanion<PersonalDataTableData> {
  final Value<DateTime> recordedDate;
  final Value<double?> weight;
  final Value<double?> bodyFatPercentage;
  final Value<int?> steps;
  final Value<double?> activeEnergy;
  final Value<int?> exerciseTime;
  final Value<double?> sleepHours;
  final Value<String> dataSource;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const PersonalDataTableCompanion({
    this.recordedDate = const Value.absent(),
    this.weight = const Value.absent(),
    this.bodyFatPercentage = const Value.absent(),
    this.steps = const Value.absent(),
    this.activeEnergy = const Value.absent(),
    this.exerciseTime = const Value.absent(),
    this.sleepHours = const Value.absent(),
    this.dataSource = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PersonalDataTableCompanion.insert({
    required DateTime recordedDate,
    this.weight = const Value.absent(),
    this.bodyFatPercentage = const Value.absent(),
    this.steps = const Value.absent(),
    this.activeEnergy = const Value.absent(),
    this.exerciseTime = const Value.absent(),
    this.sleepHours = const Value.absent(),
    this.dataSource = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : recordedDate = Value(recordedDate);
  static Insertable<PersonalDataTableData> custom({
    Expression<DateTime>? recordedDate,
    Expression<double>? weight,
    Expression<double>? bodyFatPercentage,
    Expression<int>? steps,
    Expression<double>? activeEnergy,
    Expression<int>? exerciseTime,
    Expression<double>? sleepHours,
    Expression<String>? dataSource,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (recordedDate != null) 'recorded_date': recordedDate,
      if (weight != null) 'weight': weight,
      if (bodyFatPercentage != null) 'body_fat_percentage': bodyFatPercentage,
      if (steps != null) 'steps': steps,
      if (activeEnergy != null) 'active_energy': activeEnergy,
      if (exerciseTime != null) 'exercise_time': exerciseTime,
      if (sleepHours != null) 'sleep_hours': sleepHours,
      if (dataSource != null) 'data_source': dataSource,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PersonalDataTableCompanion copyWith(
      {Value<DateTime>? recordedDate,
      Value<double?>? weight,
      Value<double?>? bodyFatPercentage,
      Value<int?>? steps,
      Value<double?>? activeEnergy,
      Value<int?>? exerciseTime,
      Value<double?>? sleepHours,
      Value<String>? dataSource,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return PersonalDataTableCompanion(
      recordedDate: recordedDate ?? this.recordedDate,
      weight: weight ?? this.weight,
      bodyFatPercentage: bodyFatPercentage ?? this.bodyFatPercentage,
      steps: steps ?? this.steps,
      activeEnergy: activeEnergy ?? this.activeEnergy,
      exerciseTime: exerciseTime ?? this.exerciseTime,
      sleepHours: sleepHours ?? this.sleepHours,
      dataSource: dataSource ?? this.dataSource,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (recordedDate.present) {
      map['recorded_date'] = Variable<DateTime>(recordedDate.value);
    }
    if (weight.present) {
      map['weight'] = Variable<double>(weight.value);
    }
    if (bodyFatPercentage.present) {
      map['body_fat_percentage'] = Variable<double>(bodyFatPercentage.value);
    }
    if (steps.present) {
      map['steps'] = Variable<int>(steps.value);
    }
    if (activeEnergy.present) {
      map['active_energy'] = Variable<double>(activeEnergy.value);
    }
    if (exerciseTime.present) {
      map['exercise_time'] = Variable<int>(exerciseTime.value);
    }
    if (sleepHours.present) {
      map['sleep_hours'] = Variable<double>(sleepHours.value);
    }
    if (dataSource.present) {
      map['data_source'] = Variable<String>(dataSource.value);
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
    return (StringBuffer('PersonalDataTableCompanion(')
          ..write('recordedDate: $recordedDate, ')
          ..write('weight: $weight, ')
          ..write('bodyFatPercentage: $bodyFatPercentage, ')
          ..write('steps: $steps, ')
          ..write('activeEnergy: $activeEnergy, ')
          ..write('exerciseTime: $exerciseTime, ')
          ..write('sleepHours: $sleepHours, ')
          ..write('dataSource: $dataSource, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FoodItemTableTable extends FoodItemTable
    with TableInfo<$FoodItemTableTable, FoodItemTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FoodItemTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
      'quantity', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(1.0));
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 20),
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('個'));
  static const VerificationMeta _purchaseDateMeta =
      const VerificationMeta('purchaseDate');
  @override
  late final GeneratedColumn<DateTime> purchaseDate = GeneratedColumn<DateTime>(
      'purchase_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _expiryDateMeta =
      const VerificationMeta('expiryDate');
  @override
  late final GeneratedColumn<DateTime> expiryDate = GeneratedColumn<DateTime>(
      'expiry_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _storageLocationMeta =
      const VerificationMeta('storageLocation');
  @override
  late final GeneratedColumn<String> storageLocation = GeneratedColumn<String>(
      'storage_location', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _memoMeta = const VerificationMeta('memo');
  @override
  late final GeneratedColumn<String> memo = GeneratedColumn<String>(
      'memo', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isOutOfStockMeta =
      const VerificationMeta('isOutOfStock');
  @override
  late final GeneratedColumn<bool> isOutOfStock = GeneratedColumn<bool>(
      'is_out_of_stock', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_out_of_stock" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        category,
        quantity,
        unit,
        purchaseDate,
        expiryDate,
        storageLocation,
        memo,
        isOutOfStock,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'food_item_table';
  @override
  VerificationContext validateIntegrity(Insertable<FoodItemTableData> instance,
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
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    }
    if (data.containsKey('purchase_date')) {
      context.handle(
          _purchaseDateMeta,
          purchaseDate.isAcceptableOrUnknown(
              data['purchase_date']!, _purchaseDateMeta));
    }
    if (data.containsKey('expiry_date')) {
      context.handle(
          _expiryDateMeta,
          expiryDate.isAcceptableOrUnknown(
              data['expiry_date']!, _expiryDateMeta));
    }
    if (data.containsKey('storage_location')) {
      context.handle(
          _storageLocationMeta,
          storageLocation.isAcceptableOrUnknown(
              data['storage_location']!, _storageLocationMeta));
    }
    if (data.containsKey('memo')) {
      context.handle(
          _memoMeta, memo.isAcceptableOrUnknown(data['memo']!, _memoMeta));
    }
    if (data.containsKey('is_out_of_stock')) {
      context.handle(
          _isOutOfStockMeta,
          isOutOfStock.isAcceptableOrUnknown(
              data['is_out_of_stock']!, _isOutOfStockMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FoodItemTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FoodItemTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}quantity'])!,
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit'])!,
      purchaseDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}purchase_date']),
      expiryDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}expiry_date']),
      storageLocation: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}storage_location']),
      memo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}memo']),
      isOutOfStock: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_out_of_stock'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $FoodItemTableTable createAlias(String alias) {
    return $FoodItemTableTable(attachedDatabase, alias);
  }
}

class FoodItemTableData extends DataClass
    implements Insertable<FoodItemTableData> {
  /// 主キー
  final int id;

  /// 食品名
  final String name;

  /// カテゴリー（野菜、肉、魚、調味料など）
  final String category;

  /// 数量
  final double quantity;

  /// 単位（g, ml, 個など）
  final String unit;

  /// 購入日
  final DateTime? purchaseDate;

  /// 賞味期限・消費期限
  final DateTime? expiryDate;

  /// 保管場所（冷蔵庫、冷凍庫、常温など）
  final String? storageLocation;

  /// メモ
  final String? memo;

  /// 在庫切れフラグ
  final bool isOutOfStock;

  /// 作成日時
  final DateTime createdAt;

  /// 更新日時
  final DateTime updatedAt;
  const FoodItemTableData(
      {required this.id,
      required this.name,
      required this.category,
      required this.quantity,
      required this.unit,
      this.purchaseDate,
      this.expiryDate,
      this.storageLocation,
      this.memo,
      required this.isOutOfStock,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['category'] = Variable<String>(category);
    map['quantity'] = Variable<double>(quantity);
    map['unit'] = Variable<String>(unit);
    if (!nullToAbsent || purchaseDate != null) {
      map['purchase_date'] = Variable<DateTime>(purchaseDate);
    }
    if (!nullToAbsent || expiryDate != null) {
      map['expiry_date'] = Variable<DateTime>(expiryDate);
    }
    if (!nullToAbsent || storageLocation != null) {
      map['storage_location'] = Variable<String>(storageLocation);
    }
    if (!nullToAbsent || memo != null) {
      map['memo'] = Variable<String>(memo);
    }
    map['is_out_of_stock'] = Variable<bool>(isOutOfStock);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  FoodItemTableCompanion toCompanion(bool nullToAbsent) {
    return FoodItemTableCompanion(
      id: Value(id),
      name: Value(name),
      category: Value(category),
      quantity: Value(quantity),
      unit: Value(unit),
      purchaseDate: purchaseDate == null && nullToAbsent
          ? const Value.absent()
          : Value(purchaseDate),
      expiryDate: expiryDate == null && nullToAbsent
          ? const Value.absent()
          : Value(expiryDate),
      storageLocation: storageLocation == null && nullToAbsent
          ? const Value.absent()
          : Value(storageLocation),
      memo: memo == null && nullToAbsent ? const Value.absent() : Value(memo),
      isOutOfStock: Value(isOutOfStock),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory FoodItemTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FoodItemTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      category: serializer.fromJson<String>(json['category']),
      quantity: serializer.fromJson<double>(json['quantity']),
      unit: serializer.fromJson<String>(json['unit']),
      purchaseDate: serializer.fromJson<DateTime?>(json['purchaseDate']),
      expiryDate: serializer.fromJson<DateTime?>(json['expiryDate']),
      storageLocation: serializer.fromJson<String?>(json['storageLocation']),
      memo: serializer.fromJson<String?>(json['memo']),
      isOutOfStock: serializer.fromJson<bool>(json['isOutOfStock']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'category': serializer.toJson<String>(category),
      'quantity': serializer.toJson<double>(quantity),
      'unit': serializer.toJson<String>(unit),
      'purchaseDate': serializer.toJson<DateTime?>(purchaseDate),
      'expiryDate': serializer.toJson<DateTime?>(expiryDate),
      'storageLocation': serializer.toJson<String?>(storageLocation),
      'memo': serializer.toJson<String?>(memo),
      'isOutOfStock': serializer.toJson<bool>(isOutOfStock),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  FoodItemTableData copyWith(
          {int? id,
          String? name,
          String? category,
          double? quantity,
          String? unit,
          Value<DateTime?> purchaseDate = const Value.absent(),
          Value<DateTime?> expiryDate = const Value.absent(),
          Value<String?> storageLocation = const Value.absent(),
          Value<String?> memo = const Value.absent(),
          bool? isOutOfStock,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      FoodItemTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        category: category ?? this.category,
        quantity: quantity ?? this.quantity,
        unit: unit ?? this.unit,
        purchaseDate:
            purchaseDate.present ? purchaseDate.value : this.purchaseDate,
        expiryDate: expiryDate.present ? expiryDate.value : this.expiryDate,
        storageLocation: storageLocation.present
            ? storageLocation.value
            : this.storageLocation,
        memo: memo.present ? memo.value : this.memo,
        isOutOfStock: isOutOfStock ?? this.isOutOfStock,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  FoodItemTableData copyWithCompanion(FoodItemTableCompanion data) {
    return FoodItemTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      category: data.category.present ? data.category.value : this.category,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unit: data.unit.present ? data.unit.value : this.unit,
      purchaseDate: data.purchaseDate.present
          ? data.purchaseDate.value
          : this.purchaseDate,
      expiryDate:
          data.expiryDate.present ? data.expiryDate.value : this.expiryDate,
      storageLocation: data.storageLocation.present
          ? data.storageLocation.value
          : this.storageLocation,
      memo: data.memo.present ? data.memo.value : this.memo,
      isOutOfStock: data.isOutOfStock.present
          ? data.isOutOfStock.value
          : this.isOutOfStock,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FoodItemTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('storageLocation: $storageLocation, ')
          ..write('memo: $memo, ')
          ..write('isOutOfStock: $isOutOfStock, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      category,
      quantity,
      unit,
      purchaseDate,
      expiryDate,
      storageLocation,
      memo,
      isOutOfStock,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FoodItemTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.category == this.category &&
          other.quantity == this.quantity &&
          other.unit == this.unit &&
          other.purchaseDate == this.purchaseDate &&
          other.expiryDate == this.expiryDate &&
          other.storageLocation == this.storageLocation &&
          other.memo == this.memo &&
          other.isOutOfStock == this.isOutOfStock &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class FoodItemTableCompanion extends UpdateCompanion<FoodItemTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> category;
  final Value<double> quantity;
  final Value<String> unit;
  final Value<DateTime?> purchaseDate;
  final Value<DateTime?> expiryDate;
  final Value<String?> storageLocation;
  final Value<String?> memo;
  final Value<bool> isOutOfStock;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const FoodItemTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.category = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unit = const Value.absent(),
    this.purchaseDate = const Value.absent(),
    this.expiryDate = const Value.absent(),
    this.storageLocation = const Value.absent(),
    this.memo = const Value.absent(),
    this.isOutOfStock = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  FoodItemTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String category,
    this.quantity = const Value.absent(),
    this.unit = const Value.absent(),
    this.purchaseDate = const Value.absent(),
    this.expiryDate = const Value.absent(),
    this.storageLocation = const Value.absent(),
    this.memo = const Value.absent(),
    this.isOutOfStock = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : name = Value(name),
        category = Value(category);
  static Insertable<FoodItemTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? category,
    Expression<double>? quantity,
    Expression<String>? unit,
    Expression<DateTime>? purchaseDate,
    Expression<DateTime>? expiryDate,
    Expression<String>? storageLocation,
    Expression<String>? memo,
    Expression<bool>? isOutOfStock,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      if (quantity != null) 'quantity': quantity,
      if (unit != null) 'unit': unit,
      if (purchaseDate != null) 'purchase_date': purchaseDate,
      if (expiryDate != null) 'expiry_date': expiryDate,
      if (storageLocation != null) 'storage_location': storageLocation,
      if (memo != null) 'memo': memo,
      if (isOutOfStock != null) 'is_out_of_stock': isOutOfStock,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  FoodItemTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? category,
      Value<double>? quantity,
      Value<String>? unit,
      Value<DateTime?>? purchaseDate,
      Value<DateTime?>? expiryDate,
      Value<String?>? storageLocation,
      Value<String?>? memo,
      Value<bool>? isOutOfStock,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return FoodItemTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      expiryDate: expiryDate ?? this.expiryDate,
      storageLocation: storageLocation ?? this.storageLocation,
      memo: memo ?? this.memo,
      isOutOfStock: isOutOfStock ?? this.isOutOfStock,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (purchaseDate.present) {
      map['purchase_date'] = Variable<DateTime>(purchaseDate.value);
    }
    if (expiryDate.present) {
      map['expiry_date'] = Variable<DateTime>(expiryDate.value);
    }
    if (storageLocation.present) {
      map['storage_location'] = Variable<String>(storageLocation.value);
    }
    if (memo.present) {
      map['memo'] = Variable<String>(memo.value);
    }
    if (isOutOfStock.present) {
      map['is_out_of_stock'] = Variable<bool>(isOutOfStock.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FoodItemTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('storageLocation: $storageLocation, ')
          ..write('memo: $memo, ')
          ..write('isOutOfStock: $isOutOfStock, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $RecipeTableTable extends RecipeTable
    with TableInfo<$RecipeTableTable, RecipeTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecipeTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 200),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _cookingTimeMeta =
      const VerificationMeta('cookingTime');
  @override
  late final GeneratedColumn<int> cookingTime = GeneratedColumn<int>(
      'cooking_time', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _servingsMeta =
      const VerificationMeta('servings');
  @override
  late final GeneratedColumn<int> servings = GeneratedColumn<int>(
      'servings', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _ingredientsMeta =
      const VerificationMeta('ingredients');
  @override
  late final GeneratedColumn<String> ingredients = GeneratedColumn<String>(
      'ingredients', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _instructionsMeta =
      const VerificationMeta('instructions');
  @override
  late final GeneratedColumn<String> instructions = GeneratedColumn<String>(
      'instructions', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _caloriesMeta =
      const VerificationMeta('calories');
  @override
  late final GeneratedColumn<double> calories = GeneratedColumn<double>(
      'calories', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _proteinMeta =
      const VerificationMeta('protein');
  @override
  late final GeneratedColumn<double> protein = GeneratedColumn<double>(
      'protein', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _fatMeta = const VerificationMeta('fat');
  @override
  late final GeneratedColumn<double> fat = GeneratedColumn<double>(
      'fat', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _carbsMeta = const VerificationMeta('carbs');
  @override
  late final GeneratedColumn<double> carbs = GeneratedColumn<double>(
      'carbs', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _imagePathMeta =
      const VerificationMeta('imagePath');
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
      'image_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isFavoriteMeta =
      const VerificationMeta('isFavorite');
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
      'is_favorite', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_favorite" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
      'tags', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        category,
        cookingTime,
        servings,
        ingredients,
        instructions,
        calories,
        protein,
        fat,
        carbs,
        imagePath,
        isFavorite,
        tags,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipe_table';
  @override
  VerificationContext validateIntegrity(Insertable<RecipeTableData> instance,
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
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('cooking_time')) {
      context.handle(
          _cookingTimeMeta,
          cookingTime.isAcceptableOrUnknown(
              data['cooking_time']!, _cookingTimeMeta));
    }
    if (data.containsKey('servings')) {
      context.handle(_servingsMeta,
          servings.isAcceptableOrUnknown(data['servings']!, _servingsMeta));
    }
    if (data.containsKey('ingredients')) {
      context.handle(
          _ingredientsMeta,
          ingredients.isAcceptableOrUnknown(
              data['ingredients']!, _ingredientsMeta));
    } else if (isInserting) {
      context.missing(_ingredientsMeta);
    }
    if (data.containsKey('instructions')) {
      context.handle(
          _instructionsMeta,
          instructions.isAcceptableOrUnknown(
              data['instructions']!, _instructionsMeta));
    } else if (isInserting) {
      context.missing(_instructionsMeta);
    }
    if (data.containsKey('calories')) {
      context.handle(_caloriesMeta,
          calories.isAcceptableOrUnknown(data['calories']!, _caloriesMeta));
    }
    if (data.containsKey('protein')) {
      context.handle(_proteinMeta,
          protein.isAcceptableOrUnknown(data['protein']!, _proteinMeta));
    }
    if (data.containsKey('fat')) {
      context.handle(
          _fatMeta, fat.isAcceptableOrUnknown(data['fat']!, _fatMeta));
    }
    if (data.containsKey('carbs')) {
      context.handle(
          _carbsMeta, carbs.isAcceptableOrUnknown(data['carbs']!, _carbsMeta));
    }
    if (data.containsKey('image_path')) {
      context.handle(_imagePathMeta,
          imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta));
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
          _isFavoriteMeta,
          isFavorite.isAcceptableOrUnknown(
              data['is_favorite']!, _isFavoriteMeta));
    }
    if (data.containsKey('tags')) {
      context.handle(
          _tagsMeta, tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecipeTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecipeTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      cookingTime: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}cooking_time']),
      servings: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}servings'])!,
      ingredients: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ingredients'])!,
      instructions: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}instructions'])!,
      calories: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}calories']),
      protein: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}protein']),
      fat: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}fat']),
      carbs: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}carbs']),
      imagePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_path']),
      isFavorite: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_favorite'])!,
      tags: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tags']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $RecipeTableTable createAlias(String alias) {
    return $RecipeTableTable(attachedDatabase, alias);
  }
}

class RecipeTableData extends DataClass implements Insertable<RecipeTableData> {
  /// 主キー
  final int id;

  /// レシピ名
  final String name;

  /// カテゴリー（和食、洋食、中華など）
  final String category;

  /// 調理時間（分）
  final int? cookingTime;

  /// サービング数
  final int servings;

  /// 材料（JSON形式）
  final String ingredients;

  /// 手順（JSON形式）
  final String instructions;

  /// カロリー（kcal/1人前）
  final double? calories;

  /// タンパク質（g/1人前）
  final double? protein;

  /// 脂質（g/1人前）
  final double? fat;

  /// 炭水化物（g/1人前）
  final double? carbs;

  /// 画像パス
  final String? imagePath;

  /// お気に入りフラグ
  final bool isFavorite;

  /// タグ（カンマ区切り）
  final String? tags;

  /// 作成日時
  final DateTime createdAt;

  /// 更新日時
  final DateTime updatedAt;
  const RecipeTableData(
      {required this.id,
      required this.name,
      required this.category,
      this.cookingTime,
      required this.servings,
      required this.ingredients,
      required this.instructions,
      this.calories,
      this.protein,
      this.fat,
      this.carbs,
      this.imagePath,
      required this.isFavorite,
      this.tags,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || cookingTime != null) {
      map['cooking_time'] = Variable<int>(cookingTime);
    }
    map['servings'] = Variable<int>(servings);
    map['ingredients'] = Variable<String>(ingredients);
    map['instructions'] = Variable<String>(instructions);
    if (!nullToAbsent || calories != null) {
      map['calories'] = Variable<double>(calories);
    }
    if (!nullToAbsent || protein != null) {
      map['protein'] = Variable<double>(protein);
    }
    if (!nullToAbsent || fat != null) {
      map['fat'] = Variable<double>(fat);
    }
    if (!nullToAbsent || carbs != null) {
      map['carbs'] = Variable<double>(carbs);
    }
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    map['is_favorite'] = Variable<bool>(isFavorite);
    if (!nullToAbsent || tags != null) {
      map['tags'] = Variable<String>(tags);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  RecipeTableCompanion toCompanion(bool nullToAbsent) {
    return RecipeTableCompanion(
      id: Value(id),
      name: Value(name),
      category: Value(category),
      cookingTime: cookingTime == null && nullToAbsent
          ? const Value.absent()
          : Value(cookingTime),
      servings: Value(servings),
      ingredients: Value(ingredients),
      instructions: Value(instructions),
      calories: calories == null && nullToAbsent
          ? const Value.absent()
          : Value(calories),
      protein: protein == null && nullToAbsent
          ? const Value.absent()
          : Value(protein),
      fat: fat == null && nullToAbsent ? const Value.absent() : Value(fat),
      carbs:
          carbs == null && nullToAbsent ? const Value.absent() : Value(carbs),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
      isFavorite: Value(isFavorite),
      tags: tags == null && nullToAbsent ? const Value.absent() : Value(tags),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory RecipeTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecipeTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      category: serializer.fromJson<String>(json['category']),
      cookingTime: serializer.fromJson<int?>(json['cookingTime']),
      servings: serializer.fromJson<int>(json['servings']),
      ingredients: serializer.fromJson<String>(json['ingredients']),
      instructions: serializer.fromJson<String>(json['instructions']),
      calories: serializer.fromJson<double?>(json['calories']),
      protein: serializer.fromJson<double?>(json['protein']),
      fat: serializer.fromJson<double?>(json['fat']),
      carbs: serializer.fromJson<double?>(json['carbs']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      tags: serializer.fromJson<String?>(json['tags']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'category': serializer.toJson<String>(category),
      'cookingTime': serializer.toJson<int?>(cookingTime),
      'servings': serializer.toJson<int>(servings),
      'ingredients': serializer.toJson<String>(ingredients),
      'instructions': serializer.toJson<String>(instructions),
      'calories': serializer.toJson<double?>(calories),
      'protein': serializer.toJson<double?>(protein),
      'fat': serializer.toJson<double?>(fat),
      'carbs': serializer.toJson<double?>(carbs),
      'imagePath': serializer.toJson<String?>(imagePath),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'tags': serializer.toJson<String?>(tags),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  RecipeTableData copyWith(
          {int? id,
          String? name,
          String? category,
          Value<int?> cookingTime = const Value.absent(),
          int? servings,
          String? ingredients,
          String? instructions,
          Value<double?> calories = const Value.absent(),
          Value<double?> protein = const Value.absent(),
          Value<double?> fat = const Value.absent(),
          Value<double?> carbs = const Value.absent(),
          Value<String?> imagePath = const Value.absent(),
          bool? isFavorite,
          Value<String?> tags = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      RecipeTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        category: category ?? this.category,
        cookingTime: cookingTime.present ? cookingTime.value : this.cookingTime,
        servings: servings ?? this.servings,
        ingredients: ingredients ?? this.ingredients,
        instructions: instructions ?? this.instructions,
        calories: calories.present ? calories.value : this.calories,
        protein: protein.present ? protein.value : this.protein,
        fat: fat.present ? fat.value : this.fat,
        carbs: carbs.present ? carbs.value : this.carbs,
        imagePath: imagePath.present ? imagePath.value : this.imagePath,
        isFavorite: isFavorite ?? this.isFavorite,
        tags: tags.present ? tags.value : this.tags,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  RecipeTableData copyWithCompanion(RecipeTableCompanion data) {
    return RecipeTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      category: data.category.present ? data.category.value : this.category,
      cookingTime:
          data.cookingTime.present ? data.cookingTime.value : this.cookingTime,
      servings: data.servings.present ? data.servings.value : this.servings,
      ingredients:
          data.ingredients.present ? data.ingredients.value : this.ingredients,
      instructions: data.instructions.present
          ? data.instructions.value
          : this.instructions,
      calories: data.calories.present ? data.calories.value : this.calories,
      protein: data.protein.present ? data.protein.value : this.protein,
      fat: data.fat.present ? data.fat.value : this.fat,
      carbs: data.carbs.present ? data.carbs.value : this.carbs,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      isFavorite:
          data.isFavorite.present ? data.isFavorite.value : this.isFavorite,
      tags: data.tags.present ? data.tags.value : this.tags,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecipeTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('cookingTime: $cookingTime, ')
          ..write('servings: $servings, ')
          ..write('ingredients: $ingredients, ')
          ..write('instructions: $instructions, ')
          ..write('calories: $calories, ')
          ..write('protein: $protein, ')
          ..write('fat: $fat, ')
          ..write('carbs: $carbs, ')
          ..write('imagePath: $imagePath, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('tags: $tags, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      category,
      cookingTime,
      servings,
      ingredients,
      instructions,
      calories,
      protein,
      fat,
      carbs,
      imagePath,
      isFavorite,
      tags,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecipeTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.category == this.category &&
          other.cookingTime == this.cookingTime &&
          other.servings == this.servings &&
          other.ingredients == this.ingredients &&
          other.instructions == this.instructions &&
          other.calories == this.calories &&
          other.protein == this.protein &&
          other.fat == this.fat &&
          other.carbs == this.carbs &&
          other.imagePath == this.imagePath &&
          other.isFavorite == this.isFavorite &&
          other.tags == this.tags &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RecipeTableCompanion extends UpdateCompanion<RecipeTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> category;
  final Value<int?> cookingTime;
  final Value<int> servings;
  final Value<String> ingredients;
  final Value<String> instructions;
  final Value<double?> calories;
  final Value<double?> protein;
  final Value<double?> fat;
  final Value<double?> carbs;
  final Value<String?> imagePath;
  final Value<bool> isFavorite;
  final Value<String?> tags;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const RecipeTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.category = const Value.absent(),
    this.cookingTime = const Value.absent(),
    this.servings = const Value.absent(),
    this.ingredients = const Value.absent(),
    this.instructions = const Value.absent(),
    this.calories = const Value.absent(),
    this.protein = const Value.absent(),
    this.fat = const Value.absent(),
    this.carbs = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.tags = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  RecipeTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String category,
    this.cookingTime = const Value.absent(),
    this.servings = const Value.absent(),
    required String ingredients,
    required String instructions,
    this.calories = const Value.absent(),
    this.protein = const Value.absent(),
    this.fat = const Value.absent(),
    this.carbs = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.tags = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : name = Value(name),
        category = Value(category),
        ingredients = Value(ingredients),
        instructions = Value(instructions);
  static Insertable<RecipeTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? category,
    Expression<int>? cookingTime,
    Expression<int>? servings,
    Expression<String>? ingredients,
    Expression<String>? instructions,
    Expression<double>? calories,
    Expression<double>? protein,
    Expression<double>? fat,
    Expression<double>? carbs,
    Expression<String>? imagePath,
    Expression<bool>? isFavorite,
    Expression<String>? tags,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      if (cookingTime != null) 'cooking_time': cookingTime,
      if (servings != null) 'servings': servings,
      if (ingredients != null) 'ingredients': ingredients,
      if (instructions != null) 'instructions': instructions,
      if (calories != null) 'calories': calories,
      if (protein != null) 'protein': protein,
      if (fat != null) 'fat': fat,
      if (carbs != null) 'carbs': carbs,
      if (imagePath != null) 'image_path': imagePath,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (tags != null) 'tags': tags,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  RecipeTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? category,
      Value<int?>? cookingTime,
      Value<int>? servings,
      Value<String>? ingredients,
      Value<String>? instructions,
      Value<double?>? calories,
      Value<double?>? protein,
      Value<double?>? fat,
      Value<double?>? carbs,
      Value<String?>? imagePath,
      Value<bool>? isFavorite,
      Value<String?>? tags,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return RecipeTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      cookingTime: cookingTime ?? this.cookingTime,
      servings: servings ?? this.servings,
      ingredients: ingredients ?? this.ingredients,
      instructions: instructions ?? this.instructions,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      fat: fat ?? this.fat,
      carbs: carbs ?? this.carbs,
      imagePath: imagePath ?? this.imagePath,
      isFavorite: isFavorite ?? this.isFavorite,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (cookingTime.present) {
      map['cooking_time'] = Variable<int>(cookingTime.value);
    }
    if (servings.present) {
      map['servings'] = Variable<int>(servings.value);
    }
    if (ingredients.present) {
      map['ingredients'] = Variable<String>(ingredients.value);
    }
    if (instructions.present) {
      map['instructions'] = Variable<String>(instructions.value);
    }
    if (calories.present) {
      map['calories'] = Variable<double>(calories.value);
    }
    if (protein.present) {
      map['protein'] = Variable<double>(protein.value);
    }
    if (fat.present) {
      map['fat'] = Variable<double>(fat.value);
    }
    if (carbs.present) {
      map['carbs'] = Variable<double>(carbs.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecipeTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('cookingTime: $cookingTime, ')
          ..write('servings: $servings, ')
          ..write('ingredients: $ingredients, ')
          ..write('instructions: $instructions, ')
          ..write('calories: $calories, ')
          ..write('protein: $protein, ')
          ..write('fat: $fat, ')
          ..write('carbs: $carbs, ')
          ..write('imagePath: $imagePath, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('tags: $tags, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $JapaneseFoodCompositionTableTable extends JapaneseFoodCompositionTable
    with
        TableInfo<$JapaneseFoodCompositionTableTable,
            JapaneseFoodCompositionTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JapaneseFoodCompositionTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _groupIdMeta =
      const VerificationMeta('groupId');
  @override
  late final GeneratedColumn<int> groupId = GeneratedColumn<int>(
      'group_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _foodIdMeta = const VerificationMeta('foodId');
  @override
  late final GeneratedColumn<int> foodId = GeneratedColumn<int>(
      'food_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _indexIdMeta =
      const VerificationMeta('indexId');
  @override
  late final GeneratedColumn<int> indexId = GeneratedColumn<int>(
      'index_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _foodNameMeta =
      const VerificationMeta('foodName');
  @override
  late final GeneratedColumn<String> foodName = GeneratedColumn<String>(
      'food_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _refuseMeta = const VerificationMeta('refuse');
  @override
  late final GeneratedColumn<double> refuse = GeneratedColumn<double>(
      'refuse', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _enercMeta = const VerificationMeta('enerc');
  @override
  late final GeneratedColumn<double> enerc = GeneratedColumn<double>(
      'enerc', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _enercKcalMeta =
      const VerificationMeta('enercKcal');
  @override
  late final GeneratedColumn<double> enercKcal = GeneratedColumn<double>(
      'enerc_kcal', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _waterMeta = const VerificationMeta('water');
  @override
  late final GeneratedColumn<double> water = GeneratedColumn<double>(
      'water', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _protcaaMeta =
      const VerificationMeta('protcaa');
  @override
  late final GeneratedColumn<double> protcaa = GeneratedColumn<double>(
      'protcaa', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _protMeta = const VerificationMeta('prot');
  @override
  late final GeneratedColumn<double> prot = GeneratedColumn<double>(
      'prot', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _fatnleaMeta =
      const VerificationMeta('fatnlea');
  @override
  late final GeneratedColumn<double> fatnlea = GeneratedColumn<double>(
      'fatnlea', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _choleMeta = const VerificationMeta('chole');
  @override
  late final GeneratedColumn<double> chole = GeneratedColumn<double>(
      'chole', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _fatMeta = const VerificationMeta('fat');
  @override
  late final GeneratedColumn<double> fat = GeneratedColumn<double>(
      'fat', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _choavlmMeta =
      const VerificationMeta('choavlm');
  @override
  late final GeneratedColumn<double> choavlm = GeneratedColumn<double>(
      'choavlm', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _choavlMeta = const VerificationMeta('choavl');
  @override
  late final GeneratedColumn<double> choavl = GeneratedColumn<double>(
      'choavl', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _choavldfMeta =
      const VerificationMeta('choavldf');
  @override
  late final GeneratedColumn<double> choavldf = GeneratedColumn<double>(
      'choavldf', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _fibMeta = const VerificationMeta('fib');
  @override
  late final GeneratedColumn<double> fib = GeneratedColumn<double>(
      'fib', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _polylMeta = const VerificationMeta('polyl');
  @override
  late final GeneratedColumn<double> polyl = GeneratedColumn<double>(
      'polyl', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _chocdfMeta = const VerificationMeta('chocdf');
  @override
  late final GeneratedColumn<double> chocdf = GeneratedColumn<double>(
      'chocdf', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _oaMeta = const VerificationMeta('oa');
  @override
  late final GeneratedColumn<double> oa = GeneratedColumn<double>(
      'oa', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _ashMeta = const VerificationMeta('ash');
  @override
  late final GeneratedColumn<double> ash = GeneratedColumn<double>(
      'ash', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _naMeta = const VerificationMeta('na');
  @override
  late final GeneratedColumn<double> na = GeneratedColumn<double>(
      'na', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _kMeta = const VerificationMeta('k');
  @override
  late final GeneratedColumn<double> k = GeneratedColumn<double>(
      'k', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _caMeta = const VerificationMeta('ca');
  @override
  late final GeneratedColumn<double> ca = GeneratedColumn<double>(
      'ca', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _mgMeta = const VerificationMeta('mg');
  @override
  late final GeneratedColumn<double> mg = GeneratedColumn<double>(
      'mg', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _pMeta = const VerificationMeta('p');
  @override
  late final GeneratedColumn<double> p = GeneratedColumn<double>(
      'p', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _feMeta = const VerificationMeta('fe');
  @override
  late final GeneratedColumn<double> fe = GeneratedColumn<double>(
      'fe', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _znMeta = const VerificationMeta('zn');
  @override
  late final GeneratedColumn<double> zn = GeneratedColumn<double>(
      'zn', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _cuMeta = const VerificationMeta('cu');
  @override
  late final GeneratedColumn<double> cu = GeneratedColumn<double>(
      'cu', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _mnMeta = const VerificationMeta('mn');
  @override
  late final GeneratedColumn<double> mn = GeneratedColumn<double>(
      'mn', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _iodineMeta = const VerificationMeta('iodine');
  @override
  late final GeneratedColumn<double> iodine = GeneratedColumn<double>(
      'iodine', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _seMeta = const VerificationMeta('se');
  @override
  late final GeneratedColumn<double> se = GeneratedColumn<double>(
      'se', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _crMeta = const VerificationMeta('cr');
  @override
  late final GeneratedColumn<double> cr = GeneratedColumn<double>(
      'cr', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _moMeta = const VerificationMeta('mo');
  @override
  late final GeneratedColumn<double> mo = GeneratedColumn<double>(
      'mo', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _retolMeta = const VerificationMeta('retol');
  @override
  late final GeneratedColumn<double> retol = GeneratedColumn<double>(
      'retol', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _cartaMeta = const VerificationMeta('carta');
  @override
  late final GeneratedColumn<double> carta = GeneratedColumn<double>(
      'carta', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _cartbMeta = const VerificationMeta('cartb');
  @override
  late final GeneratedColumn<double> cartb = GeneratedColumn<double>(
      'cartb', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _crypxbMeta = const VerificationMeta('crypxb');
  @override
  late final GeneratedColumn<double> crypxb = GeneratedColumn<double>(
      'crypxb', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _cartbeqMeta =
      const VerificationMeta('cartbeq');
  @override
  late final GeneratedColumn<double> cartbeq = GeneratedColumn<double>(
      'cartbeq', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _vitaRaeMeta =
      const VerificationMeta('vitaRae');
  @override
  late final GeneratedColumn<double> vitaRae = GeneratedColumn<double>(
      'vita_rae', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _vitDMeta = const VerificationMeta('vitD');
  @override
  late final GeneratedColumn<double> vitD = GeneratedColumn<double>(
      'vit_d', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _tocphAMeta = const VerificationMeta('tocphA');
  @override
  late final GeneratedColumn<double> tocphA = GeneratedColumn<double>(
      'tocph_a', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _tocphBMeta = const VerificationMeta('tocphB');
  @override
  late final GeneratedColumn<double> tocphB = GeneratedColumn<double>(
      'tocph_b', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _tocphGMeta = const VerificationMeta('tocphG');
  @override
  late final GeneratedColumn<double> tocphG = GeneratedColumn<double>(
      'tocph_g', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _tocphDMeta = const VerificationMeta('tocphD');
  @override
  late final GeneratedColumn<double> tocphD = GeneratedColumn<double>(
      'tocph_d', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _vitKMeta = const VerificationMeta('vitK');
  @override
  late final GeneratedColumn<double> vitK = GeneratedColumn<double>(
      'vit_k', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _thiaMeta = const VerificationMeta('thia');
  @override
  late final GeneratedColumn<double> thia = GeneratedColumn<double>(
      'thia', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _ribfMeta = const VerificationMeta('ribf');
  @override
  late final GeneratedColumn<double> ribf = GeneratedColumn<double>(
      'ribf', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _niaMeta = const VerificationMeta('nia');
  @override
  late final GeneratedColumn<double> nia = GeneratedColumn<double>(
      'nia', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _neMeta = const VerificationMeta('ne');
  @override
  late final GeneratedColumn<double> ne = GeneratedColumn<double>(
      'ne', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _vitB6AMeta = const VerificationMeta('vitB6A');
  @override
  late final GeneratedColumn<double> vitB6A = GeneratedColumn<double>(
      'vit_b6_a', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _vitB12Meta = const VerificationMeta('vitB12');
  @override
  late final GeneratedColumn<double> vitB12 = GeneratedColumn<double>(
      'vit_b12', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _folMeta = const VerificationMeta('fol');
  @override
  late final GeneratedColumn<double> fol = GeneratedColumn<double>(
      'fol', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _pantacMeta = const VerificationMeta('pantac');
  @override
  late final GeneratedColumn<double> pantac = GeneratedColumn<double>(
      'pantac', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _biotMeta = const VerificationMeta('biot');
  @override
  late final GeneratedColumn<double> biot = GeneratedColumn<double>(
      'biot', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _vitCMeta = const VerificationMeta('vitC');
  @override
  late final GeneratedColumn<double> vitC = GeneratedColumn<double>(
      'vit_c', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _alcMeta = const VerificationMeta('alc');
  @override
  late final GeneratedColumn<double> alc = GeneratedColumn<double>(
      'alc', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _naclEqMeta = const VerificationMeta('naclEq');
  @override
  late final GeneratedColumn<double> naclEq = GeneratedColumn<double>(
      'nacl_eq', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        groupId,
        foodId,
        indexId,
        foodName,
        refuse,
        enerc,
        enercKcal,
        water,
        protcaa,
        prot,
        fatnlea,
        chole,
        fat,
        choavlm,
        choavl,
        choavldf,
        fib,
        polyl,
        chocdf,
        oa,
        ash,
        na,
        k,
        ca,
        mg,
        p,
        fe,
        zn,
        cu,
        mn,
        iodine,
        se,
        cr,
        mo,
        retol,
        carta,
        cartb,
        crypxb,
        cartbeq,
        vitaRae,
        vitD,
        tocphA,
        tocphB,
        tocphG,
        tocphD,
        vitK,
        thia,
        ribf,
        nia,
        ne,
        vitB6A,
        vitB12,
        fol,
        pantac,
        biot,
        vitC,
        alc,
        naclEq,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'japanese_food_composition_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<JapaneseFoodCompositionTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('group_id')) {
      context.handle(_groupIdMeta,
          groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta));
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('food_id')) {
      context.handle(_foodIdMeta,
          foodId.isAcceptableOrUnknown(data['food_id']!, _foodIdMeta));
    } else if (isInserting) {
      context.missing(_foodIdMeta);
    }
    if (data.containsKey('index_id')) {
      context.handle(_indexIdMeta,
          indexId.isAcceptableOrUnknown(data['index_id']!, _indexIdMeta));
    } else if (isInserting) {
      context.missing(_indexIdMeta);
    }
    if (data.containsKey('food_name')) {
      context.handle(_foodNameMeta,
          foodName.isAcceptableOrUnknown(data['food_name']!, _foodNameMeta));
    } else if (isInserting) {
      context.missing(_foodNameMeta);
    }
    if (data.containsKey('refuse')) {
      context.handle(_refuseMeta,
          refuse.isAcceptableOrUnknown(data['refuse']!, _refuseMeta));
    }
    if (data.containsKey('enerc')) {
      context.handle(
          _enercMeta, enerc.isAcceptableOrUnknown(data['enerc']!, _enercMeta));
    }
    if (data.containsKey('enerc_kcal')) {
      context.handle(_enercKcalMeta,
          enercKcal.isAcceptableOrUnknown(data['enerc_kcal']!, _enercKcalMeta));
    }
    if (data.containsKey('water')) {
      context.handle(
          _waterMeta, water.isAcceptableOrUnknown(data['water']!, _waterMeta));
    }
    if (data.containsKey('protcaa')) {
      context.handle(_protcaaMeta,
          protcaa.isAcceptableOrUnknown(data['protcaa']!, _protcaaMeta));
    }
    if (data.containsKey('prot')) {
      context.handle(
          _protMeta, prot.isAcceptableOrUnknown(data['prot']!, _protMeta));
    }
    if (data.containsKey('fatnlea')) {
      context.handle(_fatnleaMeta,
          fatnlea.isAcceptableOrUnknown(data['fatnlea']!, _fatnleaMeta));
    }
    if (data.containsKey('chole')) {
      context.handle(
          _choleMeta, chole.isAcceptableOrUnknown(data['chole']!, _choleMeta));
    }
    if (data.containsKey('fat')) {
      context.handle(
          _fatMeta, fat.isAcceptableOrUnknown(data['fat']!, _fatMeta));
    }
    if (data.containsKey('choavlm')) {
      context.handle(_choavlmMeta,
          choavlm.isAcceptableOrUnknown(data['choavlm']!, _choavlmMeta));
    }
    if (data.containsKey('choavl')) {
      context.handle(_choavlMeta,
          choavl.isAcceptableOrUnknown(data['choavl']!, _choavlMeta));
    }
    if (data.containsKey('choavldf')) {
      context.handle(_choavldfMeta,
          choavldf.isAcceptableOrUnknown(data['choavldf']!, _choavldfMeta));
    }
    if (data.containsKey('fib')) {
      context.handle(
          _fibMeta, fib.isAcceptableOrUnknown(data['fib']!, _fibMeta));
    }
    if (data.containsKey('polyl')) {
      context.handle(
          _polylMeta, polyl.isAcceptableOrUnknown(data['polyl']!, _polylMeta));
    }
    if (data.containsKey('chocdf')) {
      context.handle(_chocdfMeta,
          chocdf.isAcceptableOrUnknown(data['chocdf']!, _chocdfMeta));
    }
    if (data.containsKey('oa')) {
      context.handle(_oaMeta, oa.isAcceptableOrUnknown(data['oa']!, _oaMeta));
    }
    if (data.containsKey('ash')) {
      context.handle(
          _ashMeta, ash.isAcceptableOrUnknown(data['ash']!, _ashMeta));
    }
    if (data.containsKey('na')) {
      context.handle(_naMeta, na.isAcceptableOrUnknown(data['na']!, _naMeta));
    }
    if (data.containsKey('k')) {
      context.handle(_kMeta, k.isAcceptableOrUnknown(data['k']!, _kMeta));
    }
    if (data.containsKey('ca')) {
      context.handle(_caMeta, ca.isAcceptableOrUnknown(data['ca']!, _caMeta));
    }
    if (data.containsKey('mg')) {
      context.handle(_mgMeta, mg.isAcceptableOrUnknown(data['mg']!, _mgMeta));
    }
    if (data.containsKey('p')) {
      context.handle(_pMeta, p.isAcceptableOrUnknown(data['p']!, _pMeta));
    }
    if (data.containsKey('fe')) {
      context.handle(_feMeta, fe.isAcceptableOrUnknown(data['fe']!, _feMeta));
    }
    if (data.containsKey('zn')) {
      context.handle(_znMeta, zn.isAcceptableOrUnknown(data['zn']!, _znMeta));
    }
    if (data.containsKey('cu')) {
      context.handle(_cuMeta, cu.isAcceptableOrUnknown(data['cu']!, _cuMeta));
    }
    if (data.containsKey('mn')) {
      context.handle(_mnMeta, mn.isAcceptableOrUnknown(data['mn']!, _mnMeta));
    }
    if (data.containsKey('iodine')) {
      context.handle(_iodineMeta,
          iodine.isAcceptableOrUnknown(data['iodine']!, _iodineMeta));
    }
    if (data.containsKey('se')) {
      context.handle(_seMeta, se.isAcceptableOrUnknown(data['se']!, _seMeta));
    }
    if (data.containsKey('cr')) {
      context.handle(_crMeta, cr.isAcceptableOrUnknown(data['cr']!, _crMeta));
    }
    if (data.containsKey('mo')) {
      context.handle(_moMeta, mo.isAcceptableOrUnknown(data['mo']!, _moMeta));
    }
    if (data.containsKey('retol')) {
      context.handle(
          _retolMeta, retol.isAcceptableOrUnknown(data['retol']!, _retolMeta));
    }
    if (data.containsKey('carta')) {
      context.handle(
          _cartaMeta, carta.isAcceptableOrUnknown(data['carta']!, _cartaMeta));
    }
    if (data.containsKey('cartb')) {
      context.handle(
          _cartbMeta, cartb.isAcceptableOrUnknown(data['cartb']!, _cartbMeta));
    }
    if (data.containsKey('crypxb')) {
      context.handle(_crypxbMeta,
          crypxb.isAcceptableOrUnknown(data['crypxb']!, _crypxbMeta));
    }
    if (data.containsKey('cartbeq')) {
      context.handle(_cartbeqMeta,
          cartbeq.isAcceptableOrUnknown(data['cartbeq']!, _cartbeqMeta));
    }
    if (data.containsKey('vita_rae')) {
      context.handle(_vitaRaeMeta,
          vitaRae.isAcceptableOrUnknown(data['vita_rae']!, _vitaRaeMeta));
    }
    if (data.containsKey('vit_d')) {
      context.handle(
          _vitDMeta, vitD.isAcceptableOrUnknown(data['vit_d']!, _vitDMeta));
    }
    if (data.containsKey('tocph_a')) {
      context.handle(_tocphAMeta,
          tocphA.isAcceptableOrUnknown(data['tocph_a']!, _tocphAMeta));
    }
    if (data.containsKey('tocph_b')) {
      context.handle(_tocphBMeta,
          tocphB.isAcceptableOrUnknown(data['tocph_b']!, _tocphBMeta));
    }
    if (data.containsKey('tocph_g')) {
      context.handle(_tocphGMeta,
          tocphG.isAcceptableOrUnknown(data['tocph_g']!, _tocphGMeta));
    }
    if (data.containsKey('tocph_d')) {
      context.handle(_tocphDMeta,
          tocphD.isAcceptableOrUnknown(data['tocph_d']!, _tocphDMeta));
    }
    if (data.containsKey('vit_k')) {
      context.handle(
          _vitKMeta, vitK.isAcceptableOrUnknown(data['vit_k']!, _vitKMeta));
    }
    if (data.containsKey('thia')) {
      context.handle(
          _thiaMeta, thia.isAcceptableOrUnknown(data['thia']!, _thiaMeta));
    }
    if (data.containsKey('ribf')) {
      context.handle(
          _ribfMeta, ribf.isAcceptableOrUnknown(data['ribf']!, _ribfMeta));
    }
    if (data.containsKey('nia')) {
      context.handle(
          _niaMeta, nia.isAcceptableOrUnknown(data['nia']!, _niaMeta));
    }
    if (data.containsKey('ne')) {
      context.handle(_neMeta, ne.isAcceptableOrUnknown(data['ne']!, _neMeta));
    }
    if (data.containsKey('vit_b6_a')) {
      context.handle(_vitB6AMeta,
          vitB6A.isAcceptableOrUnknown(data['vit_b6_a']!, _vitB6AMeta));
    }
    if (data.containsKey('vit_b12')) {
      context.handle(_vitB12Meta,
          vitB12.isAcceptableOrUnknown(data['vit_b12']!, _vitB12Meta));
    }
    if (data.containsKey('fol')) {
      context.handle(
          _folMeta, fol.isAcceptableOrUnknown(data['fol']!, _folMeta));
    }
    if (data.containsKey('pantac')) {
      context.handle(_pantacMeta,
          pantac.isAcceptableOrUnknown(data['pantac']!, _pantacMeta));
    }
    if (data.containsKey('biot')) {
      context.handle(
          _biotMeta, biot.isAcceptableOrUnknown(data['biot']!, _biotMeta));
    }
    if (data.containsKey('vit_c')) {
      context.handle(
          _vitCMeta, vitC.isAcceptableOrUnknown(data['vit_c']!, _vitCMeta));
    }
    if (data.containsKey('alc')) {
      context.handle(
          _alcMeta, alc.isAcceptableOrUnknown(data['alc']!, _alcMeta));
    }
    if (data.containsKey('nacl_eq')) {
      context.handle(_naclEqMeta,
          naclEq.isAcceptableOrUnknown(data['nacl_eq']!, _naclEqMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  JapaneseFoodCompositionTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JapaneseFoodCompositionTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      groupId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}group_id'])!,
      foodId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}food_id'])!,
      indexId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}index_id'])!,
      foodName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}food_name'])!,
      refuse: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}refuse'])!,
      enerc: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}enerc']),
      enercKcal: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}enerc_kcal']),
      water: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}water']),
      protcaa: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}protcaa']),
      prot: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}prot']),
      fatnlea: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}fatnlea']),
      chole: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}chole']),
      fat: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}fat']),
      choavlm: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}choavlm']),
      choavl: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}choavl']),
      choavldf: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}choavldf']),
      fib: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}fib']),
      polyl: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}polyl']),
      chocdf: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}chocdf']),
      oa: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}oa']),
      ash: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}ash']),
      na: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}na']),
      k: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}k']),
      ca: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}ca']),
      mg: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}mg']),
      p: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}p']),
      fe: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}fe']),
      zn: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}zn']),
      cu: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}cu']),
      mn: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}mn']),
      iodine: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}iodine']),
      se: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}se']),
      cr: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}cr']),
      mo: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}mo']),
      retol: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}retol']),
      carta: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}carta']),
      cartb: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}cartb']),
      crypxb: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}crypxb']),
      cartbeq: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}cartbeq']),
      vitaRae: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}vita_rae']),
      vitD: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}vit_d']),
      tocphA: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}tocph_a']),
      tocphB: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}tocph_b']),
      tocphG: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}tocph_g']),
      tocphD: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}tocph_d']),
      vitK: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}vit_k']),
      thia: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}thia']),
      ribf: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}ribf']),
      nia: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}nia']),
      ne: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}ne']),
      vitB6A: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}vit_b6_a']),
      vitB12: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}vit_b12']),
      fol: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}fol']),
      pantac: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}pantac']),
      biot: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}biot']),
      vitC: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}vit_c']),
      alc: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}alc']),
      naclEq: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}nacl_eq']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $JapaneseFoodCompositionTableTable createAlias(String alias) {
    return $JapaneseFoodCompositionTableTable(attachedDatabase, alias);
  }
}

class JapaneseFoodCompositionTableCompanion
    extends UpdateCompanion<JapaneseFoodCompositionTableData> {
  final Value<int> id;
  final Value<int> groupId;
  final Value<int> foodId;
  final Value<int> indexId;
  final Value<String> foodName;
  final Value<double> refuse;
  final Value<double?> enerc;
  final Value<double?> enercKcal;
  final Value<double?> water;
  final Value<double?> protcaa;
  final Value<double?> prot;
  final Value<double?> fatnlea;
  final Value<double?> chole;
  final Value<double?> fat;
  final Value<double?> choavlm;
  final Value<double?> choavl;
  final Value<double?> choavldf;
  final Value<double?> fib;
  final Value<double?> polyl;
  final Value<double?> chocdf;
  final Value<double?> oa;
  final Value<double?> ash;
  final Value<double?> na;
  final Value<double?> k;
  final Value<double?> ca;
  final Value<double?> mg;
  final Value<double?> p;
  final Value<double?> fe;
  final Value<double?> zn;
  final Value<double?> cu;
  final Value<double?> mn;
  final Value<double?> iodine;
  final Value<double?> se;
  final Value<double?> cr;
  final Value<double?> mo;
  final Value<double?> retol;
  final Value<double?> carta;
  final Value<double?> cartb;
  final Value<double?> crypxb;
  final Value<double?> cartbeq;
  final Value<double?> vitaRae;
  final Value<double?> vitD;
  final Value<double?> tocphA;
  final Value<double?> tocphB;
  final Value<double?> tocphG;
  final Value<double?> tocphD;
  final Value<double?> vitK;
  final Value<double?> thia;
  final Value<double?> ribf;
  final Value<double?> nia;
  final Value<double?> ne;
  final Value<double?> vitB6A;
  final Value<double?> vitB12;
  final Value<double?> fol;
  final Value<double?> pantac;
  final Value<double?> biot;
  final Value<double?> vitC;
  final Value<double?> alc;
  final Value<double?> naclEq;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const JapaneseFoodCompositionTableCompanion({
    this.id = const Value.absent(),
    this.groupId = const Value.absent(),
    this.foodId = const Value.absent(),
    this.indexId = const Value.absent(),
    this.foodName = const Value.absent(),
    this.refuse = const Value.absent(),
    this.enerc = const Value.absent(),
    this.enercKcal = const Value.absent(),
    this.water = const Value.absent(),
    this.protcaa = const Value.absent(),
    this.prot = const Value.absent(),
    this.fatnlea = const Value.absent(),
    this.chole = const Value.absent(),
    this.fat = const Value.absent(),
    this.choavlm = const Value.absent(),
    this.choavl = const Value.absent(),
    this.choavldf = const Value.absent(),
    this.fib = const Value.absent(),
    this.polyl = const Value.absent(),
    this.chocdf = const Value.absent(),
    this.oa = const Value.absent(),
    this.ash = const Value.absent(),
    this.na = const Value.absent(),
    this.k = const Value.absent(),
    this.ca = const Value.absent(),
    this.mg = const Value.absent(),
    this.p = const Value.absent(),
    this.fe = const Value.absent(),
    this.zn = const Value.absent(),
    this.cu = const Value.absent(),
    this.mn = const Value.absent(),
    this.iodine = const Value.absent(),
    this.se = const Value.absent(),
    this.cr = const Value.absent(),
    this.mo = const Value.absent(),
    this.retol = const Value.absent(),
    this.carta = const Value.absent(),
    this.cartb = const Value.absent(),
    this.crypxb = const Value.absent(),
    this.cartbeq = const Value.absent(),
    this.vitaRae = const Value.absent(),
    this.vitD = const Value.absent(),
    this.tocphA = const Value.absent(),
    this.tocphB = const Value.absent(),
    this.tocphG = const Value.absent(),
    this.tocphD = const Value.absent(),
    this.vitK = const Value.absent(),
    this.thia = const Value.absent(),
    this.ribf = const Value.absent(),
    this.nia = const Value.absent(),
    this.ne = const Value.absent(),
    this.vitB6A = const Value.absent(),
    this.vitB12 = const Value.absent(),
    this.fol = const Value.absent(),
    this.pantac = const Value.absent(),
    this.biot = const Value.absent(),
    this.vitC = const Value.absent(),
    this.alc = const Value.absent(),
    this.naclEq = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  JapaneseFoodCompositionTableCompanion.insert({
    this.id = const Value.absent(),
    required int groupId,
    required int foodId,
    required int indexId,
    required String foodName,
    this.refuse = const Value.absent(),
    this.enerc = const Value.absent(),
    this.enercKcal = const Value.absent(),
    this.water = const Value.absent(),
    this.protcaa = const Value.absent(),
    this.prot = const Value.absent(),
    this.fatnlea = const Value.absent(),
    this.chole = const Value.absent(),
    this.fat = const Value.absent(),
    this.choavlm = const Value.absent(),
    this.choavl = const Value.absent(),
    this.choavldf = const Value.absent(),
    this.fib = const Value.absent(),
    this.polyl = const Value.absent(),
    this.chocdf = const Value.absent(),
    this.oa = const Value.absent(),
    this.ash = const Value.absent(),
    this.na = const Value.absent(),
    this.k = const Value.absent(),
    this.ca = const Value.absent(),
    this.mg = const Value.absent(),
    this.p = const Value.absent(),
    this.fe = const Value.absent(),
    this.zn = const Value.absent(),
    this.cu = const Value.absent(),
    this.mn = const Value.absent(),
    this.iodine = const Value.absent(),
    this.se = const Value.absent(),
    this.cr = const Value.absent(),
    this.mo = const Value.absent(),
    this.retol = const Value.absent(),
    this.carta = const Value.absent(),
    this.cartb = const Value.absent(),
    this.crypxb = const Value.absent(),
    this.cartbeq = const Value.absent(),
    this.vitaRae = const Value.absent(),
    this.vitD = const Value.absent(),
    this.tocphA = const Value.absent(),
    this.tocphB = const Value.absent(),
    this.tocphG = const Value.absent(),
    this.tocphD = const Value.absent(),
    this.vitK = const Value.absent(),
    this.thia = const Value.absent(),
    this.ribf = const Value.absent(),
    this.nia = const Value.absent(),
    this.ne = const Value.absent(),
    this.vitB6A = const Value.absent(),
    this.vitB12 = const Value.absent(),
    this.fol = const Value.absent(),
    this.pantac = const Value.absent(),
    this.biot = const Value.absent(),
    this.vitC = const Value.absent(),
    this.alc = const Value.absent(),
    this.naclEq = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : groupId = Value(groupId),
        foodId = Value(foodId),
        indexId = Value(indexId),
        foodName = Value(foodName);
  static Insertable<JapaneseFoodCompositionTableData> custom({
    Expression<int>? id,
    Expression<int>? groupId,
    Expression<int>? foodId,
    Expression<int>? indexId,
    Expression<String>? foodName,
    Expression<double>? refuse,
    Expression<double>? enerc,
    Expression<double>? enercKcal,
    Expression<double>? water,
    Expression<double>? protcaa,
    Expression<double>? prot,
    Expression<double>? fatnlea,
    Expression<double>? chole,
    Expression<double>? fat,
    Expression<double>? choavlm,
    Expression<double>? choavl,
    Expression<double>? choavldf,
    Expression<double>? fib,
    Expression<double>? polyl,
    Expression<double>? chocdf,
    Expression<double>? oa,
    Expression<double>? ash,
    Expression<double>? na,
    Expression<double>? k,
    Expression<double>? ca,
    Expression<double>? mg,
    Expression<double>? p,
    Expression<double>? fe,
    Expression<double>? zn,
    Expression<double>? cu,
    Expression<double>? mn,
    Expression<double>? iodine,
    Expression<double>? se,
    Expression<double>? cr,
    Expression<double>? mo,
    Expression<double>? retol,
    Expression<double>? carta,
    Expression<double>? cartb,
    Expression<double>? crypxb,
    Expression<double>? cartbeq,
    Expression<double>? vitaRae,
    Expression<double>? vitD,
    Expression<double>? tocphA,
    Expression<double>? tocphB,
    Expression<double>? tocphG,
    Expression<double>? tocphD,
    Expression<double>? vitK,
    Expression<double>? thia,
    Expression<double>? ribf,
    Expression<double>? nia,
    Expression<double>? ne,
    Expression<double>? vitB6A,
    Expression<double>? vitB12,
    Expression<double>? fol,
    Expression<double>? pantac,
    Expression<double>? biot,
    Expression<double>? vitC,
    Expression<double>? alc,
    Expression<double>? naclEq,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (groupId != null) 'group_id': groupId,
      if (foodId != null) 'food_id': foodId,
      if (indexId != null) 'index_id': indexId,
      if (foodName != null) 'food_name': foodName,
      if (refuse != null) 'refuse': refuse,
      if (enerc != null) 'enerc': enerc,
      if (enercKcal != null) 'enerc_kcal': enercKcal,
      if (water != null) 'water': water,
      if (protcaa != null) 'protcaa': protcaa,
      if (prot != null) 'prot': prot,
      if (fatnlea != null) 'fatnlea': fatnlea,
      if (chole != null) 'chole': chole,
      if (fat != null) 'fat': fat,
      if (choavlm != null) 'choavlm': choavlm,
      if (choavl != null) 'choavl': choavl,
      if (choavldf != null) 'choavldf': choavldf,
      if (fib != null) 'fib': fib,
      if (polyl != null) 'polyl': polyl,
      if (chocdf != null) 'chocdf': chocdf,
      if (oa != null) 'oa': oa,
      if (ash != null) 'ash': ash,
      if (na != null) 'na': na,
      if (k != null) 'k': k,
      if (ca != null) 'ca': ca,
      if (mg != null) 'mg': mg,
      if (p != null) 'p': p,
      if (fe != null) 'fe': fe,
      if (zn != null) 'zn': zn,
      if (cu != null) 'cu': cu,
      if (mn != null) 'mn': mn,
      if (iodine != null) 'iodine': iodine,
      if (se != null) 'se': se,
      if (cr != null) 'cr': cr,
      if (mo != null) 'mo': mo,
      if (retol != null) 'retol': retol,
      if (carta != null) 'carta': carta,
      if (cartb != null) 'cartb': cartb,
      if (crypxb != null) 'crypxb': crypxb,
      if (cartbeq != null) 'cartbeq': cartbeq,
      if (vitaRae != null) 'vita_rae': vitaRae,
      if (vitD != null) 'vit_d': vitD,
      if (tocphA != null) 'tocph_a': tocphA,
      if (tocphB != null) 'tocph_b': tocphB,
      if (tocphG != null) 'tocph_g': tocphG,
      if (tocphD != null) 'tocph_d': tocphD,
      if (vitK != null) 'vit_k': vitK,
      if (thia != null) 'thia': thia,
      if (ribf != null) 'ribf': ribf,
      if (nia != null) 'nia': nia,
      if (ne != null) 'ne': ne,
      if (vitB6A != null) 'vit_b6_a': vitB6A,
      if (vitB12 != null) 'vit_b12': vitB12,
      if (fol != null) 'fol': fol,
      if (pantac != null) 'pantac': pantac,
      if (biot != null) 'biot': biot,
      if (vitC != null) 'vit_c': vitC,
      if (alc != null) 'alc': alc,
      if (naclEq != null) 'nacl_eq': naclEq,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  JapaneseFoodCompositionTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? groupId,
      Value<int>? foodId,
      Value<int>? indexId,
      Value<String>? foodName,
      Value<double>? refuse,
      Value<double?>? enerc,
      Value<double?>? enercKcal,
      Value<double?>? water,
      Value<double?>? protcaa,
      Value<double?>? prot,
      Value<double?>? fatnlea,
      Value<double?>? chole,
      Value<double?>? fat,
      Value<double?>? choavlm,
      Value<double?>? choavl,
      Value<double?>? choavldf,
      Value<double?>? fib,
      Value<double?>? polyl,
      Value<double?>? chocdf,
      Value<double?>? oa,
      Value<double?>? ash,
      Value<double?>? na,
      Value<double?>? k,
      Value<double?>? ca,
      Value<double?>? mg,
      Value<double?>? p,
      Value<double?>? fe,
      Value<double?>? zn,
      Value<double?>? cu,
      Value<double?>? mn,
      Value<double?>? iodine,
      Value<double?>? se,
      Value<double?>? cr,
      Value<double?>? mo,
      Value<double?>? retol,
      Value<double?>? carta,
      Value<double?>? cartb,
      Value<double?>? crypxb,
      Value<double?>? cartbeq,
      Value<double?>? vitaRae,
      Value<double?>? vitD,
      Value<double?>? tocphA,
      Value<double?>? tocphB,
      Value<double?>? tocphG,
      Value<double?>? tocphD,
      Value<double?>? vitK,
      Value<double?>? thia,
      Value<double?>? ribf,
      Value<double?>? nia,
      Value<double?>? ne,
      Value<double?>? vitB6A,
      Value<double?>? vitB12,
      Value<double?>? fol,
      Value<double?>? pantac,
      Value<double?>? biot,
      Value<double?>? vitC,
      Value<double?>? alc,
      Value<double?>? naclEq,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return JapaneseFoodCompositionTableCompanion(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      foodId: foodId ?? this.foodId,
      indexId: indexId ?? this.indexId,
      foodName: foodName ?? this.foodName,
      refuse: refuse ?? this.refuse,
      enerc: enerc ?? this.enerc,
      enercKcal: enercKcal ?? this.enercKcal,
      water: water ?? this.water,
      protcaa: protcaa ?? this.protcaa,
      prot: prot ?? this.prot,
      fatnlea: fatnlea ?? this.fatnlea,
      chole: chole ?? this.chole,
      fat: fat ?? this.fat,
      choavlm: choavlm ?? this.choavlm,
      choavl: choavl ?? this.choavl,
      choavldf: choavldf ?? this.choavldf,
      fib: fib ?? this.fib,
      polyl: polyl ?? this.polyl,
      chocdf: chocdf ?? this.chocdf,
      oa: oa ?? this.oa,
      ash: ash ?? this.ash,
      na: na ?? this.na,
      k: k ?? this.k,
      ca: ca ?? this.ca,
      mg: mg ?? this.mg,
      p: p ?? this.p,
      fe: fe ?? this.fe,
      zn: zn ?? this.zn,
      cu: cu ?? this.cu,
      mn: mn ?? this.mn,
      iodine: iodine ?? this.iodine,
      se: se ?? this.se,
      cr: cr ?? this.cr,
      mo: mo ?? this.mo,
      retol: retol ?? this.retol,
      carta: carta ?? this.carta,
      cartb: cartb ?? this.cartb,
      crypxb: crypxb ?? this.crypxb,
      cartbeq: cartbeq ?? this.cartbeq,
      vitaRae: vitaRae ?? this.vitaRae,
      vitD: vitD ?? this.vitD,
      tocphA: tocphA ?? this.tocphA,
      tocphB: tocphB ?? this.tocphB,
      tocphG: tocphG ?? this.tocphG,
      tocphD: tocphD ?? this.tocphD,
      vitK: vitK ?? this.vitK,
      thia: thia ?? this.thia,
      ribf: ribf ?? this.ribf,
      nia: nia ?? this.nia,
      ne: ne ?? this.ne,
      vitB6A: vitB6A ?? this.vitB6A,
      vitB12: vitB12 ?? this.vitB12,
      fol: fol ?? this.fol,
      pantac: pantac ?? this.pantac,
      biot: biot ?? this.biot,
      vitC: vitC ?? this.vitC,
      alc: alc ?? this.alc,
      naclEq: naclEq ?? this.naclEq,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<int>(groupId.value);
    }
    if (foodId.present) {
      map['food_id'] = Variable<int>(foodId.value);
    }
    if (indexId.present) {
      map['index_id'] = Variable<int>(indexId.value);
    }
    if (foodName.present) {
      map['food_name'] = Variable<String>(foodName.value);
    }
    if (refuse.present) {
      map['refuse'] = Variable<double>(refuse.value);
    }
    if (enerc.present) {
      map['enerc'] = Variable<double>(enerc.value);
    }
    if (enercKcal.present) {
      map['enerc_kcal'] = Variable<double>(enercKcal.value);
    }
    if (water.present) {
      map['water'] = Variable<double>(water.value);
    }
    if (protcaa.present) {
      map['protcaa'] = Variable<double>(protcaa.value);
    }
    if (prot.present) {
      map['prot'] = Variable<double>(prot.value);
    }
    if (fatnlea.present) {
      map['fatnlea'] = Variable<double>(fatnlea.value);
    }
    if (chole.present) {
      map['chole'] = Variable<double>(chole.value);
    }
    if (fat.present) {
      map['fat'] = Variable<double>(fat.value);
    }
    if (choavlm.present) {
      map['choavlm'] = Variable<double>(choavlm.value);
    }
    if (choavl.present) {
      map['choavl'] = Variable<double>(choavl.value);
    }
    if (choavldf.present) {
      map['choavldf'] = Variable<double>(choavldf.value);
    }
    if (fib.present) {
      map['fib'] = Variable<double>(fib.value);
    }
    if (polyl.present) {
      map['polyl'] = Variable<double>(polyl.value);
    }
    if (chocdf.present) {
      map['chocdf'] = Variable<double>(chocdf.value);
    }
    if (oa.present) {
      map['oa'] = Variable<double>(oa.value);
    }
    if (ash.present) {
      map['ash'] = Variable<double>(ash.value);
    }
    if (na.present) {
      map['na'] = Variable<double>(na.value);
    }
    if (k.present) {
      map['k'] = Variable<double>(k.value);
    }
    if (ca.present) {
      map['ca'] = Variable<double>(ca.value);
    }
    if (mg.present) {
      map['mg'] = Variable<double>(mg.value);
    }
    if (p.present) {
      map['p'] = Variable<double>(p.value);
    }
    if (fe.present) {
      map['fe'] = Variable<double>(fe.value);
    }
    if (zn.present) {
      map['zn'] = Variable<double>(zn.value);
    }
    if (cu.present) {
      map['cu'] = Variable<double>(cu.value);
    }
    if (mn.present) {
      map['mn'] = Variable<double>(mn.value);
    }
    if (iodine.present) {
      map['iodine'] = Variable<double>(iodine.value);
    }
    if (se.present) {
      map['se'] = Variable<double>(se.value);
    }
    if (cr.present) {
      map['cr'] = Variable<double>(cr.value);
    }
    if (mo.present) {
      map['mo'] = Variable<double>(mo.value);
    }
    if (retol.present) {
      map['retol'] = Variable<double>(retol.value);
    }
    if (carta.present) {
      map['carta'] = Variable<double>(carta.value);
    }
    if (cartb.present) {
      map['cartb'] = Variable<double>(cartb.value);
    }
    if (crypxb.present) {
      map['crypxb'] = Variable<double>(crypxb.value);
    }
    if (cartbeq.present) {
      map['cartbeq'] = Variable<double>(cartbeq.value);
    }
    if (vitaRae.present) {
      map['vita_rae'] = Variable<double>(vitaRae.value);
    }
    if (vitD.present) {
      map['vit_d'] = Variable<double>(vitD.value);
    }
    if (tocphA.present) {
      map['tocph_a'] = Variable<double>(tocphA.value);
    }
    if (tocphB.present) {
      map['tocph_b'] = Variable<double>(tocphB.value);
    }
    if (tocphG.present) {
      map['tocph_g'] = Variable<double>(tocphG.value);
    }
    if (tocphD.present) {
      map['tocph_d'] = Variable<double>(tocphD.value);
    }
    if (vitK.present) {
      map['vit_k'] = Variable<double>(vitK.value);
    }
    if (thia.present) {
      map['thia'] = Variable<double>(thia.value);
    }
    if (ribf.present) {
      map['ribf'] = Variable<double>(ribf.value);
    }
    if (nia.present) {
      map['nia'] = Variable<double>(nia.value);
    }
    if (ne.present) {
      map['ne'] = Variable<double>(ne.value);
    }
    if (vitB6A.present) {
      map['vit_b6_a'] = Variable<double>(vitB6A.value);
    }
    if (vitB12.present) {
      map['vit_b12'] = Variable<double>(vitB12.value);
    }
    if (fol.present) {
      map['fol'] = Variable<double>(fol.value);
    }
    if (pantac.present) {
      map['pantac'] = Variable<double>(pantac.value);
    }
    if (biot.present) {
      map['biot'] = Variable<double>(biot.value);
    }
    if (vitC.present) {
      map['vit_c'] = Variable<double>(vitC.value);
    }
    if (alc.present) {
      map['alc'] = Variable<double>(alc.value);
    }
    if (naclEq.present) {
      map['nacl_eq'] = Variable<double>(naclEq.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JapaneseFoodCompositionTableCompanion(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('foodId: $foodId, ')
          ..write('indexId: $indexId, ')
          ..write('foodName: $foodName, ')
          ..write('refuse: $refuse, ')
          ..write('enerc: $enerc, ')
          ..write('enercKcal: $enercKcal, ')
          ..write('water: $water, ')
          ..write('protcaa: $protcaa, ')
          ..write('prot: $prot, ')
          ..write('fatnlea: $fatnlea, ')
          ..write('chole: $chole, ')
          ..write('fat: $fat, ')
          ..write('choavlm: $choavlm, ')
          ..write('choavl: $choavl, ')
          ..write('choavldf: $choavldf, ')
          ..write('fib: $fib, ')
          ..write('polyl: $polyl, ')
          ..write('chocdf: $chocdf, ')
          ..write('oa: $oa, ')
          ..write('ash: $ash, ')
          ..write('na: $na, ')
          ..write('k: $k, ')
          ..write('ca: $ca, ')
          ..write('mg: $mg, ')
          ..write('p: $p, ')
          ..write('fe: $fe, ')
          ..write('zn: $zn, ')
          ..write('cu: $cu, ')
          ..write('mn: $mn, ')
          ..write('iodine: $iodine, ')
          ..write('se: $se, ')
          ..write('cr: $cr, ')
          ..write('mo: $mo, ')
          ..write('retol: $retol, ')
          ..write('carta: $carta, ')
          ..write('cartb: $cartb, ')
          ..write('crypxb: $crypxb, ')
          ..write('cartbeq: $cartbeq, ')
          ..write('vitaRae: $vitaRae, ')
          ..write('vitD: $vitD, ')
          ..write('tocphA: $tocphA, ')
          ..write('tocphB: $tocphB, ')
          ..write('tocphG: $tocphG, ')
          ..write('tocphD: $tocphD, ')
          ..write('vitK: $vitK, ')
          ..write('thia: $thia, ')
          ..write('ribf: $ribf, ')
          ..write('nia: $nia, ')
          ..write('ne: $ne, ')
          ..write('vitB6A: $vitB6A, ')
          ..write('vitB12: $vitB12, ')
          ..write('fol: $fol, ')
          ..write('pantac: $pantac, ')
          ..write('biot: $biot, ')
          ..write('vitC: $vitC, ')
          ..write('alc: $alc, ')
          ..write('naclEq: $naclEq, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $MealTableTable mealTable = $MealTableTable(this);
  late final $ExternalRecipeTableTable externalRecipeTable =
      $ExternalRecipeTableTable(this);
  late final $MealItemTableTable mealItemTable = $MealItemTableTable(this);
  late final $PersonalDataTableTable personalDataTable =
      $PersonalDataTableTable(this);
  late final $FoodItemTableTable foodItemTable = $FoodItemTableTable(this);
  late final $RecipeTableTable recipeTable = $RecipeTableTable(this);
  late final $JapaneseFoodCompositionTableTable japaneseFoodCompositionTable =
      $JapaneseFoodCompositionTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        mealTable,
        externalRecipeTable,
        mealItemTable,
        personalDataTable,
        foodItemTable,
        recipeTable,
        japaneseFoodCompositionTable
      ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('meal_table',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('meal_item_table', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('external_recipe_table',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('meal_item_table', kind: UpdateKind.update),
            ],
          ),
        ],
      );
}

typedef $$MealTableTableCreateCompanionBuilder = MealTableCompanion Function({
  Value<int> id,
  required DateTime recordedAt,
  required String mealType,
  Value<String?> memo,
  Value<double> totalCalories,
  Value<double> totalProtein,
  Value<double> totalFat,
  Value<double> totalCarbs,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$MealTableTableUpdateCompanionBuilder = MealTableCompanion Function({
  Value<int> id,
  Value<DateTime> recordedAt,
  Value<String> mealType,
  Value<String?> memo,
  Value<double> totalCalories,
  Value<double> totalProtein,
  Value<double> totalFat,
  Value<double> totalCarbs,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$MealTableTableReferences
    extends BaseReferences<_$AppDatabase, $MealTableTable, MealTableData> {
  $$MealTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MealItemTableTable, List<MealItemTableData>>
      _mealItemTableRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.mealItemTable,
              aliasName: $_aliasNameGenerator(
                  db.mealTable.id, db.mealItemTable.mealId));

  $$MealItemTableTableProcessedTableManager get mealItemTableRefs {
    final manager = $$MealItemTableTableTableManager($_db, $_db.mealItemTable)
        .filter((f) => f.mealId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_mealItemTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$MealTableTableFilterComposer
    extends Composer<_$AppDatabase, $MealTableTable> {
  $$MealTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get recordedAt => $composableBuilder(
      column: $table.recordedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mealType => $composableBuilder(
      column: $table.mealType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get memo => $composableBuilder(
      column: $table.memo, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalCalories => $composableBuilder(
      column: $table.totalCalories, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalProtein => $composableBuilder(
      column: $table.totalProtein, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalFat => $composableBuilder(
      column: $table.totalFat, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalCarbs => $composableBuilder(
      column: $table.totalCarbs, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> mealItemTableRefs(
      Expression<bool> Function($$MealItemTableTableFilterComposer f) f) {
    final $$MealItemTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.mealItemTable,
        getReferencedColumn: (t) => t.mealId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MealItemTableTableFilterComposer(
              $db: $db,
              $table: $db.mealItemTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$MealTableTableOrderingComposer
    extends Composer<_$AppDatabase, $MealTableTable> {
  $$MealTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get recordedAt => $composableBuilder(
      column: $table.recordedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mealType => $composableBuilder(
      column: $table.mealType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get memo => $composableBuilder(
      column: $table.memo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalCalories => $composableBuilder(
      column: $table.totalCalories,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalProtein => $composableBuilder(
      column: $table.totalProtein,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalFat => $composableBuilder(
      column: $table.totalFat, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalCarbs => $composableBuilder(
      column: $table.totalCarbs, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$MealTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $MealTableTable> {
  $$MealTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get recordedAt => $composableBuilder(
      column: $table.recordedAt, builder: (column) => column);

  GeneratedColumn<String> get mealType =>
      $composableBuilder(column: $table.mealType, builder: (column) => column);

  GeneratedColumn<String> get memo =>
      $composableBuilder(column: $table.memo, builder: (column) => column);

  GeneratedColumn<double> get totalCalories => $composableBuilder(
      column: $table.totalCalories, builder: (column) => column);

  GeneratedColumn<double> get totalProtein => $composableBuilder(
      column: $table.totalProtein, builder: (column) => column);

  GeneratedColumn<double> get totalFat =>
      $composableBuilder(column: $table.totalFat, builder: (column) => column);

  GeneratedColumn<double> get totalCarbs => $composableBuilder(
      column: $table.totalCarbs, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> mealItemTableRefs<T extends Object>(
      Expression<T> Function($$MealItemTableTableAnnotationComposer a) f) {
    final $$MealItemTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.mealItemTable,
        getReferencedColumn: (t) => t.mealId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MealItemTableTableAnnotationComposer(
              $db: $db,
              $table: $db.mealItemTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$MealTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MealTableTable,
    MealTableData,
    $$MealTableTableFilterComposer,
    $$MealTableTableOrderingComposer,
    $$MealTableTableAnnotationComposer,
    $$MealTableTableCreateCompanionBuilder,
    $$MealTableTableUpdateCompanionBuilder,
    (MealTableData, $$MealTableTableReferences),
    MealTableData,
    PrefetchHooks Function({bool mealItemTableRefs})> {
  $$MealTableTableTableManager(_$AppDatabase db, $MealTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MealTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MealTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MealTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> recordedAt = const Value.absent(),
            Value<String> mealType = const Value.absent(),
            Value<String?> memo = const Value.absent(),
            Value<double> totalCalories = const Value.absent(),
            Value<double> totalProtein = const Value.absent(),
            Value<double> totalFat = const Value.absent(),
            Value<double> totalCarbs = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              MealTableCompanion(
            id: id,
            recordedAt: recordedAt,
            mealType: mealType,
            memo: memo,
            totalCalories: totalCalories,
            totalProtein: totalProtein,
            totalFat: totalFat,
            totalCarbs: totalCarbs,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required DateTime recordedAt,
            required String mealType,
            Value<String?> memo = const Value.absent(),
            Value<double> totalCalories = const Value.absent(),
            Value<double> totalProtein = const Value.absent(),
            Value<double> totalFat = const Value.absent(),
            Value<double> totalCarbs = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              MealTableCompanion.insert(
            id: id,
            recordedAt: recordedAt,
            mealType: mealType,
            memo: memo,
            totalCalories: totalCalories,
            totalProtein: totalProtein,
            totalFat: totalFat,
            totalCarbs: totalCarbs,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$MealTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({mealItemTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (mealItemTableRefs) db.mealItemTable
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (mealItemTableRefs)
                    await $_getPrefetchedData<MealTableData, $MealTableTable,
                            MealItemTableData>(
                        currentTable: table,
                        referencedTable: $$MealTableTableReferences
                            ._mealItemTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MealTableTableReferences(db, table, p0)
                                .mealItemTableRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.mealId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$MealTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MealTableTable,
    MealTableData,
    $$MealTableTableFilterComposer,
    $$MealTableTableOrderingComposer,
    $$MealTableTableAnnotationComposer,
    $$MealTableTableCreateCompanionBuilder,
    $$MealTableTableUpdateCompanionBuilder,
    (MealTableData, $$MealTableTableReferences),
    MealTableData,
    PrefetchHooks Function({bool mealItemTableRefs})>;
typedef $$ExternalRecipeTableTableCreateCompanionBuilder
    = ExternalRecipeTableCompanion Function({
  Value<int> id,
  required String url,
  required String title,
  Value<String?> description,
  Value<String?> imageUrl,
  Value<String?> siteName,
  Value<bool> isFavorite,
  Value<String?> tags,
  Value<String?> memo,
  Value<String?> ingredientsJson,
  Value<String?> ingredientsRawText,
  Value<double?> calories,
  Value<double?> protein,
  Value<double?> fat,
  Value<double?> carbohydrate,
  Value<double?> salt,
  Value<double?> fiber,
  Value<double?> vitaminC,
  Value<bool> isNutritionAutoExtracted,
  Value<int> servings,
  Value<DateTime?> lastAccessedAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$ExternalRecipeTableTableUpdateCompanionBuilder
    = ExternalRecipeTableCompanion Function({
  Value<int> id,
  Value<String> url,
  Value<String> title,
  Value<String?> description,
  Value<String?> imageUrl,
  Value<String?> siteName,
  Value<bool> isFavorite,
  Value<String?> tags,
  Value<String?> memo,
  Value<String?> ingredientsJson,
  Value<String?> ingredientsRawText,
  Value<double?> calories,
  Value<double?> protein,
  Value<double?> fat,
  Value<double?> carbohydrate,
  Value<double?> salt,
  Value<double?> fiber,
  Value<double?> vitaminC,
  Value<bool> isNutritionAutoExtracted,
  Value<int> servings,
  Value<DateTime?> lastAccessedAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$ExternalRecipeTableTableReferences extends BaseReferences<
    _$AppDatabase, $ExternalRecipeTableTable, ExternalRecipeTableData> {
  $$ExternalRecipeTableTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MealItemTableTable, List<MealItemTableData>>
      _mealItemTableRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.mealItemTable,
              aliasName: $_aliasNameGenerator(db.externalRecipeTable.id,
                  db.mealItemTable.externalRecipeId));

  $$MealItemTableTableProcessedTableManager get mealItemTableRefs {
    final manager = $$MealItemTableTableTableManager($_db, $_db.mealItemTable)
        .filter(
            (f) => f.externalRecipeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_mealItemTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ExternalRecipeTableTableFilterComposer
    extends Composer<_$AppDatabase, $ExternalRecipeTableTable> {
  $$ExternalRecipeTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get url => $composableBuilder(
      column: $table.url, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imageUrl => $composableBuilder(
      column: $table.imageUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get siteName => $composableBuilder(
      column: $table.siteName, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isFavorite => $composableBuilder(
      column: $table.isFavorite, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get memo => $composableBuilder(
      column: $table.memo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ingredientsJson => $composableBuilder(
      column: $table.ingredientsJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ingredientsRawText => $composableBuilder(
      column: $table.ingredientsRawText,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get calories => $composableBuilder(
      column: $table.calories, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get protein => $composableBuilder(
      column: $table.protein, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get fat => $composableBuilder(
      column: $table.fat, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get carbohydrate => $composableBuilder(
      column: $table.carbohydrate, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get salt => $composableBuilder(
      column: $table.salt, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get fiber => $composableBuilder(
      column: $table.fiber, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get vitaminC => $composableBuilder(
      column: $table.vitaminC, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isNutritionAutoExtracted => $composableBuilder(
      column: $table.isNutritionAutoExtracted,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get servings => $composableBuilder(
      column: $table.servings, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastAccessedAt => $composableBuilder(
      column: $table.lastAccessedAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> mealItemTableRefs(
      Expression<bool> Function($$MealItemTableTableFilterComposer f) f) {
    final $$MealItemTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.mealItemTable,
        getReferencedColumn: (t) => t.externalRecipeId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MealItemTableTableFilterComposer(
              $db: $db,
              $table: $db.mealItemTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ExternalRecipeTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ExternalRecipeTableTable> {
  $$ExternalRecipeTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get url => $composableBuilder(
      column: $table.url, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imageUrl => $composableBuilder(
      column: $table.imageUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get siteName => $composableBuilder(
      column: $table.siteName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
      column: $table.isFavorite, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get memo => $composableBuilder(
      column: $table.memo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ingredientsJson => $composableBuilder(
      column: $table.ingredientsJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ingredientsRawText => $composableBuilder(
      column: $table.ingredientsRawText,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get calories => $composableBuilder(
      column: $table.calories, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get protein => $composableBuilder(
      column: $table.protein, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get fat => $composableBuilder(
      column: $table.fat, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get carbohydrate => $composableBuilder(
      column: $table.carbohydrate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get salt => $composableBuilder(
      column: $table.salt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get fiber => $composableBuilder(
      column: $table.fiber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get vitaminC => $composableBuilder(
      column: $table.vitaminC, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isNutritionAutoExtracted => $composableBuilder(
      column: $table.isNutritionAutoExtracted,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get servings => $composableBuilder(
      column: $table.servings, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastAccessedAt => $composableBuilder(
      column: $table.lastAccessedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$ExternalRecipeTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExternalRecipeTableTable> {
  $$ExternalRecipeTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<String> get siteName =>
      $composableBuilder(column: $table.siteName, builder: (column) => column);

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
      column: $table.isFavorite, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<String> get memo =>
      $composableBuilder(column: $table.memo, builder: (column) => column);

  GeneratedColumn<String> get ingredientsJson => $composableBuilder(
      column: $table.ingredientsJson, builder: (column) => column);

  GeneratedColumn<String> get ingredientsRawText => $composableBuilder(
      column: $table.ingredientsRawText, builder: (column) => column);

  GeneratedColumn<double> get calories =>
      $composableBuilder(column: $table.calories, builder: (column) => column);

  GeneratedColumn<double> get protein =>
      $composableBuilder(column: $table.protein, builder: (column) => column);

  GeneratedColumn<double> get fat =>
      $composableBuilder(column: $table.fat, builder: (column) => column);

  GeneratedColumn<double> get carbohydrate => $composableBuilder(
      column: $table.carbohydrate, builder: (column) => column);

  GeneratedColumn<double> get salt =>
      $composableBuilder(column: $table.salt, builder: (column) => column);

  GeneratedColumn<double> get fiber =>
      $composableBuilder(column: $table.fiber, builder: (column) => column);

  GeneratedColumn<double> get vitaminC =>
      $composableBuilder(column: $table.vitaminC, builder: (column) => column);

  GeneratedColumn<bool> get isNutritionAutoExtracted => $composableBuilder(
      column: $table.isNutritionAutoExtracted, builder: (column) => column);

  GeneratedColumn<int> get servings =>
      $composableBuilder(column: $table.servings, builder: (column) => column);

  GeneratedColumn<DateTime> get lastAccessedAt => $composableBuilder(
      column: $table.lastAccessedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> mealItemTableRefs<T extends Object>(
      Expression<T> Function($$MealItemTableTableAnnotationComposer a) f) {
    final $$MealItemTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.mealItemTable,
        getReferencedColumn: (t) => t.externalRecipeId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MealItemTableTableAnnotationComposer(
              $db: $db,
              $table: $db.mealItemTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ExternalRecipeTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ExternalRecipeTableTable,
    ExternalRecipeTableData,
    $$ExternalRecipeTableTableFilterComposer,
    $$ExternalRecipeTableTableOrderingComposer,
    $$ExternalRecipeTableTableAnnotationComposer,
    $$ExternalRecipeTableTableCreateCompanionBuilder,
    $$ExternalRecipeTableTableUpdateCompanionBuilder,
    (ExternalRecipeTableData, $$ExternalRecipeTableTableReferences),
    ExternalRecipeTableData,
    PrefetchHooks Function({bool mealItemTableRefs})> {
  $$ExternalRecipeTableTableTableManager(
      _$AppDatabase db, $ExternalRecipeTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExternalRecipeTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExternalRecipeTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExternalRecipeTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> url = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> imageUrl = const Value.absent(),
            Value<String?> siteName = const Value.absent(),
            Value<bool> isFavorite = const Value.absent(),
            Value<String?> tags = const Value.absent(),
            Value<String?> memo = const Value.absent(),
            Value<String?> ingredientsJson = const Value.absent(),
            Value<String?> ingredientsRawText = const Value.absent(),
            Value<double?> calories = const Value.absent(),
            Value<double?> protein = const Value.absent(),
            Value<double?> fat = const Value.absent(),
            Value<double?> carbohydrate = const Value.absent(),
            Value<double?> salt = const Value.absent(),
            Value<double?> fiber = const Value.absent(),
            Value<double?> vitaminC = const Value.absent(),
            Value<bool> isNutritionAutoExtracted = const Value.absent(),
            Value<int> servings = const Value.absent(),
            Value<DateTime?> lastAccessedAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              ExternalRecipeTableCompanion(
            id: id,
            url: url,
            title: title,
            description: description,
            imageUrl: imageUrl,
            siteName: siteName,
            isFavorite: isFavorite,
            tags: tags,
            memo: memo,
            ingredientsJson: ingredientsJson,
            ingredientsRawText: ingredientsRawText,
            calories: calories,
            protein: protein,
            fat: fat,
            carbohydrate: carbohydrate,
            salt: salt,
            fiber: fiber,
            vitaminC: vitaminC,
            isNutritionAutoExtracted: isNutritionAutoExtracted,
            servings: servings,
            lastAccessedAt: lastAccessedAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String url,
            required String title,
            Value<String?> description = const Value.absent(),
            Value<String?> imageUrl = const Value.absent(),
            Value<String?> siteName = const Value.absent(),
            Value<bool> isFavorite = const Value.absent(),
            Value<String?> tags = const Value.absent(),
            Value<String?> memo = const Value.absent(),
            Value<String?> ingredientsJson = const Value.absent(),
            Value<String?> ingredientsRawText = const Value.absent(),
            Value<double?> calories = const Value.absent(),
            Value<double?> protein = const Value.absent(),
            Value<double?> fat = const Value.absent(),
            Value<double?> carbohydrate = const Value.absent(),
            Value<double?> salt = const Value.absent(),
            Value<double?> fiber = const Value.absent(),
            Value<double?> vitaminC = const Value.absent(),
            Value<bool> isNutritionAutoExtracted = const Value.absent(),
            Value<int> servings = const Value.absent(),
            Value<DateTime?> lastAccessedAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              ExternalRecipeTableCompanion.insert(
            id: id,
            url: url,
            title: title,
            description: description,
            imageUrl: imageUrl,
            siteName: siteName,
            isFavorite: isFavorite,
            tags: tags,
            memo: memo,
            ingredientsJson: ingredientsJson,
            ingredientsRawText: ingredientsRawText,
            calories: calories,
            protein: protein,
            fat: fat,
            carbohydrate: carbohydrate,
            salt: salt,
            fiber: fiber,
            vitaminC: vitaminC,
            isNutritionAutoExtracted: isNutritionAutoExtracted,
            servings: servings,
            lastAccessedAt: lastAccessedAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ExternalRecipeTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({mealItemTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (mealItemTableRefs) db.mealItemTable
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (mealItemTableRefs)
                    await $_getPrefetchedData<ExternalRecipeTableData,
                            $ExternalRecipeTableTable, MealItemTableData>(
                        currentTable: table,
                        referencedTable: $$ExternalRecipeTableTableReferences
                            ._mealItemTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ExternalRecipeTableTableReferences(db, table, p0)
                                .mealItemTableRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.externalRecipeId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ExternalRecipeTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ExternalRecipeTableTable,
    ExternalRecipeTableData,
    $$ExternalRecipeTableTableFilterComposer,
    $$ExternalRecipeTableTableOrderingComposer,
    $$ExternalRecipeTableTableAnnotationComposer,
    $$ExternalRecipeTableTableCreateCompanionBuilder,
    $$ExternalRecipeTableTableUpdateCompanionBuilder,
    (ExternalRecipeTableData, $$ExternalRecipeTableTableReferences),
    ExternalRecipeTableData,
    PrefetchHooks Function({bool mealItemTableRefs})>;
typedef $$MealItemTableTableCreateCompanionBuilder = MealItemTableCompanion
    Function({
  Value<int> id,
  required int mealId,
  required String foodName,
  Value<double> quantity,
  Value<String> unit,
  Value<double> calories,
  Value<double> protein,
  Value<double> fat,
  Value<double> carbs,
  Value<int?> externalRecipeId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$MealItemTableTableUpdateCompanionBuilder = MealItemTableCompanion
    Function({
  Value<int> id,
  Value<int> mealId,
  Value<String> foodName,
  Value<double> quantity,
  Value<String> unit,
  Value<double> calories,
  Value<double> protein,
  Value<double> fat,
  Value<double> carbs,
  Value<int?> externalRecipeId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$MealItemTableTableReferences extends BaseReferences<_$AppDatabase,
    $MealItemTableTable, MealItemTableData> {
  $$MealItemTableTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $MealTableTable _mealIdTable(_$AppDatabase db) =>
      db.mealTable.createAlias(
          $_aliasNameGenerator(db.mealItemTable.mealId, db.mealTable.id));

  $$MealTableTableProcessedTableManager get mealId {
    final $_column = $_itemColumn<int>('meal_id')!;

    final manager = $$MealTableTableTableManager($_db, $_db.mealTable)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_mealIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $ExternalRecipeTableTable _externalRecipeIdTable(_$AppDatabase db) =>
      db.externalRecipeTable.createAlias($_aliasNameGenerator(
          db.mealItemTable.externalRecipeId, db.externalRecipeTable.id));

  $$ExternalRecipeTableTableProcessedTableManager? get externalRecipeId {
    final $_column = $_itemColumn<int>('external_recipe_id');
    if ($_column == null) return null;
    final manager =
        $$ExternalRecipeTableTableTableManager($_db, $_db.externalRecipeTable)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_externalRecipeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$MealItemTableTableFilterComposer
    extends Composer<_$AppDatabase, $MealItemTableTable> {
  $$MealItemTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get foodName => $composableBuilder(
      column: $table.foodName, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get calories => $composableBuilder(
      column: $table.calories, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get protein => $composableBuilder(
      column: $table.protein, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get fat => $composableBuilder(
      column: $table.fat, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get carbs => $composableBuilder(
      column: $table.carbs, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$MealTableTableFilterComposer get mealId {
    final $$MealTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.mealId,
        referencedTable: $db.mealTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MealTableTableFilterComposer(
              $db: $db,
              $table: $db.mealTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ExternalRecipeTableTableFilterComposer get externalRecipeId {
    final $$ExternalRecipeTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.externalRecipeId,
        referencedTable: $db.externalRecipeTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExternalRecipeTableTableFilterComposer(
              $db: $db,
              $table: $db.externalRecipeTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MealItemTableTableOrderingComposer
    extends Composer<_$AppDatabase, $MealItemTableTable> {
  $$MealItemTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get foodName => $composableBuilder(
      column: $table.foodName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get calories => $composableBuilder(
      column: $table.calories, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get protein => $composableBuilder(
      column: $table.protein, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get fat => $composableBuilder(
      column: $table.fat, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get carbs => $composableBuilder(
      column: $table.carbs, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$MealTableTableOrderingComposer get mealId {
    final $$MealTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.mealId,
        referencedTable: $db.mealTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MealTableTableOrderingComposer(
              $db: $db,
              $table: $db.mealTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ExternalRecipeTableTableOrderingComposer get externalRecipeId {
    final $$ExternalRecipeTableTableOrderingComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.externalRecipeId,
            referencedTable: $db.externalRecipeTable,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ExternalRecipeTableTableOrderingComposer(
                  $db: $db,
                  $table: $db.externalRecipeTable,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }
}

class $$MealItemTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $MealItemTableTable> {
  $$MealItemTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get foodName =>
      $composableBuilder(column: $table.foodName, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<double> get calories =>
      $composableBuilder(column: $table.calories, builder: (column) => column);

  GeneratedColumn<double> get protein =>
      $composableBuilder(column: $table.protein, builder: (column) => column);

  GeneratedColumn<double> get fat =>
      $composableBuilder(column: $table.fat, builder: (column) => column);

  GeneratedColumn<double> get carbs =>
      $composableBuilder(column: $table.carbs, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$MealTableTableAnnotationComposer get mealId {
    final $$MealTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.mealId,
        referencedTable: $db.mealTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MealTableTableAnnotationComposer(
              $db: $db,
              $table: $db.mealTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ExternalRecipeTableTableAnnotationComposer get externalRecipeId {
    final $$ExternalRecipeTableTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.externalRecipeId,
            referencedTable: $db.externalRecipeTable,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ExternalRecipeTableTableAnnotationComposer(
                  $db: $db,
                  $table: $db.externalRecipeTable,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }
}

class $$MealItemTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MealItemTableTable,
    MealItemTableData,
    $$MealItemTableTableFilterComposer,
    $$MealItemTableTableOrderingComposer,
    $$MealItemTableTableAnnotationComposer,
    $$MealItemTableTableCreateCompanionBuilder,
    $$MealItemTableTableUpdateCompanionBuilder,
    (MealItemTableData, $$MealItemTableTableReferences),
    MealItemTableData,
    PrefetchHooks Function({bool mealId, bool externalRecipeId})> {
  $$MealItemTableTableTableManager(_$AppDatabase db, $MealItemTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MealItemTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MealItemTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MealItemTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> mealId = const Value.absent(),
            Value<String> foodName = const Value.absent(),
            Value<double> quantity = const Value.absent(),
            Value<String> unit = const Value.absent(),
            Value<double> calories = const Value.absent(),
            Value<double> protein = const Value.absent(),
            Value<double> fat = const Value.absent(),
            Value<double> carbs = const Value.absent(),
            Value<int?> externalRecipeId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              MealItemTableCompanion(
            id: id,
            mealId: mealId,
            foodName: foodName,
            quantity: quantity,
            unit: unit,
            calories: calories,
            protein: protein,
            fat: fat,
            carbs: carbs,
            externalRecipeId: externalRecipeId,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int mealId,
            required String foodName,
            Value<double> quantity = const Value.absent(),
            Value<String> unit = const Value.absent(),
            Value<double> calories = const Value.absent(),
            Value<double> protein = const Value.absent(),
            Value<double> fat = const Value.absent(),
            Value<double> carbs = const Value.absent(),
            Value<int?> externalRecipeId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              MealItemTableCompanion.insert(
            id: id,
            mealId: mealId,
            foodName: foodName,
            quantity: quantity,
            unit: unit,
            calories: calories,
            protein: protein,
            fat: fat,
            carbs: carbs,
            externalRecipeId: externalRecipeId,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$MealItemTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({mealId = false, externalRecipeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (mealId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.mealId,
                    referencedTable:
                        $$MealItemTableTableReferences._mealIdTable(db),
                    referencedColumn:
                        $$MealItemTableTableReferences._mealIdTable(db).id,
                  ) as T;
                }
                if (externalRecipeId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.externalRecipeId,
                    referencedTable: $$MealItemTableTableReferences
                        ._externalRecipeIdTable(db),
                    referencedColumn: $$MealItemTableTableReferences
                        ._externalRecipeIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$MealItemTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MealItemTableTable,
    MealItemTableData,
    $$MealItemTableTableFilterComposer,
    $$MealItemTableTableOrderingComposer,
    $$MealItemTableTableAnnotationComposer,
    $$MealItemTableTableCreateCompanionBuilder,
    $$MealItemTableTableUpdateCompanionBuilder,
    (MealItemTableData, $$MealItemTableTableReferences),
    MealItemTableData,
    PrefetchHooks Function({bool mealId, bool externalRecipeId})>;
typedef $$PersonalDataTableTableCreateCompanionBuilder
    = PersonalDataTableCompanion Function({
  required DateTime recordedDate,
  Value<double?> weight,
  Value<double?> bodyFatPercentage,
  Value<int?> steps,
  Value<double?> activeEnergy,
  Value<int?> exerciseTime,
  Value<double?> sleepHours,
  Value<String> dataSource,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$PersonalDataTableTableUpdateCompanionBuilder
    = PersonalDataTableCompanion Function({
  Value<DateTime> recordedDate,
  Value<double?> weight,
  Value<double?> bodyFatPercentage,
  Value<int?> steps,
  Value<double?> activeEnergy,
  Value<int?> exerciseTime,
  Value<double?> sleepHours,
  Value<String> dataSource,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$PersonalDataTableTableFilterComposer
    extends Composer<_$AppDatabase, $PersonalDataTableTable> {
  $$PersonalDataTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get recordedDate => $composableBuilder(
      column: $table.recordedDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get weight => $composableBuilder(
      column: $table.weight, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get bodyFatPercentage => $composableBuilder(
      column: $table.bodyFatPercentage,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get steps => $composableBuilder(
      column: $table.steps, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get activeEnergy => $composableBuilder(
      column: $table.activeEnergy, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get exerciseTime => $composableBuilder(
      column: $table.exerciseTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get sleepHours => $composableBuilder(
      column: $table.sleepHours, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dataSource => $composableBuilder(
      column: $table.dataSource, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$PersonalDataTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PersonalDataTableTable> {
  $$PersonalDataTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get recordedDate => $composableBuilder(
      column: $table.recordedDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get weight => $composableBuilder(
      column: $table.weight, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get bodyFatPercentage => $composableBuilder(
      column: $table.bodyFatPercentage,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get steps => $composableBuilder(
      column: $table.steps, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get activeEnergy => $composableBuilder(
      column: $table.activeEnergy,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get exerciseTime => $composableBuilder(
      column: $table.exerciseTime,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get sleepHours => $composableBuilder(
      column: $table.sleepHours, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dataSource => $composableBuilder(
      column: $table.dataSource, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$PersonalDataTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PersonalDataTableTable> {
  $$PersonalDataTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get recordedDate => $composableBuilder(
      column: $table.recordedDate, builder: (column) => column);

  GeneratedColumn<double> get weight =>
      $composableBuilder(column: $table.weight, builder: (column) => column);

  GeneratedColumn<double> get bodyFatPercentage => $composableBuilder(
      column: $table.bodyFatPercentage, builder: (column) => column);

  GeneratedColumn<int> get steps =>
      $composableBuilder(column: $table.steps, builder: (column) => column);

  GeneratedColumn<double> get activeEnergy => $composableBuilder(
      column: $table.activeEnergy, builder: (column) => column);

  GeneratedColumn<int> get exerciseTime => $composableBuilder(
      column: $table.exerciseTime, builder: (column) => column);

  GeneratedColumn<double> get sleepHours => $composableBuilder(
      column: $table.sleepHours, builder: (column) => column);

  GeneratedColumn<String> get dataSource => $composableBuilder(
      column: $table.dataSource, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$PersonalDataTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PersonalDataTableTable,
    PersonalDataTableData,
    $$PersonalDataTableTableFilterComposer,
    $$PersonalDataTableTableOrderingComposer,
    $$PersonalDataTableTableAnnotationComposer,
    $$PersonalDataTableTableCreateCompanionBuilder,
    $$PersonalDataTableTableUpdateCompanionBuilder,
    (
      PersonalDataTableData,
      BaseReferences<_$AppDatabase, $PersonalDataTableTable,
          PersonalDataTableData>
    ),
    PersonalDataTableData,
    PrefetchHooks Function()> {
  $$PersonalDataTableTableTableManager(
      _$AppDatabase db, $PersonalDataTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PersonalDataTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PersonalDataTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PersonalDataTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<DateTime> recordedDate = const Value.absent(),
            Value<double?> weight = const Value.absent(),
            Value<double?> bodyFatPercentage = const Value.absent(),
            Value<int?> steps = const Value.absent(),
            Value<double?> activeEnergy = const Value.absent(),
            Value<int?> exerciseTime = const Value.absent(),
            Value<double?> sleepHours = const Value.absent(),
            Value<String> dataSource = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PersonalDataTableCompanion(
            recordedDate: recordedDate,
            weight: weight,
            bodyFatPercentage: bodyFatPercentage,
            steps: steps,
            activeEnergy: activeEnergy,
            exerciseTime: exerciseTime,
            sleepHours: sleepHours,
            dataSource: dataSource,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required DateTime recordedDate,
            Value<double?> weight = const Value.absent(),
            Value<double?> bodyFatPercentage = const Value.absent(),
            Value<int?> steps = const Value.absent(),
            Value<double?> activeEnergy = const Value.absent(),
            Value<int?> exerciseTime = const Value.absent(),
            Value<double?> sleepHours = const Value.absent(),
            Value<String> dataSource = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PersonalDataTableCompanion.insert(
            recordedDate: recordedDate,
            weight: weight,
            bodyFatPercentage: bodyFatPercentage,
            steps: steps,
            activeEnergy: activeEnergy,
            exerciseTime: exerciseTime,
            sleepHours: sleepHours,
            dataSource: dataSource,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PersonalDataTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PersonalDataTableTable,
    PersonalDataTableData,
    $$PersonalDataTableTableFilterComposer,
    $$PersonalDataTableTableOrderingComposer,
    $$PersonalDataTableTableAnnotationComposer,
    $$PersonalDataTableTableCreateCompanionBuilder,
    $$PersonalDataTableTableUpdateCompanionBuilder,
    (
      PersonalDataTableData,
      BaseReferences<_$AppDatabase, $PersonalDataTableTable,
          PersonalDataTableData>
    ),
    PersonalDataTableData,
    PrefetchHooks Function()>;
typedef $$FoodItemTableTableCreateCompanionBuilder = FoodItemTableCompanion
    Function({
  Value<int> id,
  required String name,
  required String category,
  Value<double> quantity,
  Value<String> unit,
  Value<DateTime?> purchaseDate,
  Value<DateTime?> expiryDate,
  Value<String?> storageLocation,
  Value<String?> memo,
  Value<bool> isOutOfStock,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$FoodItemTableTableUpdateCompanionBuilder = FoodItemTableCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<String> category,
  Value<double> quantity,
  Value<String> unit,
  Value<DateTime?> purchaseDate,
  Value<DateTime?> expiryDate,
  Value<String?> storageLocation,
  Value<String?> memo,
  Value<bool> isOutOfStock,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

class $$FoodItemTableTableFilterComposer
    extends Composer<_$AppDatabase, $FoodItemTableTable> {
  $$FoodItemTableTableFilterComposer({
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

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get purchaseDate => $composableBuilder(
      column: $table.purchaseDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get expiryDate => $composableBuilder(
      column: $table.expiryDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get storageLocation => $composableBuilder(
      column: $table.storageLocation,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get memo => $composableBuilder(
      column: $table.memo, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isOutOfStock => $composableBuilder(
      column: $table.isOutOfStock, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$FoodItemTableTableOrderingComposer
    extends Composer<_$AppDatabase, $FoodItemTableTable> {
  $$FoodItemTableTableOrderingComposer({
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

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get purchaseDate => $composableBuilder(
      column: $table.purchaseDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get expiryDate => $composableBuilder(
      column: $table.expiryDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get storageLocation => $composableBuilder(
      column: $table.storageLocation,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get memo => $composableBuilder(
      column: $table.memo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isOutOfStock => $composableBuilder(
      column: $table.isOutOfStock,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$FoodItemTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $FoodItemTableTable> {
  $$FoodItemTableTableAnnotationComposer({
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

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<DateTime> get purchaseDate => $composableBuilder(
      column: $table.purchaseDate, builder: (column) => column);

  GeneratedColumn<DateTime> get expiryDate => $composableBuilder(
      column: $table.expiryDate, builder: (column) => column);

  GeneratedColumn<String> get storageLocation => $composableBuilder(
      column: $table.storageLocation, builder: (column) => column);

  GeneratedColumn<String> get memo =>
      $composableBuilder(column: $table.memo, builder: (column) => column);

  GeneratedColumn<bool> get isOutOfStock => $composableBuilder(
      column: $table.isOutOfStock, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$FoodItemTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FoodItemTableTable,
    FoodItemTableData,
    $$FoodItemTableTableFilterComposer,
    $$FoodItemTableTableOrderingComposer,
    $$FoodItemTableTableAnnotationComposer,
    $$FoodItemTableTableCreateCompanionBuilder,
    $$FoodItemTableTableUpdateCompanionBuilder,
    (
      FoodItemTableData,
      BaseReferences<_$AppDatabase, $FoodItemTableTable, FoodItemTableData>
    ),
    FoodItemTableData,
    PrefetchHooks Function()> {
  $$FoodItemTableTableTableManager(_$AppDatabase db, $FoodItemTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FoodItemTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FoodItemTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FoodItemTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<double> quantity = const Value.absent(),
            Value<String> unit = const Value.absent(),
            Value<DateTime?> purchaseDate = const Value.absent(),
            Value<DateTime?> expiryDate = const Value.absent(),
            Value<String?> storageLocation = const Value.absent(),
            Value<String?> memo = const Value.absent(),
            Value<bool> isOutOfStock = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              FoodItemTableCompanion(
            id: id,
            name: name,
            category: category,
            quantity: quantity,
            unit: unit,
            purchaseDate: purchaseDate,
            expiryDate: expiryDate,
            storageLocation: storageLocation,
            memo: memo,
            isOutOfStock: isOutOfStock,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String category,
            Value<double> quantity = const Value.absent(),
            Value<String> unit = const Value.absent(),
            Value<DateTime?> purchaseDate = const Value.absent(),
            Value<DateTime?> expiryDate = const Value.absent(),
            Value<String?> storageLocation = const Value.absent(),
            Value<String?> memo = const Value.absent(),
            Value<bool> isOutOfStock = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              FoodItemTableCompanion.insert(
            id: id,
            name: name,
            category: category,
            quantity: quantity,
            unit: unit,
            purchaseDate: purchaseDate,
            expiryDate: expiryDate,
            storageLocation: storageLocation,
            memo: memo,
            isOutOfStock: isOutOfStock,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FoodItemTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FoodItemTableTable,
    FoodItemTableData,
    $$FoodItemTableTableFilterComposer,
    $$FoodItemTableTableOrderingComposer,
    $$FoodItemTableTableAnnotationComposer,
    $$FoodItemTableTableCreateCompanionBuilder,
    $$FoodItemTableTableUpdateCompanionBuilder,
    (
      FoodItemTableData,
      BaseReferences<_$AppDatabase, $FoodItemTableTable, FoodItemTableData>
    ),
    FoodItemTableData,
    PrefetchHooks Function()>;
typedef $$RecipeTableTableCreateCompanionBuilder = RecipeTableCompanion
    Function({
  Value<int> id,
  required String name,
  required String category,
  Value<int?> cookingTime,
  Value<int> servings,
  required String ingredients,
  required String instructions,
  Value<double?> calories,
  Value<double?> protein,
  Value<double?> fat,
  Value<double?> carbs,
  Value<String?> imagePath,
  Value<bool> isFavorite,
  Value<String?> tags,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$RecipeTableTableUpdateCompanionBuilder = RecipeTableCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<String> category,
  Value<int?> cookingTime,
  Value<int> servings,
  Value<String> ingredients,
  Value<String> instructions,
  Value<double?> calories,
  Value<double?> protein,
  Value<double?> fat,
  Value<double?> carbs,
  Value<String?> imagePath,
  Value<bool> isFavorite,
  Value<String?> tags,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

class $$RecipeTableTableFilterComposer
    extends Composer<_$AppDatabase, $RecipeTableTable> {
  $$RecipeTableTableFilterComposer({
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

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get cookingTime => $composableBuilder(
      column: $table.cookingTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get servings => $composableBuilder(
      column: $table.servings, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ingredients => $composableBuilder(
      column: $table.ingredients, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get instructions => $composableBuilder(
      column: $table.instructions, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get calories => $composableBuilder(
      column: $table.calories, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get protein => $composableBuilder(
      column: $table.protein, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get fat => $composableBuilder(
      column: $table.fat, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get carbs => $composableBuilder(
      column: $table.carbs, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imagePath => $composableBuilder(
      column: $table.imagePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isFavorite => $composableBuilder(
      column: $table.isFavorite, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$RecipeTableTableOrderingComposer
    extends Composer<_$AppDatabase, $RecipeTableTable> {
  $$RecipeTableTableOrderingComposer({
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

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get cookingTime => $composableBuilder(
      column: $table.cookingTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get servings => $composableBuilder(
      column: $table.servings, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ingredients => $composableBuilder(
      column: $table.ingredients, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get instructions => $composableBuilder(
      column: $table.instructions,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get calories => $composableBuilder(
      column: $table.calories, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get protein => $composableBuilder(
      column: $table.protein, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get fat => $composableBuilder(
      column: $table.fat, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get carbs => $composableBuilder(
      column: $table.carbs, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imagePath => $composableBuilder(
      column: $table.imagePath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
      column: $table.isFavorite, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$RecipeTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecipeTableTable> {
  $$RecipeTableTableAnnotationComposer({
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

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get cookingTime => $composableBuilder(
      column: $table.cookingTime, builder: (column) => column);

  GeneratedColumn<int> get servings =>
      $composableBuilder(column: $table.servings, builder: (column) => column);

  GeneratedColumn<String> get ingredients => $composableBuilder(
      column: $table.ingredients, builder: (column) => column);

  GeneratedColumn<String> get instructions => $composableBuilder(
      column: $table.instructions, builder: (column) => column);

  GeneratedColumn<double> get calories =>
      $composableBuilder(column: $table.calories, builder: (column) => column);

  GeneratedColumn<double> get protein =>
      $composableBuilder(column: $table.protein, builder: (column) => column);

  GeneratedColumn<double> get fat =>
      $composableBuilder(column: $table.fat, builder: (column) => column);

  GeneratedColumn<double> get carbs =>
      $composableBuilder(column: $table.carbs, builder: (column) => column);

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
      column: $table.isFavorite, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$RecipeTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RecipeTableTable,
    RecipeTableData,
    $$RecipeTableTableFilterComposer,
    $$RecipeTableTableOrderingComposer,
    $$RecipeTableTableAnnotationComposer,
    $$RecipeTableTableCreateCompanionBuilder,
    $$RecipeTableTableUpdateCompanionBuilder,
    (
      RecipeTableData,
      BaseReferences<_$AppDatabase, $RecipeTableTable, RecipeTableData>
    ),
    RecipeTableData,
    PrefetchHooks Function()> {
  $$RecipeTableTableTableManager(_$AppDatabase db, $RecipeTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecipeTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecipeTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecipeTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<int?> cookingTime = const Value.absent(),
            Value<int> servings = const Value.absent(),
            Value<String> ingredients = const Value.absent(),
            Value<String> instructions = const Value.absent(),
            Value<double?> calories = const Value.absent(),
            Value<double?> protein = const Value.absent(),
            Value<double?> fat = const Value.absent(),
            Value<double?> carbs = const Value.absent(),
            Value<String?> imagePath = const Value.absent(),
            Value<bool> isFavorite = const Value.absent(),
            Value<String?> tags = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              RecipeTableCompanion(
            id: id,
            name: name,
            category: category,
            cookingTime: cookingTime,
            servings: servings,
            ingredients: ingredients,
            instructions: instructions,
            calories: calories,
            protein: protein,
            fat: fat,
            carbs: carbs,
            imagePath: imagePath,
            isFavorite: isFavorite,
            tags: tags,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String category,
            Value<int?> cookingTime = const Value.absent(),
            Value<int> servings = const Value.absent(),
            required String ingredients,
            required String instructions,
            Value<double?> calories = const Value.absent(),
            Value<double?> protein = const Value.absent(),
            Value<double?> fat = const Value.absent(),
            Value<double?> carbs = const Value.absent(),
            Value<String?> imagePath = const Value.absent(),
            Value<bool> isFavorite = const Value.absent(),
            Value<String?> tags = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              RecipeTableCompanion.insert(
            id: id,
            name: name,
            category: category,
            cookingTime: cookingTime,
            servings: servings,
            ingredients: ingredients,
            instructions: instructions,
            calories: calories,
            protein: protein,
            fat: fat,
            carbs: carbs,
            imagePath: imagePath,
            isFavorite: isFavorite,
            tags: tags,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$RecipeTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RecipeTableTable,
    RecipeTableData,
    $$RecipeTableTableFilterComposer,
    $$RecipeTableTableOrderingComposer,
    $$RecipeTableTableAnnotationComposer,
    $$RecipeTableTableCreateCompanionBuilder,
    $$RecipeTableTableUpdateCompanionBuilder,
    (
      RecipeTableData,
      BaseReferences<_$AppDatabase, $RecipeTableTable, RecipeTableData>
    ),
    RecipeTableData,
    PrefetchHooks Function()>;
typedef $$JapaneseFoodCompositionTableTableCreateCompanionBuilder
    = JapaneseFoodCompositionTableCompanion Function({
  Value<int> id,
  required int groupId,
  required int foodId,
  required int indexId,
  required String foodName,
  Value<double> refuse,
  Value<double?> enerc,
  Value<double?> enercKcal,
  Value<double?> water,
  Value<double?> protcaa,
  Value<double?> prot,
  Value<double?> fatnlea,
  Value<double?> chole,
  Value<double?> fat,
  Value<double?> choavlm,
  Value<double?> choavl,
  Value<double?> choavldf,
  Value<double?> fib,
  Value<double?> polyl,
  Value<double?> chocdf,
  Value<double?> oa,
  Value<double?> ash,
  Value<double?> na,
  Value<double?> k,
  Value<double?> ca,
  Value<double?> mg,
  Value<double?> p,
  Value<double?> fe,
  Value<double?> zn,
  Value<double?> cu,
  Value<double?> mn,
  Value<double?> iodine,
  Value<double?> se,
  Value<double?> cr,
  Value<double?> mo,
  Value<double?> retol,
  Value<double?> carta,
  Value<double?> cartb,
  Value<double?> crypxb,
  Value<double?> cartbeq,
  Value<double?> vitaRae,
  Value<double?> vitD,
  Value<double?> tocphA,
  Value<double?> tocphB,
  Value<double?> tocphG,
  Value<double?> tocphD,
  Value<double?> vitK,
  Value<double?> thia,
  Value<double?> ribf,
  Value<double?> nia,
  Value<double?> ne,
  Value<double?> vitB6A,
  Value<double?> vitB12,
  Value<double?> fol,
  Value<double?> pantac,
  Value<double?> biot,
  Value<double?> vitC,
  Value<double?> alc,
  Value<double?> naclEq,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$JapaneseFoodCompositionTableTableUpdateCompanionBuilder
    = JapaneseFoodCompositionTableCompanion Function({
  Value<int> id,
  Value<int> groupId,
  Value<int> foodId,
  Value<int> indexId,
  Value<String> foodName,
  Value<double> refuse,
  Value<double?> enerc,
  Value<double?> enercKcal,
  Value<double?> water,
  Value<double?> protcaa,
  Value<double?> prot,
  Value<double?> fatnlea,
  Value<double?> chole,
  Value<double?> fat,
  Value<double?> choavlm,
  Value<double?> choavl,
  Value<double?> choavldf,
  Value<double?> fib,
  Value<double?> polyl,
  Value<double?> chocdf,
  Value<double?> oa,
  Value<double?> ash,
  Value<double?> na,
  Value<double?> k,
  Value<double?> ca,
  Value<double?> mg,
  Value<double?> p,
  Value<double?> fe,
  Value<double?> zn,
  Value<double?> cu,
  Value<double?> mn,
  Value<double?> iodine,
  Value<double?> se,
  Value<double?> cr,
  Value<double?> mo,
  Value<double?> retol,
  Value<double?> carta,
  Value<double?> cartb,
  Value<double?> crypxb,
  Value<double?> cartbeq,
  Value<double?> vitaRae,
  Value<double?> vitD,
  Value<double?> tocphA,
  Value<double?> tocphB,
  Value<double?> tocphG,
  Value<double?> tocphD,
  Value<double?> vitK,
  Value<double?> thia,
  Value<double?> ribf,
  Value<double?> nia,
  Value<double?> ne,
  Value<double?> vitB6A,
  Value<double?> vitB12,
  Value<double?> fol,
  Value<double?> pantac,
  Value<double?> biot,
  Value<double?> vitC,
  Value<double?> alc,
  Value<double?> naclEq,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

class $$JapaneseFoodCompositionTableTableFilterComposer
    extends Composer<_$AppDatabase, $JapaneseFoodCompositionTableTable> {
  $$JapaneseFoodCompositionTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get groupId => $composableBuilder(
      column: $table.groupId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get foodId => $composableBuilder(
      column: $table.foodId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get indexId => $composableBuilder(
      column: $table.indexId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get foodName => $composableBuilder(
      column: $table.foodName, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get refuse => $composableBuilder(
      column: $table.refuse, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get enerc => $composableBuilder(
      column: $table.enerc, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get enercKcal => $composableBuilder(
      column: $table.enercKcal, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get water => $composableBuilder(
      column: $table.water, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get protcaa => $composableBuilder(
      column: $table.protcaa, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get prot => $composableBuilder(
      column: $table.prot, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get fatnlea => $composableBuilder(
      column: $table.fatnlea, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get chole => $composableBuilder(
      column: $table.chole, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get fat => $composableBuilder(
      column: $table.fat, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get choavlm => $composableBuilder(
      column: $table.choavlm, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get choavl => $composableBuilder(
      column: $table.choavl, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get choavldf => $composableBuilder(
      column: $table.choavldf, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get fib => $composableBuilder(
      column: $table.fib, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get polyl => $composableBuilder(
      column: $table.polyl, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get chocdf => $composableBuilder(
      column: $table.chocdf, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get oa => $composableBuilder(
      column: $table.oa, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get ash => $composableBuilder(
      column: $table.ash, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get na => $composableBuilder(
      column: $table.na, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get k => $composableBuilder(
      column: $table.k, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get ca => $composableBuilder(
      column: $table.ca, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get mg => $composableBuilder(
      column: $table.mg, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get p => $composableBuilder(
      column: $table.p, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get fe => $composableBuilder(
      column: $table.fe, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get zn => $composableBuilder(
      column: $table.zn, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get cu => $composableBuilder(
      column: $table.cu, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get mn => $composableBuilder(
      column: $table.mn, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get iodine => $composableBuilder(
      column: $table.iodine, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get se => $composableBuilder(
      column: $table.se, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get cr => $composableBuilder(
      column: $table.cr, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get mo => $composableBuilder(
      column: $table.mo, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get retol => $composableBuilder(
      column: $table.retol, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get carta => $composableBuilder(
      column: $table.carta, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get cartb => $composableBuilder(
      column: $table.cartb, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get crypxb => $composableBuilder(
      column: $table.crypxb, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get cartbeq => $composableBuilder(
      column: $table.cartbeq, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get vitaRae => $composableBuilder(
      column: $table.vitaRae, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get vitD => $composableBuilder(
      column: $table.vitD, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get tocphA => $composableBuilder(
      column: $table.tocphA, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get tocphB => $composableBuilder(
      column: $table.tocphB, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get tocphG => $composableBuilder(
      column: $table.tocphG, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get tocphD => $composableBuilder(
      column: $table.tocphD, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get vitK => $composableBuilder(
      column: $table.vitK, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get thia => $composableBuilder(
      column: $table.thia, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get ribf => $composableBuilder(
      column: $table.ribf, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get nia => $composableBuilder(
      column: $table.nia, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get ne => $composableBuilder(
      column: $table.ne, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get vitB6A => $composableBuilder(
      column: $table.vitB6A, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get vitB12 => $composableBuilder(
      column: $table.vitB12, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get fol => $composableBuilder(
      column: $table.fol, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get pantac => $composableBuilder(
      column: $table.pantac, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get biot => $composableBuilder(
      column: $table.biot, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get vitC => $composableBuilder(
      column: $table.vitC, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get alc => $composableBuilder(
      column: $table.alc, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get naclEq => $composableBuilder(
      column: $table.naclEq, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$JapaneseFoodCompositionTableTableOrderingComposer
    extends Composer<_$AppDatabase, $JapaneseFoodCompositionTableTable> {
  $$JapaneseFoodCompositionTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get groupId => $composableBuilder(
      column: $table.groupId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get foodId => $composableBuilder(
      column: $table.foodId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get indexId => $composableBuilder(
      column: $table.indexId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get foodName => $composableBuilder(
      column: $table.foodName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get refuse => $composableBuilder(
      column: $table.refuse, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get enerc => $composableBuilder(
      column: $table.enerc, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get enercKcal => $composableBuilder(
      column: $table.enercKcal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get water => $composableBuilder(
      column: $table.water, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get protcaa => $composableBuilder(
      column: $table.protcaa, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get prot => $composableBuilder(
      column: $table.prot, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get fatnlea => $composableBuilder(
      column: $table.fatnlea, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get chole => $composableBuilder(
      column: $table.chole, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get fat => $composableBuilder(
      column: $table.fat, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get choavlm => $composableBuilder(
      column: $table.choavlm, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get choavl => $composableBuilder(
      column: $table.choavl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get choavldf => $composableBuilder(
      column: $table.choavldf, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get fib => $composableBuilder(
      column: $table.fib, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get polyl => $composableBuilder(
      column: $table.polyl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get chocdf => $composableBuilder(
      column: $table.chocdf, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get oa => $composableBuilder(
      column: $table.oa, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get ash => $composableBuilder(
      column: $table.ash, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get na => $composableBuilder(
      column: $table.na, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get k => $composableBuilder(
      column: $table.k, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get ca => $composableBuilder(
      column: $table.ca, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get mg => $composableBuilder(
      column: $table.mg, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get p => $composableBuilder(
      column: $table.p, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get fe => $composableBuilder(
      column: $table.fe, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get zn => $composableBuilder(
      column: $table.zn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get cu => $composableBuilder(
      column: $table.cu, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get mn => $composableBuilder(
      column: $table.mn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get iodine => $composableBuilder(
      column: $table.iodine, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get se => $composableBuilder(
      column: $table.se, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get cr => $composableBuilder(
      column: $table.cr, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get mo => $composableBuilder(
      column: $table.mo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get retol => $composableBuilder(
      column: $table.retol, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get carta => $composableBuilder(
      column: $table.carta, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get cartb => $composableBuilder(
      column: $table.cartb, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get crypxb => $composableBuilder(
      column: $table.crypxb, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get cartbeq => $composableBuilder(
      column: $table.cartbeq, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get vitaRae => $composableBuilder(
      column: $table.vitaRae, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get vitD => $composableBuilder(
      column: $table.vitD, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get tocphA => $composableBuilder(
      column: $table.tocphA, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get tocphB => $composableBuilder(
      column: $table.tocphB, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get tocphG => $composableBuilder(
      column: $table.tocphG, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get tocphD => $composableBuilder(
      column: $table.tocphD, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get vitK => $composableBuilder(
      column: $table.vitK, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get thia => $composableBuilder(
      column: $table.thia, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get ribf => $composableBuilder(
      column: $table.ribf, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get nia => $composableBuilder(
      column: $table.nia, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get ne => $composableBuilder(
      column: $table.ne, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get vitB6A => $composableBuilder(
      column: $table.vitB6A, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get vitB12 => $composableBuilder(
      column: $table.vitB12, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get fol => $composableBuilder(
      column: $table.fol, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get pantac => $composableBuilder(
      column: $table.pantac, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get biot => $composableBuilder(
      column: $table.biot, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get vitC => $composableBuilder(
      column: $table.vitC, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get alc => $composableBuilder(
      column: $table.alc, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get naclEq => $composableBuilder(
      column: $table.naclEq, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$JapaneseFoodCompositionTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $JapaneseFoodCompositionTableTable> {
  $$JapaneseFoodCompositionTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get groupId =>
      $composableBuilder(column: $table.groupId, builder: (column) => column);

  GeneratedColumn<int> get foodId =>
      $composableBuilder(column: $table.foodId, builder: (column) => column);

  GeneratedColumn<int> get indexId =>
      $composableBuilder(column: $table.indexId, builder: (column) => column);

  GeneratedColumn<String> get foodName =>
      $composableBuilder(column: $table.foodName, builder: (column) => column);

  GeneratedColumn<double> get refuse =>
      $composableBuilder(column: $table.refuse, builder: (column) => column);

  GeneratedColumn<double> get enerc =>
      $composableBuilder(column: $table.enerc, builder: (column) => column);

  GeneratedColumn<double> get enercKcal =>
      $composableBuilder(column: $table.enercKcal, builder: (column) => column);

  GeneratedColumn<double> get water =>
      $composableBuilder(column: $table.water, builder: (column) => column);

  GeneratedColumn<double> get protcaa =>
      $composableBuilder(column: $table.protcaa, builder: (column) => column);

  GeneratedColumn<double> get prot =>
      $composableBuilder(column: $table.prot, builder: (column) => column);

  GeneratedColumn<double> get fatnlea =>
      $composableBuilder(column: $table.fatnlea, builder: (column) => column);

  GeneratedColumn<double> get chole =>
      $composableBuilder(column: $table.chole, builder: (column) => column);

  GeneratedColumn<double> get fat =>
      $composableBuilder(column: $table.fat, builder: (column) => column);

  GeneratedColumn<double> get choavlm =>
      $composableBuilder(column: $table.choavlm, builder: (column) => column);

  GeneratedColumn<double> get choavl =>
      $composableBuilder(column: $table.choavl, builder: (column) => column);

  GeneratedColumn<double> get choavldf =>
      $composableBuilder(column: $table.choavldf, builder: (column) => column);

  GeneratedColumn<double> get fib =>
      $composableBuilder(column: $table.fib, builder: (column) => column);

  GeneratedColumn<double> get polyl =>
      $composableBuilder(column: $table.polyl, builder: (column) => column);

  GeneratedColumn<double> get chocdf =>
      $composableBuilder(column: $table.chocdf, builder: (column) => column);

  GeneratedColumn<double> get oa =>
      $composableBuilder(column: $table.oa, builder: (column) => column);

  GeneratedColumn<double> get ash =>
      $composableBuilder(column: $table.ash, builder: (column) => column);

  GeneratedColumn<double> get na =>
      $composableBuilder(column: $table.na, builder: (column) => column);

  GeneratedColumn<double> get k =>
      $composableBuilder(column: $table.k, builder: (column) => column);

  GeneratedColumn<double> get ca =>
      $composableBuilder(column: $table.ca, builder: (column) => column);

  GeneratedColumn<double> get mg =>
      $composableBuilder(column: $table.mg, builder: (column) => column);

  GeneratedColumn<double> get p =>
      $composableBuilder(column: $table.p, builder: (column) => column);

  GeneratedColumn<double> get fe =>
      $composableBuilder(column: $table.fe, builder: (column) => column);

  GeneratedColumn<double> get zn =>
      $composableBuilder(column: $table.zn, builder: (column) => column);

  GeneratedColumn<double> get cu =>
      $composableBuilder(column: $table.cu, builder: (column) => column);

  GeneratedColumn<double> get mn =>
      $composableBuilder(column: $table.mn, builder: (column) => column);

  GeneratedColumn<double> get iodine =>
      $composableBuilder(column: $table.iodine, builder: (column) => column);

  GeneratedColumn<double> get se =>
      $composableBuilder(column: $table.se, builder: (column) => column);

  GeneratedColumn<double> get cr =>
      $composableBuilder(column: $table.cr, builder: (column) => column);

  GeneratedColumn<double> get mo =>
      $composableBuilder(column: $table.mo, builder: (column) => column);

  GeneratedColumn<double> get retol =>
      $composableBuilder(column: $table.retol, builder: (column) => column);

  GeneratedColumn<double> get carta =>
      $composableBuilder(column: $table.carta, builder: (column) => column);

  GeneratedColumn<double> get cartb =>
      $composableBuilder(column: $table.cartb, builder: (column) => column);

  GeneratedColumn<double> get crypxb =>
      $composableBuilder(column: $table.crypxb, builder: (column) => column);

  GeneratedColumn<double> get cartbeq =>
      $composableBuilder(column: $table.cartbeq, builder: (column) => column);

  GeneratedColumn<double> get vitaRae =>
      $composableBuilder(column: $table.vitaRae, builder: (column) => column);

  GeneratedColumn<double> get vitD =>
      $composableBuilder(column: $table.vitD, builder: (column) => column);

  GeneratedColumn<double> get tocphA =>
      $composableBuilder(column: $table.tocphA, builder: (column) => column);

  GeneratedColumn<double> get tocphB =>
      $composableBuilder(column: $table.tocphB, builder: (column) => column);

  GeneratedColumn<double> get tocphG =>
      $composableBuilder(column: $table.tocphG, builder: (column) => column);

  GeneratedColumn<double> get tocphD =>
      $composableBuilder(column: $table.tocphD, builder: (column) => column);

  GeneratedColumn<double> get vitK =>
      $composableBuilder(column: $table.vitK, builder: (column) => column);

  GeneratedColumn<double> get thia =>
      $composableBuilder(column: $table.thia, builder: (column) => column);

  GeneratedColumn<double> get ribf =>
      $composableBuilder(column: $table.ribf, builder: (column) => column);

  GeneratedColumn<double> get nia =>
      $composableBuilder(column: $table.nia, builder: (column) => column);

  GeneratedColumn<double> get ne =>
      $composableBuilder(column: $table.ne, builder: (column) => column);

  GeneratedColumn<double> get vitB6A =>
      $composableBuilder(column: $table.vitB6A, builder: (column) => column);

  GeneratedColumn<double> get vitB12 =>
      $composableBuilder(column: $table.vitB12, builder: (column) => column);

  GeneratedColumn<double> get fol =>
      $composableBuilder(column: $table.fol, builder: (column) => column);

  GeneratedColumn<double> get pantac =>
      $composableBuilder(column: $table.pantac, builder: (column) => column);

  GeneratedColumn<double> get biot =>
      $composableBuilder(column: $table.biot, builder: (column) => column);

  GeneratedColumn<double> get vitC =>
      $composableBuilder(column: $table.vitC, builder: (column) => column);

  GeneratedColumn<double> get alc =>
      $composableBuilder(column: $table.alc, builder: (column) => column);

  GeneratedColumn<double> get naclEq =>
      $composableBuilder(column: $table.naclEq, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$JapaneseFoodCompositionTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $JapaneseFoodCompositionTableTable,
    JapaneseFoodCompositionTableData,
    $$JapaneseFoodCompositionTableTableFilterComposer,
    $$JapaneseFoodCompositionTableTableOrderingComposer,
    $$JapaneseFoodCompositionTableTableAnnotationComposer,
    $$JapaneseFoodCompositionTableTableCreateCompanionBuilder,
    $$JapaneseFoodCompositionTableTableUpdateCompanionBuilder,
    (
      JapaneseFoodCompositionTableData,
      BaseReferences<_$AppDatabase, $JapaneseFoodCompositionTableTable,
          JapaneseFoodCompositionTableData>
    ),
    JapaneseFoodCompositionTableData,
    PrefetchHooks Function()> {
  $$JapaneseFoodCompositionTableTableTableManager(
      _$AppDatabase db, $JapaneseFoodCompositionTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$JapaneseFoodCompositionTableTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$JapaneseFoodCompositionTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$JapaneseFoodCompositionTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> groupId = const Value.absent(),
            Value<int> foodId = const Value.absent(),
            Value<int> indexId = const Value.absent(),
            Value<String> foodName = const Value.absent(),
            Value<double> refuse = const Value.absent(),
            Value<double?> enerc = const Value.absent(),
            Value<double?> enercKcal = const Value.absent(),
            Value<double?> water = const Value.absent(),
            Value<double?> protcaa = const Value.absent(),
            Value<double?> prot = const Value.absent(),
            Value<double?> fatnlea = const Value.absent(),
            Value<double?> chole = const Value.absent(),
            Value<double?> fat = const Value.absent(),
            Value<double?> choavlm = const Value.absent(),
            Value<double?> choavl = const Value.absent(),
            Value<double?> choavldf = const Value.absent(),
            Value<double?> fib = const Value.absent(),
            Value<double?> polyl = const Value.absent(),
            Value<double?> chocdf = const Value.absent(),
            Value<double?> oa = const Value.absent(),
            Value<double?> ash = const Value.absent(),
            Value<double?> na = const Value.absent(),
            Value<double?> k = const Value.absent(),
            Value<double?> ca = const Value.absent(),
            Value<double?> mg = const Value.absent(),
            Value<double?> p = const Value.absent(),
            Value<double?> fe = const Value.absent(),
            Value<double?> zn = const Value.absent(),
            Value<double?> cu = const Value.absent(),
            Value<double?> mn = const Value.absent(),
            Value<double?> iodine = const Value.absent(),
            Value<double?> se = const Value.absent(),
            Value<double?> cr = const Value.absent(),
            Value<double?> mo = const Value.absent(),
            Value<double?> retol = const Value.absent(),
            Value<double?> carta = const Value.absent(),
            Value<double?> cartb = const Value.absent(),
            Value<double?> crypxb = const Value.absent(),
            Value<double?> cartbeq = const Value.absent(),
            Value<double?> vitaRae = const Value.absent(),
            Value<double?> vitD = const Value.absent(),
            Value<double?> tocphA = const Value.absent(),
            Value<double?> tocphB = const Value.absent(),
            Value<double?> tocphG = const Value.absent(),
            Value<double?> tocphD = const Value.absent(),
            Value<double?> vitK = const Value.absent(),
            Value<double?> thia = const Value.absent(),
            Value<double?> ribf = const Value.absent(),
            Value<double?> nia = const Value.absent(),
            Value<double?> ne = const Value.absent(),
            Value<double?> vitB6A = const Value.absent(),
            Value<double?> vitB12 = const Value.absent(),
            Value<double?> fol = const Value.absent(),
            Value<double?> pantac = const Value.absent(),
            Value<double?> biot = const Value.absent(),
            Value<double?> vitC = const Value.absent(),
            Value<double?> alc = const Value.absent(),
            Value<double?> naclEq = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              JapaneseFoodCompositionTableCompanion(
            id: id,
            groupId: groupId,
            foodId: foodId,
            indexId: indexId,
            foodName: foodName,
            refuse: refuse,
            enerc: enerc,
            enercKcal: enercKcal,
            water: water,
            protcaa: protcaa,
            prot: prot,
            fatnlea: fatnlea,
            chole: chole,
            fat: fat,
            choavlm: choavlm,
            choavl: choavl,
            choavldf: choavldf,
            fib: fib,
            polyl: polyl,
            chocdf: chocdf,
            oa: oa,
            ash: ash,
            na: na,
            k: k,
            ca: ca,
            mg: mg,
            p: p,
            fe: fe,
            zn: zn,
            cu: cu,
            mn: mn,
            iodine: iodine,
            se: se,
            cr: cr,
            mo: mo,
            retol: retol,
            carta: carta,
            cartb: cartb,
            crypxb: crypxb,
            cartbeq: cartbeq,
            vitaRae: vitaRae,
            vitD: vitD,
            tocphA: tocphA,
            tocphB: tocphB,
            tocphG: tocphG,
            tocphD: tocphD,
            vitK: vitK,
            thia: thia,
            ribf: ribf,
            nia: nia,
            ne: ne,
            vitB6A: vitB6A,
            vitB12: vitB12,
            fol: fol,
            pantac: pantac,
            biot: biot,
            vitC: vitC,
            alc: alc,
            naclEq: naclEq,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int groupId,
            required int foodId,
            required int indexId,
            required String foodName,
            Value<double> refuse = const Value.absent(),
            Value<double?> enerc = const Value.absent(),
            Value<double?> enercKcal = const Value.absent(),
            Value<double?> water = const Value.absent(),
            Value<double?> protcaa = const Value.absent(),
            Value<double?> prot = const Value.absent(),
            Value<double?> fatnlea = const Value.absent(),
            Value<double?> chole = const Value.absent(),
            Value<double?> fat = const Value.absent(),
            Value<double?> choavlm = const Value.absent(),
            Value<double?> choavl = const Value.absent(),
            Value<double?> choavldf = const Value.absent(),
            Value<double?> fib = const Value.absent(),
            Value<double?> polyl = const Value.absent(),
            Value<double?> chocdf = const Value.absent(),
            Value<double?> oa = const Value.absent(),
            Value<double?> ash = const Value.absent(),
            Value<double?> na = const Value.absent(),
            Value<double?> k = const Value.absent(),
            Value<double?> ca = const Value.absent(),
            Value<double?> mg = const Value.absent(),
            Value<double?> p = const Value.absent(),
            Value<double?> fe = const Value.absent(),
            Value<double?> zn = const Value.absent(),
            Value<double?> cu = const Value.absent(),
            Value<double?> mn = const Value.absent(),
            Value<double?> iodine = const Value.absent(),
            Value<double?> se = const Value.absent(),
            Value<double?> cr = const Value.absent(),
            Value<double?> mo = const Value.absent(),
            Value<double?> retol = const Value.absent(),
            Value<double?> carta = const Value.absent(),
            Value<double?> cartb = const Value.absent(),
            Value<double?> crypxb = const Value.absent(),
            Value<double?> cartbeq = const Value.absent(),
            Value<double?> vitaRae = const Value.absent(),
            Value<double?> vitD = const Value.absent(),
            Value<double?> tocphA = const Value.absent(),
            Value<double?> tocphB = const Value.absent(),
            Value<double?> tocphG = const Value.absent(),
            Value<double?> tocphD = const Value.absent(),
            Value<double?> vitK = const Value.absent(),
            Value<double?> thia = const Value.absent(),
            Value<double?> ribf = const Value.absent(),
            Value<double?> nia = const Value.absent(),
            Value<double?> ne = const Value.absent(),
            Value<double?> vitB6A = const Value.absent(),
            Value<double?> vitB12 = const Value.absent(),
            Value<double?> fol = const Value.absent(),
            Value<double?> pantac = const Value.absent(),
            Value<double?> biot = const Value.absent(),
            Value<double?> vitC = const Value.absent(),
            Value<double?> alc = const Value.absent(),
            Value<double?> naclEq = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              JapaneseFoodCompositionTableCompanion.insert(
            id: id,
            groupId: groupId,
            foodId: foodId,
            indexId: indexId,
            foodName: foodName,
            refuse: refuse,
            enerc: enerc,
            enercKcal: enercKcal,
            water: water,
            protcaa: protcaa,
            prot: prot,
            fatnlea: fatnlea,
            chole: chole,
            fat: fat,
            choavlm: choavlm,
            choavl: choavl,
            choavldf: choavldf,
            fib: fib,
            polyl: polyl,
            chocdf: chocdf,
            oa: oa,
            ash: ash,
            na: na,
            k: k,
            ca: ca,
            mg: mg,
            p: p,
            fe: fe,
            zn: zn,
            cu: cu,
            mn: mn,
            iodine: iodine,
            se: se,
            cr: cr,
            mo: mo,
            retol: retol,
            carta: carta,
            cartb: cartb,
            crypxb: crypxb,
            cartbeq: cartbeq,
            vitaRae: vitaRae,
            vitD: vitD,
            tocphA: tocphA,
            tocphB: tocphB,
            tocphG: tocphG,
            tocphD: tocphD,
            vitK: vitK,
            thia: thia,
            ribf: ribf,
            nia: nia,
            ne: ne,
            vitB6A: vitB6A,
            vitB12: vitB12,
            fol: fol,
            pantac: pantac,
            biot: biot,
            vitC: vitC,
            alc: alc,
            naclEq: naclEq,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$JapaneseFoodCompositionTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $JapaneseFoodCompositionTableTable,
        JapaneseFoodCompositionTableData,
        $$JapaneseFoodCompositionTableTableFilterComposer,
        $$JapaneseFoodCompositionTableTableOrderingComposer,
        $$JapaneseFoodCompositionTableTableAnnotationComposer,
        $$JapaneseFoodCompositionTableTableCreateCompanionBuilder,
        $$JapaneseFoodCompositionTableTableUpdateCompanionBuilder,
        (
          JapaneseFoodCompositionTableData,
          BaseReferences<_$AppDatabase, $JapaneseFoodCompositionTableTable,
              JapaneseFoodCompositionTableData>
        ),
        JapaneseFoodCompositionTableData,
        PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$MealTableTableTableManager get mealTable =>
      $$MealTableTableTableManager(_db, _db.mealTable);
  $$ExternalRecipeTableTableTableManager get externalRecipeTable =>
      $$ExternalRecipeTableTableTableManager(_db, _db.externalRecipeTable);
  $$MealItemTableTableTableManager get mealItemTable =>
      $$MealItemTableTableTableManager(_db, _db.mealItemTable);
  $$PersonalDataTableTableTableManager get personalDataTable =>
      $$PersonalDataTableTableTableManager(_db, _db.personalDataTable);
  $$FoodItemTableTableTableManager get foodItemTable =>
      $$FoodItemTableTableTableManager(_db, _db.foodItemTable);
  $$RecipeTableTableTableManager get recipeTable =>
      $$RecipeTableTableTableManager(_db, _db.recipeTable);
  $$JapaneseFoodCompositionTableTableTableManager
      get japaneseFoodCompositionTable =>
          $$JapaneseFoodCompositionTableTableTableManager(
              _db, _db.japaneseFoodCompositionTable);
}
