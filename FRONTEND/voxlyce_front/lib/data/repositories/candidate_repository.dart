import '../../core/services/api_service.dart';
import '../../core/constants/api_constants.dart';
import '../models/candidate_model.dart';
import '../models/payment_model.dart';

/// Candidate Repository
class CandidateRepository {
  final ApiService _apiService = ApiService();

  /// Apply as candidate
  Future<CandidateModel> applyAsCandidate({
    required int positionId,
    required String manifesto,
    String? studentCardPhotoUrl,
  }) async {
    try {
      final response = await _apiService.post(
        ApiConstants.studentCandidates,
        data: {
          'positionId': positionId,
          'manifesto': manifesto,
          if (studentCardPhotoUrl != null)
            'studentCardPhotoUrl': studentCardPhotoUrl,
        },
      );
      return CandidateModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  /// Get my candidatures
  Future<List<CandidateModel>> getMyCandidatures() async {
    try {
      final response = await _apiService.get(
        ApiConstants.studentMyCandidatures,
      );
      final List<dynamic> data = response.data as List;
      return data.map((json) => CandidateModel.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Update candidature
  Future<CandidateModel> updateCandidature({
    required int id,
    required int positionId,
    required String manifesto,
  }) async {
    try {
      final response = await _apiService.put(
        ApiConstants.studentUpdateCandidature(id),
        data: {
          'positionId': positionId,
          'manifesto': manifesto,
        },
      );
      return CandidateModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  /// Withdraw candidature
  Future<void> withdrawCandidature(int id) async {
    try {
      await _apiService.delete(ApiConstants.studentWithdrawCandidature(id));
    } catch (e) {
      rethrow;
    }
  }

  /// Pay deposit fee
  Future<PaymentResponseModel> payDepositFee({
    required int candidateId,
    required String paymentMethod,
    required String paymentReference,
    required double amount,
  }) async {
    try {
      final request = PaymentRequestModel(
        candidateId: candidateId,
        paymentMethod: paymentMethod,
        paymentReference: paymentReference,
        amount: amount,
      );

      final response = await _apiService.post(
        ApiConstants.studentPayDeposit(candidateId),
        data: request.toJson(),
      );
      return PaymentResponseModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  /// Get payment status
  Future<PaymentResponseModel> getPaymentStatus(int candidateId) async {
    try {
      final response = await _apiService.get(
        ApiConstants.studentPaymentStatus(candidateId),
      );
      return PaymentResponseModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  /// Upload student card photo
  Future<CandidateModel> uploadStudentCard({
    required int candidateId,
    required String photoUrl,
  }) async {
    try {
      final response = await _apiService.put(
        ApiConstants.studentUploadCard(candidateId),
        data: {
          'candidateId': candidateId,
          'photoUrl': photoUrl,
        },
      );
      return CandidateModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  /// Get election candidates
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

  /// Get pending candidates (Admin)
  Future<List<CandidateModel>> getPendingCandidates() async {
    try {
      final response = await _apiService.get(
        ApiConstants.adminCandidatesPending,
      );
      final List<dynamic> data = response.data as List;
      return data.map((json) => CandidateModel.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Update candidate status (Admin)
  Future<void> updateCandidateStatus({
    required int id,
    required String status,
  }) async {
    try {
      await _apiService.put(
        ApiConstants.adminCandidateStatus(id),
        data: {'status': status},
      );
    } catch (e) {
      rethrow;
    }
  }
}
