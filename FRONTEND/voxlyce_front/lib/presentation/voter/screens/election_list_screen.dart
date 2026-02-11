import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/appbars/custom_appbar.dart';
import '../../../core/widgets/loading/loading_widget.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../../core/utils/date_utils.dart' as app_date;
import '../../../data/models/election_model.dart';
import '../bloc/vote_bloc.dart';
import '../bloc/vote_event.dart';
import '../bloc/vote_state.dart';
import 'vote_screen.dart';

class ElectionListScreen extends StatefulWidget {
  const ElectionListScreen({Key? key}) : super(key: key);

  @override
  State<ElectionListScreen> createState() => _ElectionListScreenState();
}

class _ElectionListScreenState extends State<ElectionListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<VoteBloc>().add(LoadElections());
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'PENDING':
        return AppColors.kPending;
      case 'ONGOING':
        return AppColors.kOngoing;
      case 'VALIDATED':
        return AppColors.kValidated;
      default:
        return AppColors.kGrey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'PENDING':
        return 'En attente';
      case 'ONGOING':
        return 'En cours';
      case 'VALIDATED':
        return 'Terminée';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kBackground,
      appBar: CustomAppBar(
        title: 'Élections',
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<VoteBloc>().add(LoadElections());
            },
          ),
        ],
      ),
      body: BlocConsumer<VoteBloc, VoteState>(
        listener: (context, state) {
          if (state is VoteError) {
            SnackbarUtils.showError(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is VoteLoading) {
            return const LoadingWidget();
          }

          if (state is ElectionsLoaded) {
            if (state.elections.isEmpty) {
              return _buildEmptyState();
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<VoteBloc>().add(LoadElections());
              },
              child: ListView.builder(
                padding: EdgeInsets.all(AppSpacing.md),
                itemCount: state.elections.length,
                itemBuilder: (context, index) {
                  final election = state.elections[index];
                  return _buildElectionCard(election);
                },
              ),
            );
          }

          return _buildEmptyState();
        },
      ),
    );
  }

  Widget _buildElectionCard(ElectionModel election) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        boxShadow: [AppColors.cardShadow],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: election.isOngoing
              ? () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => VoteScreen(election: election),
                    ),
                  );
                }
              : null,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    // Status Badge
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(election.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      ),
                      child: Text(
                        _getStatusText(election.status),
                        style: AppTypography.kCaption.copyWith(
                          color: _getStatusColor(election.status),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    // Type Badge
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.kPrimary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      ),
                      child: Text(
                        election.isCommitteeVote ? 'Comité' : 'Classe',
                        style: AppTypography.kCaption.copyWith(
                          color: AppColors.kPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: AppSpacing.sm),
                
                // Title
                Text(
                  election.title,
                  style: AppTypography.kHeading3.copyWith(
                    color: AppColors.kSecondary,
                  ),
                ),
                
                if (election.classroom != null) ...[
                  SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      Icon(
                        Icons.class_outlined,
                        size: 16.sp,
                        color: AppColors.kGrey,
                      ),
                      SizedBox(width: AppSpacing.xs),
                      Text(
                        election.classroom!,
                        style: AppTypography.kBody1.copyWith(
                          color: AppColors.kGrey,
                        ),
                      ),
                    ],
                  ),
                ],
                
                if (election.startTime != null) ...[
                  SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 16.sp,
                        color: AppColors.kGrey,
                      ),
                      SizedBox(width: AppSpacing.xs),
                      Text(
                        app_date.DateUtils.formatDateTime(election.startTime!),
                        style: AppTypography.kCaption.copyWith(
                          color: AppColors.kGrey,
                        ),
                      ),
                    ],
                  ),
                ],
                
                if (election.isOngoing) ...[
                  SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Icon(
                        Icons.how_to_vote,
                        size: 18.sp,
                        color: AppColors.kPrimary,
                      ),
                      SizedBox(width: AppSpacing.xs),
                      Text(
                        'Cliquez pour voter',
                        style: AppTypography.kBody1.copyWith(
                          color: AppColors.kPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 80.sp,
            color: AppColors.kGrey.withOpacity(0.5),
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            'Aucune élection disponible',
            style: AppTypography.kHeading3.copyWith(
              color: AppColors.kGrey,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            'Les élections apparaîtront ici',
            style: AppTypography.kBody1.copyWith(
              color: AppColors.kGrey,
            ),
          ),
        ],
      ),
    );
  }
}
