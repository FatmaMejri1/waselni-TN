import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/constants/firestore_paths.dart';
import '../domain/schedule_model.dart';
import '../domain/schedule_source.dart';
import '../domain/schedule_status.dart';

class ScheduleService {
  ScheduleService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _schedulesCollection =>
      _firestore.collection(FirestorePaths.schedules);

  // Passenger: submit a schedule suggestion.
  Future<void> submitSchedule(ScheduleModel schedule) {
    final suggestion = schedule.copyWith(
      source: ScheduleSource.community,
      status: ScheduleStatus.pending,
    );

    return _schedulesCollection.doc(schedule.id).set(suggestion.toMap());
  }

  // Admin: observe suggestions awaiting review.
  Stream<List<ScheduleModel>> watchPendingSchedules() {
    return _schedulesCollection
        .where('status', isEqualTo: ScheduleStatus.pending.name)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ScheduleModel.fromMap(doc.data()))
              .toList(),
        );
  }

  // Admin: approve a suggestion.
  Future<void> approveSchedule({
    required String scheduleId,
    required String adminId,
  }) {
    return _schedulesCollection.doc(scheduleId).update({
      'status': ScheduleStatus.approved.name,
      'source': ScheduleSource.official.name,
      'reviewedBy': adminId,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Admin: reject a suggestion.
  Future<void> rejectSchedule({
    required String scheduleId,
    required String adminId,
  }) {
    return _schedulesCollection.doc(scheduleId).update({
      'status': ScheduleStatus.rejected.name,
      'reviewedBy': adminId,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Passengers: observe approved schedules.
  Stream<List<ScheduleModel>> watchApprovedSchedules() {
    return _schedulesCollection
        .where('status', isEqualTo: ScheduleStatus.approved.name)
        .orderBy('departureTime')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ScheduleModel.fromMap(doc.data()))
              .toList(),
        );
  }

  // Observe approved schedules for one transport line.
  Stream<List<ScheduleModel>> watchSchedulesForLine(String lineId) {
    return _schedulesCollection
        .where('lineId', isEqualTo: lineId)
        .where('status', isEqualTo: ScheduleStatus.approved.name)
        .orderBy('departureTime')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ScheduleModel.fromMap(doc.data()))
              .toList(),
        );
  }

  Future<ScheduleModel?> getSchedule(String scheduleId) async {
    final snapshot = await _schedulesCollection.doc(scheduleId).get();

    if (!snapshot.exists || snapshot.data() == null) {
      return null;
    }

    return ScheduleModel.fromMap(snapshot.data()!);
  }
}
