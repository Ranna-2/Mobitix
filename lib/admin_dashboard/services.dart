import 'package:http/http.dart' as http;
import 'dart:convert';

const String baseUrl = 'http://192.168.75.242/mobitix';


Future<List<dynamic>> fetchAllBusSchedules() async {
  final response = await http.get(Uri.parse('$baseUrl/manage_schedules.php'));
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load bus schedules');
  }
}
Future<List<dynamic>> fetchTicketReservations() async {
  final response = await http.get(Uri.parse('$baseUrl/payments.php'));
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load ticket reservations');
  }
}
Future<void> deleteTicketReservation(int ticketId) async {
  await http.delete(Uri.parse('$baseUrl/payments.php?delete=$ticketId'));
}

Future<Map<String, dynamic>> getPerformanceData() async {
  final response = await http.get(Uri.parse('$baseUrl/get_performance_data.php'));
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load performance data');
  }
}

// Add a new bus schedule
Future<void> addBusSchedule(Map<String, dynamic> scheduleData) async {
  final response = await http.post(
    Uri.parse('$baseUrl/manage_schedules.php'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode(scheduleData),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to add bus schedule');
  }
}

// Update a bus schedule
Future<void> updateBusSchedule(Map<String, dynamic> scheduleData) async {
  final response = await http.put(
    Uri.parse('$baseUrl/manage_schedules.php'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode(scheduleData),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to update bus schedule');
  }
}

// Delete a bus schedule
Future<void> deleteBusSchedule(int id) async {
  final response = await http.delete(
    Uri.parse('$baseUrl/manage_schedules.php?id=$id'),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to delete bus schedule');
  }
}