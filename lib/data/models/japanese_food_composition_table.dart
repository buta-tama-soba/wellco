import 'package:drift/drift.dart';

/// 日本食品標準成分表2020年版データテーブル
/// katoharu432さんのJSONデータに対応
@UseRowClass(JapaneseFoodCompositionTableData)
class JapaneseFoodCompositionTable extends Table {
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
  
  // エネルギー
  /// エネルギー（kJ/100g）
  RealColumn get enerc => real().nullable()();
  
  /// エネルギー（kcal/100g）
  RealColumn get enercKcal => real().nullable()();
  
  // 基本栄養素
  /// 水分（g/100g）
  RealColumn get water => real().nullable()();
  
  /// たんぱく質（アミノ酸組成によるもの）（g/100g）
  RealColumn get protcaa => real().nullable()();
  
  /// たんぱく質（g/100g）
  RealColumn get prot => real().nullable()();
  
  /// 脂質（トリアシルグリセロール当量）（g/100g）
  RealColumn get fatnlea => real().nullable()();
  
  /// コレステロール（mg/100g）
  RealColumn get chole => real().nullable()();
  
  /// 脂質（g/100g）
  RealColumn get fat => real().nullable()();
  
  // 炭水化物
  /// 利用可能炭水化物（単糖当量）（g/100g）
  RealColumn get choavlm => real().nullable()();
  
  /// 利用可能炭水化物（g/100g）
  RealColumn get choavl => real().nullable()();
  
  /// 利用可能炭水化物（でん粉・糖類）（g/100g）
  RealColumn get choavldf => real().nullable()();
  
  /// 総食物繊維（g/100g）
  RealColumn get fib => real().nullable()();
  
  /// 多糖類（g/100g）
  RealColumn get polyl => real().nullable()();
  
  /// 炭水化物（g/100g）
  RealColumn get chocdf => real().nullable()();
  
  /// 有機酸（g/100g）
  RealColumn get oa => real().nullable()();
  
  /// 灰分（g/100g）
  RealColumn get ash => real().nullable()();
  
  // ミネラル
  /// ナトリウム（mg/100g）
  RealColumn get na => real().nullable()();
  
  /// カリウム（mg/100g）
  RealColumn get k => real().nullable()();
  
  /// カルシウム（mg/100g）
  RealColumn get ca => real().nullable()();
  
  /// マグネシウム（mg/100g）
  RealColumn get mg => real().nullable()();
  
  /// リン（mg/100g）
  RealColumn get p => real().nullable()();
  
  /// 鉄（mg/100g）
  RealColumn get fe => real().nullable()();
  
  /// 亜鉛（mg/100g）
  RealColumn get zn => real().nullable()();
  
  /// 銅（mg/100g）
  RealColumn get cu => real().nullable()();
  
  /// マンガン（mg/100g）
  RealColumn get mn => real().nullable()();
  
  /// ヨウ素（μg/100g）- 注意：keyが'id'のため'iodine'として保存
  RealColumn get iodine => real().nullable()();
  
  /// セレン（μg/100g）
  RealColumn get se => real().nullable()();
  
  /// クロム（μg/100g）
  RealColumn get cr => real().nullable()();
  
  /// モリブデン（μg/100g）
  RealColumn get mo => real().nullable()();
  
  // ビタミンA系
  /// レチノール（μg/100g）
  RealColumn get retol => real().nullable()();
  
  /// αカロテン（μg/100g）
  RealColumn get carta => real().nullable()();
  
  /// βカロテン（μg/100g）
  RealColumn get cartb => real().nullable()();
  
  /// βクリプトキサンチン（μg/100g）
  RealColumn get crypxb => real().nullable()();
  
  /// βカロテン当量（μg/100g）
  RealColumn get cartbeq => real().nullable()();
  
  /// レチノール活性当量（μg/100g）
  RealColumn get vitaRae => real().nullable()();
  
  // ビタミンD
  /// ビタミンD（μg/100g）
  RealColumn get vitD => real().nullable()();
  
  // ビタミンE
  /// αトコフェロール（mg/100g）
  RealColumn get tocphA => real().nullable()();
  
  /// βトコフェロール（mg/100g）
  RealColumn get tocphB => real().nullable()();
  
  /// γトコフェロール（mg/100g）
  RealColumn get tocphG => real().nullable()();
  
  /// δトコフェロール（mg/100g）
  RealColumn get tocphD => real().nullable()();
  
  // ビタミンK
  /// ビタミンK（μg/100g）
  RealColumn get vitK => real().nullable()();
  
  // ビタミンB群
  /// ビタミンB1（mg/100g）
  RealColumn get thia => real().nullable()();
  
  /// ビタミンB2（mg/100g）
  RealColumn get ribf => real().nullable()();
  
  /// ナイアシン（mg/100g）
  RealColumn get nia => real().nullable()();
  
  /// ナイアシン当量（mg/100g）
  RealColumn get ne => real().nullable()();
  
  /// ビタミンB6（mg/100g）
  RealColumn get vitB6A => real().nullable()();
  
  /// ビタミンB12（μg/100g）
  RealColumn get vitB12 => real().nullable()();
  
  /// 葉酸（μg/100g）
  RealColumn get fol => real().nullable()();
  
  /// パントテン酸（mg/100g）
  RealColumn get pantac => real().nullable()();
  
  /// ビオチン（μg/100g）
  RealColumn get biot => real().nullable()();
  
  // ビタミンC
  /// ビタミンC（mg/100g）
  RealColumn get vitC => real().nullable()();
  
  // その他
  /// アルコール（g/100g）
  RealColumn get alc => real().nullable()();
  
  /// 食塩相当量（g/100g）
  RealColumn get naclEq => real().nullable()();
  
  /// データ作成日
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  
  /// データ更新日
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// 日本食品標準成分表データクラス
class JapaneseFoodCompositionTableData {
  final int id;
  final int groupId;
  final int foodId;
  final int indexId;
  final String foodName;
  final double refuse;
  final double? enerc;
  final double? enercKcal;
  final double? water;
  final double? protcaa;
  final double? prot;
  final double? fatnlea;
  final double? chole;
  final double? fat;
  final double? choavlm;
  final double? choavl;
  final double? choavldf;
  final double? fib;
  final double? polyl;
  final double? chocdf;
  final double? oa;
  final double? ash;
  final double? na;
  final double? k;
  final double? ca;
  final double? mg;
  final double? p;
  final double? fe;
  final double? zn;
  final double? cu;
  final double? mn;
  final double? iodine;
  final double? se;
  final double? cr;
  final double? mo;
  final double? retol;
  final double? carta;
  final double? cartb;
  final double? crypxb;
  final double? cartbeq;
  final double? vitaRae;
  final double? vitD;
  final double? tocphA;
  final double? tocphB;
  final double? tocphG;
  final double? tocphD;
  final double? vitK;
  final double? thia;
  final double? ribf;
  final double? nia;
  final double? ne;
  final double? vitB6A;
  final double? vitB12;
  final double? fol;
  final double? pantac;
  final double? biot;
  final double? vitC;
  final double? alc;
  final double? naclEq;
  final DateTime createdAt;
  final DateTime updatedAt;

  const JapaneseFoodCompositionTableData({
    required this.id,
    required this.groupId,
    required this.foodId,
    required this.indexId,
    required this.foodName,
    required this.refuse,
    this.enerc,
    this.enercKcal,
    this.water,
    this.protcaa,
    this.prot,
    this.fatnlea,
    this.chole,
    this.fat,
    this.choavlm,
    this.choavl,
    this.choavldf,
    this.fib,
    this.polyl,
    this.chocdf,
    this.oa,
    this.ash,
    this.na,
    this.k,
    this.ca,
    this.mg,
    this.p,
    this.fe,
    this.zn,
    this.cu,
    this.mn,
    this.iodine,
    this.se,
    this.cr,
    this.mo,
    this.retol,
    this.carta,
    this.cartb,
    this.crypxb,
    this.cartbeq,
    this.vitaRae,
    this.vitD,
    this.tocphA,
    this.tocphB,
    this.tocphG,
    this.tocphD,
    this.vitK,
    this.thia,
    this.ribf,
    this.nia,
    this.ne,
    this.vitB6A,
    this.vitB12,
    this.fol,
    this.pantac,
    this.biot,
    this.vitC,
    this.alc,
    this.naclEq,
    required this.createdAt,
    required this.updatedAt,
  });

  /// 基本栄養素（カロリー、タンパク質、脂質、炭水化物）の取得
  Map<String, double> getBasicNutrition() {
    return {
      'energy': enercKcal ?? 0.0,
      'protein': prot ?? 0.0, // protcaaよりprotを優先
      'fat': fat ?? 0.0,
      'carbohydrate': choavl ?? chocdf ?? 0.0, // 利用可能炭水化物を優先
    };
  }

  /// ミネラル情報の取得
  Map<String, double> getMinerals() {
    return {
      'sodium': na ?? 0.0,
      'potassium': k ?? 0.0,
      'calcium': ca ?? 0.0,
      'magnesium': mg ?? 0.0,
      'phosphorus': p ?? 0.0,
      'iron': fe ?? 0.0,
      'zinc': zn ?? 0.0,
      'copper': cu ?? 0.0,
      'manganese': mn ?? 0.0,
      'iodine': iodine ?? 0.0,
      'selenium': se ?? 0.0,
    };
  }

  /// ビタミン情報の取得
  Map<String, double> getVitamins() {
    return {
      'vitaminA': vitaRae ?? cartbeq ?? 0.0, // レチノール活性当量を優先
      'vitaminD': vitD ?? 0.0,
      'vitaminE': tocphA ?? 0.0,
      'vitaminK': vitK ?? 0.0,
      'vitaminB1': thia ?? 0.0,
      'vitaminB2': ribf ?? 0.0,
      'niacin': nia ?? 0.0,
      'vitaminB6': vitB6A ?? 0.0,
      'vitaminB12': vitB12 ?? 0.0,
      'folate': fol ?? 0.0,
      'pantothenicAcid': pantac ?? 0.0,
      'biotin': biot ?? 0.0,
      'vitaminC': vitC ?? 0.0,
    };
  }

  /// 食物繊維情報の取得
  double getDietaryFiber() {
    return fib ?? 0.0;
  }

  /// 食塩相当量の取得
  double getSaltEquivalent() {
    return naclEq ?? (na != null ? na! * 2.54 / 1000 : 0.0); // ナトリウムから計算
  }

  /// JSONからオブジェクトを生成
  factory JapaneseFoodCompositionTableData.fromJson(Map<String, dynamic> json) {
    return JapaneseFoodCompositionTableData(
      id: 0, // auto-increment
      groupId: json['groupId'] ?? 0,
      foodId: json['foodId'] ?? 0,
      indexId: json['indexId'] ?? 0,
      foodName: json['foodName'] ?? '',
      refuse: (json['refuse'] ?? 0).toDouble(),
      enerc: json['enerc']?.toDouble(),
      enercKcal: json['enercKcal']?.toDouble(),
      water: json['water']?.toDouble(),
      protcaa: json['protcaa']?.toDouble(),
      prot: json['prot']?.toDouble(),
      fatnlea: json['fatnlea']?.toDouble(),
      chole: json['chole']?.toDouble(),
      fat: json['fat']?.toDouble(),
      choavlm: json['choavlm']?.toDouble(),
      choavl: json['choavl']?.toDouble(),
      choavldf: json['choavldf']?.toDouble(),
      fib: json['fib']?.toDouble(),
      polyl: json['polyl']?.toDouble(),
      chocdf: json['chocdf']?.toDouble(),
      oa: json['oa']?.toDouble(),
      ash: json['ash']?.toDouble(),
      na: json['na']?.toDouble(),
      k: json['k']?.toDouble(),
      ca: json['ca']?.toDouble(),
      mg: json['mg']?.toDouble(),
      p: json['p']?.toDouble(),
      fe: json['fe']?.toDouble(),
      zn: json['zn']?.toDouble(),
      cu: json['cu']?.toDouble(),
      mn: json['mn']?.toDouble(),
      iodine: json['id']?.toDouble(), // JSONのkeyは'id'だがiodineとして保存
      se: json['se']?.toDouble(),
      cr: json['cr']?.toDouble(),
      mo: json['mo']?.toDouble(),
      retol: json['retol']?.toDouble(),
      carta: json['carta']?.toDouble(),
      cartb: json['cartb']?.toDouble(),
      crypxb: json['crypxb']?.toDouble(),
      cartbeq: json['cartbeq']?.toDouble(),
      vitaRae: json['vitaRae']?.toDouble(),
      vitD: json['vitD']?.toDouble(),
      tocphA: json['tocphA']?.toDouble(),
      tocphB: json['tocphB']?.toDouble(),
      tocphG: json['tocphG']?.toDouble(),
      tocphD: json['tocphD']?.toDouble(),
      vitK: json['vitK']?.toDouble(),
      thia: json['thia']?.toDouble(),
      ribf: json['ribf']?.toDouble(),
      nia: json['nia']?.toDouble(),
      ne: json['ne']?.toDouble(),
      vitB6A: json['vitB6A']?.toDouble(),
      vitB12: json['vitB12']?.toDouble(),
      fol: json['fol']?.toDouble(),
      pantac: json['pantac']?.toDouble(),
      biot: json['biot']?.toDouble(),
      vitC: json['vitC']?.toDouble(),
      alc: json['alc']?.toDouble(),
      naclEq: json['naclEq']?.toDouble(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}