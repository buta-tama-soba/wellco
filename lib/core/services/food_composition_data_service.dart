import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:drift/drift.dart';
import '../../data/models/japanese_food_composition_table.dart';
import '../../data/datasources/app_database.dart';

/// 日本食品標準成分表データ取得・管理サービス
class FoodCompositionDataService {
  static const String _dataUrl = 
      'https://raw.githubusercontent.com/katoharu432/standards-tables-of-food-composition-in-japan/master/data.json';
  
  final AppDatabase _database;

  FoodCompositionDataService(this._database);

  /// GitHubからJSONデータを取得してデータベースに投入
  Future<void> loadFoodCompositionData() async {
    try {
      print('食品成分データの取得を開始...');
      
      // GitHubからJSONデータを取得
      final response = await http.get(
        Uri.parse(_dataUrl),
        headers: {
          'User-Agent': 'HealthMeal-App/1.0',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode != 200) {
        throw Exception('データの取得に失敗しました: ${response.statusCode}');
      }

      print('JSONデータの解析開始...');
      
      // JSONデータを解析
      final List<dynamic> jsonData = json.decode(response.body);
      
      print('解析完了: ${jsonData.length}件のデータを発見');
      
      // データベースへの一括投入
      await _insertFoodCompositionData(jsonData);
      
      print('食品成分データの投入完了');

    } catch (e) {
      print('食品成分データの取得エラー: $e');
      throw Exception('食品成分データの取得に失敗しました: $e');
    }
  }

  /// データベースへの一括投入
  Future<void> _insertFoodCompositionData(List<dynamic> jsonData) async {
    await _database.transaction(() async {
      // 既存データをクリア（初期化の場合）
      // await _database.delete(_database.japaneseFoodCompositionTable).go();
      
      int insertedCount = 0;
      int errorCount = 0;
      
      for (final item in jsonData) {
        try {
          final foodData = JapaneseFoodCompositionTableData.fromJson(
            item as Map<String, dynamic>
          );
          
          // データベースに挿入
          await _database.into(_database.japaneseFoodCompositionTable).insert(
            JapaneseFoodCompositionTableCompanion.insert(
              groupId: foodData.groupId,
              foodId: foodData.foodId,
              indexId: foodData.indexId,
              foodName: foodData.foodName,
              refuse: Value(foodData.refuse),
              enerc: foodData.enerc != null ? Value(foodData.enerc!) : const Value.absent(),
              enercKcal: foodData.enercKcal != null ? Value(foodData.enercKcal!) : const Value.absent(),
              water: foodData.water != null ? Value(foodData.water!) : const Value.absent(),
              protcaa: foodData.protcaa != null ? Value(foodData.protcaa!) : const Value.absent(),
              prot: foodData.prot != null ? Value(foodData.prot!) : const Value.absent(),
              fatnlea: foodData.fatnlea != null ? Value(foodData.fatnlea!) : const Value.absent(),
              chole: foodData.chole != null ? Value(foodData.chole!) : const Value.absent(),
              fat: foodData.fat != null ? Value(foodData.fat!) : const Value.absent(),
              choavlm: foodData.choavlm != null ? Value(foodData.choavlm!) : const Value.absent(),
              choavl: foodData.choavl != null ? Value(foodData.choavl!) : const Value.absent(),
              choavldf: foodData.choavldf != null ? Value(foodData.choavldf!) : const Value.absent(),
              fib: foodData.fib != null ? Value(foodData.fib!) : const Value.absent(),
              polyl: foodData.polyl != null ? Value(foodData.polyl!) : const Value.absent(),
              chocdf: foodData.chocdf != null ? Value(foodData.chocdf!) : const Value.absent(),
              oa: foodData.oa != null ? Value(foodData.oa!) : const Value.absent(),
              ash: foodData.ash != null ? Value(foodData.ash!) : const Value.absent(),
              na: foodData.na != null ? Value(foodData.na!) : const Value.absent(),
              k: foodData.k != null ? Value(foodData.k!) : const Value.absent(),
              ca: foodData.ca != null ? Value(foodData.ca!) : const Value.absent(),
              mg: foodData.mg != null ? Value(foodData.mg!) : const Value.absent(),
              p: foodData.p != null ? Value(foodData.p!) : const Value.absent(),
              fe: foodData.fe != null ? Value(foodData.fe!) : const Value.absent(),
              zn: foodData.zn != null ? Value(foodData.zn!) : const Value.absent(),
              cu: foodData.cu != null ? Value(foodData.cu!) : const Value.absent(),
              mn: foodData.mn != null ? Value(foodData.mn!) : const Value.absent(),
              iodine: foodData.iodine != null ? Value(foodData.iodine!) : const Value.absent(),
              se: foodData.se != null ? Value(foodData.se!) : const Value.absent(),
              cr: foodData.cr != null ? Value(foodData.cr!) : const Value.absent(),
              mo: foodData.mo != null ? Value(foodData.mo!) : const Value.absent(),
              retol: foodData.retol != null ? Value(foodData.retol!) : const Value.absent(),
              carta: foodData.carta != null ? Value(foodData.carta!) : const Value.absent(),
              cartb: foodData.cartb != null ? Value(foodData.cartb!) : const Value.absent(),
              crypxb: foodData.crypxb != null ? Value(foodData.crypxb!) : const Value.absent(),
              cartbeq: foodData.cartbeq != null ? Value(foodData.cartbeq!) : const Value.absent(),
              vitaRae: foodData.vitaRae != null ? Value(foodData.vitaRae!) : const Value.absent(),
              vitD: foodData.vitD != null ? Value(foodData.vitD!) : const Value.absent(),
              tocphA: foodData.tocphA != null ? Value(foodData.tocphA!) : const Value.absent(),
              tocphB: foodData.tocphB != null ? Value(foodData.tocphB!) : const Value.absent(),
              tocphG: foodData.tocphG != null ? Value(foodData.tocphG!) : const Value.absent(),
              tocphD: foodData.tocphD != null ? Value(foodData.tocphD!) : const Value.absent(),
              vitK: foodData.vitK != null ? Value(foodData.vitK!) : const Value.absent(),
              thia: foodData.thia != null ? Value(foodData.thia!) : const Value.absent(),
              ribf: foodData.ribf != null ? Value(foodData.ribf!) : const Value.absent(),
              nia: foodData.nia != null ? Value(foodData.nia!) : const Value.absent(),
              ne: foodData.ne != null ? Value(foodData.ne!) : const Value.absent(),
              vitB6A: foodData.vitB6A != null ? Value(foodData.vitB6A!) : const Value.absent(),
              vitB12: foodData.vitB12 != null ? Value(foodData.vitB12!) : const Value.absent(),
              fol: foodData.fol != null ? Value(foodData.fol!) : const Value.absent(),
              pantac: foodData.pantac != null ? Value(foodData.pantac!) : const Value.absent(),
              biot: foodData.biot != null ? Value(foodData.biot!) : const Value.absent(),
              vitC: foodData.vitC != null ? Value(foodData.vitC!) : const Value.absent(),
              alc: foodData.alc != null ? Value(foodData.alc!) : const Value.absent(),
              naclEq: foodData.naclEq != null ? Value(foodData.naclEq!) : const Value.absent(),
            ),
          );
          
          insertedCount++;
          
          // 進捗表示（100件ごと）
          if (insertedCount % 100 == 0) {
            print('投入済み: $insertedCount件');
          }
          
        } catch (e) {
          errorCount++;
          print('データ投入エラー (食品ID: ${item['foodId']}): $e');
        }
      }
      
      print('投入完了: 成功 $insertedCount件, エラー $errorCount件');
    });
  }

  /// 食品名で検索
  Future<List<JapaneseFoodCompositionTableData>> searchFoodsByName(String name) async {
    final query = _database.select(_database.japaneseFoodCompositionTable)
      ..where((tbl) => tbl.foodName.like('%$name%'))
      ..limit(20);
    
    return await query.get();
  }

  /// 食品IDで取得
  Future<JapaneseFoodCompositionTableData?> getFoodById(int foodId) async {
    final query = _database.select(_database.japaneseFoodCompositionTable)
      ..where((tbl) => tbl.foodId.equals(foodId));
    
    return await query.getSingleOrNull();
  }

  /// 食品群別に取得
  Future<List<JapaneseFoodCompositionTableData>> getFoodsByGroup(int groupId) async {
    final query = _database.select(_database.japaneseFoodCompositionTable)
      ..where((tbl) => tbl.groupId.equals(groupId))
      ..orderBy([(tbl) => OrderingTerm.asc(tbl.indexId)]);
    
    return await query.get();
  }

  /// データベースの食品件数を取得
  Future<int> getFoodCount() async {
    final countQuery = _database.selectOnly(_database.japaneseFoodCompositionTable)
      ..addColumns([_database.japaneseFoodCompositionTable.id.count()]);
    
    final result = await countQuery.getSingle();
    return result.read(_database.japaneseFoodCompositionTable.id.count()) ?? 0;
  }

  /// データベースが初期化済みかチェック
  Future<bool> isDatabaseInitialized() async {
    final count = await getFoodCount();
    return count > 0;
  }

  /// 食品群一覧を取得
  Future<Map<int, String>> getFoodGroups() async {
    // 食品群の日本語名マッピング（簡略版）
    return {
      1: '穀類',
      2: 'いも及びでん粉類',
      3: '砂糖及び甘味類',
      4: '豆類',
      5: '種実類',
      6: '野菜類',
      7: '果実類',
      8: 'きのこ類',
      9: '藻類',
      10: '魚介類',
      11: '肉類',
      12: '卵類',
      13: '乳類',
      14: '油脂類',
      15: '菓子類',
      16: 'し好飲料類',
      17: '調味料及び香辛料類',
      18: '調理加工食品類',
    };
  }

  /// 類似食品を検索（材料名マッチング用）
  Future<List<JapaneseFoodCompositionTableData>> findSimilarFoods(String ingredientName) async {
    // キーワード抽出
    final cleanedName = _cleanIngredientName(ingredientName);
    final keywords = _extractKeywords(cleanedName);
    
    final results = <JapaneseFoodCompositionTableData>[];
    
    // 複数のキーワードで検索
    for (final keyword in keywords) {
      if (keyword.length >= 2) { // 2文字以上のキーワードのみ
        final query = _database.select(_database.japaneseFoodCompositionTable)
          ..where((tbl) => tbl.foodName.like('%$keyword%'))
          ..limit(5);
        
        final matches = await query.get();
        results.addAll(matches);
        
        if (results.isNotEmpty) break; // 最初にマッチしたキーワードで終了
      }
    }
    
    return results.take(10).toList(); // 重複除去して最大10件
  }

  /// 材料名をクリーニング
  String _cleanIngredientName(String name) {
    return name
        .replaceAll(RegExp(r'\([^)]*\)'), '') // 括弧内削除
        .replaceAll(RegExp(r'（[^）]*）'), '') // 全角括弧内削除
        .replaceAll(RegExp(r'[0-9]+[.0-9]*[a-zA-Z]*'), '') // 数量削除
        .replaceAll(RegExp(r'(大さじ|小さじ|カップ|個|本|枚|束|片|玉|切り|薄切り|みじん切り)'), '')
        .trim();
  }

  /// キーワード抽出
  List<String> _extractKeywords(String text) {
    final keywords = <String>[];
    
    // 全体をキーワードとして追加
    if (text.isNotEmpty) {
      keywords.add(text);
    }
    
    // 2-3文字の部分文字列も追加
    for (int i = 0; i < text.length - 1; i++) {
      if (i + 2 <= text.length) {
        keywords.add(text.substring(i, i + 2));
      }
      if (i + 3 <= text.length) {
        keywords.add(text.substring(i, i + 3));
      }
    }
    
    return keywords.toSet().toList(); // 重複削除
  }
}