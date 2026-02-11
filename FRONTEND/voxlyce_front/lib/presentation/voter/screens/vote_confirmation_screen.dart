import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/appbars/custom_appbar.dart';
import '../../../core/widgets/buttons/primary_button.dart';
import '../../../core/widgets/loading/loading_widget.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../../data/models/election_model.dart';
import '../../../data/models/candidate_model.dart';
import '../bloc/vote_bloc.dart';
import '../bloc/vote_event.dart';
import '../bloc/vote_state.dart';

class VoteConfirmationScreen extends StatelessWidget {
  final ElectionModel election;
  final Map<int, int> votes; // positionId -> candidateId
  final List<CandidateModel> candidates;

  const VoteConfirmationScreen({
    required this.election,
    required this.votes,
    required this.candidates,
    Key? key,
  }) : super(key: key);

  void _handleConfirm(BuildContext context) {
    context.read<VoteBloc>().add(
          SubmitVote(
            electionId: election.id,
            votes: votes,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kBackground,
      appBar: const CustomAppBar(
        title: 'Confirmation du vote',
      ),
      body: BlocConsumer<VoteBloc, VoteState>(
        listener: (context, state) {
          if (state is VoteSubmitted) {
            SnackbarUtils.showSuccess(context, state.message);
            // Navigate back to election list
            Navigator.of(context).popUntil((route) => route.isFirst);
          } else if (state is VoteError) {
            SnackbarUtils.showError(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is VoteLoading) {
            return const LoadingWidget();
          }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Warning Card
                      Container(
                        padding: EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: AppColors.kWarning.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                          border: Border.all(
                            color: AppColors.kWarning.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              color: AppColors.kWarning,
                              size: 28.sp,
                            ),
                            SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Text(
                                'Attention: Une fois soumis, votre vote ne peut pas être modifié.',
                                style: AppTypography.kBody1.copyWith(
                                  color: AppColors.kWarning,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      SizedBox(height: AppSpacing.xl),
                      
                      // Title
                      Text(
                        'Vérifiez vos choix',
                        style: AppTypography.kHeading2.copyWith(
                          color: AppColors.kSecondary,
                        ),
                      ),
                      
                      SizedBox(height: AppSpacing.sm),
                      
                      Text(
                        'Assurez-vous que vos sélections sont correctes avant de confirmer.',
                        style: AppTypography.kBody1.copyWith(
                          color: AppColors.kGrey,
                        ),
                      ),
                      
                      SizedBox(height: AppSpacing.lg),
                      
                      // Selected Votes
                      ...votes.entries.map((entry) {
                        final positionId = entry.key;
                        final candidateId = entry.value;
                        
                        final candidate = candidates.firstWhere(
                          (c) => c.id == candidateId,
                        );
                        
                        return _buildVoteCard(candidate);
                      }).toList(),
                    ],
                  ),
                ),
              ),
              
              // Action Buttons
              Container(
                padding: EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.kWhite,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.kBlack.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      PrimaryButton(
                        onTap: () => _handleConfirm(context),
                        text: 'Confirmer et soumettre',
                        icon: Icons.check_circle,
                      ),
                      
                      SizedBox(height: AppSpacing.sm),
                      
                      PrimaryButton(
                        onTap: () => Navigator.of(context).pop(),
                        text: 'Modifier mes choix',
                        isOutlined: true,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildVoteCard(CandidateModel candidate) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.md),
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        boxShadow: [AppColors.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Position
          Text(
            candidate.position.name,
            style: AppTypography.kCaption.copyWith(
              color: AppColors.kPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          SizedBox(height: AppSpacing.sm),
          
          // Candidate
          Row(
            children: [
              CircleAvatar(
                radius: 25.r,
                backgroundColor: AppColors.kPrimary.withOpacity(0.1),
                child: Text(
                  '${candidate.user.firstName[0]}${candidate.user.lastName[0]}',
                  style: AppTypography.kHeading4.copyWith(
                    color: AppColors.kPrimary,
                  ),
                ),
              ),
              
              SizedBox(width: AppSpacing.sm),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${candidate.user.firstName} ${candidate.user.lastName}',
                      style: AppTypography.kHeading4.copyWith(
                        color: AppColors.kSecondary,
                      ),
                    ),
                    
                    SizedBox(height: AppSpacing.xs),
                    
                    Text(
                      candidate.manifesto,
                      style: AppTypography.kCaption.copyWith(
                        color: AppColors.kGrey,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              
              Icon(
                Icons.check_circle,
                color: AppColors.kSuccess,
                size: 28.sp,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
