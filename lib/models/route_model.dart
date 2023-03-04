// ignore_for_file: non_constant_identifier_names

class BusRoute {
  String id;
  final String driver_id;
  final String company;
  final DateTime date_start;
  final DateTime date_end;
  final List<Map<String, dynamic>> bus_stops;

  BusRoute({
    this.id = '',
    required this.driver_id,
    required this.company,
    required this.date_start,
    required this.date_end,
    required this.bus_stops,
  });

  Map<String, dynamic> toJson() => {
      'id': id,
      'driver_id': driver_id,
      'company': company,
      'date_start': date_start,
      'date_end': date_end,
      'bus_stops': bus_stops,
    };
}