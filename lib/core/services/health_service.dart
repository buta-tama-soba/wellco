import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

class HealthService {
  static final HealthService _instance = HealthService._internal();
  factory HealthService() => _instance;
  HealthService._internal();

  final Health _health = Health();
  bool _isConfigured = false;

  // HealthKitで取得するデータタイプ
  static const List<HealthDataType> _dataTypes = [
    HealthDataType.WEIGHT,
    HealthDataType.BODY_FAT_PERCENTAGE,
    HealthDataType.STEPS,
    HealthDataType.ACTIVE_ENERGY_BURNED, 
    HealthDataType.EXERCISE_TIME,
    HealthDataType.SLEEP_IN_BED,
    HealthDataType.SLEEP_ASLEEP,
  ];

  // 権限リスト（読み取り専用）
  static const List<HealthDataAccess> _permissions = [
    HealthDataAccess.READ,
    HealthDataAccess.READ,
    HealthDataAccess.READ,
    HealthDataAccess.READ,
    HealthDataAccess.READ,
    HealthDataAccess.READ,
    HealthDataAccess.READ,
  ];

  /// HealthKitを初期化
  Future<bool> initialize() async {
    try {
      if (_isConfigured) return true;
      
      // Health packageの設定（voidを返すため、例外が発生しなければ成功とみなす）
      await _health.configure();
      _isConfigured = true;
      return true;
    } catch (e) {
      print('HealthKit初期化エラー: $e');
      return false;
    }
  }

  /// 権限をリクエスト
  Future<bool> requestPermissions() async {
    try {
      if (!_isConfigured) {
        final initialized = await initialize();
        if (!initialized) return false;
      }

      // 既に権限があるかチェック
      bool? hasPermissions = await _health.hasPermissions(_dataTypes, permissions: _permissions);
      if (hasPermissions == true) return true;

      // 権限をリクエスト
      bool requested = await _health.requestAuthorization(_dataTypes, permissions: _permissions);
      return requested;
    } catch (e) {
      print('権限リクエストエラー: $e');
      return false;
    }
  }

  /// 体重データを取得
  Future<double?> getLatestWeight() async {
    try {
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 30)); // 30日前まで

      List<HealthDataPoint> data = await _health.getHealthDataFromTypes(
        types: [HealthDataType.WEIGHT],
        startTime: yesterday,
        endTime: now,
      );

      if (data.isEmpty) return null;

      // 最新のデータを取得
      data.sort((a, b) => b.dateFrom.compareTo(a.dateFrom));
      final latestWeight = data.first.value as NumericHealthValue;
      return latestWeight.numericValue.toDouble();
    } catch (e) {
      print('体重取得エラー: $e');
      return null;
    }
  }

  /// 体脂肪率データを取得
  Future<double?> getLatestBodyFatPercentage() async {
    try {
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 30));

      List<HealthDataPoint> data = await _health.getHealthDataFromTypes(
        types: [HealthDataType.BODY_FAT_PERCENTAGE],
        startTime: yesterday,
        endTime: now,
      );

      if (data.isEmpty) return null;

      data.sort((a, b) => b.dateFrom.compareTo(a.dateFrom));
      final latestBodyFat = data.first.value as NumericHealthValue;
      return latestBodyFat.numericValue.toDouble();
    } catch (e) {
      print('体脂肪率取得エラー: $e');
      return null;
    }
  }

  /// 今日の歩数を取得
  Future<int?> getTodaySteps() async {
    try {
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);

      List<HealthDataPoint> data = await _health.getHealthDataFromTypes(
        types: [HealthDataType.STEPS],
        startTime: startOfDay,
        endTime: now,
      );

      if (data.isEmpty) return null;

      // 今日の歩数を合計
      int totalSteps = 0;
      for (final point in data) {
        final steps = point.value as NumericHealthValue;
        totalSteps += steps.numericValue.toInt();
      }

      return totalSteps;
    } catch (e) {
      print('歩数取得エラー: $e');
      return null;
    }
  }

  /// 今日の消費カロリーを取得
  Future<double?> getTodayActiveEnergy() async {
    try {
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);

      List<HealthDataPoint> data = await _health.getHealthDataFromTypes(
        types: [HealthDataType.ACTIVE_ENERGY_BURNED],
        startTime: startOfDay,
        endTime: now,
      );

      if (data.isEmpty) return null;

      // 今日の消費カロリーを合計
      double totalEnergy = 0.0;
      for (final point in data) {
        final energy = point.value as NumericHealthValue;
        totalEnergy += energy.numericValue.toDouble();
      }

      return totalEnergy;
    } catch (e) {
      print('消費カロリー取得エラー: $e');
      return null;
    }
  }

  /// 今日の運動時間を取得（分）
  Future<int?> getTodayExerciseTime() async {
    try {
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);

      List<HealthDataPoint> data = await _health.getHealthDataFromTypes(
        types: [HealthDataType.EXERCISE_TIME],
        startTime: startOfDay,
        endTime: now,
      );

      if (data.isEmpty) return null;

      // 今日の運動時間を合計（分）
      int totalMinutes = 0;
      for (final point in data) {
        final exerciseTime = point.value as NumericHealthValue;
        totalMinutes += exerciseTime.numericValue.toInt();
      }

      return totalMinutes;
    } catch (e) {
      print('運動時間取得エラー: $e');
      return null;
    }
  }

  /// 昨夜の睡眠時間を取得（時間）
  Future<double?> getLastNightSleepHours() async {
    try {
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 1));
      final startOfYesterday = DateTime(yesterday.year, yesterday.month, yesterday.day);

      List<HealthDataPoint> data = await _health.getHealthDataFromTypes(
        types: [HealthDataType.SLEEP_ASLEEP, HealthDataType.SLEEP_IN_BED],
        startTime: startOfYesterday,
        endTime: now,
      );

      if (data.isEmpty) return null;

      // 睡眠データを時間で計算
      double totalSleepHours = 0.0;
      for (final point in data) {
        if (point.type == HealthDataType.SLEEP_ASLEEP) {
          final sleepDuration = point.dateTo.difference(point.dateFrom);
          totalSleepHours += sleepDuration.inMinutes / 60.0;
        }
      }

      return totalSleepHours > 0 ? totalSleepHours : null;
    } catch (e) {
      print('睡眠時間取得エラー: $e');
      return null;
    }
  }

  /// 体重データを手動で記録
  Future<bool> writeWeight(double weight, DateTime dateTime) async {
    try {
      if (!_isConfigured) {
        final initialized = await initialize();
        if (!initialized) return false;
      }

      bool success = await _health.writeHealthData(
        value: weight,
        type: HealthDataType.WEIGHT,
        startTime: dateTime,
        endTime: dateTime,
        unit: HealthDataUnit.KILOGRAM,
      );

      return success;
    } catch (e) {
      print('体重記録エラー: $e');
      return false;
    }
  }

  /// 体脂肪率データを手動で記録
  Future<bool> writeBodyFatPercentage(double percentage, DateTime dateTime) async {
    try {
      if (!_isConfigured) {
        final initialized = await initialize();
        if (!initialized) return false;
      }

      bool success = await _health.writeHealthData(
        value: percentage,
        type: HealthDataType.BODY_FAT_PERCENTAGE,
        startTime: dateTime,
        endTime: dateTime,
        unit: HealthDataUnit.PERCENT,
      );

      return success;
    } catch (e) {
      print('体脂肪率記録エラー: $e');
      return false;
    }
  }

  /// HealthKitが利用可能かチェック
  Future<bool> isHealthKitAvailable() async {
    try {
      await _health.configure();
      return true;
    } catch (e) {
      return false;
    }
  }
}