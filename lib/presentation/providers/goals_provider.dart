import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';

/// 目標値を管理するプロバイダー
class GoalsNotifier extends ChangeNotifier {
  double _weightGoal = AppConstants.defaultWeightGoal.toDouble();
  double _caloriesGoal = AppConstants.defaultCaloriesGoal.toDouble();
  double _proteinGoal = AppConstants.defaultProteinGoal.toDouble();
  double _fatGoal = AppConstants.defaultFatGoal.toDouble();
  double _carbsGoal = AppConstants.defaultCarbsGoal.toDouble();

  static const String _weightGoalKey = 'weight_goal';
  static const String _caloriesGoalKey = 'calories_goal';
  static const String _proteinGoalKey = 'protein_goal';
  static const String _fatGoalKey = 'fat_goal';
  static const String _carbsGoalKey = 'carbs_goal';

  bool _isLoaded = false;

  double get weightGoal => _weightGoal;
  double get caloriesGoal => _caloriesGoal;
  double get proteinGoal => _proteinGoal;
  double get fatGoal => _fatGoal;
  double get carbsGoal => _carbsGoal;
  bool get isLoaded => _isLoaded;

  /// SharedPreferencesから目標値を読み込み
  Future<void> loadGoals() async {
    if (_isLoaded) return;
    
    final prefs = await SharedPreferences.getInstance();
    _weightGoal = prefs.getDouble(_weightGoalKey) ?? AppConstants.defaultWeightGoal.toDouble();
    _caloriesGoal = prefs.getDouble(_caloriesGoalKey) ?? AppConstants.defaultCaloriesGoal.toDouble();
    _proteinGoal = prefs.getDouble(_proteinGoalKey) ?? AppConstants.defaultProteinGoal.toDouble();
    _fatGoal = prefs.getDouble(_fatGoalKey) ?? AppConstants.defaultFatGoal.toDouble();
    _carbsGoal = prefs.getDouble(_carbsGoalKey) ?? AppConstants.defaultCarbsGoal.toDouble();
    
    _isLoaded = true;
    notifyListeners();
  }

  /// 体重目標を更新して保存
  Future<void> updateWeightGoal(double value) async {
    _weightGoal = value;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_weightGoalKey, value);
  }

  /// 栄養目標を更新して保存
  Future<void> updateNutritionGoals({
    required double calories,
    required double protein,
    required double fat,
    required double carbs,
  }) async {
    _caloriesGoal = calories;
    _proteinGoal = protein;
    _fatGoal = fat;
    _carbsGoal = carbs;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.setDouble(_caloriesGoalKey, calories),
      prefs.setDouble(_proteinGoalKey, protein),
      prefs.setDouble(_fatGoalKey, fat),
      prefs.setDouble(_carbsGoalKey, carbs),
    ]);
  }
}

final goalsProvider = ChangeNotifierProvider<GoalsNotifier>((ref) {
  return GoalsNotifier();
});