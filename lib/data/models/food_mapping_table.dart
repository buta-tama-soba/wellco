import 'package:drift/drift.dart';
import 'nutrition_table.dart';

/// 食品マッピングテーブル（材料名 → 栄養データの対応）
@UseRowClass(FoodMappingTableData)
class FoodMappingTable extends Table {
  /// ID
  IntColumn get id => integer().autoIncrement()();
  
  /// 材料名（レシピで使われる一般的な名前）
  TextColumn get ingredientName => text()();
  
  /// 栄養データテーブルのID
  IntColumn get nutritionDataId => integer().references(NutritionDataTable, #id)();
  
  /// マッピングの信頼度（0.0-1.0）
  RealColumn get confidence => real().withDefault(const Constant(1.0))();
  
  /// 単位変換係数（材料の単位からg換算）
  /// 例: 玉ねぎ1個 = 200g なら 200.0
  RealColumn get unitConversionFactor => real().nullable()();
  
  /// 単位名
  TextColumn get unit => text().nullable()();
  
  /// 別名・類義語（カンマ区切り）
  TextColumn get aliases => text().nullable()();
  
  /// カテゴリ（野菜、肉類、調味料など）
  TextColumn get category => text().nullable()();
  
  /// 廃棄率調整後の可食部割合（0.0-1.0）
  RealColumn get ediblePortion => real().withDefault(const Constant(1.0))();
  
  /// 作成日
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  
  /// 更新日
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// 食品マッピングデータクラス
class FoodMappingTableData {
  final int id;
  final String ingredientName;
  final int nutritionDataId;
  final double confidence;
  final double? unitConversionFactor;
  final String? unit;
  final String? aliases;
  final String? category;
  final double ediblePortion;
  final DateTime createdAt;
  final DateTime updatedAt;

  const FoodMappingTableData({
    required this.id,
    required this.ingredientName,
    required this.nutritionDataId,
    required this.confidence,
    this.unitConversionFactor,
    this.unit,
    this.aliases,
    this.category,
    required this.ediblePortion,
    required this.createdAt,
    required this.updatedAt,
  });

  /// 別名リストの取得
  List<String> getAliases() {
    if (aliases == null || aliases!.isEmpty) return [];
    return aliases!.split(',').map((e) => e.trim()).toList();
  }

  /// 材料名がマッチするかチェック
  bool matchesIngredient(String name) {
    final normalizedName = name.toLowerCase().trim();
    final normalizedIngredientName = ingredientName.toLowerCase().trim();
    
    // 完全一致
    if (normalizedName == normalizedIngredientName) return true;
    
    // 部分一致
    if (normalizedName.contains(normalizedIngredientName) || 
        normalizedIngredientName.contains(normalizedName)) return true;
    
    // 別名チェック
    final aliasesList = getAliases();
    for (final alias in aliasesList) {
      final normalizedAlias = alias.toLowerCase().trim();
      if (normalizedName == normalizedAlias ||
          normalizedName.contains(normalizedAlias) ||
          normalizedAlias.contains(normalizedName)) return true;
    }
    
    return false;
  }

  /// 単位からグラムへの変換
  double convertToGrams(double amount, String? inputUnit) {
    // 単位変換係数が設定されている場合
    if (unitConversionFactor != null && inputUnit == unit) {
      return amount * unitConversionFactor!;
    }
    
    // 一般的な単位変換
    final normalizedUnit = (inputUnit ?? '').toLowerCase();
    switch (normalizedUnit) {
      case 'kg':
      case 'キロ':
        return amount * 1000;
      case 'g':
      case 'グラム':
        return amount;
      case '個':
      case 'コ':
        // デフォルトの単位変換係数を使用
        return amount * (unitConversionFactor ?? 100.0);
      case '本':
        return amount * (unitConversionFactor ?? 50.0);
      case '枚':
        return amount * (unitConversionFactor ?? 20.0);
      case '束':
        return amount * (unitConversionFactor ?? 100.0);
      case '片':
        return amount * (unitConversionFactor ?? 10.0);
      case '玉':
        return amount * (unitConversionFactor ?? 200.0);
      default:
        return amount;
    }
  }
}