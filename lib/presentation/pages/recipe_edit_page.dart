import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../core/themes/app_colors.dart';
import '../../core/themes/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../data/datasources/app_database.dart';
import '../../core/services/recipe_nutrition_analysis_service.dart';
import '../../core/services/ogp_fetcher_service.dart';
import '../../core/services/ingredient_extraction_service.dart';
import '../../data/models/japanese_food_composition_table.dart';
import '../providers/database_provider.dart';

/// 材料アイテム（UI用）
class IngredientItem {
  final String name;
  final double? amount;
  final String? unit;
  final String originalText;
  final bool isAnalyzed;
  final double? calories;
  final double? protein;
  final double? fat;
  final double? carbohydrate;

  IngredientItem({
    required this.name,
    this.amount,
    this.unit,
    required this.originalText,
    this.isAnalyzed = false,
    this.calories,
    this.protein,
    this.fat,
    this.carbohydrate,
  });

  IngredientItem copyWith({
    String? name,
    double? amount,
    String? unit,
    String? originalText,
    bool? isAnalyzed,
    double? calories,
    double? protein,
    double? fat,
    double? carbohydrate,
  }) {
    return IngredientItem(
      name: name ?? this.name,
      amount: amount ?? this.amount,
      unit: unit ?? this.unit,
      originalText: originalText ?? this.originalText,
      isAnalyzed: isAnalyzed ?? this.isAnalyzed,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      fat: fat ?? this.fat,
      carbohydrate: carbohydrate ?? this.carbohydrate,
    );
  }
}

/// レシピ編集ページ
class RecipeEditPage extends ConsumerStatefulWidget {
  final ExternalRecipeTableData recipe;

  const RecipeEditPage({
    super.key,
    required this.recipe,
  });

  @override
  ConsumerState<RecipeEditPage> createState() => _RecipeEditPageState();
}

class _RecipeEditPageState extends ConsumerState<RecipeEditPage> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _titleController;
  late TextEditingController _tagsController;
  late TextEditingController _memoController;
  late TextEditingController _recipeTextController;
  late TextEditingController _caloriesController;
  late TextEditingController _proteinController;
  late TextEditingController _fatController;
  late TextEditingController _carbohydrateController;
  late TextEditingController _saltController;
  late TextEditingController _fiberController;
  late TextEditingController _vitaminCController;
  
  List<IngredientItem> _ingredientsList = [];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.recipe.title);
    _tagsController = TextEditingController(text: widget.recipe.tags ?? '');
    _memoController = TextEditingController(text: widget.recipe.memo ?? '');
    _recipeTextController = TextEditingController(text: widget.recipe.ingredientsRawText ?? '');
    _caloriesController = TextEditingController(text: widget.recipe.calories?.toStringAsFixed(0) ?? '');
    _proteinController = TextEditingController(text: widget.recipe.protein?.toStringAsFixed(1) ?? '');
    _fatController = TextEditingController(text: widget.recipe.fat?.toStringAsFixed(1) ?? '');
    _carbohydrateController = TextEditingController(text: widget.recipe.carbohydrate?.toStringAsFixed(1) ?? '');
    _saltController = TextEditingController(text: widget.recipe.salt?.toStringAsFixed(2) ?? '');
    _fiberController = TextEditingController(text: widget.recipe.fiber?.toStringAsFixed(1) ?? '');
    _vitaminCController = TextEditingController(text: widget.recipe.vitaminC?.toStringAsFixed(0) ?? '');
    
    // 初期材料リストを構築
    _initializeIngredientsList();
  }
  
  void _initializeIngredientsList() {
    // 保存されている材料JSONから復元
    if (widget.recipe.ingredientsJson != null && widget.recipe.ingredientsJson!.isNotEmpty) {
      _ingredientsList = _ingredientsListFromJson(widget.recipe.ingredientsJson);
    } else {
      // 空のリストから開始
      _ingredientsList = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'レシピ編集',
          style: AppTextStyles.headline2,
        ),
        actions: [
          // 削除ボタン
          Consumer(
            builder: (context, ref, child) {
              final saveState = ref.watch(recipeRegistrationProvider);
              
              return saveState.isLoading
                  ? const SizedBox.shrink()
                  : TextButton(
                      onPressed: _showDeleteConfirmation,
                      child: Text(
                        '削除',
                        style: AppTextStyles.body1.copyWith(
                          color: AppColors.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
            },
          ),
          // 保存ボタン
          Consumer(
            builder: (context, ref, child) {
              final saveState = ref.watch(recipeRegistrationProvider);
              
              return saveState.isLoading
                  ? Padding(
                      padding: EdgeInsets.all(16.w),
                      child: SizedBox(
                        width: 20.w,
                        height: 20.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.w,
                          valueColor: AlwaysStoppedAnimation(AppColors.primary),
                        ),
                      ),
                    )
                  : TextButton(
                      onPressed: _saveChanges,
                      child: Text(
                        '保存',
                        style: AppTextStyles.body1.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppConstants.paddingM.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // URL表示（編集不可）
                _buildUrlSection(),
                SizedBox(height: AppConstants.paddingL.h),
                
                // レシピプレビュー
                _buildRecipePreview(),
                SizedBox(height: AppConstants.paddingL.h),
                
                // タイトル入力
                _buildTitleField(),
                SizedBox(height: AppConstants.paddingM.h),
                
                // タグ入力（一時的に非表示）
                // _buildTagsField(),
                // SizedBox(height: AppConstants.paddingM.h),
                
                // メモ入力
                _buildMemoField(),
                SizedBox(height: AppConstants.paddingL.h),
                
                // レシピ本文表示
                _buildRecipeTextField(),
                SizedBox(height: AppConstants.paddingL.h),
                
                // 材料リスト
                _buildIngredientsListSection(),
                SizedBox(height: AppConstants.paddingL.h),
                
                // 栄養情報入力セクション
                _buildNutritionInputSection(),
                SizedBox(height: AppConstants.paddingL.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUrlSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'レシピURL',
          style: AppTextStyles.headline3,
        ),
        SizedBox(height: AppConstants.paddingS.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(AppConstants.paddingM.w),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
            border: Border.all(color: AppColors.primary.withOpacity(0.2)),
          ),
          child: Text(
            widget.recipe.url,
            style: AppTextStyles.body2.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecipePreview() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusL.r),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppConstants.paddingM.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // サイト名
            if (widget.recipe.siteName != null)
              Text(
                widget.recipe.siteName!,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primary,
                ),
              ),
            
            // 現在のタイトル表示
            if (widget.recipe.title.isNotEmpty) ...[
              SizedBox(height: 4.h),
              Text(
                widget.recipe.title,
                style: AppTextStyles.headline3,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            
            // 説明
            if (widget.recipe.description != null) ...[
              SizedBox(height: 8.h),
              Text(
                widget.recipe.description!,
                style: AppTextStyles.body2.copyWith(
                  color: AppColors.textSecondary,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            
            // 画像
            if (widget.recipe.imageUrl != null) ...[
              SizedBox(height: AppConstants.paddingM.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
                child: CachedNetworkImage(
                  imageUrl: widget.recipe.imageUrl!,
                  width: double.infinity,
                  height: 180.h,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: AppColors.surface,
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2.w,
                        valueColor: AlwaysStoppedAnimation(AppColors.primary),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: AppColors.surface,
                    child: Icon(
                      Icons.image_not_supported,
                      size: 48.w,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTitleField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'タイトル',
          style: AppTextStyles.headline3,
        ),
        SizedBox(height: AppConstants.paddingS.h),
        TextFormField(
          controller: _titleController,
          decoration: InputDecoration(
            hintText: 'レシピのタイトル',
            prefixIcon: Icon(Icons.title, size: 20.w),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'タイトルを入力してください';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildTagsField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'タグ（カンマ区切り）',
          style: AppTextStyles.headline3,
        ),
        SizedBox(height: AppConstants.paddingS.h),
        TextFormField(
          controller: _tagsController,
          decoration: InputDecoration(
            hintText: '和食, 簡単, 15分',
            prefixIcon: Icon(Icons.tag, size: 20.w),
          ),
        ),
      ],
    );
  }

  Widget _buildMemoField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'メモ',
          style: AppTextStyles.headline3,
        ),
        SizedBox(height: AppConstants.paddingS.h),
        TextFormField(
          controller: _memoController,
          decoration: InputDecoration(
            hintText: 'このレシピのポイントなど',
            prefixIcon: Icon(Icons.note, size: 20.w),
          ),
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildRecipeTextField() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusL.r),
        border: Border.all(color: AppColors.textDisabled),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ヘッダー部分
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppConstants.paddingM.w,
              AppConstants.paddingM.h,
              AppConstants.paddingS.w,
              AppConstants.paddingS.h,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'レシピ本文',
                  style: AppTextStyles.headline3,
                ),
                // URLから再取得ボタン（右端に配置）
                ElevatedButton.icon(
                  onPressed: _reanalyzeFromUrl,
                  icon: Icon(Icons.refresh, size: 16.w),
                  label: const Text('再取得'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: AppConstants.paddingS.w,
                      vertical: AppConstants.paddingS.h,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // テキストフィールド
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppConstants.paddingM.w,
              0,
              AppConstants.paddingM.w,
              AppConstants.paddingM.h,
            ),
            child: TextFormField(
              controller: _recipeTextController,
              decoration: InputDecoration(
                hintText: 'レシピの材料や作り方など',
                prefixIcon: Icon(Icons.description, size: 20.w),
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientsListSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '材料リスト',
              style: AppTextStyles.headline3,
            ),
            Spacer(),
            TextButton.icon(
              onPressed: _analyzeIngredientsFromText,
              icon: Icon(Icons.analytics, size: 16.w),
              label: const Text('分析'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.secondary,
              ),
            ),
            TextButton.icon(
              onPressed: _addIngredientManually,
              icon: Icon(Icons.add, size: 18.w),
              label: const Text('追加'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
              ),
            ),
          ],
        ),
        SizedBox(height: AppConstants.paddingS.h),
        
        if (_ingredientsList.isEmpty) ...[
          Container(
            padding: EdgeInsets.all(AppConstants.paddingL.w),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
              border: Border.all(color: AppColors.textDisabled),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.shopping_basket_outlined,
                  size: 48.w,
                  color: AppColors.textSecondary,
                ),
                SizedBox(height: AppConstants.paddingS.h),
                Text(
                  '材料が登録されていません',
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: AppConstants.paddingS.h),
                Text(
                  'レシピ本文から材料を分析するか、手動で追加してください',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ] else ...[
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _ingredientsList.length,
            separatorBuilder: (context, index) => SizedBox(height: AppConstants.paddingS.h),
            itemBuilder: (context, index) {
              return _buildIngredientCard(_ingredientsList[index], index);
            },
          ),
        ],
        
      ],
    );
  }

  Widget _buildIngredientCard(IngredientItem ingredient, int index) {
    return Container(
      padding: EdgeInsets.all(AppConstants.paddingM.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
        border: Border.all(
          color: ingredient.isAnalyzed 
              ? AppColors.success.withOpacity(0.3)
              : AppColors.textDisabled,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ingredient.name,
                      style: AppTextStyles.body1.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (ingredient.amount != null) ...[
                      SizedBox(height: 2.h),
                      Text(
                        '${ingredient.amount}${ingredient.unit ?? ''}',
                        style: AppTextStyles.body2.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Row(
                children: [
                  if (ingredient.isAnalyzed)
                    Icon(
                      Icons.check_circle,
                      size: 20.w,
                      color: AppColors.success,
                    )
                  else
                    Icon(
                      Icons.help_outline,
                      size: 20.w,
                      color: AppColors.warning,
                    ),
                  SizedBox(width: AppConstants.paddingS.w),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        _editIngredient(index);
                      } else if (value == 'delete') {
                        _deleteIngredient(index);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text('編集'),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('削除'),
                      ),
                    ],
                    child: Icon(
                      Icons.more_vert,
                      size: 20.w,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          if (ingredient.isAnalyzed) ...[
            SizedBox(height: AppConstants.paddingS.h),
            Container(
              padding: EdgeInsets.all(AppConstants.paddingS.w),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppConstants.radiusS.r),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildNutritionValue(
                      '${(ingredient.calories ?? 0).toStringAsFixed(0)} kcal',
                      Icons.local_fire_department,
                      AppColors.error,
                    ),
                  ),
                  Expanded(
                    child: _buildNutritionValue(
                      '${(ingredient.protein ?? 0).toStringAsFixed(1)}g',
                      Icons.fitness_center,
                      AppColors.primary,
                    ),
                  ),
                  Expanded(
                    child: _buildNutritionValue(
                      '${(ingredient.fat ?? 0).toStringAsFixed(1)}g',
                      Icons.water_drop,
                      AppColors.warning,
                    ),
                  ),
                  Expanded(
                    child: _buildNutritionValue(
                      '${(ingredient.carbohydrate ?? 0).toStringAsFixed(1)}g',
                      Icons.grain,
                      AppColors.success,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNutritionValue(String value, IconData icon, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16.w,
          color: color,
        ),
        SizedBox(width: 4.w),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildNutritionInputSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '栄養情報（1人前あたり）',
          style: AppTextStyles.headline3,
        ),
        SizedBox(height: AppConstants.paddingS.h),
        
        // 基本栄養素入力
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _caloriesController,
                decoration: InputDecoration(
                  labelText: 'エネルギー',
                  hintText: '200',
                  suffixText: 'kcal',
                  prefixIcon: Icon(Icons.local_fire_department, size: 20.w),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(width: AppConstants.paddingS.w),
            Expanded(
              child: TextFormField(
                controller: _proteinController,
                decoration: InputDecoration(
                  labelText: 'タンパク質',
                  hintText: '15.5',
                  suffixText: 'g',
                  prefixIcon: Icon(Icons.fitness_center, size: 20.w),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
            ),
          ],
        ),
        SizedBox(height: AppConstants.paddingM.h),
        
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _fatController,
                decoration: InputDecoration(
                  labelText: '脂質',
                  hintText: '8.2',
                  suffixText: 'g',
                  prefixIcon: Icon(Icons.water_drop, size: 20.w),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
            ),
            SizedBox(width: AppConstants.paddingS.w),
            Expanded(
              child: TextFormField(
                controller: _carbohydrateController,
                decoration: InputDecoration(
                  labelText: '炭水化物',
                  hintText: '25.3',
                  suffixText: 'g',
                  prefixIcon: Icon(Icons.grain, size: 20.w),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
            ),
          ],
        ),
        SizedBox(height: AppConstants.paddingM.h),
        
        // その他の栄養素入力
        ExpansionTile(
          title: Text(
            'その他の栄養素',
            style: AppTextStyles.body1,
          ),
          children: [
            Padding(
              padding: EdgeInsets.all(AppConstants.paddingS.w),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _saltController,
                          decoration: InputDecoration(
                            labelText: '食塩相当量',
                            hintText: '1.2',
                            suffixText: 'g',
                            prefixIcon: Icon(Icons.grain, size: 20.w),
                          ),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        ),
                      ),
                      SizedBox(width: AppConstants.paddingS.w),
                      Expanded(
                        child: TextFormField(
                          controller: _fiberController,
                          decoration: InputDecoration(
                            labelText: '食物繊維',
                            hintText: '2.1',
                            suffixText: 'g',
                            prefixIcon: Icon(Icons.eco, size: 20.w),
                          ),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppConstants.paddingM.h),
                  TextFormField(
                    controller: _vitaminCController,
                    decoration: InputDecoration(
                      labelText: 'ビタミンC',
                      hintText: '15',
                      suffixText: 'mg',
                      prefixIcon: Icon(Icons.local_hospital, size: 20.w),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
          ],
        ),
        
        // 自動抽出フラグの表示
        if (widget.recipe.isNutritionAutoExtracted == true) ...[
          SizedBox(height: AppConstants.paddingS.h),
          Row(
            children: [
              Icon(
                Icons.auto_awesome,
                size: 16.w,
                color: AppColors.primary,
              ),
              SizedBox(width: 4.w),
              Text(
                '自動分析済み（手動で編集可能）',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildNutritionCards() {
    return Container(
      padding: EdgeInsets.all(AppConstants.paddingM.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
        border: Border.all(color: AppColors.textDisabled),
      ),
      child: Column(
        children: [
          // 基本栄養素
          Row(
            children: [
              Expanded(
                child: _buildNutritionItem(
                  'エネルギー',
                  '${(widget.recipe.calories ?? 0).toStringAsFixed(0)} kcal',
                  Icons.local_fire_department,
                  AppColors.error,
                ),
              ),
              SizedBox(width: AppConstants.paddingS.w),
              Expanded(
                child: _buildNutritionItem(
                  'タンパク質',
                  '${(widget.recipe.protein ?? 0).toStringAsFixed(1)} g',
                  Icons.fitness_center,
                  AppColors.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: AppConstants.paddingS.h),
          Row(
            children: [
              Expanded(
                child: _buildNutritionItem(
                  '脂質',
                  '${(widget.recipe.fat ?? 0).toStringAsFixed(1)} g',
                  Icons.water_drop,
                  AppColors.warning,
                ),
              ),
              SizedBox(width: AppConstants.paddingS.w),
              Expanded(
                child: _buildNutritionItem(
                  '炭水化物',
                  '${(widget.recipe.carbohydrate ?? 0).toStringAsFixed(1)} g',
                  Icons.grain,
                  AppColors.success,
                ),
              ),
            ],
          ),
          
          
          // 人前あたりの表示
          SizedBox(height: AppConstants.paddingS.h),
          Text(
            '1人前あたりの栄養価',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          if (false && (widget.recipe.servings ?? 1) > 1) ...[
            SizedBox(height: AppConstants.paddingS.h),
            Text(
              '${widget.recipe.servings}人前の栄養価',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNutritionItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(
          icon,
          size: 24.w,
          color: color,
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          value,
          style: AppTextStyles.body1.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  /// 材料を手動で追加
  void _addIngredientManually() {
    showDialog(
      context: context,
      builder: (context) => _buildAddIngredientDialog(),
    );
  }

  /// 材料を編集
  void _editIngredient(int index) {
    showDialog(
      context: context,
      builder: (context) => _buildEditIngredientDialog(_ingredientsList[index], index),
    );
  }

  /// 材料を削除
  void _deleteIngredient(int index) {
    setState(() {
      _ingredientsList.removeAt(index);
    });
  }

  /// レシピ本文から材料を分析
  Future<void> _analyzeIngredientsFromText() async {
    final recipeText = _recipeTextController.text.trim();
    
    if (recipeText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('レシピ本文を入力してください'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(AppColors.primary),
            ),
            SizedBox(height: AppConstants.paddingM.h),
            Text(
              '材料を分析中...',
              style: AppTextStyles.body2,
            ),
          ],
        ),
      ),
    );

    try {
      final database = ref.read(databaseProvider);
      final nutritionService = RecipeNutritionAnalysisService(database);
      final result = await nutritionService.analyzeRecipe(recipeText);
      
      setState(() {
        _ingredientsList = result.matchResults.map((matchResult) => IngredientItem(
          name: matchResult.ingredient.name,
          amount: matchResult.ingredient.amount,
          unit: matchResult.ingredient.unit,
          originalText: matchResult.ingredient.originalText,
          isAnalyzed: matchResult.matchedFood != null,
          calories: matchResult.matchedFood != null 
              ? _calculateIndividualNutrition(matchResult.ingredient, matchResult.matchedFood!, 'calories')
              : null,
          protein: matchResult.matchedFood != null 
              ? _calculateIndividualNutrition(matchResult.ingredient, matchResult.matchedFood!, 'protein')
              : null,
          fat: matchResult.matchedFood != null 
              ? _calculateIndividualNutrition(matchResult.ingredient, matchResult.matchedFood!, 'fat')
              : null,
          carbohydrate: matchResult.matchedFood != null 
              ? _calculateIndividualNutrition(matchResult.ingredient, matchResult.matchedFood!, 'carbohydrate')
              : null,
        )).toList();
      });

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${result.ingredients.length}件の材料を抽出しました'),
          backgroundColor: AppColors.success,
        ),
      );
    } catch (e) {
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('材料の分析に失敗しました: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  /// 材料追加ダイアログ
  Widget _buildAddIngredientDialog() {
    final nameController = TextEditingController();
    final amountController = TextEditingController();
    final unitController = TextEditingController();

    return AlertDialog(
      backgroundColor: AppColors.surface,
      title: Text('材料を追加', style: AppTextStyles.headline3),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: '材料名',
              hintText: 'にんじん',
            ),
          ),
          SizedBox(height: AppConstants.paddingM.h),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: amountController,
                  decoration: const InputDecoration(
                    labelText: '分量',
                    hintText: '100',
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              SizedBox(width: AppConstants.paddingS.w),
              Expanded(
                child: TextFormField(
                  controller: unitController,
                  decoration: const InputDecoration(
                    labelText: '単位',
                    hintText: 'g',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('キャンセル', style: AppTextStyles.body2),
        ),
        ElevatedButton(
          onPressed: () {
            if (nameController.text.isNotEmpty) {
              final newIngredient = IngredientItem(
                name: nameController.text.trim(),
                amount: double.tryParse(amountController.text),
                unit: unitController.text.isNotEmpty ? unitController.text.trim() : null,
                originalText: '${nameController.text} ${amountController.text} ${unitController.text}',
                isAnalyzed: false,
              );
              
              setState(() {
                _ingredientsList.add(newIngredient);
              });
              
              Navigator.pop(context);
            }
          },
          child: const Text('追加'),
        ),
      ],
    );
  }

  /// 材料編集ダイアログ
  Widget _buildEditIngredientDialog(IngredientItem ingredient, int index) {
    final nameController = TextEditingController(text: ingredient.name);
    final amountController = TextEditingController(text: ingredient.amount?.toString() ?? '');
    final unitController = TextEditingController(text: ingredient.unit ?? '');

    return AlertDialog(
      backgroundColor: AppColors.surface,
      title: Text('材料を編集', style: AppTextStyles.headline3),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: '材料名',
            ),
          ),
          SizedBox(height: AppConstants.paddingM.h),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: amountController,
                  decoration: const InputDecoration(
                    labelText: '分量',
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              SizedBox(width: AppConstants.paddingS.w),
              Expanded(
                child: TextFormField(
                  controller: unitController,
                  decoration: const InputDecoration(
                    labelText: '単位',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('キャンセル', style: AppTextStyles.body2),
        ),
        ElevatedButton(
          onPressed: () {
            if (nameController.text.isNotEmpty) {
              final updatedIngredient = ingredient.copyWith(
                name: nameController.text.trim(),
                amount: double.tryParse(amountController.text),
                unit: unitController.text.isNotEmpty ? unitController.text.trim() : null,
                originalText: '${nameController.text} ${amountController.text} ${unitController.text}',
              );
              
              setState(() {
                _ingredientsList[index] = updatedIngredient;
              });
              
              Navigator.pop(context);
            }
          },
          child: const Text('保存'),
        ),
      ],
    );
  }

  /// URLから材料を再取得
  Future<void> _reanalyzeFromUrl() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(AppColors.primary),
            ),
            SizedBox(height: AppConstants.paddingM.h),
            Text(
              'レシピ情報を再取得中...',
              style: AppTextStyles.body2,
            ),
          ],
        ),
      ),
    );
    
    try {
      final ogpFetcher = OgpFetcherService();
      final ogpData = await ogpFetcher.fetchOgpData(widget.recipe.url);
      
      if (ogpData.recipeText != null && ogpData.recipeText!.isNotEmpty) {
        // レシピ本文を更新
        setState(() {
          _recipeTextController.text = ogpData.recipeText!;
        });
        
        // 材料を抽出
        final extractionService = IngredientExtractionService();
        final ingredients = extractionService.extractIngredients(ogpData.recipeText!);
        
        // 栄養分析も実行
        final database = ref.read(databaseProvider);
        final nutritionService = RecipeNutritionAnalysisService(database);
        final result = await nutritionService.analyzeRecipe(ogpData.recipeText!);
        
        // 材料リストと栄養情報を更新
        setState(() {
          _ingredientsList = ingredients.map((ingredient) => IngredientItem(
            name: ingredient.name,
            amount: ingredient.amount,
            unit: ingredient.unit,
            originalText: ingredient.originalText,
            isAnalyzed: false, // 個別分析はまだ未実装
          )).toList();
          
          _caloriesController.text = result.nutrition.energy.toStringAsFixed(0);
          _proteinController.text = result.nutrition.protein.toStringAsFixed(1);
          _fatController.text = result.nutrition.fat.toStringAsFixed(1);
          _carbohydrateController.text = result.nutrition.carbohydrate.toStringAsFixed(1);
          _saltController.text = result.nutrition.salt.toStringAsFixed(2);
          _fiberController.text = result.nutrition.fiber.toStringAsFixed(1);
          _vitaminCController.text = result.nutrition.vitaminC.toStringAsFixed(0);
        });
        
        Navigator.pop(context);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('レシピを再取得し、${ingredients.length}件の材料を抽出しました'),
            backgroundColor: AppColors.success,
          ),
        );
      } else {
        Navigator.pop(context);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('レシピ情報を取得できませんでした'),
            backgroundColor: AppColors.warning,
          ),
        );
      }
    } catch (e) {
      Navigator.pop(context);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('再取得に失敗しました: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  /// 入力された材料から栄養分析
  Future<void> _reanalyzeNutrition() async {
    final recipeText = _recipeTextController.text.trim();
        
    if (recipeText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('材料テキストが入力されていません'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    
    // 栄養再分析の処理
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(AppColors.primary),
            ),
            SizedBox(height: AppConstants.paddingM.h),
            Text(
              '栄養情報を分析中...',
              style: AppTextStyles.body2,
            ),
          ],
        ),
      ),
    );
    
    try {
      final database = ref.read(databaseProvider);
      final nutritionService = RecipeNutritionAnalysisService(database);
      final result = await nutritionService.analyzeRecipe(recipeText);
      
      // 栄養情報を入力フィールドに反映
      setState(() {
        _caloriesController.text = result.nutrition.energy.toStringAsFixed(0);
        _proteinController.text = result.nutrition.protein.toStringAsFixed(1);
        _fatController.text = result.nutrition.fat.toStringAsFixed(1);
        _carbohydrateController.text = result.nutrition.carbohydrate.toStringAsFixed(1);
        _saltController.text = result.nutrition.salt.toStringAsFixed(2);
        _fiberController.text = result.nutrition.fiber.toStringAsFixed(1);
        _vitaminCController.text = result.nutrition.vitaminC.toStringAsFixed(0);
      });
      
      Navigator.pop(context);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('栄養分析を完了しました（${result.ingredients.length}件の材料を抽出）'),
          backgroundColor: AppColors.success,
        ),
      );
    } catch (e) {
      Navigator.pop(context);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('栄養分析に失敗しました: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    final recipeNotifier = ref.read(recipeRegistrationProvider.notifier);
    
    // 材料リストをJSONに変換
    final ingredientsJson = _ingredientsListToJson();
    
    await recipeNotifier.updateExternalRecipe(
      recipeId: widget.recipe.id,
      title: _titleController.text,
      tags: _tagsController.text,
      memo: _memoController.text,
      ingredientsRawText: _recipeTextController.text,
      ingredientsJson: ingredientsJson,
      calories: double.tryParse(_caloriesController.text),
      protein: double.tryParse(_proteinController.text),
      fat: double.tryParse(_fatController.text),
      carbohydrate: double.tryParse(_carbohydrateController.text),
      salt: double.tryParse(_saltController.text),
      fiber: double.tryParse(_fiberController.text),
      vitaminC: double.tryParse(_vitaminCController.text),
    );
    
    // 保存状態を監視
    final saveState = ref.read(recipeRegistrationProvider);
    
    saveState.when(
      data: (_) {
        // 成功メッセージを表示
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('レシピを更新しました'),
            backgroundColor: AppColors.success,
          ),
        );
        
        // 画面を閉じる
        Navigator.pop(context);
      },
      loading: () {
        // ローディング中は何もしない（UIで表示済み）
      },
      error: (error, _) {
        // エラーメッセージを表示
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('更新に失敗しました: $error'),
            backgroundColor: AppColors.error,
          ),
        );
      },
    );
  }

  /// 材料リストをJSONに変換
  String _ingredientsListToJson() {
    final ingredientsList = _ingredientsList.map((ingredient) => {
      'name': ingredient.name,
      'amount': ingredient.amount,
      'unit': ingredient.unit,
      'originalText': ingredient.originalText,
      'isAnalyzed': ingredient.isAnalyzed,
      'calories': ingredient.calories,
      'protein': ingredient.protein,
      'fat': ingredient.fat,
      'carbohydrate': ingredient.carbohydrate,
    }).toList();
    
    return json.encode(ingredientsList);
  }

  /// JSONから材料リストを復元
  List<IngredientItem> _ingredientsListFromJson(String? jsonString) {
    if (jsonString == null || jsonString.isEmpty) return [];
    
    try {
      final jsonList = json.decode(jsonString) as List<dynamic>;
      return jsonList.map((item) => IngredientItem(
        name: item['name'] ?? '',
        amount: item['amount']?.toDouble(),
        unit: item['unit'],
        originalText: item['originalText'] ?? '',
        isAnalyzed: item['isAnalyzed'] ?? false,
        calories: item['calories']?.toDouble(),
        protein: item['protein']?.toDouble(),
        fat: item['fat']?.toDouble(),
        carbohydrate: item['carbohydrate']?.toDouble(),
      )).toList();
    } catch (e) {
      print('材料JSONの解析に失敗: $e');
      return [];
    }
  }

  Future<void> _showDeleteConfirmation() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          'レシピを削除',
          style: AppTextStyles.headline3,
        ),
        content: Text(
          'このレシピを削除しますか？\nこの操作は取り消せません。',
          style: AppTextStyles.body2,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'キャンセル',
              style: AppTextStyles.body2.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              '削除',
              style: AppTextStyles.body2.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (result == true) {
      await _deleteRecipe();
    }
  }

  Future<void> _deleteRecipe() async {
    final recipeNotifier = ref.read(recipeRegistrationProvider.notifier);
    
    await recipeNotifier.deleteExternalRecipe(widget.recipe.id);
    
    // 削除状態を監視
    final deleteState = ref.read(recipeRegistrationProvider);
    
    deleteState.when(
      data: (_) {
        // 成功メッセージを表示
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('レシピを削除しました'),
            backgroundColor: AppColors.success,
          ),
        );
        
        // 画面を閉じる
        Navigator.pop(context);
      },
      loading: () {
        // ローディング中は何もしない（UIで表示済み）
      },
      error: (error, _) {
        // エラーメッセージを表示
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('削除に失敗しました: $error'),
            backgroundColor: AppColors.error,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _tagsController.dispose();
    _memoController.dispose();
    _recipeTextController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _fatController.dispose();
    _carbohydrateController.dispose();
    _saltController.dispose();
    _fiberController.dispose();
    _vitaminCController.dispose();
    super.dispose();
  }

  /// 個別材料の栄養価を計算
  double? _calculateIndividualNutrition(Ingredient ingredient, JapaneseFoodCompositionTableData food, String nutrientType) {
    if (ingredient.amount == null) return null;
    
    // 重量をグラムに変換
    final grossWeight = _convertToGrams(ingredient.amount!, ingredient.unit);
    final edibleWeight = grossWeight * (1 - (food.refuse ?? 0) / 100);
    final multiplier = edibleWeight / 100; // 100gあたりの値から実際の量を計算
    
    switch (nutrientType) {
      case 'calories':
        return (food.enercKcal ?? 0) * multiplier;
      case 'protein':
        return (food.prot ?? 0) * multiplier;
      case 'fat':
        return (food.fat ?? 0) * multiplier;
      case 'carbohydrate':
        return (food.choavl ?? 0) * multiplier;
      default:
        return null;
    }
  }

  /// 単位変換
  double _convertToGrams(double amount, String? unit) {
    final normalizedUnit = (unit ?? '').toLowerCase();
    
    final conversionMap = {
      'g': 1.0,
      'kg': 1000.0,
      'ml': 1.0, // 液体は1ml=1gと仮定
      '個': 100.0, // 野菜1個の平均重量
      'コ': 100.0,
      '本': 50.0,  // 野菜1本の平均重量
      '枚': 100.0, // 肉1枚の平均重量
      '束': 100.0,
      '大さじ': 15.0,
      '小さじ': 5.0,
    };
    
    return amount * (conversionMap[normalizedUnit] ?? 1.0);
  }
}