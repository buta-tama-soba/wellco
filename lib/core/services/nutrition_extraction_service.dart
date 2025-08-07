import 'package:html/dom.dart';

/// レシピページから栄養情報を直接抽出するサービス
class NutritionExtractionService {
  
  /// HTML文書から栄養表示情報を抽出
  /// 材料分析より優先して使用される
  NutritionInfo? extractNutritionFromHtml(Document document) {
    print('デバッグ: HTML文書から栄養情報の抽出を開始');
    
    // 1. 構造化データ（JSON-LD）から栄養情報を抽出
    final jsonLdNutrition = _extractFromJsonLD(document);
    if (jsonLdNutrition != null) {
      print('デバッグ: JSON-LDから栄養情報を抽出: ${jsonLdNutrition.calories}kcal');
      return jsonLdNutrition;
    }
    
    // 2. Microdataから栄養情報を抽出
    final microdataNutrition = _extractFromMicrodata(document);
    if (microdataNutrition != null) {
      print('デバッグ: Microdataから栄養情報を抽出: ${microdataNutrition.calories}kcal');
      return microdataNutrition;
    }
    
    // 3. テキストパターンマッチングで栄養情報を抽出
    final textNutrition = _extractFromTextPatterns(document);
    if (textNutrition != null) {
      print('デバッグ: テキストパターンから栄養情報を抽出: ${textNutrition.calories}kcal');
      return textNutrition;
    }
    
    // 4. テーブル構造から栄養情報を抽出
    final tableNutrition = _extractFromTables(document);
    if (tableNutrition != null) {
      print('デバッグ: テーブルから栄養情報を抽出: ${tableNutrition.calories}kcal');
      return tableNutrition;
    }
    
    print('デバッグ: HTML文書から栄養情報は見つかりませんでした');
    return null;
  }
  
  /// JSON-LD構造化データから栄養情報を抽出
  NutritionInfo? _extractFromJsonLD(Document document) {
    final scripts = document.querySelectorAll('script[type="application/ld+json"]');
    
    for (final script in scripts) {
      try {
        final jsonText = script.text;
        if (jsonText.contains('Recipe') || jsonText.contains('nutrition')) {
          // JSON-LD解析は複雑なため、簡単なパターンマッチングで対応
          final caloriesMatch = RegExp(r'"calories"\s*:\s*"?(\d+\.?\d*)"?').firstMatch(jsonText);
          final proteinMatch = RegExp(r'"proteinContent"\s*:\s*"?(\d+\.?\d*)"?').firstMatch(jsonText);
          final fatMatch = RegExp(r'"fatContent"\s*:\s*"?(\d+\.?\d*)"?').firstMatch(jsonText);
          final carbsMatch = RegExp(r'"carbohydrateContent"\s*:\s*"?(\d+\.?\d*)"?').firstMatch(jsonText);
          
          if (caloriesMatch != null) {
            return NutritionInfo(
              calories: double.tryParse(caloriesMatch.group(1)!) ?? 0,
              protein: proteinMatch != null ? (double.tryParse(proteinMatch.group(1)!) ?? 0) : 0,
              fat: fatMatch != null ? (double.tryParse(fatMatch.group(1)!) ?? 0) : 0,
              carbs: carbsMatch != null ? (double.tryParse(carbsMatch.group(1)!) ?? 0) : 0,
              source: 'JSON-LD',
            );
          }
        }
      } catch (e) {
        print('JSON-LD解析エラー: $e');
        continue;
      }
    }
    
    return null;
  }
  
  /// Microdataから栄養情報を抽出
  NutritionInfo? _extractFromMicrodata(Document document) {
    // Recipe microdataを探す
    final recipeElements = document.querySelectorAll('[itemtype*="Recipe"]');
    
    for (final recipe in recipeElements) {
      final nutritionElement = recipe.querySelector('[itemtype*="NutritionInformation"]');
      if (nutritionElement != null) {
        final calories = _extractMicrodataProperty(nutritionElement, 'calories');
        final protein = _extractMicrodataProperty(nutritionElement, 'proteinContent');
        final fat = _extractMicrodataProperty(nutritionElement, 'fatContent');
        final carbs = _extractMicrodataProperty(nutritionElement, 'carbohydrateContent');
        
        if (calories > 0) {
          return NutritionInfo(
            calories: calories,
            protein: protein,
            fat: fat,
            carbs: carbs,
            source: 'Microdata',
          );
        }
      }
    }
    
    return null;
  }
  
  /// Microdataプロパティを抽出
  double _extractMicrodataProperty(Element element, String property) {
    final propertyElement = element.querySelector('[itemprop="$property"]');
    if (propertyElement != null) {
      final content = propertyElement.attributes['content'] ?? propertyElement.text;
      return double.tryParse(content.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0;
    }
    return 0;
  }
  
  /// テキストパターンから栄養情報を抽出
  NutritionInfo? _extractFromTextPatterns(Document document) {
    final bodyText = document.body?.text ?? '';
    
    // 日本語の栄養表示パターン
    final patterns = [
      // カロリー・エネルギー
      RegExp(r'(?:カロリー|エネルギー|kcal)[：:\s]*(\d+\.?\d*)(?:\s*kcal)?', caseSensitive: false),
      // タンパク質
      RegExp(r'(?:たんぱく質|タンパク質|蛋白質|protein)[：:\s]*(\d+\.?\d*)(?:\s*g)?', caseSensitive: false),
      // 脂質
      RegExp(r'(?:脂質|脂肪|fat)[：:\s]*(\d+\.?\d*)(?:\s*g)?', caseSensitive: false),
      // 炭水化物
      RegExp(r'(?:炭水化物|carbohydrate)[：:\s]*(\d+\.?\d*)(?:\s*g)?', caseSensitive: false),
      // 食塩相当量・塩分
      RegExp(r'(?:食塩相当量|塩分|sodium)[：:\s]*(\d+\.?\d*)(?:\s*g)?', caseSensitive: false),
    ];
    
    double? calories;
    double protein = 0;
    double fat = 0;
    double carbs = 0;
    double salt = 0;
    
    // カロリー抽出
    final caloriesMatch = patterns[0].firstMatch(bodyText);
    if (caloriesMatch != null) {
      calories = double.tryParse(caloriesMatch.group(1)!);
    }
    
    // その他の栄養素
    final proteinMatch = patterns[1].firstMatch(bodyText);
    if (proteinMatch != null) {
      protein = double.tryParse(proteinMatch.group(1)!) ?? 0;
    }
    
    final fatMatch = patterns[2].firstMatch(bodyText);
    if (fatMatch != null) {
      fat = double.tryParse(fatMatch.group(1)!) ?? 0;
    }
    
    final carbsMatch = patterns[3].firstMatch(bodyText);
    if (carbsMatch != null) {
      carbs = double.tryParse(carbsMatch.group(1)!) ?? 0;
    }
    
    final saltMatch = patterns[4].firstMatch(bodyText);
    if (saltMatch != null) {
      salt = double.tryParse(saltMatch.group(1)!) ?? 0;
    }
    
    if (calories != null && calories > 0) {
      return NutritionInfo(
        calories: calories,
        protein: protein,
        fat: fat,
        carbs: carbs,
        salt: salt,
        source: 'テキストパターン',
      );
    }
    
    return null;
  }
  
  /// テーブル構造から栄養情報を抽出
  NutritionInfo? _extractFromTables(Document document) {
    final tables = document.querySelectorAll('table');
    
    for (final table in tables) {
      // 栄養情報テーブルの特徴的なキーワードを探す
      final tableText = table.text.toLowerCase();
      if (tableText.contains('栄養') || tableText.contains('カロリー') || 
          tableText.contains('エネルギー') || tableText.contains('nutrition')) {
        
        final rows = table.querySelectorAll('tr');
        
        double? calories;
        double protein = 0;
        double fat = 0;
        double carbs = 0;
        double salt = 0;
        
        for (final row in rows) {
          final cells = row.querySelectorAll('td, th');
          if (cells.length >= 2) {
            final label = cells[0].text.toLowerCase();
            final valueText = cells[1].text;
            final value = double.tryParse(valueText.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0;
            
            if (label.contains('カロリー') || label.contains('エネルギー') || label.contains('kcal')) {
              calories = value;
            } else if (label.contains('たんぱく質') || label.contains('タンパク質') || label.contains('蛋白質')) {
              protein = value;
            } else if (label.contains('脂質') || label.contains('脂肪')) {
              fat = value;
            } else if (label.contains('炭水化物')) {
              carbs = value;
            } else if (label.contains('食塩相当量') || label.contains('塩分')) {
              salt = value;
            }
          }
        }
        
        if (calories != null && calories > 0) {
          return NutritionInfo(
            calories: calories,
            protein: protein,
            fat: fat,
            carbs: carbs,
            salt: salt,
            source: 'テーブル',
          );
        }
      }
    }
    
    return null;
  }
}

/// 抽出された栄養情報
class NutritionInfo {
  final double calories;
  final double protein;
  final double fat;
  final double carbs;
  final double salt;
  final double fiber;
  final double vitaminC;
  final String source; // 抽出元の情報
  
  const NutritionInfo({
    required this.calories,
    this.protein = 0,
    this.fat = 0,
    this.carbs = 0,
    this.salt = 0,
    this.fiber = 0,
    this.vitaminC = 0,
    required this.source,
  });
  
  /// 栄養情報が有効かどうか
  bool get isValid => calories > 0;
  
  @override
  String toString() {
    return 'NutritionInfo(calories: $calories, protein: $protein, fat: $fat, carbs: $carbs, source: $source)';
  }
}