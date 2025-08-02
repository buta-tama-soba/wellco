/// 基本的な食品マッピングデータ（日本の一般的な食材）
/// 
/// 注意: これは実装例であり、実際の運用では文部科学省の
/// 日本食品標準成分表から正確なデータを取得する必要があります

class BasicFoodMappingSeed {
  /// 基本的な食品マッピングデータ
  static const List<Map<String, dynamic>> basicMappings = [
    // 野菜類
    {
      'ingredientName': '玉ねぎ',
      'aliases': 'たまねぎ,タマネギ,onion',
      'category': '野菜',
      'unitConversionFactor': 200.0, // 1個 = 200g
      'unit': '個',
      'ediblePortion': 0.95, // 廃棄率5%
      'nutritionData': {
        'foodNumber': '06001',
        'foodName': 'たまねぎ 鱗茎 生',
        'energy': 37.0,
        'protein': 1.0,
        'fat': 0.1,
        'carbohydrate': 8.8,
        'sodium': 2.0,
        'potassium': 150.0,
        'calcium': 21.0,
        'dietaryFiber': 1.6,
      }
    },
    {
      'ingredientName': 'なす',
      'aliases': 'ナス,茄子,eggplant',
      'category': '野菜',
      'unitConversionFactor': 80.0, // 1本 = 80g
      'unit': '本',
      'ediblePortion': 0.95,
      'nutritionData': {
        'foodNumber': '06014',
        'foodName': 'なす 果実 生',
        'energy': 22.0,
        'protein': 1.1,
        'fat': 0.1,
        'carbohydrate': 5.1,
        'sodium': 1.0,
        'potassium': 220.0,
        'calcium': 18.0,
        'dietaryFiber': 2.2,
      }
    },
    {
      'ingredientName': 'ピーマン',
      'aliases': 'green pepper',
      'category': '野菜',
      'unitConversionFactor': 30.0, // 1個 = 30g
      'unit': '個',
      'ediblePortion': 0.85, // 種と軸を除く
      'nutritionData': {
        'foodNumber': '06024',
        'foodName': 'ピーマン 果実 生',
        'energy': 22.0,
        'protein': 0.9,
        'fat': 0.2,
        'carbohydrate': 5.1,
        'sodium': 1.0,
        'potassium': 190.0,
        'calcium': 11.0,
        'vitaminC': 76.0,
        'dietaryFiber': 2.3,
      }
    },
    {
      'ingredientName': 'さやいんげん',
      'aliases': 'いんげん,インゲン,green beans',
      'category': '野菜',
      'unitConversionFactor': 8.0, // 1本 = 8g
      'unit': '本',
      'ediblePortion': 0.90,
      'nutritionData': {
        'foodNumber': '06015',
        'foodName': 'いんげんまめ さやいんげん 若ざや 生',
        'energy': 23.0,
        'protein': 1.8,
        'fat': 0.1,
        'carbohydrate': 4.6,
        'sodium': 1.0,
        'potassium': 260.0,
        'calcium': 40.0,
        'dietaryFiber': 2.4,
      }
    },

    // 肉類
    {
      'ingredientName': '豚肉',
      'aliases': '豚,ぶた肉,pork',
      'category': '肉類',
      'unitConversionFactor': 100.0, // 1枚 = 100g（目安）
      'unit': '枚',
      'ediblePortion': 1.0,
      'nutritionData': {
        'foodNumber': '11005',
        'foodName': 'ぶた 肩ロース 脂身つき 生',
        'energy': 253.0,
        'protein': 17.1,
        'fat': 19.2,
        'carbohydrate': 0.2,
        'sodium': 54.0,
        'potassium': 300.0,
        'iron': 0.6,
      }
    },
    {
      'ingredientName': '豚しゃぶ肉',
      'aliases': '豚薄切り肉,豚バラ薄切り',
      'category': '肉類',
      'unitConversionFactor': 100.0,
      'unit': 'g',
      'ediblePortion': 1.0,
      'nutritionData': {
        'foodNumber': '11007',
        'foodName': 'ぶた ばら 脂身つき 生',
        'energy': 386.0,
        'protein': 14.2,
        'fat': 34.6,
        'carbohydrate': 0.1,
        'sodium': 48.0,
        'potassium': 240.0,
        'iron': 0.6,
      }
    },
    {
      'ingredientName': '鶏もも肉',
      'aliases': '鶏肉,とり肉,chicken thigh',
      'category': '肉類',
      'unitConversionFactor': 250.0, // 1枚 = 250g
      'unit': '枚',
      'ediblePortion': 1.0,
      'nutritionData': {
        'foodNumber': '11015',
        'foodName': 'にわとり もも 皮つき 生',
        'energy': 200.0,
        'protein': 16.2,
        'fat': 14.0,
        'carbohydrate': 0.0,
        'sodium': 98.0,
        'potassium': 270.0,
        'iron': 0.6,
      }
    },

    // 調味料類
    {
      'ingredientName': '醤油',
      'aliases': 'しょうゆ,しょう油,soy sauce',
      'category': '調味料',
      'unitConversionFactor': 15.0, // 大さじ1 = 15ml
      'unit': '大さじ',
      'ediblePortion': 1.0,
      'nutritionData': {
        'foodNumber': '18001',
        'foodName': 'しょうゆ 濃口',
        'energy': 71.0,
        'protein': 7.7,
        'fat': 0.0,
        'carbohydrate': 10.1,
        'sodium': 5700.0,
        'potassium': 610.0,
      }
    },
    {
      'ingredientName': 'みりん',
      'aliases': 'mirin',
      'category': '調味料',
      'unitConversionFactor': 15.0, // 大さじ1 = 15ml
      'unit': '大さじ',
      'ediblePortion': 1.0,
      'nutritionData': {
        'foodNumber': '18011',
        'foodName': 'みりん 本みりん',
        'energy': 241.0,
        'protein': 0.1,
        'fat': 0.0,
        'carbohydrate': 43.2,
        'sodium': 11.0,
        'potassium': 5.0,
      }
    },
    {
      'ingredientName': 'ごま油',
      'aliases': 'sesame oil',
      'category': '調味料',
      'unitConversionFactor': 5.0, // 小さじ1 = 5ml
      'unit': '小さじ',
      'ediblePortion': 1.0,
      'nutritionData': {
        'foodNumber': '17024',
        'foodName': 'ごま油',
        'energy': 921.0,
        'protein': 0.0,
        'fat': 100.0,
        'carbohydrate': 0.0,
        'sodium': 0.0,
        'vitaminE': 0.1,
      }
    },

    // 主食類
    {
      'ingredientName': 'そうめん',
      'aliases': '素麺,そーめん,somen',
      'category': '主食',
      'unitConversionFactor': 50.0, // 1束 = 50g
      'unit': '束',
      'ediblePortion': 1.0,
      'nutritionData': {
        'foodNumber': '01020',
        'foodName': 'そうめん・ひやむぎ 乾',
        'energy': 356.0,
        'protein': 9.5,
        'fat': 1.1,
        'carbohydrate': 72.7,
        'sodium': 1800.0,
        'potassium': 120.0,
      }
    },

    // その他
    {
      'ingredientName': 'だし汁',
      'aliases': 'だし,出汁,dashi',
      'category': 'その他',
      'unitConversionFactor': 1.0, // 1ml = 1g
      'unit': 'ml',
      'ediblePortion': 1.0,
      'nutritionData': {
        'foodNumber': '19001',
        'foodName': 'かつおだし',
        'energy': 3.0,
        'protein': 0.8,
        'fat': 0.0,
        'carbohydrate': 0.1,
        'sodium': 270.0,
        'potassium': 88.0,
      }
    },
    {
      'ingredientName': 'ちりめんじゃこ',
      'aliases': 'しらす干し,じゃこ',
      'category': '魚介類',
      'unitConversionFactor': 15.0, // 大さじ1 = 15g
      'unit': '大さじ',
      'ediblePortion': 1.0,
      'nutritionData': {
        'foodNumber': '10042',
        'foodName': 'しらす干し 半乾燥品',
        'energy': 206.0,
        'protein': 40.5,
        'fat': 3.6,
        'carbohydrate': 0.5,
        'sodium': 1100.0,
        'calcium': 520.0,
      }
    },
  ];

  /// シード実行のためのSQL生成（参考）
  static String generateInsertSQL() {
    final buffer = StringBuffer();
    
    buffer.writeln('-- 基本的な食品マッピングデータ');
    buffer.writeln('-- 注意: 実際の数値は文部科学省の公式データを使用してください\n');
    
    for (int i = 0; i < basicMappings.length; i++) {
      final mapping = basicMappings[i];
      final nutrition = mapping['nutritionData'] as Map<String, dynamic>;
      
      // 栄養データテーブルへの挿入
      buffer.writeln('INSERT INTO nutrition_data_table (');
      buffer.writeln('  food_number, food_name, energy, protein, fat, carbohydrate,');
      buffer.writeln('  sodium, potassium, calcium, dietary_fiber, vitamin_c, iron');
      buffer.writeln(') VALUES (');
      buffer.writeln("  '${nutrition['foodNumber']}',");
      buffer.writeln("  '${nutrition['foodName']}',");
      buffer.writeln("  ${nutrition['energy']},");
      buffer.writeln("  ${nutrition['protein']},");
      buffer.writeln("  ${nutrition['fat']},");
      buffer.writeln("  ${nutrition['carbohydrate']},");
      buffer.writeln("  ${nutrition['sodium']},");
      buffer.writeln("  ${nutrition['potassium'] ?? 0},");
      buffer.writeln("  ${nutrition['calcium'] ?? 0},");
      buffer.writeln("  ${nutrition['dietaryFiber'] ?? 0},");
      buffer.writeln("  ${nutrition['vitaminC'] ?? 0},");
      buffer.writeln("  ${nutrition['iron'] ?? 0}");
      buffer.writeln(');\n');
      
      // 食品マッピングテーブルへの挿入
      buffer.writeln('INSERT INTO food_mapping_table (');
      buffer.writeln('  ingredient_name, nutrition_data_id, confidence,');
      buffer.writeln('  unit_conversion_factor, unit, aliases, category, edible_portion');
      buffer.writeln(') VALUES (');
      buffer.writeln("  '${mapping['ingredientName']}',");
      buffer.writeln("  (SELECT id FROM nutrition_data_table WHERE food_number = '${nutrition['foodNumber']}'),");
      buffer.writeln("  0.9,");
      buffer.writeln("  ${mapping['unitConversionFactor']},");
      buffer.writeln("  '${mapping['unit']}',");
      buffer.writeln("  '${mapping['aliases']}',");
      buffer.writeln("  '${mapping['category']}',");
      buffer.writeln("  ${mapping['ediblePortion']}");
      buffer.writeln(');\n');
    }
    
    return buffer.toString();
  }
}