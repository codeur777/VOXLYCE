import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/theme/app_theme.dart';
import 'core/services/storage_service.dart';
import 'core/routes/route_generator.dart';
import 'core/routes/app_routes.dart';
import 'core/constants/role_constants.dart';
import 'presentation/auth/bloc/auth_bloc.dart';
import 'presentation/auth/bloc/auth_event.dart';
import 'presentation/auth/bloc/auth_state.dart';
import 'presentation/auth/screens/login_screen.dart';
import 'presentation/voter/bloc/vote_bloc.dart';
import 'presentation/candidate/bloc/candidate_bloc.dart';
import 'presentation/student/screens/student_dashboard.dart';
import 'presentation/admin/screens/admin_dashboard.dart';
import 'presentation/supervisor/screens/supervisor_dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize storage
  await StorageService().init();
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => AuthBloc()..add(CheckAuthStatus())),
            BlocProvider(create: (_) => VoteBloc()),
            BlocProvider(create: (_) => CandidateBloc()),
          ],
          child: MaterialApp(
            title: 'Voxlyce',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.light,
            onGenerateRoute: RouteGenerator.generateRoute,
            home: const SplashScreen(),
          ),
        );
      },
    );
  }
}

/// Splash Screen with Auth Check and Role-Based Routing
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          return _getRoleBasedHome(state.authResponse.role);
        } else if (state is AuthUnauthenticated) {
          return const LoginScreen();
        }
        
        // Loading state
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
  
  Widget _getRoleBasedHome(String role) {
    if (RoleConstants.isAdmin(role)) {
      return const AdminDashboard();
    } else if (RoleConstants.isSupervisor(role)) {
      return const SupervisorDashboard();
    } else if (RoleConstants.isStudent(role)) {
      return const StudentDashboard();
    }
    
    // Default to student dashboard
    return const StudentDashboard();
  }
}
