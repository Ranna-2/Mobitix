import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'services.dart';

class ManageSchedules extends StatefulWidget {
  @override
  _ManageSchedulesState createState() => _ManageSchedulesState();
}

class _ManageSchedulesState extends State<ManageSchedules> {
  late TextEditingController _departureTimeController;
  late TextEditingController _arrivalTimeController;
  List schedules = [];
  bool isLoading = true;
  final _formKey = GlobalKey<FormState>();
  bool isEditing = false;
  Map<String, dynamic> currentSchedule = {
    'id': '',
    'bus_name': '',
    'departure_time': '',
    'arrival_time': '',
    'route': '',
  };

  @override
  void initState() {
    super.initState();
    _departureTimeController = TextEditingController();
    _arrivalTimeController = TextEditingController();
    fetchSchedules();
  }

  @override
  void dispose() {
    _departureTimeController.dispose();
    _arrivalTimeController.dispose();
    super.dispose();
  }

  Future<void> fetchSchedules() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse('$baseUrl/manage_schedules.php'));
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

  Future<void> addSchedule() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/manage_schedules.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(currentSchedule),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Schedule added successfully')),
        );
        fetchSchedules();
        Navigator.of(context).pop();
      } else {
        throw Exception('Failed to add schedule');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding schedule: $e')),
      );
    }
  }

  Future<void> updateSchedule() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    try {
      final response = await http.put(
        Uri.parse('$baseUrl/manage_schedules.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(currentSchedule),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Schedule updated successfully')),
        );
        fetchSchedules();
        Navigator.of(context).pop();
      } else {
        throw Exception('Failed to update schedule');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating schedule: $e')),
      );
    }
  }

  Future<void> deleteSchedule(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/manage_schedules.php?id=$id'),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Schedule deleted successfully')),
        );
        fetchSchedules();
      } else {
        throw Exception('Failed to delete schedule');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting schedule: $e')),
      );
    }
  }

  void showScheduleForm({Map<String, dynamic>? schedule}) {
    setState(() {
      isEditing = schedule != null;
      currentSchedule = schedule != null
          ? {
        'id': schedule['id'].toString(),
        'bus_name': schedule['bus_name'],
        'departure_time': schedule['departure_time'],
        'arrival_time': schedule['arrival_time'],
        'route': schedule['route'],
      }
          : {
        'id': '',
        'bus_name': '',
        'departure_time': '',
        'arrival_time': '',
        'route': '',
      };

      if (schedule != null) {
        final departureTime = DateTime.parse(schedule['departure_time']);
        _departureTimeController.text =
        "${departureTime.year}-${departureTime.month.toString().padLeft(2,'0')}-"
            "${departureTime.day.toString().padLeft(2,'0')} "
            "${departureTime.hour.toString().padLeft(2,'0')}:"
            "${departureTime.minute.toString().padLeft(2,'0')}";

        final arrivalTime = DateTime.parse(schedule['arrival_time']);
        _arrivalTimeController.text =
        "${arrivalTime.year}-${arrivalTime.month.toString().padLeft(2,'0')}-"
            "${arrivalTime.day.toString().padLeft(2,'0')} "
            "${arrivalTime.hour.toString().padLeft(2,'0')}:"
            "${arrivalTime.minute.toString().padLeft(2,'0')}";
      } else {
        _departureTimeController.clear();
        _arrivalTimeController.clear();
      }
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isEditing ? 'Edit Schedule' : 'Add New Schedule',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    initialValue: currentSchedule['bus_name'],
                    decoration: InputDecoration(
                      labelText: 'Bus Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter bus name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      currentSchedule['bus_name'] = value!;
                    },
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    initialValue: currentSchedule['route'],
                    decoration: InputDecoration(
                      labelText: 'Route',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter route';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      currentSchedule['route'] = value!;
                    },
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Departure Time',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    readOnly: true,
                    controller: _departureTimeController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select departure time';
                      }
                      return null;
                    },
                    onTap: () async {
                      final DateTime? date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );

                      if (date != null) {
                        final TimeOfDay? time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );

                        if (time != null) {
                          final DateTime dateTime = DateTime(
                            date.year,
                            date.month,
                            date.day,
                            time.hour,
                            time.minute,
                          );

                          setState(() {
                            currentSchedule['departure_time'] = dateTime.toIso8601String();
                            _departureTimeController.text =
                            "${date.year}-${date.month.toString().padLeft(2,'0')}-"
                                "${date.day.toString().padLeft(2,'0')} "
                                "${time.hour.toString().padLeft(2,'0')}:"
                                "${time.minute.toString().padLeft(2,'0')}";
                          });
                        }
                      }
                    },
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Arrival Time',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    readOnly: true,
                    controller: _arrivalTimeController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select arrival time';
                      }
                      return null;
                    },
                    onTap: () async {
                      final DateTime? date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );

                      if (date != null) {
                        final TimeOfDay? time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );

                        if (time != null) {
                          final DateTime dateTime = DateTime(
                            date.year,
                            date.month,
                            date.day,
                            time.hour,
                            time.minute,
                          );

                          setState(() {
                            currentSchedule['arrival_time'] = dateTime.toIso8601String();
                            _arrivalTimeController.text =
                            "${date.year}-${date.month.toString().padLeft(2,'0')}-"
                                "${date.day.toString().padLeft(2,'0')} "
                                "${time.hour.toString().padLeft(2,'0')}:"
                                "${time.minute.toString().padLeft(2,'0')}";
                          });
                        }
                      }
                    },
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('Cancel'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: isEditing ? updateSchedule : addSchedule,
                        child: Text(isEditing ? 'Update' : 'Add'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Bus Schedules'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => showScheduleForm(),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : schedules.isEmpty
          ? Center(child: Text('No schedules found'))
          : ListView.builder(
        itemCount: schedules.length,
        itemBuilder: (context, index) {
          var schedule = schedules[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            child: ListTile(
              title: Text(schedule['bus_name']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Route: ${schedule['route']}'),
                  Text(
                      'Departure: ${schedule['departure_time'].toString().substring(0, 16)}'),
                  Text(
                      'Arrival: ${schedule['arrival_time'].toString().substring(0, 16)}'),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () =>
                        showScheduleForm(schedule: schedules[index]),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deleteSchedule(
                        int.parse(schedule['id'].toString())),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showScheduleForm(),
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}