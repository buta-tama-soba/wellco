import 'package:fl_chart/fl_chart.dart';
import '../services/health_service.dart';

/// チャート関連のユーティリティクラス
class ChartUtils {
  /// 7日移動平均を計算
  static List<FlSpot> calculateMovingAverage(
    List<WeightData> data, 
    int period,
  ) {
    if (data.length < period) return [];
    
    List<FlSpot> movingAverageSpots = [];
    
    for (int i = period - 1; i < data.length; i++) {
      double sum = 0;
      for (int j = i - period + 1; j <= i; j++) {
        sum += data[j].weight;
      }
      double average = sum / period;
      
      movingAverageSpots.add(FlSpot(i.toDouble(), average));
    }
    
    return movingAverageSpots;
  }
  
  /// WeightDataをFlSpotに変換
  static List<FlSpot> convertToFlSpots(List<WeightData> data) {
    return data.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.weight);
    }).toList();
  }
  
  /// チャートデータの有効性をチェック
  static List<FlSpot> validateChartData(List<FlSpot> spots) {
    return spots.where((spot) => 
      !spot.x.isNaN && 
      !spot.y.isNaN && 
      spot.x.isFinite && 
      spot.y.isFinite
    ).toList();
  }
  
  /// データのダウンサンプリング（パフォーマンス向上）
  static List<WeightData> downsampleData(List<WeightData> data, int maxPoints) {
    if (data.length <= maxPoints) return data;
    
    final step = data.length / maxPoints;
    List<WeightData> downsampled = [];
    
    for (int i = 0; i < maxPoints; i++) {
      final index = (i * step).round();
      if (index < data.length) {
        downsampled.add(data[index]);
      }
    }
    
    return downsampled;
  }
  
  /// チャートの安全な境界を計算
  static ChartBounds calculateSafeBounds(List<FlSpot> spots, {double padding = 1.0}) {
    if (spots.isEmpty) {
      return ChartBounds(minX: 0, maxX: 1, minY: 0, maxY: 100);
    }
    
    double minX = spots.map((s) => s.x).reduce((a, b) => a < b ? a : b);
    double maxX = spots.map((s) => s.x).reduce((a, b) => a > b ? a : b);
    double minY = spots.map((s) => s.y).reduce((a, b) => a < b ? a : b);
    double maxY = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    
    // パディングを追加
    final yRange = maxY - minY;
    final yPadding = yRange * 0.1 + padding;
    
    return ChartBounds(
      minX: minX,
      maxX: maxX,
      minY: minY - yPadding,
      maxY: maxY + yPadding,
    );
  }
  
  /// 最適なグリッド間隔を取得
  static double getOptimalInterval(int dataPointCount) {
    if (dataPointCount <= 10) return 1.0;
    if (dataPointCount <= 30) return 2.0;
    if (dataPointCount <= 60) return 5.0;
    return 10.0;
  }
  
  /// 日付を軸ラベル用にフォーマット
  static String formatDateForAxis(DateTime date, int totalPoints) {
    if (totalPoints <= 30) {
      return '${date.month}/${date.day}';
    } else if (totalPoints <= 60) {
      return date.day == 1 ? '${date.month}月' : '';
    } else {
      return date.day == 1 && date.month % 2 == 1 ? '${date.month}月' : '';
    }
  }
  
  /// 体重の傾向を分析
  static WeightTrend analyzeWeightTrend(List<WeightData> data) {
    if (data.length < 7) return WeightTrend.stable;
    
    final recent = data.take(7).map((d) => d.weight).toList();
    final older = data.skip(data.length - 7).map((d) => d.weight).toList();
    
    final recentAvg = recent.reduce((a, b) => a + b) / recent.length;
    final olderAvg = older.reduce((a, b) => a + b) / older.length;
    
    final difference = recentAvg - olderAvg;
    
    if (difference > 0.5) return WeightTrend.increasing;
    if (difference < -0.5) return WeightTrend.decreasing;
    return WeightTrend.stable;
  }
}

/// チャートの境界値
class ChartBounds {
  final double minX;
  final double maxX;
  final double minY;
  final double maxY;
  
  ChartBounds({
    required this.minX,
    required this.maxX,
    required this.minY,
    required this.maxY,
  });
}

/// 体重の傾向
enum WeightTrend {
  increasing,
  decreasing,
  stable;
  
  String get displayName {
    switch (this) {
      case WeightTrend.increasing:
        return '増加傾向';
      case WeightTrend.decreasing:
        return '減少傾向';
      case WeightTrend.stable:
        return '安定';
    }
  }
}