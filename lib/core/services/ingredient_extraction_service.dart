import 'dart:convert';
import '../../data/seeds/enhanced_food_dictionary.dart';

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
    ingredients.addAll(_extractWithPattern8(normalizedText)); // 白ごはん.com連続形式
    ingredients.addAll(_extractWithPattern9(normalizedText)); // 複数選択肢処理
    ingredients.addAll(_extractWithPattern10(normalizedText)); // 味の素パーク「・・・」形式
    ingredients.addAll(_extractWithPattern11(normalizedText)); // レタスクラブスペース区切り形式
    ingredients.addAll(_extractWithPattern12(normalizedText)); // 記号系パターン対応
    ingredients.addAll(_extractWithPattern13(normalizedText)); // 柔軟な材料セクション抽出
    
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
        // 連続する空白やタブを1つの空白に（改行は保持）
        .replaceAll(RegExp(r'[ \t]+'), ' ')
        .trim();
  }

  /// パターン1: 基本形 材料名: 数量単位
  List<Ingredient> _extractWithPattern1(String text) {
    final pattern = RegExp(
      r'([^:\n]+):\s*([0-9]+(?:\.[0-9]+)?(?:~[0-9]+(?:\.[0-9]+)?)?)\s*(g|グラム|kg|キロ|ml|ミリリットル|L|リットル|個|コ|本|枚|束|片|玉|房|大さじ|小さじ|カップ)',
      multiLine: true,
    );
    
    return pattern.allMatches(text).where((match) {
      final name = match.group(1)!.trim();
      return EnhancedFoodDictionary.isIngredient(name);
    }).map((match) {
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
    
    return pattern.allMatches(text).where((match) {
      final name = match.group(1)!.trim();
      return EnhancedFoodDictionary.isIngredient(name);
    }).map((match) {
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
    
    return pattern.allMatches(text).where((match) {
      final name = match.group(1)!.trim();
      return EnhancedFoodDictionary.isIngredient(name);
    }).map((match) {
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
    
    return pattern.allMatches(text).where((match) {
      final name = match.group(1)!.trim();
      return EnhancedFoodDictionary.isIngredient(name);
    }).map((match) {
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
    
    return pattern.allMatches(text).where((match) {
      final name = match.group(1)!.trim();
      return EnhancedFoodDictionary.isIngredient(name);
    }).map((match) {
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
    
    return pattern.allMatches(text).where((match) {
      final name = match.group(1)!.trim();
      // 栄養成分等の除外パターンをチェック
      return EnhancedFoodDictionary.isIngredient(name);
    }).map((match) {
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

  /// パターン8: 白ごはん.com連続形式 - 材料名直接数量単位
  List<Ingredient> _extractWithPattern8(String text) {
    final ingredients = <Ingredient>[];
    
    // 白ごはん.comでよく使われる連続パターン
    // 例: "牛肉（すき焼き用）400～500ｇ", "玉ねぎ1/2個", "椎茸7～8枚"
    final patterns = [
      // パターン8-1: 材料名（詳細）数量～数量単位
      RegExp(r'([あ-んア-ンー一-龯a-zA-Z]+(?:\([^)]*\))?[あ-んア-ンー一-龯a-zA-Z]*)([0-9]+(?:\.[0-9]+)?[～〜~][0-9]+(?:\.[0-9]+)?)\s*(ｇ|g|グラム|ｋｇ|kg|キロ|ｍｌ|ml|ミリリットル|Ｌ|L|リットル|個|コ|本|枚|束|片|玉|房|丁|袋|缶)', multiLine: true),
      
      // パターン8-2: 材料名（詳細）数量単位
      RegExp(r'([あ-んア-ンー一-龯a-zA-Z]+(?:\([^)]*\))?[あ-んア-ンー一-龯a-zA-Z]*)([0-9]+(?:\.[0-9]+)?)\s*(ｇ|g|グラム|ｋｇ|kg|キロ|ｍｌ|ml|ミリリットル|Ｌ|L|リットル|個|コ|本|枚|束|片|玉|房|丁|袋|缶)', multiLine: true),
      
      // パターン8-3: 材料名数量/数量単位 (分数表記)
      RegExp(r'([あ-んア-ンー一-龯a-zA-Z]+)([0-9]+/[0-9]+)\s*(個|コ|本|枚|束|片|玉|房|丁|袋|缶)', multiLine: true),
      
      // パターン8-4: 材料名曖昧表記
      RegExp(r'([あ-んア-ンー一-龯a-zA-Z]+(?:\([^)]*\))?[あ-んア-ンー一-龯a-zA-Z]*)(適量|好みで|各少々|少々)', multiLine: true),
    ];
    
    for (final pattern in patterns) {
      final matches = pattern.allMatches(text).where((match) {
        final name = match.group(1)!.trim();
        return EnhancedFoodDictionary.isIngredient(name);
      });
      
      for (final match in matches) {
        final name = match.group(1)!.trim();
        final amountStr = match.group(2)!;
        final unit = match.groupCount >= 3 ? match.group(3) : null;
        
        double? amount;
        String? finalUnit = unit;
        
        // 分数処理
        if (amountStr.contains('/')) {
          final parts = amountStr.split('/');
          if (parts.length == 2) {
            final numerator = double.tryParse(parts[0]) ?? 0;
            final denominator = double.tryParse(parts[1]) ?? 1;
            amount = numerator / denominator;
          }
        } 
        // 範囲処理
        else if (amountStr.contains('～') || amountStr.contains('〜') || amountStr.contains('~')) {
          amount = _parseAmount(amountStr);
        }
        // 曖昧表記
        else if (amountStr == '適量' || amountStr == '好みで' || amountStr == '各少々' || amountStr == '少々') {
          amount = null;
          finalUnit = amountStr;
        }
        // 通常の数値
        else {
          amount = double.tryParse(amountStr);
        }
        
        ingredients.add(Ingredient(
          name: _cleanIngredientName(name),
          amount: amount,
          unit: finalUnit != null ? _normalizeUnit(finalUnit) : null,
          originalText: match.group(0)!,
          confidence: 0.8,
        ));
      }
    }
    
    return ingredients;
  }

  /// パターン9: 複数選択肢・曖昧表現対応
  List<Ingredient> _extractWithPattern9(String text) {
    final ingredients = <Ingredient>[];
    
    // 複数選択肢パターン: "白菜または キャベツ 200g"
    final orPattern = RegExp(
      r'([あ-んア-ンー一-龯a-zA-Z]+)または\s*([あ-んア-ンー一-龯a-zA-Z]+)\s+([0-9]+(?:\.[0-9]+)?(?:/[0-9]+)?(?:[～〜~][0-9]+(?:\.[0-9]+)?(?:/[0-9]+)?)?)\s*(ｇ|g|グラム|ｋｇ|kg|キロ|ｍｌ|ml|ミリリットル|Ｌ|L|リットル|個|コ|本|枚|束|片|玉|房|丁|袋|缶)',
      multiLine: true,
    );
    
    for (final match in orPattern.allMatches(text)) {
      final ingredient1 = match.group(1)!.trim();
      final ingredient2 = match.group(2)!.trim();
      final amountStr = match.group(3)!;
      final unit = match.group(4)!;
      
      // 両方の選択肢を材料として追加（辞書でチェック）
      for (final ingredient in [ingredient1, ingredient2]) {
        if (EnhancedFoodDictionary.isIngredient(ingredient)) {
          ingredients.add(Ingredient(
            name: _cleanIngredientName(ingredient),
            amount: _parseAmount(amountStr),
            unit: _normalizeUnit(unit),
            originalText: match.group(0)!,
            confidence: 0.75, // 選択肢なので少し低めの信頼度
          ));
        }
      }
    }
    
    // 曖昧表現拡張パターン
    final ambiguousPatterns = [
      // "生姜 小ひとかけ(約10g)"
      RegExp(r'([あ-んア-ンー一-龯a-zA-Z]+)\s+(小ひとかけ|ひとかけ|少し)\s*(?:\(約([0-9]+(?:\.[0-9]+)?)([ｇ|g|グラム|ml|ミリリットル]*)\))?', multiLine: true),
      
      // "サラダ油や米油など 小さじ1"
      RegExp(r'([あ-んア-ンー一-龯a-zA-Z]+)や[あ-んア-ンー一-龯a-zA-Z]+など\s+([0-9]+(?:\.[0-9]+)?(?:/[0-9]+)?)\s*(大さじ|小さじ|カップ)', multiLine: true),
      
      // "こしょうや粗びき黒こしょう 少々"
      RegExp(r'([あ-んア-ンー一-龯a-zA-Z]+)や[あ-んア-ンー一-龯a-zA-Z]+\s+(少々|適量)', multiLine: true),
    ];
    
    for (final pattern in ambiguousPatterns) {
      for (final match in pattern.allMatches(text)) {
        final name = match.group(1)!.trim();
        
        if (EnhancedFoodDictionary.isIngredient(name)) {
          double? amount;
          String? unit;
          
          // 括弧内に具体的な重量がある場合
          if (match.groupCount >= 3 && match.group(3) != null) {
            amount = double.tryParse(match.group(3)!);
            unit = match.group(4);
          } 
          // 通常の数量がある場合
          else if (match.groupCount >= 2 && match.group(2) != null) {
            final amountStr = match.group(2)!;
            if (RegExp(r'^[0-9]+').hasMatch(amountStr)) {
              amount = _parseAmount(amountStr);
              unit = match.groupCount >= 3 ? match.group(3) : null;
            } else {
              // "少々", "適量" など
              unit = amountStr;
            }
          }
          
          ingredients.add(Ingredient(
            name: _cleanIngredientName(name),
            amount: amount,
            unit: unit != null ? _normalizeUnit(unit) : null,
            originalText: match.group(0)!,
            confidence: 0.75,
          ));
        }
      }
    }
    
    return ingredients;
  }

  /// パターン10: 味の素パーク「・・・」区切り形式
  List<Ingredient> _extractWithPattern10(String text) {
    final ingredients = <Ingredient>[];
    
    // 味の素パーク特有の「・・・」区切りパターン
    final patterns = [
      // パターン10-1: 材料・・・数量単位
      RegExp(r'([あ-んア-ンー一-龯a-zA-Z]+(?:\([^)]*\))?[あ-んア-ンー一-龯a-zA-Z]*)\s*・・・\s*([0-9]+(?:\.[0-9]+)?(?:/[0-9]+)?(?:[～〜~][0-9]+(?:\.[0-9]+)?(?:/[0-9]+)?)?)\s*(ｇ|g|グラム|ｋｇ|kg|キロ|ｍｌ|ml|ミリリットル|Ｌ|L|リットル|個|コ|本|枚|束|片|玉|房|丁|袋|缶|杯|大さじ|小さじ|カップ)', multiLine: true),
      
      // パターン10-2: 材料・・・曖昧表記
      RegExp(r'([あ-んア-ンー一-龯a-zA-Z]+(?:\([^)]*\))?[あ-んア-ンー一-龯a-zA-Z]*)\s*・・・\s*(適量|少々|お好みで)', multiLine: true),
      
      // パターン10-3: 商品名・・・数量単位 (「」で囲まれた商品)
      RegExp(r'「([^」]+)」\s*・・・\s*([0-9]+(?:\.[0-9]+)?(?:/[0-9]+)?)\s*(大さじ|小さじ|カップ|g|ml)', multiLine: true),
      
      // パターン10-4: 缶詰・容器表記・・・数量（詳細）
      RegExp(r'([あ-んア-ンー一-龯a-zA-Z]+)\s*・・・\s*([0-9]+)\s*(缶|パック|袋)\s*(?:\(([0-9]+(?:\.[0-9]+)?)([ｇ|g|ml]*)\))?', multiLine: true),
    ];
    
    for (final pattern in patterns) {
      for (final match in pattern.allMatches(text)) {
        String name = match.group(1)!.trim();
        double? amount;
        String? unit;
        
        // 商品名の正規化処理
        name = _normalizeProductName(name);
        
        if (!EnhancedFoodDictionary.isIngredient(name)) {
          continue;
        }
        
        // パターンに応じた解析
        if (match.groupCount >= 2) {
          final amountOrUnit = match.group(2)!;
          
          // 数値かどうかチェック
          if (RegExp(r'^[0-9]+').hasMatch(amountOrUnit)) {
            amount = _parseAmount(amountOrUnit);
            unit = match.groupCount >= 3 ? match.group(3) : null;
            
            // 括弧内の詳細重量がある場合（缶詰など）
            if (match.groupCount >= 5 && match.group(4) != null) {
              amount = double.tryParse(match.group(4)!);
              unit = match.group(5);
            }
          } else {
            // 曖昧表記
            unit = amountOrUnit;
          }
        }
        
        ingredients.add(Ingredient(
          name: _cleanIngredientName(name),
          amount: amount,
          unit: unit != null ? _normalizeUnit(unit) : null,
          originalText: match.group(0)!,
          confidence: 0.85,
        ));
      }
    }
    
    return ingredients;
  }
  
  /// 商品名の正規化（味の素パーク対応）
  String _normalizeProductName(String productName) {
    // 商品名から一般的な食材名への変換
    final productMapping = {
      'ほんだし': 'だし',
      'Cook Do 香味ペースト': '中華だし',
      '丸鶏がらスープ': 'だし',
      'ツナ缶': 'ツナ',
      '木綿豆腐': '豆腐',
      '絹ごし豆腐': '豆腐',
    };
    
    // 完全一致での変換
    if (productMapping.containsKey(productName)) {
      return productMapping[productName]!;
    }
    
    // 部分一致での変換
    for (final entry in productMapping.entries) {
      if (productName.contains(entry.key)) {
        return entry.value;
      }
    }
    
    return productName;
  }

  /// パターン11: レタスクラブスペース区切り形式
  List<Ingredient> _extractWithPattern11(String text) {
    final ingredients = <Ingredient>[];
    
    // レタスクラブ特有のスペース区切りパターン
    final patterns = [
      // パターン11-1: 材料名 サイズ数量(詳細重量)
      RegExp(r'([あ-んア-ンー一-龯a-zA-Z]+)\s+(小|中|大|特大)?([0-9]+)\s*(枚|個|本|玉|房|丁|袋|パック|杯|缶)\s*(?:\(約([0-9]+(?:\.[0-9]+)?)([ｇ|g|ml]*)\))?', multiLine: true),
      
      // パターン11-2: 材料名 数量〜数量単位
      RegExp(r'([あ-んア-ンー一-龯a-zA-Z]+)\s+([0-9]+(?:\.[0-9]+)?[～〜~][0-9]+(?:\.[0-9]+)?)\s*(枚|個|本|玉|房|丁|袋|パック|杯)', multiLine: true),
      
      // パターン11-3: 材料名 数量/数量単位
      RegExp(r'([あ-んア-ンー一-龯a-zA-Z]+)\s+([0-9]+/[0-9]+)\s*(個|本|玉|房|丁|袋|パック|杯)', multiLine: true),
      
      // パターン11-4: 調理後材料名 数量個分・本分
      RegExp(r'([あ-んア-ンー一-龯a-zA-Z]+)の(みじん切り|粗みじん切り|千切り|輪切り|薄切り)\s+([0-9]+/[0-9]+|[0-9]+(?:\.[0-9]+)?)\s*(個分|本分|片分)', multiLine: true),
      
      // パターン11-5: 材料名 数量g
      RegExp(r'([あ-んア-ンー一-龯a-zA-Z]+)\s+([0-9]+(?:\.[0-9]+)?)\s*(ｇ|g|グラム|ml|ミリリットル)', multiLine: true),
      
      // パターン11-6: 容器付き材料名 数量杯分
      RegExp(r'([あ-んア-ンー一-龯a-zA-Z]+)\s+(どんぶり|茶碗|カップ)?([0-9]+)\s*(杯分|杯)', multiLine: true),
      
      // パターン11-7: 材料名 適量
      RegExp(r'([あ-んア-ンー一-龯a-zA-Z]+)\s+(適量|少々)', multiLine: true),
    ];
    
    for (final pattern in patterns) {
      for (final match in pattern.allMatches(text)) {
        String name = match.group(1)!.trim();
        double? amount;
        String? unit;
        
        // 調理後表記の場合は基本材料名に正規化
        if (match.groupCount >= 2 && match.group(2) != null) {
          final cookingMethod = match.group(2)!;
          if (['みじん切り', '粗みじん切り', '千切り', '輪切り', '薄切り'].contains(cookingMethod)) {
            // 調理方法を削除して基本材料名のみにする
            // 例: "玉ねぎのみじん切り" → "玉ねぎ"
          }
        }
        
        if (!EnhancedFoodDictionary.isIngredient(name)) {
          continue;
        }
        
        // パターンに応じた数量・単位解析
        if (match.groupCount >= 3) {
          final amountStr = match.group(3)!;
          
          // 分数処理
          if (amountStr.contains('/')) {
            amount = _parseSingleFraction(amountStr);
          }
          // 範囲処理
          else if (amountStr.contains('～') || amountStr.contains('〜') || amountStr.contains('~')) {
            amount = _parseAmount(amountStr);
          }
          // 通常の数値
          else if (RegExp(r'^[0-9]+').hasMatch(amountStr)) {
            amount = double.tryParse(amountStr);
          }
          // 曖昧表記
          else if (['適量', '少々'].contains(amountStr)) {
            unit = amountStr;
          }
          
          // 単位の設定
          if (match.groupCount >= 4 && match.group(4) != null) {
            unit = match.group(4);
          }
          
          // 括弧内の詳細重量がある場合（優先）
          if (match.groupCount >= 6 && match.group(5) != null) {
            amount = double.tryParse(match.group(5)!);
            unit = match.group(6);
          }
        }
        
        ingredients.add(Ingredient(
          name: _cleanIngredientName(name),
          amount: amount,
          unit: unit != null ? _normalizeUnit(unit) : null,
          originalText: match.group(0)!,
          confidence: 0.8,
        ));
      }
    }
    
    return ingredients;
  }

  /// パターン12: 記号系パターン対応（■★◎●①・等）
  List<Ingredient> _extractWithPattern12(String text) {
    final ingredients = <Ingredient>[];
    
    // 主要レシピサイトの記号系パターン
    final patterns = [
      // パターン12-1: ■★☆記号 材料名 数量単位
      RegExp(r'[■★☆▲▼◆◇]\s*([あ-んア-ンー一-龯a-zA-Z]+(?:\([^)]*\))?[あ-んア-ンー一-龯a-zA-Z]*)\s+([0-9]+(?:\.[0-9]+)?(?:/[0-9]+)?(?:[～〜~][0-9]+(?:\.[0-9]+)?(?:/[0-9]+)?)?)\s*(ｇ|g|グラム|ｋｇ|kg|キロ|ｍｌ|ml|ミリリットル|Ｌ|L|リットル|個|コ|本|枚|束|片|玉|房|丁|袋|缶|杯|大さじ|小さじ|カップ)', multiLine: true),
      
      // パターン12-2: ◎●○記号材料名・・・数量単位
      RegExp(r'[◎●○△▽]\s*([あ-んア-ンー一-龯a-zA-Z]+(?:\([^)]*\))?[あ-んア-ンー一-龯a-zA-Z]*)\s*[・・・]+\s*([0-9]+(?:\.[0-9]+)?(?:/[0-9]+)?(?:[～〜~][0-9]+(?:\.[0-9]+)?(?:/[0-9]+)?)?)\s*(ｇ|g|グラム|ｋｇ|kg|キロ|ｍｌ|ml|ミリリットル|Ｌ|L|リットル|個|コ|本|枚|束|片|玉|房|丁|袋|缶|杯|大さじ|小さじ|カップ)', multiLine: true),
      
      // パターン12-3: ①②③数字記号材料名 数量単位
      RegExp(r'[①②③④⑤⑥⑦⑧⑨⑩]\s*([あ-んア-ンー一-龯a-zA-Z]+(?:\([^)]*\))?[あ-んア-ンー一-龯a-zA-Z]*)\s+([0-9]+(?:\.[0-9]+)?(?:/[0-9]+)?(?:[～〜~][0-9]+(?:\.[0-9]+)?(?:/[0-9]+)?)?)\s*(ｇ|g|グラム|ｋｇ|kg|キロ|ｍｌ|ml|ミリリットル|Ｌ|L|リットル|個|コ|本|枚|束|片|玉|房|丁|袋|缶|杯|大さじ|小さじ|カップ)', multiLine: true),
      
      // パターン12-4: A B C アルファベット記号 材料名 数量単位
      RegExp(r'[A-Z]\s+([あ-んア-ンー一-龯a-zA-Z]+(?:\([^)]*\))?[あ-んア-ンー一-龯a-zA-Z]*)\s+([0-9]+(?:\.[0-9]+)?(?:/[0-9]+)?(?:[～〜~][0-9]+(?:\.[0-9]+)?(?:/[0-9]+)?)?)\s*(ｇ|g|グラム|ｋｇ|kg|キロ|ｍｌ|ml|ミリリットル|Ｌ|L|リットル|個|コ|本|枚|束|片|玉|房|丁|袋|缶|杯|大さじ|小さじ|カップ)', multiLine: true),
      
      // パターン12-5: ・前置詞 材料名（量） 数量単位
      RegExp(r'・\s*([あ-んア-ンー一-龯a-zA-Z]+(?:\([^)]*\))?[あ-んア-ンー一-龯a-zA-Z]*)\s+([0-9]+(?:\.[0-9]+)?(?:/[0-9]+)?(?:[～〜~][0-9]+(?:\.[0-9]+)?(?:/[0-9]+)?)?)\s*(ｇ|g|グラム|ｋｇ|kg|キロ|ｍｌ|ml|ミリリットル|Ｌ|L|リットル|個|コ|本|枚|束|片|玉|房|丁|袋|缶|杯|大さじ|小さじ|カップ)', multiLine: true),
      
      // パターン12-6: 記号 材料名 適量
      RegExp(r'[■★☆▲▼◆◇◎●○△▽①②③④⑤⑥⑦⑧⑨⑩A-Z・]\s*([あ-んア-ンー一-龯a-zA-Z]+(?:\([^)]*\))?[あ-んア-ンー一-龯a-zA-Z]*)\s+(適量|少々|お好みで)', multiLine: true),
      
      // パターン12-7: 複雑な分数 材料名 2と1/2 等
      RegExp(r'([あ-んア-ンー一-龯a-zA-Z]+(?:\([^)]*\))?[あ-んア-ンー一-龯a-zA-Z]*)\s+([0-9]+)と([0-9]+/[0-9]+)\s*(大さじ|小さじ|カップ)', multiLine: true),
    ];
    
    for (final pattern in patterns) {
      for (final match in pattern.allMatches(text)) {
        final name = match.group(1)!.trim();
        
        if (!EnhancedFoodDictionary.isIngredient(name)) {
          continue;
        }
        
        double? amount;
        String? unit;
        
        // 複雑な分数処理（2と1/2等）
        if (match.groupCount >= 4 && match.group(2) != null && match.group(3) != null) {
          final wholeNumber = double.tryParse(match.group(2)!) ?? 0;
          final fractionPart = _parseSingleFraction(match.group(3)!) ?? 0;
          amount = wholeNumber + fractionPart;
          unit = match.group(4);
        }
        // 通常の数量処理
        else if (match.groupCount >= 2 && match.group(2) != null) {
          final amountStr = match.group(2)!;
          
          // 適量等の曖昧表記
          if (['適量', '少々', 'お好みで'].contains(amountStr)) {
            unit = amountStr;
          } else {
            amount = _parseAmount(amountStr);
            unit = match.groupCount >= 3 ? match.group(3) : null;
          }
        }
        
        ingredients.add(Ingredient(
          name: _cleanIngredientName(name),
          amount: amount,
          unit: unit != null ? _normalizeUnit(unit) : null,
          originalText: match.group(0)!,
          confidence: 0.82,
        ));
      }
    }
    
    return ingredients;
  }

  /// パターン13: 柔軟な材料セクション抽出（辞書にない材料も抽出）
  List<Ingredient> _extractWithPattern13(String text) {
    final ingredients = <Ingredient>[];
    
    // 「材料」セクションを検出
    final materialsSection = RegExp(
      r'材料[^:：]*[:：]?([\s\S]*?)(?=作り方|手順|レシピ|$)',
      multiLine: true,
    ).firstMatch(text);
    
    final targetText = materialsSection?.group(1) ?? text;
    
    // 柔軟なパターン（* や ・ で始まる行、「…」区切り、分数対応）
    final patterns = [
      // パターン13-1: 大さじ・小さじの分数表記専用パターン
      RegExp(r'^\s*[*・]?\s*([^…・\s]+?)\s*[…・]+\s*([大小]さじ|カップ)\s*([0-9]+(?:と[0-9]+/[0-9]+)?(?:/[0-9]+)?)', multiLine: true),
      
      // パターン13-2: *や・で始まり、材料名…数量単位（分数対応）
      RegExp(r'[*・]\s*([^…]+?)\s*…\s*([0-9]+(?:と[0-9]+/[0-9]+)?(?:\.[0-9]+)?(?:[〜~～][0-9]+(?:\.[0-9]+)?)?)\s*(g|ｇ|グラム|kg|ｋｇ|キロ|ml|ｍｌ|ミリリットル|L|Ｌ|リットル|個|コ|本|枚|束|片|玉|房|大さじ|小さじ|カップ|ほど)?', multiLine: true),
      
      // パターン13-3: *や・で始まり、材料名…曖昧表記
      RegExp(r'[*・]\s*([^…]+?)\s*…\s*(少々|適量|適宜|お好みで)', multiLine: true),
      
      // パターン13-4: より柔軟な材料名マッチング（数量がある場合は材料とみなす）
      RegExp(r'^\s*[*・]?\s*([^0-9…]+?)\s*[…・]+\s*([0-9]+[^\\n]*)', multiLine: true),
    ];
    
    for (final pattern in patterns) {
      for (final match in pattern.allMatches(targetText)) {
        var name = match.group(1)!.trim();
        
        // 除外パターンチェック
        if (_shouldExclude(name)) continue;
        
        // 材料名のクリーンアップ
        name = name.replaceAll(RegExp(r'^[*・\s]+'), '').trim();
        
        double? amount;
        String? unit;
        
        // パターン13-1の場合（大さじ・小さじ専用）
        if (pattern.pattern.contains('[大小]さじ|カップ')) {
          if (match.groupCount >= 3) {
            unit = match.group(2)!.trim();  // 大さじ、小さじ、カップ
            final amountStr = match.group(3)!.trim();  // 数量
            
            // 「2と1/2」形式の処理
            if (amountStr.contains('と') && amountStr.contains('/')) {
              final parts = amountStr.split('と');
              if (parts.length == 2) {
                final wholePart = double.tryParse(parts[0]) ?? 0;
                final fractionPart = _parseSingleFraction(parts[1]) ?? 0;
                amount = wholePart + fractionPart;
              }
            }
            // 分数のみ（1/2など）
            else if (amountStr.contains('/')) {
              amount = _parseSingleFraction(amountStr);
            }
            // 整数
            else {
              amount = double.tryParse(amountStr);
            }
          }
        }
        // その他のパターン
        else if (match.groupCount >= 2) {
          final amountOrUnit = match.group(2)!.trim();
          
          // 「2と1/2」形式の処理
          if (amountOrUnit.contains('と') && amountOrUnit.contains('/')) {
            final parts = amountOrUnit.split('と');
            if (parts.length == 2) {
              final wholePart = double.tryParse(parts[0]) ?? 0;
              final fractionPart = _parseSingleFraction(parts[1]) ?? 0;
              amount = wholePart + fractionPart;
            }
          }
          // 通常の数値処理
          else if (RegExp(r'^[0-9]').hasMatch(amountOrUnit)) {
            amount = _parseAmount(amountOrUnit);
          }
          // 曖昧表記
          else {
            unit = amountOrUnit;
          }
          
          // 単位の取得
          if (match.groupCount >= 3 && match.group(3) != null && amount != null) {
            unit = match.group(3);
          }
        }
        
        // 信頼度の計算（辞書にある：0.9、ない：0.6）
        final confidence = EnhancedFoodDictionary.isIngredient(name) ? 0.9 : 0.6;
        
        ingredients.add(Ingredient(
          name: _cleanIngredientName(name),
          amount: amount,
          unit: unit != null ? _normalizeUnit(unit) : null,
          originalText: match.group(0)!,
          confidence: confidence,
        ));
      }
    }
    
    return ingredients;
  }
  
  /// 除外すべき単語かチェック
  bool _shouldExclude(String text) {
    final excludeWords = [
      '鍋', 'フライパン', 'ボウル', '皿', '器',
      '包丁', 'まな板', '菜箸', 'お玉', 'ヘラ',
      '電子レンジ', 'オーブン', 'トースター',
      '冷蔵庫', '冷凍庫', '保存容器',
      '作り方', '手順', 'レシピ', 'ポイント',
      'カロリー', 'kcal', '栄養', 'たんぱく質',
    ];
    
    final lowerText = text.toLowerCase();
    return excludeWords.any((word) => lowerText.contains(word.toLowerCase()));
  }

  /// 材料っぽい行かどうかを判定
  bool _looksLikeIngredient(String line) {
    // 強化された辞書を使用して判定
    return EnhancedFoodDictionary.isIngredient(line);
  }

  /// 数量解析（範囲指定・複雑分数対応）
  double? _parseAmount(String amountStr) {
    // 日本語数字を半角数字に変換
    String normalizedAmount = _convertJapaneseNumbers(amountStr);
    
    // 範囲+分数組み合わせ処理: "1/3〜1/4本"
    if (normalizedAmount.contains('~') || normalizedAmount.contains('〜')) {
      final rangeSeparator = normalizedAmount.contains('~') ? '~' : '〜';
      final parts = normalizedAmount.split(rangeSeparator);
      if (parts.length == 2) {
        final min = _parseSingleFraction(parts[0].trim());
        final max = _parseSingleFraction(parts[1].trim());
        if (min != null && max != null) {
          return (min + max) / 2; // 中央値
        }
      }
    }
    
    // 単一の分数または数値
    return _parseSingleFraction(normalizedAmount);
  }
  
  /// 単一の分数または数値を解析
  double? _parseSingleFraction(String amountStr) {
    final cleanAmount = amountStr.trim();
    
    // 分数処理: "1/2", "1/3", "1/5" etc.
    if (cleanAmount.contains('/')) {
      final parts = cleanAmount.split('/');
      if (parts.length == 2) {
        final numerator = double.tryParse(parts[0].trim());
        final denominator = double.tryParse(parts[1].trim());
        if (numerator != null && denominator != null && denominator != 0) {
          return numerator / denominator;
        }
      }
    }
    
    // 通常の数値
    return double.tryParse(cleanAmount);
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
    // 基本的なクリーニング
    String cleaned = name
        // 不要な記号を削除
        .replaceAll(RegExp(r'[・･]'), '')
        // 余分な空白を削除
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    
    // 辞書を使用して正規化
    return EnhancedFoodDictionary.normalize(cleaned);
  }

  /// 単位正規化
  String _normalizeUnit(String unit) {
    // 強化された辞書の単位正規化を使用
    return EnhancedFoodDictionary.unitNormalization[unit] ?? unit;
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
    
    // カテゴリ別集計
    final categoryCount = <String, int>{};
    for (final ingredient in ingredients) {
      final category = EnhancedFoodDictionary.getCategory(ingredient.name) ?? 'その他';
      categoryCount[category] = (categoryCount[category] ?? 0) + 1;
    }
    
    return {
      'totalCount': totalCount,
      'withAmount': withAmount,
      'withoutAmount': totalCount - withAmount,
      'averageConfidence': avgConfidence,
      'highConfidenceCount': ingredients.where((i) => i.confidence >= 0.8).length,
      'categoryBreakdown': categoryCount,
    };
  }
}