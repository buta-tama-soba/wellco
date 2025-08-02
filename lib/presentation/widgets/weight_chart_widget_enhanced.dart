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

/// 拡張版体重グラフウィジェット（グラスモーフィズム・最新UIトレンド対応）
class WeightChartWidgetEnhanced extends StatefulWidget {
  final List<WeightData> weightData;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRefresh;

  const WeightChartWidgetEnhanced({
    super.key,
    required this.weightData,
    this.isLoading = false,
    this.errorMessage,
    this.onRefresh,
  });

  @override
  State<WeightChartWidgetEnhanced> createState() => _WeightChartWidgetEnhancedState();
}

class _WeightChartWidgetEnhancedState extends State<WeightChartWidgetEnhanced> 
    with TickerProviderStateMixin {
  
  late AnimationController _animationController;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;
  
  List<FlSpot>? _touchedSpots;
  int? _selectedDataIndex;

  late List<FlSpot> _cachedWeightSpots;
  late List<FlSpot> _cachedMovingAverageSpots;
  late ChartBounds _cachedBounds;

  @override
  void initState() {
    super.initState();
    
    // アニメーションコントローラーの初期化
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    _updateCachedData();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(WeightChartWidgetEnhanced oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.weightData != widget.weightData) {
      _updateCachedData();
      _animationController.reset();
      _animationController.forward();
    }
  }

  void _updateCachedData() {
    if (widget.weightData.isNotEmpty) {
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return AnimatedBuilder(
      animation: Listenable.merge([_animationController, _pulseController]),
      builder: (context, child) {
        return Transform.scale(
          scale: 0.95 + (0.05 * _scaleAnimation.value),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: _buildGlassmorphicCard(context, colorScheme),
          ),
        );
      },
    );
  }

  Widget _buildGlassmorphicCard(BuildContext context, ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary.withOpacity(0.1),
            colorScheme.secondary.withOpacity(0.05),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.2),
            blurRadius: 20.r,
            offset: Offset(0, 10.h),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(
                color: colorScheme.primary.withOpacity(0.2),
                width: 1.5,
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.1),
                  Colors.white.withOpacity(0.05),
                ],
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(AppConstants.paddingL.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildEnhancedHeader(context, colorScheme),
                  SizedBox(height: AppConstants.paddingM.h),
                  _buildChart(context, colorScheme),
                  if (widget.weightData.isNotEmpty) ...[
                    SizedBox(height: AppConstants.paddingM.h),
                    _buildEnhancedStats(colorScheme),
                    SizedBox(height: AppConstants.paddingS.h),
                    _buildModernLegend(colorScheme),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedHeader(BuildContext context, ColorScheme colorScheme) {
    final latestWeight = widget.weightData.isNotEmpty ? widget.weightData.last.weight : 0.0;
    final previousWeight = widget.weightData.length > 1 ? widget.weightData[widget.weightData.length - 2].weight : latestWeight;
    final weightChange = latestWeight - previousWeight;
    
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '体重推移',
              style: AppTextStyles.headline2.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                Text(
                  '${latestWeight.toStringAsFixed(1)}',
                  style: AppTextStyles.headline1.copyWith(
                    color: colorScheme.primary,
                    fontSize: 36.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  'kg',
                  style: AppTextStyles.body1.copyWith(
                    color: colorScheme.primary.withOpacity(0.7),
                  ),
                ),
                SizedBox(width: 16.w),
                _buildTrendIndicator(weightChange, colorScheme),
              ],
            ),
          ],
        ),
        const Spacer(),
        if (widget.onRefresh != null)
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  colorScheme.primary.withOpacity(0.2),
                  colorScheme.secondary.withOpacity(0.1),
                ],
              ),
            ),
            child: IconButton(
              onPressed: widget.onRefresh,
              icon: Icon(
                Icons.refresh_rounded,
                color: colorScheme.primary,
                size: 24.w,
              ),
              tooltip: '更新',
            ),
          ),
      ],
    );
  }

  Widget _buildTrendIndicator(double change, ColorScheme colorScheme) {
    final isUp = change > 0;
    final color = isUp ? Colors.red : Colors.green;
    
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isUp ? Icons.trending_up : Icons.trending_down,
                  color: color,
                  size: 16.w,
                ),
                SizedBox(width: 4.w),
                Text(
                  '${change.abs().toStringAsFixed(1)}kg',
                  style: AppTextStyles.caption.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildChart(BuildContext context, ColorScheme colorScheme) {
    final chartHeight = 280.0.h;

    return SizedBox(
      height: chartHeight,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: _buildChartContent(context, colorScheme),
      ),
    );
  }

  Widget _buildChartContent(BuildContext context, ColorScheme colorScheme) {
    if (widget.isLoading) {
      return _buildModernLoadingState(colorScheme);
    }
    
    if (widget.errorMessage != null) {
      return _buildModernErrorState(widget.errorMessage!, colorScheme);
    }
    
    if (widget.weightData.isEmpty) {
      return _buildModernEmptyState(colorScheme);
    }

    return RepaintBoundary(
      child: GestureDetector(
        onTapDown: (details) => _handleChartTouch(details, context),
        child: LineChart(
          _buildEnhancedLineChartData(colorScheme),
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutCubic,
        ),
      ),
    );
  }

  void _handleChartTouch(TapDownDetails details, BuildContext context) {
    // タッチ位置に基づいてデータポイントを特定
    setState(() {
      _selectedDataIndex = (_selectedDataIndex == null) ? 0 : null;
    });
    
    HapticFeedback.lightImpact();
  }

  LineChartData _buildEnhancedLineChartData(ColorScheme colorScheme) {
    return LineChartData(
      lineBarsData: [
        _buildEnhancedWeightLine(colorScheme),
        if (_cachedMovingAverageSpots.isNotEmpty)
          _buildEnhancedMovingAverageLine(colorScheme),
      ],
      
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        drawVerticalLine: false,
        horizontalInterval: 2,
        getDrawingHorizontalLine: (value) => FlLine(
          color: colorScheme.outline.withOpacity(0.1),
          strokeWidth: 1,
          dashArray: [5, 5],
        ),
      ),
      
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 45.w,
            getTitlesWidget: (value, meta) => _buildModernYAxisTitle(value, meta, colorScheme),
            interval: 2,
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30.h,
            getTitlesWidget: (value, meta) => _buildModernXAxisTitle(value, meta, colorScheme),
            interval: math.max(1, (_cachedWeightSpots.length / 5).round()).toDouble(),
          ),
        ),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      
      borderData: FlBorderData(show: false),
      
      lineTouchData: LineTouchData(
        enabled: true,
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (touchedSpot) => colorScheme.surface.withOpacity(0.9),
          tooltipBorder: BorderSide(
            color: colorScheme.primary.withOpacity(0.3),
            width: 1,
          ),
          getTooltipItems: _buildEnhancedTooltipItems,
          tooltipRoundedRadius: 16.r,
          tooltipPadding: EdgeInsets.all(12.w),
        ),
        getTouchedSpotIndicator: (barData, spotIndexes) => 
            spotIndexes.map((index) => TouchedSpotIndicatorData(
              FlLine(
                color: colorScheme.primary,
                strokeWidth: 3,
                dashArray: [8, 4],
              ),
              FlDotData(
                getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                  radius: 8,
                  color: colorScheme.primary,
                  strokeWidth: 3,
                  strokeColor: colorScheme.surface,
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

  LineChartBarData _buildEnhancedWeightLine(ColorScheme colorScheme) {
    return LineChartBarData(
      spots: _cachedWeightSpots,
      isCurved: true,
      curveSmoothness: 0.4,
      barWidth: 4,
      isStrokeCapRound: true,
      
      gradient: LinearGradient(
        colors: [
          colorScheme.primary,
          colorScheme.secondary,
        ],
        stops: const [0.0, 1.0],
      ),
      
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) {
          final isSelected = _selectedDataIndex == index;
          return FlDotCirclePainter(
            radius: isSelected ? 8 : 5,
            color: colorScheme.primary,
            strokeWidth: 2,
            strokeColor: colorScheme.surface,
          );
        },
      ),
      
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            colorScheme.primary.withOpacity(0.3),
            colorScheme.primary.withOpacity(0.0),
          ],
          stops: const [0.0, 1.0],
        ),
      ),
      
      shadow: Shadow(
        color: colorScheme.primary.withOpacity(0.3),
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
    );
  }

  LineChartBarData _buildEnhancedMovingAverageLine(ColorScheme colorScheme) {
    return LineChartBarData(
      spots: _cachedMovingAverageSpots,
      isCurved: true,
      curveSmoothness: 0.5,
      barWidth: 2,
      isStrokeCapRound: true,
      
      color: colorScheme.tertiary.withOpacity(0.7),
      dashArray: [8, 4],
      
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
    );
  }

  Widget _buildModernYAxisTitle(double value, TitleMeta meta, ColorScheme colorScheme) {
    return Container(
      margin: EdgeInsets.only(right: 8.w),
      child: Text(
        '${value.toStringAsFixed(0)}',
        style: AppTextStyles.caption.copyWith(
          color: colorScheme.onSurface.withOpacity(0.5),
          fontSize: 11.sp,
        ),
        textAlign: TextAlign.right,
      ),
    );
  }

  Widget _buildModernXAxisTitle(double value, TitleMeta meta, ColorScheme colorScheme) {
    final index = value.toInt();
    if (index < 0 || index >= widget.weightData.length) {
      return const SizedBox.shrink();
    }

    final date = widget.weightData[index].date;
    return Transform.rotate(
      angle: -0.5,
      child: Text(
        '${date.month}/${date.day}',
        style: AppTextStyles.caption.copyWith(
          color: colorScheme.onSurface.withOpacity(0.5),
          fontSize: 10.sp,
        ),
      ),
    );
  }

  List<LineTooltipItem> _buildEnhancedTooltipItems(List<LineBarSpot> touchedSpots) {
    return touchedSpots.map((barSpot) {
      final flSpot = barSpot;
      final index = flSpot.x.toInt();
      
      if (index >= 0 && index < widget.weightData.length) {
        final data = widget.weightData[index];
        final isMovingAverage = barSpot.barIndex == 1;
        
        return LineTooltipItem(
          '${data.date.month}月${data.date.day}日\n'
          '${isMovingAverage ? "平均 " : ""}'
          '${flSpot.y.toStringAsFixed(1)} kg',
          TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 13.sp,
          ),
        );
      }
      
      return LineTooltipItem('', const TextStyle());
    }).toList();
  }

  Widget _buildEnhancedStats(ColorScheme colorScheme) {
    if (widget.weightData.isEmpty) return const SizedBox.shrink();
    
    final trend = ChartUtils.analyzeWeightTrend(widget.weightData);
    final minWeight = _cachedWeightSpots.map((s) => s.y).reduce(math.min);
    final maxWeight = _cachedWeightSpots.map((s) => s.y).reduce(math.max);
    final avgWeight = _cachedWeightSpots.map((s) => s.y).reduce((a, b) => a + b) / _cachedWeightSpots.length;
    
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary.withOpacity(0.05),
            colorScheme.secondary.withOpacity(0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: colorScheme.primary.withOpacity(0.1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('最低', minWeight, Icons.arrow_downward, Colors.blue, colorScheme),
          _buildStatItem('平均', avgWeight, Icons.remove, colorScheme.primary, colorScheme),
          _buildStatItem('最高', maxWeight, Icons.arrow_upward, Colors.orange, colorScheme),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, double value, IconData icon, Color color, ColorScheme colorScheme) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20.w),
        SizedBox(height: 4.h),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        Text(
          '${value.toStringAsFixed(1)}kg',
          style: AppTextStyles.body1.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildModernLegend(ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildModernLegendItem('実測値', colorScheme.primary, false),
        SizedBox(width: AppConstants.paddingL.w),
        if (_cachedMovingAverageSpots.isNotEmpty)
          _buildModernLegendItem('7日平均', colorScheme.tertiary, true),
      ],
    );
  }

  Widget _buildModernLegendItem(String label, Color color, bool isDashed) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 24.w,
            height: 3.h,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernLoadingState(ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  colorScheme.primary.withOpacity(0.3),
                  colorScheme.secondary.withOpacity(0.3),
                ],
              ),
            ),
            child: Center(
              child: CircularProgressIndicator(
                color: colorScheme.primary,
                strokeWidth: 3.w,
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'データを読み込んでいます...',
            style: AppTextStyles.body2.copyWith(
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernErrorState(String error, ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.error.withOpacity(0.1),
            ),
            child: Icon(
              Icons.error_outline_rounded,
              size: 48.w,
              color: colorScheme.error,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'データの読み込みに失敗しました',
            style: AppTextStyles.body1.copyWith(
              color: colorScheme.error,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'タップして再試行',
            style: AppTextStyles.caption.copyWith(
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernEmptyState(ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  colorScheme.primary.withOpacity(0.1),
                  colorScheme.secondary.withOpacity(0.05),
                ],
              ),
            ),
            child: Icon(
              Icons.insights_rounded,
              size: 56.w,
              color: colorScheme.primary.withOpacity(0.5),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'まだデータがありません',
            style: AppTextStyles.headline3.copyWith(
              color: colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            '体重を記録してグラフを表示しましょう',
            style: AppTextStyles.body2.copyWith(
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}