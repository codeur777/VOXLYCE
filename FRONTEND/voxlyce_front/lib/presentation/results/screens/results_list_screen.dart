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
import '../bloc/result_bloc.dart';
import '../bloc/result_event.dart';
import '../bloc/result_state.dart';
import 'result_detail_screen.dart';

class ResultsListScreen extends StatefulWidget {
  const ResultsListScreen({Key? key}) : super(key: key);

  @override
  State<ResultsListScreen> createState() => _ResultsListScreenState();
}

class _ResultsListScreenState extends State<ResultsListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ResultBloc>().add(LoadCompletedElections());
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'VALIDATED':
        return AppColors.kValidated;
      case 'ONGOING':
        return AppColors.kOngoing;
      default:
        return AppColors.kGrey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'VALIDATED':
        return 'Validée';
      case 'ONGOING':
        return 'En cours';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kBackground,
      appBar: CustomAppBar(
        title: 'Résultats des Élections',
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<ResultBloc>().add(LoadCompletedElections());
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

          if (state is CompletedElectionsLoaded) {
            if (state.elections.isEmpty) {
              return _buildEmptyState();
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<ResultBloc>().add(LoadCompletedElections());
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
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ResultDetailScreen(election: election),
              ),
            );
          },
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
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            election.isValidated
                                ? Icons.check_circle
                                : Icons.pending,
                            size: 14.sp,
                            color: _getStatusColor(election.status),
                          ),
                          SizedBox(width: AppSpacing.xs),
                          Text(
                            _getStatusText(election.status),
                            style: AppTypography.kCaption.copyWith(
                              color: _getStatusColor(election.status),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
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

                if (election.endTime != null) ...[
                  SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Icon(
                        Icons.event_available,
                        size: 16.sp,
                        color: AppColors.kGrey,
                      ),
                      SizedBox(width: AppSpacing.xs),
                      Text(
                        'Terminée le ${app_date.DateUtils.formatDateTime(election.endTime!)}',
                        style: AppTypography.kCaption.copyWith(
                          color: AppColors.kGrey,
                        ),
                      ),
                    ],
                  ),
                ],

                SizedBox(height: AppSpacing.md),

                // View Results Button
                Row(
                  children: [
                    Icon(
                      Icons.bar_chart,
                      size: 18.sp,
                      color: AppColors.kPrimary,
                    ),
                    SizedBox(width: AppSpacing.xs),
                    Text(
                      'Voir les résultats',
                      style: AppTypography.kBody1.copyWith(
                        color: AppColors.kPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16.sp,
                      color: AppColors.kPrimary,
                    ),
                  ],
                ),
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
            Icons.poll_outlined,
            size: 80.sp,
            color: AppColors.kGrey.withOpacity(0.5),
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            'Aucun résultat disponible',
            style: AppTypography.kHeading3.copyWith(
              color: AppColors.kGrey,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            'Les résultats des élections terminées apparaîtront ici',
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
