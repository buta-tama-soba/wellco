import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart';
import 'dart:convert';

/// OGP（Open Graph Protocol）データ
class OgpData {
  final String? title;
  final String? description;
  final String? imageUrl;
  final String? siteName;
  final String? url;
  final String? type;
  final String? recipeText; // レシピ本文（材料抽出用）

  const OgpData({
    this.title,
    this.description,
    this.imageUrl,
    this.siteName,
    this.url,
    this.type,
    this.recipeText,
  });

  bool get hasBasicInfo => title != null && (description != null || imageUrl != null);

  @override
  String toString() {
    return 'OgpData(title: $title, description: $description, imageUrl: $imageUrl, siteName: $siteName)';
  }
}

/// OGPメタデータ取得サービス
class OgpFetcherService {
  static const Duration _timeout = Duration(seconds: 10);
  
  /// URLからOGPメタデータを取得
  Future<OgpData> fetchOgpData(String url) async {
    try {
      // URLの検証
      final uri = Uri.parse(url);
      if (!uri.hasScheme || !uri.hasAuthority) {
        throw Exception('無効なURLです');
      }
      
      // HTTPSのみ許可
      if (uri.scheme != 'https' && uri.scheme != 'http') {
        throw Exception('HTTPSまたはHTTPのURLのみ対応しています');
      }

      // HTMLを取得（UTF-8ヘッダーを明示的に設定）
      final response = await http.get(
        uri, 
        headers: {
          'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
          'Accept-Charset': 'UTF-8',
          'User-Agent': 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148',
        },
      ).timeout(_timeout);
      
      if (response.statusCode != 200) {
        throw Exception('ページの取得に失敗しました (${response.statusCode})');
      }

      // レスポンスの文字エンコーディングを確認・修正
      String htmlContent;
      try {
        // Content-Typeヘッダーからcharsetを取得
        final contentType = response.headers['content-type'];
        if (contentType != null && contentType.contains('charset=')) {
          // Content-Typeで指定されたcharsetを使用
          htmlContent = response.body;
        } else {
          // charsetが指定されていない場合、UTF-8として扱う
          final bytes = response.bodyBytes;
          htmlContent = utf8.decode(bytes, allowMalformed: true);
        }
      } catch (e) {
        // エンコーディングエラーの場合、元のbodyを使用
        htmlContent = response.body;
      }

      // HTMLをパース
      final document = html_parser.parse(htmlContent);
      
      // OGPメタタグを取得
      final ogpData = _extractOgpData(document, url);
      
      // レシピ本文を抽出
      final recipeText = _extractRecipeText(document, url);
      print('デバッグ: 抽出されたレシピ本文の長さ = ${recipeText?.length ?? 0}');
      
      // OGPデータが不足している場合は通常のメタタグから補完
      return _complementWithStandardMeta(ogpData, document, recipeText);
      
    } on http.ClientException catch (e) {
      throw Exception('ネットワークエラー: ${e.message}');
    } catch (e) {
      throw Exception('OGPデータの取得に失敗しました: $e');
    }
  }

  /// OGPメタタグからデータを抽出
  OgpData _extractOgpData(Document document, String url) {
    String? title;
    String? description;
    String? imageUrl;
    String? siteName;
    String? type;
    
    // メタタグを検索
    final metaTags = document.getElementsByTagName('meta');
    
    for (final meta in metaTags) {
      final property = meta.attributes['property'] ?? meta.attributes['name'];
      final content = meta.attributes['content'];
      
      if (property == null || content == null || content.isEmpty) continue;
      
      switch (property) {
        case 'og:title':
          title = content;
          break;
        case 'og:description':
          description = content;
          break;
        case 'og:image':
          imageUrl = _makeAbsoluteUrl(content, url);
          break;
        case 'og:site_name':
          siteName = content;
          break;
        case 'og:type':
          type = content;
          break;
      }
    }
    
    return OgpData(
      title: title,
      description: description,
      imageUrl: imageUrl,
      siteName: siteName,
      url: url,
      type: type,
    );
  }

  /// レシピ本文を抽出（材料情報取得用）
  String? _extractRecipeText(Document document, String url) {
    final uri = Uri.parse(url);
    final host = uri.host.toLowerCase();
    
    try {
      // サイト別の抽出ロジック
      if (host.contains('park.ajinomoto.co.jp')) {
        return _extractAjinomotoRecipe(document);
      } else if (host.contains('www.lettuceclub.net')) {
        return _extractLettuceClubRecipe(document);
      } else if (host.contains('www.orangepage.net')) {
        return _extractOrangePageRecipe(document);
      } else if (host.contains('www.kyounoryouri.jp')) {
        return _extractKyounoRyouriRecipe(document);
      } else {
        // 汎用的な抽出
        return _extractGenericRecipe(document);
      }
    } catch (e) {
      // エラー時は汎用的な抽出を試行
      return _extractGenericRecipe(document);
    }
  }
  
  /// 味の素パーク用レシピ抽出
  String? _extractAjinomotoRecipe(Document document) {
    final buffer = StringBuffer();
    
    // より幅広いセレクタで材料を探す
    final possibleSelectors = [
      'ul li',  // 汎用的なリスト項目
      '.material li',
      '.recipe-material li',
      '.ingredients li',
      'h3:contains("材料") + ul li',
      'h3 + ul li',
    ];
    
    bool foundIngredients = false;
    for (final selector in possibleSelectors) {
      final elements = document.querySelectorAll(selector);
      if (elements.isNotEmpty) {
        // 材料っぽいテキストが含まれているかチェック
        final ingredientTexts = elements.map((e) => e.text.trim()).where((text) => 
          text.isNotEmpty && 
          (text.contains('g') || text.contains('個') || text.contains('本') || 
           text.contains('枚') || text.contains('大さじ') || text.contains('小さじ') ||
           text.contains('ml') || text.contains('L') || text.contains('カップ') ||
           text.contains('少々') || text.contains('適量') || text.contains('適宜'))
        ).toList();
        
        if (ingredientTexts.length >= 2) { // 2つ以上の材料があれば採用
          buffer.writeln('【材料】');
          for (final text in ingredientTexts) {
            // テキストが途切れていないかチェック
            String fullText = text;
            if (text.length > 10 && !text.endsWith('g') && !text.endsWith('個') && 
                !text.endsWith('本') && !text.endsWith('枚') && !text.endsWith('大さじ') && 
                !text.endsWith('小さじ') && !text.endsWith('少々') && !text.endsWith('適量')) {
              // 途切れている可能性があるため、周辺のテキストも確認
              final parentElement = elements.firstWhere((e) => e.text.trim() == text, 
                orElse: () => elements.first).parent;
              if (parentElement != null) {
                final fullParentText = parentElement.text.trim();
                if (fullParentText.length > text.length) {
                  fullText = fullParentText;
                }
              }
            }
            buffer.writeln(fullText);
          }
          foundIngredients = true;
          break;
        }
      }
    }
    
    // セレクタベースで見つからない場合は、テキスト全体から材料らしい部分を抽出
    if (!foundIngredients) {
      final bodyText = document.body?.text ?? '';
      print('デバッグ: セレクタで材料が見つからないため、テキスト全体から抽出を試行');
      
      final lines = bodyText.split('\n');
      bool inMaterialSection = false;
      
      for (final line in lines) {
        final cleanLine = line.trim();
        if (cleanLine.contains('材料') && (cleanLine.contains('人分') || cleanLine.contains('分量'))) {
          inMaterialSection = true;
          buffer.writeln('【材料】');
          continue;
        }
        
        if (inMaterialSection) {
          if (cleanLine.contains('作り方') || cleanLine.contains('手順') || cleanLine.contains('調理')) {
            break;
          }
          
          if (cleanLine.isNotEmpty && 
              (cleanLine.contains('g') || cleanLine.contains('個') || cleanLine.contains('本') || 
               cleanLine.contains('枚') || cleanLine.contains('大さじ') || cleanLine.contains('小さじ') ||
               cleanLine.contains('ml') || cleanLine.contains('L') || cleanLine.contains('カップ') ||
               cleanLine.contains('少々') || cleanLine.contains('適量') || cleanLine.contains('適宜') ||
               cleanLine.contains('…') || cleanLine.contains('・'))) {
            buffer.writeln(cleanLine);
          }
        }
      }
    }
    
    // さらに詳細なHTML構造を調査（味の素パーク固有）
    if (buffer.toString().trim().isEmpty || buffer.toString().contains('オリーブオ')) {
      print('デバッグ: 材料抽出が不完全なため、詳細調査を実行');
      
      // より具体的なセレクタを試行
      final specificSelectors = [
        '.recipe-detail .ingredients li',
        '.recipe-ingredients .ingredient-item',
        '[data-ingredient]',
        '.material-list li',
        '.ingredient-list li',
      ];
      
      for (final selector in specificSelectors) {
        final elements = document.querySelectorAll(selector);
        if (elements.isNotEmpty) {
          final newBuffer = StringBuffer();
          newBuffer.writeln('【材料】');
          
          for (final element in elements) {
            final text = element.text.trim();
            if (text.isNotEmpty && text.length > 2) {
              newBuffer.writeln(text);
            }
          }
          
          if (newBuffer.toString().split('\n').length > 3) {
            return newBuffer.toString();
          }
        }
      }
    }
    
    return buffer.toString().trim().isNotEmpty ? buffer.toString() : null;
  }
  
  /// レタスクラブ用レシピ抽出
  String? _extractLettuceClubRecipe(Document document) {
    final buffer = StringBuffer();
    
    // 材料
    final ingredients = document.querySelectorAll('.recipe-material dd, .material dd, .ingredients dd');
    if (ingredients.isNotEmpty) {
      buffer.writeln('【材料】');
      for (final ingredient in ingredients) {
        final text = ingredient.text.trim();
        if (text.isNotEmpty) {
          buffer.writeln(text);
        }
      }
      buffer.writeln();
    }
    
    return buffer.toString().trim().isNotEmpty ? buffer.toString() : null;
  }
  
  /// オレンジページ用レシピ抽出
  String? _extractOrangePageRecipe(Document document) {
    final buffer = StringBuffer();
    
    // 材料
    final ingredients = document.querySelectorAll('.recipe-ingredients li, .ingredients li');
    if (ingredients.isNotEmpty) {
      buffer.writeln('【材料】');
      for (final ingredient in ingredients) {
        final text = ingredient.text.trim();
        if (text.isNotEmpty) {
          buffer.writeln(text);
        }
      }
    }
    
    return buffer.toString().trim().isNotEmpty ? buffer.toString() : null;
  }
  
  /// みんなのきょうの料理用レシピ抽出
  String? _extractKyounoRyouriRecipe(Document document) {
    final buffer = StringBuffer();
    
    // 材料
    final ingredients = document.querySelectorAll('.recipe-material li, .ingredients li');
    if (ingredients.isNotEmpty) {
      buffer.writeln('【材料】');
      for (final ingredient in ingredients) {
        final text = ingredient.text.trim();
        if (text.isNotEmpty) {
          buffer.writeln(text);
        }
      }
    }
    
    return buffer.toString().trim().isNotEmpty ? buffer.toString() : null;
  }
  
  /// 汎用的なレシピ抽出
  String? _extractGenericRecipe(Document document) {
    final buffer = StringBuffer();
    
    // 一般的なCSSセレクタで材料を探す
    final possibleSelectors = [
      '.ingredients li', '.ingredient li', '.material li',
      '.recipe-ingredients li', '.recipe-material li',
      '.ingredients dd', '.ingredient dd', '.material dd',
      '.ingredients p', '.ingredient p', '.material p',
    ];
    
    for (final selector in possibleSelectors) {
      final elements = document.querySelectorAll(selector);
      if (elements.isNotEmpty) {
        buffer.writeln('【材料】');
        for (final element in elements) {
          final text = element.text.trim();
          if (text.isNotEmpty && text.length > 2) {
            buffer.writeln(text);
          }
        }
        break; // 最初に見つかったセレクタのみ使用
      }
    }
    
    return buffer.toString().trim().isNotEmpty ? buffer.toString() : null;
  }

  /// 通常のメタタグでOGPデータを補完
  OgpData _complementWithStandardMeta(OgpData ogpData, Document document, String? recipeText) {
    // タイトルの補完
    String? title = ogpData.title;
    if (title == null || title.isEmpty) {
      final titleElement = document.querySelector('title');
      if (titleElement != null) {
        title = titleElement.text.trim();
      }
    }
    
    // 説明の補完
    String? description = ogpData.description;
    if (description == null || description.isEmpty) {
      final descMeta = document.querySelector('meta[name="description"]');
      if (descMeta != null) {
        description = descMeta.attributes['content'];
      }
    }
    
    // サイト名の補完（ドメイン名から推測）
    String? siteName = ogpData.siteName;
    if (siteName == null || siteName.isEmpty) {
      final uri = Uri.tryParse(ogpData.url ?? '');
      if (uri != null) {
        siteName = uri.host.replaceAll('www.', '');
      }
    }
    
    return OgpData(
      title: title,
      description: description,
      imageUrl: ogpData.imageUrl,
      siteName: siteName,
      url: ogpData.url,
      type: ogpData.type,
      recipeText: recipeText,
    );
  }

  /// 相対URLを絶対URLに変換
  String _makeAbsoluteUrl(String url, String baseUrl) {
    try {
      final uri = Uri.parse(url);
      if (uri.hasScheme) {
        return url; // 既に絶対URL
      }
      
      final baseUri = Uri.parse(baseUrl);
      final absoluteUri = baseUri.resolve(url);
      return absoluteUri.toString();
    } catch (e) {
      return url; // エラー時は元のURLを返す
    }
  }
}