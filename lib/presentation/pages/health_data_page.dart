import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/themes/app_colors.dart';
import '../../core/themes/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../providers/database_provider.dart' hide weightHistoryProvider;
import '../providers/health_provider.dart';
import '../widgets/weight_chart_widget_modern.dart';

class HealthDataPage extends HookConsumerWidget {
  const HealthDataPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final personalData = ref.watch(todayPersonalDataProvider);
    final healthPermission = ref.watch(healthPermissionProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(todayPersonalDataProvider);
            ref.invalidate(healthPermissionProvider);
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

                // 権限確認カード
                healthPermission.when(
                  data: (hasPermission) => hasPermission
                      ? const SizedBox.shrink()
                      : _buildPermissionCard(context, ref),
                  loading: () => _buildLoadingCard(),
                  error: (error, stack) => _buildErrorCard('権限確認に失敗しました'),
                ),

                // 体重・体脂肪率カード
                personalData.when(
                  data: (data) => _buildWeightCard(data, ref),
                  loading: () => _buildLoadingCard(),
                  error: (error, stack) => _buildErrorCard('健康データの取得に失敗しました'),
                ),
                SizedBox(height: AppConstants.paddingM.h),

                // 今日の活動カード
                personalData.when(
                  data: (data) => _buildActivityCard(data),
                  loading: () => _buildLoadingCard(),
                  error: (error, stack) => _buildErrorCard('活動データの取得に失敗しました'),
                ),
                SizedBox(height: AppConstants.paddingM.h),

                // 手動入力ボタン
                _buildManualInputButton(context),
                SizedBox(height: AppConstants.paddingL.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final isToday = _isToday(selectedDate);
    
    return Column(
      children: [
        Row(
          children: [
            Text(
              '身体・活動',
              style: AppTextStyles.headline2,
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                // データを再取得
                ref.invalidate(todayPersonalDataProvider);
                ref.invalidate(healthPermissionProvider);
                ref.invalidate(healthDataSummaryProvider);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('HealthKitデータを更新しました'),
                    backgroundColor: AppColors.primary,
                  ),
                );
              },
              icon: Icon(
                Icons.refresh_rounded,
                color: AppColors.primary,
                size: 24.w,
              ),
            ),
          ],
        ),
        // 日付選択バーは非表示（機能は残す）
        // SizedBox(height: AppConstants.paddingM.h),
        // _buildDateSelector(context, ref, selectedDate, isToday),
      ],
    );
  }

  Widget _buildDateSelector(BuildContext context, WidgetRef ref, DateTime selectedDate, bool isToday) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppConstants.paddingM.w,
        vertical: AppConstants.paddingS.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          // 前日ボタン
          IconButton(
            onPressed: () {
              final previousDay = selectedDate.subtract(const Duration(days: 1));
              ref.read(selectedDateProvider.notifier).state = previousDay;
            },
            icon: Icon(
              Icons.chevron_left_rounded,
              color: AppColors.primary,
              size: 24.w,
            ),
          ),
          
          // 日付表示
          Expanded(
            child: GestureDetector(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime.now().subtract(const Duration(days: 365)),
                  lastDate: DateTime.now(),
                  locale: const Locale('ja', 'JP'),
                );
                if (date != null) {
                  ref.read(selectedDateProvider.notifier).state = date;
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Column(
                  children: [
                    Text(
                      isToday ? '今日' : _formatDate(selectedDate),
                      style: AppTextStyles.headline3.copyWith(
                        color: AppColors.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (!isToday)
                      Text(
                        _formatDateWithWeekday(selectedDate),
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                  ],
                ),
              ),
            ),
          ),
          
          // 翌日ボタン（今日より前の場合のみ表示）
          IconButton(
            onPressed: _isToday(selectedDate.add(const Duration(days: 1))) ? null : () {
              final nextDay = selectedDate.add(const Duration(days: 1));
              ref.read(selectedDateProvider.notifier).state = nextDay;
            },
            icon: Icon(
              Icons.chevron_right_rounded,
              color: _isToday(selectedDate.add(const Duration(days: 1))) 
                  ? AppColors.textSecondary.withOpacity(0.3)
                  : AppColors.primary,
              size: 24.w,
            ),
          ),
        ],
      ),
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  String _formatDate(DateTime date) {
    return '${date.month}月${date.day}日';
  }

  String _formatDateWithWeekday(DateTime date) {
    const weekdays = ['月', '火', '水', '木', '金', '土', '日'];
    final weekday = weekdays[date.weekday - 1];
    return '${date.year}年${date.month}月${date.day}日（$weekday）';
  }

  Widget _buildPermissionCard(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.all(AppConstants.paddingM.w),
      margin: EdgeInsets.only(bottom: AppConstants.paddingM.h),
      decoration: BoxDecoration(
        color: AppColors.warning.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppConstants.radiusL.r),
        border: Border.all(color: AppColors.warning.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.health_and_safety_rounded,
            color: AppColors.warning,
            size: 32.w,
          ),
          SizedBox(height: AppConstants.paddingS.h),
          Text(
            'HealthKit連携が必要です',
            style: AppTextStyles.headline3.copyWith(color: AppColors.warning),
          ),
          SizedBox(height: AppConstants.paddingS.h),
          Text(
            'より正確な健康データを取得するため、HealthKitへのアクセスを許可してください',
            style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppConstants.paddingM.h),
          ElevatedButton(
            onPressed: () async {
              print('HealthKit接続ボタンがタップされました'); // デバッグログ追加
              try {
                final healthService = ref.read(healthServiceProvider);
                print('HealthServiceを取得しました'); // デバッグログ追加
                
                final granted = await healthService.requestPermissions();
                print('権限リクエスト結果: $granted'); // デバッグログ追加
                
                if (granted) {
                  ref.invalidate(healthPermissionProvider);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('HealthKit連携が完了しました'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('HealthKit権限が拒否されました'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              } catch (e) {
                print('HealthKit接続エラー: $e'); // デバッグログ追加
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('エラーが発生しました: $e'),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
            child: const Text('HealthKitに接続'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingCard() {
    return Container(
      height: 120.h,
      margin: EdgeInsets.only(bottom: AppConstants.paddingM.h),
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

  Widget _buildErrorCard(String message) {
    return Container(
      padding: EdgeInsets.all(AppConstants.paddingM.w),
      margin: EdgeInsets.only(bottom: AppConstants.paddingM.h),
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
        ],
      ),
    );
  }

  Widget _buildWeightCard(PersonalDataTableData? data, WidgetRef ref) {
    return Container(
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
          Text(
            '体重・体脂肪率',
            style: AppTextStyles.headline3,
          ),
          SizedBox(height: AppConstants.paddingM.h),
          
          Row(
            children: [
              // 体重
              Expanded(
                child: _buildMetricItem(
                  value: data?.weight?.toStringAsFixed(1) ?? '--',
                  unit: 'kg',
                  change: data?.weight != null ? 'HealthKit連携' : 'データなし',
                  changeColor: data?.weight != null ? AppColors.success : AppColors.textSecondary,
                  subtitle: '最新データ',
                ),
              ),
              SizedBox(width: AppConstants.paddingM.w),
              
              // 体脂肪率
              Expanded(
                child: _buildMetricItem(
                  value: data?.bodyFatPercentage?.toStringAsFixed(1) ?? '--',
                  unit: '%',
                  change: data?.bodyFatPercentage != null ? 'HealthKit連携' : 'データなし',
                  changeColor: data?.bodyFatPercentage != null ? AppColors.success : AppColors.textSecondary,
                  subtitle: '最新データ',
                ),
              ),
            ],
          ),
          
          SizedBox(height: AppConstants.paddingM.h),
          
          // 体重推移グラフ
          SizedBox(
            height: 280.h,
            child: _buildWeightChartSection(ref),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(PersonalDataTableData? data) {
    return Container(
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
          Text(
            '直近24時間の活動',
            style: AppTextStyles.headline3,
          ),
          SizedBox(height: AppConstants.paddingM.h),
          
          // アクティビティメトリクス
          _buildActivityMetric(
            icon: Icons.directions_walk_rounded,
            label: '歩数',
            value: data?.steps?.toString() ?? '--',
            unit: '歩',
            color: AppColors.primary,
          ),
          SizedBox(height: AppConstants.paddingM.h),
          
          _buildActivityMetric(
            icon: Icons.local_fire_department_rounded,
            label: '消費カロリー',
            value: data?.activeEnergy?.toInt().toString() ?? '--',
            unit: 'kcal',
            color: AppColors.secondary,
          ),
          SizedBox(height: AppConstants.paddingM.h),
          
          _buildActivityMetric(
            icon: Icons.fitness_center_rounded,
            label: '運動時間',
            value: data?.exerciseTime?.toString() ?? '--',
            unit: '分',
            color: AppColors.accent,
          ),
          SizedBox(height: AppConstants.paddingM.h),
          
          _buildActivityMetric(
            icon: Icons.bedtime_rounded,
            label: '睡眠時間',
            value: data?.sleepHours?.toStringAsFixed(1) ?? '--',
            unit: '時間',
            color: AppColors.info,
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem({
    required String value,
    required String unit,
    required String change,
    required Color changeColor,
    required String subtitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              value,
              style: AppTextStyles.numberLarge.copyWith(
                color: AppColors.primary,
              ),
            ),
            SizedBox(width: 4.w),
            Padding(
              padding: EdgeInsets.only(bottom: 4.h),
              child: Text(
                unit,
                style: AppTextStyles.body1.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Text(
          change,
          style: AppTextStyles.caption.copyWith(
            color: changeColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          subtitle,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildActivityMetric({
    required IconData icon,
    required String label,
    required String value,
    required String unit,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20.w,
          ),
        ),
        SizedBox(width: AppConstants.paddingM.w),
        
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.body2.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                '$value $unit',
                style: AppTextStyles.body1.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWeightChartSection(WidgetRef ref) {
    final weightHistoryAsync = ref.watch(weightHistoryProvider);

    return weightHistoryAsync.when(
      data: (weightData) => WeightChartWidgetModern(
        weightData: weightData,
        onRefresh: () {
          ref.invalidate(weightHistoryProvider);
        },
      ),
      loading: () => WeightChartWidgetModern(
        weightData: const [],
        isLoading: true,
      ),
      error: (error, stack) => WeightChartWidgetModern(
        weightData: const [],
        errorMessage: error.toString(),
        onRefresh: () {
          ref.invalidate(weightHistoryProvider);
        },
      ),
    );
  }

  Widget _buildManualInputButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('手動入力機能は準備中です')),
          );
        },
        icon: Icon(
          Icons.edit_rounded,
          size: 20.w,
        ),
        label: const Text('手動で記録'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.primary,
          elevation: 0,
          side: BorderSide(
            color: AppColors.primary.withOpacity(0.3),
          ),
          padding: EdgeInsets.symmetric(vertical: 16.h),
        ),
      ),
    );
  }
}