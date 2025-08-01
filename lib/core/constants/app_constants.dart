class AppConstants {
  AppConstants._();

  // アプリ情報
  static const String appName = 'ウェルコ';
  static const String appVersion = '1.0.0';

  // スペーシング
  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 32.0;

  // ボーダーラディウス
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 20.0;

  // アニメーション時間
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);

  // 栄養素デフォルト目標値
  static const int defaultCaloriesGoal = 2000;
  static const int defaultProteinGoal = 75;  // g
  static const int defaultFatGoal = 60;      // g
  static const int defaultCarbsGoal = 300;   // g

  // 体重・歩数デフォルト目標値
  static const double defaultWeightGoal = 65.0;  // kg
  static const int defaultStepsGoal = 10000;     // 歩

  // HealthKit関連
  static const List<String> healthKitPermissions = [
    'BODY_MASS',
    'BODY_FAT_PERCENTAGE', 
    'STEPS',
    'ACTIVE_ENERGY_BURNED',
    'EXERCISE_TIME',
    'SLEEP_IN_BED',
  ];

  // 食品カテゴリ
  static const List<String> foodCategories = [
    '野菜',
    '果物',
    '肉類',
    '魚類',
    '卵・乳製品',
    '穀物',
    '調味料',
    '加工食品',
    'その他',
  ];

  // 食事タイプ
  static const List<String> mealTypes = [
    '朝食',
    '昼食',
    '夕食',
    '間食',
  ];

  // API関連
  static const String rakutenRecipeBaseUrl = 'https://app.rakuten.co.jp/services/api/Recipe/';
  static const String openFoodFactsBaseUrl = 'https://world.openfoodfacts.org/api/v0/product/';

  // データベース
  static const String databaseName = 'health_meal.db';
  static const int databaseVersion = 1;

  // 画像関連
  static const int maxImageSizeKB = 500;  // KB
  static const int imageQuality = 85;     // 0-100

  // バリデーション
  static const int maxFoodNameLength = 50;
  static const int maxRecipeNameLength = 100;
  static const double maxQuantity = 9999.0;
  static const double minQuantity = 0.1;

  // 期限関連
  static const int expiryDangerDays = 3;   // 3日以内は危険
  static const int expiryWarningDays = 7;  // 7日以内は警告

  // グラフ関連
  static const int weightGraphDays = 90;   // 3ヶ月分の体重データ
  static const int movingAverageDays = 7;  // 7日移動平均

  // ページネーション
  static const int recipesPerPage = 20;
  static const int foodItemsPerPage = 50;

  // タイムアウト
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration imagePickTimeout = Duration(seconds: 60);

  // エラーメッセージ
  static const String networkErrorMessage = 'ネットワークエラーが発生しました';
  static const String generalErrorMessage = '予期しないエラーが発生しました';
  static const String validationErrorMessage = '入力内容を確認してください';
}