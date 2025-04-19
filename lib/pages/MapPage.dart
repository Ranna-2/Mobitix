import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'HomePage.dart';
import 'SearchPage.dart';
import 'package:mobitix/widgets/CustomBottomNavBar.dart';

class Mappage extends StatefulWidget {
  const Mappage({super.key});

  @override
  State<Mappage> createState() => _MappageState();
}

class _MappageState extends State<Mappage> {
  LatLng _currentLocation = LatLng(7.2906, 80.6328); // Default location (Kandy)
  bool _isLoading = true;
  final Location location = Location();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    // Check if location services are enabled
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        _showSnackBar("Location services are disabled");
        return;
      }
    }

    // Request location permission
    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        _showSnackBar("Location permission denied");
        return;
      }
    }

    // Initial location fetch
    try {
      LocationData current = await location.getLocation();
      setState(() {
        _currentLocation = LatLng(current.latitude!, current.longitude!);
        _isLoading = false;
      });
    } catch (e) {
      print("Error getting location: $e");
    }

    // Listen to location changes
    location.onLocationChanged.listen((LocationData loc) {
      if (loc.latitude != null && loc.longitude != null) {
        setState(() {
          _currentLocation = LatLng(loc.latitude!, loc.longitude!);
        });
      }
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Map"),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _currentLocation,
          zoom: 13,
        ),
        markers: {
          Marker(
            markerId: const MarkerId("currentLocation"),
            icon: BitmapDescriptor.defaultMarker,
            position: _currentLocation,
          ),
          const Marker(
            markerId: MarkerId("sourceLocation"),
            icon: BitmapDescriptor.defaultMarker,
            position: LatLng(7.2906, 80.6328), // Example fixed source
          ),
        },
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return CustomBottomNavBar(
      currentIndex: 3, // Index for Map tab
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
            break;
          case 1:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SearchPage()),
            );
            break;
        // You can add navigation logic for Ticket and Profile if needed
        }
      },

    );
  }
}
