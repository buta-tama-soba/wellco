import 'dart:convert';

/// 材料情報
class Ingredient {
  final String name;
  final double? amount;
  final String? unit;
  final String originalText;
  final double confidence; // 抽出信頼度 0.0-1.0

  const Ingredient({
    required this.name,
    this.amount,
    this.unit,
    required this.originalText,
    this.confidence = 0.0,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'amount': amount,
    'unit': unit,
    'originalText': originalText,
    'confidence': confidence,
  };

  @override
  String toString() => '$name: ${amount ?? ''}${unit ?? ''} (${originalText})';
}

/// 規則ベース材料抽出サービス
class IngredientExtractionService {
  
  /// メイン抽出メソッド
  List<Ingredient> extractIngredients(String text) {
    final ingredients = <Ingredient>[];
    
    // テキストの前処理
    final normalizedText = _normalizeText(text);
    
    // 複数パターンで抽出
    ingredients.addAll(_extractWithPattern1(normalizedText));
    ingredients.addAll(_extractWithPattern2(normalizedText));
    ingredients.addAll(_extractWithPattern3(normalizedText));
    ingredients.addAll(_extractWithPattern4(normalizedText));
    ingredients.addAll(_extractWithPattern5(normalizedText)); // 連続形式用パターン追加
    ingredients.addAll(_extractWithPattern6(normalizedText)); // 日本語レシピ形式
    ingredients.addAll(_extractWithPattern7(normalizedText)); // 行区切り形式
    
    // 重複除去と信頼度順ソート
    return _deduplicateAndSort(ingredients);
  }

  /// テキスト正規化
  String _normalizeText(String text) {
    String result = text;
    
    // 全角数字を半角に変換
    for (int i = 0; i <= 9; i++) {
      final fullWidth = String.fromCharCode(0xFF10 + i);
      final halfWidth = i.toString();
      result = result.replaceAll(fullWidth, halfWidth);
    }
    
    return result
        // 全角記号を半角に
        .replaceAll('：', ':')
        .replaceAll('（', '(')
        .replaceAll('）', ')')
        .replaceAll('～', '~')
        .replaceAll('〜', '~')
        .replaceAll('ｇ', 'g')
        .replaceAll('ｍｌ', 'ml')
        .replaceAll('ｋｇ', 'kg')
        .replaceAll('Ｌ', 'L')
        // 括弧内の説明を適切に処理
        .replaceAll(RegExp(r'（[^）]*なら[^）]*）'), '') // 「大きめなら1本でも」等の説明を削除
        .replaceAll(RegExp(r'（[^）]*品）'), '') // 「市販品」等の説明を削除
        // 連続する空白やタブを1つの空白に
        .replaceAll(RegExp(r'[\s\t]+'), ' ')
        .trim();
  }

  /// パターン1: 基本形 材料名: 数量単位
  List<Ingredient> _extractWithPattern1(String text) {
    final pattern = RegExp(
      r'([^:\n]+):\s*([0-9]+(?:\.[0-9]+)?(?:~[0-9]+(?:\.[0-9]+)?)?)\s*(g|グラム|kg|キロ|ml|ミリリットル|L|リットル|個|コ|本|枚|束|片|玉|房|大さじ|小さじ|カップ)',
      multiLine: true,
    );
    
    return pattern.allMatches(text).map((match) {
      final name = match.group(1)!.trim();
      final amountStr = match.group(2)!;
      final unit = match.group(3)!;
      
      // 範囲指定の場合は中央値を取る
      final amount = _parseAmount(amountStr);
      
      return Ingredient(
        name: _cleanIngredientName(name),
        amount: amount,
        unit: _normalizeUnit(unit),
        originalText: match.group(0)!,
        confidence: 0.9,
      );
    }).toList();
  }

  /// パターン2: 複合形 材料名: 数量×数量単位
  List<Ingredient> _extractWithPattern2(String text) {
    final pattern = RegExp(
      r'([^:\n]+):\s*([0-9]+(?:\.[0-9]+)?)\s*(g|ml)×([0-9]+)\s*(束|個|本)',
      multiLine: true,
    );
    
    return pattern.allMatches(text).map((match) {
      final name = match.group(1)!.trim();
      final baseAmount = double.tryParse(match.group(2)!) ?? 0;
      final baseUnit = match.group(3)!;
      final multiplier = double.tryParse(match.group(4)!) ?? 1;
      final containerUnit = match.group(5)!;
      
      return Ingredient(
        name: _cleanIngredientName(name),
        amount: baseAmount * multiplier,
        unit: baseUnit,
        originalText: match.group(0)!,
        confidence: 0.8,
      );
    }).toList();
  }

  /// パターン3: 括弧付き 材料名(詳細): 数量単位
  List<Ingredient> _extractWithPattern3(String text) {
    final pattern = RegExp(
      r'([^:\n]+(?:\([^)]+\))?[^:\n]*?):\s*([0-9]+(?:\.[0-9]+)?(?:~[0-9]+(?:\.[0-9]+)?)?)\s*(g|グラム|kg|キロ|ml|ミリリットル|L|リットル|個|コ|本|枚|束|片|玉|房|大さじ|小さじ|カップ)',
      multiLine: true,
    );
    
    return pattern.allMatches(text).map((match) {
      final name = match.group(1)!.trim();
      final amountStr = match.group(2)!;
      final unit = match.group(3)!;
      
      final amount = _parseAmount(amountStr);
      
      return Ingredient(
        name: _cleanIngredientName(name),
        amount: amount,
        unit: _normalizeUnit(unit),
        originalText: match.group(0)!,
        confidence: 0.85,
      );
    }).toList();
  }

  /// パターン4: 曖昧表記 材料名: 少々/適量/適宜
  List<Ingredient> _extractWithPattern4(String text) {
    final pattern = RegExp(
      r'([^:\n]+):\s*(少々|適量|適宜)',
      multiLine: true,
    );
    
    return pattern.allMatches(text).map((match) {
      final name = match.group(1)!.trim();
      final amountDesc = match.group(2)!;
      
      return Ingredient(
        name: _cleanIngredientName(name),
        amount: null,
        unit: amountDesc,
        originalText: match.group(0)!,
        confidence: 0.7,
      );
    }).toList();
  }

  /// パターン5: 連続形式（区切り文字なし）材料名数量単位 形式
  List<Ingredient> _extractWithPattern5(String text) {
    // 材料名+数量+単位の連続パターン
    final pattern = RegExp(
      r'([あ-んア-ン一-龯]+)([0-9]+(?:\.[0-9]+)?(?:~[0-9]+(?:\.[0-9]+)?)?)\s*(g|グラム|kg|キロ|ml|ミリリットル|L|リットル|個|コ|本|枚|束|片|玉|房|大さじ|小さじ|カップ)',
      multiLine: true,
    );
    
    return pattern.allMatches(text).map((match) {
      final name = match.group(1)!.trim();
      final amountStr = match.group(2)!;
      final unit = match.group(3)!;
      
      final amount = _parseAmount(amountStr);
      
      return Ingredient(
        name: _cleanIngredientName(name),
        amount: amount,
        unit: _normalizeUnit(unit),
        originalText: match.group(0)!,
        confidence: 0.75,
      );
    }).toList();
  }

  /// パターン6: 日本語レシピ形式 材料名　…　数量単位
  List<Ingredient> _extractWithPattern6(String text) {
    // 日本語レシピでよく使われる「材料名　…　数量単位」形式
    final pattern = RegExp(
      r'([あ-んア-ンー一-龯a-zA-Z]+(?:\([^)]*\))?[あ-んア-ンー一-龯a-zA-Z]*)\s*[…・\s]+\s*([0-9]+(?:\.[0-9]+)?(?:[〜~][0-9]+(?:\.[0-9]+)?)?)\s*(ｇ|g|グラム|ｋｇ|kg|キロ|ｍｌ|ml|ミリリットル|Ｌ|L|リットル|個|コ|本|枚|束|片|玉|房|大さじ|小さじ|カップ|人分)',
      multiLine: true,
    );
    
    return pattern.allMatches(text).map((match) {
      final name = match.group(1)!.trim();
      final amountStr = match.group(2)!;
      final unit = match.group(3)!;
      
      final amount = _parseAmount(amountStr.replaceAll('〜', '~'));
      
      return Ingredient(
        name: _cleanIngredientName(name),
        amount: amount,
        unit: _normalizeUnit(unit),
        originalText: match.group(0)!,
        confidence: 0.85,
      );
    }).toList();
  }

  /// パターン7: 行区切り形式 - 1行に1つの材料
  List<Ingredient> _extractWithPattern7(String text) {
    final ingredients = <Ingredient>[];
    final lines = text.split('\n');
    
    for (final line in lines) {
      final cleanLine = line.trim();
      if (cleanLine.isEmpty || cleanLine.startsWith('【') || cleanLine.contains('作り方')) {
        continue;
      }
      
      // 材料っぽい行かチェック
      if (_looksLikeIngredient(cleanLine)) {
        // 材料名と数量を分離
        final match = RegExp(
          r'^([あ-んア-ンー一-龯a-zA-Z\s]+?)(?:\s*[…・]\s*)?([0-9]+(?:\.[0-9]+)?(?:[〜~][0-9]+(?:\.[0-9]+)?)?)\s*(ｇ|g|グラム|ｋｇ|kg|キロ|ｍｌ|ml|ミリリットル|Ｌ|L|リットル|個|コ|本|枚|束|片|玉|房|大さじ|小さじ|カップ|人分)',
        ).firstMatch(cleanLine);
        
        if (match != null) {
          final name = match.group(1)!.trim();
          final amountStr = match.group(2)!;
          final unit = match.group(3)!;
          
          final amount = _parseAmount(amountStr.replaceAll('〜', '~'));
          
          ingredients.add(Ingredient(
            name: _cleanIngredientName(name),
            amount: amount,
            unit: _normalizeUnit(unit),
            originalText: cleanLine,
            confidence: 0.8,
          ));
        } else {
          // 数量が明記されていない材料
          final simpleMatch = RegExp(r'^([あ-んア-ンー一-龯a-zA-Z\s]+?)(?:\s*[…・]\s*)?(少々|適量|適宜|お好みで)').firstMatch(cleanLine);
          if (simpleMatch != null) {
            final name = simpleMatch.group(1)!.trim();
            final amountDesc = simpleMatch.group(2)!;
            
            ingredients.add(Ingredient(
              name: _cleanIngredientName(name),
              amount: null,
              unit: amountDesc,
              originalText: cleanLine,
              confidence: 0.7,
            ));
          } else {
            // 「…」区切りだが単位がない材料（例：「オリーブオイル … 適量」）
            final fallbackMatch = RegExp(r'^([あ-んア-ンー一-龯a-zA-Z\s]+)\s*[…・]\s*(.*)').firstMatch(cleanLine);
            if (fallbackMatch != null) {
              final name = fallbackMatch.group(1)!.trim();
              final rest = fallbackMatch.group(2)!.trim();
              
              // 残りの部分が材料名の続きかどうか判定
              if (rest.isNotEmpty && rest.length < 20) {
                ingredients.add(Ingredient(
                  name: _cleanIngredientName(name),
                  amount: null,
                  unit: rest.isNotEmpty ? rest : null,
                  originalText: cleanLine,
                  confidence: 0.6,
                ));
              }
            }
          }
        }
      }
    }
    
    return ingredients;
  }

  /// 材料っぽい行かどうかを判定
  bool _looksLikeIngredient(String line) {
    // 説明文や指示文を除外
    if (RegExp(r'(大きめなら|小さめなら|お好みで|場合は|時は|なら|ば|とき)').hasMatch(line)) {
      return false;
    }
    
    // 数字が含まれているか、材料らしいキーワードが含まれている
    if (RegExp(r'[0-9]').hasMatch(line)) return true;
    if (RegExp(r'(少々|適量|適宜|お好みで)').hasMatch(line)) return true;
    
    // 一般的な材料名のパターン
    final commonIngredients = [
      'トマト', 'なす', 'そうめん', '大葉', 'ごま', 'ポン酢', 'オリーブ', '玉ねぎ',
      '人参', 'にんじん', 'じゃがいも', 'キャベツ', 'レタス', 'きゅうり', 'ピーマン',
      '鶏肉', '豚肉', '牛肉', '魚', 'エビ', 'イカ', '卵', '牛乳', '豆腐', '米', 'パン',
      '醤油', '味噌', '塩', '砂糖', '酢', '油', 'バター', 'マヨネーズ'
    ];
    
    for (final ingredient in commonIngredients) {
      if (line.contains(ingredient)) return true;
    }
    
    return false;
  }

  /// 数量解析（範囲指定対応）
  double? _parseAmount(String amountStr) {
    // 日本語数字を半角数字に変換
    String normalizedAmount = _convertJapaneseNumbers(amountStr);
    
    if (normalizedAmount.contains('~')) {
      final parts = normalizedAmount.split('~');
      if (parts.length == 2) {
        final min = double.tryParse(parts[0]) ?? 0;
        final max = double.tryParse(parts[1]) ?? 0;
        return (min + max) / 2; // 中央値
      }
    }
    return double.tryParse(normalizedAmount);
  }

  /// 日本語数字を半角数字に変換
  String _convertJapaneseNumbers(String text) {
    const japaneseNumbers = {
      '一': '1', '二': '2', '三': '3', '四': '4', '五': '5',
      '六': '6', '七': '7', '八': '8', '九': '9', '十': '10',
      '１': '1', '２': '2', '３': '3', '４': '4', '５': '5',
      '６': '6', '７': '7', '８': '8', '９': '9', '０': '0',
    };
    
    String result = text;
    japaneseNumbers.forEach((japanese, arabic) {
      result = result.replaceAll(japanese, arabic);
    });
    
    return result;
  }

  /// 材料名クリーニング
  String _cleanIngredientName(String name) {
    return name
        // 不要な記号を削除
        .replaceAll(RegExp(r'[・･]'), '')
        // 余分な空白を削除
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  /// 単位正規化
  String _normalizeUnit(String unit) {
    const unitMap = {
      'グラム': 'g',
      'ｇ': 'g',
      'キロ': 'kg',
      'ｋｇ': 'kg', 
      'ミリリットル': 'ml',
      'ｍｌ': 'ml',
      'リットル': 'L',
      'Ｌ': 'L',
      'コ': '個',
      '人分': '人前',
    };
    return unitMap[unit] ?? unit;
  }

  /// 重複除去と信頼度順ソート
  List<Ingredient> _deduplicateAndSort(List<Ingredient> ingredients) {
    final uniqueIngredients = <String, Ingredient>{};
    
    for (final ingredient in ingredients) {
      final key = ingredient.name.toLowerCase();
      if (!uniqueIngredients.containsKey(key) || 
          uniqueIngredients[key]!.confidence < ingredient.confidence) {
        uniqueIngredients[key] = ingredient;
      }
    }
    
    final result = uniqueIngredients.values.toList();
    result.sort((a, b) => b.confidence.compareTo(a.confidence));
    return result;
  }

  /// 抽出結果の統計情報
  Map<String, dynamic> getExtractionStats(List<Ingredient> ingredients) {
    final totalCount = ingredients.length;
    final withAmount = ingredients.where((i) => i.amount != null).length;
    final avgConfidence = ingredients.isEmpty 
        ? 0.0 
        : ingredients.map((i) => i.confidence).reduce((a, b) => a + b) / totalCount;
    
    return {
      'totalCount': totalCount,
      'withAmount': withAmount,
      'withoutAmount': totalCount - withAmount,
      'averageConfidence': avgConfidence,
      'highConfidenceCount': ingredients.where((i) => i.confidence >= 0.8).length,
    };
  }
}