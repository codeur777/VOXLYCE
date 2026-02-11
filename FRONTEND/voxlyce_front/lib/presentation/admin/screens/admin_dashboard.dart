import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/widgets/appbars/custom_appbar.dart';
import '../../common/screens/profile_screen.dart';

/// Admin Dashboard
class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Administration',
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              AppAssets.kNotification,
              width: 24,
              height: 24,
            ),
            onPressed: () {
              // TODO: Navigate to notifications
            },
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vue d\'ensemble',
              style: AppTypography.kHeading2,
            ),
            const SizedBox(height: 20),
            _buildStatsGrid(),
            const SizedBox(height: 30),
            Text(
              'Actions Rapides',
              style: AppTypography.kHeading3,
            ),
            const SizedBox(height: 16),
            _buildQuickActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: AppColors.kPrimary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.admin_panel_settings, size: 30),
                ),
                const SizedBox(height: 10),
                Text(
                  'Administrateur',
                  style: AppTypography.kHeading3.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
          _buildDrawerItem(
            context,
            icon: AppAssets.kHome,
            title: 'Vue d\'ensemble',
            onTap: () => Navigator.pop(context),
          ),
          _buildDrawerItem(
            context,
            icon: AppAssets.kActivity,
            title: 'Gérer les Élections',
            onTap: () {
              Navigator.pop(context);
              // TODO: Navigate to manage elections
            },
          ),
          _buildDrawerItem(
            context,
            icon: AppAssets.kBookOpen,
            title: 'Valider les Candidats',
            onTap: () {
              Navigator.pop(context);
              // TODO: Navigate to validate candidates
            },
          ),
          _buildDrawerItem(
            context,
            icon: AppAssets.kStatistics,
            title: 'Valider les Résultats',
            onTap: () {
              Navigator.pop(context);
              // TODO: Navigate to validate results
            },
          ),
          const Divider(),
          _buildDrawerItem(
            context,
            icon: AppAssets.kProfile,
            title: 'Profil',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
          ),
          _buildDrawerItem(
            context,
            icon: AppAssets.kHelp,
            title: 'Aide',
            onTap: () {
              Navigator.pop(context);
              // TODO: Navigate to help
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: SvgPicture.asset(
        icon,
        width: 24,
        height: 24,
        colorFilter: const ColorFilter.mode(
          AppColors.kSecondary,
          BlendMode.srcIn,
        ),
      ),
      title: Text(title, style: AppTypography.kBody1),
      onTap: onTap,
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard(
          title: 'Élections',
          value: '12',
          icon: AppAssets.kActivity,
          color: AppColors.kPrimary,
        ),
        _buildStatCard(
          title: 'Candidats',
          value: '48',
          icon: AppAssets.kBookOpen,
          color: AppColors.kSuccess,
        ),
        _buildStatCard(
          title: 'Votes',
          value: '324',
          icon: AppAssets.kThumbUp,
          color: AppColors.kWarning,
        ),
        _buildStatCard(
          title: 'Utilisateurs',
          value: '156',
          icon: AppAssets.kProfile,
          color: AppColors.kInfo,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: SvgPicture.asset(
              icon,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: AppTypography.kHeading2.copyWith(color: color),
              ),
              Text(
                title,
                style: AppTypography.kCaption.copyWith(
                  color: AppColors.kGrey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      children: [
        _buildActionButton(
          context,
          icon: AppAssets.kAdd,
          title: 'Créer une Élection',
          onTap: () {
            // TODO: Navigate to create election
          },
        ),
        const SizedBox(height: 12),
        _buildActionButton(
          context,
          icon: AppAssets.kBookOpen,
          title: 'Valider les Candidats',
          onTap: () {
            // TODO: Navigate to validate candidates
          },
        ),
        const SizedBox(height: 12),
        _buildActionButton(
          context,
          icon: AppAssets.kStatistics,
          title: 'Voir les Statistiques',
          onTap: () {
            // TODO: Navigate to statistics
          },
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
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
                width: 24,
                height: 24,
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
                style: AppTypography.kBody1.copyWith(
                  fontWeight: FontWeight.w600,
                ),
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
}
