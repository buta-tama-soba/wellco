import 'package:drift/drift.dart';

/// レシピテーブル（アプリ内レシピ）
class RecipeTable extends Table {
  /// 主キー
  IntColumn get id => integer().autoIncrement()();
  
  /// レシピ名
  TextColumn get name => text().withLength(min: 1, max: 200)();
  
  /// カテゴリー（和食、洋食、中華など）
  TextColumn get category => text().withLength(min: 1, max: 50)();
  
  /// 調理時間（分）
  IntColumn get cookingTime => integer().nullable()();
  
  /// サービング数
  IntColumn get servings => integer().withDefault(const Constant(1))();
  
  /// 材料（JSON形式）
  TextColumn get ingredients => text()();
  
  /// 手順（JSON形式）
  TextColumn get instructions => text()();
  
  /// カロリー（kcal/1人前）
  RealColumn get calories => real().nullable()();
  
  /// タンパク質（g/1人前）
  RealColumn get protein => real().nullable()();
  
  /// 脂質（g/1人前）
  RealColumn get fat => real().nullable()();
  
  /// 炭水化物（g/1人前）
  RealColumn get carbs => real().nullable()();
  
  /// 画像パス
  TextColumn get imagePath => text().nullable()();
  
  /// お気に入りフラグ
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  
  /// タグ（カンマ区切り）
  TextColumn get tags => text().nullable()();
  
  /// 作成日時
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  
  /// 更新日時
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}