import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/themes/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'presentation/providers/theme_provider.dart';
import 'presentation/pages/main_page.dart';

void main() {
  runApp(
    const ProviderScope(
      child: HealthMealApp(),
    ),
  );
}

class HealthMealApp extends ConsumerWidget {
  const HealthMealApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone 13 miniベース
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          
          // テーマ設定
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          
          // ローカライゼーション
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('ja', 'JP'),
          ],
          
          // ホーム画面
          home: const MainPage(),
          
          // ルート設定（将来的に使用）
          // routes: AppRoutes.routes,
        );
      },
    );
  }
}