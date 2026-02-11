import '../../core/services/api_service.dart';
import '../../core/constants/api_constants.dart';
import '../models/election_model.dart';

/// Election Repository
class ElectionRepository {
  final ApiService _apiService = ApiService();

  /// Get all elections (Student)
  Future<List<ElectionModel>> getElections() async {
    try {
      final response = await _apiService.get(ApiConstants.studentElections);
      final List<dynamic> data = response.data as List;
      return data.map((json) => ElectionModel.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Get election details
  Future<ElectionModel> getElectionDetails(int id) async {
    try {
      final response = await _apiService.get(
        ApiConstants.studentElectionDetails(id),
      );
      return ElectionModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  /// Get public elections
  Future<List<ElectionModel>> getPublicElections() async {
    try {
      final response = await _apiService.get(ApiConstants.publicElections);
      final List<dynamic> data = response.data as List;
      return data.map((json) => ElectionModel.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Get public election details
  Future<ElectionModel> getPublicElectionDetails(int id) async {
    try {
      final response = await _apiService.get(
        ApiConstants.publicElectionDetails(id),
      );
      return ElectionModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  /// Get elections history
  Future<List<ElectionModel>> getElectionsHistory() async {
    try {
      final response = await _apiService.get(
        ApiConstants.studentElectionsHistory,
      );
      final List<dynamic> data = response.data as List;
      return data.map((json) => ElectionModel.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Create election (Admin)
  Future<ElectionModel> createElection({
    required String title,
    required String type,
    required List<String> positionNames,
    int? classroomId,
  }) async {
    try {
      final response = await _apiService.post(
        ApiConstants.adminElections,
        data: {
          'title': title,
          'type': type,
          'positionNames': positionNames,
          if (classroomId != null) 'classroomId': classroomId,
        },
      );
      return ElectionModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  /// Start election (Supervisor)
  Future<void> startElection(int id) async {
    try {
      await _apiService.post(ApiConstants.supervisorStartElection(id));
    } catch (e) {
      rethrow;
    }
  }

  /// Get elector count (Supervisor)
  Future<int> getElectorCount(int id) async {
    try {
      final response = await _apiService.get(
        ApiConstants.supervisorElectorCount(id),
      );
      return response.data as int;
    } catch (e) {
      rethrow;
    }
  }

  /// Validate results (Admin)
  Future<void> validateResults(int id) async {
    try {
      await _apiService.post(ApiConstants.adminValidateResults(id));
    } catch (e) {
      rethrow;
    }
  }
}
