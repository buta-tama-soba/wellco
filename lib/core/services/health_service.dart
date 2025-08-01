import 'package:health/health.dart';

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

  /// 体重データを取得（今日のデータを優先）
  Future<double?> getLatestWeight() async {
    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final thirtyDaysAgo = now.subtract(const Duration(days: 30));

      List<HealthDataPoint> data = await _health.getHealthDataFromTypes(
        types: [HealthDataType.WEIGHT],
        startTime: thirtyDaysAgo,
        endTime: now,
      );

      if (data.isEmpty) return null;

      // 日付順でソート（最新が先頭）
      data.sort((a, b) => b.dateFrom.compareTo(a.dateFrom));
      
      // 今日のデータがあるかチェック
      final todayData = data.where((point) => 
        point.dateFrom.isAfter(today) || 
        point.dateFrom.isAtSameMomentAs(today)
      ).toList();
      
      // 今日のデータがあれば最新のものを、なければ全体の最新データを使用
      final latestData = todayData.isNotEmpty ? todayData.first : data.first;
      final latestWeight = latestData.value as NumericHealthValue;
      
      print('体重データ取得: ${latestWeight.numericValue}kg (日時: ${latestData.dateFrom})');
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
      // HealthKitの体脂肪率は0-1の小数値で格納されているため100倍する
      return latestBodyFat.numericValue.toDouble() * 100;
    } catch (e) {
      print('体脂肪率取得エラー: $e');
      return null;
    }
  }

  /// 指定日の歩数を取得（重複除去済み）
  Future<int?> getStepsForDate(DateTime date) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));
      print('歩数取得開始: ${startOfDay} から ${endOfDay}');

      // getTotalStepsInIntervalを試行、失敗した場合はgetHealthDataFromTypesで重複除去
      try {
        print('getTotalStepsInInterval を試行中...');
        final steps = await _health.getTotalStepsInInterval(startOfDay, endOfDay);
        print('getTotalStepsInInterval結果: $steps');
        if (steps != null && steps > 0) {
          print('getTotalStepsInInterval成功: ${steps.toInt()}歩');
          return steps.toInt();
        }
      } catch (e) {
        print('getTotalStepsInInterval失敗: $e');
      }

      // フォールバック: 従来の方法で取得して重複除去
      print('フォールバック方法でgetHealthDataFromTypesを使用...');
      List<HealthDataPoint> data = await _health.getHealthDataFromTypes(
        types: [HealthDataType.STEPS],
        startTime: startOfDay,
        endTime: endOfDay,
      );

      print('生データ取得: ${data.length}件のデータポイント');
      if (data.isEmpty) {
        print('歩数データが見つかりません');
        return null;
      }

      // 生データの内容を確認
      for (int i = 0; i < data.length && i < 5; i++) {
        final point = data[i];
        final steps = point.value as NumericHealthValue;
        print('生データ[$i]: ${steps.numericValue}歩 (${point.dateFrom} - ${point.dateTo}) source: ${point.sourceId}');
      }

      // health package の removeDuplicates を使用
      print('重複除去前のデータ件数: ${data.length}');
      data = _health.removeDuplicates(data);
      print('重複除去後のデータ件数: ${data.length}');

      // 指定日の歩数を合計
      int totalSteps = 0;
      for (final point in data) {
        final steps = point.value as NumericHealthValue;
        totalSteps += steps.numericValue.toInt();
        print('加算中: ${steps.numericValue}歩, 累計: ${totalSteps}歩');
      }

      print('指定日歩数取得結果: $totalSteps');
      return totalSteps;
    } catch (e) {
      print('歩数取得エラー: $e');
      return null;
    }
  }

  /// 直近24時間の歩数を取得（重複除去済み）
  Future<int?> getLast24HoursSteps() async {
    try {
      final now = DateTime.now();
      final twentyFourHoursAgo = now.subtract(const Duration(hours: 24));
      print('直近24時間の歩数取得開始: ${twentyFourHoursAgo} から ${now}');

      // getTotalStepsInIntervalを試行、失敗した場合はgetHealthDataFromTypesで重複除去
      try {
        print('getTotalStepsInInterval を試行中...');
        final steps = await _health.getTotalStepsInInterval(twentyFourHoursAgo, now);
        print('getTotalStepsInInterval結果: $steps');
        if (steps != null && steps > 0) {
          print('getTotalStepsInInterval成功: ${steps.toInt()}歩');
          return steps.toInt();
        }
      } catch (e) {
        print('getTotalStepsInInterval失敗: $e');
      }

      // フォールバック: 従来の方法で取得して重複除去
      print('フォールバック方法でgetHealthDataFromTypesを使用...');
      List<HealthDataPoint> data = await _health.getHealthDataFromTypes(
        types: [HealthDataType.STEPS],
        startTime: twentyFourHoursAgo,
        endTime: now,
      );

      print('生データ取得: ${data.length}件のデータポイント');
      if (data.isEmpty) {
        print('歩数データが見つかりません');
        return null;
      }

      // 生データの内容を確認
      for (int i = 0; i < data.length && i < 5; i++) {
        final point = data[i];
        final steps = point.value as NumericHealthValue;
        print('生データ[$i]: ${steps.numericValue}歩 (${point.dateFrom} - ${point.dateTo}) source: ${point.sourceId}');
      }

      // health package の removeDuplicates を使用
      print('重複除去前のデータ件数: ${data.length}');
      data = _health.removeDuplicates(data);
      print('重複除去後のデータ件数: ${data.length}');

      // 直近24時間の歩数を合計
      int totalSteps = 0;
      for (final point in data) {
        final steps = point.value as NumericHealthValue;
        totalSteps += steps.numericValue.toInt();
        print('加算中: ${steps.numericValue}歩, 累計: ${totalSteps}歩');
      }

      print('直近24時間歩数取得結果: $totalSteps');
      return totalSteps;
    } catch (e) {
      print('歩数取得エラー: $e');
      return null;
    }
  }

  /// 今日の歩数を取得（重複除去済み）
  Future<int?> getTodaySteps() async {
    final now = DateTime.now();
    return getStepsForDate(now);
  }

  /// 指定日の消費カロリーを取得
  Future<double?> getActiveEnergyForDate(DateTime date) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));
      print('消費カロリー取得開始: ${startOfDay} から ${endOfDay}');

      List<HealthDataPoint> data = await _health.getHealthDataFromTypes(
        types: [HealthDataType.ACTIVE_ENERGY_BURNED],
        startTime: startOfDay,
        endTime: endOfDay,
      );

      print('生データ取得: ${data.length}件の消費カロリーデータポイント');
      if (data.isEmpty) {
        print('消費カロリーデータが見つかりません');
        return null;
      }

      // 生データの内容を確認
      for (int i = 0; i < data.length && i < 5; i++) {
        final point = data[i];
        final energy = point.value as NumericHealthValue;
        print('生データ[$i]: ${energy.numericValue} kcal (${point.dateFrom} - ${point.dateTo}) source: ${point.sourceId}');
      }

      // 重複除去
      print('重複除去前の消費カロリーデータ件数: ${data.length}');
      data = _health.removeDuplicates(data);
      print('重複除去後の消費カロリーデータ件数: ${data.length}');

      // 指定日の消費カロリーを合計
      double totalEnergy = 0.0;
      for (final point in data) {
        final energy = point.value as NumericHealthValue;
        totalEnergy += energy.numericValue.toDouble();
        print('加算中: ${energy.numericValue} kcal, 累計: ${totalEnergy} kcal');
      }

      print('指定日消費カロリー: ${totalEnergy} kcal');
      return totalEnergy;
    } catch (e) {
      print('消費カロリー取得エラー: $e');
      return null;
    }
  }

  /// 直近24時間の消費カロリーを取得
  Future<double?> getLast24HoursActiveEnergy() async {
    try {
      final now = DateTime.now();
      final twentyFourHoursAgo = now.subtract(const Duration(hours: 24));
      print('直近24時間の消費カロリー取得開始: ${twentyFourHoursAgo} から ${now}');

      List<HealthDataPoint> data = await _health.getHealthDataFromTypes(
        types: [HealthDataType.ACTIVE_ENERGY_BURNED],
        startTime: twentyFourHoursAgo,
        endTime: now,
      );

      print('生データ取得: ${data.length}件の消費カロリーデータポイント');
      if (data.isEmpty) {
        print('消費カロリーデータが見つかりません');
        return null;
      }

      // 生データの内容を確認
      for (int i = 0; i < data.length && i < 5; i++) {
        final point = data[i];
        final energy = point.value as NumericHealthValue;
        print('生データ[$i]: ${energy.numericValue} kcal (${point.dateFrom} - ${point.dateTo}) source: ${point.sourceId}');
      }

      // 重複除去
      print('重複除去前の消費カロリーデータ件数: ${data.length}');
      data = _health.removeDuplicates(data);
      print('重複除去後の消費カロリーデータ件数: ${data.length}');

      // 直近24時間の消費カロリーを合計
      double totalEnergy = 0.0;
      for (final point in data) {
        final energy = point.value as NumericHealthValue;
        totalEnergy += energy.numericValue.toDouble();
        print('加算中: ${energy.numericValue} kcal, 累計: ${totalEnergy} kcal');
      }

      print('直近24時間消費カロリー: ${totalEnergy} kcal');
      return totalEnergy;
    } catch (e) {
      print('消費カロリー取得エラー: $e');
      return null;
    }
  }

  /// 今日の消費カロリーを取得
  Future<double?> getTodayActiveEnergy() async {
    final now = DateTime.now();
    return getActiveEnergyForDate(now);
  }

  /// 指定日の運動時間を取得（分）
  Future<int?> getExerciseTimeForDate(DateTime date) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));
      print('運動時間取得開始: ${startOfDay} から ${endOfDay}');

      List<HealthDataPoint> data = await _health.getHealthDataFromTypes(
        types: [HealthDataType.EXERCISE_TIME],
        startTime: startOfDay,
        endTime: endOfDay,
      );

      print('生データ取得: ${data.length}件の運動時間データポイント');
      if (data.isEmpty) {
        print('運動時間データが見つかりません');
        return null;
      }

      // 生データの内容を確認
      for (int i = 0; i < data.length && i < 5; i++) {
        final point = data[i];
        final exerciseTime = point.value as NumericHealthValue;
        print('生データ[$i]: ${exerciseTime.numericValue} 分 (${point.dateFrom} - ${point.dateTo}) source: ${point.sourceId}');
      }

      // 重複除去
      print('重複除去前の運動時間データ件数: ${data.length}');
      data = _health.removeDuplicates(data);
      print('重複除去後の運動時間データ件数: ${data.length}');

      // 指定日の運動時間を合計（分）
      int totalMinutes = 0;
      for (final point in data) {
        final exerciseTime = point.value as NumericHealthValue;
        totalMinutes += exerciseTime.numericValue.toInt();
        print('加算中: ${exerciseTime.numericValue} 分, 累計: ${totalMinutes} 分');
      }

      print('指定日運動時間: ${totalMinutes} 分');
      return totalMinutes;
    } catch (e) {
      print('運動時間取得エラー: $e');
      return null;
    }
  }

  /// 直近24時間の運動時間を取得（分）
  Future<int?> getLast24HoursExerciseTime() async {
    try {
      final now = DateTime.now();
      final twentyFourHoursAgo = now.subtract(const Duration(hours: 24));
      print('直近24時間の運動時間取得開始: ${twentyFourHoursAgo} から ${now}');

      List<HealthDataPoint> data = await _health.getHealthDataFromTypes(
        types: [HealthDataType.EXERCISE_TIME],
        startTime: twentyFourHoursAgo,
        endTime: now,
      );

      print('生データ取得: ${data.length}件の運動時間データポイント');
      if (data.isEmpty) {
        print('運動時間データが見つかりません');
        return null;
      }

      // 生データの内容を確認
      for (int i = 0; i < data.length && i < 5; i++) {
        final point = data[i];
        final exerciseTime = point.value as NumericHealthValue;
        print('生データ[$i]: ${exerciseTime.numericValue} 分 (${point.dateFrom} - ${point.dateTo}) source: ${point.sourceId}');
      }

      // 重複除去
      print('重複除去前の運動時間データ件数: ${data.length}');
      data = _health.removeDuplicates(data);
      print('重複除去後の運動時間データ件数: ${data.length}');

      // 直近24時間の運動時間を合計（分）
      int totalMinutes = 0;
      for (final point in data) {
        final exerciseTime = point.value as NumericHealthValue;
        totalMinutes += exerciseTime.numericValue.toInt();
        print('加算中: ${exerciseTime.numericValue} 分, 累計: ${totalMinutes} 分');
      }

      print('直近24時間運動時間: ${totalMinutes} 分');
      return totalMinutes;
    } catch (e) {
      print('運動時間取得エラー: $e');
      return null;
    }
  }

  /// 今日の運動時間を取得（分）
  Future<int?> getTodayExerciseTime() async {
    final now = DateTime.now();
    return getExerciseTimeForDate(now);
  }

  /// 指定日の夜の睡眠時間を取得（時間）
  Future<double?> getSleepHoursForDate(DateTime date) async {
    try {
      // 指定日の夜から翌日昼まで（睡眠時間は日付をまたぐため）
      final nightStart = DateTime(date.year, date.month, date.day, 18); // 18時から
      final nextDayNoon = DateTime(date.year, date.month, date.day + 1, 12); // 翌日12時まで
      print('睡眠時間取得開始: ${nightStart} から ${nextDayNoon}');

      List<HealthDataPoint> data = await _health.getHealthDataFromTypes(
        types: [HealthDataType.SLEEP_ASLEEP],
        startTime: nightStart,
        endTime: nextDayNoon,
      );

      print('生データ取得: ${data.length}件の睡眠データポイント');
      if (data.isEmpty) {
        print('睡眠時間データが見つかりません');
        return null;
      }

      // 日付順でソート（最新が先頭）
      data.sort((a, b) => b.dateFrom.compareTo(a.dateFrom));

      // 同じ夜の睡眠セッションをグループ化
      double totalSleepHours = 0.0;
      DateTime? lastSleepEnd;
      
      for (final point in data) {
        final sleepDuration = point.dateTo.difference(point.dateFrom);
        
        // 最初の睡眠データか、前の睡眠終了時刻から8時間以内の場合は同じセッション
        if (lastSleepEnd == null || 
            point.dateTo.difference(lastSleepEnd).inHours.abs() <= 8) {
          totalSleepHours += sleepDuration.inMinutes / 60.0;
          lastSleepEnd = point.dateTo;
          print('睡眠データ: ${point.dateFrom} - ${point.dateTo}, 時間: ${sleepDuration.inMinutes / 60.0}時間');
        } else {
          // 8時間以上離れている場合は別のセッションなので終了
          break;
        }
      }

      print('指定日の合計睡眠時間: ${totalSleepHours}時間');
      return totalSleepHours > 0 ? totalSleepHours : null;
    } catch (e) {
      print('睡眠時間取得エラー: $e');
      return null;
    }
  }

  /// 直近24時間の睡眠時間を取得（時間）
  Future<double?> getLast24HoursSleepHours() async {
    try {
      final now = DateTime.now();
      final twentyFourHoursAgo = now.subtract(const Duration(hours: 24));
      print('直近24時間の睡眠時間取得開始: ${twentyFourHoursAgo} から ${now}');

      List<HealthDataPoint> data = await _health.getHealthDataFromTypes(
        types: [HealthDataType.SLEEP_ASLEEP],
        startTime: twentyFourHoursAgo,
        endTime: now,
      );

      print('生データ取得: ${data.length}件の睡眠データポイント');
      if (data.isEmpty) {
        print('睡眠時間データが見つかりません');
        return null;
      }

      // 日付順でソート（最新が先頭）
      data.sort((a, b) => b.dateFrom.compareTo(a.dateFrom));

      // 直近24時間の睡眠時間を合計
      double totalSleepHours = 0.0;
      
      for (final point in data) {
        final sleepDuration = point.dateTo.difference(point.dateFrom);
        totalSleepHours += sleepDuration.inMinutes / 60.0;
        print('睡眠データ: ${point.dateFrom} - ${point.dateTo}, 時間: ${sleepDuration.inMinutes / 60.0}時間');
      }

      print('直近24時間の合計睡眠時間: ${totalSleepHours}時間');
      return totalSleepHours > 0 ? totalSleepHours : null;
    } catch (e) {
      print('睡眠時間取得エラー: $e');
      return null;
    }
  }

  /// 直近の睡眠時間を取得（時間）
  Future<double?> getLastNightSleepHours() async {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return getSleepHoursForDate(yesterday);
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

  /// 過去3ヶ月の体重履歴を取得
  Future<List<WeightData>> getWeightHistory() async {
    try {
      final now = DateTime.now();
      final threeMonthsAgo = now.subtract(const Duration(days: 90));
      
      print('体重履歴取得開始: ${threeMonthsAgo} から ${now}');

      List<HealthDataPoint> data = await _health.getHealthDataFromTypes(
        types: [HealthDataType.WEIGHT],
        startTime: threeMonthsAgo,
        endTime: now,
      );

      print('体重履歴データ取得: ${data.length}件');
      if (data.isEmpty) {
        print('体重履歴データが見つかりません');
        return [];
      }

      // 日付順でソート（古い順）
      data.sort((a, b) => a.dateFrom.compareTo(b.dateFrom));

      // WeightDataに変換
      List<WeightData> weightHistory = [];
      for (final point in data) {
        final weight = point.value as NumericHealthValue;
        weightHistory.add(WeightData(
          date: point.dateFrom,
          weight: weight.numericValue.toDouble(),
          measurementError: 0.1, // 体重計の一般的な誤差
        ));
      }

      print('体重履歴変換完了: ${weightHistory.length}件');
      return weightHistory;
    } catch (e) {
      print('体重履歴取得エラー: $e');
      return [];
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

/// 体重データクラス
class WeightData {
  final DateTime date;
  final double weight;
  final double? measurementError;

  const WeightData({
    required this.date,
    required this.weight,
    this.measurementError,
  });

  @override
  String toString() {
    return 'WeightData(date: $date, weight: ${weight}kg, error: $measurementError)';
  }
}