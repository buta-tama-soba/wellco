import 'dart:convert';
import '../../data/models/japanese_food_composition_table.dart';
import '../../data/datasources/app_database.dart';
import 'ingredient_extraction_service.dart';
import 'food_composition_data_service.dart';
import 'food_dictionary_service.dart';

/// レシピ栄養分析サービス
class RecipeNutritionAnalysisService {
  final IngredientExtractionService _extractor = IngredientExtractionService();
  final FoodCompositionDataService _foodService;
  final FoodDictionaryService _dictionaryService;
  
  RecipeNutritionAnalysisService(AppDatabase database) 
      : _foodService = FoodCompositionDataService(database),
        _dictionaryService = FoodDictionaryService(database);

  /// レシピ本文から材料・栄養を分析
  Future<RecipeNutritionResult> analyzeRecipe(String recipeText) async {
    print('デバッグ: RecipeNutritionAnalysisService.analyzeRecipe開始');
    print('デバッグ: レシピ本文 = ${recipeText.substring(0, recipeText.length > 100 ? 100 : recipeText.length)}...');
    
    // 1. 材料抽出
    final ingredients = _extractor.extractIngredients(recipeText);
    final stats = _extractor.getExtractionStats(ingredients);
    print('デバッグ: 抽出された材料数 = ${ingredients.length}');
    
    // 2. 食品マッチング
    final matchResults = <IngredientMatchResult>[];
    
    for (final ingredient in ingredients) {
      // 辞書サービスを使用した高度なマッチング
      final matchedFood = await _dictionaryService.findBestMatch(ingredient.name);
      
      // 見つからない場合は基本マッチングにフォールバック
      final finalMatch = matchedFood ?? _findBasicFood(ingredient.name);
      print('デバッグ: ${ingredient.name} → ${finalMatch?.foodName ?? "マッチなし"}');
      
      matchResults.add(IngredientMatchResult(
        ingredient: ingredient,
        matchedFood: finalMatch,
        confidence: finalMatch != null ? (matchedFood != null ? 0.9 : 0.7) : 0.0,
      ));
    }
    
    // 3. 栄養計算
    final nutrition = _calculateNutrition(matchResults);
    
    // 4. PFCバランス
    final pfcBalance = _calculatePFCBalance(nutrition);
    
    return RecipeNutritionResult(
      ingredients: ingredients,
      matchResults: matchResults,
      nutrition: nutrition,
      pfcBalance: pfcBalance,
      extractionStats: stats,
      ingredientsJson: _ingredientsToJson(ingredients),
      rawText: recipeText,
    );
  }

  /// 栄養計算
  RecipeNutrition _calculateNutrition(List<IngredientMatchResult> matchResults) {
    double totalEnergy = 0;
    double totalProtein = 0;
    double totalFat = 0;
    double totalCarbs = 0;
    double totalSalt = 0;
    double totalFiber = 0;
    double totalVitaminC = 0;
    
    for (final result in matchResults) {
      if (result.matchedFood != null) {
        final ingredient = result.ingredient;
        final food = result.matchedFood!;
        
        // 重量をグラムに変換（可食部重量考慮）  
        final grossWeight = _convertToGrams(ingredient.amount ?? 0, ingredient.unit);
        final edibleWeight = grossWeight * (1 - (food.refuse ?? 0) / 100);
        final multiplier = edibleWeight / 100; // 100gあたりの値から実際の量を計算
        
        // 栄養素計算
        totalEnergy += (food.enercKcal ?? 0) * multiplier;
        totalProtein += (food.prot ?? 0) * multiplier;
        totalFat += (food.fat ?? 0) * multiplier;
        totalCarbs += (food.choavl ?? 0) * multiplier;
        totalSalt += (food.na ?? 0) * multiplier * 2.54 / 1000; // ナトリウム→食塩相当量
        totalFiber += (food.fib ?? 0) * multiplier;
        totalVitaminC += (food.vitC ?? 0) * multiplier;
      }
    }
    
    return RecipeNutrition(
      energy: totalEnergy,
      protein: totalProtein,
      fat: totalFat,
      carbohydrate: totalCarbs,
      salt: totalSalt,
      fiber: totalFiber,
      vitaminC: totalVitaminC,
    );
  }

  /// PFCバランス計算
  PFCBalance _calculatePFCBalance(RecipeNutrition nutrition) {
    final proteinCal = nutrition.protein * 4; // 1g = 4kcal
    final fatCal = nutrition.fat * 9; // 1g = 9kcal
    final carbsCal = nutrition.carbohydrate * 4; // 1g = 4kcal
    final total = proteinCal + fatCal + carbsCal;
    
    if (total == 0) {
      return PFCBalance(protein: 0, fat: 0, carbohydrate: 0);
    }
    
    return PFCBalance(
      protein: (proteinCal / total) * 100,
      fat: (fatCal / total) * 100,
      carbohydrate: (carbsCal / total) * 100,
    );
  }

  /// 単位変換
  double _convertToGrams(double amount, String? unit) {
    final normalizedUnit = (unit ?? '').toLowerCase();
    
    final conversionMap = {
      'g': 1.0,
      'kg': 1000.0,
      'ml': 1.0, // 液体は1ml=1gと仮定
      '個': 100.0, // 野菜1個の平均重量
      'コ': 100.0,
      '本': 50.0,  // 野菜1本の平均重量
      '枚': 100.0, // 肉1枚の平均重量
      '束': 100.0,
      '大さじ': 15.0,
      '小さじ': 5.0,
    };
    
    return amount * (conversionMap[normalizedUnit] ?? 1.0);
  }

  /// 改善された食品マッチング
  JapaneseFoodCompositionTableData? _findBasicFood(String ingredientName) {
    final cleanedName = ingredientName.toLowerCase().trim();
    
    // 1. 完全一致の確認
    final exactMatch = _findExactMatch(cleanedName);
    if (exactMatch != null) return exactMatch;
    
    // 2. 部分一致の確認
    final partialMatch = _findPartialMatch(cleanedName);
    if (partialMatch != null) return partialMatch;
    
    // 3. シノニム（同義語）マッチング
    final synonymMatch = _findSynonymMatch(cleanedName);
    if (synonymMatch != null) return synonymMatch;
    
    // 4. ファジーマッチング（編集距離ベース）
    final fuzzyMatch = _findFuzzyMatch(cleanedName);
    if (fuzzyMatch != null) return fuzzyMatch;
    
    return null;
  }

  /// 完全一致検索
  JapaneseFoodCompositionTableData? _findExactMatch(String name) {
    // 基本的な食品マッピング（テスト用）
    final basicFoods = {
      '豚': JapaneseFoodCompositionTableData(
        id: 1, groupId: 11, foodId: 11005, indexId: 1,
        foodName: 'ぶた 肩ロース 脂身つき 生',
        refuse: 0.0, enercKcal: 253.0, prot: 17.1, fat: 19.2, choavl: 0.2,
        na: 54.0, k: 300.0, ca: 5.0, fe: 0.6, fib: 0.0, vitC: 1.0,
        createdAt: DateTime.now(), updatedAt: DateTime.now(),
      ),
      'なす': JapaneseFoodCompositionTableData(
        id: 2, groupId: 6, foodId: 6014, indexId: 1,
        foodName: 'なす 果実 生',
        refuse: 0.0, enercKcal: 22.0, prot: 1.1, fat: 0.1, choavl: 5.1,
        na: 1.0, k: 220.0, ca: 18.0, fe: 0.3, fib: 2.2, vitC: 5.0,
        createdAt: DateTime.now(), updatedAt: DateTime.now(),
      ),
      'そうめん': JapaneseFoodCompositionTableData(
        id: 3, groupId: 1, foodId: 1020, indexId: 1,
        foodName: 'そうめん・ひやむぎ 乾',
        refuse: 0.0, enercKcal: 356.0, prot: 9.5, fat: 1.1, choavl: 72.7,
        na: 1800.0, k: 120.0, ca: 9.0, fe: 0.6, fib: 2.5, vitC: 0.0,
        createdAt: DateTime.now(), updatedAt: DateTime.now(),
      ),
      'だし': JapaneseFoodCompositionTableData(
        id: 4, groupId: 19, foodId: 19001, indexId: 1,
        foodName: 'かつおだし',
        refuse: 0.0, enercKcal: 3.0, prot: 0.8, fat: 0.0, choavl: 0.1,
        na: 270.0, k: 88.0, ca: 2.0, fe: 0.0, fib: 0.0, vitC: 0.0,
        createdAt: DateTime.now(), updatedAt: DateTime.now(),
      ),
      'ピーマン': JapaneseFoodCompositionTableData(
        id: 5, groupId: 6, foodId: 6024, indexId: 1,
        foodName: 'ピーマン 果実 生',
        refuse: 0.0, enercKcal: 22.0, prot: 0.9, fat: 0.2, choavl: 5.1,
        na: 1.0, k: 190.0, ca: 11.0, fe: 0.4, fib: 2.3, vitC: 76.0,
        createdAt: DateTime.now(), updatedAt: DateTime.now(),
      ),
      '鶏': JapaneseFoodCompositionTableData(
        id: 6, groupId: 11, foodId: 11015, indexId: 1,
        foodName: 'にわとり もも 皮つき 生',
        refuse: 0.0, enercKcal: 200.0, prot: 16.2, fat: 14.0, choavl: 0.0,
        na: 98.0, k: 270.0, ca: 6.0, fe: 0.6, fib: 0.0, vitC: 3.0,
        createdAt: DateTime.now(), updatedAt: DateTime.now(),
      ),
      'いんげん': JapaneseFoodCompositionTableData(
        id: 7, groupId: 6, foodId: 6015, indexId: 1,
        foodName: 'いんげんまめ さやいんげん 若ざや 生',
        refuse: 0.0, enercKcal: 23.0, prot: 1.8, fat: 0.1, choavl: 4.6,
        na: 1.0, k: 260.0, ca: 40.0, fe: 0.7, fib: 2.4, vitC: 8.0,
        createdAt: DateTime.now(), updatedAt: DateTime.now(),
      ),
      'トマト': JapaneseFoodCompositionTableData(
        id: 8, groupId: 6, foodId: 6031, indexId: 1,
        foodName: 'トマト 果実 生',
        refuse: 0.0, enercKcal: 20.0, prot: 0.7, fat: 0.1, choavl: 4.7,
        na: 3.0, k: 210.0, ca: 7.0, fe: 0.2, fib: 1.0, vitC: 15.0,
        createdAt: DateTime.now(), updatedAt: DateTime.now(),
      ),
      '大葉': JapaneseFoodCompositionTableData(
        id: 9, groupId: 6, foodId: 6041, indexId: 1,
        foodName: 'しそ 葉 生',
        refuse: 0.0, enercKcal: 37.0, prot: 3.9, fat: 0.1, choavl: 7.5,
        na: 1.0, k: 500.0, ca: 230.0, fe: 1.7, fib: 7.3, vitC: 26.0,
        createdAt: DateTime.now(), updatedAt: DateTime.now(),
      ),
      'ポン酢': JapaneseFoodCompositionTableData(
        id: 10, groupId: 18, foodId: 18001, indexId: 1,
        foodName: 'ぽん酢',
        refuse: 0.0, enercKcal: 56.0, prot: 2.1, fat: 0.0, choavl: 12.2,  
        na: 3200.0, k: 130.0, ca: 8.0, fe: 0.4, fib: 0.0, vitC: 12.0,
        createdAt: DateTime.now(), updatedAt: DateTime.now(),
      ),
      'オリーブオイル': JapaneseFoodCompositionTableData(
        id: 11, groupId: 14, foodId: 14003, indexId: 1,
        foodName: 'オリーブ油',
        refuse: 0.0, enercKcal: 921.0, prot: 0.0, fat: 100.0, choavl: 0.0,
        na: 0.0, k: 0.0, ca: 0.0, fe: 0.0, fib: 0.0, vitC: 0.0,
        createdAt: DateTime.now(), updatedAt: DateTime.now(),
      ),
      'ごま': JapaneseFoodCompositionTableData(
        id: 12, groupId: 3, foodId: 3020, indexId: 1,
        foodName: 'ごま いり',
        refuse: 0.0, enercKcal: 599.0, prot: 19.8, fat: 54.2, choavl: 18.5,
        na: 2.0, k: 400.0, ca: 1200.0, fe: 9.9, fib: 10.8, vitC: 0.0,
        createdAt: DateTime.now(), updatedAt: DateTime.now(),
      ),
    };
    
    // 完全一致検索
    return basicFoods[name];
  }

  /// 部分一致検索
  JapaneseFoodCompositionTableData? _findPartialMatch(String name) {
    final basicFoods = _getBasicFoods();
    
    for (final entry in basicFoods.entries) {
      if (name.contains(entry.key) || entry.key.contains(name)) {
        return entry.value;
      }
    }
    return null;
  }

  /// シノニム（同義語）マッチング
  JapaneseFoodCompositionTableData? _findSynonymMatch(String name) {
    final basicFoods = _getBasicFoods();
    final synonyms = {
      'しそ': '大葉',
      'オリーブ': 'オリーブオイル',
      'いりごま': 'ごま',
      '白ごま': 'ごま',
      'しろごま': 'ごま',
      'いり': 'ごま',
      'ぽん酢': 'ポン酢',
      'ポンズ': 'ポン酢',
      'しょうゆ': 'ポン酢',
      '醤油': 'ポン酢',
      // 追加のシノニム
      'にんじん': '人参',
      'たまねぎ': '玉ねぎ',
      'きゅうり': '胡瓜',
      'じゃがいも': 'じゃが芋',
      'さつまいも': 'さつま芋',
      'だいこん': '大根',
      'はくさい': '白菜',
      '鳥肉': '鶏肉',
      'とり肉': '鶏肉',
      'ぶた肉': '豚肉',
      '牛肉': '牛',
      'びーふ': '牛肉',
      'ポーク': '豚肉',
      'チキン': '鶏肉',
    };
    
    for (final entry in synonyms.entries) {
      if (name.contains(entry.key)) {
        return basicFoods[entry.value];
      }
    }
    return null;
  }

  /// ファジーマッチング（編集距離ベース）
  JapaneseFoodCompositionTableData? _findFuzzyMatch(String name) {
    final basicFoods = _getBasicFoods();
    
    // 編集距離が2以下で最も近い食品を探す
    String? bestMatch;
    int minDistance = 3; // 閾値
    
    for (final foodName in basicFoods.keys) {
      final distance = _calculateEditDistance(name, foodName);
      if (distance < minDistance) {
        minDistance = distance;
        bestMatch = foodName;
      }
    }
    
    return bestMatch != null ? basicFoods[bestMatch] : null;
  }

  /// 編集距離（レーベンシュタイン距離）の計算
  int _calculateEditDistance(String s1, String s2) {
    final len1 = s1.length;
    final len2 = s2.length;
    
    final matrix = List.generate(len1 + 1, (i) => List.filled(len2 + 1, 0));
    
    for (int i = 0; i <= len1; i++) matrix[i][0] = i;
    for (int j = 0; j <= len2; j++) matrix[0][j] = j;
    
    for (int i = 1; i <= len1; i++) {
      for (int j = 1; j <= len2; j++) {
        final cost = s1[i - 1] == s2[j - 1] ? 0 : 1;
        matrix[i][j] = [
          matrix[i - 1][j] + 1,      // 削除
          matrix[i][j - 1] + 1,      // 挿入  
          matrix[i - 1][j - 1] + cost, // 置換
        ].reduce((a, b) => a < b ? a : b);
      }
    }
    
    return matrix[len1][len2];
  }

  /// 基本食品データベースを取得
  Map<String, JapaneseFoodCompositionTableData> _getBasicFoods() {
    return {
      '豚': JapaneseFoodCompositionTableData(
        id: 1, groupId: 11, foodId: 11005, indexId: 1,
        foodName: 'ぶた 肩ロース 脂身つき 生',
        refuse: 0.0, enercKcal: 253.0, prot: 17.1, fat: 19.2, choavl: 0.2,
        na: 54.0, k: 300.0, ca: 5.0, fe: 0.6, fib: 0.0, vitC: 1.0,
        createdAt: DateTime.now(), updatedAt: DateTime.now(),
      ),
      // ... 他の食品データ
    };
  }
  }

  /// 材料リストをJSONに変換
  String _ingredientsToJson(List<Ingredient> ingredients) {
    final jsonList = ingredients.map((ingredient) => {
      'name': ingredient.name,
      'amount': ingredient.amount,
      'unit': ingredient.unit,
      'confidence': ingredient.confidence,
    }).toList();
    
    return json.encode(jsonList);
  }

/// レシピ栄養分析結果
class RecipeNutritionResult {
  final List<Ingredient> ingredients;
  final List<IngredientMatchResult> matchResults;
  final RecipeNutrition nutrition;
  final PFCBalance pfcBalance;
  final Map<String, dynamic> extractionStats;
  final String ingredientsJson;
  final String rawText;

  RecipeNutritionResult({
    required this.ingredients,
    required this.matchResults,
    required this.nutrition,
    required this.pfcBalance,
    required this.extractionStats,
    required this.ingredientsJson,
    required this.rawText,
  });
}

/// 材料マッチング結果
class IngredientMatchResult {
  final Ingredient ingredient;
  final JapaneseFoodCompositionTableData? matchedFood;
  final double confidence;

  IngredientMatchResult({
    required this.ingredient,
    required this.matchedFood,
    required this.confidence,
  });
}

/// レシピ栄養情報
class RecipeNutrition {
  final double energy;
  final double protein;
  final double fat;
  final double carbohydrate;
  final double salt;
  final double fiber;
  final double vitaminC;

  RecipeNutrition({
    required this.energy,
    required this.protein,
    required this.fat,
    required this.carbohydrate,
    required this.salt,
    required this.fiber,
    required this.vitaminC,
  });
}

/// PFCバランス
class PFCBalance {
  final double protein;
  final double fat;
  final double carbohydrate;

  PFCBalance({
    required this.protein,
    required this.fat,
    required this.carbohydrate,
  });
}

