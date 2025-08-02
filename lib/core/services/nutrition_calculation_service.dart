import '../../data/datasources/app_database.dart';
import '../../data/models/nutrition_table.dart';
import '../../data/models/food_mapping_table.dart';
import '../services/ingredient_extraction_service.dart';

/// 栄養計算結果
class NutritionCalculationResult {
  final double totalEnergy;
  final double totalProtein;
  final double totalFat;
  final double totalCarbohydrate;
  final double totalSodium;
  final double totalFiber;
  final List<IngredientNutrition> ingredientDetails;
  final double confidence; // 計算全体の信頼度
  final List<String> unmatchedIngredients; // マッチしなかった材料
  final Map<String, double> vitamins;
  final Map<String, double> minerals;

  const NutritionCalculationResult({
    required this.totalEnergy,
    required this.totalProtein,
    required this.totalFat,
    required this.totalCarbohydrate,
    required this.totalSodium,
    required this.totalFiber,
    required this.ingredientDetails,
    required this.confidence,
    required this.unmatchedIngredients,
    required this.vitamins,
    required this.minerals,
  });

  /// 基本栄養素のMap取得
  Map<String, double> getBasicNutrition() {
    return {
      'energy': totalEnergy,
      'protein': totalProtein,
      'fat': totalFat,
      'carbohydrate': totalCarbohydrate,
    };
  }

  /// PFCバランス計算（タンパク質:脂質:炭水化物の比率）
  Map<String, double> getPFCBalance() {
    final proteinCal = totalProtein * 4; // 1g = 4kcal
    final fatCal = totalFat * 9; // 1g = 9kcal
    final carbCal = totalCarbohydrate * 4; // 1g = 4kcal
    final total = proteinCal + fatCal + carbCal;
    
    if (total == 0) {
      return {'protein': 0, 'fat': 0, 'carbohydrate': 0};
    }
    
    return {
      'protein': (proteinCal / total) * 100,
      'fat': (fatCal / total) * 100,
      'carbohydrate': (carbCal / total) * 100,
    };
  }
}

/// 材料ごとの栄養情報
class IngredientNutrition {
  final String ingredientName;
  final double amountInGrams;
  final double energy;
  final double protein;
  final double fat;
  final double carbohydrate;
  final double confidence;
  final String? matchedFoodName;

  const IngredientNutrition({
    required this.ingredientName,
    required this.amountInGrams,
    required this.energy,
    required this.protein,
    required this.fat,
    required this.carbohydrate,
    required this.confidence,
    this.matchedFoodName,
  });
}

/// 栄養計算サービス
class NutritionCalculationService {
  final AppDatabase _database;

  NutritionCalculationService(this._database);

  /// 材料リストから栄養情報を計算
  Future<NutritionCalculationResult> calculateNutrition(
    List<Ingredient> ingredients,
  ) async {
    final ingredientDetails = <IngredientNutrition>[];
    final unmatchedIngredients = <String>[];
    
    double totalEnergy = 0;
    double totalProtein = 0;
    double totalFat = 0;
    double totalCarbohydrate = 0;
    double totalSodium = 0;
    double totalFiber = 0;
    
    final vitamins = <String, double>{};
    final minerals = <String, double>{};
    
    double totalConfidence = 0;
    int matchedCount = 0;

    for (final ingredient in ingredients) {
      // 材料名から栄養データを検索
      final nutritionResult = await _findNutritionData(ingredient);
      
      if (nutritionResult != null) {
        final mapping = nutritionResult['mapping'] as FoodMappingTableData;
        final nutrition = nutritionResult['nutrition'] as NutritionDataTableData;
        
        // 材料の重量をグラムに変換
        final amountInGrams = mapping.convertToGrams(
          ingredient.amount ?? 0, 
          ingredient.unit,
        ) * mapping.ediblePortion;

        // 100gあたりの栄養価から実際の量を計算
        final multiplier = amountInGrams / 100;
        
        final ingredientEnergy = (nutrition.energy ?? 0) * multiplier;
        final ingredientProtein = (nutrition.protein ?? 0) * multiplier;
        final ingredientFat = (nutrition.fat ?? 0) * multiplier;
        final ingredientCarb = (nutrition.carbohydrate ?? 0) * multiplier;
        
        // 合計に追加
        totalEnergy += ingredientEnergy;
        totalProtein += ingredientProtein;
        totalFat += ingredientFat;
        totalCarbohydrate += ingredientCarb;
        totalSodium += (nutrition.sodium ?? 0) * multiplier;
        totalFiber += (nutrition.dietaryFiber ?? 0) * multiplier;
        
        // ビタミン・ミネラルの合計
        _addVitaminsAndMinerals(nutrition, multiplier, vitamins, minerals);
        
        // 材料詳細を追加
        ingredientDetails.add(IngredientNutrition(
          ingredientName: ingredient.name,
          amountInGrams: amountInGrams,
          energy: ingredientEnergy,
          protein: ingredientProtein,
          fat: ingredientFat,
          carbohydrate: ingredientCarb,
          confidence: mapping.confidence * ingredient.confidence,
          matchedFoodName: nutrition.foodName,
        ));
        
        totalConfidence += mapping.confidence * ingredient.confidence;
        matchedCount++;
      } else {
        unmatchedIngredients.add(ingredient.name);
      }
    }

    final averageConfidence = matchedCount > 0 ? totalConfidence / matchedCount : 0.0;

    return NutritionCalculationResult(
      totalEnergy: totalEnergy,
      totalProtein: totalProtein,
      totalFat: totalFat,
      totalCarbohydrate: totalCarbohydrate,
      totalSodium: totalSodium,
      totalFiber: totalFiber,
      ingredientDetails: ingredientDetails,
      confidence: averageConfidence,
      unmatchedIngredients: unmatchedIngredients,
      vitamins: vitamins,
      minerals: minerals,
    );
  }

  /// 材料名から栄養データを検索
  Future<Map<String, dynamic>?> _findNutritionData(Ingredient ingredient) async {
    // 1. 完全一致検索
    final exactMatch = await _searchByExactMatch(ingredient.name);
    if (exactMatch != null) return exactMatch;
    
    // 2. 部分一致検索
    final partialMatch = await _searchByPartialMatch(ingredient.name);
    if (partialMatch != null) return partialMatch;
    
    // 3. 類似度検索（将来的にAI補完）
    final similarMatch = await _searchBySimilarity(ingredient.name);
    if (similarMatch != null) return similarMatch;
    
    return null;
  }

  /// 完全一致検索
  Future<Map<String, dynamic>?> _searchByExactMatch(String ingredientName) async {
    final query = _database.select(_database.foodMappingTable).join([
      leftOuterJoin(
        _database.nutritionDataTable,
        _database.nutritionDataTable.id.equalsExp(
          _database.foodMappingTable.nutritionDataId,
        ),
      ),
    ])..where(_database.foodMappingTable.ingredientName.equals(ingredientName));

    final result = await query.getSingleOrNull();
    if (result != null) {
      return {
        'mapping': result.readTable(_database.foodMappingTable),
        'nutrition': result.readTable(_database.nutritionDataTable),
      };
    }
    return null;
  }

  /// 部分一致検索
  Future<Map<String, dynamic>?> _searchByPartialMatch(String ingredientName) async {
    final query = _database.select(_database.foodMappingTable).join([
      leftOuterJoin(
        _database.nutritionDataTable,
        _database.nutritionDataTable.id.equalsExp(
          _database.foodMappingTable.nutritionDataId,
        ),
      ),
    ])..where(_database.foodMappingTable.ingredientName.like('%$ingredientName%'))
      ..orderBy([OrderingTerm.desc(_database.foodMappingTable.confidence)]);

    final results = await query.get();
    if (results.isNotEmpty) {
      final result = results.first;
      return {
        'mapping': result.readTable(_database.foodMappingTable),
        'nutrition': result.readTable(_database.nutritionDataTable),
      };
    }
    return null;
  }

  /// 類似度検索（将来的に改善）
  Future<Map<String, dynamic>?> _searchBySimilarity(String ingredientName) async {
    // 現在は簡単なキーワードマッチング
    final keywords = _extractKeywords(ingredientName);
    
    for (final keyword in keywords) {
      final result = await _searchByPartialMatch(keyword);
      if (result != null) return result;
    }
    
    return null;
  }

  /// キーワード抽出（簡易版）
  List<String> _extractKeywords(String text) {
    // 括弧内削除
    String cleaned = text.replaceAll(RegExp(r'\([^)]*\)'), '');
    cleaned = cleaned.replaceAll(RegExp(r'（[^）]*）'), '');
    
    // 一般的な修飾語を削除
    final modifiers = ['新鮮な', '国産', '冷凍', '乾燥', '粉末', '液体', 'みじん切り', 'せん切り', '角切り'];
    for (final modifier in modifiers) {
      cleaned = cleaned.replaceAll(modifier, '');
    }
    
    return [cleaned.trim()];
  }

  /// ビタミン・ミネラルを合計に追加
  void _addVitaminsAndMinerals(
    NutritionDataTableData nutrition,
    double multiplier,
    Map<String, double> vitamins,
    Map<String, double> minerals,
  ) {
    // ビタミン
    vitamins['vitaminA'] = (vitamins['vitaminA'] ?? 0) + 
        (nutrition.retinolActivityEquivalent ?? 0) * multiplier;
    vitamins['vitaminD'] = (vitamins['vitaminD'] ?? 0) + 
        (nutrition.vitaminD ?? 0) * multiplier;
    vitamins['vitaminB1'] = (vitamins['vitaminB1'] ?? 0) + 
        (nutrition.vitaminB1 ?? 0) * multiplier;
    vitamins['vitaminB2'] = (vitamins['vitaminB2'] ?? 0) + 
        (nutrition.vitaminB2 ?? 0) * multiplier;
    vitamins['vitaminC'] = (vitamins['vitaminC'] ?? 0) + 
        (nutrition.vitaminC ?? 0) * multiplier;
    
    // ミネラル
    minerals['calcium'] = (minerals['calcium'] ?? 0) + 
        (nutrition.calcium ?? 0) * multiplier;
    minerals['iron'] = (minerals['iron'] ?? 0) + 
        (nutrition.iron ?? 0) * multiplier;
    minerals['potassium'] = (minerals['potassium'] ?? 0) + 
        (nutrition.potassium ?? 0) * multiplier;
    minerals['magnesium'] = (minerals['magnesium'] ?? 0) + 
        (nutrition.magnesium ?? 0) * multiplier;
  }

  /// 栄養計算の統計情報
  Map<String, dynamic> getCalculationStats(NutritionCalculationResult result) {
    return {
      'matchedIngredients': result.ingredientDetails.length,
      'unmatchedIngredients': result.unmatchedIngredients.length,
      'totalIngredients': result.ingredientDetails.length + result.unmatchedIngredients.length,
      'matchRate': result.ingredientDetails.length / 
          (result.ingredientDetails.length + result.unmatchedIngredients.length) * 100,
      'averageConfidence': result.confidence,
      'pfcBalance': result.getPFCBalance(),
    };
  }
}