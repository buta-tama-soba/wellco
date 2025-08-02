import 'package:drift/drift.dart';

/// 個人データテーブル（身体・活動データ）
class PersonalDataTable extends Table {
  /// 主キー（記録日をそのまま主キーとして使用）
  DateTimeColumn get recordedDate => dateTime()();
  
  /// 体重（kg）
  RealColumn get weight => real().nullable()();
  
  /// 体脂肪率（%）
  RealColumn get bodyFatPercentage => real().nullable()();
  
  /// 歩数
  IntColumn get steps => integer().nullable()();
  
  /// 消費カロリー（kcal）
  RealColumn get activeEnergy => real().nullable()();
  
  /// 運動時間（分）
  IntColumn get exerciseTime => integer().nullable()();
  
  /// 睡眠時間（時間）
  RealColumn get sleepHours => real().nullable()();
  
  /// データソース（manual, healthkit）
  TextColumn get dataSource => text().withDefault(const Constant('manual'))();
  
  /// 作成日時
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  
  /// 更新日時
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  
  /// 記録日を主キーとして設定（同じ日付のデータは1つだけ）
  @override
  Set<Column> get primaryKey => {recordedDate};
}