import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../core/constants/app_constants.dart';

/// 目標値を管理するプロバイダー
class GoalsNotifier extends ChangeNotifier {
  double _weightGoal = AppConstants.defaultWeightGoal.toDouble();
  double _caloriesGoal = AppConstants.defaultCaloriesGoal.toDouble();
  double _proteinGoal = AppConstants.defaultProteinGoal.toDouble();
  double _fatGoal = AppConstants.defaultFatGoal.toDouble();
  double _carbsGoal = AppConstants.defaultCarbsGoal.toDouble();

  double get weightGoal => _weightGoal;
  double get caloriesGoal => _caloriesGoal;
  double get proteinGoal => _proteinGoal;
  double get fatGoal => _fatGoal;
  double get carbsGoal => _carbsGoal;

  void updateWeightGoal(double value) {
    _weightGoal = value;
    notifyListeners();
  }

  void updateNutritionGoals({
    required double calories,
    required double protein,
    required double fat,
    required double carbs,
  }) {
    _caloriesGoal = calories;
    _proteinGoal = protein;
    _fatGoal = fat;
    _carbsGoal = carbs;
    notifyListeners();
  }
}

final goalsProvider = ChangeNotifierProvider<GoalsNotifier>((ref) {
  return GoalsNotifier();
});