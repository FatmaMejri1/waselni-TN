import 'package:flutter/material.dart';

import '../data/notification_database.dart';
import '../domain/notification_model.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late Future<List<NotificationModel>> _notificationsFuture;

  @override
  void initState() {
    super.initState();
    _refreshNotifications();
  }

  void _refreshNotifications() {
    _notificationsFuture = NotificationDatabase.instance.getAll();
  }

  Future<void> _markAsRead(NotificationModel notification) async {
    await NotificationDatabase.instance.markAsRead(notification.id);

    if (!mounted) return;

    setState(_refreshNotifications);
  }

  Future<void> _deleteNotification(NotificationModel notification) async {
    await NotificationDatabase.instance.delete(notification.id);

    if (!mounted) return;

    setState(_refreshNotifications);

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Notification deleted')));
  }

  String _formatDate(DateTime date) {
    final localDate = date.toLocal();
    final datePart =
        '${localDate.day.toString().padLeft(2, '0')}/'
        '${localDate.month.toString().padLeft(2, '0')}/'
        '${localDate.year}';
    final timePart =
        '${localDate.hour.toString().padLeft(2, '0')}:'
        '${localDate.minute.toString().padLeft(2, '0')}';

    return '$datePart • $timePart';
  }

  Future<void> _openNotification(NotificationModel notification) async {
    if (!notification.isRead) {
      await NotificationDatabase.instance.markAsRead(notification.id);
    }

    if (!mounted) return;

    if (!notification.isRead) {
      setState(_refreshNotifications);
    }

    Navigator.of(context).pushNamed(notification.targetScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            tooltip: 'Refresh notifications',
            onPressed: () {
              setState(_refreshNotifications);
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder<List<NotificationModel>>(
        future: _notificationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Could not load notifications.'));
          }

          final notifications = snapshot.data ?? [];

          if (notifications.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.notifications_none,
                      size: 64,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No notifications yet',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'New transport updates and reports will appear here.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: notifications.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final notification = notifications[index];

              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: notification.isRead
                        ? Colors.grey.shade200
                        : Theme.of(context).colorScheme.primaryContainer,
                    child: Icon(
                      notification.isRead
                          ? Icons.notifications_none
                          : Icons.notifications_active,
                    ),
                  ),
                  title: Text(
                    notification.title,
                    style: TextStyle(
                      fontWeight: notification.isRead
                          ? FontWeight.normal
                          : FontWeight.bold,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(notification.body),
                        const SizedBox(height: 6),
                        Text(
                          _formatDate(notification.receivedAt),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        if (!notification.isRead)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              'Unread',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  isThreeLine: true,
                  onTap: () => _openNotification(notification),
                  trailing: PopupMenuButton<String>(
                    tooltip: 'Notification options',
                    onSelected: (value) {
                      if (value == 'read') {
                        _markAsRead(notification);
                      } else if (value == 'delete') {
                        _deleteNotification(notification);
                      }
                    },
                    itemBuilder: (context) => [
                      if (!notification.isRead)
                        const PopupMenuItem(
                          value: 'read',
                          child: Text('Mark as read'),
                        ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
