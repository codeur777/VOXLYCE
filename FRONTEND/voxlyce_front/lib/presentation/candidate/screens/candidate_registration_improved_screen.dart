import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/appbars/custom_appbar.dart';
import '../../../core/widgets/buttons/primary_button.dart';
import '../../../core/widgets/inputs/custom_text_field.dart';
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
import 'my_candidatures_screen.dart';

/// Inscription Candidat Améliorée - 3 Étapes
/// Étape 1: Sélection élection et position + Manifesto
/// Étape 2: Paiement des frais (500F)
/// Étape 3: Upload carte étudiante (optionnel)
class CandidateRegistrationImprovedScreen extends StatefulWidget {
  const CandidateRegistrationImprovedScreen({super.key});

  @override
  State<CandidateRegistrationImprovedScreen> createState() =>
      _CandidateRegistrationImprovedScreenState();
}

class _CandidateRegistrationImprovedScreenState
    extends State<CandidateRegistrationImprovedScreen> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();
  
  // Étape 1
  final _manifestoController = TextEditingController();
  ElectionModel? _selectedElection;
  PositionModel? _selectedPosition;
  List<ElectionModel> _elections = [];
  
  // Étape 2
  final _paymentReferenceController = TextEditingController();
  String _selectedPaymentMethod = 'Mobile Money';
  
  // Étape 3
  String? _studentCardUrl;
  int? _candidateId;

  @override
  void initState() {
    super.initState();
    context.read<VoteBloc>().add(LoadElections());
  }

  @override
  void dispose() {
    _manifestoController.dispose();
    _paymentReferenceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      .where((e) => e.status == 'PENDING')
                      .toList();
                });
              }
            },
          ),
          BlocListener<CandidateBloc, CandidateState>(
            listener: (context, state) {
              if (state is CandidateRegistered) {
                setState(() {
                  _candidateId = state.candidate.id;
                });
                SnackbarUtils.showSuccess(
                  context,
                  'Candidature enregistrée! Passez au paiement.',
                );
                setState(() {
                  _currentStep = 1;
                });
              } else if (state is PaymentCompleted) {
                SnackbarUtils.showSuccess(
                  context,
                  'Paiement enregistré! Vous pouvez uploader votre carte (optionnel).',
                );
                setState(() {
                  _currentStep = 2;
                });
              } else if (state is StudentCardUploaded) {
                SnackbarUtils.showSuccess(
                  context,
                  'Carte étudiante uploadée! Candidature complète.',
                );
                _navigateToMyCandidatures();
              } else if (state is CandidateError) {
                SnackbarUtils.showError(context, state.message);
              }
            },
          ),
        ],
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStepIndicator(),
              const SizedBox(height: 30),
              _buildCurrentStep(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Row(
      children: [
        _buildStepCircle(1, 'Candidature', _currentStep >= 0),
        _buildStepLine(_currentStep >= 1),
        _buildStepCircle(2, 'Paiement', _currentStep >= 1),
        _buildStepLine(_currentStep >= 2),
        _buildStepCircle(3, 'Carte', _currentStep >= 2),
      ],
    );
  }

  Widget _buildStepCircle(int step, String label, bool isActive) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isActive ? AppColors.kPrimary : AppColors.kGreyLight,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$step',
                style: AppTypography.kBody1.copyWith(
                  color: isActive ? Colors.white : AppColors.kGrey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTypography.kCaption.copyWith(
              color: isActive ? AppColors.kPrimary : AppColors.kGrey,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepLine(bool isActive) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 30),
        color: isActive ? AppColors.kPrimary : AppColors.kGreyLight,
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildStep1();
      case 1:
        return _buildStep2();
      case 2:
        return _buildStep3();
      default:
        return _buildStep1();
    }
  }

  // ÉTAPE 1: Candidature
  Widget _buildStep1() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Étape 1: Informations de Candidature',
            style: AppTypography.kHeading3,
          ),
          const SizedBox(height: 20),
          
          // Sélection élection
          Text('Élection', style: AppTypography.kBody1Medium),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.kGreyLight),
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<ElectionModel>(
                value: _selectedElection,
                isExpanded: true,
                hint: const Text('Sélectionnez une élection'),
                items: _elections.map((election) {
                  return DropdownMenuItem(
                    value: election,
                    child: Text(election.title),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedElection = value;
                    _selectedPosition = null;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Sélection position
          if (_selectedElection != null) ...[
            Text('Position', style: AppTypography.kBody1Medium),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.kGreyLight),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<PositionModel>(
                  value: _selectedPosition,
                  isExpanded: true,
                  hint: const Text('Sélectionnez une position'),
                  items: _selectedElection!.positions.map((position) {
                    return DropdownMenuItem(
                      value: position,
                      child: Text(position.title),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedPosition = value;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          
          // Manifesto
          CustomTextField(
            controller: _manifestoController,
            label: 'Manifesto / Programme',
            hint: 'Décrivez votre programme et vos objectifs...',
            maxLines: 8,
            validator: Validators.required('Le manifesto est requis'),
          ),
          const SizedBox(height: 30),
          
          BlocBuilder<CandidateBloc, CandidateState>(
            builder: (context, state) {
              final isLoading = state is CandidateLoading;
              
              return PrimaryButton(
                text: 'Continuer',
                onTap: isLoading ? () {} : _submitStep1,
                isLoading: isLoading,
              );
            },
          ),
        ],
      ),
    );
  }

  void _submitStep1() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    if (_selectedElection == null) {
      SnackbarUtils.showError(context, 'Veuillez sélectionner une élection');
      return;
    }
    
    if (_selectedPosition == null) {
      SnackbarUtils.showError(context, 'Veuillez sélectionner une position');
      return;
    }
    
    context.read<CandidateBloc>().add(
      RegisterAsCandidate(
        electionId: _selectedElection!.id,
        positionId: _selectedPosition!.id,
        manifesto: _manifestoController.text.trim(),
      ),
    );
  }

  // ÉTAPE 2: Paiement
  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Étape 2: Paiement des Frais',
          style: AppTypography.kHeading3,
        ),
        const SizedBox(height: 20),
        
        // Montant
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.kPrimary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Frais de candidature',
                style: AppTypography.kBody1,
              ),
              Text(
                '500 F',
                style: AppTypography.kHeading2.copyWith(
                  color: AppColors.kPrimary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        
        // Méthode de paiement
        Text('Méthode de paiement', style: AppTypography.kBody1Medium),
        const SizedBox(height: 12),
        _buildPaymentMethod('Mobile Money', Icons.phone_android),
        const SizedBox(height: 8),
        _buildPaymentMethod('Carte Bancaire', Icons.credit_card),
        const SizedBox(height: 8),
        _buildPaymentMethod('Espèces', Icons.money),
        const SizedBox(height: 20),
        
        // Référence de paiement
        CustomTextField(
          controller: _paymentReferenceController,
          label: 'Référence de paiement',
          hint: 'Ex: TXN123456789',
          prefixIcon: Icons.receipt,
          validator: Validators.required('La référence est requise'),
        ),
        const SizedBox(height: 30),
        
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    _currentStep = 0;
                  });
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: AppColors.kPrimary),
                ),
                child: Text(
                  'Retour',
                  style: AppTypography.kButton.copyWith(
                    color: AppColors.kPrimary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: BlocBuilder<CandidateBloc, CandidateState>(
                builder: (context, state) {
                  final isLoading = state is CandidateLoading;
                  
                  return PrimaryButton(
                    text: 'Payer',
                    onTap: isLoading ? () {} : _submitStep2,
                    isLoading: isLoading,
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentMethod(String method, IconData icon) {
    final isSelected = _selectedPaymentMethod == method;
    
    return InkWell(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = method;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.kPrimary : AppColors.kGreyLight,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? AppColors.kPrimary.withOpacity(0.05) : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.kPrimary : AppColors.kGrey,
            ),
            const SizedBox(width: 16),
            Text(
              method,
              style: AppTypography.kBody1.copyWith(
                color: isSelected ? AppColors.kPrimary : AppColors.kSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppColors.kPrimary,
              ),
          ],
        ),
      ),
    );
  }

  void _submitStep2() {
    if (_paymentReferenceController.text.trim().isEmpty) {
      SnackbarUtils.showError(
        context,
        'Veuillez entrer la référence de paiement',
      );
      return;
    }
    
    if (_candidateId == null) {
      SnackbarUtils.showError(context, 'Erreur: ID candidat manquant');
      return;
    }
    
    context.read<CandidateBloc>().add(
      PayDepositFee(
        candidateId: _candidateId!,
        amount: 500,
        paymentReference: _paymentReferenceController.text.trim(),
      ),
    );
  }

  // ÉTAPE 3: Upload Carte (Optionnel)
  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Étape 3: Carte Étudiante (Optionnel)',
          style: AppTypography.kHeading3,
        ),
        const SizedBox(height: 12),
        Text(
          'Vous pouvez uploader votre carte étudiante pour faciliter la validation par l\'administrateur.',
          style: AppTypography.kBody2.copyWith(
            color: AppColors.kGrey,
          ),
        ),
        const SizedBox(height: 30),
        
        // Zone d'upload
        InkWell(
          onTap: _pickStudentCard,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.kGreyLight,
                width: 2,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(12),
              color: AppColors.kGreyLight.withOpacity(0.3),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _studentCardUrl != null
                        ? Icons.check_circle
                        : Icons.cloud_upload_outlined,
                    size: 64,
                    color: _studentCardUrl != null
                        ? AppColors.kSuccess
                        : AppColors.kGrey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _studentCardUrl != null
                        ? 'Carte uploadée'
                        : 'Cliquez pour uploader',
                    style: AppTypography.kBody1.copyWith(
                      color: _studentCardUrl != null
                          ? AppColors.kSuccess
                          : AppColors.kGrey,
                    ),
                  ),
                  if (_studentCardUrl == null)
                    Text(
                      'JPG, PNG (Max 5MB)',
                      style: AppTypography.kCaption.copyWith(
                        color: AppColors.kGrey,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 30),
        
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _navigateToMyCandidatures,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: AppColors.kGrey),
                ),
                child: Text(
                  'Passer',
                  style: AppTypography.kButton.copyWith(
                    color: AppColors.kGrey,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: BlocBuilder<CandidateBloc, CandidateState>(
                builder: (context, state) {
                  final isLoading = state is CandidateLoading;
                  
                  return PrimaryButton(
                    text: 'Terminer',
                    onTap: isLoading ? () {} : _submitStep3,
                    isLoading: isLoading,
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _pickStudentCard() {
    // TODO: Implémenter l'upload d'image
    // Pour l'instant, simuler l'upload
    setState(() {
      _studentCardUrl = 'https://example.com/student-card.jpg';
    });
    SnackbarUtils.showSuccess(context, 'Carte sélectionnée');
  }

  void _submitStep3() {
    if (_candidateId == null) {
      SnackbarUtils.showError(context, 'Erreur: ID candidat manquant');
      return;
    }
    
    if (_studentCardUrl != null) {
      context.read<CandidateBloc>().add(
        UploadStudentCard(
          candidateId: _candidateId!,
          photoUrl: _studentCardUrl!,
        ),
      );
    } else {
      _navigateToMyCandidatures();
    }
  }

  void _navigateToMyCandidatures() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const MyCandidaturesScreen(),
      ),
    );
  }
}
