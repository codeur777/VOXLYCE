import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/appbars/custom_appbar.dart';
import '../../../core/widgets/loading/loading_widget.dart';
import '../../../core/widgets/buttons/primary_button.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../../data/models/candidate_model.dart';

class ValidateCandidatesScreen extends StatefulWidget {
  const ValidateCandidatesScreen({super.key});

  @override
  State<ValidateCandidatesScreen> createState() => _ValidateCandidatesScreenState();
}

class _ValidateCandidatesScreenState extends State<ValidateCandidatesScreen> {
  bool _isLoading = true;
  List<CandidateModel> _candidates = [];
  String _filterStatus = 'PENDING';

  @override
  void initState() {
    super.initState();
    _loadCandidates();
  }

  Future<void> _loadCandidates() async {
    setState(() => _isLoading = true);
    try {
      // TODO: Call API
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock data
      _candidates = [
        CandidateModel(
          id: 1,
          userId: 1,
          userName: 'Jean Dupont',
          userEmail: 'jean.dupont@example.com',
          positionId: 1,
          positionName: 'Président',
          electionId: 1,
          electionTitle: 'Élection Comité L3 Info',
          manifesto: 'Je m\'engage à améliorer la communication entre les étudiants et l\'administration...',
          status: 'PENDING',
          paymentStatus: 'PAID',
          paymentAmount: 500,
          studentCardUrl: 'https://example.com/card1.jpg',
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
        CandidateModel(
          id: 2,
          userId: 2,
          userName: 'Marie Martin',
          userEmail: 'marie.martin@example.com',
          positionId: 2,
          positionName: 'Vice-Président',
          electionId: 1,
          electionTitle: 'Élection Comité L3 Info',
          manifesto: 'Mon objectif est de renforcer les liens entre les différentes promotions...',
          status: 'PENDING',
          paymentStatus: 'PAID',
          paymentAmount: 500,
          studentCardUrl: null,
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        CandidateModel(
          id: 3,
          userId: 3,
          userName: 'Pierre Durand',
          userEmail: 'pierre.durand@example.com',
          positionId: 1,
          positionName: 'Président',
          electionId: 2,
          electionTitle: 'Élection Bureau Étudiant',
          manifesto: 'Je souhaite organiser plus d\'événements culturels et sportifs...',
          status: 'ACCEPTED',
          paymentStatus: 'PAID',
          paymentAmount: 500,
          studentCardUrl: 'https://example.com/card3.jpg',
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
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

  List<CandidateModel> get filteredCandidates {
    if (_filterStatus == 'ALL') {
      return _candidates;
    }
    return _candidates.where((c) => c.status == _filterStatus).toList();
  }

  Future<void> _validateCandidate(CandidateModel candidate, bool accept) async {
    String? rejectionReason;

    if (!accept) {
      rejectionReason = await showDialog<String>(
        context: context,
        builder: (context) {
          final controller = TextEditingController();
          return AlertDialog(
            title: Text('Raison du rejet', style: AppTypography.kHeading3),
            content: TextField(
              controller: controller,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Expliquez pourquoi cette candidature est rejetée...',
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Annuler', style: TextStyle(color: AppColors.kGrey)),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, controller.text),
                child: Text('Confirmer', style: TextStyle(color: AppColors.kError)),
              ),
            ],
          );
        },
      );

      if (rejectionReason == null || rejectionReason.isEmpty) {
        return;
      }
    }

    try {
      // TODO: Call API
      await Future.delayed(const Duration(seconds: 1));
      
      setState(() {
        final index = _candidates.indexWhere((c) => c.id == candidate.id);
        if (index != -1) {
          _candidates[index] = CandidateModel(
            id: candidate.id,
            userId: candidate.userId,
            userName: candidate.userName,
            userEmail: candidate.userEmail,
            positionId: candidate.positionId,
            positionName: candidate.positionName,
            electionId: candidate.electionId,
            electionTitle: candidate.electionTitle,
            manifesto: candidate.manifesto,
            status: accept ? 'ACCEPTED' : 'REJECTED',
            paymentStatus: candidate.paymentStatus,
            paymentAmount: candidate.paymentAmount,
            studentCardUrl: candidate.studentCardUrl,
            createdAt: candidate.createdAt,
            rejectionReason: rejectionReason,
          );
        }
      });
      
      if (mounted) {
        SnackbarUtils.showSuccess(
          context,
          accept ? 'Candidature acceptée' : 'Candidature rejetée',
        );
      }
    } catch (e) {
      if (mounted) {
        SnackbarUtils.showError(context, 'Erreur: ${e.toString()}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kBackground,
      appBar: CustomAppBar(
        title: 'Validation des Candidats',
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadCandidates,
          ),
        ],
      ),
      body: Column(
        children: [
          // Filters
          Container(
            padding: EdgeInsets.all(AppSpacing.md),
            color: AppColors.kWhite,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('PENDING', 'En attente', AppColors.kWarning),
                  SizedBox(width: AppSpacing.sm),
                  _buildFilterChip('ACCEPTED', 'Acceptées', AppColors.kSuccess),
                  SizedBox(width: AppSpacing.sm),
                  _buildFilterChip('REJECTED', 'Rejetées', AppColors.kError),
                  SizedBox(width: AppSpacing.sm),
                  _buildFilterChip('ALL', 'Toutes', AppColors.kGrey),
                ],
              ),
            ),
          ),

          // Candidates List
          Expanded(
            child: _isLoading
                ? const LoadingWidget()
                : filteredCandidates.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                        onRefresh: _loadCandidates,
                        child: ListView.builder(
                          padding: EdgeInsets.all(AppSpacing.md),
                          itemCount: filteredCandidates.length,
                          itemBuilder: (context, index) {
                            final candidate = filteredCandidates[index];
                            return _buildCandidateCard(candidate);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String value, String label, Color color) {
    final isSelected = _filterStatus == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() => _filterStatus = value);
      },
      backgroundColor: AppColors.kWhite,
      selectedColor: color.withOpacity(0.2),
      labelStyle: TextStyle(
        color: isSelected ? color : AppColors.kGrey,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildCandidateCard(CandidateModel candidate) {
    final statusColor = candidate.status == 'ACCEPTED'
        ? AppColors.kSuccess
        : candidate.status == 'REJECTED'
            ? AppColors.kError
            : AppColors.kWarning;

    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        boxShadow: [AppColors.cardShadow],
        border: Border.all(
          color: statusColor.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppSpacing.radiusMd),
                topRight: Radius.circular(AppSpacing.radiusMd),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: statusColor,
                  child: Text(
                    candidate.userName[0].toUpperCase(),
                    style: TextStyle(color: AppColors.kWhite),
                  ),
                ),
                SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        candidate.userName,
                        style: AppTypography.kHeading4,
                      ),
                      Text(
                        candidate.userEmail,
                        style: AppTypography.kCaption.copyWith(
                          color: AppColors.kGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: Text(
                    candidate.status == 'PENDING'
                        ? 'En attente'
                        : candidate.status == 'ACCEPTED'
                            ? 'Acceptée'
                            : 'Rejetée',
                    style: AppTypography.kCaption.copyWith(
                      color: AppColors.kWhite,
                      fontWeight: FontWeight.bold,
                    ),
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
                // Election & Position
                Row(
                  children: [
                    Icon(Icons.how_to_vote, size: 20.sp, color: AppColors.kPrimary),
                    SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: Text(
                        candidate.electionTitle,
                        style: AppTypography.kBody1.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Icon(Icons.workspace_premium, size: 20.sp, color: AppColors.kSuccess),
                    SizedBox(width: AppSpacing.xs),
                    Text(
                      'Poste: ${candidate.positionName}',
                      style: AppTypography.kBody1,
                    ),
                  ],
                ),

                SizedBox(height: AppSpacing.md),

                // Manifesto
                Text(
                  'Manifesto:',
                  style: AppTypography.kBody1.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  candidate.manifesto,
                  style: AppTypography.kBody2.copyWith(
                    color: AppColors.kGrey,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: AppSpacing.md),

                // Payment & Card Status
                Row(
                  children: [
                    Icon(
                      candidate.paymentStatus == 'PAID'
                          ? Icons.check_circle
                          : Icons.pending,
                      size: 20.sp,
                      color: candidate.paymentStatus == 'PAID'
                          ? AppColors.kSuccess
                          : AppColors.kWarning,
                    ),
                    SizedBox(width: AppSpacing.xs),
                    Text(
                      'Paiement: ${candidate.paymentAmount} F',
                      style: AppTypography.kBody2,
                    ),
                    SizedBox(width: AppSpacing.md),
                    Icon(
                      candidate.studentCardUrl != null
                          ? Icons.badge
                          : Icons.badge_outlined,
                      size: 20.sp,
                      color: candidate.studentCardUrl != null
                          ? AppColors.kSuccess
                          : AppColors.kGrey,
                    ),
                    SizedBox(width: AppSpacing.xs),
                    Text(
                      candidate.studentCardUrl != null
                          ? 'Carte fournie'
                          : 'Pas de carte',
                      style: AppTypography.kBody2,
                    ),
                  ],
                ),

                // Rejection Reason
                if (candidate.rejectionReason != null) ...[
                  SizedBox(height: AppSpacing.md),
                  Container(
                    padding: EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: AppColors.kError.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info, color: AppColors.kError, size: 20.sp),
                        SizedBox(width: AppSpacing.xs),
                        Expanded(
                          child: Text(
                            'Raison: ${candidate.rejectionReason}',
                            style: AppTypography.kBody2.copyWith(
                              color: AppColors.kError,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // Actions (only for pending)
                if (candidate.status == 'PENDING') ...[
                  SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: PrimaryButton(
                          text: 'Accepter',
                          onPressed: () => _validateCandidate(candidate, true),
                          backgroundColor: AppColors.kSuccess,
                        ),
                      ),
                      SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: PrimaryButton(
                          text: 'Rejeter',
                          onPressed: () => _validateCandidate(candidate, false),
                          backgroundColor: AppColors.kError,
                        ),
                      ),
                    ],
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
            Icons.how_to_reg_outlined,
            size: 80.sp,
            color: AppColors.kGrey.withOpacity(0.5),
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            'Aucun candidat',
            style: AppTypography.kHeading3.copyWith(
              color: AppColors.kGrey,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            'Les candidatures apparaîtront ici',
            style: AppTypography.kBody1.copyWith(
              color: AppColors.kGrey,
            ),
          ),
        ],
      ),
    );
  }
}

