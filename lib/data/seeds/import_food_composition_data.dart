import 'dart:convert';
import 'dart:io';
import '../../data/datasources/app_database.dart';
import 'package:drift/drift.dart';

/// 日本食品成分表の全データをインポート
class FoodCompositionDataImporter {
  final AppDatabase database;
  
  FoodCompositionDataImporter(this.database);
  
  /// JSONファイルから全データをインポート
  Future<void> importFromJson(String jsonFilePath) async {
    print('食品成分表データのインポートを開始します...');
    
    try {
      // JSONファイルを読み込み
      final file = File(jsonFilePath);
      final jsonString = await file.readAsString();
      final List<dynamic> jsonData = json.decode(jsonString);
      
      print('読み込んだ食品数: ${jsonData.length}');
      
      int successCount = 0;
      int errorCount = 0;
      
      // バッチ処理でインポート
      const batchSize = 100;
      for (int i = 0; i < jsonData.length; i += batchSize) {
        final batch = jsonData.skip(i).take(batchSize).toList();
        
        await database.batch((batch) {
          for (final item in batch) {
            try {
              batch.insert(
                database.japaneseFoodCompositionTable,
                JapaneseFoodCompositionTableCompanion.insert(
                  groupId: item['groupId'] ?? 0,
                  foodId: item['foodId'] ?? 0,
                  indexId: item['indexId'] ?? 0,
                  foodName: item['foodName'] ?? '',
                  refuse: Value(item['refuse']?.toDouble()),
                  enerc: Value(item['enerc']?.toDouble()),
                  enercKcal: Value(item['enercKcal']?.toDouble()),
                  water: Value(item['water']?.toDouble()),
                  protcaa: Value(item['protcaa']?.toDouble()),
                  prot: Value(item['prot']?.toDouble()),
                  fatnlea: Value(item['fatnlea']?.toDouble()),
                  chole: Value(item['chole']?.toDouble()),
                  fat: Value(item['fat']?.toDouble()),
                  choavlm: Value(item['choavlm']?.toDouble()),
                  choavl: Value(item['choavl']?.toDouble()),
                  choavldf: Value(item['choavldf']?.toDouble()),
                  fib: Value(item['fib']?.toDouble()),
                  polyl: Value(item['polyl']?.toDouble()),
                  chocdf: Value(item['chocdf']?.toDouble()),
                  oa: Value(item['oa']?.toDouble()),
                  ash: Value(item['ash']?.toDouble()),
                  na: Value(item['na']?.toDouble()),
                  k: Value(item['k']?.toDouble()),
                  ca: Value(item['ca']?.toDouble()),
                  mg: Value(item['mg']?.toDouble()),
                  p: Value(item['p']?.toDouble()),
                  fe: Value(item['fe']?.toDouble()),
                  zn: Value(item['zn']?.toDouble()),
                  cu: Value(item['cu']?.toDouble()),
                  mn: Value(item['mn']?.toDouble()),
                  id: Value(item['id']?.toDouble()),
                  se: Value(item['se']?.toDouble()),
                  cr: Value(item['cr']?.toDouble()),
                  mo: Value(item['mo']?.toDouble()),
                  retol: Value(item['retol']?.toDouble()),
                  carta: Value(item['carta']?.toDouble()),
                  cartb: Value(item['cartb']?.toDouble()),
                  crypxb: Value(item['crypxb']?.toDouble()),
                  cartbeq: Value(item['cartbeq']?.toDouble()),
                  vita: Value(item['vita']?.toDouble()),
                  vitd: Value(item['vitd']?.toDouble()),
                  vite: Value(item['vite']?.toDouble()),
                  vitk: Value(item['vitk']?.toDouble()),
                  vitb1: Value(item['vitb1']?.toDouble()),
                  vitb2: Value(item['vitb2']?.toDouble()),
                  nia: Value(item['nia']?.toDouble()),
                  ne: Value(item['ne']?.toDouble()),
                  vitb6: Value(item['vitb6']?.toDouble()),
                  vitb12: Value(item['vitb12']?.toDouble()),
                  fol: Value(item['fol']?.toDouble()),
                  pantac: Value(item['pantac']?.toDouble()),
                  biot: Value(item['biot']?.toDouble()),
                  vitC: Value(item['vitC']?.toDouble()),
                  nacl: Value(item['nacl']?.toDouble()),
                  al: Value(item['al']?.toDouble()),
                ),
              );
              successCount++;
            } catch (e) {
              print('エラー: ${item['foodName']} - $e');
              errorCount++;
            }
          }
        });
        
        print('進捗: ${i + batch.length}/${jsonData.length}');
      }
      
      print('インポート完了！');
      print('成功: $successCount件');
      print('エラー: $errorCount件');
      
    } catch (e) {
      print('インポートエラー: $e');
      rethrow;
    }
  }
  
  /// 食品名から正規化された材料名を生成
  static String normalizeFoodName(String foodName) {
    // 例: "ぶた [大型種肉] かた 脂身つき 生" -> "豚肉"
    // 例: "にんじん 根 皮つき 生" -> "にんじん"
    
    final parts = foodName.split(' ');
    if (parts.isEmpty) return foodName;
    
    // 最初の部分を基本名として使用
    String baseName = parts[0];
    
    // 特殊な正規化ルール
    final normalizations = {
      'ぶた': '豚肉',
      'うし': '牛肉',
      'にわとり': '鶏肉',
      'さけ': '鮭',
      'まぐろ': 'マグロ',
    };
    
    return normalizations[baseName] ?? baseName;
  }
}

// 実行用のヘルパー関数
Future<void> runImport() async {
  final database = AppDatabase();
  final importer = FoodCompositionDataImporter(database);
  
  try {
    await importer.importFromJson(
      '/Users/shota/Downloads/standards-tables-of-food-composition-in-japan/data.json'
    );
  } finally {
    await database.close();
  }
}