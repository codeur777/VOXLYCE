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
import 'vote_confirmation_screen.dart';

class VoteScreen extends StatefulWidget {
  final ElectionModel election;

  const VoteScreen({
    required this.election,
    Key? key,
  }) : super(key: key);

  @override
  State<VoteScreen> createState() => _VoteScreenState();
}

class _VoteScreenState extends State<VoteScreen> {
  final Map<int, int> _selectedVotes = {}; // positionId -> candidateId
  List<CandidateModel> _candidates = [];
  Map<String, dynamic> _votingStatus = {};

  @override
  void initState() {
    super.initState();
    context.read<VoteBloc>().add(LoadElectionDetails(widget.election.id));
  }

  bool get _canSubmit {
    // Check if all positions have a vote
    final positions = widget.election.positions ?? [];
    return positions.every((position) => _selectedVotes.containsKey(position.id));
  }

  void _handleSubmit() {
    if (!_canSubmit) {
      SnackbarUtils.showWarning(
        context,
        'Veuillez voter pour tous les postes',
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => VoteConfirmationScreen(
          election: widget.election,
          votes: _selectedVotes,
          candidates: _candidates,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kBackground,
      appBar: CustomAppBar(
        title: widget.election.title,
      ),
      body: BlocConsumer<VoteBloc, VoteState>(
        listener: (context, state) {
          if (state is VoteError) {
            SnackbarUtils.showError(context, state.message);
          } else if (state is ElectionDetailsLoaded) {
            setState(() {
              _candidates = state.candidates;
              _votingStatus = state.votingStatus;
            });

            // Check if already voted
            if (_votingStatus['hasVoted'] == true) {
              SnackbarUtils.showInfo(
                context,
                'Vous avez déjà voté pour cette élection',
              );
              Navigator.of(context).pop();
            }
          }
        },
        builder: (context, state) {
          if (state is VoteLoading) {
            return const LoadingWidget();
          }

          if (state is ElectionDetailsLoaded) {
            final positions = state.election.positions ?? [];

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(AppSpacing.md),
                    itemCount: positions.length,
                    itemBuilder: (context, index) {
                      final position = positions[index];
                      final positionCandidates = _candidates
                          .where((c) => c.position.id == position.id)
                          .toList();

                      return _buildPositionSection(
                        position.name,
                        position.id,
                        positionCandidates,
                      );
                    },
                  ),
                ),
                
                // Submit Button
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
                    child: PrimaryButton(
                      onTap: _handleSubmit,
                      text: 'Confirmer mon vote',
                      icon: Icons.check_circle_outline,
                      isDisabled: !_canSubmit,
                    ),
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildPositionSection(
    String positionName,
    int positionId,
    List<CandidateModel> candidates,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Position Title
          Text(
            positionName,
            style: AppTypography.kHeading3.copyWith(
              color: AppColors.kSecondary,
            ),
          ),
          
          SizedBox(height: AppSpacing.sm),
          
          Text(
            'Sélectionnez un candidat',
            style: AppTypography.kBody1.copyWith(
              color: AppColors.kGrey,
            ),
          ),
          
          SizedBox(height: AppSpacing.md),
          
          // Candidates
          ...candidates.map((candidate) {
            final isSelected = _selectedVotes[positionId] == candidate.id;
            
            return _buildCandidateCard(
              candidate,
              isSelected,
              () {
                setState(() {
                  _selectedVotes[positionId] = candidate.id;
                });
              },
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildCandidateCard(
    CandidateModel candidate,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(
          color: isSelected ? AppColors.kPrimary : AppColors.kGreyLight,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: isSelected
            ? [AppColors.defaultShadow]
            : [AppColors.cardShadow],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 30.r,
                  backgroundColor: AppColors.kPrimary.withOpacity(0.1),
                  child: Text(
                    '${candidate.user.firstName[0]}${candidate.user.lastName[0]}',
                    style: AppTypography.kHeading3.copyWith(
                      color: AppColors.kPrimary,
                    ),
                  ),
                ),
                
                SizedBox(width: AppSpacing.md),
                
                // Info
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
                
                // Selection Indicator
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: AppColors.kPrimary,
                    size: 28.sp,
                  )
                else
                  Icon(
                    Icons.radio_button_unchecked,
                    color: AppColors.kGrey,
                    size: 28.sp,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
