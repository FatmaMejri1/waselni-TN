import 'package:cloud_firestore/cloud_firestore.dart';

import 'transport_type.dart';

class LineModel {
  final String id;
  final String name;
  final String code;
  final TransportType transportType;
  final String description;
  final List<String> stationIds;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const LineModel({
    required this.id,
    required this.name,
    required this.code,
    required this.transportType,
    this.description = '',
    this.stationIds = const [],
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'transportType': transportType.name,
      'description': description,
      'stationIds': stationIds,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory LineModel.fromMap(Map<String, dynamic> map) {
    final typeName = map['transportType'] as String? ?? 'other';

    return LineModel(
      id: map['id'] as String,
      name: map['name'] as String? ?? '',
      code: map['code'] as String? ?? '',
      transportType: TransportType.values.firstWhere(
        (type) => type.name == typeName,
        orElse: () => TransportType.other,
      ),
      description: map['description'] as String? ?? '',
      stationIds: List<String>.from(map['stationIds'] as List? ?? []),
      isActive: map['isActive'] as bool? ?? true,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }
}
