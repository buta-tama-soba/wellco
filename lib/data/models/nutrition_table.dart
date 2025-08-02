import 'package:drift/drift.dart';

/// 栄養成分データテーブル（日本食品標準成分表2020年版ベース）
@UseRowClass(NutritionDataTableData)
class NutritionDataTable extends Table {
  /// 内部ID
  IntColumn get id => integer().autoIncrement()();
  
  /// 食品群ID
  IntColumn get groupId => integer()();
  
  /// 食品ID
  IntColumn get foodId => integer().unique()();
  
  /// インデックスID
  IntColumn get indexId => integer()();
  
  /// 食品名
  TextColumn get foodName => text()();
  
  /// 廃棄率(%)
  RealColumn get refuse => real().withDefault(const Constant(0.0))();
  
  /// エネルギー（kcal/100g）
  RealColumn get energy => real().nullable()();
  
  /// 水分（g/100g）
  RealColumn get water => real().nullable()();
  
  /// たんぱく質（g/100g）
  RealColumn get protein => real().nullable()();
  
  /// 脂質（g/100g）
  RealColumn get fat => real().nullable()();
  
  /// 炭水化物（g/100g）
  RealColumn get carbohydrate => real().nullable()();
  
  /// 灰分（g/100g）
  RealColumn get ash => real().nullable()();
  
  /// ナトリウム（mg/100g）
  RealColumn get sodium => real().nullable()();
  
  /// カリウム（mg/100g）
  RealColumn get potassium => real().nullable()();
  
  /// カルシウム（mg/100g）
  RealColumn get calcium => real().nullable()();
  
  /// マグネシウム（mg/100g）
  RealColumn get magnesium => real().nullable()();
  
  /// リン（mg/100g）
  RealColumn get phosphorus => real().nullable()();
  
  /// 鉄（mg/100g）
  RealColumn get iron => real().nullable()();
  
  /// 亜鉛（mg/100g）
  RealColumn get zinc => real().nullable()();
  
  /// 銅（mg/100g）
  RealColumn get copper => real().nullable()();
  
  /// マンガン（mg/100g）
  RealColumn get manganese => real().nullable()();
  
  /// ヨウ素（μg/100g）
  RealColumn get iodine => real().nullable()();
  
  /// セレン（μg/100g）
  RealColumn get selenium => real().nullable()();
  
  /// クロム（μg/100g）
  RealColumn get chromium => real().nullable()();
  
  /// モリブデン（μg/100g）
  RealColumn get molybdenum => real().nullable()();
  
  /// レチノール（μg/100g）
  RealColumn get retinol => real().nullable()();
  
  /// αカロテン（μg/100g）
  RealColumn get alphaCarotene => real().nullable()();
  
  /// βカロテン（μg/100g）
  RealColumn get betaCarotene => real().nullable()();
  
  /// βクリプトキサンチン（μg/100g）
  RealColumn get betaCryptoxanthin => real().nullable()();
  
  /// βカロテン当量（μg/100g）
  RealColumn get betaCaroteneEquivalent => real().nullable()();
  
  /// レチノール活性当量（μg/100g）
  RealColumn get retinolActivityEquivalent => real().nullable()();
  
  /// ビタミンD（μg/100g）
  RealColumn get vitaminD => real().nullable()();
  
  /// αトコフェロール（mg/100g）
  RealColumn get alphaTocopherol => real().nullable()();
  
  /// βトコフェロール（mg/100g）
  RealColumn get betaTocopherol => real().nullable()();
  
  /// γトコフェロール（mg/100g）
  RealColumn get gammaTocopherol => real().nullable()();
  
  /// δトコフェロール（mg/100g）
  RealColumn get deltaTocopherol => real().nullable()();
  
  /// ビタミンK（μg/100g）
  RealColumn get vitaminK => real().nullable()();
  
  /// ビタミンB1（mg/100g）
  RealColumn get vitaminB1 => real().nullable()();
  
  /// ビタミンB2（mg/100g）
  RealColumn get vitaminB2 => real().nullable()();
  
  /// ナイアシン（mg/100g）
  RealColumn get niacin => real().nullable()();
  
  /// ビタミンB6（mg/100g）
  RealColumn get vitaminB6 => real().nullable()();
  
  /// ビタミンB12（μg/100g）
  RealColumn get vitaminB12 => real().nullable()();
  
  /// 葉酸（μg/100g）
  RealColumn get folate => real().nullable()();
  
  /// パントテン酸（mg/100g）
  RealColumn get pantothenicAcid => real().nullable()();
  
  /// ビオチン（μg/100g）
  RealColumn get biotin => real().nullable()();
  
  /// ビタミンC（mg/100g）
  RealColumn get vitaminC => real().nullable()();
  
  /// 食塩相当量（g/100g）
  RealColumn get saltEquivalent => real().nullable()();
  
  /// 飽和脂肪酸（g/100g）
  RealColumn get saturatedFat => real().nullable()();
  
  /// 一価不飽和脂肪酸（g/100g）
  RealColumn get monounsaturatedFat => real().nullable()();
  
  /// 多価不飽和脂肪酸（g/100g）
  RealColumn get polyunsaturatedFat => real().nullable()();
  
  /// コレステロール（mg/100g）
  RealColumn get cholesterol => real().nullable()();
  
  /// 食物繊維総量（g/100g）
  RealColumn get dietaryFiber => real().nullable()();
  
  /// 水溶性食物繊維（g/100g）
  RealColumn get solubleFiber => real().nullable()();
  
  /// 不溶性食物繊維（g/100g）
  RealColumn get insolubleFiber => real().nullable()();
  
  /// 有機酸（g/100g）
  RealColumn get organicAcid => real().nullable()();
  
  /// 廃棄率（%）
  RealColumn get wasteRate => real().nullable()();
  
  /// データ作成日
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  
  /// データ更新日
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// 栄養成分データクラス
class NutritionDataTableData {
  final int id;
  final String foodNumber;
  final String foodName;
  final String? foodNameKana;
  final String? foodGroup;
  final String? category;
  final double? energy;
  final double? water;
  final double? protein;
  final double? fat;
  final double? carbohydrate;
  final double? ash;
  final double? sodium;
  final double? potassium;
  final double? calcium;
  final double? magnesium;
  final double? phosphorus;
  final double? iron;
  final double? zinc;
  final double? copper;
  final double? manganese;
  final double? iodine;
  final double? selenium;
  final double? chromium;
  final double? molybdenum;
  final double? retinol;
  final double? alphaCarotene;
  final double? betaCarotene;
  final double? betaCryptoxanthin;
  final double? betaCaroteneEquivalent;
  final double? retinolActivityEquivalent;
  final double? vitaminD;
  final double? alphaTocopherol;
  final double? betaTocopherol;
  final double? gammaTocopherol;
  final double? deltaTocopherol;
  final double? vitaminK;
  final double? vitaminB1;
  final double? vitaminB2;
  final double? niacin;
  final double? vitaminB6;
  final double? vitaminB12;
  final double? folate;
  final double? pantothenicAcid;
  final double? biotin;
  final double? vitaminC;
  final double? saltEquivalent;
  final double? saturatedFat;
  final double? monounsaturatedFat;
  final double? polyunsaturatedFat;
  final double? cholesterol;
  final double? dietaryFiber;
  final double? solubleFiber;
  final double? insolubleFiber;
  final double? organicAcid;
  final double? wasteRate;
  final DateTime createdAt;
  final DateTime updatedAt;

  const NutritionDataTableData({
    required this.id,
    required this.foodNumber,
    required this.foodName,
    this.foodNameKana,
    this.foodGroup,
    this.category,
    this.energy,
    this.water,
    this.protein,
    this.fat,
    this.carbohydrate,
    this.ash,
    this.sodium,
    this.potassium,
    this.calcium,
    this.magnesium,
    this.phosphorus,
    this.iron,
    this.zinc,
    this.copper,
    this.manganese,
    this.iodine,
    this.selenium,
    this.chromium,
    this.molybdenum,
    this.retinol,
    this.alphaCarotene,
    this.betaCarotene,
    this.betaCryptoxanthin,
    this.betaCaroteneEquivalent,
    this.retinolActivityEquivalent,
    this.vitaminD,
    this.alphaTocopherol,
    this.betaTocopherol,
    this.gammaTocopherol,
    this.deltaTocopherol,
    this.vitaminK,
    this.vitaminB1,
    this.vitaminB2,
    this.niacin,
    this.vitaminB6,
    this.vitaminB12,
    this.folate,
    this.pantothenicAcid,
    this.biotin,
    this.vitaminC,
    this.saltEquivalent,
    this.saturatedFat,
    this.monounsaturatedFat,
    this.polyunsaturatedFat,
    this.cholesterol,
    this.dietaryFiber,
    this.solubleFiber,
    this.insolubleFiber,
    this.organicAcid,
    this.wasteRate,
    required this.createdAt,
    required this.updatedAt,
  });

  /// 基本栄養素（カロリー、タンパク質、脂質、炭水化物）の取得
  Map<String, double> getBasicNutrition() {
    return {
      'energy': energy ?? 0.0,
      'protein': protein ?? 0.0,
      'fat': fat ?? 0.0,
      'carbohydrate': carbohydrate ?? 0.0,
    };
  }

  /// ミネラル情報の取得
  Map<String, double> getMinerals() {
    return {
      'sodium': sodium ?? 0.0,
      'potassium': potassium ?? 0.0,
      'calcium': calcium ?? 0.0,
      'magnesium': magnesium ?? 0.0,
      'phosphorus': phosphorus ?? 0.0,
      'iron': iron ?? 0.0,
      'zinc': zinc ?? 0.0,
    };
  }

  /// ビタミン情報の取得
  Map<String, double> getVitamins() {
    return {
      'vitaminA': retinolActivityEquivalent ?? 0.0,
      'vitaminD': vitaminD ?? 0.0,
      'vitaminB1': vitaminB1 ?? 0.0,
      'vitaminB2': vitaminB2 ?? 0.0,
      'vitaminB6': vitaminB6 ?? 0.0,
      'vitaminB12': vitaminB12 ?? 0.0,
      'vitaminC': vitaminC ?? 0.0,
      'folate': folate ?? 0.0,
    };
  }
}