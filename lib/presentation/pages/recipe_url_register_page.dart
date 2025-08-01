import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../core/themes/app_colors.dart';
import '../../core/themes/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/services/ogp_fetcher_service.dart';
import '../../core/services/recipe_nutrition_analysis_service.dart';
import '../providers/database_provider.dart';
import 'recipe_viewer_page.dart';

/// レシピURL登録ページ
class RecipeUrlRegisterPage extends ConsumerStatefulWidget {
  const RecipeUrlRegisterPage({super.key});

  @override
  ConsumerState<RecipeUrlRegisterPage> createState() => _RecipeUrlRegisterPageState();
}

class _RecipeUrlRegisterPageState extends ConsumerState<RecipeUrlRegisterPage> {
  final _urlController = TextEditingController();
  final _tagsController = TextEditingController();
  final _memoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  final _ogpFetcher = OgpFetcherService();
  late final RecipeNutritionAnalysisService _nutritionService;
  
  bool _isLoading = false;
  OgpData? _ogpData;
  RecipeNutritionResult? _nutritionResult;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // データベースを取得してから栄養分析サービスを初期化
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final database = ref.read(databaseProvider);
      _nutritionService = RecipeNutritionAnalysisService(database);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'レシピURL登録',
          style: AppTextStyles.headline2,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppConstants.paddingM.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // URL入力フィールド
                _buildUrlField(),
                SizedBox(height: AppConstants.paddingM.h),
                
                // OGPプレビュー
                if (_ogpData != null) ...[
                  _buildOgpPreview(),
                  SizedBox(height: AppConstants.paddingL.h),
                ],
                
                // 栄養情報プレビュー
                if (_nutritionResult != null) ...[
                  _buildNutritionPreview(),
                  SizedBox(height: AppConstants.paddingL.h),
                ],
                
                // エラーメッセージ
                if (_errorMessage != null) ...[
                  _buildErrorMessage(),
                  SizedBox(height: AppConstants.paddingM.h),
                ],
                
                // タグ入力
                _buildTagsField(),
                SizedBox(height: AppConstants.paddingM.h),
                
                // メモ入力
                _buildMemoField(),
                SizedBox(height: AppConstants.paddingL.h),
                
                // 保存ボタン
                _buildSaveButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUrlField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'レシピURL',
          style: AppTextStyles.headline3,
        ),
        SizedBox(height: AppConstants.paddingS.h),
        TextFormField(
          controller: _urlController,
          decoration: InputDecoration(
            hintText: 'https://example.com/recipe',
            prefixIcon: Icon(Icons.link, size: 20.w),
            suffixIcon: _isLoading
                ? Padding(
                    padding: EdgeInsets.all(12.w),
                    child: SizedBox(
                      width: 20.w,
                      height: 20.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.w,
                        valueColor: AlwaysStoppedAnimation(AppColors.primary),
                      ),
                    ),
                  )
                : IconButton(
                    icon: Icon(Icons.search, size: 24.w),
                    onPressed: _fetchOgpData,
                  ),
          ),
          keyboardType: TextInputType.url,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'URLを入力してください';
            }
            if (!Uri.tryParse(value)!.hasScheme) {
              return '有効なURLを入力してください';
            }
            return null;
          },
          onFieldSubmitted: (_) => _fetchOgpData(),
        ),
      ],
    );
  }

  Widget _buildOgpPreview() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusL.r),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppConstants.radiusL.r),
          onTap: () {
            // プレビューでWebViewを開く
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecipeViewerPage(
                  url: _urlController.text,
                  title: _ogpData?.title,
                ),
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.all(AppConstants.paddingM.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // サイト名
                if (_ogpData!.siteName != null)
                  Text(
                    _ogpData!.siteName!,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                
                // タイトル
                if (_ogpData!.title != null) ...[
                  SizedBox(height: 4.h),
                  Text(
                    _ogpData!.title!,
                    style: AppTextStyles.headline3,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                
                // 説明
                if (_ogpData!.description != null) ...[
                  SizedBox(height: 8.h),
                  Text(
                    _ogpData!.description!,
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                
                // 画像
                if (_ogpData!.imageUrl != null) ...[
                  SizedBox(height: AppConstants.paddingM.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
                    child: CachedNetworkImage(
                      imageUrl: _ogpData!.imageUrl!,
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
        ),
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      padding: EdgeInsets.all(AppConstants.paddingM.w),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
        border: Border.all(
          color: AppColors.error.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            size: 20.w,
            color: AppColors.error,
          ),
          SizedBox(width: AppConstants.paddingS.w),
          Expanded(
            child: Text(
              _errorMessage!,
              style: AppTextStyles.body2.copyWith(
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
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

  Widget _buildSaveButton() {
    final saveState = ref.watch(recipeRegistrationProvider);
    
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: (_ogpData != null && !saveState.isLoading) ? _saveRecipe : null,
        icon: saveState.isLoading 
          ? SizedBox(
              width: 20.w,
              height: 20.w,
              child: CircularProgressIndicator(
                strokeWidth: 2.w,
                valueColor: const AlwaysStoppedAnimation(Colors.white),
              ),
            )
          : Icon(Icons.save, size: 20.w),
        label: saveState.isLoading 
          ? const Text('保存中...')
          : const Text('レシピを保存'),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16.h),
        ),
      ),
    );
  }

  Widget _buildNutritionPreview() {
    if (_nutritionResult == null) return const SizedBox.shrink();
    
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusL.r),
        border: Border.all(
          color: AppColors.success.withOpacity(0.3),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppConstants.paddingM.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.auto_awesome,
                  size: 20.w,
                  color: AppColors.success,
                ),
                SizedBox(width: 8.w),
                Text(
                  '栄養情報を自動分析しました',
                  style: AppTextStyles.headline3.copyWith(
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppConstants.paddingM.h),
            
            // 抽出された材料
            if (_nutritionResult!.ingredients.isNotEmpty) ...[
              Text(
                '抽出された材料 (${_nutritionResult!.ingredients.length}件)',
                style: AppTextStyles.body1.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: AppConstants.paddingS.h),
              ...(_nutritionResult!.ingredients.take(5).map((ingredient) => 
                Padding(
                  padding: EdgeInsets.only(bottom: 4.h),
                  child: Text(
                    '• ${ingredient.name}${ingredient.amount != null ? ' ${ingredient.amount}${ingredient.unit ?? ''}' : ''}',
                    style: AppTextStyles.body2,
                  ),
                )
              ).toList()),
              if (_nutritionResult!.ingredients.length > 5)
                Text(
                  '...他${_nutritionResult!.ingredients.length - 5}件',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              SizedBox(height: AppConstants.paddingM.h),
            ],
            
            // 栄養情報
            Container(
              padding: EdgeInsets.all(AppConstants.paddingS.w),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(AppConstants.radiusS.r),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildNutritionItem(
                      'エネルギー',
                      '${_nutritionResult!.nutrition.energy.toStringAsFixed(0)} kcal',
                      Icons.local_fire_department,
                      AppColors.error,
                    ),
                  ),
                  Expanded(
                    child: _buildNutritionItem(
                      'タンパク質',
                      '${_nutritionResult!.nutrition.protein.toStringAsFixed(1)} g',
                      Icons.fitness_center,
                      AppColors.primary,
                    ),
                  ),
                  Expanded(
                    child: _buildNutritionItem(
                      '脂質',
                      '${_nutritionResult!.nutrition.fat.toStringAsFixed(1)} g',
                      Icons.water_drop,
                      AppColors.warning,
                    ),
                  ),
                  Expanded(
                    child: _buildNutritionItem(
                      '炭水化物',
                      '${_nutritionResult!.nutrition.carbohydrate.toStringAsFixed(1)} g',
                      Icons.grain,
                      AppColors.success,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(
          icon,
          size: 20.w,
          color: color,
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 2.h),
        Text(
          value,
          style: AppTextStyles.body2.copyWith(
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Future<void> _fetchOgpData() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _ogpData = null;
    });
    
    try {
      final ogpData = await _ogpFetcher.fetchOgpData(_urlController.text);
      
      // OGP取得後、レシピ本文があれば栄養分析を実行
      RecipeNutritionResult? nutritionResult;
      if (ogpData.recipeText != null && ogpData.recipeText!.isNotEmpty) {
        try {
          nutritionResult = await _nutritionService.analyzeRecipe(ogpData.recipeText!);
        } catch (e) {
          print('栄養分析エラー: $e');
        }
      }
      
      setState(() {
        _ogpData = ogpData;
        _nutritionResult = nutritionResult;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  Future<void> _saveRecipe() async {
    if (_ogpData == null) return;
    
    // データベースに保存
    final recipeNotifier = ref.read(recipeRegistrationProvider.notifier);
    
    // 栄養分析結果を含めて保存
    await recipeNotifier.saveExternalRecipeWithNutrition(
      url: _urlController.text,
      title: _ogpData!.title ?? 'タイトルなし',
      description: _ogpData!.description,
      imageUrl: _ogpData!.imageUrl,
      siteName: _ogpData!.siteName,
      tags: _tagsController.text.isNotEmpty ? _tagsController.text : null,
      memo: _memoController.text.isNotEmpty ? _memoController.text : null,
      recipeText: _ogpData!.recipeText,
      nutritionResult: _nutritionResult, // 栄養分析結果
    );
    
    // 保存状態を監視
    final saveState = ref.read(recipeRegistrationProvider);
    
    saveState.when(
      data: (_) {
        // 成功メッセージを表示
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('レシピを保存しました'),
            backgroundColor: AppColors.success,
          ),
        );
        
        // 画面を閉じる
        Navigator.pop(context);
      },
      loading: () {
        // ローディング中は何もしない（UIで表示）
      },
      error: (error, _) {
        // エラーメッセージを表示
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('保存に失敗しました: $error'),
            backgroundColor: AppColors.error,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _urlController.dispose();
    _tagsController.dispose();
    _memoController.dispose();
    super.dispose();
  }
}