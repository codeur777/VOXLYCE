import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/appbars/custom_appbar.dart';
import '../../../core/widgets/loading/loading_widget.dart';
import '../../../data/models/vote_model.dart';
import '../bloc/vote_bloc.dart';
import '../bloc/vote_event.dart';
import '../bloc/vote_state.dart';

/// Écran d'historique des votes
class VoteHistoryScreen extends StatefulWidget {
  const VoteHistoryScreen({super.key});

  @override
  State<VoteHistoryScreen> createState() => _VoteHistoryScreenState();
}

class _VoteHistoryScreenState extends State<VoteHistoryScreen> {
  String _searchQuery = '';
  String _filterStatus = 'ALL'; // ALL, COMPLETED, ONGOING

  @override
  void initState() {
    super.initState();
    context.read<VoteBloc>().add(LoadVoteHistory());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Historique des Votes',
      ),
      body: Column(
        children: [
          _buildSearchAndFilter(),
          Expanded(
            child: BlocBuilder<VoteBloc, VoteState>(
              builder: (context, state) {
                if (state is VoteLoading) {
                  return const LoadingWidget();
                } else if (state is VoteHistoryLoaded) {
                  final filteredVotes = _filterVotes(state.votes);
                  
                  if (filteredVotes.isEmpty) {
                    return _buildEmptyState();
                  }
                  
                  return _buildVoteList(filteredVotes);
                } else if (state is VoteError) {
                  return _buildErrorState(state.message);
                }
                
                return _buildEmptyState();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
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
          // Barre de recherche
          TextField(
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Rechercher une élection...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.kGreyLight),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.kGreyLight),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.kPrimary),
              ),
            ),
          ),
          const SizedBox(height: 12),
          
          // Filtres
          Row(
            children: [
              _buildFilterChip('Tous', 'ALL'),
              const SizedBox(width: 8),
              _buildFilterChip('Terminées', 'COMPLETED'),
              const SizedBox(width: 8),
              _buildFilterChip('En cours', 'ONGOING'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _filterStatus == value;
    
    return InkWell(
      onTap: () {
        setState(() {
          _filterStatus = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.kPrimary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.kPrimary : AppColors.kGreyLight,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.kBody2.copyWith(
            color: isSelected ? Colors.white : AppColors.kGrey,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  List<VoteModel> _filterVotes(List<VoteModel> votes) {
    var filtered = votes;
    
    // Filtre par recherche
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((vote) {
        return vote.electionTitle
            .toLowerCase()
            .contains(_searchQuery.toLowerCase());
      }).toList();
    }
    
    // Filtre par statut
    if (_filterStatus != 'ALL') {
      filtered = filtered.where((vote) {
        return vote.status == _filterStatus;
      }).toList();
    }
    
    return filtered;
  }

  Widget _buildVoteList(List<VoteModel> votes) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: votes.length,
      itemBuilder: (context, index) {
        final vote = votes[index];
        return _buildVoteCard(vote);
      },
    );
  }

  Widget _buildVoteCard(VoteModel vote) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  vote.electionTitle,
                  style: AppTypography.kBody1.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getStatusColor(vote.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _getStatusText(vote.status),
                  style: AppTypography.kCaption.copyWith(
                    color: _getStatusColor(vote.status),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 16,
                color: AppColors.kGrey,
              ),
              const SizedBox(width: 8),
              Text(
                _formatDate(vote.votedAt),
                style: AppTypography.kCaption.copyWith(
                  color: AppColors.kGrey,
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.access_time,
                size: 16,
                color: AppColors.kGrey,
              ),
              const SizedBox(width: 8),
              Text(
                _formatTime(vote.votedAt),
                style: AppTypography.kCaption.copyWith(
                  color: AppColors.kGrey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.kSuccess.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: AppColors.kSuccess,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Vote enregistré avec succès',
                    style: AppTypography.kBody2.copyWith(
                      color: AppColors.kSuccess,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showVoteReceipt(vote),
                  icon: const Icon(Icons.receipt_long, size: 18),
                  label: const Text('Voir le reçu'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.kPrimary,
                    side: BorderSide(color: AppColors.kPrimary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _shareVote(vote),
                  icon: const Icon(Icons.share, size: 18),
                  label: const Text('Partager'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.kGrey,
                    side: BorderSide(color: AppColors.kGreyLight),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
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
            Icons.history,
            size: 80,
            color: AppColors.kGrey.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Aucun vote enregistré',
            style: AppTypography.kHeading3.copyWith(
              color: AppColors.kGrey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Vos votes apparaîtront ici',
            style: AppTypography.kBody2.copyWith(
              color: AppColors.kGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: AppColors.kError,
          ),
          const SizedBox(height: 16),
          Text(
            'Erreur',
            style: AppTypography.kHeading3.copyWith(
              color: AppColors.kError,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: AppTypography.kBody2.copyWith(
              color: AppColors.kGrey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showVoteReceipt(VoteModel vote) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reçu de Vote', style: AppTypography.kHeading3),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildReceiptRow('Élection', vote.electionTitle),
            const Divider(),
            _buildReceiptRow('Date', _formatDate(vote.votedAt)),
            const Divider(),
            _buildReceiptRow('Heure', _formatTime(vote.votedAt)),
            const Divider(),
            _buildReceiptRow('ID Vote', vote.id.toString()),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.kSuccess.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.verified,
                    color: AppColors.kSuccess,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Vote vérifié et enregistré',
                      style: AppTypography.kBody2.copyWith(
                        color: AppColors.kSuccess,
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
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTypography.kBody2.copyWith(
              color: AppColors.kGrey,
            ),
          ),
          Text(
            value,
            style: AppTypography.kBody2.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _shareVote(VoteModel vote) {
    // TODO: Implémenter le partage
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fonctionnalité de partage à venir'),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'COMPLETED':
        return AppColors.kSuccess;
      case 'ONGOING':
        return AppColors.kWarning;
      default:
        return AppColors.kGrey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'COMPLETED':
        return 'Terminée';
      case 'ONGOING':
        return 'En cours';
      default:
        return status;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
