import 'package:flutter_riverpod/flutter_riverpod.dart';

// 一時的にダミーのデータベースクラスとテーブルデータクラスを作成
class AppDatabase {
  void close() {}
  Future<Map<String, double>> getTodayNutrition() async {
    return {
      'calories': 0.0,
      'protein': 0.0,
      'fat': 0.0,
      'carbs': 0.0,
    };
  }
  Future<List<FoodItemTableData>> getAllFoodItems() async => [];
  Future<List<FoodItemTableData>> getExpiringSoon(int days) async => [];
  Future<List<MealTableData>> getMealsByDate(DateTime date) async => [];
  Future<PersonalDataTableData?> getPersonalDataByDate(DateTime date) async => null;
  Future<List<double>> getWeightHistory(int days) async => [];
  Future<List<RecipeTableData>> getFavoriteRecipes() async => [];
}

class FoodItemTableData {
  const FoodItemTableData();
}

class MealTableData {
  const MealTableData();
}

class PersonalDataTableData {
  const PersonalDataTableData();
  int? get steps => null;
  double? get activeEnergy => null;
}

class RecipeTableData {
  const RecipeTableData();
}

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

// 食品一覧プロバイダー
final foodItemsProvider = FutureProvider<List<FoodItemTableData>>((ref) async {
  final database = ref.watch(databaseProvider);
  return await database.getAllFoodItems();
});

// 期限切れ間近の食品プロバイダー
final expiringSoonProvider = FutureProvider<List<FoodItemTableData>>((ref) async {
  final database = ref.watch(databaseProvider);
  return await database.getExpiringSoon(7); // 7日以内
});

// 今日の食事プロバイダー
final todayMealsProvider = FutureProvider<List<MealTableData>>((ref) async {
  final database = ref.watch(databaseProvider);
  return await database.getMealsByDate(DateTime.now());
});

// 今日のパーソナルデータプロバイダー
final todayPersonalDataProvider = FutureProvider<PersonalDataTableData?>((ref) async {
  final database = ref.watch(databaseProvider);
  return await database.getPersonalDataByDate(DateTime.now());
});

// 体重履歴プロバイダー
final weightHistoryProvider = FutureProvider<List<double>>((ref) async {
  final database = ref.watch(databaseProvider);
  return await database.getWeightHistory(90); // 90日分
});

// お気に入りレシピプロバイダー
final favoriteRecipesProvider = FutureProvider<List<RecipeTableData>>((ref) async {
  final database = ref.watch(databaseProvider);
  return await database.getFavoriteRecipes();
});