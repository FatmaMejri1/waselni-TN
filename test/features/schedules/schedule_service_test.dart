import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:waselni/features/schedules/data/schedule_service.dart';
import 'package:waselni/features/schedules/domain/schedule_model.dart';
import 'package:waselni/features/schedules/domain/schedule_source.dart';
import 'package:waselni/features/schedules/domain/schedule_status.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late ScheduleService scheduleService;

  final now = DateTime(2026, 11, 1);

  ScheduleModel createSchedule({
    String id = 'schedule-1',
    String lineId = 'line-1',
  }) {
    return ScheduleModel(
      id: id,
      lineId: lineId,
      departureTime: '07:30',
      days: const [1, 2, 3, 4, 5],
      submittedBy: 'passenger-1',
      createdAt: now,
      updatedAt: now,
    );
  }

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    scheduleService = ScheduleService(firestore: fakeFirestore);
  });

  group('Schedule submission', () {
    test('submits a suggestion as pending and community', () async {
      await scheduleService.submitSchedule(createSchedule());

      final result = await scheduleService.getSchedule('schedule-1');

      expect(result, isNotNull);
      expect(result!.status, ScheduleStatus.pending);
      expect(result.source, ScheduleSource.community);
      expect(result.submittedBy, 'passenger-1');
    });

    test('returns null for an unknown schedule', () async {
      final result = await scheduleService.getSchedule('unknown');

      expect(result, isNull);
    });
  });

  group('Schedule moderation', () {
    test('approves a schedule and makes it official', () async {
      await scheduleService.submitSchedule(createSchedule());

      await scheduleService.approveSchedule(
        scheduleId: 'schedule-1',
        adminId: 'admin-1',
      );

      final result = await scheduleService.getSchedule('schedule-1');

      expect(result!.status, ScheduleStatus.approved);
      expect(result.source, ScheduleSource.official);
      expect(result.reviewedBy, 'admin-1');
    });

    test('rejects a schedule and keeps community source', () async {
      await scheduleService.submitSchedule(createSchedule());

      await scheduleService.rejectSchedule(
        scheduleId: 'schedule-1',
        adminId: 'admin-1',
      );

      final result = await scheduleService.getSchedule('schedule-1');

      expect(result!.status, ScheduleStatus.rejected);
      expect(result.source, ScheduleSource.community);
      expect(result.reviewedBy, 'admin-1');
    });
  });

  group('Schedule queries', () {
    test('returns only approved schedules for a line', () async {
      await scheduleService.submitSchedule(createSchedule());

      await scheduleService.submitSchedule(
        createSchedule(id: 'schedule-2', lineId: 'line-1'),
      );

      await scheduleService.submitSchedule(
        createSchedule(id: 'schedule-3', lineId: 'line-2'),
      );

      await scheduleService.approveSchedule(
        scheduleId: 'schedule-1',
        adminId: 'admin-1',
      );

      await scheduleService.approveSchedule(
        scheduleId: 'schedule-3',
        adminId: 'admin-1',
      );

      final schedules = await scheduleService
          .watchSchedulesForLine('line-1')
          .first;

      expect(schedules.length, 1);
      expect(schedules.first.id, 'schedule-1');
    });

    test('returns pending suggestions', () async {
      await scheduleService.submitSchedule(createSchedule());

      final schedules = await scheduleService.watchPendingSchedules().first;

      expect(schedules.length, 1);
      expect(schedules.first.status, ScheduleStatus.pending);
    });

    test('does not return rejected schedules as approved', () async {
      await scheduleService.submitSchedule(createSchedule());

      await scheduleService.rejectSchedule(
        scheduleId: 'schedule-1',
        adminId: 'admin-1',
      );

      final schedules = await scheduleService.watchApprovedSchedules().first;

      expect(schedules, isEmpty);
    });
  });
}
