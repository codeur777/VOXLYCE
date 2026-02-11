import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

/// Indicateur de participation
class ParticipationIndicator extends StatelessWidget {
  final double participationRate;
  final int totalVoters;
  final int votedCount;

  const ParticipationIndicator({
    super.key,
    required this.participationRate,
    required this.totalVoters,
    required this.votedCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Taux de Participation',
                style: AppTypography.kHeading4,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getParticipationColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${(participationRate * 100).toStringAsFixed(1)}%',
                  style: AppTypography.kBody1.copyWith(
                    color: _getParticipationColor(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Barre de progression
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: participationRate,
              minHeight: 20,
              backgroundColor: AppColors.kGreyLight,
              valueColor: AlwaysStoppedAnimation<Color>(
                _getParticipationColor(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Statistiques
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStat(
                'Ont voté',
                votedCount.toString(),
                AppColors.kSuccess,
              ),
              _buildStat(
                'N\'ont pas voté',
                (totalVoters - votedCount).toString(),
                AppColors.kError,
              ),
              _buildStat(
                'Total électeurs',
                totalVoters.toString(),
                AppColors.kPrimary,
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Message
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _getParticipationColor().withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  _getParticipationIcon(),
                  color: _getParticipationColor(),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _getParticipationMessage(),
                    style: AppTypography.kBody2.copyWith(
                      color: _getParticipationColor(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.kHeading3.copyWith(
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTypography.kCaption.copyWith(
            color: AppColors.kGrey,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Color _getParticipationColor() {
    if (participationRate >= 0.75) {
      return AppColors.kSuccess;
    } else if (participationRate >= 0.50) {
      return AppColors.kWarning;
    } else {
      return AppColors.kError;
    }
  }

  IconData _getParticipationIcon() {
    if (participationRate >= 0.75) {
      return Icons.trending_up;
    } else if (participationRate >= 0.50) {
      return Icons.trending_flat;
    } else {
      return Icons.trending_down;
    }
  }

  String _getParticipationMessage() {
    if (participationRate >= 0.75) {
      return 'Excellente participation! Plus de 75% des électeurs ont voté.';
    } else if (participationRate >= 0.50) {
      return 'Bonne participation. Plus de la moitié des électeurs ont voté.';
    } else {
      return 'Participation faible. Moins de 50% des électeurs ont voté.';
    }
  }
}
