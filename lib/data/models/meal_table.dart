import 'package:drift/drift.dart';

/// 食事記録テーブル
class MealTable extends Table {
  /// 主キー
  IntColumn get id => integer().autoIncrement()();
  
  /// 記録日時
  DateTimeColumn get recordedAt => dateTime()();
  
  /// 食事タイプ（朝食、昼食、夕食、間食）
  TextColumn get mealType => text().withLength(min: 1, max: 20)();
  
  /// メモ（任意）
  TextColumn get memo => text().nullable()();
  
  /// 合計カロリー（kcal）
  RealColumn get totalCalories => real().withDefault(const Constant(0.0))();
  
  /// 合計タンパク質（g）
  RealColumn get totalProtein => real().withDefault(const Constant(0.0))();
  
  /// 合計脂質（g）
  RealColumn get totalFat => real().withDefault(const Constant(0.0))();
  
  /// 合計炭水化物（g）
  RealColumn get totalCarbs => real().withDefault(const Constant(0.0))();
  
  /// 作成日時
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  
  /// 更新日時
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// 食事項目テーブル
class MealItemTable extends Table {
  /// 主キー
  IntColumn get id => integer().autoIncrement()();
  
  /// 食事ID（外部キー）
  IntColumn get mealId => integer().references(MealTable, #id, onDelete: KeyAction.cascade)();
  
  /// 食品名
  TextColumn get foodName => text().withLength(min: 1, max: 100)();
  
  /// 量
  RealColumn get quantity => real().withDefault(const Constant(1.0))();
  
  /// 単位（g, ml, 個など）
  TextColumn get unit => text().withLength(min: 1, max: 20).withDefault(const Constant('g'))();
  
  /// カロリー（kcal）
  RealColumn get calories => real().withDefault(const Constant(0.0))();
  
  /// タンパク質（g）
  RealColumn get protein => real().withDefault(const Constant(0.0))();
  
  /// 脂質（g）
  RealColumn get fat => real().withDefault(const Constant(0.0))();
  
  /// 炭水化物（g）
  RealColumn get carbs => real().withDefault(const Constant(0.0))();
  
  /// 外部レシピID（任意）
  IntColumn get externalRecipeId => integer().nullable().references(ExternalRecipeTable, #id, onDelete: KeyAction.setNull)();
  
  /// 作成日時
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  
  /// 更新日時
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// 外部レシピテーブル
class ExternalRecipeTable extends Table {
  /// 主キー
  IntColumn get id => integer().autoIncrement()();
  
  /// レシピURL
  TextColumn get url => text().withLength(min: 1, max: 500).unique()();
  
  /// タイトル（OGPから取得）
  TextColumn get title => text().withLength(min: 1, max: 200)();
  
  /// 説明（OGPから取得）
  TextColumn get description => text().nullable()();
  
  /// 画像URL（OGPから取得）
  TextColumn get imageUrl => text().nullable()();
  
  /// サイト名（OGPから取得）
  TextColumn get siteName => text().nullable()();
  
  /// お気に入りフラグ
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  
  /// タグ（カンマ区切り）
  TextColumn get tags => text().nullable()();
  
  /// メモ
  TextColumn get memo => text().nullable()();
  
  /// 最終アクセス日時
  DateTimeColumn get lastAccessedAt => dateTime().nullable()();
  
  /// 作成日時
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  
  /// 更新日時
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// 食事タイプの列挙型
enum MealType {
  breakfast('朝食'),
  lunch('昼食'),
  dinner('夕食'),
  snack('間食');

  final String label;
  const MealType(this.label);
}