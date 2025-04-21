class Bus {
  final String id;  // Changed from int to String
  final String busName;
  final String departureTime;
  final String arrivalTime;
  final String route;

  Bus({
    required this.id,
    required this.busName,
    required this.departureTime,
    required this.arrivalTime,
    required this.route,
  });

  factory Bus.fromJson(Map<String, dynamic> json) {
    return Bus(
      id: json['id'].toString(), // Ensure it's a string
      busName: json['bus_name'],
      departureTime: json['departure_time'],
      arrivalTime: json['arrival_time'],
      route: json['route'],
    );
  }
}