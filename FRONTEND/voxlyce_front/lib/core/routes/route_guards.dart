import 'package:flutter/material.dart';
import '../../core/services/storage_service.dart';
import '../../core/constants/role_constants.dart';
import '../routes/app_routes.dart';

/// Route Guard for Authentication
class AuthGuard {
  static Future<bool> isAuthenticated() async {
    final token = await StorageService().getToken();
    return token != null && token.isNotEmpty;
  }
  
  static Future<String?> getUserRole() async {
    return await StorageService().getUserRole();
  }
}

/// Route Guard Middleware
class RouteGuard {
  /// Check if user can access route based on role
  static Future<bool> canAccess(String route) async {
    final isAuth = await AuthGuard.isAuthenticated();
    
    // Public routes
    if (route == AppRoutes.login || 
        route == AppRoutes.register || 
        route == AppRoutes.forgotPassword ||
        route == AppRoutes.resetPassword) {
      return true;
    }
    
    // Protected routes require authentication
    if (!isAuth) {
      return false;
    }
    
    final role = await AuthGuard.getUserRole();
    if (role == null) return false;
    
    // Admin routes
    if (route.startsWith('/admin')) {
      return RoleConstants.isAdmin(role);
    }
    
    // Supervisor routes
    if (route.startsWith('/supervisor')) {
      return RoleConstants.isSupervisor(role);
    }
    
    // Student routes
    if (route.startsWith('/student')) {
      return RoleConstants.isStudent(role);
    }
    
    // Common routes accessible by all authenticated users
    if (route == AppRoutes.profile || 
        route == AppRoutes.notifications || 
        route == AppRoutes.settings ||
        route == AppRoutes.help) {
      return true;
    }
    
    return false;
  }
  
  /// Get redirect route based on role
  static Future<String> getHomeRoute() async {
    final role = await AuthGuard.getUserRole();
    
    if (role == null) {
      return AppRoutes.login;
    }
    
    if (RoleConstants.isAdmin(role)) {
      return AppRoutes.adminDashboard;
    } else if (RoleConstants.isSupervisor(role)) {
      return AppRoutes.supervisorDashboard;
    } else if (RoleConstants.isStudent(role)) {
      return AppRoutes.studentDashboard;
    }
    
    return AppRoutes.login;
  }
}
