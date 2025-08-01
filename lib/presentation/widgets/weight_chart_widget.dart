import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;

import '../../core/themes/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/services/health_service.dart';
import '../../core/utils/chart_utils.dart';

/// 体重グラフウィジェット（Material Design 3準拠）
class WeightChartWidget extends StatefulWidget {
  final List<WeightData> weightData;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRefresh;

  const WeightChartWidget({
    super.key,
    required this.weightData,
    this.isLoading = false,
    this.errorMessage,
    this.onRefresh,
  });

  @override
  State<WeightChartWidget> createState() => _WeightChartWidgetState();
}

class _WeightChartWidgetState extends State<WeightChartWidget> 
    with AutomaticKeepAliveClientMixin {
  
  @override
  bool get wantKeepAlive => true; // ウィジェットの状態を保持

  late List<FlSpot> _cachedWeightSpots;
  late List<FlSpot> _cachedMovingAverageSpots;
  late ChartBounds _cachedBounds;

  @override
  void initState() {
    super.initState();
    _updateCachedData();
  }

  @override
  void didUpdateWidget(WeightChartWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.weightData != widget.weightData) {
      _updateCachedData();
    }
  }

  void _updateCachedData() {
    if (widget.weightData.isNotEmpty) {
      // 最大90ポイントに制限してパフォーマンス向上
      final processedData = ChartUtils.downsampleData(widget.weightData, 90);
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
    super.build(context);
    
    return Semantics(
      container: true,
      label: '体重推移グラフ',
      hint: '過去3ヶ月の体重変化と1週間移動平均を表示しています。タップして詳細を確認できます',
      child: _buildChartCard(context),
    );
  }

  Widget _buildChartCard(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerLow,
      child: Padding(
        padding: EdgeInsets.all(AppConstants.paddingM.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, colorScheme),
            SizedBox(height: AppConstants.paddingM.h),
            _buildChart(context, colorScheme),
            if (widget.weightData.isNotEmpty) ...[
              SizedBox(height: AppConstants.paddingS.h),
              _buildLegend(colorScheme),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ColorScheme colorScheme) {
    return Row(
      children: [
        Text(
          '体重推移',
          style: AppTextStyles.headline3.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
        const Spacer(),
        if (widget.onRefresh != null)
          IconButton(
            onPressed: widget.onRefresh,
            icon: Icon(
              Icons.refresh_rounded,
              color: colorScheme.primary,
              size: 20.w,
            ),
            tooltip: '更新',
          ),
      ],
    );
  }

  Widget _buildChart(BuildContext context, ColorScheme colorScheme) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    final chartHeight = isSmallScreen ? 250.0 : 300.0;

    return SizedBox(
      height: chartHeight.h,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _buildChartContent(context, colorScheme, isSmallScreen),
      ),
    );
  }

  Widget _buildChartContent(BuildContext context, ColorScheme colorScheme, bool isSmallScreen) {
    if (widget.isLoading) {
      return _buildLoadingState(colorScheme);
    }
    
    if (widget.errorMessage != null) {
      return _buildErrorState(widget.errorMessage!, colorScheme);
    }
    
    if (widget.weightData.isEmpty) {
      return _buildEmptyState(colorScheme);
    }

    return RepaintBoundary(
      child: GestureDetector(
        onTap: () => _announceChartData(context),
        child: LineChart(
          _buildLineChartData(colorScheme, isSmallScreen),
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOutCubic,
        ),
      ),
    );
  }

  LineChartData _buildLineChartData(ColorScheme colorScheme, bool isSmallScreen) {
    return LineChartData(
      lineBarsData: [
        _buildWeightLine(colorScheme),
        if (_cachedMovingAverageSpots.isNotEmpty)
          _buildMovingAverageLine(colorScheme),
      ],
      
      gridData: FlGridData(
        show: !isSmallScreen,
        drawHorizontalLine: true,
        drawVerticalLine: false,
        horizontalInterval: ChartUtils.getOptimalInterval(_cachedWeightSpots.length),
        getDrawingHorizontalLine: (value) => FlLine(
          color: colorScheme.outline.withOpacity(0.3),
          strokeWidth: 1,
        ),
      ),
      
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: isSmallScreen ? 35.w : 40.w,
            getTitlesWidget: (value, meta) => _buildYAxisTitle(value, meta, colorScheme),
            interval: 1,
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 25.h,
            getTitlesWidget: (value, meta) => _buildXAxisTitle(value, meta, colorScheme),
            interval: math.max(1, (_cachedWeightSpots.length / 6).round()).toDouble(),
          ),
        ),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      
      borderData: FlBorderData(
        show: true,
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.3),
          width: 1,
        ),
      ),
      
      lineTouchData: LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (touchedSpot) => colorScheme.surface,
          tooltipBorder: BorderSide(color: colorScheme.outline),
          getTooltipItems: _buildTooltipItems,
          tooltipRoundedRadius: 8,
        ),
        getTouchedSpotIndicator: (barData, spotIndexes) => 
            spotIndexes.map((index) => TouchedSpotIndicatorData(
              FlLine(
                color: colorScheme.primary,
                strokeWidth: 2,
                dashArray: [5, 5],
              ),
              FlDotData(
                getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                  radius: 6,
                  color: colorScheme.primary,
                  strokeWidth: 2,
                  strokeColor: colorScheme.surface,
                ),
              ),
            )).toList(),
      ),
      
      minX: _cachedBounds.minX,
      maxX: _cachedBounds.maxX,
      minY: _cachedBounds.minY,
      maxY: _cachedBounds.maxY,
    );
  }

  LineChartBarData _buildWeightLine(ColorScheme colorScheme) {
    return LineChartBarData(
      spots: _cachedWeightSpots,
      isCurved: true,
      curveSmoothness: 0.3,
      color: colorScheme.primary,
      barWidth: 3,
      
      dotData: FlDotData(
        show: _cachedWeightSpots.length <= 30, // データが少ない時のみドット表示
        getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
          radius: 4,
          color: colorScheme.primary,
          strokeWidth: 2,
          strokeColor: colorScheme.surface,
        ),
      ),
      
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            colorScheme.primary.withOpacity(0.3),
            colorScheme.primary.withOpacity(0.1),
          ],
        ),
      ),
    );
  }

  LineChartBarData _buildMovingAverageLine(ColorScheme colorScheme) {
    return LineChartBarData(
      spots: _cachedMovingAverageSpots,
      isCurved: true,
      curveSmoothness: 0.4,
      color: colorScheme.secondary,
      barWidth: 2,
      dashArray: [5, 5],
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
    );
  }

  Widget _buildYAxisTitle(double value, TitleMeta meta, ColorScheme colorScheme) {
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        '${value.toStringAsFixed(0)}kg',
        style: AppTextStyles.caption.copyWith(
          color: colorScheme.onSurface,
          fontSize: 10.sp,
        ),
      ),
    );
  }

  Widget _buildXAxisTitle(double value, TitleMeta meta, ColorScheme colorScheme) {
    final index = value.toInt();
    if (index < 0 || index >= widget.weightData.length) {
      return const SizedBox.shrink();
    }

    final date = widget.weightData[index].date;
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        ChartUtils.formatDateForAxis(date, widget.weightData.length),
        style: AppTextStyles.caption.copyWith(
          color: colorScheme.onSurface,
          fontSize: 9.sp,
        ),
      ),
    );
  }

  List<LineTooltipItem> _buildTooltipItems(List<LineBarSpot> touchedSpots) {
    return touchedSpots.map((barSpot) {
      final flSpot = barSpot;
      final index = flSpot.x.toInt();
      
      if (index >= 0 && index < widget.weightData.length) {
        final data = widget.weightData[index];
        final isMovingAverage = barSpot.barIndex == 1;
        
        return LineTooltipItem(
          '${data.date.month}/${data.date.day}\n'
          '${isMovingAverage ? "平均: " : "体重: "}'
          '${flSpot.y.toStringAsFixed(1)}kg',
          TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12.sp,
          ),
        );
      }
      
      return LineTooltipItem('', const TextStyle());
    }).toList();
  }

  Widget _buildLegend(ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem('実測値', colorScheme.primary, false),
        SizedBox(width: AppConstants.paddingM.w),
        if (_cachedMovingAverageSpots.isNotEmpty)
          _buildLegendItem('7日平均', colorScheme.secondary, true),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color, bool isDashed) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 20.w,
          height: 3.h,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(1.5.r),
          ),
          child: isDashed ? CustomPaint(
            painter: DashedLinePainter(color: color),
          ) : null,
        ),
        SizedBox(width: 4.w),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontSize: 11.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState(ColorScheme colorScheme) {
    return Container(
      alignment: Alignment.center,
      child: CircularProgressIndicator(
        color: colorScheme.primary,
        strokeWidth: 2.w,
      ),
    );
  }

  Widget _buildErrorState(String error, ColorScheme colorScheme) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 48.w,
            color: colorScheme.error,
          ),
          SizedBox(height: AppConstants.paddingS.h),
          Text(
            'グラフの表示中にエラーが発生しました',
            style: AppTextStyles.body2.copyWith(
              color: colorScheme.error,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ColorScheme colorScheme) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.show_chart_rounded,
            size: 48.w,
            color: colorScheme.outline,
          ),
          SizedBox(height: AppConstants.paddingS.h),
          Text(
            '体重データがありません',
            style: AppTextStyles.body2.copyWith(
              color: colorScheme.outline,
            ),
          ),
          SizedBox(height: AppConstants.paddingS.h),
          Text(
            'HealthKitから体重データを取得するか、\n手動で記録してください',
            style: AppTextStyles.caption.copyWith(
              color: colorScheme.outline,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _announceChartData(BuildContext context) {
    if (widget.weightData.isEmpty) {
      SystemSound.play(SystemSoundType.click);
      return;
    }

    final trend = ChartUtils.analyzeWeightTrend(widget.weightData);
    final latestWeight = widget.weightData.last.weight;

    // 簡易的なフィードバック
    SystemSound.play(SystemSoundType.click);
    
    // 必要に応じて、ScaffoldMessengerでスナックバーを表示
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('最新体重: ${latestWeight.toStringAsFixed(1)}kg (${trend.displayName})'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

/// 破線描画用のカスタムペインター
class DashedLinePainter extends CustomPainter {
  final Color color;

  DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final dashWidth = 3.0;
    final dashSpace = 2.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(math.min(startX + dashWidth, size.width), size.height / 2),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}