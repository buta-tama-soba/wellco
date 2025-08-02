import 'package:drift/drift.dart';
import '../../data/datasources/app_database.dart';
import '../../data/models/japanese_food_composition_table.dart';

/// 食材辞書サービス
/// 日本食品成分表のデータを活用して、材料名のバリエーションを管理
class FoodDictionaryService {
  final AppDatabase _database;
  
  // キャッシュ
  Map<String, List<String>>? _foodNameVariations;
  List<String>? _allFoodNames;
  
  FoodDictionaryService(this._database);
  
  /// 全食品名のリストを取得
  Future<List<String>> getAllFoodNames() async {
    if (_allFoodNames != null) return _allFoodNames!;
    
    final foods = await _database.select(_database.japaneseFoodCompositionTable).get();
    
    _allFoodNames = foods.map((f) => f.foodName).toList();
    return _allFoodNames!;
  }
  
  /// 食品名のバリエーション辞書を構築
  Future<Map<String, List<String>>> buildFoodNameVariations() async {
    if (_foodNameVariations != null) return _foodNameVariations!;
    
    final foods = await _database.select(_database.japaneseFoodCompositionTable).get();
    final variations = <String, List<String>>{};
    
    for (final food in foods) {
      final baseName = _extractBaseName(food.foodName);
      final normalized = _normalizeName(baseName);
      
      if (!variations.containsKey(normalized)) {
        variations[normalized] = [];
      }
      
      // 元の名前を追加
      variations[normalized]!.add(food.foodName);
      
      // バリエーションを追加
      variations[normalized]!.addAll(_generateVariations(baseName));
    }
    
    // 重複を削除
    variations.forEach((key, value) {
      variations[key] = value.toSet().toList();
    });
    
    _foodNameVariations = variations;
    return variations;
  }
  
  /// 食品名から基本名を抽出
  String _extractBaseName(String foodName) {
    // 例: "ぶた [大型種肉] かた 脂身つき 生" -> "ぶた"
    // 例: "にんじん 根 皮つき 生" -> "にんじん"
    
    // 角括弧の内容を削除
    String cleaned = foodName.replaceAll(RegExp(r'\[.*?\]'), '').trim();
    
    // 最初の単語を取得
    final parts = cleaned.split(RegExp(r'[\s　]+'));
    return parts.isNotEmpty ? parts[0] : foodName;
  }
  
  /// 名前を正規化
  String _normalizeName(String name) {
    // カタカナをひらがなに変換
    String normalized = _katakanaToHiragana(name);
    
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
  String _katakanaToHiragana(String text) {
    final buf = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      final code = text.codeUnitAt(i);
      // カタカナの範囲: 0x30A0 - 0x30FF
      // ひらがなの範囲: 0x3040 - 0x309F
      if (code >= 0x30A0 && code <= 0x30FF) {
        buf.writeCharCode(code - 0x60);
      } else {
        buf.write(text[i]);
      }
    }
    return buf.toString();
  }
  
  /// 名前のバリエーションを生成
  List<String> _generateVariations(String baseName) {
    final variations = <String>[];
    
    // ひらがな
    final hiragana = _katakanaToHiragana(baseName);
    variations.add(hiragana);
    
    // カタカナ
    final katakana = _hiraganaToKatakana(baseName);
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
  String _hiraganaToKatakana(String text) {
    final buf = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      final code = text.codeUnitAt(i);
      // ひらがなの範囲: 0x3040 - 0x309F
      // カタカナの範囲: 0x30A0 - 0x30FF
      if (code >= 0x3040 && code <= 0x309F) {
        buf.writeCharCode(code + 0x60);
      } else {
        buf.write(text[i]);
      }
    }
    return buf.toString();
  }
  
  /// 材料名から最適な食品を検索
  Future<JapaneseFoodCompositionTableData?> findBestMatch(String ingredientName) async {
    final variations = await buildFoodNameVariations();
    final cleanedName = ingredientName.toLowerCase().trim();
    
    // 1. 正規化された名前で検索
    for (final entry in variations.entries) {
      final normalizedKey = entry.key.toLowerCase();
      final variationList = entry.value.map((v) => v.toLowerCase()).toList();
      
      // キーまたはバリエーションに含まれるか確認
      if (normalizedKey == cleanedName || 
          variationList.contains(cleanedName) ||
          normalizedKey.contains(cleanedName) ||
          cleanedName.contains(normalizedKey)) {
        
        // 最初の食品データを返す
        final foods = await (_database.select(_database.japaneseFoodCompositionTable)
          ..where((t) => t.foodName.like('%${entry.key}%')))
          .get();
        
        if (foods.isNotEmpty) {
          return foods.first;
        }
      }
    }
    
    // 2. 部分一致で検索
    final foods = await (_database.select(_database.japaneseFoodCompositionTable)
      ..where((t) => t.foodName.like('%$cleanedName%')))
      .get();
    
    return foods.isNotEmpty ? foods.first : null;
  }
  
  /// 材料カテゴリを判定
  String? detectFoodCategory(String ingredientName) {
    final name = ingredientName.toLowerCase();
    
    // カテゴリ判定ルール
    if (RegExp(r'(肉|ぶた|うし|とり|鶏|牛|豚|ポーク|ビーフ|チキン)').hasMatch(name)) {
      return '肉類';
    }
    if (RegExp(r'(魚|さかな|鮭|まぐろ|さば|いわし|あじ|さんま)').hasMatch(name)) {
      return '魚介類';
    }
    if (RegExp(r'(野菜|やさい|人参|玉ねぎ|じゃがいも|キャベツ|レタス|トマト)').hasMatch(name)) {
      return '野菜類';
    }
    if (RegExp(r'(果物|くだもの|りんご|みかん|バナナ|いちご|ぶどう)').hasMatch(name)) {
      return '果物類';
    }
    if (RegExp(r'(米|ごはん|パン|麺|うどん|そば|パスタ)').hasMatch(name)) {
      return '穀類';
    }
    if (RegExp(r'(牛乳|ミルク|チーズ|ヨーグルト|バター)').hasMatch(name)) {
      return '乳製品';
    }
    if (RegExp(r'(豆腐|とうふ|納豆|なっとう|大豆|だいず)').hasMatch(name)) {
      return '豆類';
    }
    if (RegExp(r'(塩|砂糖|醤油|しょうゆ|味噌|みそ|酢|油)').hasMatch(name)) {
      return '調味料';
    }
    
    return null;
  }
}