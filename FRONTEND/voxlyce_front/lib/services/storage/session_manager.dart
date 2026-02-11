import 'dart:async';
import 'secure_storage.dart';

/// Session Manager for handling user sessions
class SessionManager {
  static final SessionManager _instance = SessionManager._internal();
  factory SessionManager() => _instance;
  SessionManager._internal();

  final SecureStorageService _secureStorage = SecureStorageService();

  Timer? _sessionTimer;
  DateTime? _lastActivityTime;
  
  // Session timeout duration (30 minutes)
  static const Duration sessionTimeout = Duration(minutes: 30);
  
  // Warning before timeout (5 minutes before)
  static const Duration warningBeforeTimeout = Duration(minutes: 5);

  // Stream controllers for session events
  final _sessionExpiredController = StreamController<void>.broadcast();
  final _sessionWarningController = StreamController<void>.broadcast();

  Stream<void> get onSessionExpired => _sessionExpiredController.stream;
  Stream<void> get onSessionWarning => _sessionWarningController.stream;

  /// Start session monitoring
  void startSession() {
    _lastActivityTime = DateTime.now();
    _startSessionTimer();
  }

  /// Update last activity time
  void updateActivity() {
    _lastActivityTime = DateTime.now();
  }

  /// Stop session monitoring
  void stopSession() {
    _sessionTimer?.cancel();
    _sessionTimer = null;
    _lastActivityTime = null;
  }

  /// Check if session is active
  bool isSessionActive() {
    if (_lastActivityTime == null) return false;
    
    final now = DateTime.now();
    final difference = now.difference(_lastActivityTime!);
    
    return difference < sessionTimeout;
  }

  /// Get remaining session time
  Duration? getRemainingTime() {
    if (_lastActivityTime == null) return null;
    
    final now = DateTime.now();
    final elapsed = now.difference(_lastActivityTime!);
    final remaining = sessionTimeout - elapsed;
    
    return remaining.isNegative ? Duration.zero : remaining;
  }

  /// Start session timer
  void _startSessionTimer() {
    _sessionTimer?.cancel();
    
    _sessionTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (!isSessionActive()) {
        _handleSessionExpired();
      } else {
        final remaining = getRemainingTime();
        if (remaining != null && remaining <= warningBeforeTimeout) {
          _sessionWarningController.add(null);
        }
      }
    });
  }

  /// Handle session expiration
  void _handleSessionExpired() async {
    stopSession();
    await _secureStorage.clearAuthData();
    _sessionExpiredController.add(null);
  }

  /// Extend session
  void extendSession() {
    updateActivity();
  }

  /// Logout and clear session
  Future<void> logout() async {
    stopSession();
    await _secureStorage.clearAll();
  }

  /// Dispose resources
  void dispose() {
    _sessionTimer?.cancel();
    _sessionExpiredController.close();
    _sessionWarningController.close();
  }
}
