import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/themes/app_colors.dart';
import '../../core/themes/app_text_styles.dart';
import '../../core/constants/app_constants.dart';

class NutritionSummaryCard extends StatelessWidget {
  const NutritionSummaryCard({
    super.key,
    required this.nutrition,
  });

  final Map<String, double> nutrition;

  @override
  Widget build(BuildContext context) {
    final calories = nutrition['calories'] ?? 0.0;
    final protein = nutrition['protein'] ?? 0.0;
    final fat = nutrition['fat'] ?? 0.0;
    final carbs = nutrition['carbs'] ?? 0.0;

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
          
          // カロリー（メイン表示）
          _buildMainNutrient(
            label: 'カロリー',
            current: calories,
            target: AppConstants.defaultCaloriesGoal.toDouble(),
            unit: 'kcal',
            color: AppColors.primary,
          ),
          SizedBox(height: AppConstants.paddingM.h),

          // 3大栄養素（グリッド表示）
          Row(
            children: [
              Expanded(
                child: _buildMiniNutrient(
                  label: 'タンパク質',
                  current: protein,
                  target: AppConstants.defaultProteinGoal.toDouble(),
                  unit: 'g',
                  color: AppColors.info,
                ),
              ),
              SizedBox(width: AppConstants.paddingS.w),
              Expanded(
                child: _buildMiniNutrient(
                  label: '脂質',
                  current: fat,
                  target: AppConstants.defaultFatGoal.toDouble(),
                  unit: 'g',
                  color: AppColors.warning,
                ),
              ),
              SizedBox(width: AppConstants.paddingS.w),
              Expanded(
                child: _buildMiniNutrient(
                  label: '炭水化物',
                  current: carbs,
                  target: AppConstants.defaultCarbsGoal.toDouble(),
                  unit: 'g',
                  color: AppColors.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMainNutrient({
    required String label,
    required double current,
    required double target,
    required String unit,
    required Color color,
  }) {
    final percentage = target > 0 ? (current / target).clamp(0.0, 1.0) : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppTextStyles.body1.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${percentage.toPercentage()}%',
              style: AppTextStyles.body2.copyWith(
                color: _getPercentageColor(percentage),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: AppConstants.paddingS.h),
        Text(
          '${current.toInt()} / ${target.toInt()} $unit',
          style: AppTextStyles.numberMedium.copyWith(color: color),
        ),
        SizedBox(height: AppConstants.paddingS.h),
        LinearProgressIndicator(
          value: percentage,
          backgroundColor: color.withOpacity(0.2),
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 6.h,
          borderRadius: BorderRadius.circular(3.r),
        ),
      ],
    );
  }

  Widget _buildMiniNutrient({
    required String label,
    required double current,
    required double target,
    required String unit,
    required Color color,
  }) {
    final percentage = target > 0 ? (current / target).clamp(0.0, 1.0) : 0.0;

    return Container(
      padding: EdgeInsets.all(AppConstants.paddingS.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
            '${current.toInt()}g',
            style: AppTextStyles.numberSmall.copyWith(color: color),
          ),
          SizedBox(height: 4.h),
          LinearProgressIndicator(
            value: percentage,
            backgroundColor: Colors.white.withOpacity(0.5),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 3.h,
            borderRadius: BorderRadius.circular(1.5.r),
          ),
        ],
      ),
    );
  }

  Color _getPercentageColor(double percentage) {
    if (percentage >= 0.8 && percentage <= 1.2) {
      return AppColors.success;
    } else if (percentage >= 0.6 && percentage <= 1.4) {
      return AppColors.warning;
    } else {
      return AppColors.error;
    }
  }
}

extension on double {
  int toPercentage() => (this * 100).round();
}