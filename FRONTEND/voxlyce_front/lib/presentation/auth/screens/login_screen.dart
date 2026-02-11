import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/buttons/primary_button.dart';
import '../../../core/widgets/inputs/custom_text_field.dart';
import '../../../core/widgets/loading/loading_widget.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../../core/utils/validators.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../../voter/screens/election_list_screen.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';
import '../../../core/constants/role_constants.dart';
import '../../student/screens/student_dashboard.dart';
import '../../admin/screens/admin_dashboard.dart';
import '../../supervisor/screens/supervisor_dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            LoginRequested(
              email: _emailController.text.trim(),
              password: _passwordController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kBackground,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            SnackbarUtils.showSuccess(
              context,
              'Connexion réussie!',
            );
            
            // Redirection basée sur le rôle
            Widget homeScreen;
            final role = state.authResponse.role;
            
            if (RoleConstants.isAdmin(role)) {
              homeScreen = const AdminDashboard();
            } else if (RoleConstants.isSupervisor(role)) {
              homeScreen = const SupervisorDashboard();
            } else {
              homeScreen = const StudentDashboard();
            }
            
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => homeScreen),
            );
          } else if (state is AuthError) {
            SnackbarUtils.showError(
              context,
              state.message,
            );
          } else if (state is Auth2FARequired) {
            // Navigate to 2FA screen if needed
            SnackbarUtils.showInfo(
              context,
              'Vérification 2FA requise',
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const LoadingWidget();
          }

          return SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.xl,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: AppSpacing.xxl),
                    
                    // Logo
                    Center(
                      child: Container(
                        width: 100.w,
                        height: 100.h,
                        decoration: BoxDecoration(
                          color: AppColors.kPrimary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.how_to_vote_rounded,
                          size: 50.sp,
                          color: AppColors.kPrimary,
                        ),
                      ),
                    ),
                    
                    SizedBox(height: AppSpacing.xl),
                    
                    // Title
                    Text(
                      'Bienvenue sur',
                      style: AppTypography.kHeading2.copyWith(
                        color: AppColors.kSecondary,
                      ),
                    ),
                    Text(
                      'Voxlyce',
                      style: AppTypography.kHeading1.copyWith(
                        color: AppColors.kPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                    SizedBox(height: AppSpacing.xs),
                    
                    Text(
                      'Connectez-vous pour voter',
                      style: AppTypography.kBody1.copyWith(
                        color: AppColors.kGrey,
                      ),
                    ),
                    
                    SizedBox(height: AppSpacing.xxl),
                    
                    // Email Field
                    CustomTextField(
                      controller: _emailController,
                      label: 'Email',
                      hint: 'votre.email@example.com',
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icons.email_outlined,
                      validator: Validators.email,
                    ),
                    
                    SizedBox(height: AppSpacing.md),
                    
                    // Password Field
                    CustomTextField(
                      controller: _passwordController,
                      label: 'Mot de passe',
                      hint: '••••••••',
                      obscureText: _obscurePassword,
                      prefixIcon: Icons.lock_outline,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: AppColors.kGrey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      validator: Validators.required,
                    ),
                    
                    SizedBox(height: AppSpacing.xxl),
                    
                    // Login Button
                    PrimaryButton(
                      onTap: _handleLogin,
                      text: 'Se connecter',
                      icon: Icons.login,
                    ),
                    
                    SizedBox(height: AppSpacing.md),
                    
                    // Forgot Password Link
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const ForgotPasswordScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Mot de passe oublié ?',
                          style: AppTypography.kBody1.copyWith(
                            color: AppColors.kPrimary,
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: AppSpacing.lg),
                    
                    // Register Link
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const RegisterScreen(),
                            ),
                          );
                        },
                        child: RichText(
                          text: TextSpan(
                            text: 'Pas encore de compte? ',
                            style: AppTypography.kBody1.copyWith(
                              color: AppColors.kGrey,
                            ),
                            children: [
                              TextSpan(
                                text: 'S\'inscrire',
                                style: AppTypography.kBody1.copyWith(
                                  color: AppColors.kPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
