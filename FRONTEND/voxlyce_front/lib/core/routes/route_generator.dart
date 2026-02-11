import 'package:flutter/material.dart';
import 'app_routes.dart';
import '../../presentation/auth/screens/login_screen.dart';
import '../../presentation/auth/screens/register_screen.dart';
import '../../presentation/student/screens/student_dashboard.dart';
import '../../presentation/admin/screens/admin_dashboard.dart';
import '../../presentation/supervisor/screens/supervisor_dashboard.dart';
import '../../presentation/common/screens/profile_screen.dart';
import '../../presentation/voter/screens/election_list_screen.dart';
import '../../presentation/voter/screens/vote_screen.dart';
import '../../presentation/voter/screens/vote_confirmation_screen.dart';
import '../../presentation/candidate/screens/my_candidatures_screen.dart';
import '../../presentation/candidate/screens/candidate_registration_screen.dart';
import '../../presentation/results/screens/results_list_screen.dart';
import '../../presentation/results/screens/result_detail_screen.dart';

/// Route Generator
class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    
    switch (settings.name) {
      // Auth Routes
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      
      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      
      // Student Routes
      case AppRoutes.studentDashboard:
        return MaterialPageRoute(builder: (_) => const StudentDashboard());
      
      case AppRoutes.elections:
        return MaterialPageRoute(builder: (_) => const ElectionListScreen());
      
      case AppRoutes.vote:
        if (args is Map<String, dynamic>) {
          return MaterialPageRoute(
            builder: (_) => VoteScreen(
              electionId: args['electionId'] as int,
              electionTitle: args['electionTitle'] as String,
            ),
          );
        }
        return _errorRoute();
      
      case AppRoutes.voteConfirmation:
        if (args is Map<String, dynamic>) {
          return MaterialPageRoute(
            builder: (_) => VoteConfirmationScreen(
              electionId: args['electionId'] as int,
              selectedCandidates: args['selectedCandidates'] as Map<int, int>,
            ),
          );
        }
        return _errorRoute();
      
      case AppRoutes.candidatures:
        return MaterialPageRoute(builder: (_) => const MyCandidaturesScreen());
      
      case AppRoutes.registerCandidate:
        return MaterialPageRoute(builder: (_) => const CandidateRegistrationScreen());
      
      case AppRoutes.results:
        return MaterialPageRoute(builder: (_) => const ResultsListScreen());
      
      case AppRoutes.resultDetail:
        if (args is int) {
          return MaterialPageRoute(
            builder: (_) => ResultDetailScreen(electionId: args),
          );
        }
        return _errorRoute();
      
      // Admin Routes
      case AppRoutes.adminDashboard:
        return MaterialPageRoute(builder: (_) => const AdminDashboard());
      
      // Supervisor Routes
      case AppRoutes.supervisorDashboard:
        return MaterialPageRoute(builder: (_) => const SupervisorDashboard());
      
      // Common Routes
      case AppRoutes.profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      
      default:
        return _errorRoute();
    }
  }
  
  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(
          child: Text('Page not found'),
        ),
      ),
    );
  }
}
