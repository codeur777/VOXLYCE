import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/appbars/custom_appbar.dart';
import '../../../core/widgets/buttons/primary_button.dart';
import '../../../core/widgets/inputs/custom_text_field.dart';
import '../../../core/widgets/loading/loading_widget.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../../core/utils/validators.dart';
import '../../../data/models/election_model.dart';
import '../../../data/models/position_model.dart';
import '../../voter/bloc/vote_bloc.dart';
import '../../voter/bloc/vote_event.dart';
import '../../voter/bloc/vote_state.dart';
import '../bloc/candidate_bloc.dart';
import '../bloc/candidate_event.dart';
import '../bloc/candidate_state.dart';

class CandidateRegistrationScreen extends StatefulWidget {
  const CandidateRegistrationScreen({Key? key}) : super(key: key);

  @override
  State<CandidateRegistrationScreen> createState() =>
      _CandidateRegistrationScreenState();
}

class _CandidateRegistrationScreenState
    extends State<CandidateRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _manifestoController = TextEditingController();

  ElectionModel? _selectedElection;
  PositionModel? _selectedPosition;
  List<ElectionModel> _elections = [];

  @override
  void initState() {
    super.initState();
    context.read<VoteBloc>().add(LoadElections());
  }

  @override
  void dispose() {
    _manifestoController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      if (_selectedPosition == null) {
        SnackbarUtils.showWarning(
          context,
          'Veuillez sélectionner un poste',
        );
        return;
      }

      context.read<CandidateBloc>().add(
            RegisterCandidate(
              positionId: _selectedPosition!.id,
              manifesto: _manifestoController.text.trim(),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kBackground,
      appBar: const CustomAppBar(
        title: 'Inscription Candidat',
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<VoteBloc, VoteState>(
            listener: (context, state) {
              if (state is ElectionsLoaded) {
                setState(() {
                  _elections = state.elections
                      .where((e) => e.isPending)
                      .toList();
                });
              }
            },
          ),
          BlocListener<CandidateBloc, CandidateState>(
            listener: (context, state) {
              if (state is CandidateRegistered) {
                SnackbarUtils.showSuccess(
                  context,
                  'Candidature enregistrée avec succès!',
                );
                Navigator.of(context).pop();
              } else if (state is CandidateError) {
                SnackbarUtils.showError(context, state.message);
              }
            },
          ),
        ],
        child: BlocBuilder<CandidateBloc, CandidateState>(
          builder: (context, state) {
            if (state is CandidateLoading) {
              return const LoadingWidget();
            }

            return SingleChildScrollView(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Info Card
                    Container(
                      padding: EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.kInfo.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                        border: Border.all(
                          color: AppColors.kInfo.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: AppColors.kInfo,
                            size: 24.sp,
                          ),
                          SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              'Frais de candidature: 500 FCFA\nCarte étudiante requise pour validation',
                              style: AppTypography.kBody1.copyWith(
                                color: AppColors.kInfo,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: AppSpacing.xl),

                    // Election Selection
                    Text(
                      'Sélectionner une Élection',
                      style: AppTypography.kHeading4.copyWith(
                        color: AppColors.kSecondary,
                      ),
                    ),

                    SizedBox(height: AppSpacing.sm),

                    Container(
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.kWhite,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                        border: Border.all(color: AppColors.kGreyLight),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<ElectionModel>(
                          value: _selectedElection,
                          hint: Text('Choisir une élection'),
                          isExpanded: true,
                          items: _elections.map((election) {
                            return DropdownMenuItem(
                              value: election,
                              child: Text(election.title),
                            );
                          }).toList(),
                          onChanged: (election) {
                            setState(() {
                              _selectedElection = election;
                              _selectedPosition = null;
                            });
                          },
                        ),
                      ),
                    ),

                    SizedBox(height: AppSpacing.lg),

                    // Position Selection
                    if (_selectedElection != null) ...[
                      Text(
                        'Sélectionner un Poste',
                        style: AppTypography.kHeading4.copyWith(
                          color: AppColors.kSecondary,
                        ),
                      ),

                      SizedBox(height: AppSpacing.sm),

                      Container(
                        padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                        decoration: BoxDecoration(
                          color: AppColors.kWhite,
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusMd),
                          border: Border.all(color: AppColors.kGreyLight),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<PositionModel>(
                            value: _selectedPosition,
                            hint: Text('Choisir un poste'),
                            isExpanded: true,
                            items: _selectedElection!.positions?.map((position) {
                              return DropdownMenuItem(
                                value: position,
                                child: Text(position.name),
                              );
                            }).toList(),
                            onChanged: (position) {
                              setState(() {
                                _selectedPosition = position;
                              });
                            },
                          ),
                        ),
                      ),

                      SizedBox(height: AppSpacing.lg),
                    ],

                    // Manifesto
                    Text(
                      'Votre Manifeste',
                      style: AppTypography.kHeading4.copyWith(
                        color: AppColors.kSecondary,
                      ),
                    ),

                    SizedBox(height: AppSpacing.sm),

                    CustomTextField(
                      controller: _manifestoController,
                      label: 'Manifeste',
                      hint: 'Décrivez votre programme et vos objectifs...',
                      maxLines: 8,
                      validator: (value) =>
                          Validators.minLength(value, 50, 'Le manifeste'),
                    ),

                    SizedBox(height: AppSpacing.sm),

                    Text(
                      'Minimum 50 caractères',
                      style: AppTypography.kCaption.copyWith(
                        color: AppColors.kGrey,
                      ),
                    ),

                    SizedBox(height: AppSpacing.xxl),

                    // Submit Button
                    PrimaryButton(
                      onTap: _handleSubmit,
                      text: 'Soumettre ma Candidature',
                      icon: Icons.how_to_reg,
                    ),

                    SizedBox(height: AppSpacing.md),

                    // Info Text
                    Center(
                      child: Text(
                        'Après soumission, vous devrez payer les frais\net télécharger votre carte étudiante',
                        style: AppTypography.kCaption.copyWith(
                          color: AppColors.kGrey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
