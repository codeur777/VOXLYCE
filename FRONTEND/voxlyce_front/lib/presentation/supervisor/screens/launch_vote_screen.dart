import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/appbars/custom_appbar.dart';
import '../../../core/widgets/buttons/primary_button.dart';
import '../../../core/widgets/loading/loading_widget.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../../data/models/election_model.dart';

class LaunchVoteScreen extends StatefulWidget {
  const LaunchVoteScreen({super.key});

  @override
  State<LaunchVoteScreen> createState() => _LaunchVoteScreenState();
}

class _LaunchVoteScreenState extends State<LaunchVoteScreen> {
  bool _isLoading = true;
  List<ElectionModel> _pendingElections = [];

  @override
  void initState() {
    super.initState();
    _loadPendingElections();
  }

  Future<void> _loadPendingElections() async {
    setState(() => _isLoading = true);
    try {
      // TODO: Call API
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock data
      _pendingElections = [
        ElectionModel(
          id: 1,
          title: 'Élection du Comité de Classe L3 Info',
          isCommitteeVote: false,
          classroom: 'L3 Info',
          status: 'PENDING',
          isValidated: false,
          startTime: DateTime.now().add(const Duration(days: 2)),
          endTime: DateTime.now().add(const Duration(days: 5)),
        ),
        ElectionModel(
          id: 2,
          title: 'Élection Délégués M1',
          isCommitteeVote: false,
          classroom: 'M1 Génie Logiciel',
          status: 'PENDING',
          isValidated: false,
          startTime: DateTime.now().add(const Duration(days: 1)),
          endTime: DateTime.now().add(const Duration(days: 4)),
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

  Future<void> _launchElection(ElectionModel election) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Lancer l\'élection', style: AppTypography.kHeading3),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Êtes-vous sûr de vouloir lancer cette élection ?',
              style: AppTypography.kBody1,
            ),
            SizedBox(height: AppSpacing.md),
            Container(
              padding: EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.kPrimary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    election.title,
                    style: AppTypography.kHeading4.copyWith(
                      color: AppColors.kPrimary,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    'Type: ${election.isCommitteeVote ? "Comité" : "Classe"}',
                    style: AppTypography.kCaption,
                  ),
                  if (election.classroom != null)
                    Text(
                      'Classe: ${election.classroom}',
                      style: AppTypography.kCaption,
                    ),
                ],
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
                      style: AppTypography.kCaption.copyWith(
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
            child: Text('Lancer', style: TextStyle(color: AppColors.kSuccess)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        // TODO: Call API
        await Future.delayed(const Duration(seconds: 1));
        
        setState(() {
          _pendingElections.removeWhere((e) => e.id == election.id);
        });
        
        if (mounted) {
          SnackbarUtils.showSuccess(context, 'Élection lancée avec succès');
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
        title: 'Lancer une Élection',
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPendingElections,
          ),
        ],
      ),
      body: _isLoading
          ? const LoadingWidget()
          : _pendingElections.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: _loadPendingElections,
                  child: ListView(
                    padding: EdgeInsets.all(AppSpacing.md),
                    children: [
                      // Info Card
                      Container(
                        padding: EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: AppColors.kInfo.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                          border: Border.all(color: AppColors.kInfo),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info, color: AppColors.kInfo),
                            SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Text(
                                'Vérifiez que tous les prérequis sont remplis avant de lancer une élection',
                                style: AppTypography.kBody2.copyWith(
                                  color: AppColors.kInfo,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: AppSpacing.lg),

                      Text(
                        'Élections en attente',
                        style: AppTypography.kHeading3.copyWith(
                          color: AppColors.kSecondary,
                        ),
                      ),

                      SizedBox(height: AppSpacing.md),

                      ..._pendingElections.map((election) {
                        return _buildElectionCard(election);
                      }).toList(),
                    ],
                  ),
                ),
    );
  }

  Widget _buildElectionCard(ElectionModel election) {
    // Mock checklist data
    final checklist = {
      'Candidats validés': true,
      'Étudiants vérifiés': true,
      'Date de début configurée': election.startTime != null,
      'Date de fin configurée': election.endTime != null,
    };

    final allReady = checklist.values.every((v) => v);

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
            child: Row(
              children: [
                Icon(
                  Icons.how_to_vote,
                  color: AppColors.kWhite,
                  size: 32.sp,
                ),
                SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        election.title,
                        style: AppTypography.kHeading3.copyWith(
                          color: AppColors.kWhite,
                        ),
                      ),
                      Text(
                        election.isCommitteeVote
                            ? 'Comité'
                            : election.classroom ?? '',
                        style: AppTypography.kBody1.copyWith(
                          color: AppColors.kWhite.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Body
          Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dates
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 20.sp, color: AppColors.kGrey),
                    SizedBox(width: AppSpacing.xs),
                    Text(
                      'Début: ${election.startTime?.day}/${election.startTime?.month}/${election.startTime?.year}',
                      style: AppTypography.kBody2.copyWith(
                        color: AppColors.kGrey,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Icon(Icons.event_available, size: 20.sp, color: AppColors.kGrey),
                    SizedBox(width: AppSpacing.xs),
                    Text(
                      'Fin: ${election.endTime?.day}/${election.endTime?.month}/${election.endTime?.year}',
                      style: AppTypography.kBody2.copyWith(
                        color: AppColors.kGrey,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: AppSpacing.md),

                // Checklist
                Text(
                  'Prérequis',
                  style: AppTypography.kBody1.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: AppSpacing.sm),

                ...checklist.entries.map((entry) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: AppSpacing.xs),
                    child: Row(
                      children: [
                        Icon(
                          entry.value ? Icons.check_circle : Icons.cancel,
                          color: entry.value ? AppColors.kSuccess : AppColors.kError,
                          size: 20.sp,
                        ),
                        SizedBox(width: AppSpacing.xs),
                        Text(
                          entry.key,
                          style: AppTypography.kBody2.copyWith(
                            color: entry.value ? AppColors.kSuccess : AppColors.kError,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),

                SizedBox(height: AppSpacing.md),

                // Launch Button
                PrimaryButton(
                  text: 'Lancer l\'Élection',
                  onPressed: allReady ? () => _launchElection(election) : null,
                  backgroundColor: AppColors.kSuccess,
                  icon: Icons.play_arrow,
                ),

                if (!allReady) ...[
                  SizedBox(height: AppSpacing.sm),
                  Text(
                    'Complétez tous les prérequis avant de lancer',
                    style: AppTypography.kCaption.copyWith(
                      color: AppColors.kError,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
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
            Icons.inbox_outlined,
            size: 80.sp,
            color: AppColors.kGrey.withOpacity(0.5),
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            'Aucune élection en attente',
            style: AppTypography.kHeading3.copyWith(
              color: AppColors.kGrey,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            'Les élections prêtes à être lancées apparaîtront ici',
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
