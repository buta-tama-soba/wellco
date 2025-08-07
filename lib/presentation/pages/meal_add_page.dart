import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:drift/drift.dart' hide Column;

import '../../core/themes/app_colors.dart';
import '../../core/themes/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../data/datasources/app_database.dart';
import '../providers/database_provider.dart';

/// 食事追加画面のタブ
enum MealAddTab {
  fromRecipe,  // 保存済みレシピから追加
  manual       // 手動追加
}

class MealAddPage extends HookConsumerWidget {
  const MealAddPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = useState(MealAddTab.fromRecipe);
    final selectedRecipe = useState<ExternalRecipeTableData?>(null);
    
    // 手動追加用
    final foodNameController = useTextEditingController();
    final quantityController = useTextEditingController();
    final unitController = useTextEditingController(text: 'g');
    final caloriesController = useTextEditingController();
    final proteinController = useTextEditingController();
    final fatController = useTextEditingController();
    final carbsController = useTextEditingController();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_rounded,
            color: AppColors.textPrimary,
            size: 24.w,
          ),
        ),
        title: Text(
          '食事を追加',
          style: AppTextStyles.headline2,
        ),
        actions: [
          TextButton(
            onPressed: () => _saveMeal(
              context, 
              ref,
              currentTab.value,
              selectedRecipe.value,
              foodNameController.text,
              quantityController.text,
              unitController.text,
              caloriesController.text,
              proteinController.text,
              fatController.text,
              carbsController.text,
            ),
            child: Text(
              '保存',
              style: AppTextStyles.body1.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // タブセレクター
          Container(
            margin: EdgeInsets.all(AppConstants.paddingM.w),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => currentTab.value = MealAddTab.fromRecipe,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      decoration: BoxDecoration(
                        color: currentTab.value == MealAddTab.fromRecipe 
                            ? AppColors.primary 
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
                      ),
                      child: Text(
                        'レシピから追加',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.body2.copyWith(
                          color: currentTab.value == MealAddTab.fromRecipe 
                              ? Colors.white 
                              : AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => currentTab.value = MealAddTab.manual,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      decoration: BoxDecoration(
                        color: currentTab.value == MealAddTab.manual 
                            ? AppColors.primary 
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
                      ),
                      child: Text(
                        '手動で追加',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.body2.copyWith(
                          color: currentTab.value == MealAddTab.manual 
                              ? Colors.white 
                              : AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          
          // タブ別コンテンツ
          Expanded(
            child: currentTab.value == MealAddTab.fromRecipe
                ? _buildFromRecipeTab(selectedRecipe)
                : _buildManualTab(
                    foodNameController,
                    quantityController,
                    unitController,
                    caloriesController,
                    proteinController,
                    fatController,
                    carbsController,
                  ),
          ),
        ],
      ),
    );
  }

  /// 保存済みレシピから追加タブ
  Widget _buildFromRecipeTab(
    ValueNotifier<ExternalRecipeTableData?> selectedRecipe,
  ) {
    return Column(
      children: [
        // レシピ選択リスト
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: AppConstants.paddingM.w),
            child: Consumer(
              builder: (context, ref, child) {
                final recipesAsync = ref.watch(recentRecipesProvider);
                
                return recipesAsync.when(
                  data: (recipes) {
                    if (recipes.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.restaurant_menu,
                              size: 64.w,
                              color: AppColors.textSecondary,
                            ),
                            SizedBox(height: AppConstants.paddingM.h),
                            Text(
                              '保存済みレシピがありません',
                              style: AppTextStyles.headline3.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            SizedBox(height: AppConstants.paddingS.h),
                            Text(
                              'レシピを登録してから追加してください',
                              style: AppTextStyles.body2.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    
                    return ListView.builder(
                      itemCount: recipes.length,
                      itemBuilder: (context, index) {
                        final recipe = recipes[index];
                        final isSelected = selectedRecipe.value?.id == recipe.id;
                        
                        return _buildRecipeSelectionItem(
                          recipe: recipe,
                          isSelected: isSelected,
                          onTap: () => selectedRecipe.value = recipe,
                        );
                      },
                    );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  error: (error, stack) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64.w,
                          color: AppColors.error,
                        ),
                        SizedBox(height: AppConstants.paddingM.h),
                        Text(
                          'エラーが発生しました',
                          style: AppTextStyles.headline3.copyWith(
                            color: AppColors.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  /// 手動追加タブ
  Widget _buildManualTab(
    TextEditingController foodNameController,
    TextEditingController quantityController,
    TextEditingController unitController,
    TextEditingController caloriesController,
    TextEditingController proteinController,
    TextEditingController fatController,
    TextEditingController carbsController,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: AppConstants.paddingM.w),
      child: Column(
        children: [
          _buildInputField(
            label: '食品名',
            controller: foodNameController,
            hintText: '例: ご飯、鶏胸肉、卵',
          ),
          SizedBox(height: AppConstants.paddingM.h),
          
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildInputField(
                  label: '分量',
                  controller: quantityController,
                  hintText: '100',
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(width: AppConstants.paddingM.w),
              Expanded(
                child: _buildInputField(
                  label: '単位',
                  controller: unitController,
                  hintText: 'g',
                ),
              ),
            ],
          ),
          SizedBox(height: AppConstants.paddingL.h),
          
          Text(
            '栄養情報',
            style: AppTextStyles.headline3,
          ),
          SizedBox(height: AppConstants.paddingM.h),
          
          _buildInputField(
            label: 'カロリー',
            controller: caloriesController,
            hintText: '0',
            keyboardType: TextInputType.number,
            suffix: Text('kcal', style: AppTextStyles.body2),
          ),
          SizedBox(height: AppConstants.paddingM.h),
          
          Row(
            children: [
              Expanded(
                child: _buildInputField(
                  label: 'タンパク質',
                  controller: proteinController,
                  hintText: '0',
                  keyboardType: TextInputType.number,
                  suffix: Text('g', style: AppTextStyles.body2),
                ),
              ),
              SizedBox(width: AppConstants.paddingM.w),
              Expanded(
                child: _buildInputField(
                  label: '脂質',
                  controller: fatController,
                  hintText: '0',
                  keyboardType: TextInputType.number,
                  suffix: Text('g', style: AppTextStyles.body2),
                ),
              ),
            ],
          ),
          SizedBox(height: AppConstants.paddingM.h),
          
          _buildInputField(
            label: '炭水化物',
            controller: carbsController,
            hintText: '0',
            keyboardType: TextInputType.number,
            suffix: Text('g', style: AppTextStyles.body2),
          ),
          SizedBox(height: AppConstants.paddingXL.h),
        ],
      ),
    );
  }

  /// 入力フィールド
  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    String? hintText,
    TextInputType? keyboardType,
    Widget? suffix,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.body2.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: AppConstants.paddingS.h),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hintText,
            suffixIcon: suffix != null ? Padding(
              padding: EdgeInsets.only(right: AppConstants.paddingM.w),
              child: suffix,
            ) : null,
            suffixIconConstraints: const BoxConstraints(),
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppConstants.paddingM.w,
              vertical: 12.h,
            ),
          ),
        ),
      ],
    );
  }

  /// レシピ選択アイテム
  Widget _buildRecipeSelectionItem({
    required ExternalRecipeTableData recipe,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: AppConstants.paddingM.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusL.r),
        border: isSelected 
            ? Border.all(color: AppColors.primary, width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppConstants.radiusL.r),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(AppConstants.paddingM.w),
            child: Row(
              children: [
                // サムネイル
                Container(
                  width: 60.w,
                  height: 60.w,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
                    child: recipe.imageUrl != null
                        ? CachedNetworkImage(
                            imageUrl: recipe.imageUrl!,
                            width: 60.w,
                            height: 60.w,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: AppColors.primary.withOpacity(0.1),
                              child: Icon(
                                Icons.restaurant,
                                color: AppColors.primary,
                                size: 24.w,
                              ),
                            ),
                            errorWidget: (context, url, error) => Icon(
                              Icons.restaurant,
                              color: AppColors.primary,
                              size: 24.w,
                            ),
                          )
                        : Icon(
                            Icons.restaurant,
                            color: AppColors.primary,
                            size: 24.w,
                          ),
                  ),
                ),
                SizedBox(width: AppConstants.paddingM.w),
                
                // 内容
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recipe.title,
                        style: AppTextStyles.headline3,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (recipe.siteName != null) ...[
                        SizedBox(height: 4.h),
                        Text(
                          recipe.siteName!,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                      if (recipe.calories != null) ...[
                        SizedBox(height: 4.h),
                        Text(
                          '${recipe.calories!.toInt()} kcal / 1人前',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                
                // 選択インジケータ
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: AppColors.primary,
                    size: 24.w,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 食事を保存
  void _saveMeal(
    BuildContext context,
    WidgetRef ref,
    MealAddTab tabType,
    ExternalRecipeTableData? selectedRecipe,
    String foodName,
    String quantityText,
    String unit,
    String caloriesText,
    String proteinText,
    String fatText,
    String carbsText,
  ) async {
    if (tabType == MealAddTab.fromRecipe) {
      if (selectedRecipe == null) {
        _showErrorSnackBar(context, 'レシピを選択してください');
        return;
      }
      
      await _saveMealFromRecipe(context, ref, selectedRecipe);
    } else {
      if (foodName.trim().isEmpty) {
        _showErrorSnackBar(context, '食品名を入力してください');
        return;
      }
      
      final quantity = double.tryParse(quantityText);
      if (quantity == null || quantity <= 0) {
        _showErrorSnackBar(context, '正しい分量を入力してください');
        return;
      }
      
      await _saveManualMeal(
        context, ref, foodName, quantity, unit,
        caloriesText, proteinText, fatText, carbsText,
      );
    }
  }

  /// レシピから食事を保存
  Future<void> _saveMealFromRecipe(
    BuildContext context,
    WidgetRef ref,
    ExternalRecipeTableData recipe,
  ) async {
    try {
      final database = ref.read(databaseProvider);
      
      // 栄養情報（1人前として保存）
      final calories = recipe.calories ?? 0;
      final protein = recipe.protein ?? 0;
      final fat = recipe.fat ?? 0;
      final carbs = recipe.carbohydrate ?? 0;
      
      // 食事記録を作成
      final meal = MealTableCompanion.insert(
        recordedAt: DateTime.now(),
        mealType: '食事',
        totalCalories: Value(calories),
        totalProtein: Value(protein),
        totalFat: Value(fat),
        totalCarbs: Value(carbs),
      );
      
      // 食事項目を作成
      final mealItem = MealItemTableCompanion.insert(
        mealId: 0, // insertMealWithItemsで自動設定される
        foodName: recipe.title,
        quantity: const Value(1.0),
        unit: const Value('人前'),
        calories: Value(calories),
        protein: Value(protein),
        fat: Value(fat),
        carbs: Value(carbs),
        externalRecipeId: Value(recipe.id),
      );
      
      // 保存
      await database.insertMealWithItems(meal, [mealItem]);
      
      // プロバイダーを更新
      ref.invalidate(todayMealsProvider);
      ref.invalidate(todayNutritionProvider);
      
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('食事を追加しました')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        _showErrorSnackBar(context, '保存に失敗しました: $e');
      }
    }
  }

  /// 手動で食事を保存
  Future<void> _saveManualMeal(
    BuildContext context,
    WidgetRef ref,
    String foodName,
    double quantity,
    String unit,
    String caloriesText,
    String proteinText,
    String fatText,
    String carbsText,
  ) async {
    try {
      final database = ref.read(databaseProvider);
      
      final calories = double.tryParse(caloriesText) ?? 0;
      final protein = double.tryParse(proteinText) ?? 0;
      final fat = double.tryParse(fatText) ?? 0;
      final carbs = double.tryParse(carbsText) ?? 0;
      
      // 食事記録を作成
      final meal = MealTableCompanion.insert(
        recordedAt: DateTime.now(),
        mealType: '食事',
        totalCalories: Value(calories),
        totalProtein: Value(protein),
        totalFat: Value(fat),
        totalCarbs: Value(carbs),
      );
      
      // 食事項目を作成
      final mealItem = MealItemTableCompanion.insert(
        mealId: 0, // insertMealWithItemsで自動設定される
        foodName: foodName,
        quantity: Value(quantity),
        unit: Value(unit),
        calories: Value(calories),
        protein: Value(protein),
        fat: Value(fat),
        carbs: Value(carbs),
      );
      
      // 保存
      await database.insertMealWithItems(meal, [mealItem]);
      
      // プロバイダーを更新
      ref.invalidate(todayMealsProvider);
      ref.invalidate(todayNutritionProvider);
      
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('食事を追加しました')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        _showErrorSnackBar(context, '保存に失敗しました: $e');
      }
    }
  }

  /// エラースナックバーを表示
  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
      ),
    );
  }
}