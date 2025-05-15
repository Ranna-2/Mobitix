class Ticket {
  final String id;
  final String passengerName;
  final String mobile;
  final String email;
  final List<String> seats;
  final String boarding;
  final String destination;
  final double totalAmount;
  final DateTime bookingDate;
  final DateTime travelDate;
  final String busName;
  final String busId;
  final String paymentMethod;
  final String referenceId;
  final String status; // 'upcoming', 'completed', 'cancelled'

  Ticket({
    required this.id,
    required this.passengerName,
    required this.mobile,
    required this.email,
    required this.seats,
    required this.boarding,
    required this.destination,
    required this.totalAmount,
    required this.bookingDate,
    required this.travelDate,
    required this.busName,
    required this.busId,
    required this.paymentMethod,
    required this.referenceId,
    required this.status,
  });

  // Add fromJson method for easier conversion
  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'],
      passengerName: json['passengerName'],
      mobile: json['mobile'],
      email: json['email'],
      seats: List<String>.from(json['seats'].map((s) => s.toString())),
      boarding: json['boarding'],
      destination: json['destination'],
      totalAmount: json['totalAmount'].toDouble(),
      bookingDate: DateTime.parse(json['bookingDate']),
      travelDate: DateTime.parse(json['travelDate']),
      busName: json['busName'],
      busId: json['busId'].toString(),
      paymentMethod: json['paymentMethod'],
      referenceId: json['referenceId'],
      status: json['status'],
    );
  }
}