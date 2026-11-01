enum TransportType { bus, metro, train, tgm, other }

extension TransportTypeExtension on TransportType {
  String get displayName {
    switch (this) {
      case TransportType.bus:
        return 'Bus';
      case TransportType.metro:
        return 'Metro';
      case TransportType.train:
        return 'Train';
      case TransportType.tgm:
        return 'TGM';
      case TransportType.other:
        return 'Other';
    }
  }
}
