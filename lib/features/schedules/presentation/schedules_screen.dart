import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/schedule_provider.dart';
import '../../../core/providers/transport_provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../transport/domain/line_model.dart';
import '../domain/schedule_model.dart';
import 'submit_schedule_screen.dart';

class SchedulesScreen extends ConsumerWidget {
  const SchedulesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final schedulesAsync = ref.watch(approvedSchedulesProvider);
    final linesAsync = ref.watch(linesProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const SubmitScheduleScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: Text(l10n.submitSchedule),
            ),
          ),
        ),
        Expanded(
          child: schedulesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => _MessageView(
              icon: Icons.error_outline,
              message: l10n.scheduleLoadError,
            ),
            data: (schedules) {
              if (schedules.isEmpty) {
                return _MessageView(
                  icon: Icons.schedule_outlined,
                  message: l10n.noSchedulesAvailable,
                );
              }

              return linesAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) => _MessageView(
                  icon: Icons.error_outline,
                  message: l10n.scheduleLoadError,
                ),
                data: (lineList) {
                  final lines = {for (final line in lineList) line.id: line};

                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: schedules.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final schedule = schedules[index];
                      final line = lines[schedule.lineId];

                      return _ScheduleCard(
                        schedule: schedule,
                        line: line,
                        l10n: l10n,
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  const _ScheduleCard({
    required this.schedule,
    required this.line,
    required this.l10n,
  });

  final ScheduleModel schedule;
  final LineModel? line;
  final AppLocalizations l10n;

  String _dayName(int day) {
    switch (day) {
      case 1:
        return l10n.monday;
      case 2:
        return l10n.tuesday;
      case 3:
        return l10n.wednesday;
      case 4:
        return l10n.thursday;
      case 5:
        return l10n.friday;
      case 6:
        return l10n.saturday;
      case 7:
        return l10n.sunday;
      default:
        return day.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final lineName = line == null
        ? l10n.transportSchedules
        : '${line!.code} - ${line!.name}';

    final days = schedule.days.map(_dayName).join(' • ');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.directions_transit),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(lineName, style: theme.textTheme.titleMedium),
                ),
                const Icon(Icons.verified, color: Colors.green),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.access_time),
                const SizedBox(width: 8),
                Text(
                  '${l10n.departureTime}: ${schedule.departureTime}',
                  style: theme.textTheme.bodyLarge,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.calendar_today_outlined, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${l10n.operatingDays}: $days',
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              l10n.officialSchedule,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageView extends StatelessWidget {
  const _MessageView({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
