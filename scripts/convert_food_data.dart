import 'dart:convert';
import 'dart:io';

void main() async {
  print('食品成分表データの変換を開始します...');
  
  try {
    // JSONファイルを読み込み
    final file = File('/Users/shota/Downloads/standards-tables-of-food-composition-in-japan/data.json');
    final jsonString = await file.readAsString();
    final List<dynamic> jsonData = json.decode(jsonString);
    
    print('読み込んだ食品数: ${jsonData.length}');
    
    // 食材名の辞書を作成
    final foodDictionary = <String, List<Map<String, dynamic>>>{};
    final normalizedNames = <String, Set<String>>{};
    
    for (final item in jsonData) {
      final foodName = item['foodName'] as String;
      final baseName = extractBaseName(foodName);
      final normalized = normalizeName(baseName);
      
      // 辞書に追加
      if (!foodDictionary.containsKey(normalized)) {
        foodDictionary[normalized] = [];
        normalizedNames[normalized] = {};
      }
      
      foodDictionary[normalized]!.add({
        'id': item['id'],
        'foodName': foodName,
        'baseName': baseName,
        'calories': item['enercKcal'],
        'protein': item['prot'],
        'fat': item['fat'],
        'carbohydrate': item['choavl'],
      });
      
      // バリエーションを追加
      normalizedNames[normalized]!.addAll(generateVariations(baseName));
    }
    
    // 統計情報
    print('\n統計情報:');
    print('正規化された食材数: ${foodDictionary.length}');
    print('総バリエーション数: ${normalizedNames.values.map((s) => s.length).reduce((a, b) => a + b)}');
    
    // 頻出食材Top20を表示
    final sortedByCount = foodDictionary.entries.toList()
      ..sort((a, b) => b.value.length.compareTo(a.value.length));
    
    print('\n頻出食材Top20:');
    for (int i = 0; i < 20 && i < sortedByCount.length; i++) {
      final entry = sortedByCount[i];
      print('${i + 1}. ${entry.key} (${entry.value.length}種類)');
      print('   バリエーション: ${normalizedNames[entry.key]!.take(5).join(", ")}...');
    }
    
    // 辞書データを出力
    final outputFile = File('/Users/shota/Dev/HealthMeal/wellco/lib/data/seeds/food_dictionary.json');
    await outputFile.writeAsString(json.encode({
      'dictionary': foodDictionary,
      'variations': normalizedNames.map((k, v) => MapEntry(k, v.toList())),
    }, toEncodable: (obj) => obj.toString()));
    
    print('\n辞書データを保存しました: ${outputFile.path}');
    
  } catch (e) {
    print('エラーが発生しました: $e');
  }
}

/// 食品名から基本名を抽出
String extractBaseName(String foodName) {
  // 角括弧の内容を削除
  String cleaned = foodName.replaceAll(RegExp(r'\[.*?\]'), '').trim();
  
  // 最初の単語を取得
  final parts = cleaned.split(RegExp(r'[\s　]+'));
  return parts.isNotEmpty ? parts[0] : foodName;
}

/// 名前を正規化
String normalizeName(String name) {
  // カタカナをひらがなに変換
  String normalized = katakanaToHiragana(name);
  
  // 特殊な正規化ルール
  final replacements = {
    'ぶた': '豚',
    'うし': '牛',
    'にわとり': '鶏',
    'さけ': '鮭',
    'まぐろ': 'まぐろ',
    'たまねぎ': '玉ねぎ',
    'にんじん': '人参',
    'じゃがいも': 'じゃがいも',
    'きゃべつ': 'キャベツ',
    'はくさい': '白菜',
    'だいこん': '大根',
    'なす': 'なす',
    'ピーマン': 'ピーマン',
    'とまと': 'トマト',
    'きゅうり': 'きゅうり',
    'レタス': 'レタス',
    'ブロッコリー': 'ブロッコリー',
    'ほうれんそう': 'ほうれん草',
    'こまつな': '小松菜',
    'ねぎ': 'ねぎ',
  };
  
  return replacements[normalized] ?? normalized;
}

/// カタカナをひらがなに変換
String katakanaToHiragana(String text) {
  final buf = StringBuffer();
  for (int i = 0; i < text.length; i++) {
    final code = text.codeUnitAt(i);
    if (code >= 0x30A0 && code <= 0x30FF) {
      buf.writeCharCode(code - 0x60);
    } else {
      buf.write(text[i]);
    }
  }
  return buf.toString();
}

/// 名前のバリエーションを生成
Set<String> generateVariations(String baseName) {
  final variations = <String>{};
  
  // 元の名前
  variations.add(baseName);
  
  // ひらがな
  final hiragana = katakanaToHiragana(baseName);
  variations.add(hiragana);
  
  // カタカナ
  final katakana = hiraganaToKatakana(baseName);
  variations.add(katakana);
  
  // 漢字変換（固定辞書）
  final kanjiMap = {
    'にんじん': '人参',
    'たまねぎ': '玉ねぎ',
    'じゃがいも': 'じゃが芋',
    'はくさい': '白菜',
    'だいこん': '大根',
    'きゃべつ': 'キャベツ',
    'ほうれんそう': 'ほうれん草',
    'こまつな': '小松菜',
    'さつまいも': 'さつま芋',
    'ごぼう': '牛蒡',
    'れんこん': '蓮根',
    'しいたけ': '椎茸',
    'えのき': 'えのき茸',
    'しめじ': 'しめじ',
    'まいたけ': '舞茸',
  };
  
  if (kanjiMap.containsKey(hiragana)) {
    variations.add(kanjiMap[hiragana]!);
  }
  
  // 肉類の特殊処理
  if (baseName.contains('ぶた') || baseName.contains('豚')) {
    variations.addAll(['豚肉', '豚', 'ぶた肉', 'ブタ肉', 'ポーク']);
  }
  if (baseName.contains('うし') || baseName.contains('牛')) {
    variations.addAll(['牛肉', '牛', 'うし肉', 'ウシ肉', 'ビーフ']);
  }
  if (baseName.contains('とり') || baseName.contains('鶏') || baseName.contains('にわとり')) {
    variations.addAll(['鶏肉', '鶏', 'とり肉', 'トリ肉', 'チキン']);
  }
  
  return variations;
}

/// ひらがなをカタカナに変換
String hiraganaToKatakana(String text) {
  final buf = StringBuffer();
  for (int i = 0; i < text.length; i++) {
    final code = text.codeUnitAt(i);
    if (code >= 0x3040 && code <= 0x309F) {
      buf.writeCharCode(code + 0x60);
    } else {
      buf.write(text[i]);
    }
  }
  return buf.toString();
}