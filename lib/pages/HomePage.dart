import 'package:flutter/material.dart';
import 'SearchPage.dart'; // Import the SearchPage
import 'MapPage.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mobitix"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner
            Container(
              height: 150,
              width: double.infinity,
              color: Colors.grey[300],
              child: Center(child: Text("BANNER", style: TextStyle(fontSize: 20))),
            ),
            SizedBox(height: 20),

            // "Where are you going?" Section
            Text("Where are you going?", style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            // From field
            TextField(
              decoration: InputDecoration(
                labelText: "From...",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
            ),
            SizedBox(height: 10),
            // To field
            TextField(
              decoration: InputDecoration(
                labelText: "To...",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.flag),
              ),
            ),
            SizedBox(height: 10),

            // Search Buses Button
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text("SEARCH BUSES"),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.filter_alt),
                  onPressed: () {
                    // Filter action
                  },
                )
              ],
            ),

            SizedBox(height: 20),

            // Upcoming Trips
            Text("Upcoming Trips!", style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Card(
              elevation: 3,
              child: ListTile(
                title: Text("Bus Details - CARD 1"),
                trailing: ElevatedButton(
                  onPressed: () {},
                  child: Text("VIEW TICKET"),
                ),
              ),
            ),

            SizedBox(height: 20),

            // Promotions & Offers
            Text("Promotions & Offers", style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Container(
              height: 150,
              width: double.infinity,
              color: Colors.blue[100],
              child: Center(child: Text("PROMO BANNER")),
            ),
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // Home selected
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
          BottomNavigationBarItem(icon: Icon(Icons.confirmation_number), label: "Ticket"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }
}