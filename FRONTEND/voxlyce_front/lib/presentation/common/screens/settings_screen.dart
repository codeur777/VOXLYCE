import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/appbars/custom_appbar.dart';
import '../../../core/utils/snackbar_utils.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _darkMode = false;
  String _language = 'fr';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kBackground,
      appBar: const CustomAppBar(
        title: 'Paramètres',
      ),
      body: ListView(
        padding: EdgeInsets.all(AppSpacing.md),
        children: [
          // Account Section
          _buildSectionHeader('Compte'),
          _buildSettingCard(
            icon: Icons.person,
            title: 'Informations personnelles',
            subtitle: 'Modifier votre profil',
            onTap: () {
              SnackbarUtils.showInfo(context, 'Fonctionnalité bientôt disponible');
            },
          ),
          _buildSettingCard(
            icon: Icons.lock,
            title: 'Changer le mot de passe',
            subtitle: 'Mettre à jour votre mot de passe',
            onTap: () {
              SnackbarUtils.showInfo(context, 'Fonctionnalité bientôt disponible');
            },
          ),
          _buildSettingCard(
            icon: Icons.security,
            title: 'Authentification à deux facteurs',
            subtitle: 'Sécuriser votre compte',
            trailing: Switch(
              value: false,
              onChanged: (value) {
                SnackbarUtils.showInfo(context, 'Fonctionnalité bientôt disponible');
              },
              activeColor: AppColors.kPrimary,
            ),
          ),

          SizedBox(height: AppSpacing.lg),

          // Notifications Section
          _buildSectionHeader('Notifications'),
          _buildSettingCard(
            icon: Icons.notifications,
            title: 'Activer les notifications',
            subtitle: 'Recevoir toutes les notifications',
            trailing: Switch(
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() => _notificationsEnabled = value);
                SnackbarUtils.showSuccess(
                  context,
                  value ? 'Notifications activées' : 'Notifications désactivées',
                );
              },
              activeColor: AppColors.kPrimary,
            ),
          ),
          if (_notificationsEnabled) ...[
            _buildSettingCard(
              icon: Icons.email,
              title: 'Notifications par email',
              subtitle: 'Recevoir des emails',
              trailing: Switch(
                value: _emailNotifications,
                onChanged: (value) {
                  setState(() => _emailNotifications = value);
                },
                activeColor: AppColors.kPrimary,
              ),
            ),
            _buildSettingCard(
              icon: Icons.phone_android,
              title: 'Notifications push',
              subtitle: 'Recevoir des notifications push',
              trailing: Switch(
                value: _pushNotifications,
                onChanged: (value) {
                  setState(() => _pushNotifications = value);
                },
                activeColor: AppColors.kPrimary,
              ),
            ),
          ],

          SizedBox(height: AppSpacing.lg),

          // Appearance Section
          _buildSectionHeader('Apparence'),
          _buildSettingCard(
            icon: Icons.dark_mode,
            title: 'Mode sombre',
            subtitle: 'Activer le thème sombre',
            trailing: Switch(
              value: _darkMode,
              onChanged: (value) {
                setState(() => _darkMode = value);
                SnackbarUtils.showInfo(context, 'Fonctionnalité bientôt disponible');
              },
              activeColor: AppColors.kPrimary,
            ),
          ),
          _buildSettingCard(
            icon: Icons.language,
            title: 'Langue',
            subtitle: _language == 'fr' ? 'Français' : 'English',
            onTap: () {
              _showLanguageDialog();
            },
          ),

          SizedBox(height: AppSpacing.lg),

          // Privacy Section
          _buildSectionHeader('Confidentialité'),
          _buildSettingCard(
            icon: Icons.privacy_tip,
            title: 'Politique de confidentialité',
            subtitle: 'Lire notre politique',
            onTap: () {
              SnackbarUtils.showInfo(context, 'Fonctionnalité bientôt disponible');
            },
          ),
          _buildSettingCard(
            icon: Icons.description,
            title: 'Conditions d\'utilisation',
            subtitle: 'Lire les conditions',
            onTap: () {
              SnackbarUtils.showInfo(context, 'Fonctionnalité bientôt disponible');
            },
          ),

          SizedBox(height: AppSpacing.lg),

          // Data Section
          _buildSectionHeader('Données'),
          _buildSettingCard(
            icon: Icons.download,
            title: 'Télécharger mes données',
            subtitle: 'Exporter vos données',
            onTap: () {
              SnackbarUtils.showInfo(context, 'Fonctionnalité bientôt disponible');
            },
          ),
          _buildSettingCard(
            icon: Icons.delete_forever,
            title: 'Supprimer mon compte',
            subtitle: 'Action irréversible',
            titleColor: AppColors.kError,
            onTap: () {
              _showDeleteAccountDialog();
            },
          ),

          SizedBox(height: AppSpacing.lg),

          // About Section
          _buildSectionHeader('À propos'),
          _buildSettingCard(
            icon: Icons.info,
            title: 'Version de l\'application',
            subtitle: '1.0.0',
          ),
          _buildSettingCard(
            icon: Icons.help,
            title: 'Aide et support',
            subtitle: 'Obtenir de l\'aide',
            onTap: () {
              SnackbarUtils.showInfo(context, 'Fonctionnalité bientôt disponible');
            },
          ),

          SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.sm,
        bottom: AppSpacing.sm,
        top: AppSpacing.sm,
      ),
      child: Text(
        title,
        style: AppTypography.kHeading4.copyWith(
          color: AppColors.kPrimary,
        ),
      ),
    );
  }

  Widget _buildSettingCard({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    Color? titleColor,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        boxShadow: [AppColors.cardShadow],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: (titleColor ?? AppColors.kPrimary).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: Icon(
                    icon,
                    color: titleColor ?? AppColors.kPrimary,
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTypography.kBody1.copyWith(
                          fontWeight: FontWeight.bold,
                          color: titleColor,
                        ),
                      ),
                      if (subtitle != null) ...[
                        SizedBox(height: AppSpacing.xs),
                        Text(
                          subtitle,
                          style: AppTypography.kCaption.copyWith(
                            color: AppColors.kGrey,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailing != null)
                  trailing
                else if (onTap != null)
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16.sp,
                    color: AppColors.kGrey,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Choisir la langue', style: AppTypography.kHeading3),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Français'),
              value: 'fr',
              groupValue: _language,
              onChanged: (value) {
                setState(() => _language = value!);
                Navigator.pop(context);
                SnackbarUtils.showSuccess(context, 'Langue changée en Français');
              },
              activeColor: AppColors.kPrimary,
            ),
            RadioListTile<String>(
              title: const Text('English'),
              value: 'en',
              groupValue: _language,
              onChanged: (value) {
                setState(() => _language = value!);
                Navigator.pop(context);
                SnackbarUtils.showSuccess(context, 'Language changed to English');
              },
              activeColor: AppColors.kPrimary,
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Supprimer le compte', style: AppTypography.kHeading3),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Êtes-vous sûr de vouloir supprimer votre compte ?',
              style: AppTypography.kBody1,
            ),
            SizedBox(height: AppSpacing.md),
            Container(
              padding: EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.kError.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning, color: AppColors.kError),
                  SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      'Cette action est irréversible',
                      style: AppTypography.kCaption.copyWith(
                        color: AppColors.kError,
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
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler', style: TextStyle(color: AppColors.kGrey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              SnackbarUtils.showInfo(context, 'Fonctionnalité bientôt disponible');
            },
            child: Text('Supprimer', style: TextStyle(color: AppColors.kError)),
          ),
        ],
      ),
    );
  }
}
