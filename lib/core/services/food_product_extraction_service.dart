import 'package:html/dom.dart';
import 'dart:convert';
import '../services/nutrition_extraction_service.dart';

/// 食品商品情報を抽出するサービス
class FoodProductExtractionService {
  final NutritionExtractionService _nutritionExtractor = NutritionExtractionService();
  
  /// HTML文書から食品商品情報を抽出
  FoodProductInfo? extractFoodProductFromHtml(Document document, String url) {
    print('デバッグ: 食品商品情報の抽出を開始');
    
    // 1. JSON-LD構造化データから商品情報を抽出
    final jsonLdProduct = _extractFromJsonLD(document);
    if (jsonLdProduct != null) {
      print('デバッグ: JSON-LDから商品情報を抽出: ${jsonLdProduct.name}');
      return jsonLdProduct.copyWith(sourceUrl: url);
    }
    
    // 2. OpenGraph/メタデータから商品情報を抽出
    final ogpProduct = _extractFromOGP(document);
    if (ogpProduct != null) {
      print('デバッグ: OGPから商品情報を抽出: ${ogpProduct.name}');
      return ogpProduct.copyWith(sourceUrl: url);
    }
    
    // 3. HTMLパターンから商品情報を抽出
    final htmlProduct = _extractFromHTML(document);
    if (htmlProduct != null) {
      print('デバッグ: HTMLパターンから商品情報を抽出: ${htmlProduct.name}');
      return htmlProduct.copyWith(sourceUrl: url);
    }
    
    print('デバッグ: 食品商品情報は見つかりませんでした');
    return null;
  }
  
  /// JSON-LD構造化データから商品情報を抽出
  FoodProductInfo? _extractFromJsonLD(Document document) {
    final scripts = document.querySelectorAll('script[type="application/ld+json"]');
    
    for (final script in scripts) {
      try {
        final jsonText = script.text;
        final jsonData = json.decode(jsonText);
        
        // Productスキーマを探す
        if (jsonData is Map<String, dynamic> && jsonData['@type'] == 'Product') {
          final name = jsonData['name'] as String?;
          if (name == null || name.isEmpty) continue;
          
          // 基本商品情報
          final sku = jsonData['sku'] as String?;
          final brand = jsonData['brand'] as String?;
          final description = jsonData['description'] as String?;
          final size = jsonData['size'] as String?;
          
          // 画像URL
          List<String> imageUrls = [];
          final images = jsonData['image'];
          if (images is List) {
            imageUrls = images.map((img) => img.toString()).toList();
          } else if (images is String) {
            imageUrls = [images];
          }
          
          // 価格情報
          double? price;
          final offers = jsonData['offers'];
          if (offers is Map) {
            final priceStr = offers['price']?.toString();
            if (priceStr != null) {
              price = double.tryParse(priceStr);
            }
          }
          
          // 栄養情報を抽出
          final nutrition = _extractNutritionFromJsonLD(jsonData);
          
          // HTMLからの栄養情報も試す（JSON-LDに栄養情報がない場合）
          final htmlNutrition = nutrition ?? _nutritionExtractor.extractNutritionFromHtml(document);
          
          return FoodProductInfo(
            name: name,
            productCode: sku,
            brand: brand,
            description: description,
            size: size,
            imageUrl: imageUrls.isNotEmpty ? imageUrls.first : null,
            price: price,
            nutrition: htmlNutrition,
            nutritionSource: htmlNutrition != null ? (nutrition != null ? 'JSON-LD商品データ' : htmlNutrition.source) : null,
          );
        }
      } catch (e) {
        print('JSON-LD解析エラー: $e');
        continue;
      }
    }
    
    return null;
  }
  
  /// JSON-LDから栄養情報を抽出
  NutritionInfo? _extractNutritionFromJsonLD(Map<String, dynamic> jsonData) {
    final nutrition = jsonData['nutrition'];
    if (nutrition is Map<String, dynamic>) {
      final calories = _parseDouble(nutrition['calories']);
      final protein = _parseDouble(nutrition['proteinContent']);
      final fat = _parseDouble(nutrition['fatContent']);
      final carbs = _parseDouble(nutrition['carbohydrateContent']);
      final sodium = _parseDouble(nutrition['sodiumContent']);
      final fiber = _parseDouble(nutrition['fiberContent']);
      
      if (calories != null && calories > 0) {
        return NutritionInfo(
          calories: calories,
          protein: protein ?? 0,
          fat: fat ?? 0,
          carbs: carbs ?? 0,
          salt: sodium != null ? sodium * 2.54 / 1000 : 0, // ナトリウム→食塩相当量
          fiber: fiber ?? 0,
          source: 'JSON-LD商品データ',
        );
      }
    }
    
    return null;
  }
  
  /// OGP/メタデータから商品情報を抽出
  FoodProductInfo? _extractFromOGP(Document document) {
    String? name;
    String? description;
    String? imageUrl;
    String? siteName;
    
    // OGPメタタグを検索
    final metaTags = document.getElementsByTagName('meta');
    
    for (final meta in metaTags) {
      final property = meta.attributes['property'] ?? meta.attributes['name'];
      final content = meta.attributes['content'];
      
      if (property == null || content == null || content.isEmpty) continue;
      
      switch (property) {
        case 'og:title':
        case 'twitter:title':
          name ??= content;
          break;
        case 'og:description':
        case 'twitter:description':
        case 'description':
          description ??= content;
          break;
        case 'og:image':
        case 'twitter:image':
          imageUrl ??= content;
          break;
        case 'og:site_name':
          siteName ??= content;
          break;
      }
    }
    
    if (name != null && name.isNotEmpty) {
      // HTMLから栄養情報も抽出
      final nutrition = _nutritionExtractor.extractNutritionFromHtml(document);
      
      return FoodProductInfo(
        name: name,
        description: description,
        imageUrl: imageUrl,
        sourceSite: siteName,
        nutrition: nutrition,
        nutritionSource: nutrition != null ? nutrition.source : null,
      );
    }
    
    return null;
  }
  
  /// HTMLパターンから商品情報を抽出
  FoodProductInfo? _extractFromHTML(Document document) {
    // タイトルタグから商品名を抽出
    final titleElement = document.querySelector('title');
    final name = titleElement?.text.trim();
    
    if (name == null || name.isEmpty) return null;
    
    // HTMLから栄養情報も抽出
    final nutrition = _nutritionExtractor.extractNutritionFromHtml(document);
    
    return FoodProductInfo(
      name: name,
      nutrition: nutrition,
      nutritionSource: nutrition != null ? nutrition.source : null,
    );
  }
  
  /// 文字列を数値に変換
  double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) {
      // 数値以外の文字を除去
      final cleanValue = value.replaceAll(RegExp(r'[^\d.]'), '');
      return double.tryParse(cleanValue);
    }
    return null;
  }
}

/// 抽出された食品商品情報
class FoodProductInfo {
  final String name;
  final String? productCode;
  final String? brand;
  final String? manufacturer;
  final String? size;
  final String? description;
  final String? imageUrl;
  final double? price;
  final String? sourceUrl;
  final String? sourceSite;
  final String? category;
  final NutritionInfo? nutrition;
  final String? nutritionSource;
  final List<String>? ingredients;
  final List<String>? allergens;
  final List<String>? tags;
  
  const FoodProductInfo({
    required this.name,
    this.productCode,
    this.brand,
    this.manufacturer,
    this.size,
    this.description,
    this.imageUrl,
    this.price,
    this.sourceUrl,
    this.sourceSite,
    this.category,
    this.nutrition,
    this.nutritionSource,
    this.ingredients,
    this.allergens,
    this.tags,
  });
  
  /// コピーして一部の値を更新
  FoodProductInfo copyWith({
    String? name,
    String? productCode,
    String? brand,
    String? manufacturer,
    String? size,
    String? description,
    String? imageUrl,
    double? price,
    String? sourceUrl,
    String? sourceSite,
    String? category,
    NutritionInfo? nutrition,
    String? nutritionSource,
    List<String>? ingredients,
    List<String>? allergens,
    List<String>? tags,
  }) {
    return FoodProductInfo(
      name: name ?? this.name,
      productCode: productCode ?? this.productCode,
      brand: brand ?? this.brand,
      manufacturer: manufacturer ?? this.manufacturer,
      size: size ?? this.size,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      sourceSite: sourceSite ?? this.sourceSite,
      category: category ?? this.category,
      nutrition: nutrition ?? this.nutrition,
      nutritionSource: nutritionSource ?? this.nutritionSource,
      ingredients: ingredients ?? this.ingredients,
      allergens: allergens ?? this.allergens,
      tags: tags ?? this.tags,
    );
  }
  
  @override
  String toString() {
    return 'FoodProductInfo(name: $name, brand: $brand, price: $price, nutrition: $nutrition)';
  }
}