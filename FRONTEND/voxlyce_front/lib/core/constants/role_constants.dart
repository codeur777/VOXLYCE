/// Role Constants for Voxlyce
class RoleConstants {
  static const String admin = 'ADMIN';
  static const String supervisor = 'SUPERVISOR';
  static const String student = 'STUDENT';
  static const String voter = 'VOTER'; // Alias for STUDENT
  
  /// Check if role is admin
  static bool isAdmin(String role) => role.toUpperCase() == admin;
  
  /// Check if role is supervisor
  static bool isSupervisor(String role) => role.toUpperCase() == supervisor;
  
  /// Check if role is student/voter
  static bool isStudent(String role) {
    final upperRole = role.toUpperCase();
    return upperRole == student || upperRole == voter;
  }
}
