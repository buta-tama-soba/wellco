import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/themes/app_colors.dart';
import '../../core/themes/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../providers/theme_provider.dart';
import '../providers/goals_provider.dart';

class SettingsPage extends HookConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final isDarkMode = themeMode == ThemeMode.dark;
    
    // 目標値をプロバイダーから取得
    final goalsNotifier = ref.watch(goalsProvider);
    final weightGoal = goalsNotifier.weightGoal;
    final caloriesGoal = goalsNotifier.caloriesGoal;
    final proteinGoal = goalsNotifier.proteinGoal;
    final fatGoal = goalsNotifier.fatGoal;
    final carbsGoal = goalsNotifier.carbsGoal;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppConstants.paddingM.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ヘッダー
              Text(
                '設定',
                style: AppTextStyles.headline2,
              ),
              SizedBox(height: AppConstants.paddingL.h),

              // 設定項目（一覧表示）
              Container(
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
                  children: [
                    _buildSettingItem(
                      icon: Icons.flag_rounded,
                      title: '体重目標',
                      subtitle: '${weightGoal.toStringAsFixed(1)} kg',
                      onTap: () => _showWeightGoalDialog(context, ref),
                    ),
                    _buildDivider(),
                    _buildSettingItem(
                      icon: Icons.restaurant_rounded,
                      title: '1日の栄養目標',
                      subtitle: '${caloriesGoal.toInt()} kcal, タンパク質 ${proteinGoal.toInt()}g',
                      onTap: () => _showNutritionGoalDialog(context, ref),
                    ),
                    _buildDivider(),
                    _buildSettingItem(
                      icon: Icons.health_and_safety_rounded,
                      title: 'HealthKit連携',
                      subtitle: '健康データの同期設定',
                      onTap: () => _showComingSoonSnackBar(context),
                    ),
                    _buildDivider(),
                    _buildSettingItem(
                      icon: Icons.help_outline_rounded,
                      title: 'ヘルプ',
                      subtitle: '使い方とFAQ',
                      onTap: () => _showComingSoonSnackBar(context),
                    ),
                    _buildDivider(),
                    _buildSettingItem(
                      icon: Icons.privacy_tip_rounded,
                      title: 'プライバシーポリシー',
                      subtitle: 'データの取り扱いについて',
                      onTap: () => _showComingSoonSnackBar(context),
                    ),
                    _buildDivider(),
                    _buildSettingItem(
                      icon: Icons.info_outline_rounded,
                      title: 'アプリについて',
                      subtitle: 'バージョン ${AppConstants.appVersion}',
                      onTap: () => _showAboutDialog(context),
                    ),
                  ],
                ),
              ),

              SizedBox(height: AppConstants.paddingXL.h),

              // MVP版の説明
              _buildMVPInfo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppConstants.paddingM.w),
      height: 1.h,
      color: AppColors.textSecondary.withOpacity(0.1),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(
          icon,
          color: AppColors.primary,
          size: 20.w,
        ),
      ),
      title: Text(
        title,
        style: AppTextStyles.body1.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTextStyles.body2.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: AppColors.textSecondary,
        size: 20.w,
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppConstants.paddingM.w,
        vertical: AppConstants.paddingXS.h,
      ),
    );
  }

  Widget _buildSwitchItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(
          icon,
          color: AppColors.primary,
          size: 20.w,
        ),
      ),
      title: Text(
        title,
        style: AppTextStyles.body1.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTextStyles.body2.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppConstants.paddingM.w,
        vertical: AppConstants.paddingXS.h,
      ),
    );
  }

  Widget _buildMVPInfo() {
    return Container(
      padding: EdgeInsets.all(AppConstants.paddingM.w),
      decoration: BoxDecoration(
        color: AppColors.info.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppConstants.radiusL.r),
        border: Border.all(
          color: AppColors.info.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_rounded,
                color: AppColors.info,
                size: 20.w,
              ),
              SizedBox(width: AppConstants.paddingS.w),
              Text(
                'MVP版について',
                style: AppTextStyles.body1.copyWith(
                  color: AppColors.info,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: AppConstants.paddingS.h),
          Text(
            'これは${AppConstants.appName}のMVP（最小実用製品）版です。基本的な機能を実装しており、今後のアップデートで機能を追加していく予定です。',
            style: AppTextStyles.body2.copyWith(
              color: AppColors.info,
            ),
          ),
        ],
      ),
    );
  }

  void _showComingSoonSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('この機能は今後のアップデートで追加予定です'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showWeightGoalDialog(BuildContext context, WidgetRef ref) {
    final goalsNotifier = ref.read(goalsProvider);
    final weightController = TextEditingController(
      text: goalsNotifier.weightGoal.toString(),
    );
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusL.r),
        ),
        title: Text(
          '目標体重',
          style: AppTextStyles.headline3,
        ),
        content: TextFormField(
          controller: weightController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: '体重 (kg)',
            suffixText: 'kg',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'キャンセル',
              style: AppTextStyles.body2.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final weight = double.tryParse(weightController.text);
              if (weight != null) {
                await goalsNotifier.updateWeightGoal(weight);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('体重目標を${weightController.text}kgに設定しました'),
                    backgroundColor: AppColors.success,
                  ),
                );
              }
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }

  void _showNutritionGoalDialog(BuildContext context, WidgetRef ref) {
    final goalsNotifier = ref.read(goalsProvider);
    final caloriesController = TextEditingController(
      text: goalsNotifier.caloriesGoal.toString(),
    );
    final proteinController = TextEditingController(
      text: goalsNotifier.proteinGoal.toString(),
    );
    final fatController = TextEditingController(
      text: goalsNotifier.fatGoal.toString(),
    );
    final carbsController = TextEditingController(
      text: goalsNotifier.carbsGoal.toString(),
    );
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusL.r),
        ),
        title: Text(
          '栄養目標',
          style: AppTextStyles.headline3,
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: caloriesController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'カロリー',
                        suffixText: 'kcal',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: AppConstants.paddingS.w),
                  Expanded(
                    child: TextFormField(
                      controller: proteinController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'タンパク質',
                        suffixText: 'g',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppConstants.paddingM.h),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: fatController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: '脂質',
                        suffixText: 'g',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: AppConstants.paddingS.w),
                  Expanded(
                    child: TextFormField(
                      controller: carbsController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: '炭水化物',
                        suffixText: 'g',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'キャンセル',
              style: AppTextStyles.body2.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final calories = double.tryParse(caloriesController.text);
              final protein = double.tryParse(proteinController.text);
              final fat = double.tryParse(fatController.text);
              final carbs = double.tryParse(carbsController.text);
              
              if (calories != null && protein != null && fat != null && carbs != null) {
                await goalsNotifier.updateNutritionGoals(
                  calories: calories,
                  protein: protein,
                  fat: fat,
                  carbs: carbs,
                );
                
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('栄養目標を設定しました'),
                    backgroundColor: AppColors.success,
                  ),
                );
              }
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: AppConstants.appName,
      applicationVersion: AppConstants.appVersion,
      applicationLegalese: '© 2025 HealthMeal Team',
      children: [
        SizedBox(height: AppConstants.paddingM.h),
        Text(
          '健康的な食生活と運動管理をサポートするアプリです。',
          style: AppTextStyles.body2,
        ),
      ],
    );
  }
}