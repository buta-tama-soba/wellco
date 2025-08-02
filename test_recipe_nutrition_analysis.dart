import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'lib/core/services/ingredient_extraction_service.dart';
import 'lib/data/models/japanese_food_composition_table.dart';

/// 4つのレシピでの完全栄養分析テスト
class RecipeNutritionAnalysisTest {
  final IngredientExtractionService _extractor = IngredientExtractionService();
  final Map<String, JapaneseFoodCompositionTableData> _foodDatabase = {};

  /// テスト実行
  Future<void> runTest() async {
    print('=== レシピ栄養分析テスト開始 ===\n');
    
    // 1. 食品データベースの準備（サンプルデータのみ）
    await _prepareFoodDatabase();
    
    // 2. テストレシピデータ
    final testRecipes = [
      {
        'name': '白ごはん.com - 豚しゃぶ肉のぶっかけそうめん',
        'ingredients': '''
豚しゃぶ肉：100～150g
なす：2本（大きめなら1本でも）
そうめん：150g（50g×3束）
刻みねぎ：少々
おろし生姜：少々
だし汁：175ml
醤油：大さじ2と1/2
みりん：大さじ2
        ''',
      },
      {
        'name': 'レタスクラブ - ピーマンとちりめんじゃこの梅あえ',
        'ingredients': '''
ちりめんじゃこ: 大さじ1
ピーマン: 4個
練り梅(チューブ): 小さじ1/2
めんつゆ(3倍濃縮): 小さじ1
ごま油: 大さじ1/2
削りがつお: 適量
        ''',
      },
      {
        'name': 'オレンジページ - なすといんげんの南蛮漬け',
        'ingredients': '''
なす: 3個
さやいんげん: 10本
鶏もも肉: 1枚（約250g）
しょうゆ: 小さじ1/2
酒: 小さじ1/2
赤唐辛子の小口切り: 1本分
砂糖: 大さじ1
だし汁: 大さじ4
酢: 大さじ3
しょうゆ: 大さじ2
ごま油: 小さじ1/2
揚げ油: 適宜
        ''',
      },
      {
        'name': 'みんなのきょうの料理 - 豚の梅照り焼き',
        'ingredients': '''
豚肩ロース肉（しょうが焼き用）: 6枚 (240g)
たまねぎ: 1/2コ (100g)
梅干し（塩分14%）: 2～3コ (35g)
みりん: 大さじ2
酒: 大さじ1
砂糖: 小さじ1
しょうゆ: 小さじ1/2
キャベツ（せん切り）: 適量
塩: 少々
小麦粉: 適量
米油（またはサラダ油）: 適量
        ''',
      },
    ];

    // 3. 各レシピを分析
    for (int i = 0; i < testRecipes.length; i++) {
      final recipe = testRecipes[i];
      await _analyzeRecipe(i + 1, recipe);
      print('');
    }

    print('=== テスト完了 ===');
  }

  /// 食品データベースの準備（サンプルデータ）
  Future<void> _prepareFoodDatabase() async {
    print('📊 食品データベースの準備中...');
    
    // 実際の日本食品標準成分表からサンプルデータを作成
    // 本来はkatoharu432さんのJSONから全データを取得
    final sampleData = [
      // 豚肉類
      {
        'foodId': 11005,
        'foodName': 'ぶた 肩ロース 脂身つき 生',
        'enercKcal': 253.0,
        'prot': 17.1,
        'fat': 19.2,
        'choavl': 0.2,
        'na': 54.0,
        'k': 300.0,
        'ca': 5.0,
        'fe': 0.6,
        'fib': 0.0,
        'vitC': 1.0,
      },
      {
        'foodId': 11007,
        'foodName': 'ぶた ばら 脂身つき 生',
        'enercKcal': 386.0,
        'prot': 14.2,
        'fat': 34.6,
        'choavl': 0.1,
        'na': 48.0,
        'k': 240.0,
        'ca': 5.0,
        'fe': 0.6,
        'fib': 0.0,
        'vitC': 1.0,
      },
      
      // 鶏肉類
      {
        'foodId': 11015,
        'foodName': 'にわとり もも 皮つき 生',
        'enercKcal': 200.0,
        'prot': 16.2,
        'fat': 14.0,
        'choavl': 0.0,
        'na': 98.0,
        'k': 270.0,
        'ca': 6.0,
        'fe': 0.6,
        'fib': 0.0,
        'vitC': 3.0,
      },
      
      // 野菜類
      {
        'foodId': 6001,
        'foodName': 'たまねぎ 鱗茎 生',
        'enercKcal': 37.0,
        'prot': 1.0,
        'fat': 0.1,
        'choavl': 8.8,
        'na': 2.0,
        'k': 150.0,
        'ca': 21.0,
        'fe': 0.2,
        'fib': 1.6,
        'vitC': 8.0,
      },
      {
        'foodId': 6014,
        'foodName': 'なす 果実 生',
        'enercKcal': 22.0,
        'prot': 1.1,
        'fat': 0.1,
        'choavl': 5.1,
        'na': 1.0,
        'k': 220.0,
        'ca': 18.0,
        'fe': 0.3,
        'fib': 2.2,
        'vitC': 5.0,
      },
      {
        'foodId': 6024,
        'foodName': 'ピーマン 果実 生',
        'enercKcal': 22.0,
        'prot': 0.9,
        'fat': 0.2,
        'choavl': 5.1,
        'na': 1.0,
        'k': 190.0,
        'ca': 11.0,
        'fe': 0.4,
        'fib': 2.3,
        'vitC': 76.0,
      },
      {
        'foodId': 6015,
        'foodName': 'いんげんまめ さやいんげん 若ざや 生',
        'enercKcal': 23.0,
        'prot': 1.8,
        'fat': 0.1,
        'choavl': 4.6,
        'na': 1.0,
        'k': 260.0,
        'ca': 40.0,
        'fe': 0.7,
        'fib': 2.4,
        'vitC': 8.0,
      },
      {
        'foodId': 6029,
        'foodName': 'キャベツ 結球葉 生',
        'enercKcal': 23.0,
        'prot': 1.3,
        'fat': 0.2,
        'choavl': 5.2,
        'na': 5.0,
        'k': 200.0,
        'ca': 43.0,
        'fe': 0.3,
        'fib': 1.8,
        'vitC': 41.0,
      },
      
      // 調味料類
      {
        'foodId': 18001,
        'foodName': 'しょうゆ 濃口',
        'enercKcal': 71.0,
        'prot': 7.7,
        'fat': 0.0,
        'choavl': 10.1,
        'na': 5700.0,
        'k': 610.0,
        'ca': 17.0,
        'fe': 0.9,
        'fib': 0.0,
        'vitC': 0.0,
      },
      {
        'foodId': 18011,
        'foodName': 'みりん 本みりん',
        'enercKcal': 241.0,
        'prot': 0.1,
        'fat': 0.0,
        'choavl': 43.2,
        'na': 11.0,
        'k': 5.0,
        'ca': 1.0,
        'fe': 0.1,
        'fib': 0.0,
        'vitC': 0.0,
      },
      {
        'foodId': 17024,
        'foodName': 'ごま油',
        'enercKcal': 921.0,
        'prot': 0.0,
        'fat': 100.0,
        'choavl': 0.0,
        'na': 0.0,
        'k': 0.0,
        'ca': 0.0,
        'fe': 0.0,
        'fib': 0.0,
        'vitC': 0.0,
      },
      
      // 主食類
      {
        'foodId': 1020,
        'foodName': 'そうめん・ひやむぎ 乾',
        'enercKcal': 356.0,
        'prot': 9.5,
        'fat': 1.1,
        'choavl': 72.7,
        'na': 1800.0,
        'k': 120.0,
        'ca': 9.0,
        'fe': 0.6,
        'fib': 2.5,
        'vitC': 0.0,
      },
      
      // その他
      {
        'foodId': 19001,
        'foodName': 'かつおだし',
        'enercKcal': 3.0,
        'prot': 0.8,
        'fat': 0.0,
        'choavl': 0.1,
        'na': 270.0,
        'k': 88.0,
        'ca': 2.0,
        'fe': 0.0,
        'fib': 0.0,
        'vitC': 0.0,
      },
      {
        'foodId': 10042,
        'foodName': 'しらす干し 半乾燥品',
        'enercKcal': 206.0,
        'prot': 40.5,
        'fat': 3.6,
        'choavl': 0.5,
        'na': 1100.0,
        'k': 510.0,
        'ca': 520.0,
        'fe': 1.8,
        'fib': 0.0,
        'vitC': 0.0,
      },
    ];

    // サンプルデータをメモリ上のデータベースに保存
    for (final item in sampleData) {
      final foodData = JapaneseFoodCompositionTableData(
        id: item['foodId'] as int,
        groupId: 1,
        foodId: item['foodId'] as int,
        indexId: 1,
        foodName: item['foodName'] as String,
        refuse: 0.0,
        enercKcal: (item['enercKcal'] as double),
        prot: (item['prot'] as double),
        fat: (item['fat'] as double),
        choavl: (item['choavl'] as double),
        na: (item['na'] as double),
        k: (item['k'] as double),
        ca: (item['ca'] as double),
        fe: (item['fe'] as double),
        fib: (item['fib'] as double),
        vitC: (item['vitC'] as double),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      _foodDatabase[item['foodName'] as String] = foodData;
    }
    
    print('✅ ${_foodDatabase.length}件の食品データを準備完了');
  }

  /// レシピ分析
  Future<void> _analyzeRecipe(int recipeNumber, Map<String, dynamic> recipe) async {
    print('📄 レシピ$recipeNumber: ${recipe['name']}');
    print('=' * 70);
    
    // 1. 材料抽出
    print('🔍 STEP 1: 材料抽出');
    final ingredients = _extractor.extractIngredients(recipe['ingredients'] as String);
    final stats = _extractor.getExtractionStats(ingredients);
    
    print('抽出結果: ${ingredients.length}件');
    for (int i = 0; i < ingredients.length; i++) {
      final ingredient = ingredients[i];
      final confidence = (ingredient.confidence * 100).toStringAsFixed(0);
      print('  ${i + 1}. ${ingredient.name} | ${ingredient.amount ?? 'N/A'}${ingredient.unit ?? ''} | 信頼度:${confidence}%');
    }
    
    // 2. 食品マッチング
    print('\n🍱 STEP 2: 食品マッチング');
    final matchResults = <Map<String, dynamic>>[];
    
    for (final ingredient in ingredients) {
      final matchedFood = _findMatchingFood(ingredient.name);
      matchResults.add({
        'ingredient': ingredient,
        'food': matchedFood,
        'matched': matchedFood != null,
      });
      
      if (matchedFood != null) {
        print('  ✅ ${ingredient.name} → ${matchedFood.foodName}');
      } else {
        print('  ❌ ${ingredient.name} → マッチなし');
      }
    }
    
    // 3. 栄養計算
    print('\n🧮 STEP 3: 栄養計算');
    final nutritionResult = _calculateNutrition(matchResults);
    
    print('栄養成分（総量）:');
    print('  エネルギー: ${(nutritionResult['totalEnergy'] ?? 0.0).toStringAsFixed(1)} kcal');
    print('  タンパク質: ${(nutritionResult['totalProtein'] ?? 0.0).toStringAsFixed(1)} g');
    print('  脂質: ${(nutritionResult['totalFat'] ?? 0.0).toStringAsFixed(1)} g');
    print('  炭水化物: ${(nutritionResult['totalCarbs'] ?? 0.0).toStringAsFixed(1)} g');
    print('  食塩相当量: ${(nutritionResult['totalSalt'] ?? 0.0).toStringAsFixed(2)} g');
    print('  食物繊維: ${(nutritionResult['totalFiber'] ?? 0.0).toStringAsFixed(1)} g');
    print('  ビタミンC: ${(nutritionResult['totalVitaminC'] ?? 0.0).toStringAsFixed(1)} mg');
    
    // 4. PFCバランス
    final pfcBalance = _calculatePFCBalance(nutritionResult);
    print('\nPFCバランス:');
    print('  P（タンパク質）: ${(pfcBalance['protein'] ?? 0.0).toStringAsFixed(1)}%');
    print('  F（脂質）: ${(pfcBalance['fat'] ?? 0.0).toStringAsFixed(1)}%');
    print('  C（炭水化物）: ${(pfcBalance['carbs'] ?? 0.0).toStringAsFixed(1)}%');
    
    // 5. 統計情報
    print('\n📊 統計情報:');
    print('  材料抽出: ${stats['totalCount']}件中${stats['withAmount']}件で数量取得');
    print('  食品マッチ: ${matchResults.where((r) => r['matched']).length}/${matchResults.length}件成功');
    print('  平均信頼度: ${(stats['averageConfidence'] * 100).toStringAsFixed(1)}%');
    
    final matchRate = (matchResults.where((r) => r['matched']).length / matchResults.length * 100);
    print('  マッチ率: ${matchRate.toStringAsFixed(1)}%');
    
    print('-' * 70);
  }

  /// 食品マッチング
  JapaneseFoodCompositionTableData? _findMatchingFood(String ingredientName) {
    final cleanedName = ingredientName.toLowerCase().trim();
    
    // 完全一致チェック
    for (final entry in _foodDatabase.entries) {
      if (entry.key.toLowerCase().contains(cleanedName) || 
          cleanedName.contains(entry.key.toLowerCase())) {
        return entry.value;
      }
    }
    
    // 部分一致チェック（キーワードベース）
    final keywords = {
      '豚': ['ぶた'],
      '鶏': ['にわとり'],
      '玉ねぎ': ['たまねぎ'],
      'たまねぎ': ['たまねぎ'],
      'なす': ['なす'],
      'ピーマン': ['ピーマン'],
      'いんげん': ['いんげんまめ'],
      'さやいんげん': ['いんげんまめ'],
      'キャベツ': ['キャベツ'],
      '醤油': ['しょうゆ'],
      'しょうゆ': ['しょうゆ'],
      'みりん': ['みりん'],
      'ごま油': ['ごま油'],
      'そうめん': ['そうめん'],
      'だし': ['かつおだし'],
      'ちりめんじゃこ': ['しらす'],
      'じゃこ': ['しらす'],
    };
    
    for (final keywordEntry in keywords.entries) {
      if (cleanedName.contains(keywordEntry.key)) {
        for (final searchTerm in keywordEntry.value) {
          for (final entry in _foodDatabase.entries) {
            if (entry.key.contains(searchTerm)) {
              return entry.value;
            }
          }
        }
      }
    }
    
    return null;
  }

  /// 栄養計算
  Map<String, double> _calculateNutrition(List<Map<String, dynamic>> matchResults) {
    double totalEnergy = 0;
    double totalProtein = 0;
    double totalFat = 0;
    double totalCarbs = 0;
    double totalSalt = 0;
    double totalFiber = 0;
    double totalVitaminC = 0;
    
    for (final result in matchResults) {
      if (result['matched']) {
        final ingredient = result['ingredient'] as Ingredient;
        final food = result['food'] as JapaneseFoodCompositionTableData;
        
        // 重量をグラムに変換
        final amountInGrams = _convertToGrams(ingredient.amount ?? 0, ingredient.unit);
        final multiplier = amountInGrams / 100; // 100gあたりの値から実際の量を計算
        
        totalEnergy += (food.enercKcal ?? 0) * multiplier;
        totalProtein += (food.prot ?? 0) * multiplier;
        totalFat += (food.fat ?? 0) * multiplier;
        totalCarbs += (food.choavl ?? 0) * multiplier;
        totalSalt += (food.na ?? 0) * multiplier * 2.54 / 1000; // ナトリウムから食塩相当量
        totalFiber += (food.fib ?? 0) * multiplier;
        totalVitaminC += (food.vitC ?? 0) * multiplier;
      }
    }
    
    return {
      'totalEnergy': totalEnergy,
      'totalProtein': totalProtein,
      'totalFat': totalFat,
      'totalCarbs': totalCarbs,
      'totalSalt': totalSalt,
      'totalFiber': totalFiber,
      'totalVitaminC': totalVitaminC,
    };
  }

  /// 単位変換
  double _convertToGrams(double amount, String? unit) {
    final normalizedUnit = (unit ?? '').toLowerCase();
    
    // 基本的な単位変換表
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

  /// PFCバランス計算
  Map<String, double> _calculatePFCBalance(Map<String, double> nutrition) {
    final proteinCal = nutrition['totalProtein']! * 4; // 1g = 4kcal
    final fatCal = nutrition['totalFat']! * 9; // 1g = 9kcal
    final carbsCal = nutrition['totalCarbs']! * 4; // 1g = 4kcal
    final total = proteinCal + fatCal + carbsCal;
    
    if (total == 0) {
      return {'protein': 0, 'fat': 0, 'carbs': 0};
    }
    
    return {
      'protein': (proteinCal / total) * 100,
      'fat': (fatCal / total) * 100,
      'carbs': (carbsCal / total) * 100,
    };
  }
}

void main() async {
  final test = RecipeNutritionAnalysisTest();
  await test.runTest();
  exit(0);
}