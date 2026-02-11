import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/appbars/custom_appbar.dart';
import '../../../data/models/election_model.dart';
import 'launch_vote_screen.dart';
import 'verify_students_screen.dart';
import '../../common/screens/profile_screen.dart';

class SupervisorDashboard extends StatefulWidget {
  const SupervisorDashboard({super.key});

  @override
  State<SupervisorDashboard> createState() => _SupervisorDashboardState();
}

class _SupervisorDashboardState extends State<SupervisorDashboard> {
  bool _isLoading = true;
  List<ElectionModel> _assignedElections = [];
  int _verifiedStudents = 142;
  int _recordedVotes = 89;
  int _activeElections = 2;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      // TODO: Call API
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock data
      _assignedElections = [
        ElectionModel(
          id: 1,
          title: 'Élection du Comité de Classe L3 Info',
          isCommitteeVote: false,
          classroom: 'L3 Info',
          status: 'PENDING',
          isValidated: false,
          startTime: DateTime.now().add(const Duration(days: 2)),
          endTime: DateTime.now().add(const Duration(days: 5)),
        ),
        ElectionModel(
          id: 2,
          title: 'Élection du Bureau Étudiant 2024',
          isCommitteeVote: true,
          classroom: null,
          status: 'ONGOING',
          isValidated: true,
          startTime: DateTime.now().subtract(const Duration(days: 1)),
          endTime: DateTime.now().add(const Duration(days: 3)),
        ),
        ElectionModel(
          id: 3,
          title: 'Élection Délégués M1',
          isCommitteeVote: false,
          classroom: 'M1 Génie Logiciel',
          status: 'VALIDATED',
          isValidated: true,
          startTime: DateTime.now().subtract(const Duration(days: 10)),
          endTime: DateTime.now().subtract(const Duration(days: 5)),
        ),
      ];
    } catch (e) {
      // Handle error
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'PENDING':
        return AppColors.kWarning;
      case 'ONGOING':
        return AppColors.kOngoing;
      case 'VALIDATED':
        return AppColors.kValidated;
      default:
        return AppColors.kGrey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'PENDING':
        return 'En attente';
      case 'ONGOING':
        return 'En cours';
      case 'VALIDATED':
        return 'Terminée';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kBackground,
      appBar: CustomAppBar(
        title: 'Superviseur',
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: ListView(
          padding: EdgeInsets.all(AppSpacing.md),
          children: [
            // Welcome Card
            Container(
              padding: EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                boxShadow: [AppColors.defaultShadow],
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.supervisor_account,
                    size: 48.sp,
                    color: AppColors.kWhite,
                  ),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tableau de Bord',
                          style: AppTypography.kHeading2.copyWith(
                            color: AppColors.kWhite,
                          ),
                        ),
                        Text(
                          'Gérez vos élections assignées',
                          style: AppTypography.kBody1.copyWith(
                            color: AppColors.kWhite.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: AppSpacing.lg),

            // Quick Stats
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Étudiants Vérifiés',
                    _verifiedStudents.toString(),
                    Icons.verified_user,
                    AppColors.kSuccess,
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _buildStatCard(
                    'Votes Enregistrés',
                    _recordedVotes.toString(),
                    Icons.how_to_vote,
                    AppColors.kPrimary,
                  ),
                ),
              ],
            ),

            SizedBox(height: AppSpacing.md),

            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Élections Actives',
                    _activeElections.toString(),
                    Icons.poll,
                    AppColors.kOngoing,
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _buildStatCard(
                    'Total Élections',
                    _assignedElections.length.toString(),
                    Icons.ballot,
                    AppColors.kInfo,
                  ),
                ),
              ],
            ),

            SizedBox(height: AppSpacing.lg),

            // Quick Actions
            Text(
              'Actions Rapides',
              style: AppTypography.kHeading3.copyWith(
                color: AppColors.kSecondary,
              ),
            ),

            SizedBox(height: AppSpacing.md),

            Row(
              children: [
                Expanded(
                  child: _buildActionCard(
                    'Lancer une Élection',
                    Icons.play_circle_filled,
                    AppColors.kSuccess,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LaunchVoteScreen(),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _buildActionCard(
                    'Vérifier Étudiants',
                    Icons.fact_check,
                    AppColors.kPrimary,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const VerifyStudentsScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            SizedBox(height: AppSpacing.lg),

            // Assigned Elections
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Élections Assignées',
                  style: AppTypography.kHeading3.copyWith(
                    color: AppColors.kSecondary,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LaunchVoteScreen(),
                      ),
                    );
                  },
                  child: Text(
                    'Voir tout',
                    style: TextStyle(color: AppColors.kPrimary),
                  ),
                ),
              ],
            ),

            SizedBox(height: AppSpacing.md),

            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_assignedElections.isEmpty)
              _buildEmptyState()
            else
              ..._assignedElections.map((election) {
                return _buildElectionCard(election);
              }).toList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const LaunchVoteScreen()),
          );
        },
        backgroundColor: AppColors.kPrimary,
        icon: const Icon(Icons.play_arrow),
        label: const Text('Lancer Vote'),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        boxShadow: [AppColors.cardShadow],
      ),
      child: Column(
        children: [
          Icon(icon, size: 32.sp, color: color),
          SizedBox(height: AppSpacing.sm),
          Text(
            value,
            style: AppTypography.kHeading2.copyWith(color: color),
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            title,
            style: AppTypography.kCaption.copyWith(
              color: AppColors.kGrey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Container(
        padding: EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: color, width: 2),
        ),
        child: Column(
          children: [
            Icon(icon, size: 40.sp, color: color),
            SizedBox(height: AppSpacing.sm),
            Text(
              title,
              style: AppTypography.kBody1.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildElectionCard(ElectionModel election) {
    final statusColor = _getStatusColor(election.status);

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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (election.status == 'PENDING') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const LaunchVoteScreen(),
                ),
              );
            }
          },
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      ),
                      child: Icon(
                        election.status == 'PENDING'
                            ? Icons.pending
                            : election.status == 'ONGOING'
                                ? Icons.play_circle_filled
                                : Icons.check_circle,
                        color: statusColor,
                        size: 24.sp,
                      ),
                    ),
                    SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            election.title,
                            style: AppTypography.kHeading4,
                          ),
                          Text(
                            election.isCommitteeVote
                                ? 'Comité'
                                : election.classroom ?? '',
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
                        _getStatusText(election.status),
                        style: AppTypography.kCaption.copyWith(
                          color: AppColors.kWhite,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: AppSpacing.md),

                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16.sp,
                      color: AppColors.kGrey,
                    ),
                    SizedBox(width: AppSpacing.xs),
                    Text(
                      'Début: ${election.startTime?.day}/${election.startTime?.month}/${election.startTime?.year}',
                      style: AppTypography.kCaption.copyWith(
                        color: AppColors.kGrey,
                      ),
                    ),
                  ],
                ),

                if (election.status == 'PENDING') ...[
                  SizedBox(height: AppSpacing.md),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.arrow_forward,
                        color: AppColors.kPrimary,
                        size: 20.sp,
                      ),
                      SizedBox(width: AppSpacing.xs),
                      Text(
                        'Lancer l\'élection',
                        style: AppTypography.kBody1.copyWith(
                          color: AppColors.kPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.xl),
      child: Column(
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 64.sp,
            color: AppColors.kGrey.withOpacity(0.5),
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            'Aucune élection assignée',
            style: AppTypography.kBody1.copyWith(
              color: AppColors.kGrey,
            ),
          ),
        ],
      ),
    );
  }
}
