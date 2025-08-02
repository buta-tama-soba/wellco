import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import '../../data/datasources/app_database.dart';
import 'health_provider.dart';

// データベースインスタンスのプロバイダー
final databaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(() => database.close());
  return database;
});

// 今日の栄養データプロバイダー
final todayNutritionProvider = FutureProvider<Map<String, double>>((ref) async {
  final database = ref.watch(databaseProvider);
  return await database.getTodayNutrition();
});

// 今日の食事プロバイダー
final todayMealsProvider = FutureProvider<List<MealTableData>>((ref) async {
  final database = ref.watch(databaseProvider);
  return await database.getMealsByDate(DateTime.now());
});

// 選択された日付のパーソナルデータプロバイダー（HealthKit統合）
final todayPersonalDataProvider = FutureProvider<PersonalDataTableData?>((ref) async {
  // HealthKitからデータを取得
  try {
    final healthSummary = await ref.read(healthDataSummaryProvider.future);
    
    return PersonalDataTableData(
      dataSource: 'HealthKit',
      recordedDate: DateTime.now(),
      steps: healthSummary.todaySteps,
      activeEnergy: healthSummary.todayActiveEnergy,
      weight: healthSummary.weight,
      bodyFatPercentage: healthSummary.bodyFatPercentage,
      exerciseTime: healthSummary.todayExerciseTime,
      sleepHours: healthSummary.lastNightSleepHours,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  } catch (e) {
    print('HealthKit データ取得エラー: $e');
    // エラー時はnullを返す（ダミーデータは返さない）
    return null;
  }
});

// お気に入りレシピプロバイダー
final favoriteRecipesProvider = FutureProvider<List<ExternalRecipeTableData>>((ref) async {
  final database = ref.watch(databaseProvider);
  return await database.getFavoriteRecipes();
});

// 最近のレシピプロバイダー
final recentRecipesProvider = FutureProvider<List<ExternalRecipeTableData>>((ref) async {
  final database = ref.watch(databaseProvider);
  return await database.getRecentRecipes(limit: 10);
});

// 体重履歴プロバイダー（一時的なダミーデータ）
final weightHistoryProvider = FutureProvider<List<WeightData>>((ref) async {
  // 一時的なダミーデータを返す
  await Future.delayed(const Duration(milliseconds: 500));
  
  final now = DateTime.now();
  return List.generate(30, (index) {
    final date = now.subtract(Duration(days: 29 - index));
    final baseWeight = 70.0;
    final variation = (index % 7 - 3) * 0.3; // 週次変動
    final trend = -index * 0.05; // 減少トレンド
    
    return WeightData(
      date: date,
      weight: baseWeight + variation + trend,
    );
  });
});

// 体重データクラス
class WeightData {
  final DateTime date;
  final double weight;

  const WeightData({
    required this.date,
    required this.weight,
  });
}

// レシピ保存プロバイダー（状態管理付き）
final recipeRegistrationProvider = StateNotifierProvider<RecipeRegistrationNotifier, AsyncValue<void>>((ref) {
  return RecipeRegistrationNotifier(ref.read(databaseProvider), ref);
});

/// レシピ登録の状態管理
class RecipeRegistrationNotifier extends StateNotifier<AsyncValue<void>> {
  final AppDatabase _database;
  final StateNotifierProviderRef<RecipeRegistrationNotifier, AsyncValue<void>> _ref;

  RecipeRegistrationNotifier(this._database, this._ref) : super(const AsyncValue.data(null));

  /// 外部レシピを保存
  Future<void> saveExternalRecipe({
    required String url,
    required String title,
    String? description,
    String? imageUrl,
    String? siteName,
    String? tags,
    String? memo,
  }) async {
    state = const AsyncValue.loading();
    
    try {
      // 既存のレシピをチェック
      final existingRecipe = await _database.getRecipeByUrl(url);
      if (existingRecipe != null) {
        throw Exception('このレシピは既に登録されています');
      }
      
      // 新しいレシピを保存
      await _database.insertExternalRecipe(
        ExternalRecipeTableCompanion.insert(
          url: url,
          title: title,
          description: description != null ? Value(description) : const Value.absent(),
          imageUrl: imageUrl != null ? Value(imageUrl) : const Value.absent(),
          siteName: siteName != null ? Value(siteName) : const Value.absent(),
          tags: tags != null ? Value(tags) : const Value.absent(),
          memo: memo != null ? Value(memo) : const Value.absent(),
        ),
      );
      
      state = const AsyncValue.data(null);
      
      // お気に入りレシピプロバイダーを更新
      _ref.invalidate(favoriteRecipesProvider);
      _ref.invalidate(recentRecipesProvider);
      
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}