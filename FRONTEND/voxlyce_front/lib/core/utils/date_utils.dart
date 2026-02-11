import 'package:intl/intl.dart';

/// Date Utilities
class DateUtils {
  /// Format DateTime to readable string
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }

  /// Format DateTime to date only
  static String formatDate(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  /// Format DateTime to time only
  static String formatTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  /// Format DateTime to relative time (e.g., "il y a 2 heures")
  static String formatRelative(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return 'il y a $years ${years > 1 ? 'ans' : 'an'}';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return 'il y a $months mois';
    } else if (difference.inDays > 0) {
      return 'il y a ${difference.inDays} ${difference.inDays > 1 ? 'jours' : 'jour'}';
    } else if (difference.inHours > 0) {
      return 'il y a ${difference.inHours} ${difference.inHours > 1 ? 'heures' : 'heure'}';
    } else if (difference.inMinutes > 0) {
      return 'il y a ${difference.inMinutes} ${difference.inMinutes > 1 ? 'minutes' : 'minute'}';
    } else {
      return 'à l\'instant';
    }
  }

  /// Check if date is today
  static bool isToday(DateTime dateTime) {
    final now = DateTime.now();
    return dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day;
  }

  /// Check if date is in the past
  static bool isPast(DateTime dateTime) {
    return dateTime.isBefore(DateTime.now());
  }

  /// Check if date is in the future
  static bool isFuture(DateTime dateTime) {
    return dateTime.isAfter(DateTime.now());
  }
}
