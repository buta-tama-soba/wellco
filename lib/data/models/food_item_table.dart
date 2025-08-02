import 'package:drift/drift.dart';

/// 食品在庫テーブル
class FoodItemTable extends Table {
  /// 主キー
  IntColumn get id => integer().autoIncrement()();
  
  /// 食品名
  TextColumn get name => text().withLength(min: 1, max: 100)();
  
  /// カテゴリー（野菜、肉、魚、調味料など）
  TextColumn get category => text().withLength(min: 1, max: 50)();
  
  /// 数量
  RealColumn get quantity => real().withDefault(const Constant(1.0))();
  
  /// 単位（g, ml, 個など）
  TextColumn get unit => text().withLength(min: 1, max: 20).withDefault(const Constant('個'))();
  
  /// 購入日
  DateTimeColumn get purchaseDate => dateTime().nullable()();
  
  /// 賞味期限・消費期限
  DateTimeColumn get expiryDate => dateTime().nullable()();
  
  /// 保管場所（冷蔵庫、冷凍庫、常温など）
  TextColumn get storageLocation => text().nullable()();
  
  /// メモ
  TextColumn get memo => text().nullable()();
  
  /// 在庫切れフラグ
  BoolColumn get isOutOfStock => boolean().withDefault(const Constant(false))();
  
  /// 作成日時
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  
  /// 更新日時
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}