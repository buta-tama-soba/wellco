import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/themes/app_colors.dart';
import '../../core/themes/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../data/datasources/app_database.dart';
import '../providers/database_provider.dart';
import 'recipe_url_register_page.dart';
import 'recipe_viewer_page.dart';

/// 食事管理画面の表示モード
enum MealManagementMode {
  kanban,    // カンバン表示
  recipeList // レシピ一覧表示
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
                      ? _buildRecipeListModeContent(context, toggleMode)
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
  Widget _buildRecipeListModeContent(BuildContext context, VoidCallback toggleMode) {
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
          child: _buildFullScreenRecipeList(context),
        ),
      ],
    );
  }

  /// フルスクリーンレシピ一覧
  Widget _buildFullScreenRecipeList(BuildContext context) {
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
              _buildFilterTab('全て', true),
              SizedBox(width: AppConstants.paddingS.w),
              _buildFilterTab('お気に入り', false),
              SizedBox(width: AppConstants.paddingS.w),
              _buildFilterTab('最近使った', false),
            ],
          ),
          SizedBox(height: AppConstants.paddingM.h),
          
          // レシピリスト（データベースから取得）
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                final recentRecipesAsync = ref.watch(recentRecipesProvider);
                
                return recentRecipesAsync.when(
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
                              'レシピがありません',
                              style: AppTextStyles.headline3.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            SizedBox(height: AppConstants.paddingS.h),
                            Text(
                              'URLを登録してレシピを追加しましょう',
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
          
          // レシピ
          Expanded(
            child: _buildRecipeKanbanColumn(onRecipeListTap),
          ),
          SizedBox(width: AppConstants.paddingS.w),
          
          // 食事記録
          Expanded(
            child: _buildKanbanColumn(
              title: '食事記録',
              color: AppColors.accent,
              items: [
                _buildMealSlot('朝食'),
                _buildMealSlot('昼食'),
                _buildMealSlot('夕食'),
              ],
            ),
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

  Widget _buildRecipeItem(String name, String calories, String protein) {
    return Container(
      margin: EdgeInsets.only(bottom: AppConstants.paddingS.h),
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
            name,
            style: AppTextStyles.body2.copyWith(fontWeight: FontWeight.w600),
          ),
          Text(
            calories,
            style: AppTextStyles.caption,
          ),
          Text(
            protein,
            style: AppTextStyles.caption.copyWith(color: AppColors.info),
          ),
          SizedBox(height: 4.h),
          Container(
            width: double.infinity,
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
        ],
      ),
    );
  }

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

  /// レシピ専用のカンバンカラム
  Widget _buildRecipeKanbanColumn(VoidCallback onListTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ヘッダー（タイトル + 一覧ボタン）
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppConstants.paddingS.w,
                vertical: 4.h,
              ),
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppConstants.radiusS.r),
              ),
              child: Text(
                'レシピ',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: onListTap,
              child: Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppConstants.radiusS.r),
                ),
                child: Icon(
                  Icons.list_rounded,
                  size: 16.w,
                  color: AppColors.secondary,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: AppConstants.paddingS.h),
        
        // レシピアイテム
        Expanded(
          child: ListView(
            children: [
              _buildRecipeItem('親子丼', '450kcal', 'P:25g'),
              _buildRecipeItem('野菜炒め', '320kcal', 'P:15g'),
              _buildRecipeItem('卵スープ', '120kcal', 'P:8g'),
              // もっと見るボタン
              Container(
                margin: EdgeInsets.only(top: AppConstants.paddingS.h),
                child: GestureDetector(
                  onTap: onListTap,
                  child: Container(
                    padding: EdgeInsets.all(AppConstants.paddingS.w),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppConstants.radiusS.r),
                      border: Border.all(
                        color: AppColors.secondary.withOpacity(0.3),
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.more_horiz,
                          size: 16.w,
                          color: AppColors.secondary,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'もっと見る',
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
            ],
          ),
        ),
      ],
    );
  }


  /// フィルタータブ
  Widget _buildFilterTab(String label, bool isActive) {
    return Container(
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
                  child: Icon(
                    Icons.restaurant,
                    color: AppColors.primary,
                    size: 24.w,
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
                
                // お気に入りボタン
                IconButton(
                  onPressed: () {
                    // お気に入り切り替え
                  },
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? AppColors.error : AppColors.textSecondary,
                    size: 20.w,
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