import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/health_service.dart';

// HealthServiceのプロバイダー
final healthServiceProvider = Provider<HealthService>((ref) {
  return HealthService();
});

// 選択された日付のプロバイダー（初期値は今日）
final selectedDateProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
});

// HealthKit権限状態のプロバイダー
final healthPermissionProvider = FutureProvider<bool>((ref) async {
  final healthService = ref.read(healthServiceProvider);
  return await healthService.requestPermissions();
});

// 体重データのプロバイダー
final weightProvider = FutureProvider<double?>((ref) async {
  final healthService = ref.read(healthServiceProvider);
  
  // 権限チェック
  final hasPermission = await ref.read(healthPermissionProvider.future);
  if (!hasPermission) return null;
  
  return await healthService.getLatestWeight();
});

// 体脂肪率データのプロバイダー
final bodyFatProvider = FutureProvider<double?>((ref) async {
  final healthService = ref.read(healthServiceProvider);
  
  // 権限チェック
  final hasPermission = await ref.read(healthPermissionProvider.future);
  if (!hasPermission) return null;
  
  return await healthService.getLatestBodyFatPercentage();
});

// 今日の歩数プロバイダー
final todayStepsProvider = FutureProvider<int?>((ref) async {
  final healthService = ref.read(healthServiceProvider);
  
  // 権限チェック
  final hasPermission = await ref.read(healthPermissionProvider.future);
  if (!hasPermission) return null;
  
  return await healthService.getTodaySteps();
});

// 今日の消費カロリープロバイダー
final todayActiveEnergyProvider = FutureProvider<double?>((ref) async {
  final healthService = ref.read(healthServiceProvider);
  
  // 権限チェック
  final hasPermission = await ref.read(healthPermissionProvider.future);
  if (!hasPermission) return null;
  
  return await healthService.getTodayActiveEnergy();
});

// 今日の運動時間プロバイダー
final todayExerciseTimeProvider = FutureProvider<int?>((ref) async {
  final healthService = ref.read(healthServiceProvider);
  
  // 権限チェック
  final hasPermission = await ref.read(healthPermissionProvider.future);
  if (!hasPermission) return null;
  
  return await healthService.getTodayExerciseTime();
});

// 昨夜の睡眠時間プロバイダー
final lastNightSleepProvider = FutureProvider<double?>((ref) async {
  final healthService = ref.read(healthServiceProvider);
  
  // 権限チェック
  final hasPermission = await ref.read(healthPermissionProvider.future);
  if (!hasPermission) return null;
  
  return await healthService.getLastNightSleepHours();
});

// HealthKitの利用可否プロバイダー
final healthKitAvailabilityProvider = FutureProvider<bool>((ref) async {
  final healthService = ref.read(healthServiceProvider);
  return await healthService.isHealthKitAvailable();
});

// 体重履歴プロバイダー
final weightHistoryProvider = FutureProvider<List<WeightData>>((ref) async {
  final healthService = ref.read(healthServiceProvider);
  
  // 権限チェック
  final hasPermission = await ref.read(healthPermissionProvider.future);
  if (!hasPermission) return [];
  
  return await healthService.getWeightHistory();
});

// 健康データを統合したプロバイダー（直近24時間のデータ）
final healthDataSummaryProvider = FutureProvider<HealthDataSummary>((ref) async {
  final healthService = ref.watch(healthServiceProvider);
  final selectedDate = ref.watch(selectedDateProvider);
  final hasPermission = await ref.read(healthPermissionProvider.future);
  
  if (!hasPermission) {
    return HealthDataSummary(
      hasHealthKitPermission: false,
      targetDate: selectedDate,
    );
  }
  
  // 並行してデータを取得（活動データは直近24時間）
  final results = await Future.wait([
    healthService.getLatestWeight(),
    healthService.getLatestBodyFatPercentage(),
    healthService.getLast24HoursSteps(),  // 直近24時間
    healthService.getLast24HoursActiveEnergy(),  // 直近24時間
    healthService.getLast24HoursExerciseTime(),  // 直近24時間
    healthService.getLast24HoursSleepHours(),  // 直近24時間
  ]);
  
  return HealthDataSummary(
    weight: results[0] as double?,
    bodyFatPercentage: results[1] as double?,
    todaySteps: results[2] as int?,
    todayActiveEnergy: results[3] as double?,
    todayExerciseTime: results[4] as int?,
    lastNightSleepHours: results[5] as double?,
    hasHealthKitPermission: hasPermission,
    targetDate: selectedDate,
  );
});

// 健康データのサマリークラス
class HealthDataSummary {
  final double? weight;
  final double? bodyFatPercentage;
  final int? todaySteps;
  final double? todayActiveEnergy;
  final int? todayExerciseTime;
  final double? lastNightSleepHours;
  final bool hasHealthKitPermission;
  final DateTime targetDate;

  const HealthDataSummary({
    this.weight,
    this.bodyFatPercentage,
    this.todaySteps,
    this.todayActiveEnergy,
    this.todayExerciseTime,
    this.lastNightSleepHours,
    required this.hasHealthKitPermission,
    required this.targetDate,
  });

  // デバッグ用
  @override
  String toString() {
    return 'HealthDataSummary('
        'targetDate: $targetDate, '
        'weight: $weight, '
        'bodyFat: $bodyFatPercentage, '
        'steps: $todaySteps, '
        'activeEnergy: $todayActiveEnergy, '
        'exerciseTime: $todayExerciseTime, '
        'sleep: $lastNightSleepHours, '
        'hasPermission: $hasHealthKitPermission'
        ')';
  }
}