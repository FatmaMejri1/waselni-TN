import 'package:cloud_firestore/cloud_firestore.dart';

import 'schedule_source.dart';
import 'schedule_status.dart';

class ScheduleModel {
  final String id;
  final String lineId;
  final String departureTime;
  final List<int> days;
  final ScheduleSource source;
  final ScheduleStatus status;
  final String submittedBy;
  final String? reviewedBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ScheduleModel({
    required this.id,
    required this.lineId,
    required this.departureTime,
    required this.days,
    this.source = ScheduleSource.community,
    this.status = ScheduleStatus.pending,
    required this.submittedBy,
    this.reviewedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'lineId': lineId,
      'departureTime': departureTime,
      'days': days,
      'source': source.name,
      'status': status.name,
      'submittedBy': submittedBy,
      'reviewedBy': reviewedBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory ScheduleModel.fromMap(Map<String, dynamic> map) {
    final sourceName = map['source'] as String? ?? 'community';
    final statusName = map['status'] as String? ?? 'pending';

    return ScheduleModel(
      id: map['id'] as String,
      lineId: map['lineId'] as String,
      departureTime: map['departureTime'] as String,
      days: List<int>.from(map['days'] as List? ?? []),
      source: ScheduleSource.values.firstWhere(
        (source) => source.name == sourceName,
        orElse: () => ScheduleSource.community,
      ),
      status: ScheduleStatus.values.firstWhere(
        (status) => status.name == statusName,
        orElse: () => ScheduleStatus.pending,
      ),
      submittedBy: map['submittedBy'] as String,
      reviewedBy: map['reviewedBy'] as String?,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }

  ScheduleModel copyWith({
    String? departureTime,
    List<int>? days,
    ScheduleSource? source,
    ScheduleStatus? status,
    String? reviewedBy,
    bool clearReviewedBy = false,
    DateTime? updatedAt,
  }) {
    return ScheduleModel(
      id: id,
      lineId: lineId,
      departureTime: departureTime ?? this.departureTime,
      days: days ?? this.days,
      source: source ?? this.source,
      status: status ?? this.status,
      submittedBy: submittedBy,
      reviewedBy: clearReviewedBy ? null : reviewedBy ?? this.reviewedBy,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
