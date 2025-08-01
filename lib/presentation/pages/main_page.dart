import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/themes/app_colors.dart';
import '../../core/themes/app_text_styles.dart';
import '../pages/home_page.dart';
import '../pages/meal_management_page.dart';
import '../pages/health_data_page.dart';
import '../pages/settings_page.dart';

class MainPage extends HookConsumerWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = useState(0);

    final pages = [
      const HomePage(),
      const MealManagementPage(),
      const HealthDataPage(),
      const SettingsPage(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: currentIndex.value,
        children: pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  context: context,
                  icon: Icons.home_rounded,
                  label: 'ホーム',
                  isSelected: currentIndex.value == 0,
                  onTap: () => currentIndex.value = 0,
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.restaurant_rounded,
                  label: '食事管理',
                  isSelected: currentIndex.value == 1,
                  onTap: () => currentIndex.value = 1,
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.directions_walk_rounded,
                  label: '身体・活動',
                  isSelected: currentIndex.value == 2,
                  onTap: () => currentIndex.value = 2,
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.settings_rounded,
                  label: '設定',
                  isSelected: currentIndex.value == 3,
                  onTap: () => currentIndex.value = 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: isSelected 
                    ? AppColors.primary.withOpacity(0.1) 
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                icon,
                color: isSelected 
                    ? AppColors.primary 
                    : AppColors.textSecondary,
                size: 24.w,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: isSelected 
                    ? AppColors.primary 
                    : AppColors.textSecondary,
                fontWeight: isSelected 
                    ? FontWeight.w600 
                    : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}