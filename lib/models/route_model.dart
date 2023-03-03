import 'package:cloud_firestore/cloud_firestore.dart';

class BusRoute {
  String id;
  final String driver;
  final String company;
  final DateTime start;
  final DateTime end;
  final List<GeoPoint> stops;

  BusRoute({
    this.id = '',
    required this.driver,
    required this.company,
    required this.start,
    required this.end,
    required this.stops,
  });

  Map<String, dynamic> toJson() => {
      'id': id,
      'driver': driver,
      'company': company,
      'start': start,
      'end': end,
      'stops': stops,
    };
}