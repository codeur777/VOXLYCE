import '../../core/services/api_service.dart';
import '../../core/constants/api_constants.dart';
import '../models/candidate_model.dart';
import '../models/vote_model.dart';

/// Vote Repository
class VoteRepository {
  final ApiService _apiService = ApiService();

  /// Get candidates for an election
  Future<List<CandidateModel>> getElectionCandidates(int electionId) async {
    try {
      final response = await _apiService.get(
        ApiConstants.studentElectionCandidates(electionId),
      );
      final List<dynamic> data = response.data as List;
      return data.map((json) => CandidateModel.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Check voting status for an election
  Future<Map<String, dynamic>> getVotingStatus(int electionId) async {
    try {
      final response = await _apiService.get(
        ApiConstants.studentVotingStatus(electionId),
      );
      return response.data as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }

  /// Submit vote
  Future<void> submitVote({
    required int electionId,
    required Map<int, int> votes, // positionId -> candidateId
  }) async {
    try {
      await _apiService.post(
        ApiConstants.studentVote,
        data: {
          'electionId': electionId,
          'votes': votes,
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Get election results
  Future<Map<String, dynamic>> getElectionResults(int electionId) async {
    try {
      final response = await _apiService.get(
        ApiConstants.studentElectionResults(electionId),
      );
      return response.data as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }

  /// Get public election results
  Future<Map<String, dynamic>> getPublicElectionResults(int electionId) async {
    try {
      final response = await _apiService.get(
        ApiConstants.publicElectionResults(electionId),
      );
      return response.data as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }

  /// Get vote history
  Future<List<VoteModel>> getVoteHistory({String? statusFilter}) async {
    try {
      // TODO: Replace with actual API call
      // For now, return mock data
      final mockVotes = [
        VoteModel(
          id: 1,
          electionId: 1,
          electionTitle: 'Élection du Comité de Classe L3 Info',
          candidateId: 1,
          candidateName: 'Jean Dupont',
          positionId: 1,
          positionName: 'Président',
          votedAt: DateTime.now().subtract(const Duration(days: 2)),
          status: 'COMPLETED',
          classroom: 'L3 Info',
        ),
        VoteModel(
          id: 2,
          electionId: 2,
          electionTitle: 'Élection du Bureau Étudiant',
          candidateId: 3,
          candidateName: 'Marie Martin',
          positionId: 2,
          positionName: 'Vice-Président',
          votedAt: DateTime.now().subtract(const Duration(days: 5)),
          status: 'COMPLETED',
          classroom: null,
        ),
        VoteModel(
          id: 3,
          electionId: 3,
          electionTitle: 'Élection Délégués M1',
          candidateId: 5,
          candidateName: 'Pierre Durand',
          positionId: 1,
          positionName: 'Délégué',
          votedAt: DateTime.now().subtract(const Duration(hours: 3)),
          status: 'ONGOING',
          classroom: 'M1 Info',
        ),
      ];

      if (statusFilter != null && statusFilter != 'ALL') {
        return mockVotes.where((v) => v.status == statusFilter).toList();
      }

      return mockVotes;
    } catch (e) {
      rethrow;
    }
  }
}
