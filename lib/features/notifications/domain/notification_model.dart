class NotificationModel {
  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.receivedAt,
    this.isRead = false,
    this.targetScreen = '/home',
  });

  final String id;
  final String title;
  final String body;
  final DateTime receivedAt;
  final bool isRead;
  final String targetScreen;

  NotificationModel copyWith({bool? isRead}) {
    return NotificationModel(
      id: id,
      title: title,
      body: body,
      receivedAt: receivedAt,
      isRead: isRead ?? this.isRead,
      targetScreen: targetScreen,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'receivedAt': receivedAt.toIso8601String(),
      'isRead': isRead,
      'targetScreen': targetScreen,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] as String,
      title: map['title'] as String,
      body: map['body'] as String,
      receivedAt: DateTime.parse(map['receivedAt'] as String),
      isRead: map['isRead'] as bool? ?? false,
      targetScreen: map['targetScreen'] as String? ?? '/home',
    );
  }
}
