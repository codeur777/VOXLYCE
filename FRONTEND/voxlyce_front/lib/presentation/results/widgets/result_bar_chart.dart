import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

/// Graphique en barres pour les résultats
class ResultBarChart extends StatelessWidget {
  final List<String> candidates;
  final List<double> votes;

  const ResultBarChart({
    super.key,
    required this.candidates,
    required this.votes,
  });

  double get maxVotes => votes.reduce((a, b) => a > b ? a : b);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
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
            'Votes par Candidat',
            style: AppTypography.kHeading4,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxVotes + (maxVotes * 0.1),
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final candidateName = candidates[groupIndex];
                      final voteCount = votes[groupIndex];
                      return BarTooltipItem(
                        '$candidateName\n',
                        AppTypography.kBody2.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: '${voteCount.toInt()} votes',
                            style: AppTypography.kCaption.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 && value.toInt() < candidates.length) {
                          final candidateName = candidates[value.toInt()];
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              _getShortName(candidateName),
                              style: AppTypography.kCaption,
                              textAlign: TextAlign.center,
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: AppTypography.kCaption,
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxVotes / 5,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: AppColors.kGreyLight,
                      strokeWidth: 1,
                    );
                  },
                ),
                borderData: FlBorderData(
                  show: false,
                ),
                barGroups: votes.asMap().entries.map((entry) {
                  final index = entry.key;
                  final voteCount = entry.value;
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: voteCount,
                        color: _getBarColor(index),
                        width: 30,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getShortName(String fullName) {
    final parts = fullName.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}. ${parts[1]}';
    }
    return fullName.length > 10 ? '${fullName.substring(0, 10)}...' : fullName;
  }

  Color _getBarColor(int index) {
    final colors = [
      AppColors.kPrimary,
      AppColors.kSuccess,
      AppColors.kWarning,
      AppColors.kInfo,
      AppColors.kSecondary,
    ];
    return colors[index % colors.length];
  }
}
