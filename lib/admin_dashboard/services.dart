import 'package:http/http.dart' as http;
import 'dart:convert';

const String baseUrl = 'http://192.168.1.7/mobitix'; // Your server URL

// Fetch all bus schedules
Future<List<dynamic>> fetchAllBusSchedules() async {
  final response = await http.get(Uri.parse('$baseUrl/fetch_all_schedules.php'));
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load bus schedules');
  }
}

// Fetch specific bus schedules based on route and date
Future<List<dynamic>> fetchBusSchedules(String from, String to, String date) async {
  final response = await http.get(Uri.parse('$baseUrl/fetch_buses.php?from=$from&to=$to&date=$date'));
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load bus schedules');
  }
}

// Add a new bus schedule
Future<void> addBusSchedule(String busId, String busName, String departureTime, String arrivalTime, String route) async {
  await http.post(
    Uri.parse('$baseUrl/manage_schedules.php'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'busId': busId,
      'busName': busName,
      'departureTime': departureTime,
      'arrivalTime': arrivalTime,
      'route': route,
    }),
  );
}

// Delete a bus schedule
Future<void> deleteBusSchedule(int busId) async {
  await http.delete(Uri.parse('$baseUrl/manage_schedules.php?delete=$busId'));
}

// Fetch ticket reservations
Future<List<dynamic>> fetchTicketReservations() async {
  final response = await http.get(Uri.parse('$baseUrl/payments.php'));
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load ticket reservations');
  }
}

// Delete a ticket reservation
Future<void> deleteTicketReservation(int ticketId) async {
  await http.delete(Uri.parse('$baseUrl/payments.php?delete=$ticketId'));
}

// Fetch performance analytics
Future<Map<String, dynamic>> fetchPerformanceAnalytics() async {
  final response = await http.get(Uri.parse('$baseUrl/performance_analytics.php'));
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load performance analytics');
  }
}

// New function to get total bookings and revenue
Future<Map<String, dynamic>> getPerformanceData() async {
  final response = await http.get(Uri.parse('$baseUrl/get_performance_data.php'));
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load performance data');
  }
}