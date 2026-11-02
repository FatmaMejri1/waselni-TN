import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/schedules/data/schedule_service.dart';
import '../../features/schedules/domain/schedule_model.dart';
import 'auth_provider.dart';

/// Provides the schedule service.
final scheduleServiceProvider = Provider<ScheduleService>((ref) {
  return ScheduleService(firestore: ref.watch(firestoreProvider));
});

/// Listens to approved schedules in real time.
final approvedSchedulesProvider = StreamProvider<List<ScheduleModel>>((ref) {
  return ref.watch(scheduleServiceProvider).watchApprovedSchedules();
});
