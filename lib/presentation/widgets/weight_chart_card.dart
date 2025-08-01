import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/themes/app_colors.dart';
import '../../core/themes/app_text_styles.dart';
import '../../core/constants/app_constants.dart';

class WeightChartCard extends StatelessWidget {
  const WeightChartCard({
    super.key,
    required this.weights,
  });

  final List<double> weights;

  @override
  Widget build(BuildContext context) {
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
            '体重推移（7日移動平均）',
            style: AppTextStyles.headline3,
          ),
          SizedBox(height: AppConstants.paddingS.h),
          Text(
            '過去3ヶ月',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: AppConstants.paddingM.h),
          
          // 簡易チャート表示（実際のグラフは後で実装）
          Container(
            height: 120.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
            ),
            child: weights.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.show_chart_rounded,
                          color: AppColors.textSecondary,
                          size: 32.w,
                        ),
                        SizedBox(height: AppConstants.paddingS.h),
                        Text(
                          '体重データがありません',
                          style: AppTextStyles.body2.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${weights.last.toStringAsFixed(1)} kg',
                          style: AppTextStyles.numberLarge.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(height: AppConstants.paddingS.h),
                        Text(
                          '最新の体重',
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
}