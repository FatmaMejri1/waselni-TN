import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/transport_type.dart';
import '../../../core/providers/transport_provider.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/line_model.dart';

class TransportLinesScreen extends ConsumerWidget {
  const TransportLinesScreen({super.key, required this.transportType});

  final TransportType transportType;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final linesAsync = ref
        .watch(activeLinesProvider)
        .whenData(
          (lines) => lines
              .where((line) => line.transportType == transportType)
              .toList(),
        );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.transportLines)),
      body: linesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => _MessageView(
          icon: Icons.error_outline,
          message: l10n.linesLoadError,
          actionLabel: l10n.retry,
          onAction: () => ref.invalidate(linesProvider),
        ),
        data: (lines) {
          if (lines.isEmpty) {
            return _MessageView(
              icon: Icons.directions_transit_outlined,
              message: l10n.noLinesAvailable,
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(linesProvider);
              await ref.read(linesProvider.future);
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: lines.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return _LineCard(line: lines[index]);
              },
            ),
          );
        },
      ),
    );
  }
}

class _LineCard extends StatelessWidget {
  const _LineCard({required this.line});

  final LineModel line;

  IconData get _transportIcon {
    switch (line.transportType) {
      case TransportType.bus:
        return Icons.directions_bus;
      case TransportType.metro:
        return Icons.subway;
      case TransportType.train:
        return Icons.train;
      case TransportType.tgm:
        return Icons.tram;
      case TransportType.other:
        return Icons.directions_transit;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: colorScheme.primaryContainer,
              child: Icon(
                _transportIcon,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(line.name, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    '${line.transportType.displayName} • ${line.code}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (line.description.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(line.description, style: theme.textTheme.bodySmall),
                  ],
                  const SizedBox(height: 6),
                  Text(
                    AppLocalizations.of(context)!
                        .stationsCount(line.stationIds.length),
                    style: theme.textTheme.labelMedium,
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}

class _MessageView extends StatelessWidget {
  const _MessageView({
    required this.icon,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

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
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 16),
              FilledButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}
