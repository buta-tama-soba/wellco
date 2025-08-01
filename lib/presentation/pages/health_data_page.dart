import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/themes/app_colors.dart';
import '../../core/themes/app_text_styles.dart';
import '../../core/constants/app_constants.dart';

class HealthDataPage extends HookConsumerWidget {
  const HealthDataPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppConstants.paddingM.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ヘッダー
              _buildHeader(context),
              SizedBox(height: AppConstants.paddingL.h),

              // 体重・体脂肪率カード
              _buildWeightCard(),
              SizedBox(height: AppConstants.paddingM.h),

              // 今日の活動カード
              _buildActivityCard(),
              SizedBox(height: AppConstants.paddingM.h),

              // 手動入力ボタン
              _buildManualInputButton(context),
              SizedBox(height: AppConstants.paddingL.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Text(
          '身体・活動',
          style: AppTextStyles.headline2,
        ),
        const Spacer(),
        IconButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('HealthKit同期機能は準備中です')),
            );
          },
          icon: Icon(
            Icons.refresh_rounded,
            color: AppColors.primary,
            size: 24.w,
          ),
        ),
      ],
    );
  }

  Widget _buildWeightCard() {
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
                  value: '68.5',
                  unit: 'kg',
                  change: '↓0.3kg',
                  changeColor: AppColors.success,
                  subtitle: '昨日から',
                ),
              ),
              SizedBox(width: AppConstants.paddingM.w),
              
              // 体脂肪率
              Expanded(
                child: _buildMetricItem(
                  value: '22.3',
                  unit: '%',
                  change: '↑0.1%',
                  changeColor: AppColors.warning,
                  subtitle: '昨日から',
                ),
              ),
            ],
          ),
          
          SizedBox(height: AppConstants.paddingM.h),
          
          // 簡易グラフエリア
          Container(
            height: 80.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.show_chart_rounded,
                    color: AppColors.textSecondary,
                    size: 32.w,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '推移グラフ（準備中）',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard() {
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
            '今日の活動',
            style: AppTextStyles.headline3,
          ),
          SizedBox(height: AppConstants.paddingM.h),
          
          // アクティビティメトリクス
          _buildActivityMetric(
            icon: Icons.directions_walk_rounded,
            label: '歩数',
            value: '8,234',
            unit: '歩',
            color: AppColors.primary,
          ),
          SizedBox(height: AppConstants.paddingM.h),
          
          _buildActivityMetric(
            icon: Icons.local_fire_department_rounded,
            label: '消費カロリー',
            value: '285',
            unit: 'kcal',
            color: AppColors.secondary,
          ),
          SizedBox(height: AppConstants.paddingM.h),
          
          _buildActivityMetric(
            icon: Icons.fitness_center_rounded,
            label: '運動時間',
            value: '45',
            unit: '分',
            color: AppColors.accent,
          ),
          SizedBox(height: AppConstants.paddingM.h),
          
          _buildActivityMetric(
            icon: Icons.bedtime_rounded,
            label: '睡眠時間',
            value: '7.5',
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