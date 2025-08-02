import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart';

/// OGP（Open Graph Protocol）データ
class OgpData {
  final String? title;
  final String? description;
  final String? imageUrl;
  final String? siteName;
  final String? url;
  final String? type;

  const OgpData({
    this.title,
    this.description,
    this.imageUrl,
    this.siteName,
    this.url,
    this.type,
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

      // HTMLを取得
      final response = await http.get(uri).timeout(_timeout);
      
      if (response.statusCode != 200) {
        throw Exception('ページの取得に失敗しました (${response.statusCode})');
      }

      // HTMLをパース
      final document = html_parser.parse(response.body);
      
      // OGPメタタグを取得
      final ogpData = _extractOgpData(document, url);
      
      // OGPデータが不足している場合は通常のメタタグから補完
      return _complementWithStandardMeta(ogpData, document);
      
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

  /// 通常のメタタグでOGPデータを補完
  OgpData _complementWithStandardMeta(OgpData ogpData, Document document) {
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