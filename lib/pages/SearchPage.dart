import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'SeatSelection.dart';
import 'MapPage.dart';
import 'ProfilePage.dart';
import 'package:mobitix/widgets/CustomBottomNavBar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mobitix/model/bus.dart';
import 'package:intl/intl.dart';

class SearchPage extends StatefulWidget {
  final String? initialFrom;
  final String? initialTo;

  const SearchPage({this.initialFrom, this.initialTo, Key? key})
      : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final TextEditingController fromController;
  late final TextEditingController toController;
  List<Bus> buses = [];
  bool isLoading = false;
  bool hasSearched = false;
  DateTime? selectedDate;
  List<DateTime> availableDates = [];
  final DateFormat dateFormat = DateFormat('MMM');
  final DateFormat dayFormat = DateFormat('d');
  final DateFormat weekdayFormat = DateFormat('E');

  @override
  void initState() {
    super.initState();
    fromController = TextEditingController(text: widget.initialFrom ?? '');
    toController = TextEditingController(text: widget.initialTo ?? '');
    _initializeDates();

    if (widget.initialFrom != null && widget.initialTo != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _performSearch();
      });
    }
  }

  void _initializeDates() {
    final now = DateTime.now();
    availableDates =
        List.generate(7, (index) => now.add(Duration(days: index)));
    selectedDate = availableDates.first;
  }

  @override
  void dispose() {
    fromController.dispose();
    toController.dispose();
    super.dispose();
  }

  Future<List<Bus>> fetchBuses(String from, String to, DateTime date) async {
    try {
      setState(() => isLoading = true);

      final formattedDate = DateFormat('yyyy-MM-dd').format(date);

      final response = await http
          .get(
            Uri.parse(
                'http://192.168.1.7/mobitix/fetch_buses.php?from=$from&to=$to&date=$formattedDate'),
          )
          .timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((bus) => Bus.fromJson(bus)).toList();
      } else {
        throw Exception('Failed to load buses. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching buses: $e');
      throw Exception('Failed to load buses: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _performSearch() async {
    final from = fromController.text.trim();
    final to = toController.text.trim();

    if (from.isEmpty || to.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter both departure and destination")),
      );
      return;
    }
    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a date")),
      );
      return;
    }

    try {
      final results = await fetchBuses(from, to, selectedDate!);
      setState(() {
        buses = results;
        hasSearched = true;
      });

      if (buses.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  "No buses found for this route on ${DateFormat('MMM,d,y').format(selectedDate!)}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  // Helper method to build input fields
  Widget _buildInputField(
      String hint, IconData icon, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blueGrey.shade100),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blueAccent),
        ),
      ),
    );
  }

  // Helper method to create date cards
  Widget _dateCard(DateTime date) {
    final isSelected = selectedDate != null &&
        date.year == selectedDate!.year &&
        date.month == selectedDate!.month &&
        date.day == selectedDate!.day;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedDate = date;
        });
        if (hasSearched) {
          _performSearch(); // Auto-search when date changes if we've already searched
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        padding: EdgeInsets.all(8),
        width: 70,
        decoration: BoxDecoration(
          color: isSelected ? Colors.blueAccent : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.blueAccent : Colors.blueGrey.shade100,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              dateFormat.format(date),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : Colors.blueAccent),
            ),
            Text(
              dayFormat.format(date),
              style: TextStyle(
                fontSize: 18,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
            Text(
              weekdayFormat.format(date),
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? Colors.white : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to create quick date buttons
  Widget _quickDateButton(String label, DateTime date) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedDate = date;
        });
        if (hasSearched) {
          _performSearch();
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor:
            selectedDate == date ? Colors.blueAccent : Colors.orangeAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  // Helper method to build bus cards from search results
  Widget _buildBusCard(BuildContext context, Bus bus) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SeatSelectionPage(
                busId: bus.id,
                busName: bus.busName,
              ),
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    bus.busName,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "LKR 500",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text("Route: ${bus.route}"),
              SizedBox(height: 4),
              Text("Departure: ${bus.formattedDeparture.isNotEmpty ? bus.formattedDeparture : bus.departureTime}"),
              SizedBox(height: 4),
              Text("Arrival: ${bus.formattedArrival.isNotEmpty ? bus.formattedArrival : bus.arrivalTime}"),
              SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SeatSelectionPage(
                          busId: bus.id,
                          busName: bus.busName,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text(
                    "Select Seats",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Placeholder for bus detail card
  Widget _buildBusDetailCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Column(
        children: [
          Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.lightBlue.shade50,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Center(
              child: Text("🚍 Express Bus 1\nColombo → Kandy\n9:00 AM • AC Bus",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SeatSelectionPage(
                        busId: 'bus1',
                        busName: 'Express Bus 1',
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child:
                    Text("VIEW SEATS", style: TextStyle(color: Colors.white)),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Colors.blueAccent;
    final Color backgroundColor = Colors.grey.shade100;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Search Buses',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              fromController.clear();
              toController.clear();
              setState(() {
                buses.clear();
                hasSearched = false;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Section
            Text("Where are you going?",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            SizedBox(height: 12),
            _buildInputField("From...", Icons.location_on, fromController),
            SizedBox(height: 12),
            _buildInputField("To...", Icons.flag, toController),
            SizedBox(height: 20),

            // Sort and Date Selection
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("Sort By",
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500)),
                SizedBox(width: 8),
                Icon(Icons.arrow_upward, color: primaryColor),
                Icon(Icons.arrow_downward, color: primaryColor),
              ],
            ),
            SizedBox(height: 20),
            Text("Pick a Date",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            SizedBox(height: 12),
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children:
                    availableDates.map((date) => _dateCard(date)).toList(),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _quickDateButton(
                    "Today\n${DateFormat('MMM d').format(DateTime.now())}",
                    DateTime.now()),
                _quickDateButton(
                    "Tomorrow\n${DateFormat('MMM d').format(DateTime.now().add(Duration(days: 1)))}",
                    DateTime.now().add(Duration(days: 1))),
                _quickDateButton(
                    "Next Week", DateTime.now().add(Duration(days: 7))),
              ],
            ),
            SizedBox(height: 24),

            // Search Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _performSearch,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: isLoading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2),
                      )
                    : Text('SEARCH BUSES', style: TextStyle(fontSize: 16)),
              ),
            ),
            SizedBox(height: 24),

            // Results Section
            if (hasSearched) ...[
              Text(
                buses.isEmpty ? "No Buses Found" : "Available Buses",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 12),
              if (isLoading)
                Center(child: CircularProgressIndicator())
              else if (buses.isNotEmpty)
                ...buses.map((bus) => _buildBusCard(context, bus)).toList(),
            ] else ...[
              Text("Available Buses",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              SizedBox(height: 12),
              _buildBusDetailCard(context),
            ],
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
          } else if (index == 1) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SearchPage()));
          } else if (index == 3) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Mappage()));
          }
          else if (index == 4) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ProfilePage()));
          }
        },
      ),
    );
  }
}
