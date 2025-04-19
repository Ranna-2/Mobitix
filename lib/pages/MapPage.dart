import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'HomePage.dart';
import 'SearchPage.dart';

class Mappage extends StatefulWidget {
  const Mappage({super.key});

  @override
  State<Mappage> createState() => _MappageState();
}

class _MappageState extends State<Mappage> {
  static const LatLng _center = LatLng(7.2906, 80.6328); // Coordinates for Kandy, Sri Lanka
  static const LatLng _currentLocation = LatLng(7.2906, 80.6328); // Example current location (Kandy)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Map"),
        centerTitle: true,
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 13,
        ),
        markers: {
          Marker(
            markerId: MarkerId("currentLocation"),
            icon: BitmapDescriptor.defaultMarker,
            position: _currentLocation, // Set the position for the marker
          ),
        },
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: 3, // Assuming Map is the 3rd index
      onTap: (index) {
        if (index == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        } else if (index == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SearchPage()),
          );
        }
        // Add other navigation options as needed
      },
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey[600],
      backgroundColor: Colors.white,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
        BottomNavigationBarItem(icon: Icon(Icons.confirmation_number), label: "Ticket"),
        BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }
}