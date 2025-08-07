import 'package:drift/drift.dart';

/// 食品商品テーブル（市販商品の登録用）
@DataClassName('FoodProductTableData')
class FoodProductTable extends Table {
  /// 商品ID（プライマリキー）
  IntColumn get id => integer().autoIncrement()();
  
  /// 商品コード（JANコード等）
  TextColumn get productCode => text().nullable()();
  
  /// 商品名
  TextColumn get name => text()();
  
  /// ブランド名
  TextColumn get brand => text().nullable()();
  
  /// 製造者・販売者
  TextColumn get manufacturer => text().nullable()();
  
  /// 商品サイズ・容量
  TextColumn get size => text().nullable()();
  
  /// 商品説明
  TextColumn get description => text().nullable()();
  
  /// 商品画像URL
  TextColumn get imageUrl => text().nullable()();
  
  /// 商品価格（円）
  RealColumn get price => real().nullable()();
  
  /// 元サイトURL
  TextColumn get sourceUrl => text().nullable()();
  
  /// 元サイト名
  TextColumn get sourceSite => text().nullable()();
  
  /// カテゴリ
  TextColumn get category => text().nullable()();
  
  // === 栄養成分（100gあたり） ===
  
  /// エネルギー（kcal）
  RealColumn get calories => real().nullable()();
  
  /// タンパク質（g）
  RealColumn get protein => real().nullable()();
  
  /// 脂質（g）
  RealColumn get fat => real().nullable()();
  
  /// 炭水化物（g）
  RealColumn get carbs => real().nullable()();
  
  /// 食塩相当量（g）
  RealColumn get salt => real().nullable()();
  
  /// 食物繊維（g）
  RealColumn get fiber => real().nullable()();
  
  /// ビタミンC（mg）
  RealColumn get vitaminC => real().nullable()();
  
  /// ナトリウム（mg）
  RealColumn get sodium => real().nullable()();
  
  /// カルシウム（mg）
  RealColumn get calcium => real().nullable()();
  
  /// 鉄（mg）
  RealColumn get iron => real().nullable()();
  
  /// カリウム（mg）
  RealColumn get potassium => real().nullable()();
  
  // === 原材料・アレルギー情報 ===
  
  /// 原材料名（JSON形式）
  TextColumn get ingredientsJson => text().nullable()();
  
  /// 原材料名（テキスト形式）
  TextColumn get ingredientsText => text().nullable()();
  
  /// アレルギー情報（JSON形式）
  TextColumn get allergensJson => text().nullable()();
  
  /// アレルギー情報（テキスト形式）
  TextColumn get allergensText => text().nullable()();
  
  // === 商品分類・タグ ===
  
  /// 商品タグ（カンマ区切り）
  TextColumn get tags => text().nullable()();
  
  /// お気に入りフラグ
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  
  /// ユーザーメモ
  TextColumn get userMemo => text().nullable()();
  
  // === システム情報 ===
  
  /// 栄養情報の情報源（'直接抽出' | '手動入力' | '推測' など）
  TextColumn get nutritionSource => text().nullable()();
  
  /// 最後にアクセスした日時
  DateTimeColumn get lastAccessedAt => dateTime().nullable()();
  
  /// 作成日時
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  
  /// 更新日時
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}