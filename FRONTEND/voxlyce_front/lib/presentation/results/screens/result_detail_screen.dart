import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/appbars/custom_appbar.dart';
import '../../../core/widgets/loading/loading_widget.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../../data/models/election_model.dart';
import '../bloc/result_bloc.dart';
import '../bloc/result_event.dart';
import '../bloc/result_state.dart';
import '../widgets/result_bar_chart.dart';
import '../widgets/result_pie_chart.dart';
import '../widgets/participation_indicator.dart';

class ResultDetailScreen extends StatefulWidget {
  final ElectionModel election;

  const ResultDetailScreen({
    required this.election,
    Key? key,
  }) : super(key: key);

  @override
  State<ResultDetailScreen> createState() => _ResultDetailScreenState();
}

class _ResultDetailScreenState extends State<ResultDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ResultBloc>().add(LoadElectionResults(widget.election.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kBackground,
      appBar: CustomAppBar(
        title: 'Résultats',
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              SnackbarUtils.showInfo(
                context,
                'Fonctionnalité de partage bientôt disponible',
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<ResultBloc, ResultState>(
        listener: (context, state) {
          if (state is ResultError) {
            SnackbarUtils.showError(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is ResultLoading) {
            return const LoadingWidget();
          }

          if (state is ElectionResultsLoaded) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Election Info Card
                  _buildElectionInfoCard(state),

                  SizedBox(height: AppSpacing.lg),

                  // Participation Indicator
                  ParticipationIndicator(
                    participationRate: state.result.participationRate / 100,
                    totalVoters: (state.result.totalVotes / 
                        (state.result.participationRate / 100)).round(),
                    votedCount: state.result.totalVotes,
                  ),

                  SizedBox(height: AppSpacing.lg),

                  // Results by Position
                  Text(
                    'Résultats par Poste',
                    style: AppTypography.kHeading2.copyWith(
                      color: AppColors.kSecondary,
                    ),
                  ),

                  SizedBox(height: AppSpacing.md),

                  // Position Results with Charts
                  ...state.result.positions.map((position) {
                    return _buildPositionResults(position);
                  }).toList(),
                ],
              ),
            );
          }

          return _buildEmptyState();
        },
      ),
    );
  }

  Widget _buildElectionInfoCard(ElectionResultsLoaded state) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        boxShadow: [AppColors.defaultShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.how_to_vote,
                color: AppColors.kWhite,
                size: 32.sp,
              ),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  widget.election.title,
                  style: AppTypography.kHeading2.copyWith(
                    color: AppColors.kWhite,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: AppSpacing.md),

          _buildInfoRow(
            Icons.category,
            'Type',
            widget.election.isCommitteeVote ? 'Comité' : 'Classe',
          ),

          if (widget.election.classroom != null)
            _buildInfoRow(
              Icons.class_outlined,
              'Classe',
              widget.election.classroom!,
            ),

          _buildInfoRow(
            Icons.check_circle,
            'Statut',
            widget.election.isValidated ? 'Validée' : 'En cours',
          ),

          _buildInfoRow(
            Icons.people,
            'Participation',
            '${state.result.participationRate.toStringAsFixed(1)}%',
          ),

          _buildInfoRow(
            Icons.how_to_vote,
            'Total Votes',
            '${state.result.totalVotes}',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(top: AppSpacing.sm),
      child: Row(
        children: [
          Icon(icon, color: AppColors.kWhite.withOpacity(0.8), size: 18.sp),
          SizedBox(width: AppSpacing.sm),
          Text(
            '$label: ',
            style: AppTypography.kBody1.copyWith(
              color: AppColors.kWhite.withOpacity(0.8),
            ),
          ),
          Text(
            value,
            style: AppTypography.kBody1.copyWith(
              color: AppColors.kWhite,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildMockResults() {
    // Mock data - Replace with actual results from API
    final positions = [
      {
        'name': 'Président',
        'candidates': [
          {'name': 'Jean Dupont', 'votes': 45, 'percentage': 52.3},
          {'name': 'Marie Martin', 'votes': 35, 'percentage': 40.7},
          {'name': 'Pierre Durand', 'votes': 6, 'percentage': 7.0},
        ],
      },
      {
        'name': 'Vice-Président',
        'candidates': [
          {'name': 'Sophie Bernard', 'votes': 50, 'percentage': 58.1},
          {'name': 'Luc Petit', 'votes': 36, 'percentage': 41.9},
        ],
      },
      {
        'name': 'Secrétaire',
        'candidates': [
          {'name': 'Emma Dubois', 'votes': 42, 'percentage': 48.8},
          {'name': 'Thomas Roux', 'votes': 44, 'percentage': 51.2},
        ],
      },
    ];

    return positions.map((position) {
      return _buildPositionResults(
        position['name'] as String,
        position['candidates'] as List<Map<String, dynamic>>,
      );
    }).toList();
  }

  Widget _buildPositionResults(dynamic position) {
    // Convert to PositionResult if needed
    final positionName = position.positionName as String;
    final candidates = position.candidates as List;
    final totalVotes = position.totalVotes as int;

    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.lg),
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        boxShadow: [AppColors.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Position Title
          Row(
            children: [
              Icon(
                Icons.workspace_premium,
                color: AppColors.kPrimary,
                size: 24.sp,
              ),
              SizedBox(width: AppSpacing.sm),
              Text(
                positionName,
                style: AppTypography.kHeading3.copyWith(
                  color: AppColors.kSecondary,
                ),
              ),
            ],
          ),

          SizedBox(height: AppSpacing.md),

          // Bar Chart
          ResultBarChart(
            candidates: candidates.map((c) => c.candidateName as String).toList(),
            votes: candidates.map((c) => (c.votes as int).toDouble()).toList(),
          ),

          SizedBox(height: AppSpacing.lg),

          // Pie Chart
          ResultPieChart(
            candidates: candidates.map((c) => c.candidateName as String).toList(),
            votes: candidates.map((c) => (c.votes as int).toDouble()).toList(),
          ),

          SizedBox(height: AppSpacing.md),

          // Candidates List
          ...candidates.asMap().entries.map((entry) {
            final index = entry.key;
            final candidate = entry.value;
            final isWinner = candidate.isWinner as bool;

            return _buildCandidateResult(
              candidate.candidateName as String,
              candidate.votes as int,
              candidate.percentage as double,
              isWinner,
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildCandidateResult(
    String name,
    int votes,
    double percentage,
    bool isWinner,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.sm),
      padding: EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: isWinner
            ? AppColors.kSuccess.withOpacity(0.1)
            : AppColors.kGreyLight,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: isWinner
            ? Border.all(color: AppColors.kSuccess, width: 2)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (isWinner) ...[
                Icon(
                  Icons.emoji_events,
                  color: AppColors.kSuccess,
                  size: 20.sp,
                ),
                SizedBox(width: AppSpacing.xs),
              ],
              Expanded(
                child: Text(
                  name,
                  style: AppTypography.kBody1.copyWith(
                    color: AppColors.kSecondary,
                    fontWeight: isWinner ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
              Text(
                '$votes votes',
                style: AppTypography.kBody1.copyWith(
                  color: isWinner ? AppColors.kSuccess : AppColors.kGrey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          SizedBox(height: AppSpacing.xs),

          // Progress Bar
          Stack(
            children: [
              Container(
                height: 8.h,
                decoration: BoxDecoration(
                  color: AppColors.kGreyLight,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              FractionallySizedBox(
                widthFactor: percentage / 100,
                child: Container(
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: isWinner ? AppColors.kSuccess : AppColors.kPrimary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: AppSpacing.xs),

          Text(
            '${percentage.toStringAsFixed(1)}%',
            style: AppTypography.kCaption.copyWith(
              color: isWinner ? AppColors.kSuccess : AppColors.kGrey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.poll_outlined,
            size: 80.sp,
            color: AppColors.kGrey.withOpacity(0.5),
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            'Résultats non disponibles',
            style: AppTypography.kHeading3.copyWith(
              color: AppColors.kGrey,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            'Les résultats seront disponibles après validation',
            style: AppTypography.kBody1.copyWith(
              color: AppColors.kGrey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
