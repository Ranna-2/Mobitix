import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ManageSchedules extends StatefulWidget {
  @override
  _ManageSchedulesState createState() => _ManageSchedulesState();
}

class _ManageSchedulesState extends State<ManageSchedules> {
  List schedules = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSchedules();
  }

  Future<void> fetchSchedules() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Update the URL to your fetch_buses.php endpoint
      final response = await http.get(Uri.parse('http://192.168.1.7/mobitix/fetch_buses.php'));

      if (response.statusCode == 200) {
        final List jsonResponse = json.decode(response.body);
        setState(() {
          schedules = jsonResponse;
        });
      } else {
        throw Exception('Failed to load schedules');
      }
    } catch (e) {
      print('Error fetching schedules: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Bus Schedules'),
        backgroundColor: Colors.blue,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: schedules.length,
        itemBuilder: (context, index) {
          var schedule = schedules[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              title: Text(schedule['bus_name']),
              subtitle: Text('Route: ${schedule['route']}'),
              trailing: Text('Departure: ${schedule['departure_time']}'),
            ),
          );
        },
      ),
    );
  }
}