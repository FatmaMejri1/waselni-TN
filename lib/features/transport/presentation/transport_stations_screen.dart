import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/transport_provider.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/station_model.dart';

class TransportStationsScreen extends ConsumerWidget {
  const TransportStationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final stationsAsync = ref.watch(activeStationsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.transportStations)),
      body: stationsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => _MessageView(
          icon: Icons.error_outline,
          message: l10n.stationsLoadError,
          actionLabel: l10n.retry,
          onAction: () => ref.invalidate(stationsProvider),
        ),
        data: (stations) {
          if (stations.isEmpty) {
            return _MessageView(
              icon: Icons.location_off_outlined,
              message: l10n.noStationsAvailable,
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(stationsProvider);
              await ref.read(stationsProvider.future);
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: stations.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return _StationCard(station: stations[index]);
              },
            ),
          );
        },
      ),
    );
  }
}

class _StationCard extends StatelessWidget {
  const _StationCard({required this.station});

  final StationModel station;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: colorScheme.primaryContainer,
              child: Icon(
                Icons.location_on_outlined,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(station.name, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(
                    '${l10n.coordinates}:',
                    style: theme.textTheme.labelMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${station.latitude}, ${station.longitude}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
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
