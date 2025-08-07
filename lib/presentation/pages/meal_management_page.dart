import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../core/themes/app_colors.dart';
import '../../core/themes/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../data/datasources/app_database.dart';
import '../providers/database_provider.dart';
import 'recipe_url_register_page.dart';
import 'recipe_viewer_page.dart';
import 'recipe_edit_page.dart';

/// 食事管理画面の表示モード
enum MealManagementMode {
  kanban,    // カンバン表示
  recipeList // レシピ一覧表示
}

/// レシピフィルターモード
enum RecipeFilterMode {
  all,      // 全て
  favorite, // お気に入り
  recent    // 最近使った
}

class MealManagementPage extends HookConsumerWidget {
  const MealManagementPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // アニメーションコントローラー（速度を2倍に）
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 400),
    );
    
    // 表示モードの状態管理
    final currentMode = useState(MealManagementMode.kanban);
    
    // フィルターモードの状態管理
    final filterMode = useState(RecipeFilterMode.all);
    
    // 回転アニメーション
    final rotationAnimation = useAnimation(
      Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: animationController,
          curve: Curves.easeInOut,
        ),
      ),
    );

    // モード切り替え関数
    void toggleMode() async {
      if (currentMode.value == MealManagementMode.kanban) {
        // カンバン → レシピ一覧
        await animationController.animateTo(0.5);
        currentMode.value = MealManagementMode.recipeList;
        await animationController.animateTo(1.0);
        // レシピ一覧状態で停止（resetしない）
      } else {
        // レシピ一覧 → カンバン（逆回転）
        await animationController.animateTo(0.5);
        currentMode.value = MealManagementMode.kanban;
        await animationController.animateTo(0.0);
        // カンバン状態で停止
      }
    }
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001) // 透視効果
            ..rotateY(rotationAnimation * pi),
          child: AnimatedBuilder(
            animation: animationController,
            builder: (context, child) {
              // 現在のモードに基づいて表示内容を決定
              final normalizedAnimation = rotationAnimation % 1.0;
              final showBack = normalizedAnimation > 0.5;
              
              // モードによって表示するコンテンツを決める
              final showRecipeList = currentMode.value == MealManagementMode.recipeList;
              
              return Transform(
                alignment: Alignment.center,
                // レシピ一覧画面は常に180度事前回転して、アニメーション回転と合わせて正常向きにする
                transform: Matrix4.identity()
                  ..rotateY(showRecipeList ? pi : 0),
                child: Opacity(
                  // 滑らかなフェード効果
                  opacity: normalizedAnimation < 0.5 
                    ? 1.0 - (normalizedAnimation * 4).clamp(0.0, 1.0)
                    : ((normalizedAnimation - 0.5) * 4).clamp(0.0, 1.0),
                  child: showRecipeList
                      ? _buildRecipeListModeContent(context, toggleMode, filterMode)
                      : _buildKanbanModeContent(context, toggleMode),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  /// カンバンモード時のコンテンツ（ヘッダー + 栄養サマリー + カンバン）
  Widget _buildKanbanModeContent(BuildContext context, VoidCallback toggleMode) {
    return Column(
      children: [
        // ヘッダー
        _buildHeader(context),
        
        // 栄養分析エリア（上部）
        _buildNutritionSummary(),
        
        SizedBox(height: AppConstants.paddingM.h),
        
        // カンバンビュー
        Expanded(
          child: _buildKanbanView(toggleMode),
        ),
      ],
    );
  }

  /// レシピ一覧モード時のコンテンツ（フル画面レシピ一覧）
  Widget _buildRecipeListModeContent(BuildContext context, VoidCallback toggleMode, ValueNotifier<RecipeFilterMode> filterMode) {
    return Column(
      children: [
        // シンプルなヘッダー
        Container(
          padding: EdgeInsets.all(AppConstants.paddingM.w),
          child: Row(
            children: [
              GestureDetector(
                onTap: toggleMode,
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppConstants.radiusS.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4.r,
                        offset: Offset(0, 2.h),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.arrow_back_rounded,
                    size: 20.w,
                    color: AppColors.primary,
                  ),
                ),
              ),
              SizedBox(width: AppConstants.paddingM.w),
              Text(
                '保存済みレシピ',
                style: AppTextStyles.headline2,
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RecipeUrlRegisterPage(),
                    ),
                  );
                },
                icon: Icon(
                  Icons.add_link,
                  color: AppColors.primary,
                  size: 24.w,
                ),
                tooltip: 'レシピURL登録',
              ),
            ],
          ),
        ),
        
        // レシピ一覧エリア（フル活用）
        Expanded(
          child: _buildFullScreenRecipeList(context, filterMode),
        ),
      ],
    );
  }

  /// フルスクリーンレシピ一覧
  Widget _buildFullScreenRecipeList(BuildContext context, ValueNotifier<RecipeFilterMode> filterMode) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppConstants.paddingM.w),
      child: Column(
        children: [
          // 検索バー
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8.r,
                  offset: Offset(0, 2.h),
                ),
              ],
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'レシピを検索...',
                prefixIcon: Icon(
                  Icons.search,
                  color: AppColors.textSecondary,
                  size: 20.w,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingM.w,
                  vertical: 12.h,
                ),
              ),
            ),
          ),
          SizedBox(height: AppConstants.paddingM.h),
          
          // フィルタータブ
          Row(
            children: [
              _buildFilterTab('全て', filterMode.value == RecipeFilterMode.all, () {
                filterMode.value = RecipeFilterMode.all;
              }),
              SizedBox(width: AppConstants.paddingS.w),
              _buildFilterTab('お気に入り', filterMode.value == RecipeFilterMode.favorite, () {
                filterMode.value = RecipeFilterMode.favorite;
              }),
              SizedBox(width: AppConstants.paddingS.w),
              _buildFilterTab('最近使った', filterMode.value == RecipeFilterMode.recent, () {
                _showComingSoonMessage(context);
              }),
            ],
          ),
          SizedBox(height: AppConstants.paddingM.h),
          
          // レシピリスト（データベースから取得）
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                // フィルターモードに応じてプロバイダーを選択
                final recipesAsync = filterMode.value == RecipeFilterMode.favorite
                    ? ref.watch(favoriteRecipesProvider)
                    : ref.watch(recentRecipesProvider);
                
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
                              filterMode.value == RecipeFilterMode.favorite 
                                  ? 'お気に入りレシピがありません'
                                  : 'レシピがありません',
                              style: AppTextStyles.headline3.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            SizedBox(height: AppConstants.paddingS.h),
                            Text(
                              filterMode.value == RecipeFilterMode.favorite
                                  ? 'ハートマークをタップしてお気に入りに追加しましょう'
                                  : 'URLを登録してレシピを追加しましょう',
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
                        final tags = recipe.tags?.split(',').map((e) => e.trim()).toList() ?? [];
                        
                        return _buildRecipeListItem(
                          context,
                          recipe: recipe,
                          title: recipe.title,
                          siteName: recipe.siteName ?? 'Unknown',
                          imageUrl: recipe.imageUrl,
                          tags: tags,
                          isFavorite: recipe.isFavorite,
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
                        SizedBox(height: AppConstants.paddingS.h),
                        Text(
                          '$error',
                          style: AppTextStyles.body2.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppConstants.paddingM.w),
      child: Row(
        children: [
          Text(
            '食事管理',
            style: AppTextStyles.headline2,
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('カメラ機能は準備中です')),
              );
            },
            icon: Icon(
              Icons.camera_alt_rounded,
              color: AppColors.primary,
              size: 24.w,
            ),
          ),
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('検索機能は準備中です')),
              );
            },
            icon: Icon(
              Icons.search_rounded,
              color: AppColors.primary,
              size: 24.w,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RecipeUrlRegisterPage(),
                ),
              );
            },
            icon: Icon(
              Icons.add_link,
              color: AppColors.primary,
              size: 24.w,
            ),
            tooltip: 'レシピURL登録',
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionSummary() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppConstants.paddingM.w),
      padding: EdgeInsets.all(AppConstants.paddingM.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusL.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '今日の栄養摂取',
                style: AppTextStyles.headline3,
              ),
              TextButton(
                onPressed: () {
                  // TODO: 詳細画面へ
                },
                child: Text(
                  '詳細',
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppConstants.paddingS.h),
          
          // カロリープログレスバー
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'カロリー 0 / 2,000 kcal',
                style: AppTextStyles.body1,
              ),
              Text(
                '0%',
                style: AppTextStyles.body2.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          SizedBox(height: AppConstants.paddingS.h),
          LinearProgressIndicator(
            value: 0.0,
            backgroundColor: AppColors.primary.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            minHeight: 6.h,
            borderRadius: BorderRadius.circular(3.r),
          ),
          SizedBox(height: AppConstants.paddingS.h),
          
          // 3大栄養素
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMiniNutrient('P', '0g', AppColors.info),
              _buildMiniNutrient('F', '0g', AppColors.warning),
              _buildMiniNutrient('C', '0g', AppColors.success),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniNutrient(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          value,
          style: AppTextStyles.body2.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildKanbanView(VoidCallback onRecipeListTap) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppConstants.paddingM.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 在庫管理
          Expanded(
            child: _buildKanbanColumn(
              title: '在庫管理',
              color: AppColors.primary,
              items: [
                _buildStockItem('🥬', '白菜', '1/2個', '3日後'),
                _buildStockItem('🥚', '卵', '8個', '5日後'),
                _buildStockItem('🍗', '鶏肉', '300g', '明日'),
              ],
            ),
          ),
          SizedBox(width: AppConstants.paddingS.w),
          
          // レシピ（一時的に非表示）
          // Expanded(
          //   child: _buildRecipeKanbanColumn(onRecipeListTap),
          // ),
          // SizedBox(width: AppConstants.paddingS.w),
          
          // 食事記録
          Expanded(
            child: _buildMealRecordColumn(onRecipeListTap),
          ),
        ],
      ),
    );
  }

  Widget _buildKanbanColumn({
    required String title,
    required Color color,
    required List<Widget> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppConstants.paddingS.w,
            vertical: 4.h,
          ),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppConstants.radiusS.r),
          ),
          child: Text(
            title,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: AppConstants.paddingS.h),
        Expanded(
          child: ListView(
            children: items,
          ),
        ),
      ],
    );
  }

  Widget _buildStockItem(String emoji, String name, String quantity, String expiry) {
    return Container(
      margin: EdgeInsets.only(bottom: AppConstants.paddingS.h),
      padding: EdgeInsets.all(AppConstants.paddingS.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusS.r),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$emoji $name',
            style: AppTextStyles.body2.copyWith(fontWeight: FontWeight.w600),
          ),
          Text(
            quantity,
            style: AppTextStyles.caption,
          ),
          Text(
            expiry,
            style: AppTextStyles.caption.copyWith(color: AppColors.warning),
          ),
        ],
      ),
    );
  }

  // Widget _buildRecipeItem(String name, String calories, String protein) {
  //   return Container(
  //     margin: EdgeInsets.only(bottom: AppConstants.paddingS.h),
  //     padding: EdgeInsets.all(AppConstants.paddingS.w),
  //     decoration: BoxDecoration(
  //       color: AppColors.surface,
  //       borderRadius: BorderRadius.circular(AppConstants.radiusS.r),
  //       border: Border.all(color: AppColors.secondary.withOpacity(0.2)),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           name,
  //           style: AppTextStyles.body2.copyWith(fontWeight: FontWeight.w600),
  //         ),
  //         Text(
  //           calories,
  //           style: AppTextStyles.caption,
  //         ),
  //         Text(
  //           protein,
  //           style: AppTextStyles.caption.copyWith(color: AppColors.info),
  //         ),
  //         SizedBox(height: 4.h),
  //         Container(
  //           width: double.infinity,
  //           padding: EdgeInsets.symmetric(vertical: 4.h),
  //           decoration: BoxDecoration(
  //             color: AppColors.secondary,
  //             borderRadius: BorderRadius.circular(4.r),
  //           ),
  //           child: Text(
  //             '作る',
  //             style: AppTextStyles.caption.copyWith(
  //               color: Colors.white,
  //               fontWeight: FontWeight.w600,
  //             ),
  //             textAlign: TextAlign.center,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildMealSlot(String mealType) {
    return Container(
      margin: EdgeInsets.only(bottom: AppConstants.paddingS.h),
      padding: EdgeInsets.all(AppConstants.paddingM.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusS.r),
        border: Border.all(color: AppColors.accent.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(
            mealType,
            style: AppTextStyles.body2.copyWith(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: AppConstants.paddingS.h),
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: AppColors.accent.withOpacity(0.3),
                style: BorderStyle.solid,
                width: 2,
              ),
            ),
            child: Icon(
              Icons.add,
              color: AppColors.accent,
              size: 20.w,
            ),
          ),
        ],
      ),
    );
  }

  /// 食事記録専用のカンバンカラム（レシピ・食品登録ボタンを含む）
  Widget _buildMealRecordColumn(VoidCallback onRecipeListTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppConstants.paddingS.w,
            vertical: 4.h,
          ),
          decoration: BoxDecoration(
            color: AppColors.accent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppConstants.radiusS.r),
          ),
          child: Text(
            'レシピ・食品登録',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.accent,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: AppConstants.paddingS.h),
        Expanded(
          child: ListView(
            children: [
              _buildMealSlot('朝食'),
              _buildMealSlot('昼食'),
              _buildMealSlot('夕食'),
              SizedBox(height: AppConstants.paddingS.h),
              // レシピ・食品登録ボタン
              _buildRecipeRegistrationButton(onRecipeListTap),
            ],
          ),
        ),
      ],
    );
  }

  /// レシピ・食品登録ボタン
  Widget _buildRecipeRegistrationButton(VoidCallback onRecipeListTap) {
    return Container(
      margin: EdgeInsets.only(bottom: AppConstants.paddingS.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppConstants.radiusS.r),
          onTap: onRecipeListTap,
          child: Container(
            padding: EdgeInsets.all(AppConstants.paddingM.w),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppConstants.radiusS.r),
              border: Border.all(
                color: AppColors.secondary.withOpacity(0.3),
                style: BorderStyle.solid,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.restaurant_menu,
                  color: AppColors.secondary,
                  size: 24.w,
                ),
                SizedBox(height: 4.h),
                Text(
                  '保存済みレシピ',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// レシピ専用のカンバンカラム（一時的に非表示のため未使用）
  // Widget _buildRecipeKanbanColumn(VoidCallback onListTap) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       // ヘッダー（タイトル + 一覧ボタン）
  //       Row(
  //         children: [
  //           Container(
  //             padding: EdgeInsets.symmetric(
  //               horizontal: AppConstants.paddingS.w,
  //               vertical: 4.h,
  //             ),
  //             decoration: BoxDecoration(
  //               color: AppColors.secondary.withOpacity(0.1),
  //               borderRadius: BorderRadius.circular(AppConstants.radiusS.r),
  //             ),
  //             child: Text(
  //               'レシピ',
  //               style: AppTextStyles.caption.copyWith(
  //                 color: AppColors.secondary,
  //                 fontWeight: FontWeight.w600,
  //               ),
  //             ),
  //           ),
  //           const Spacer(),
  //           GestureDetector(
  //             onTap: onListTap,
  //             child: Container(
  //               padding: EdgeInsets.all(4.w),
  //               decoration: BoxDecoration(
  //                 color: AppColors.secondary.withOpacity(0.1),
  //                 borderRadius: BorderRadius.circular(AppConstants.radiusS.r),
  //               ),
  //               child: Icon(
  //                 Icons.list_rounded,
  //                 size: 16.w,
  //                 color: AppColors.secondary,
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //       SizedBox(height: AppConstants.paddingS.h),
  //       
  //       // レシピアイテム
  //       Expanded(
  //         child: Consumer(
  //           builder: (context, ref, child) {
  //             final recentRecipesAsync = ref.watch(recentRecipesProvider);
  //             
  //             return recentRecipesAsync.when(
  //               data: (recipes) {
  //                 final displayRecipes = recipes.take(3).toList(); // カンバンでは最大3件
  //                 
  //                 return ListView(
  //                   children: [
  //                     // 実際のレシピデータを表示
  //                     ...displayRecipes.map((recipe) => _buildKanbanRecipeItem(
  //                       context,
  //                       recipe: recipe,
  //                       onTap: () => Navigator.push(
  //                         context,
  //                         MaterialPageRoute(
  //                           builder: (context) => RecipeViewerPage(
  //                             url: recipe.url,
  //                             title: recipe.title,
  //                           ),
  //                         ),
  //                       ),
  //                     )),
  //                     
  //                     // レシピがない場合は追加ボタンを表示
  //                     if (displayRecipes.isEmpty)
  //                       _buildAddRecipeButton(context),
  //                     
  //                     // もっと見るボタン（レシピが3件以上ある場合）
  //                     if (recipes.length > 3 || displayRecipes.isNotEmpty)
  //                       Container(
  //                         margin: EdgeInsets.only(top: AppConstants.paddingS.h),
  //                         child: GestureDetector(
  //                           onTap: onListTap,
  //                           child: Container(
  //                             padding: EdgeInsets.all(AppConstants.paddingS.w),
  //                             decoration: BoxDecoration(
  //                               color: AppColors.surface,
  //                               borderRadius: BorderRadius.circular(AppConstants.radiusS.r),
  //                               border: Border.all(
  //                                 color: AppColors.secondary.withOpacity(0.3),
  //                                 style: BorderStyle.solid,
  //                               ),
  //                             ),
  //                             child: Row(
  //                               mainAxisAlignment: MainAxisAlignment.center,
  //                               children: [
  //                                 Icon(
  //                                   Icons.more_horiz,
  //                                   size: 16.w,
  //                                   color: AppColors.secondary,
  //                                 ),
  //                                 SizedBox(width: 4.w),
  //                                 Text(
  //                                   displayRecipes.isEmpty ? 'レシピを追加' : 'もっと見る',
  //                                   style: AppTextStyles.caption.copyWith(
  //                                     color: AppColors.secondary,
  //                                     fontWeight: FontWeight.w600,
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                   ],
  //                 );
  //               },
  //               loading: () => const Center(
  //                 child: Padding(
  //                   padding: EdgeInsets.all(16.0),
  //                   child: CircularProgressIndicator(),
  //                 ),
  //               ),
  //               error: (error, stack) => Center(
  //                 child: Column(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     Icon(
  //                       Icons.error_outline,
  //                       size: 32,
  //                       color: AppColors.error,
  //                     ),
  //                     const SizedBox(height: 8),
  //                     Text(
  //                       'エラー',
  //                       style: AppTextStyles.caption.copyWith(
  //                         color: AppColors.error,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             );
  //           },
  //         ),
  //       ),
  //     ],
  //   );
  // }


  /// フィルタータブ
  Widget _buildFilterTab(String label, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppConstants.paddingM.w,
          vertical: 8.h,
        ),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
          boxShadow: isActive ? [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 8.r,
              offset: Offset(0, 2.h),
            ),
          ] : null,
        ),
        child: Text(
          label,
          style: AppTextStyles.body2.copyWith(
            color: isActive ? Colors.white : AppColors.textSecondary,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  /// 今後実装予定メッセージを表示
  void _showComingSoonMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('今後実装予定の機能です'),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// レシピリストアイテム
  Widget _buildRecipeListItem(
    BuildContext context, {
    required ExternalRecipeTableData recipe,
    required String title,
    required String siteName,
    String? imageUrl,
    required List<String> tags,
    required bool isFavorite,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: AppConstants.paddingM.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusL.r),
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
          onTap: () {
            // レシピをWebViewで開く
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecipeViewerPage(
                  url: recipe.url,
                  title: recipe.title,
                ),
              ),
            );
          },
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
                    child: imageUrl != null
                        ? CachedNetworkImage(
                            imageUrl: imageUrl,
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
                        title,
                        style: AppTextStyles.headline3,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        siteName,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      // タグ
                      Wrap(
                        spacing: 4.w,
                        children: tags.map((tag) => Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            tag,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.secondary,
                              fontSize: 10.sp,
                            ),
                          ),
                        )).toList(),
                      ),
                    ],
                  ),
                ),
                
                // アクションボタン（編集・お気に入り）
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 編集ボタン
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecipeEditPage(recipe: recipe),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.edit,
                        color: AppColors.primary,
                        size: 20.w,
                      ),
                      tooltip: '編集',
                    ),
                    
                    // お気に入りボタン
                    Consumer(
                      builder: (context, ref, child) {
                        return IconButton(
                          onPressed: () {
                            // お気に入り切り替え
                            final recipeNotifier = ref.read(recipeRegistrationProvider.notifier);
                            recipeNotifier.toggleFavorite(recipe.id);
                          },
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? AppColors.error : AppColors.textSecondary,
                            size: 20.w,
                          ),
                          tooltip: 'お気に入り',
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// カンバン用レシピアイテム（コンパクトサイズ）
  Widget _buildKanbanRecipeItem(
    BuildContext context, {
    required ExternalRecipeTableData recipe,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: AppConstants.paddingS.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppConstants.radiusS.r),
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(AppConstants.paddingS.w),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppConstants.radiusS.r),
              border: Border.all(color: AppColors.secondary.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipe.title,
                  style: AppTextStyles.body2.copyWith(fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (recipe.siteName != null) ...[
                  SizedBox(height: 2.h),
                  Text(
                    recipe.siteName!,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 4.h),
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          '作る',
                          style: AppTextStyles.caption.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    
                    // 編集ボタン
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecipeEditPage(recipe: recipe),
                          ),
                        );
                      },
                      child: Icon(
                        Icons.edit,
                        color: AppColors.primary,
                        size: 16.w,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    
                    // お気に入りボタン
                    Consumer(
                      builder: (context, ref, child) {
                        return GestureDetector(
                          onTap: () {
                            final recipeNotifier = ref.read(recipeRegistrationProvider.notifier);
                            recipeNotifier.toggleFavorite(recipe.id);
                          },
                          child: Icon(
                            recipe.isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: recipe.isFavorite ? AppColors.error : AppColors.textSecondary,
                            size: 16.w,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// レシピ追加ボタン
  Widget _buildAddRecipeButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppConstants.paddingS.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppConstants.radiusS.r),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RecipeUrlRegisterPage(),
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.all(AppConstants.paddingM.w),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppConstants.radiusS.r),
              border: Border.all(
                color: AppColors.secondary.withOpacity(0.3),
                style: BorderStyle.solid,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.add_link,
                  color: AppColors.secondary,
                  size: 24.w,
                ),
                SizedBox(height: 4.h),
                Text(
                  'レシピを追加',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}