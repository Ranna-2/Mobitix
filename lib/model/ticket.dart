// models/ticket.dart
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
    this.status = 'upcoming',
  });

// Add fromJson and toJson methods if you need to serialize/deserialize
}