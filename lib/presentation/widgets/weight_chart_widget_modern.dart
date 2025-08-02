import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;
import 'dart:ui';

import '../../core/themes/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/services/health_service.dart';
import '../../core/utils/chart_utils.dart';

/// モダンダッシュボード風体重グラフウィジェット
class WeightChartWidgetModern extends StatefulWidget {
  final List<WeightData> weightData;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRefresh;

  const WeightChartWidgetModern({
    super.key,
    required this.weightData,
    this.isLoading = false,
    this.errorMessage,
    this.onRefresh,
  });

  @override
  State<WeightChartWidgetModern> createState() => _WeightChartWidgetModernState();
}

class _WeightChartWidgetModernState extends State<WeightChartWidgetModern> 
    with TickerProviderStateMixin {
  
  late AnimationController _animationController;
  late AnimationController _dotAnimationController;
  late Animation<double> _chartAnimation;
  late Animation<double> _fadeAnimation;
  
  int? _touchedIndex;
  double? _touchedValue;

  late List<FlSpot> _cachedWeightSpots;
  late List<FlSpot> _cachedMovingAverageSpots;
  late ChartBounds _cachedBounds;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _dotAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _chartAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
    ));
    
    _updateCachedData();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _dotAnimationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(WeightChartWidgetModern oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.weightData != widget.weightData) {
      _updateCachedData();
      _animationController.reset();
      _animationController.forward();
    }
  }

  void _updateCachedData() {
    if (widget.weightData.isNotEmpty) {
      final processedData = ChartUtils.downsampleData(widget.weightData, 30);
      _cachedWeightSpots = ChartUtils.validateChartData(
        ChartUtils.convertToFlSpots(processedData)
      );
      _cachedMovingAverageSpots = ChartUtils.validateChartData(
        ChartUtils.calculateMovingAverage(processedData, 7)
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
    
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Container(
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
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildChart(context, colorScheme, isDark),
                  if (widget.weightData.isNotEmpty) ...[
                    SizedBox(height: 16.h),
                    _buildProgressIndicators(colorScheme, isDark),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildModernHeader(BuildContext context, ColorScheme colorScheme, bool isDark) {
    final latestWeight = widget.weightData.isNotEmpty ? widget.weightData.last.weight : 0.0;
    final previousWeight = widget.weightData.length > 7 
      ? widget.weightData[widget.weightData.length - 8].weight 
      : latestWeight;
    final weeklyChange = latestWeight - previousWeight;
    final percentageChange = previousWeight != 0 
      ? ((weeklyChange / previousWeight) * 100).abs() 
      : 0.0;
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '体重管理',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    latestWeight.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : Colors.grey[900],
                      letterSpacing: -1,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    'kg',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w400,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              _buildChangeIndicator(weeklyChange, percentageChange, isDark),
            ],
          ),
        ),
        _buildActionButtons(colorScheme, isDark),
      ],
    );
  }

  Widget _buildChangeIndicator(double change, double percentage, bool isDark) {
    final isPositive = change >= 0;
    final color = isPositive ? const Color(0xFFFF6B6B) : const Color(0xFF4ECDC4);
    final bgColor = color.withOpacity(0.1);
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPositive ? Icons.trending_up : Icons.trending_down,
            color: color,
            size: 16.w,
          ),
          SizedBox(width: 4.w),
          Text(
            '${change.abs().toStringAsFixed(1)}kg (${percentage.toStringAsFixed(1)}%)',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            '今週',
            style: TextStyle(
              fontSize: 12.sp,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(ColorScheme colorScheme, bool isDark) {
    return Row(
      children: [
        _buildIconButton(
          Icons.calendar_today_outlined,
          () => _showDateRangePicker(context),
          isDark,
        ),
        SizedBox(width: 8.w),
        _buildIconButton(
          Icons.download_outlined,
          () => _exportData(),
          isDark,
        ),
        if (widget.onRefresh != null) ...[
          SizedBox(width: 8.w),
          _buildIconButton(
            Icons.refresh,
            widget.onRefresh!,
            isDark,
          ),
        ],
      ],
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onTap, bool isDark) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[800] : Colors.grey[100],
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Icon(
          icon,
          size: 20.w,
          color: isDark ? Colors.grey[300] : Colors.grey[700],
        ),
      ),
    );
  }

  Widget _buildChart(BuildContext context, ColorScheme colorScheme, bool isDark) {
    return SizedBox(
      height: 240.h,
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
            reservedSize: 40.w,
            getTitlesWidget: (value, meta) => _buildYAxisLabel(value, meta, isDark),
            interval: 2,
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40.h,
            getTitlesWidget: (value, meta) => _buildXAxisLabel(value, meta, isDark),
            interval: math.max(1, (_cachedWeightSpots.length / 6).round()).toDouble(),
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
              _touchedValue = response.lineBarSpots!.first.y;
            });
            _dotAnimationController.forward(from: 0);
            HapticFeedback.lightImpact();
          } else {
            setState(() {
              _touchedIndex = null;
              _touchedValue = null;
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
      padding: EdgeInsets.only(right: 8.w),
      child: Text(
        value.toStringAsFixed(0),
        style: TextStyle(
          fontSize: 11.sp,
          color: isDark ? Colors.grey[500] : Colors.grey[600],
          fontWeight: FontWeight.w400,
        ),
        textAlign: TextAlign.right,
      ),
    );
  }

  Widget _buildXAxisLabel(double value, TitleMeta meta, bool isDark) {
    final index = value.toInt();
    if (index < 0 || index >= widget.weightData.length) {
      return const SizedBox.shrink();
    }

    final date = widget.weightData[index].date;
    return Padding(
      padding: EdgeInsets.only(top: 8.h),
      child: Text(
        '${date.month}/${date.day}',
        style: TextStyle(
          fontSize: 11.sp,
          color: isDark ? Colors.grey[500] : Colors.grey[600],
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  List<LineTooltipItem> _buildTooltipItems(List<LineBarSpot> touchedSpots, bool isDark) {
    return touchedSpots.map((barSpot) {
      final index = barSpot.x.toInt();
      
      if (index >= 0 && index < widget.weightData.length) {
        final data = widget.weightData[index];
        final isAverage = barSpot.barIndex == 1;
        
        return LineTooltipItem(
          isAverage ? '平均' : '${data.date.month}月${data.date.day}日',
          TextStyle(
            color: isDark ? Colors.grey[400] : Colors.grey[600],
            fontSize: 11.sp,
            fontWeight: FontWeight.w400,
          ),
          children: [
            TextSpan(
              text: '\n${barSpot.y.toStringAsFixed(1)} kg',
              style: TextStyle(
                color: isDark ? Colors.white : Colors.grey[900],
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );
      }
      
      return LineTooltipItem('', const TextStyle());
    }).toList();
  }

  Widget _buildProgressIndicators(ColorScheme colorScheme, bool isDark) {
    if (widget.weightData.length < 2) return const SizedBox.shrink();
    
    final latestWeight = widget.weightData.last.weight;
    final targetWeight = 65.0; // 目標体重（仮）
    final progress = ((latestWeight - targetWeight).abs() / 10 * 100).clamp(0.0, 100.0);
    
    return Column(
      children: [
        _buildMetricRow(isDark),
        SizedBox(height: 20.h),
        _buildProgressBar(progress, targetWeight, latestWeight, isDark),
      ],
    );
  }

  Widget _buildMetricRow(bool isDark) {
    final avgWeight = _cachedWeightSpots.map((s) => s.y).reduce((a, b) => a + b) / _cachedWeightSpots.length;
    final minWeight = _cachedWeightSpots.map((s) => s.y).reduce(math.min);
    final maxWeight = _cachedWeightSpots.map((s) => s.y).reduce(math.max);
    
    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            '平均',
            avgWeight.toStringAsFixed(1),
            'kg',
            const Color(0xFF6366F1),
            isDark,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildMetricCard(
            '最低',
            minWeight.toStringAsFixed(1),
            'kg',
            const Color(0xFF4ECDC4),
            isDark,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildMetricCard(
            '最高',
            maxWeight.toStringAsFixed(1),
            'kg',
            const Color(0xFFF472B6),
            isDark,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard(String label, String value, String unit, Color color, bool isDark) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.grey[50],
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : Colors.grey[900],
                ),
              ),
              SizedBox(width: 4.w),
              Text(
                unit,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(double progress, double target, double current, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '目標達成まで',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.grey[400] : Colors.grey[700],
              ),
            ),
            Text(
              '${(current - target).abs().toStringAsFixed(1)}kg',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF6366F1),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Container(
          height: 8.h,
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[800] : Colors.grey[200],
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeOutCubic,
                    width: constraints.maxWidth * (progress / 100),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                      ),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
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
            size: 48.w,
            color: isDark ? Colors.grey[600] : Colors.grey[400],
          ),
          SizedBox(height: 16.h),
          Text(
            'データの読み込みに失敗しました',
            style: TextStyle(
              fontSize: 14.sp,
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
            size: 48.w,
            color: isDark ? Colors.grey[600] : Colors.grey[400],
          ),
          SizedBox(height: 16.h),
          Text(
            'データがありません',
            style: TextStyle(
              fontSize: 14.sp,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  void _showDateRangePicker(BuildContext context) {
    // 日付範囲選択の実装
    HapticFeedback.selectionClick();
  }

  void _exportData() {
    // データエクスポートの実装
    HapticFeedback.mediumImpact();
  }
}