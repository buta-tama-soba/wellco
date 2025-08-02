import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../models/meal_table.dart';
import '../models/personal_data_table.dart';
import '../models/food_item_table.dart';
import '../models/recipe_table.dart';

part 'app_database.g.dart';

/// アプリケーションデータベース
@DriftDatabase(tables: [
  MealTable,
  MealItemTable,
  ExternalRecipeTable,
  PersonalDataTable,
  FoodItemTable,
  RecipeTable,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  /// 今日の栄養データを取得
  Future<Map<String, double>> getTodayNutrition() async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    
    final meals = await (select(mealTable)
      ..where((tbl) => tbl.recordedAt.isBetweenValues(startOfDay, endOfDay)))
      .get();
    
    double totalCalories = 0.0;
    double totalProtein = 0.0;
    double totalFat = 0.0;
    double totalCarbs = 0.0;
    
    for (final meal in meals) {
      totalCalories += meal.totalCalories;
      totalProtein += meal.totalProtein;
      totalFat += meal.totalFat;
      totalCarbs += meal.totalCarbs;
    }
    
    return {
      'calories': totalCalories,
      'protein': totalProtein,
      'fat': totalFat,
      'carbs': totalCarbs,
    };
  }

  /// 食事を日付で取得
  Future<List<MealTableData>> getMealsByDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    
    return (select(mealTable)
      ..where((tbl) => tbl.recordedAt.isBetweenValues(startOfDay, endOfDay))
      ..orderBy([(tbl) => OrderingTerm(expression: tbl.recordedAt)]))
      .get();
  }

  /// 食事と食事項目を保存
  Future<int> insertMealWithItems(MealTableCompanion meal, List<MealItemTableCompanion> items) async {
    return transaction(() async {
      final mealId = await into(mealTable).insert(meal);
      
      // 各項目に食事IDを設定して保存
      for (final item in items) {
        await into(mealItemTable).insert(
          item.copyWith(mealId: Value(mealId))
        );
      }
      
      return mealId;
    });
  }

  /// 外部レシピを保存
  Future<int> insertExternalRecipe(ExternalRecipeTableCompanion recipe) async {
    return into(externalRecipeTable).insert(recipe);
  }

  /// お気に入りレシピを取得
  Future<List<ExternalRecipeTableData>> getFavoriteRecipes() async {
    return (select(externalRecipeTable)
      ..where((tbl) => tbl.isFavorite.equals(true))
      ..orderBy([(tbl) => OrderingTerm(expression: tbl.createdAt, mode: OrderingMode.desc)]))
      .get();
  }

  /// 最近のレシピを取得
  Future<List<ExternalRecipeTableData>> getRecentRecipes({int limit = 10}) async {
    return (select(externalRecipeTable)
      ..orderBy([(tbl) => OrderingTerm(expression: tbl.lastAccessedAt ?? tbl.createdAt, mode: OrderingMode.desc)])
      ..limit(limit))
      .get();
  }

  /// URLでレシピを検索
  Future<ExternalRecipeTableData?> getRecipeByUrl(String url) async {
    return (select(externalRecipeTable)
      ..where((tbl) => tbl.url.equals(url)))
      .getSingleOrNull();
  }

  /// お気に入り状態を切り替え
  Future<bool> toggleFavoriteRecipe(int recipeId) async {
    final recipe = await (select(externalRecipeTable)
      ..where((tbl) => tbl.id.equals(recipeId)))
      .getSingleOrNull();
    
    if (recipe == null) return false;
    
    final newFavoriteStatus = !recipe.isFavorite;
    
    await (update(externalRecipeTable)
      ..where((tbl) => tbl.id.equals(recipeId)))
      .write(ExternalRecipeTableCompanion(
        isFavorite: Value(newFavoriteStatus),
        updatedAt: Value(DateTime.now()),
      ));
    
    return newFavoriteStatus;
  }

  /// 外部レシピを更新
  Future<void> updateExternalRecipe({
    required int recipeId,
    required String title,
    String? tags,
    String? memo,
  }) async {
    await (update(externalRecipeTable)
      ..where((tbl) => tbl.id.equals(recipeId)))
      .write(ExternalRecipeTableCompanion(
        title: Value(title),
        tags: tags != null ? Value(tags) : const Value.absent(),
        memo: memo != null ? Value(memo) : const Value.absent(),
        updatedAt: Value(DateTime.now()),
      ));
  }

  /// 外部レシピを削除
  Future<void> deleteExternalRecipe(int recipeId) async {
    await (delete(externalRecipeTable)
      ..where((tbl) => tbl.id.equals(recipeId)))
      .go();
  }
}

/// データベース接続を開く
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'wellco.db'));
    return NativeDatabase(file);
  });
}