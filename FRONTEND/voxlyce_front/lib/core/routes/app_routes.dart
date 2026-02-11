/// App Routes Definition
class AppRoutes {
  // Auth Routes
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String twoFactor = '/two-factor';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  
  // Student Routes
  static const String studentDashboard = '/student';
  static const String elections = '/student/elections';
  static const String electionDetail = '/student/elections/detail';
  static const String vote = '/student/vote';
  static const String voteConfirmation = '/student/vote/confirmation';
  static const String candidatures = '/student/candidatures';
  static const String candidatureDetail = '/student/candidatures/detail';
  static const String registerCandidate = '/student/register-candidate';
  static const String paymentScreen = '/student/payment';
  static const String uploadCard = '/student/upload-card';
  static const String results = '/student/results';
  static const String resultDetail = '/student/results/detail';
  static const String voteHistory = '/student/vote-history';
  
  // Admin Routes
  static const String adminDashboard = '/admin';
  static const String manageElections = '/admin/elections';
  static const String createElection = '/admin/elections/create';
  static const String editElection = '/admin/elections/edit';
  static const String validateCandidates = '/admin/candidates/validate';
  static const String candidateDetailAdmin = '/admin/candidates/detail';
  static const String validateResults = '/admin/results/validate';
  static const String statistics = '/admin/statistics';
  static const String auditLogs = '/admin/audit-logs';
  
  // Supervisor Routes
  static const String supervisorDashboard = '/supervisor';
  static const String assignedElections = '/supervisor/elections';
  static const String launchVote = '/supervisor/launch-vote';
  static const String verifyStudents = '/supervisor/verify-students';
  static const String monitorElection = '/supervisor/monitor';
  
  // Common Routes
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';
  static const String notifications = '/notifications';
  static const String settings = '/settings';
  static const String help = '/help';
  static const String faq = '/faq';
}
