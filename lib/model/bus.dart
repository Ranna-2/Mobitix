class Bus {
  final String id;
  final String busName;
  final String departureTime;
  final String arrivalTime;
  final String route;
  final String formattedDeparture; // New field
  final String formattedArrival;   // New field

  Bus({
    required this.id,
    required this.busName,
    required this.departureTime,
    required this.arrivalTime,
    required this.route,
    required this.formattedDeparture,
    required this.formattedArrival,
  });

  factory Bus.fromJson(Map<String, dynamic> json) {
    return Bus(
      id: json['id'].toString(),
      busName: json['bus_name'],
      departureTime: json['departure_time'],
      arrivalTime: json['arrival_time'],
      route: json['route'],
      formattedDeparture: json['formatted_departure'] ?? '',
      formattedArrival: json['formatted_arrival'] ?? '',
    );
  }
}