import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/themes/app_colors.dart';
import '../../core/themes/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../providers/database_provider.dart';
import '../widgets/nutrition_summary_card.dart';
import '../widgets/weight_chart_card.dart';
import '../widgets/steps_progress_card.dart';
import '../widgets/quick_actions_card.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayNutrition = ref.watch(todayNutritionProvider);
    final todayPersonalData = ref.watch(todayPersonalDataProvider);
    final weightHistory = ref.watch(weightHistoryProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(todayNutritionProvider);
            ref.invalidate(todayPersonalDataProvider);
            ref.invalidate(weightHistoryProvider);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(AppConstants.paddingM.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ヘッダー
                _buildHeader(context, ref),
                SizedBox(height: AppConstants.paddingL.h),

                // 今日の栄養バランス
                todayNutrition.when(
                  data: (nutrition) => NutritionSummaryCard(nutrition: nutrition),
                  loading: () => const _LoadingCard(height: 160),
                  error: (error, stack) => _ErrorCard(
                    message: '栄養データの取得に失敗しました',
                    onRetry: () => ref.invalidate(todayNutritionProvider),
                  ),
                ),
                SizedBox(height: AppConstants.paddingM.h),

                // 体重推移
                weightHistory.when(
                  data: (weights) => WeightChartCard(weights: weights),
                  loading: () => const _LoadingCard(height: 200),
                  error: (error, stack) => _ErrorCard(
                    message: '体重データの取得に失敗しました',
                    onRetry: () => ref.invalidate(weightHistoryProvider),
                  ),
                ),
                SizedBox(height: AppConstants.paddingM.h),

                // 今日の歩数
                todayPersonalData.when(
                  data: (data) => StepsProgressCard(personalData: data),
                  loading: () => const _LoadingCard(height: 120),
                  error: (error, stack) => _ErrorCard(
                    message: '歩数データの取得に失敗しました',
                    onRetry: () => ref.invalidate(todayPersonalDataProvider),
                  ),
                ),
                SizedBox(height: AppConstants.paddingM.h),

                // クイックアクション
                const QuickActionsCard(),
                SizedBox(height: AppConstants.paddingL.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final greeting = _getTimeBasedGreeting(ref);
    final dateText = '${now.month}月${now.day}日';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greeting,
          style: AppTextStyles.headline2.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: 4.h),
        Row(
          children: [
            Text(
              dateText,
              style: AppTextStyles.headline1.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 6.h,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Text(
                'MVP版',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _getTimeBasedGreeting(WidgetRef ref) {
    final hour = DateTime.now().hour;
    final todayNutritionData = ref.read(todayNutritionProvider).valueOrNull;
    final todayPersonalData = ref.read(todayPersonalDataProvider).valueOrNull;
    
    // 記録状況を確認
    final hasNutritionRecord = todayNutritionData != null && todayNutritionData['calories'] != null && todayNutritionData['calories']! > 0;
    final hasActivityRecord = todayPersonalData != null && (todayPersonalData.steps ?? 0) > 0;
    
    if (hour < 6) {
      return hasNutritionRecord || hasActivityRecord ? 'お疲れ様でした' : 'ゆっくり休んでくださいね';
    } else if (hour < 12) {
      return hasNutritionRecord ? '素晴らしいスタートです！' : '今日も一緒に頑張りましょう！';
    } else if (hour < 18) {
      if (hasNutritionRecord && hasActivityRecord) {
        return '調子良いですね！';
      } else if (hasNutritionRecord) {
        return '体も動かしませんか？';
      } else {
        return '今からでも遅くありません！';
      }
    } else {
      if (hasNutritionRecord && hasActivityRecord) {
        return '今日も一日お疲れ様！';
      } else if (hasNutritionRecord || hasActivityRecord) {
        return '明日はもっと楽しみですね！';
      } else {
        return '明日は一緒に頑張りましょう！';
      }
    }
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height.h,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusL.r),
      ),
      child: Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
          strokeWidth: 2.w,
        ),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppConstants.paddingM.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusL.r),
        border: Border.all(color: AppColors.error.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: AppColors.error,
            size: 32.w,
          ),
          SizedBox(height: AppConstants.paddingS.h),
          Text(
            message,
            style: AppTextStyles.body2.copyWith(color: AppColors.error),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppConstants.paddingM.h),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              minimumSize: Size(double.infinity, 40.h),
            ),
            child: Text(
              '再試行',
              style: AppTextStyles.button.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}