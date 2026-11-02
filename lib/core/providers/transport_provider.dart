import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/transport/data/transport_service.dart';
import '../../features/transport/domain/line_model.dart';
import '../../features/transport/domain/station_model.dart';
import 'auth_provider.dart';

/// Provides the transport service.
final transportServiceProvider = Provider<TransportService>((ref) {
  return TransportService(firestore: ref.watch(firestoreProvider));
});

/// Listens to all transport lines in real time.
final linesProvider = StreamProvider<List<LineModel>>((ref) {
  return ref.watch(transportServiceProvider).watchLines();
});

/// Listens to all stations in real time.
final stationsProvider = StreamProvider<List<StationModel>>((ref) {
  return ref.watch(transportServiceProvider).watchStations();
});

/// Provides only active transport lines.
final activeLinesProvider = Provider<AsyncValue<List<LineModel>>>((ref) {
  return ref
      .watch(linesProvider)
      .whenData((lines) => lines.where((line) => line.isActive).toList());
});

/// Provides only active stations.
final activeStationsProvider = Provider<AsyncValue<List<StationModel>>>((ref) {
  return ref
      .watch(stationsProvider)
      .whenData(
        (stations) => stations.where((station) => station.isActive).toList(),
      );
});
