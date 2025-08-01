import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // メインカラー (ドーパミンデザイン)
  static const Color primary = Color(0xFF6366F1);       // インディゴ
  static const Color secondary = Color(0xFFF59E0B);     // アンバー
  static const Color accent = Color(0xFFEC4899);        // ピンク

  // 背景・サーフェス
  static const Color background = Color(0xFFFAFAFA);    // ほぼ白
  static const Color surface = Color(0xFFFFFFFF);       // 純白
  static const Color darkSurface = Color(0xFF1F2937);   // チャコール

  // 状態表示
  static const Color success = Color(0xFF10B981);       // エメラルド
  static const Color warning = Color(0xFFF59E0B);       // アンバー
  static const Color error = Color(0xFFEF4444);         // レッド
  static const Color info = Color(0xFF3B82F6);          // ブルー

  // テキスト
  static const Color textPrimary = Color(0xFF111827);   // ほぼ黒
  static const Color textSecondary = Color(0xFF6B7280); // グレー
  static const Color textDisabled = Color(0xFFD1D5DB);  // ライトグレー

  // グラデーション用カラー
  static const List<Color> gradientEnergy = [primary, accent];      // インディゴ → ピンク
  static const List<Color> gradientMorning = [secondary, Color(0xFFFCD34D)]; // アンバー → 明るい黄色
  static const List<Color> gradientNight = [primary, Color(0xFF9333EA)];     // インディゴ → パープル

  // 栄養バランス表示用
  static const Color nutritionGood = success;           // 適正範囲
  static const Color nutritionWarning = warning;       // やや不足/過剰
  static const Color nutritionBad = error;             // 不足/過剰

  // 在庫管理用（賞味期限）
  static const Color expiryDanger = error;             // 3日以内
  static const Color expiryWarning = warning;          // 7日以内
  static const Color expiryNormal = textSecondary;     // それ以上

  // 達成度カラー（歩数など）
  static const Color achievementLow = Color(0xFF9CA3AF);      // グレー（0-49%）
  static const Color achievementMedium = secondary;           // アンバー（50-79%）
  static const Color achievementHigh = primary;              // インディゴ（80-99%）
  static const Color achievementPerfect = accent;            // ピンク（100%以上）
}