import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import '../../data/datasources/app_database.dart';
import '../../core/services/recipe_nutrition_analysis_service.dart';
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

// 今日の食事（レシピ情報付き）プロバイダー
final todayMealsWithRecipesProvider = FutureProvider<List<MealWithRecipe>>((ref) async {
  final database = ref.watch(databaseProvider);
  return await database.getMealsWithRecipesByDate(DateTime.now());
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
  late final RecipeNutritionAnalysisService _nutritionService;

  RecipeRegistrationNotifier(this._database, this._ref) : super(const AsyncValue.data(null)) {
    _nutritionService = RecipeNutritionAnalysisService(_database);
  }

  /// 外部レシピを保存（栄養分析付き）
  Future<void> saveExternalRecipe({
    required String url,
    required String title,
    String? description,
    String? imageUrl,
    String? siteName,
    String? tags,
    String? memo,
    String? recipeText, // 追加：レシピ本文
  }) async {
    state = const AsyncValue.loading();
    
    try {
      // 既存のレシピをチェック
      final existingRecipe = await _database.getRecipeByUrl(url);
      if (existingRecipe != null) {
        throw Exception('このレシピは既に登録されています');
      }
      
      // レシピ本文がある場合は栄養分析を実行
      print('デバッグ: recipeText = $recipeText');
      RecipeNutritionResult? nutritionResult;
      if (recipeText != null && recipeText.isNotEmpty) {
        print('デバッグ: 栄養分析を開始');
        try {
          nutritionResult = await _nutritionService.analyzeRecipe(recipeText);
          print('デバッグ: 栄養分析完了 - ${nutritionResult.ingredients.length}件の材料を抽出');
        } catch (e) {
          print('栄養分析エラー: $e');
          // エラーがあっても保存は続行
        }
      } else {
        print('デバッグ: recipeTextが空のため栄養分析をスキップ');
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
          
          // 栄養分析結果を追加
          ingredientsJson: nutritionResult != null ? Value(nutritionResult.ingredientsJson) : const Value.absent(),
          ingredientsRawText: recipeText != null ? Value(recipeText) : const Value.absent(),
          calories: nutritionResult != null ? Value(nutritionResult.nutrition.energy) : const Value.absent(),
          protein: nutritionResult != null ? Value(nutritionResult.nutrition.protein) : const Value.absent(),
          fat: nutritionResult != null ? Value(nutritionResult.nutrition.fat) : const Value.absent(),
          carbohydrate: nutritionResult != null ? Value(nutritionResult.nutrition.carbohydrate) : const Value.absent(),
          salt: nutritionResult != null ? Value(nutritionResult.nutrition.salt) : const Value.absent(),
          fiber: nutritionResult != null ? Value(nutritionResult.nutrition.fiber) : const Value.absent(),
          vitaminC: nutritionResult != null ? Value(nutritionResult.nutrition.vitaminC) : const Value.absent(),
          isNutritionAutoExtracted: Value(nutritionResult != null),
          servings: const Value(1), // デフォルト1人前
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

  /// 外部レシピを栄養分析結果と一緒に保存
  Future<void> saveExternalRecipeWithNutrition({
    required String url,
    required String title,
    String? description,
    String? imageUrl,
    String? siteName,
    String? tags,
    String? memo,
    String? recipeText,
    RecipeNutritionResult? nutritionResult,
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
          
          // 栄養分析結果を追加
          ingredientsJson: nutritionResult != null ? Value(nutritionResult.ingredientsJson) : const Value.absent(),
          ingredientsRawText: recipeText != null ? Value(recipeText) : const Value.absent(),
          calories: nutritionResult != null ? Value(nutritionResult.nutrition.energy) : const Value.absent(),
          protein: nutritionResult != null ? Value(nutritionResult.nutrition.protein) : const Value.absent(),
          fat: nutritionResult != null ? Value(nutritionResult.nutrition.fat) : const Value.absent(),
          carbohydrate: nutritionResult != null ? Value(nutritionResult.nutrition.carbohydrate) : const Value.absent(),
          salt: nutritionResult != null ? Value(nutritionResult.nutrition.salt) : const Value.absent(),
          fiber: nutritionResult != null ? Value(nutritionResult.nutrition.fiber) : const Value.absent(),
          vitaminC: nutritionResult != null ? Value(nutritionResult.nutrition.vitaminC) : const Value.absent(),
          isNutritionAutoExtracted: Value(nutritionResult != null),
          servings: const Value(1), // デフォルト1人前
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

  /// お気に入り状態を切り替え
  Future<void> toggleFavorite(int recipeId) async {
    try {
      await _database.toggleFavoriteRecipe(recipeId);
      
      // レシピリストを更新
      _ref.invalidate(favoriteRecipesProvider);
      _ref.invalidate(recentRecipesProvider);
      
    } catch (e, stackTrace) {
      // エラーが発生してもUIには反映させず、ログだけ出力
      print('お気に入り切り替えエラー: $e');
    }
  }

  /// 外部レシピを更新
  Future<void> updateExternalRecipe({
    required int recipeId,
    required String title,  
    String? tags,
    String? memo,
    String? ingredientsRawText,
    String? ingredientsJson,
    double? calories,
    double? protein,
    double? fat,
    double? carbohydrate,
    double? salt,
    double? fiber,
    double? vitaminC,
  }) async {
    state = const AsyncValue.loading();
    
    try {
      await _database.updateExternalRecipe(
        recipeId: recipeId,
        title: title,
        tags: tags?.isNotEmpty == true ? tags : null,
        memo: memo?.isNotEmpty == true ? memo : null,
        ingredientsRawText: ingredientsRawText?.isNotEmpty == true ? ingredientsRawText : null,
        ingredientsJson: ingredientsJson?.isNotEmpty == true ? ingredientsJson : null,
        calories: calories,
        protein: protein,
        fat: fat,
        carbohydrate: carbohydrate,
        salt: salt,
        fiber: fiber,
        vitaminC: vitaminC,
      );
      
      state = const AsyncValue.data(null);
      
      // レシピリストを更新
      _ref.invalidate(favoriteRecipesProvider);
      _ref.invalidate(recentRecipesProvider);
      
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// 外部レシピを削除
  Future<void> deleteExternalRecipe(int recipeId) async {
    state = const AsyncValue.loading();
    
    try {
      await _database.deleteExternalRecipe(recipeId);
      
      state = const AsyncValue.data(null);
      
      // レシピリストを更新
      _ref.invalidate(favoriteRecipesProvider);
      _ref.invalidate(recentRecipesProvider);
      
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

// 食事削除プロバイダー
final mealDeletionProvider = StateNotifierProvider<MealDeletionNotifier, AsyncValue<void>>((ref) {
  return MealDeletionNotifier(ref.read(databaseProvider), ref);
});

/// 食事削除の状態管理
class MealDeletionNotifier extends StateNotifier<AsyncValue<void>> {
  final AppDatabase _database;
  final StateNotifierProviderRef<MealDeletionNotifier, AsyncValue<void>> _ref;

  MealDeletionNotifier(this._database, this._ref) : super(const AsyncValue.data(null));

  /// 食事記録を削除
  Future<void> deleteMeal(int mealId) async {
    state = const AsyncValue.loading();
    
    try {
      await _database.deleteMeal(mealId);
      state = const AsyncValue.data(null);
      
      // 食事リストを更新
      _ref.invalidate(todayMealsProvider);
      _ref.invalidate(todayMealsWithRecipesProvider);
      _ref.invalidate(todayNutritionProvider);
      
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}