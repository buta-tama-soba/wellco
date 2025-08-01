import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/health_provider.dart';
import 'weight_chart_widget.dart';

class WeightChartCard extends ConsumerWidget {
  const WeightChartCard({
    super.key,
    required this.weights, // 後方互換性のため残す
  });

  final List<double> weights; // 廃止予定、WeightDataを使用

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weightHistoryAsync = ref.watch(weightHistoryProvider);

    return weightHistoryAsync.when(
      data: (weightData) => WeightChartWidget(
        weightData: weightData,
        onRefresh: () {
          ref.invalidate(weightHistoryProvider);
        },
      ),
      loading: () => WeightChartWidget(
        weightData: const [],
        isLoading: true,
      ),
      error: (error, stack) => WeightChartWidget(
        weightData: const [],
        errorMessage: error.toString(),
        onRefresh: () {
          ref.invalidate(weightHistoryProvider);
        },
      ),
    );
  }
}