/// API Constants for Voxlyce Backend
class ApiConstants {
  // Base URL
  static const String baseUrl = 'http://localhost:8080/api/v1';
  
  // Timeout
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // Auth Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String verify2FA = '/auth/verify-2fa';
  
  // Admin Endpoints
  static const String adminElections = '/admin/elections';
  static const String adminCandidatesPending = '/admin/candidates/pending';
  static String adminCandidateStatus(int id) => '/admin/candidates/$id/status';
  static String adminValidateResults(int id) => '/admin/elections/$id/validate-results';
  
  // Supervisor Endpoints
  static String supervisorStartElection(int id) => '/supervisor/elections/$id/start';
  static String supervisorElectorCount(int id) => '/supervisor/elections/$id/elector-count';
  
  // Student - Candidature Endpoints
  static const String studentCandidates = '/student/candidates';
  static const String studentMyCandidatures = '/student/candidates/my-candidatures';
  static String studentUpdateCandidature(int id) => '/student/candidates/$id';
  static String studentWithdrawCandidature(int id) => '/student/candidates/$id';
  static String studentPayDeposit(int id) => '/student/candidates/$id/pay-deposit';
  static String studentPaymentStatus(int id) => '/student/candidates/$id/payment-status';
  static String studentUploadCard(int id) => '/student/candidates/$id/upload-student-card';
  
  // Student - Elections Endpoints
  static const String studentElections = '/student/elections';
  static String studentElectionDetails(int id) => '/student/elections/$id';
  static String studentElectionCandidates(int id) => '/student/elections/$id/candidates';
  static String studentVotingStatus(int id) => '/student/elections/$id/voting-status';
  static const String studentVote = '/student/vote';
  static String studentElectionResults(int id) => '/student/elections/$id/results';
  static const String studentElectionsHistory = '/student/elections/history';
  
  // Public Endpoints
  static const String publicElections = '/elections';
  static String publicElectionDetails(int id) => '/elections/$id';
  static String publicElectionResults(int id) => '/elections/$id/results';
  
  // Headers
  static Map<String, String> headers({String? token}) {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    
    return headers;
  }
}
