import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/themes/app_colors.dart';
import '../../core/themes/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../data/datasources/app_database.dart';
import '../providers/database_provider.dart';

class StepsProgressCard extends StatelessWidget {
  const StepsProgressCard({
    super.key,
    required this.personalData,
  });

  final PersonalDataTableData? personalData;

  @override
  Widget build(BuildContext context) {
    final steps = personalData?.steps ?? 0;
    final goal = AppConstants.defaultStepsGoal;
    final percentage = goal > 0 ? (steps / goal).clamp(0.0, 1.0) : 0.0;

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
          Row(
            children: [
              Icon(
                Icons.directions_walk_rounded,
                color: AppColors.primary,
                size: 24.w,
              ),
              SizedBox(width: AppConstants.paddingS.w),
              Text(
                '今日の歩数',
                style: AppTextStyles.headline3,
              ),
            ],
          ),
          SizedBox(height: AppConstants.paddingM.h),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$steps / $goal歩',
                style: AppTextStyles.numberMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
              Text(
                '${(percentage * 100).toInt()}%',
                style: AppTextStyles.body1.copyWith(
                  color: _getAchievementColor(percentage),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: AppConstants.paddingS.h),
          
          LinearProgressIndicator(
            value: percentage,
            backgroundColor: AppColors.primary.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(_getAchievementColor(percentage)),
            minHeight: 8.h,
            borderRadius: BorderRadius.circular(4.r),
          ),
          
          if (personalData?.activeEnergy != null) ...[
            SizedBox(height: AppConstants.paddingS.h),
            Text(
              '消費カロリー: ${personalData!.activeEnergy!.toInt()} kcal',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getAchievementColor(double percentage) {
    if (percentage >= 1.0) {
      return AppColors.achievementPerfect;
    } else if (percentage >= 0.8) {
      return AppColors.achievementHigh;
    } else if (percentage >= 0.5) {
      return AppColors.achievementMedium;
    } else {
      return AppColors.achievementLow;
    }
  }
}