import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/constants/firestore_paths.dart';
import '../domain/line_model.dart';
import '../domain/station_model.dart';

class TransportService {
  TransportService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  // -------------------- LINES --------------------

  CollectionReference<Map<String, dynamic>> get _linesCollection =>
      _firestore.collection(FirestorePaths.lines);

  Stream<List<LineModel>> watchLines() {
    return _linesCollection
        .orderBy('name')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => LineModel.fromMap(doc.data()))
              .toList(),
        );
  }

  Future<LineModel?> getLine(String lineId) async {
    final snapshot = await _linesCollection.doc(lineId).get();

    if (!snapshot.exists || snapshot.data() == null) {
      return null;
    }

    return LineModel.fromMap(snapshot.data()!);
  }

  Future<void> createLine(LineModel line) {
    return _linesCollection.doc(line.id).set(line.toMap());
  }

  Future<void> updateLine(LineModel line) {
    return _linesCollection.doc(line.id).update({
      ...line.toMap(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deactivateLine(String lineId) {
    return _linesCollection.doc(lineId).update({
      'isActive': false,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // -------------------- STATIONS --------------------

  CollectionReference<Map<String, dynamic>> get _stationsCollection =>
      _firestore.collection(FirestorePaths.stations);

  Stream<List<StationModel>> watchStations() {
    return _stationsCollection
        .orderBy('name')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => StationModel.fromMap(doc.data()))
              .toList(),
        );
  }

  Future<StationModel?> getStation(String stationId) async {
    final snapshot = await _stationsCollection.doc(stationId).get();

    if (!snapshot.exists || snapshot.data() == null) {
      return null;
    }

    return StationModel.fromMap(snapshot.data()!);
  }

  Future<void> createStation(StationModel station) {
    return _stationsCollection.doc(station.id).set(station.toMap());
  }

  Future<void> updateStation(StationModel station) {
    return _stationsCollection.doc(station.id).update({
      ...station.toMap(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deactivateStation(String stationId) {
    return _stationsCollection.doc(stationId).update({
      'isActive': false,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
