import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/appbars/custom_appbar.dart';
import '../../../core/widgets/buttons/primary_button.dart';
import '../../../core/widgets/inputs/custom_text_field.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../../core/utils/validators.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetLink() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      // TODO: Call API to send reset link
      await Future.delayed(const Duration(seconds: 2));

      setState(() => _emailSent = true);

      if (mounted) {
        SnackbarUtils.showSuccess(
          context,
          'Email de réinitialisation envoyé',
        );
      }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kBackground,
      appBar: const CustomAppBar(
        title: 'Mot de passe oublié',
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: AppSpacing.xl),

              // Icon
              Container(
                padding: EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.kPrimary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.lock_reset,
                  size: 80.sp,
                  color: AppColors.kPrimary,
                ),
              ),

              SizedBox(height: AppSpacing.xl),

              if (!_emailSent) ...[
                // Instructions
                Text(
                  'Réinitialiser votre mot de passe',
                  style: AppTypography.kHeading2.copyWith(
                    color: AppColors.kSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: AppSpacing.md),

                Text(
                  'Entrez votre adresse email et nous vous enverrons un lien pour réinitialiser votre mot de passe.',
                  style: AppTypography.kBody1.copyWith(
                    color: AppColors.kGrey,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: AppSpacing.xl),

                // Email Field
                CustomTextField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'votre.email@example.com',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email,
                  validator: Validators.validateEmail,
                ),

                SizedBox(height: AppSpacing.xl),

                // Send Button
                PrimaryButton(
                  text: 'Envoyer le lien',
                  onPressed: _isLoading ? null : _sendResetLink,
                  isLoading: _isLoading,
                  icon: Icons.send,
                ),

                SizedBox(height: AppSpacing.md),

                // Back to Login
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Retour à la connexion',
                    style: TextStyle(color: AppColors.kPrimary),
                  ),
                ),
              ] else ...[
                // Success Message
                Container(
                  padding: EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: AppColors.kSuccess.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    border: Border.all(color: AppColors.kSuccess),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 64.sp,
                        color: AppColors.kSuccess,
                      ),
                      SizedBox(height: AppSpacing.md),
                      Text(
                        'Email envoyé !',
                        style: AppTypography.kHeading3.copyWith(
                          color: AppColors.kSuccess,
                        ),
                      ),
                      SizedBox(height: AppSpacing.sm),
                      Text(
                        'Nous avons envoyé un lien de réinitialisation à :',
                        style: AppTypography.kBody1.copyWith(
                          color: AppColors.kGrey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: AppSpacing.xs),
                      Text(
                        _emailController.text,
                        style: AppTypography.kBody1.copyWith(
                          color: AppColors.kSecondary,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: AppSpacing.md),
                      Text(
                        'Vérifiez votre boîte de réception et suivez les instructions.',
                        style: AppTypography.kBody2.copyWith(
                          color: AppColors.kGrey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: AppSpacing.xl),

                // Resend Button
                OutlinedButton.icon(
                  onPressed: () {
                    setState(() => _emailSent = false);
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Renvoyer l\'email'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.kPrimary,
                    side: BorderSide(color: AppColors.kPrimary),
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                  ),
                ),

                SizedBox(height: AppSpacing.md),

                // Back to Login
                PrimaryButton(
                  text: 'Retour à la connexion',
                  onPressed: () => Navigator.pop(context),
                  icon: Icons.arrow_back,
                ),
              ],

              SizedBox(height: AppSpacing.xl),

              // Help Text
              Container(
                padding: EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.kInfo.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info, color: AppColors.kInfo),
                    SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'Si vous ne recevez pas l\'email, vérifiez vos spams ou contactez le support.',
                        style: AppTypography.kCaption.copyWith(
                          color: AppColors.kInfo,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
