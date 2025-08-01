import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/themes/app_colors.dart';
import '../../core/themes/app_text_styles.dart';
import '../../core/constants/app_constants.dart';

class QuickActionsCard extends StatelessWidget {
  const QuickActionsCard({super.key});

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
            'クイックアクション',
            style: AppTextStyles.headline3,
          ),
          SizedBox(height: AppConstants.paddingM.h),
          
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  icon: Icons.restaurant_rounded,
                  label: '食事記録',
                  color: AppColors.secondary,
                  onTap: () {
                    // TODO: 食事記録画面に遷移
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('食事記録機能は準備中です')),
                    );
                  },
                ),
              ),
              SizedBox(width: AppConstants.paddingM.w),
              Expanded(
                child: _buildActionButton(
                  icon: Icons.add_box_rounded,
                  label: '在庫追加',
                  color: AppColors.accent,
                  onTap: () {
                    // TODO: 在庫追加画面に遷移
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('在庫追加機能は準備中です')),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppConstants.paddingM.w),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 24.w,
              ),
            ),
            SizedBox(height: AppConstants.paddingS.h),
            Text(
              label,
              style: AppTextStyles.body2.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}