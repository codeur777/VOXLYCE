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
import '../../../data/models/candidate_model.dart';
import '../bloc/candidate_bloc.dart';
import '../bloc/candidate_event.dart';
import '../bloc/candidate_state.dart';
import 'candidate_registration_screen.dart';

class MyCandidaturesScreen extends StatefulWidget {
  const MyCandidaturesScreen({Key? key}) : super(key: key);

  @override
  State<MyCandidaturesScreen> createState() => _MyCandidaturesScreenState();
}

class _MyCandidaturesScreenState extends State<MyCandidaturesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CandidateBloc>().add(LoadMyCandidatures());
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'PENDING':
        return AppColors.kPending;
      case 'ACCEPTED':
        return AppColors.kSuccess;
      case 'REJECTED':
        return AppColors.kError;
      case 'WITHDRAWN':
        return AppColors.kGrey;
      default:
        return AppColors.kGrey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'PENDING':
        return 'En attente';
      case 'ACCEPTED':
        return 'Acceptée';
      case 'REJECTED':
        return 'Rejetée';
      case 'WITHDRAWN':
        return 'Retirée';
      default:
        return status;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'PENDING':
        return Icons.pending;
      case 'ACCEPTED':
        return Icons.check_circle;
      case 'REJECTED':
        return Icons.cancel;
      case 'WITHDRAWN':
        return Icons.remove_circle;
      default:
        return Icons.help;
    }
  }

  void _showPaymentDialog(CandidateModel candidate) {
    final paymentRefController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Payer les Frais', style: AppTypography.kHeading3),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Montant: ${candidate.depositFeeAmount} FCFA',
              style: AppTypography.kHeading4.copyWith(
                color: AppColors.kPrimary,
              ),
            ),
            SizedBox(height: AppSpacing.md),
            TextField(
              controller: paymentRefController,
              decoration: InputDecoration(
                labelText: 'Référence de paiement',
                hintText: 'Ex: MTN123456789',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
              ),
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              'Entrez la référence de votre transaction Mobile Money',
              style: AppTypography.kCaption.copyWith(
                color: AppColors.kGrey,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              if (paymentRefController.text.isNotEmpty) {
                Navigator.pop(context);
                context.read<CandidateBloc>().add(
                      PayDepositFee(
                        candidateId: candidate.id,
                        paymentReference: paymentRefController.text,
                      ),
                    );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.kPrimary,
            ),
            child: Text('Confirmer'),
          ),
        ],
      ),
    );
  }

  void _showWithdrawConfirmation(CandidateModel candidate) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Retirer la Candidature', style: AppTypography.kHeading3),
        content: Text(
          'Êtes-vous sûr de vouloir retirer votre candidature pour le poste de ${candidate.position.name}?',
          style: AppTypography.kBody1,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<CandidateBloc>().add(
                    WithdrawCandidature(candidate.id),
                  );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.kError,
            ),
            child: Text('Retirer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kBackground,
      appBar: const CustomAppBar(
        title: 'Mes Candidatures',
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const CandidateRegistrationScreen(),
            ),
          );
        },
        backgroundColor: AppColors.kPrimary,
        icon: const Icon(Icons.add),
        label: Text('Nouvelle Candidature'),
      ),
      body: BlocConsumer<CandidateBloc, CandidateState>(
        listener: (context, state) {
          if (state is CandidateError) {
            SnackbarUtils.showError(context, state.message);
          } else if (state is PaymentCompleted) {
            SnackbarUtils.showSuccess(
              context,
              'Paiement enregistré avec succès!',
            );
            context.read<CandidateBloc>().add(LoadMyCandidatures());
          } else if (state is CandidateWithdrawn) {
            SnackbarUtils.showSuccess(context, state.message);
            context.read<CandidateBloc>().add(LoadMyCandidatures());
          }
        },
        builder: (context, state) {
          if (state is CandidateLoading) {
            return const LoadingWidget();
          }

          if (state is MyCandidaturesLoaded) {
            if (state.candidatures.isEmpty) {
              return _buildEmptyState();
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<CandidateBloc>().add(LoadMyCandidatures());
              },
              child: ListView.builder(
                padding: EdgeInsets.all(AppSpacing.md),
                itemCount: state.candidatures.length,
                itemBuilder: (context, index) {
                  final candidature = state.candidatures[index];
                  return _buildCandidatureCard(candidature);
                },
              ),
            );
          }

          return _buildEmptyState();
        },
      ),
    );
  }

  Widget _buildCandidatureCard(CandidateModel candidate) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(
          color: _getStatusColor(candidate.status).withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [AppColors.cardShadow],
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(candidate.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getStatusIcon(candidate.status),
                        size: 14.sp,
                        color: _getStatusColor(candidate.status),
                      ),
                      SizedBox(width: AppSpacing.xs),
                      Text(
                        _getStatusText(candidate.status),
                        style: AppTypography.kCaption.copyWith(
                          color: _getStatusColor(candidate.status),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                if (!candidate.depositFeePaid)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.kWarning.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.payment,
                          size: 14.sp,
                          color: AppColors.kWarning,
                        ),
                        SizedBox(width: AppSpacing.xs),
                        Text(
                          'Paiement requis',
                          style: AppTypography.kCaption.copyWith(
                            color: AppColors.kWarning,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),

            SizedBox(height: AppSpacing.sm),

            // Position
            Text(
              candidate.position.name,
              style: AppTypography.kHeading3.copyWith(
                color: AppColors.kSecondary,
              ),
            ),

            SizedBox(height: AppSpacing.xs),

            // Election Info
            Text(
              'Élection: ${candidate.position.election?.title ?? "N/A"}',
              style: AppTypography.kBody1.copyWith(
                color: AppColors.kGrey,
              ),
            ),

            SizedBox(height: AppSpacing.sm),

            // Manifesto
            Text(
              'Manifeste:',
              style: AppTypography.kCaption.copyWith(
                color: AppColors.kGrey,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: AppSpacing.xs),
            Text(
              candidate.manifesto,
              style: AppTypography.kBody1,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),

            SizedBox(height: AppSpacing.md),

            // Actions
            if (candidate.isPending) ...[
              if (!candidate.depositFeePaid)
                PrimaryButton(
                  onTap: () => _showPaymentDialog(candidate),
                  text: 'Payer ${candidate.depositFeeAmount} FCFA',
                  icon: Icons.payment,
                )
              else
                Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: AppColors.kSuccess,
                      size: 20.sp,
                    ),
                    SizedBox(width: AppSpacing.xs),
                    Text(
                      'Paiement effectué',
                      style: AppTypography.kBody1.copyWith(
                        color: AppColors.kSuccess,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              SizedBox(height: AppSpacing.sm),
              PrimaryButton(
                onTap: () => _showWithdrawConfirmation(candidate),
                text: 'Retirer la candidature',
                isOutlined: true,
                color: AppColors.kError,
              ),
            ],
          ],
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
            Icons.how_to_reg_outlined,
            size: 80.sp,
            color: AppColors.kGrey.withOpacity(0.5),
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            'Aucune candidature',
            style: AppTypography.kHeading3.copyWith(
              color: AppColors.kGrey,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            'Inscrivez-vous comme candidat pour une élection',
            style: AppTypography.kBody1.copyWith(
              color: AppColors.kGrey,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacing.lg),
          PrimaryButton(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const CandidateRegistrationScreen(),
                ),
              );
            },
            text: 'Nouvelle Candidature',
            icon: Icons.add,
          ),
        ],
      ),
    );
  }
}
