import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/appbars/custom_appbar.dart';
import '../../../core/widgets/loading/loading_widget.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../../data/models/election_model.dart';
import 'create_election_screen.dart';

class ManageElectionsScreen extends StatefulWidget {
  const ManageElectionsScreen({super.key});

  @override
  State<ManageElectionsScreen> createState() => _ManageElectionsScreenState();
}

class _ManageElectionsScreenState extends State<ManageElectionsScreen> {
  bool _isLoading = true;
  List<ElectionModel> _elections = [];
  String _filterStatus = 'ALL';

  @override
  void initState() {
    super.initState();
    _loadElections();
  }

  Future<void> _loadElections() async {
    setState(() => _isLoading = true);
    try {
      // TODO: Call API
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock data
      _elections = [
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
      if (mounted) {
        SnackbarUtils.showError(context, 'Erreur: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  List<ElectionModel> get filteredElections {
    if (_filterStatus == 'ALL') {
      return _elections;
    }
    return _elections.where((e) => e.status == _filterStatus).toList();
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

  Future<void> _deleteElection(ElectionModel election) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmer la suppression', style: AppTypography.kHeading3),
        content: Text(
          'Êtes-vous sûr de vouloir supprimer "${election.title}" ?',
          style: AppTypography.kBody1,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Annuler', style: TextStyle(color: AppColors.kGrey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Supprimer', style: TextStyle(color: AppColors.kError)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        // TODO: Call API
        await Future.delayed(const Duration(seconds: 1));
        
        setState(() {
          _elections.removeWhere((e) => e.id == election.id);
        });
        
        if (mounted) {
          SnackbarUtils.showSuccess(context, 'Élection supprimée');
        }
      } catch (e) {
        if (mounted) {
          SnackbarUtils.showError(context, 'Erreur: ${e.toString()}');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kBackground,
      appBar: CustomAppBar(
        title: 'Gestion des Élections',
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadElections,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CreateElectionScreen(),
            ),
          );
          if (result == true) {
            _loadElections();
          }
        },
        backgroundColor: AppColors.kPrimary,
        icon: const Icon(Icons.add),
        label: const Text('Nouvelle Élection'),
      ),
      body: Column(
        children: [
          // Filters
          Container(
            padding: EdgeInsets.all(AppSpacing.md),
            color: AppColors.kWhite,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('ALL', 'Toutes'),
                  SizedBox(width: AppSpacing.sm),
                  _buildFilterChip('PENDING', 'En attente'),
                  SizedBox(width: AppSpacing.sm),
                  _buildFilterChip('ONGOING', 'En cours'),
                  SizedBox(width: AppSpacing.sm),
                  _buildFilterChip('VALIDATED', 'Terminées'),
                ],
              ),
            ),
          ),

          // Elections List
          Expanded(
            child: _isLoading
                ? const LoadingWidget()
                : filteredElections.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                        onRefresh: _loadElections,
                        child: ListView.builder(
                          padding: EdgeInsets.all(AppSpacing.md),
                          itemCount: filteredElections.length,
                          itemBuilder: (context, index) {
                            final election = filteredElections[index];
                            return _buildElectionCard(election);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String value, String label) {
    final isSelected = _filterStatus == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() => _filterStatus = value);
      },
      backgroundColor: AppColors.kWhite,
      selectedColor: AppColors.kPrimary.withOpacity(0.2),
      labelStyle: TextStyle(
        color: isSelected ? AppColors.kPrimary : AppColors.kGrey,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildElectionCard(ElectionModel election) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        boxShadow: [AppColors.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppSpacing.radiusMd),
                topRight: Radius.circular(AppSpacing.radiusMd),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    election.title,
                    style: AppTypography.kHeading3.copyWith(
                      color: AppColors.kWhite,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.kWhite.withOpacity(0.2),
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
          ),

          // Body
          Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      election.isCommitteeVote ? Icons.groups : Icons.class_,
                      size: 20.sp,
                      color: AppColors.kPrimary,
                    ),
                    SizedBox(width: AppSpacing.xs),
                    Text(
                      election.isCommitteeVote ? 'Comité' : election.classroom ?? '',
                      style: AppTypography.kBody1,
                    ),
                  ],
                ),

                SizedBox(height: AppSpacing.sm),

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
                    SizedBox(width: AppSpacing.md),
                    Icon(
                      Icons.event_available,
                      size: 16.sp,
                      color: AppColors.kGrey,
                    ),
                    SizedBox(width: AppSpacing.xs),
                    Text(
                      'Fin: ${election.endTime?.day}/${election.endTime?.month}/${election.endTime?.year}',
                      style: AppTypography.kCaption.copyWith(
                        color: AppColors.kGrey,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: AppSpacing.md),

                // Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        // TODO: Navigate to edit screen
                        SnackbarUtils.showInfo(context, 'Modification bientôt disponible');
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('Modifier'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.kPrimary,
                      ),
                    ),
                    SizedBox(width: AppSpacing.sm),
                    TextButton.icon(
                      onPressed: () => _deleteElection(election),
                      icon: const Icon(Icons.delete),
                      label: const Text('Supprimer'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.kError,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.how_to_vote_outlined,
            size: 80.sp,
            color: AppColors.kGrey.withOpacity(0.5),
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            'Aucune élection',
            style: AppTypography.kHeading3.copyWith(
              color: AppColors.kGrey,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            'Créez votre première élection',
            style: AppTypography.kBody1.copyWith(
              color: AppColors.kGrey,
            ),
          ),
        ],
      ),
    );
  }
}

