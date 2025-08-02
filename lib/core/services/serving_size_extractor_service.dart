/// レシピの人数（分量）抽出サービス
class ServingSizeExtractorService {
  /// レシピテキストから人数を抽出
  ServingSizeInfo extractServingSize(String recipeText) {
    // 正規化
    final normalizedText = _normalizeText(recipeText);
    
    // 複数のパターンで人数を抽出
    final patterns = [
      // パターン1: 「(2人分)」「（4人前）」など括弧内
      RegExp(r'[（(]\s*([0-9]+)\s*人[分前][）)]'),
      
      // パターン2: 「2人分の材料」「4人前の分量」
      RegExp(r'([0-9]+)\s*人[分前]の[材料分量]'),
      
      // パターン3: 「材料（2人分）」「分量（4人前）」
      RegExp(r'[材料分量]\s*[（(]\s*([0-9]+)\s*人[分前]\s*[）)]'),
      
      // パターン4: 「2～3人分」「4-5人前」
      RegExp(r'([0-9]+)\s*[～~－-]\s*([0-9]+)\s*人[分前]'),
      
      // パターン5: 「約2人分」「およそ3人前」
      RegExp(r'[約およそ]\s*([0-9]+)\s*人[分前]'),
      
      // パターン6: 「1人分×4」
      RegExp(r'([0-9]+)\s*人[分前]\s*[×x✕]\s*([0-9]+)'),
      
      // パターン7: 「serving: 4」「servings: 2」（英語表記）
      RegExp(r'servings?\s*[:：]\s*([0-9]+)', caseSensitive: false),
      
      // パターン8: 「4人家族分」
      RegExp(r'([0-9]+)\s*人家族[分用]'),
      
      // パターン9: 単独の「2人分」
      RegExp(r'([0-9]+)\s*人[分前]'),
    ];
    
    for (final pattern in patterns) {
      final match = pattern.firstMatch(normalizedText);
      if (match != null) {
        // 範囲指定の場合
        if (match.groupCount >= 2 && match.group(2) != null) {
          final min = int.tryParse(match.group(1)!) ?? 1;
          final max = int.tryParse(match.group(2)!) ?? min;
          return ServingSizeInfo(
            servings: (min + max) / 2,
            isRange: true,
            minServings: min,
            maxServings: max,
            originalText: match.group(0)!,
            confidence: 0.9,
          );
        }
        // 単一の値
        else if (match.groupCount >= 1 && match.group(1) != null) {
          final servings = int.tryParse(match.group(1)!) ?? 1;
          // 1人分×4の場合
          if (pattern.pattern.contains('[×x✕]') && match.groupCount >= 2 && match.group(2) != null) {
            final multiplier = int.tryParse(match.group(2)!) ?? 1;
            return ServingSizeInfo(
              servings: servings * multiplier.toDouble(),
              isRange: false,
              originalText: match.group(0)!,
              confidence: 0.9,
            );
          }
          return ServingSizeInfo(
            servings: servings.toDouble(),
            isRange: false,
            originalText: match.group(0)!,
            confidence: 0.9,
          );
        }
      }
    }
    
    // カップケーキなど個数表記の特殊パターン
    final specialPatterns = _extractSpecialServingPatterns(normalizedText);
    if (specialPatterns != null) {
      return specialPatterns;
    }
    
    // デフォルト値（見つからない場合は2人分と仮定）
    return ServingSizeInfo(
      servings: 2.0,
      isRange: false,
      originalText: '',
      confidence: 0.3,
      isDefault: true,
    );
  }
  
  /// 特殊なサービングパターンの抽出
  ServingSizeInfo? _extractSpecialServingPatterns(String text) {
    // 「12個分」「8枚分」などの個数表記
    final piecePattern = RegExp(r'([0-9]+)\s*[個枚本杯切れ]分');
    final match = piecePattern.firstMatch(text);
    if (match != null) {
      final pieces = int.tryParse(match.group(1)!) ?? 1;
      return ServingSizeInfo(
        servings: pieces.toDouble(),
        isRange: false,
        originalText: match.group(0)!,
        confidence: 0.8,
        unit: _extractUnit(match.group(0)!),
      );
    }
    
    // 「1斤分」「1ホール分」などの単位表記
    final unitPatterns = {
      '斤': 8.0,  // 食パン1斤は約8枚
      'ホール': 8.0,  // ケーキ1ホールは約8切れ
      'パウンド': 8.0,  // パウンドケーキは約8切れ
    };
    
    for (final entry in unitPatterns.entries) {
      final pattern = RegExp('([0-9]+)\\s*${entry.key}分');
      final unitMatch = pattern.firstMatch(text);
      if (unitMatch != null) {
        final quantity = double.tryParse(unitMatch.group(1)!) ?? 1;
        return ServingSizeInfo(
          servings: quantity * entry.value,
          isRange: false,
          originalText: unitMatch.group(0)!,
          confidence: 0.7,
          unit: entry.key,
        );
      }
    }
    
    return null;
  }
  
  /// 単位を抽出
  String? _extractUnit(String text) {
    final unitPattern = RegExp(r'[個枚本杯切れ斤ホールパウンド]');
    final match = unitPattern.firstMatch(text);
    return match?.group(0);
  }
  
  /// テキストの正規化
  String _normalizeText(String text) {
    return text
        .replaceAll('　', ' ')  // 全角スペースを半角に
        .replaceAll(RegExp(r'\s+'), ' ')  // 連続する空白を1つに
        .trim();
  }
}

/// 人数情報
class ServingSizeInfo {
  final double servings;  // 人数
  final bool isRange;  // 範囲指定かどうか
  final int? minServings;  // 最小人数（範囲指定の場合）
  final int? maxServings;  // 最大人数（範囲指定の場合）
  final String originalText;  // 元のテキスト
  final double confidence;  // 抽出の信頼度
  final bool isDefault;  // デフォルト値かどうか
  final String? unit;  // 単位（個、枚など）
  
  const ServingSizeInfo({
    required this.servings,
    required this.isRange,
    this.minServings,
    this.maxServings,
    required this.originalText,
    required this.confidence,
    this.isDefault = false,
    this.unit,
  });
  
  @override
  String toString() {
    if (isRange) {
      return '$minServings～$maxServings人分';
    } else if (unit != null) {
      return '${servings.toInt()}$unit分';
    } else {
      return '${servings.toInt()}人分';
    }
  }
}