import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/appbars/custom_appbar.dart';
import '../../../core/widgets/loading/loading_widget.dart';
import '../../../core/widgets/buttons/primary_button.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../../data/models/election_model.dart';
import '../../../data/models/result_model.dart';

class ValidateResultsScreen extends StatefulWidget {
  const ValidateResultsScreen({super.key});

  @override
  State<ValidateResultsScreen> createState() => _ValidateResultsScreenState();
}

class _ValidateResultsScreenState extends State<ValidateResultsScreen> {
  bool _isLoading = true;
  List<ElectionModel> _elections = [];

  @override
  void initState() {
    super.initState();
    _loadElections();
  }

  Future<void> _loadElections() async {
    setState(() => _isLoading = true);
    try {
      // TODO: Call API to get elections with status ONGOING or COMPLETED
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock data
      _elections = [
        ElectionModel(
          id: 1,
          title: 'Élection du Comité de Classe L3 Info',
          isCommitteeVote: false,
          classroom: 'L3 Info',
          status: 'ONGOING',
          isValidated: false,
          startTime: DateTime.now().subtract(const Duration(days: 2)),
          endTime: DateTime.now().add(const Duration(hours: 2)),
        ),
        ElectionModel(
          id: 2,
          title: 'Élection du Bureau Étudiant 2024',
          isCommitteeVote: true,
          classroom: null,
          status: 'COMPLETED',
          isValidated: false,
          startTime: DateTime.now().subtract(const Duration(days: 5)),
          endTime: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ];
    } catch (e) {
      if (mounted) {
        SnackbarUtils.showError(context, 'Erreur: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _validateResults(ElectionModel election) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Valider les résultats', style: AppTypography.kHeading3),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Êtes-vous sûr de vouloir valider les résultats de :',
              style: AppTypography.kBody1,
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              election.title,
              style: AppTypography.kBody1.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: AppSpacing.md),
            Container(
              padding: EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.kWarning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning, color: AppColors.kWarning),
                  SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      'Cette action est irréversible',
                      style: AppTypography.kBody2.copyWith(
                        color: AppColors.kWarning,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Annuler', style: TextStyle(color: AppColors.kGrey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Valider', style: TextStyle(color: AppColors.kSuccess)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        // TODO: Call API
        await Future.delayed(const Duration(seconds: 1));
        
        setState(() {
          _elections.removeWhere((e) => e.id == election.id);
        });
        
        if (mounted) {
          SnackbarUtils.showSuccess(context, 'Résultats validés et publiés');
        }
      } catch (e) {
        if (mounted) {
          SnackbarUtils.showError(context, 'Erreur: ${e.toString()}');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kBackground,
      appBar: CustomAppBar(
        title: 'Validation des Résultats',
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadElections,
          ),
        ],
      ),
      body: _isLoading
          ? const LoadingWidget()
          : _elections.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: _loadElections,
                  child: ListView.builder(
                    padding: EdgeInsets.all(AppSpacing.md),
                    itemCount: _elections.length,
                    itemBuilder: (context, index) {
                      final election = _elections[index];
                      return _buildElectionCard(election);
                    },
                  ),
                ),
    );
  }

  Widget _buildElectionCard(ElectionModel election) {
    // Mock results data
    final mockResult = ResultModel(
      electionId: election.id,
      electionTitle: election.title,
      positions: [
        PositionResult(
          positionId: 1,
          positionName: 'Président',
          totalVotes: 86,
          candidates: [
            CandidateResult(
              candidateId: 1,
              candidateName: 'Jean Dupont',
              votes: 45,
              percentage: 52.3,
              isWinner: true,
            ),
            CandidateResult(
              candidateId: 2,
              candidateName: 'Marie Martin',
              votes: 35,
              percentage: 40.7,
              isWinner: false,
            ),
            CandidateResult(
              candidateId: 3,
              candidateName: 'Pierre Durand',
              votes: 6,
              percentage: 7.0,
              isWinner: false,
            ),
          ],
        ),
      ],
      totalVotes: 86,
      participationRate: 85.0,
      completedAt: election.endTime,
    );

    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        boxShadow: [AppColors.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppSpacing.radiusMd),
                topRight: Radius.circular(AppSpacing.radiusMd),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        election.title,
                        style: AppTypography.kHeading3.copyWith(
                          color: AppColors.kWhite,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.kWhite.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      ),
                      child: Text(
                        election.status == 'ONGOING' ? 'En cours' : 'Terminée',
                        style: AppTypography.kCaption.copyWith(
                          color: AppColors.kWhite,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Icon(Icons.people, color: AppColors.kWhite, size: 20.sp),
                    SizedBox(width: AppSpacing.xs),
                    Text(
                      'Participation: ${mockResult.participationRate.toStringAsFixed(1)}%',
                      style: AppTypography.kBody1.copyWith(
                        color: AppColors.kWhite,
                      ),
                    ),
                    SizedBox(width: AppSpacing.md),
                    Icon(Icons.how_to_vote, color: AppColors.kWhite, size: 20.sp),
                    SizedBox(width: AppSpacing.xs),
                    Text(
                      '${mockResult.totalVotes} votes',
                      style: AppTypography.kBody1.copyWith(
                        color: AppColors.kWhite,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Results
          Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Résultats préliminaires',
                  style: AppTypography.kHeading4,
                ),
                SizedBox(height: AppSpacing.md),

                ...mockResult.positions.map((position) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        position.positionName,
                        style: AppTypography.kBody1.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.kPrimary,
                        ),
                      ),
                      SizedBox(height: AppSpacing.sm),
                      ...position.candidates.map((candidate) {
                        return Container(
                          margin: EdgeInsets.only(bottom: AppSpacing.sm),
                          padding: EdgeInsets.all(AppSpacing.sm),
                          decoration: BoxDecoration(
                            color: candidate.isWinner
                                ? AppColors.kSuccess.withOpacity(0.1)
                                : AppColors.kGreyLight,
                            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                            border: candidate.isWinner
                                ? Border.all(color: AppColors.kSuccess, width: 2)
                                : null,
                          ),
                          child: Row(
                            children: [
                              if (candidate.isWinner)
                                Icon(
                                  Icons.emoji_events,
                                  color: AppColors.kSuccess,
                                  size: 20.sp,
                                ),
                              if (candidate.isWinner) SizedBox(width: AppSpacing.xs),
                              Expanded(
                                child: Text(
                                  candidate.candidateName,
                                  style: AppTypography.kBody1.copyWith(
                                    fontWeight: candidate.isWinner
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                              Text(
                                '${candidate.votes} votes (${candidate.percentage.toStringAsFixed(1)}%)',
                                style: AppTypography.kBody2.copyWith(
                                  color: candidate.isWinner
                                      ? AppColors.kSuccess
                                      : AppColors.kGrey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      SizedBox(height: AppSpacing.md),
                    ],
                  );
                }).toList(),

                // Validation Button
                PrimaryButton(
                  text: 'Valider et Publier les Résultats',
                  onPressed: () => _validateResults(election),
                  backgroundColor: AppColors.kSuccess,
                  icon: Icons.check_circle,
                ),
              ],
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
            'Aucun résultat à valider',
            style: AppTypography.kHeading3.copyWith(
              color: AppColors.kGrey,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            'Les élections terminées apparaîtront ici',
            style: AppTypography.kBody1.copyWith(
              color: AppColors.kGrey,
            ),
          ),
        ],
      ),
    );
  }
}

