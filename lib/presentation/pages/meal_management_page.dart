import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/themes/app_colors.dart';
import '../../core/themes/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import 'recipe_url_register_page.dart';

class MealManagementPage extends HookConsumerWidget {
  const MealManagementPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ヘッダー
            _buildHeader(context),
            
            // 栄養分析エリア（上部）
            _buildNutritionSummary(),
            
            SizedBox(height: AppConstants.paddingM.h),
            
            // カンバンスタイル（下部）
            Expanded(
              child: _buildKanbanView(),
            ),
          ],
        ),
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

  Widget _buildKanbanView() {
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
            child: _buildKanbanColumn(
              title: 'レシピ',
              color: AppColors.secondary,
              items: [
                _buildRecipeItem('親子丼', '450kcal', 'P:25g'),
                _buildRecipeItem('野菜炒め', '320kcal', 'P:15g'),
                _buildRecipeItem('卵スープ', '120kcal', 'P:8g'),
              ],
            ),
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
}