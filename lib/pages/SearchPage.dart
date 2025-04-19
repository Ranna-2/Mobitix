import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'SeatSelection.dart';
import 'MapPage.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Buses'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // From & To Inputs
            const Text("Where are you going?"),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.location_on),
                hintText: 'From...',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.location_on_outlined),
                hintText: 'To...',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 10),

            // Filter Row
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text("FILTER"),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_upward),
                const Icon(Icons.arrow_downward),
              ],
            ),
            const SizedBox(height: 16),

            // Horizontal date selector
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _dateCard("Feb", "27", "Thu"),
                  _dateCard("Feb", "28", "Fri"),
                  _dateCard("Mar", "01", "Sat"),
                  _dateCard("Mar", "02", "Sun"),
                  _dateCard("Mar", "03", "Mon"),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Quick date filters
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _quickDateButton("Today\n27 Feb"),
                _quickDateButton("Tomorrow\n28 Feb"),
                _quickDateButton("Next Month\nMar"),
              ],
            ),
            const SizedBox(height: 20),

            // Search Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('SEARCH BUSES'),
              ),
            ),
            const SizedBox(height: 20),

            // Bus Detail Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  Container(
                    height: 160,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: const Center(child: Text("BUS DETAILS\nCARD 1")),
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
                              builder: (context) => const SeatSelectionPage(
                                busId: 'bus1', // Pass actual bus ID
                                busName:
                                    'Express Bus 1', // Pass actual bus name
                              ),
                            ),
                          );
                        },
                        child: const Text("VIEW SEATS"),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),

      // Bottom NavBar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // Search tab
        onTap: (index) {
          if (index == 0) {
            // Home tab
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          } else if (index == 1) {
            // Search tab
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SearchPage()),
            );
          }

          else if (index == 3) { // Assuming Map is the 3rd index
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Mappage()),
            );
          }


        },
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey[600],
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(
              icon: Icon(Icons.confirmation_number), label: "Ticket"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  // Date card widget
  Widget _dateCard(String month, String day, String weekday) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(8),
      width: 70,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(month, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(day, style: const TextStyle(fontSize: 18)),
          Text(weekday, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  // Quick date filter buttons
  Widget _quickDateButton(String label) {
    return ElevatedButton(
      onPressed: () {},
      child: Text(label, textAlign: TextAlign.center),
    );
  }
}
