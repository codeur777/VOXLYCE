import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/widgets/appbars/custom_appbar.dart';
import '../../../core/widgets/buttons/primary_button.dart';
import '../../../core/services/storage_service.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_event.dart';
import '../../auth/screens/login_screen.dart';
import 'notifications_screen.dart';
import 'settings_screen.dart';
import 'help_screen.dart';

/// Profile Screen
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _userName = '';
  String _userEmail = '';
  String _userRole = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final email = await StorageService().getUserEmail();
    final role = await StorageService().getUserRole();
    
    setState(() {
      _userEmail = email ?? 'user@voxlyce.com';
      _userRole = _getRoleLabel(role ?? 'STUDENT');
      _userName = _userEmail.split('@')[0];
    });
  }

  String _getRoleLabel(String role) {
    switch (role.toUpperCase()) {
      case 'ADMIN':
        return 'Administrateur';
      case 'SUPERVISOR':
        return 'Superviseur';
      case 'STUDENT':
      case 'VOTER':
        return 'Étudiant';
      default:
        return role;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Profil',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 30),
            _buildMenuSection(),
            const SizedBox(height: 30),
            _buildLogoutButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.kPrimary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                _userName.isNotEmpty ? _userName[0].toUpperCase() : 'U',
                style: AppTypography.kHeading1.copyWith(
                  color: AppColors.kPrimary,
                  fontSize: 36,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _userName,
            style: AppTypography.kHeading2,
          ),
          const SizedBox(height: 4),
          Text(
            _userEmail,
            style: AppTypography.kBody2.copyWith(
              color: AppColors.kGrey,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.kPrimary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _userRole,
              style: AppTypography.kCaption.copyWith(
                color: AppColors.kPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection() {
    return Column(
      children: [
        _buildMenuItem(
          icon: AppAssets.kProfile,
          title: 'Modifier le Profil',
          onTap: () {
            // TODO: Navigate to edit profile
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Fonctionnalité à venir')),
            );
          },
        ),
        const SizedBox(height: 12),
        _buildMenuItem(
          icon: AppAssets.kPassword,
          title: 'Changer le Mot de Passe',
          onTap: () {
            // TODO: Navigate to change password
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Fonctionnalité à venir')),
            );
          },
        ),
        const SizedBox(height: 12),
        _buildMenuItem(
          icon: AppAssets.kNotification,
          title: 'Notifications',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NotificationsScreen()),
            );
          },
        ),
        const SizedBox(height: 12),
        _buildMenuItem(
          icon: AppAssets.kTheme,
          title: 'Paramètres',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            );
          },
        ),
        const SizedBox(height: 12),
        _buildMenuItem(
          icon: AppAssets.kHelp,
          title: 'Aide et Support',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HelpScreen()),
            );
          },
        ),
        const SizedBox(height: 12),
        _buildMenuItem(
          icon: AppAssets.kPrivacy,
          title: 'Confidentialité',
          onTap: () {
            // TODO: Navigate to privacy
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Fonctionnalité à venir')),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.kGreyLight),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.kPrimary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SvgPicture.asset(
                icon,
                width: 20,
                height: 20,
                colorFilter: const ColorFilter.mode(
                  AppColors.kPrimary,
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: AppTypography.kBody1,
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.kGrey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return PrimaryButton(
      text: 'Se Déconnecter',
      onTap: () => _handleLogout(context),
      color: AppColors.kError,
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Déconnexion'),
        content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Déconnecter',
              style: TextStyle(color: AppColors.kError),
            ),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      context.read<AuthBloc>().add(LogoutRequested());
      
      // Navigate to login screen
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }
}
