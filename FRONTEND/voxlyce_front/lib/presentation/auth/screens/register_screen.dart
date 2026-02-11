import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/widgets/buttons/primary_button.dart';
import '../../../core/widgets/inputs/custom_text_field.dart';
import '../../../core/utils/validators.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import 'login_screen.dart';
import '../../student/screens/student_dashboard.dart';

/// Register Screen - Inscription des nouveaux utilisateurs
/// Par défaut, tous les utilisateurs s'inscrivent comme STUDENT
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _classroomController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _classroomController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_acceptTerms) {
      SnackbarUtils.showError(
        context,
        'Veuillez accepter les conditions d\'utilisation',
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      SnackbarUtils.showError(
        context,
        'Les mots de passe ne correspondent pas',
      );
      return;
    }

    // Déclencher l'inscription avec le rôle STUDENT par défaut
    context.read<AuthBloc>().add(
          RegisterRequested(
            firstName: _firstNameController.text.trim(),
            lastName: _lastNameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text,
            role: 'STUDENT', // Rôle par défaut
            classroom: _classroomController.text.trim(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kBackground,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            SnackbarUtils.showSuccess(
              context,
              'Inscription réussie! Bienvenue sur Voxlyce',
            );
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const StudentDashboard()),
              (route) => false,
            );
          } else if (state is AuthError) {
            SnackbarUtils.showError(context, state.message);
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildHeader(),
                  const SizedBox(height: 40),
                  _buildRegistrationForm(),
                  const SizedBox(height: 24),
                  _buildTermsCheckbox(),
                  const SizedBox(height: 24),
                  _buildRegisterButton(),
                  const SizedBox(height: 24),
                  _buildLoginLink(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Logo
        Center(
          child: Image.asset(
            AppAssets.kAppLogo,
            height: 60,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Créer un compte',
          style: AppTypography.kHeading1.copyWith(
            color: AppColors.kSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Rejoignez Voxlyce et participez aux élections',
          style: AppTypography.kBody1.copyWith(
            color: AppColors.kGrey,
          ),
        ),
      ],
    );
  }

  Widget _buildRegistrationForm() {
    return Column(
      children: [
        // Prénom
        CustomTextField(
          controller: _firstNameController,
          label: 'Prénom',
          hint: 'Entrez votre prénom',
          prefixIcon: Icons.person_outline,
          validator: Validators.required('Le prénom est requis'),
        ),
        const SizedBox(height: 16),

        // Nom
        CustomTextField(
          controller: _lastNameController,
          label: 'Nom',
          hint: 'Entrez votre nom',
          prefixIcon: Icons.person_outline,
          validator: Validators.required('Le nom est requis'),
        ),
        const SizedBox(height: 16),

        // Email
        CustomTextField(
          controller: _emailController,
          label: 'Email',
          hint: 'exemple@voxlyce.com',
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          validator: Validators.email,
        ),
        const SizedBox(height: 16),

        // Classe
        CustomTextField(
          controller: _classroomController,
          label: 'Classe',
          hint: 'Ex: L3 Informatique',
          prefixIcon: Icons.school_outlined,
          validator: Validators.required('La classe est requise'),
        ),
        const SizedBox(height: 16),

        // Mot de passe
        CustomTextField(
          controller: _passwordController,
          label: 'Mot de passe',
          hint: 'Minimum 8 caractères',
          prefixIcon: Icons.lock_outline,
          obscureText: _obscurePassword,
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_off : Icons.visibility,
              color: AppColors.kGrey,
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
          validator: Validators.password,
        ),
        const SizedBox(height: 16),

        // Confirmer mot de passe
        CustomTextField(
          controller: _confirmPasswordController,
          label: 'Confirmer le mot de passe',
          hint: 'Retapez votre mot de passe',
          prefixIcon: Icons.lock_outline,
          obscureText: _obscureConfirmPassword,
          suffixIcon: IconButton(
            icon: Icon(
              _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
              color: AppColors.kGrey,
            ),
            onPressed: () {
              setState(() {
                _obscureConfirmPassword = !_obscureConfirmPassword;
              });
            },
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Veuillez confirmer votre mot de passe';
            }
            if (value != _passwordController.text) {
              return 'Les mots de passe ne correspondent pas';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: _acceptTerms,
          onChanged: (value) {
            setState(() {
              _acceptTerms = value ?? false;
            });
          },
          activeColor: AppColors.kPrimary,
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _acceptTerms = !_acceptTerms;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: RichText(
                text: TextSpan(
                  style: AppTypography.kBody2.copyWith(
                    color: AppColors.kGrey,
                  ),
                  children: [
                    const TextSpan(text: 'J\'accepte les '),
                    TextSpan(
                      text: 'Conditions d\'utilisation',
                      style: AppTypography.kBody2.copyWith(
                        color: AppColors.kPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const TextSpan(text: ' et la '),
                    TextSpan(
                      text: 'Politique de confidentialité',
                      style: AppTypography.kBody2.copyWith(
                        color: AppColors.kPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterButton() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return PrimaryButton(
          text: 'S\'inscrire',
          onTap: isLoading ? () {} : _handleRegister,
          isLoading: isLoading,
        );
      },
    );
  }

  Widget _buildLoginLink() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Vous avez déjà un compte? ',
            style: AppTypography.kBody2.copyWith(
              color: AppColors.kGrey,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
            child: Text(
              'Se connecter',
              style: AppTypography.kBody2.copyWith(
                color: AppColors.kPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
