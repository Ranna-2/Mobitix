import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mobitix/widgets/CustomBottomNavBar.dart';
import 'HomePage.dart';
import 'ProfilePage.dart';
import 'SearchPage.dart';



class Mappage extends StatefulWidget {
  const Mappage({super.key});

  @override
  State<Mappage> createState() => _MappageState();
}

class _MappageState extends State<Mappage> {
  LatLng _currentLocation = LatLng(7.2906, 80.6328); // Default location
  bool _isLoading = true;
  final Location _location = Location();
  Set<Marker> _markers = {};
  String busId = "bus7";

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    // Fetch bus locations every 10 seconds
    Future.delayed(Duration(seconds: 10), () {
      _fetchBusLocations();
    });
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    try {
      LocationData currentLocation = await _location.getLocation();
      setState(() {
        _currentLocation = LatLng(currentLocation.latitude!, currentLocation.longitude!);
        _isLoading = false;
        _markers.add(Marker(
          markerId: MarkerId("currentLocation"),
          position: _currentLocation,
          infoWindow: InfoWindow(title: "Your Location"),
        ));
      });

      // Send the current location to the server
      _sendLocationToServer(currentLocation.latitude!, currentLocation.longitude!);
    } catch (e) {
      print("Error getting location: $e");
    }

    // Listen to location changes
    _location.onLocationChanged.listen((LocationData loc) {
      if (loc.latitude != null && loc.longitude != null) {
        setState(() {
          _currentLocation = LatLng(loc.latitude!, loc.longitude!);
          _markers.add(Marker(
            markerId: MarkerId("currentLocation"),
            position: _currentLocation,
            infoWindow: InfoWindow(title: "Your Location"),
          ));
        });

        // Send updated location to the server
        _sendLocationToServer(loc.latitude!, loc.longitude!);
      }
    });
  }

  Future<void> _sendLocationToServer(double latitude, double longitude) async {
    final String url = 'http://localhost/mobitix/location.php'; // Update with your server URL
    try {
      await http.post(Uri.parse(url), body: {
        'busId': busId,
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
      });
    } catch (e) {
      print("Error sending location to server: $e");
    }
  }

  Future<void> _fetchBusLocations() async {
    final String url = 'http://localhost/mobitix/location.php'; // Update with your server URL
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> locations = json.decode(response.body);
        setState(() {
          _markers.clear(); // Clear existing markers
          locations.forEach((busId, location) {
            _markers.add(Marker(
              markerId: MarkerId(busId),
              position: LatLng(double.parse(location['latitude']), double.parse(location['longitude'])),
              infoWindow: InfoWindow(title: "Bus $busId"),
            ));
          });
        });
      }
    } catch (e) {
      print("Error fetching bus locations: $e");
    }
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
        markers: _markers,
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