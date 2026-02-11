import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/appbars/custom_appbar.dart';
import '../../../core/widgets/loading/loading_widget.dart';
import '../../../core/utils/snackbar_utils.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _notifications = [];
  String _filterType = 'ALL';

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() => _isLoading = true);
    try {
      // TODO: Call API
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock data
      _notifications = [
        {
          'id': 1,
          'title': 'Candidature acceptée',
          'message': 'Votre candidature pour le poste de Président a été acceptée.',
          'type': 'SUCCESS',
          'read': false,
          'timestamp': DateTime.now().subtract(const Duration(minutes: 30)),
        },
        {
          'id': 2,
          'title': 'Nouvelle élection',
          'message': 'Une nouvelle élection "Comité L3 Info" est disponible.',
          'type': 'INFO',
          'read': false,
          'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
        },
        {
          'id': 3,
          'title': 'Résultats publiés',
          'message': 'Les résultats de l\'élection du Bureau Étudiant sont disponibles.',
          'type': 'INFO',
          'read': true,
          'timestamp': DateTime.now().subtract(const Duration(days: 1)),
        },
        {
          'id': 4,
          'title': 'Paiement confirmé',
          'message': 'Votre paiement de 500F a été confirmé.',
          'type': 'SUCCESS',
          'read': true,
          'timestamp': DateTime.now().subtract(const Duration(days: 2)),
        },
        {
          'id': 5,
          'title': 'Rappel: Vote en cours',
          'message': 'N\'oubliez pas de voter pour l\'élection en cours.',
          'type': 'WARNING',
          'read': true,
          'timestamp': DateTime.now().subtract(const Duration(days: 3)),
        },
      ];
    } catch (e) {
      if (mounted) {
        SnackbarUtils.showError(context, 'Erreur: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  List<Map<String, dynamic>> get filteredNotifications {
    if (_filterType == 'ALL') {
      return _notifications;
    } else if (_filterType == 'UNREAD') {
      return _notifications.where((n) => n['read'] == false).toList();
    } else {
      return _notifications.where((n) => n['type'] == _filterType).toList();
    }
  }

  Future<void> _markAsRead(Map<String, dynamic> notification) async {
    try {
      // TODO: Call API
      await Future.delayed(const Duration(milliseconds: 300));
      
      setState(() {
        final index = _notifications.indexWhere((n) => n['id'] == notification['id']);
        if (index != -1) {
          _notifications[index]['read'] = true;
        }
      });
    } catch (e) {
      if (mounted) {
        SnackbarUtils.showError(context, 'Erreur: ${e.toString()}');
      }
    }
  }

  Future<void> _markAllAsRead() async {
    try {
      // TODO: Call API
      await Future.delayed(const Duration(milliseconds: 500));
      
      setState(() {
        for (var notification in _notifications) {
          notification['read'] = true;
        }
      });
      
      if (mounted) {
        SnackbarUtils.showSuccess(context, 'Toutes les notifications marquées comme lues');
      }
    } catch (e) {
      if (mounted) {
        SnackbarUtils.showError(context, 'Erreur: ${e.toString()}');
      }
    }
  }

  Future<void> _deleteNotification(Map<String, dynamic> notification) async {
    try {
      // TODO: Call API
      await Future.delayed(const Duration(milliseconds: 300));
      
      setState(() {
        _notifications.removeWhere((n) => n['id'] == notification['id']);
      });
      
      if (mounted) {
        SnackbarUtils.showSuccess(context, 'Notification supprimée');
      }
    } catch (e) {
      if (mounted) {
        SnackbarUtils.showError(context, 'Erreur: ${e.toString()}');
      }
    }
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'SUCCESS':
        return AppColors.kSuccess;
      case 'WARNING':
        return AppColors.kWarning;
      case 'ERROR':
        return AppColors.kError;
      default:
        return AppColors.kInfo;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'SUCCESS':
        return Icons.check_circle;
      case 'WARNING':
        return Icons.warning;
      case 'ERROR':
        return Icons.error;
      default:
        return Icons.info;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return 'Il y a ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'Il y a ${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return 'Il y a ${difference.inDays}j';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  int get unreadCount => _notifications.where((n) => n['read'] == false).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kBackground,
      appBar: CustomAppBar(
        title: 'Notifications',
        actions: [
          if (unreadCount > 0)
            IconButton(
              icon: const Icon(Icons.done_all),
              onPressed: _markAllAsRead,
              tooltip: 'Tout marquer comme lu',
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadNotifications,
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats & Filters
          Container(
            padding: EdgeInsets.all(AppSpacing.md),
            color: AppColors.kWhite,
            child: Column(
              children: [
                // Unread Count
                if (unreadCount > 0)
                  Container(
                    padding: EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: AppColors.kPrimary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.notifications_active, color: AppColors.kPrimary),
                        SizedBox(width: AppSpacing.xs),
                        Text(
                          '$unreadCount notification${unreadCount > 1 ? 's' : ''} non lue${unreadCount > 1 ? 's' : ''}',
                          style: AppTypography.kBody1.copyWith(
                            color: AppColors.kPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                
                SizedBox(height: AppSpacing.md),

                // Filters
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('ALL', 'Toutes'),
                      SizedBox(width: AppSpacing.sm),
                      _buildFilterChip('UNREAD', 'Non lues'),
                      SizedBox(width: AppSpacing.sm),
                      _buildFilterChip('INFO', 'Info'),
                      SizedBox(width: AppSpacing.sm),
                      _buildFilterChip('SUCCESS', 'Succès'),
                      SizedBox(width: AppSpacing.sm),
                      _buildFilterChip('WARNING', 'Alertes'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Notifications List
          Expanded(
            child: _isLoading
                ? const LoadingWidget()
                : filteredNotifications.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                        onRefresh: _loadNotifications,
                        child: ListView.builder(
                          padding: EdgeInsets.all(AppSpacing.md),
                          itemCount: filteredNotifications.length,
                          itemBuilder: (context, index) {
                            final notification = filteredNotifications[index];
                            return _buildNotificationCard(notification);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String value, String label) {
    final isSelected = _filterType == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() => _filterType = value);
      },
      backgroundColor: AppColors.kWhite,
      selectedColor: AppColors.kPrimary.withOpacity(0.2),
      labelStyle: TextStyle(
        color: isSelected ? AppColors.kPrimary : AppColors.kGrey,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    final isRead = notification['read'] as bool;
    final type = notification['type'] as String;
    final typeColor = _getTypeColor(type);

    return Dismissible(
      key: Key(notification['id'].toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.kError,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: Icon(Icons.delete, color: AppColors.kWhite),
      ),
      onDismissed: (direction) {
        _deleteNotification(notification);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: AppSpacing.md),
        decoration: BoxDecoration(
          color: isRead ? AppColors.kWhite : AppColors.kPrimary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          boxShadow: [AppColors.cardShadow],
          border: isRead ? null : Border.all(color: AppColors.kPrimary.withOpacity(0.3)),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              if (!isRead) {
                _markAsRead(notification);
              }
            },
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: typeColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                    child: Icon(
                      _getTypeIcon(type),
                      color: typeColor,
                      size: 24.sp,
                    ),
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                notification['title'],
                                style: AppTypography.kBody1.copyWith(
                                  fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                                ),
                              ),
                            ),
                            if (!isRead)
                              Container(
                                width: 8.w,
                                height: 8.h,
                                decoration: BoxDecoration(
                                  color: AppColors.kPrimary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: AppSpacing.xs),
                        Text(
                          notification['message'],
                          style: AppTypography.kBody2.copyWith(
                            color: AppColors.kGrey,
                          ),
                        ),
                        SizedBox(height: AppSpacing.xs),
                        Text(
                          _formatTimestamp(notification['timestamp']),
                          style: AppTypography.kCaption.copyWith(
                            color: AppColors.kGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 80.sp,
            color: AppColors.kGrey.withOpacity(0.5),
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            'Aucune notification',
            style: AppTypography.kHeading3.copyWith(
              color: AppColors.kGrey,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            'Vous êtes à jour !',
            style: AppTypography.kBody1.copyWith(
              color: AppColors.kGrey,
            ),
          ),
        ],
      ),
    );
  }
}
