import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;

import '../../core/themes/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/services/health_service.dart';
import '../../core/utils/chart_utils.dart';

/// ホーム画面用のシンプルな体重グラフウィジェット
class WeightChartWidgetHome extends StatefulWidget {
  final List<WeightData> weightData;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRefresh;

  const WeightChartWidgetHome({
    super.key,
    required this.weightData,
    this.isLoading = false,
    this.errorMessage,
    this.onRefresh,
  });

  @override
  State<WeightChartWidgetHome> createState() => _WeightChartWidgetHomeState();
}

class _WeightChartWidgetHomeState extends State<WeightChartWidgetHome> 
    with TickerProviderStateMixin {
  
  late AnimationController _animationController;
  late Animation<double> _chartAnimation;
  
  int? _touchedIndex;

  late List<FlSpot> _cachedWeightSpots;
  late List<FlSpot> _cachedMovingAverageSpots;
  late ChartBounds _cachedBounds;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _chartAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );
    
    _updateCachedData();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(WeightChartWidgetHome oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.weightData != widget.weightData) {
      _updateCachedData();
      _animationController.reset();
      _animationController.forward();
    }
  }

  void _updateCachedData() {
    if (widget.weightData.isNotEmpty) {
      const displayDays = 30; // 表示期間
      
      // 表示期間のデータのみを取得（移動平均計算のため全データを保持）
      _cachedWeightSpots = ChartUtils.validateChartData(
        ChartUtils.convertToFlSpots(widget.weightData, displayDays: displayDays)
      );
      _cachedMovingAverageSpots = ChartUtils.validateChartData(
        ChartUtils.calculateMovingAverage(widget.weightData, 7, displayDays: displayDays)
      );
      _cachedBounds = ChartUtils.calculateSafeBounds(
        [..._cachedWeightSpots, ..._cachedMovingAverageSpots],
        padding: 2.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: isDark 
              ? Colors.black.withOpacity(0.3)
              : Colors.grey.withOpacity(0.08),
            blurRadius: 24.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 0.w, right: 16.w, top: 20.h, bottom: 5.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildChart(context, colorScheme, isDark),
            ],
        ),
      ),
    );
  }

  Widget _buildChart(BuildContext context, ColorScheme colorScheme, bool isDark) {
    return SizedBox(
      height: 180.h,
        child: widget.isLoading
          ? _buildLoadingState(isDark)
          : widget.errorMessage != null
            ? _buildErrorState(widget.errorMessage!, isDark)
            : widget.weightData.isEmpty
              ? _buildEmptyState(isDark)
              : _buildChartContent(colorScheme, isDark),
    );
  }

  Widget _buildChartContent(ColorScheme colorScheme, bool isDark) {
    return AnimatedBuilder(
      animation: _chartAnimation,
      builder: (context, child) {
        return LineChart(
          _buildLineChartData(colorScheme, isDark),
          duration: const Duration(milliseconds: 0),
        );
      },
    );
  }

  LineChartData _buildLineChartData(ColorScheme colorScheme, bool isDark) {
    return LineChartData(
      lineBarsData: [
        _buildMainLine(isDark),
        if (_cachedMovingAverageSpots.isNotEmpty)
          _buildAverageLine(isDark),
      ],
      
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        drawVerticalLine: false,
        horizontalInterval: 2,
        getDrawingHorizontalLine: (value) => FlLine(
          color: isDark 
            ? Colors.grey[800]!.withOpacity(0.3)
            : Colors.grey[200]!,
          strokeWidth: 1,
        ),
      ),
      
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 35.w,
            getTitlesWidget: (value, meta) => _buildYAxisLabel(value, meta, isDark),
            interval: 2,
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30.h,
            getTitlesWidget: (value, meta) => _buildXAxisLabel(value, meta, isDark),
            interval: math.max(1, (_cachedWeightSpots.length / 5).round()).toDouble(),
          ),
        ),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      
      borderData: FlBorderData(show: false),
      
      lineTouchData: LineTouchData(
        enabled: true,
        touchCallback: (FlTouchEvent event, LineTouchResponse? response) {
          if (response != null && response.lineBarSpots != null && response.lineBarSpots!.isNotEmpty) {
            setState(() {
              _touchedIndex = response.lineBarSpots!.first.x.toInt();
            });
            HapticFeedback.lightImpact();
          } else {
            setState(() {
              _touchedIndex = null;
            });
          }
        },
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (touchedSpot) => isDark 
            ? Colors.grey[800]!
            : Colors.white,
          tooltipBorder: BorderSide(
            color: isDark
              ? Colors.grey[700]!
              : Colors.grey[200]!,
            width: 1,
          ),
          tooltipRoundedRadius: 12.r,
          tooltipPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          getTooltipItems: (touchedSpots) => _buildTooltipItems(touchedSpots, isDark),
        ),
        getTouchedSpotIndicator: (barData, spotIndexes) => 
          spotIndexes.map((index) => TouchedSpotIndicatorData(
            FlLine(color: Colors.transparent),
            FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                radius: 6,
                color: const Color(0xFF6366F1),
                strokeWidth: 2,
                strokeColor: Colors.white,
              ),
            ),
          )).toList(),
      ),
      
      minX: _cachedBounds.minX,
      maxX: _cachedBounds.maxX,
      minY: _cachedBounds.minY,
      maxY: _cachedBounds.maxY,
      
      backgroundColor: Colors.transparent,
    );
  }

  LineChartBarData _buildMainLine(bool isDark) {
    return LineChartBarData(
      spots: _cachedWeightSpots.asMap().entries.map((entry) {
        final progress = _chartAnimation.value;
        final index = entry.key;
        final spot = entry.value;
        final animatedY = spot.y * progress + (_cachedBounds.minY * (1 - progress));
        return FlSpot(spot.x, animatedY);
      }).toList(),
      
      isCurved: true,
      curveSmoothness: 0.3,
      barWidth: 3,
      isStrokeCapRound: true,
      
      color: const Color(0xFF6366F1),
      
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) {
          final isTouched = _touchedIndex == index;
          return FlDotCirclePainter(
            radius: isTouched ? 8 : 4,
            color: const Color(0xFF6366F1),
            strokeWidth: 2,
            strokeColor: Colors.white,
          );
        },
      ),
      
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF6366F1).withOpacity(0.2),
            const Color(0xFF6366F1).withOpacity(0.0),
          ],
        ),
      ),
    );
  }

  LineChartBarData _buildAverageLine(bool isDark) {
    return LineChartBarData(
      spots: _cachedMovingAverageSpots.asMap().entries.map((entry) {
        final progress = _chartAnimation.value;
        final spot = entry.value;
        final animatedY = spot.y * progress + (_cachedBounds.minY * (1 - progress));
        return FlSpot(spot.x, animatedY);
      }).toList(),
      
      isCurved: true,
      curveSmoothness: 0.4,
      barWidth: 2,
      isStrokeCapRound: true,
      
      color: const Color(0xFFF472B6).withOpacity(0.6),
      dashArray: [6, 3],
      
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
    );
  }

  Widget _buildYAxisLabel(double value, TitleMeta meta, bool isDark) {
    return Padding(
      padding: EdgeInsets.only(right: 4.w),
      child: Text(
        value.toStringAsFixed(0),
        style: TextStyle(
          fontSize: 10.sp,
          color: isDark ? Colors.grey[500] : Colors.grey[600],
          fontWeight: FontWeight.w400,
        ),
        textAlign: TextAlign.right,
      ),
    );
  }

  Widget _buildXAxisLabel(double value, TitleMeta meta, bool isDark) {
    final index = value.toInt();
    const displayDays = 30;
    
    // 表示期間のデータのみを使用
    final displayStartIndex = widget.weightData.length - displayDays;
    final actualIndex = displayStartIndex + index;
    
    if (actualIndex < 0 || actualIndex >= widget.weightData.length) {
      return const SizedBox.shrink();
    }

    final date = widget.weightData[actualIndex].date;
    return Padding(
      padding: EdgeInsets.only(top: 6.h),
      child: Text(
        '${date.month}/${date.day}',
        style: TextStyle(
          fontSize: 10.sp,
          color: isDark ? Colors.grey[500] : Colors.grey[600],
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  List<LineTooltipItem> _buildTooltipItems(List<LineBarSpot> touchedSpots, bool isDark) {
    return touchedSpots.map((barSpot) {
      final index = barSpot.x.toInt();
      const displayDays = 30;
      
      // 表示期間のデータのみを使用
      final displayStartIndex = widget.weightData.length - displayDays;
      final actualIndex = displayStartIndex + index;
      
      if (actualIndex >= 0 && actualIndex < widget.weightData.length) {
        final data = widget.weightData[actualIndex];
        final isAverage = barSpot.barIndex == 1;
        
        return LineTooltipItem(
          isAverage ? '平均' : '${data.date.month}月${data.date.day}日',
          TextStyle(
            color: isDark ? Colors.grey[400] : Colors.grey[600],
            fontSize: 10.sp,
            fontWeight: FontWeight.w400,
          ),
          children: [
            TextSpan(
              text: '\n${barSpot.y.toStringAsFixed(1)} kg',
              style: TextStyle(
                color: isDark ? Colors.white : Colors.grey[900],
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );
      }
      
      return LineTooltipItem('', const TextStyle());
    }).toList();
  }

  Widget _buildLoadingState(bool isDark) {
    return Center(
      child: CircularProgressIndicator(
        color: const Color(0xFF6366F1),
        strokeWidth: 2.w,
      ),
    );
  }

  Widget _buildErrorState(String error, bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 32.w,
            color: isDark ? Colors.grey[600] : Colors.grey[400],
          ),
          SizedBox(height: 8.h),
          Text(
            'データの読み込みに失敗しました',
            style: TextStyle(
              fontSize: 12.sp,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.show_chart,
            size: 32.w,
            color: isDark ? Colors.grey[600] : Colors.grey[400],
          ),
          SizedBox(height: 8.h),
          Text(
            'データがありません',
            style: TextStyle(
              fontSize: 12.sp,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}