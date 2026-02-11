import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

/// Graphique camembert pour les résultats
class ResultPieChart extends StatelessWidget {
  final List<String> candidates;
  final List<double> votes;

  const ResultPieChart({
    super.key,
    required this.candidates,
    required this.votes,
  });

  double get totalVotes => votes.reduce((a, b) => a + b);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Répartition des Votes',
            style: AppTypography.kHeading4,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                      sections: _buildPieSections(),
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {},
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _buildLegend(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildPieSections() {
    return votes.asMap().entries.map((entry) {
      final index = entry.key;
      final voteCount = entry.value;
      final percentage = (voteCount / totalVotes) * 100;

      return PieChartSectionData(
        color: _getPieColor(index),
        value: voteCount,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 80,
        titleStyle: AppTypography.kBody2.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      );
    }).toList();
  }

  Widget _buildLegend() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: candidates.length,
      itemBuilder: (context, index) {
        final candidateName = candidates[index];
        final voteCount = votes[index];
        final percentage = (voteCount / totalVotes) * 100;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: _getPieColor(index),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      candidateName,
                      style: AppTypography.kBody2.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${voteCount.toInt()} votes (${percentage.toStringAsFixed(1)}%)',
                      style: AppTypography.kCaption.copyWith(
                        color: AppColors.kGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getPieColor(int index) {
    final colors = [
      AppColors.kPrimary,
      AppColors.kSuccess,
      AppColors.kWarning,
      AppColors.kInfo,
      AppColors.kSecondary,
      AppColors.kError,
    ];
    return colors[index % colors.length];
  }
}
