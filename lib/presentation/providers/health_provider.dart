import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/health_service.dart';

// HealthServiceのプロバイダー
final healthServiceProvider = Provider<HealthService>((ref) {
  return HealthService();
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

// 全体的な健康データを統合したプロバイダー
final healthDataSummaryProvider = FutureProvider<HealthDataSummary>((ref) async {
  final weight = await ref.read(weightProvider.future);
  final bodyFat = await ref.read(bodyFatProvider.future);
  final steps = await ref.read(todayStepsProvider.future);
  final activeEnergy = await ref.read(todayActiveEnergyProvider.future);
  final exerciseTime = await ref.read(todayExerciseTimeProvider.future);
  final sleepHours = await ref.read(lastNightSleepProvider.future);
  final hasPermission = await ref.read(healthPermissionProvider.future);
  
  return HealthDataSummary(
    weight: weight,
    bodyFatPercentage: bodyFat,
    todaySteps: steps,
    todayActiveEnergy: activeEnergy,
    todayExerciseTime: exerciseTime,
    lastNightSleepHours: sleepHours,
    hasHealthKitPermission: hasPermission,
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

  const HealthDataSummary({
    this.weight,
    this.bodyFatPercentage,
    this.todaySteps,
    this.todayActiveEnergy,
    this.todayExerciseTime,
    this.lastNightSleepHours,
    required this.hasHealthKitPermission,
  });

  // デバッグ用
  @override
  String toString() {
    return 'HealthDataSummary('
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