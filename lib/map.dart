import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:safevoxx/login.dart'; // Import login page for navigation if not authenticated

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController _mapController;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Initial position (you can fetch user's location dynamically)
  static const LatLng _initialPosition = LatLng(17.4125, 78.3254); // Hyderabad, India (example)

  // Markers for the map (based on your screenshot)
  final Set<Marker> _markers = {
    Marker(
      markerId: MarkerId('cricket_ground'),
      position: LatLng(17.4125, 78.3254), // SVM Gagan Sports Cricket Ground
      infoWindow: InfoWindow(title: 'SVM Gagan Sports Cricket Ground'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    ),
    Marker(
      markerId: MarkerId('new_cricket_stadium'),
      position: LatLng(17.4150, 78.3300), // New Cricket Stadium (example position)
      infoWindow: InfoWindow(title: 'New Cricket Stadium'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    ),
    Marker(
      markerId: MarkerId('sncc_iit_hyderabad'),
      position: LatLng(17.4100, 78.3200), // SNCC IIT Hyderabad (example position)
      infoWindow: InfoWindow(title: 'SNCC IIT Hyderabad'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    ),
    Marker(
      markerId: MarkerId('iit_hyderabad'),
      position: LatLng(17.4100, 78.3200), // Indian Institute of Technology, Hyderabad
      infoWindow: InfoWindow(title: 'Indian Institute of Technology, Hyderabad'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    ),
  };

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  void _checkAuthStatus() {
    if (_auth.currentUser == null) {
      // If no user is logged in, navigate to login page
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      });
    }
  }

  void _logout() async {
    await _auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark background to match your palette
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Row(
          children: [
            Image.asset(
              'assets/safevoxx_logo.png', // Replace with your logo asset path
              height: 30,
              width: 30,
            ),
            const SizedBox(width: 8),
            const Text('SafeVoxx'),
          ],
        ),
        actions: [
          CircleAvatar(
            backgroundImage: NetworkImage(
                'https://example.com/profile.jpg'), // Replace with actual user profile image
            radius: 15,
          ),
          const SizedBox(width: 10),
        ],
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.black,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Drawer Header with Back Arrow
            Container(
              padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context); // Close the drawer
                    },
                  ),
                ],
              ),
            ),
            // Menu Items
            ListTile(
              leading: const Icon(Icons.person, color: Colors.grey),
              title: const Text('My Profile', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context); // Close drawer
                // Add navigation or action for My Profile
              },
            ),
            ListTile(
              leading: const Icon(Icons.mic, color: Colors.grey),
              title: const Text('Voice Activation', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context); // Close drawer
                // Add navigation or action for Voice Activation
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.grey),
              title: const Text('Settings', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context); // Close drawer
                // Add navigation or action for Settings
              },
            ),
            ListTile(
              leading: const Icon(Icons.history, color: Colors.grey),
              title: const Text('History', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context); // Close drawer
                // Add navigation or action for History
              },
            ),
            ListTile(
              leading: const Icon(Icons.add, color: Colors.grey),
              title: const Text('Add Emergency Contacts', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context); // Close drawer
                // Add navigation or action for Add Emergency Contacts
              },
            ),
            ListTile(
              leading: const Icon(Icons.music_note, color: Colors.grey),
              title: const Text('Recordings', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context); // Close drawer
                // Add navigation or action for Recordings
              },
            ),
            ListTile(
              leading: const Icon(Icons.help, color: Colors.grey),
              title: const Text('Help', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context); // Close drawer
                // Add navigation or action for Help
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.grey),
              title: const Text('Logout', style: TextStyle(color: Colors.white)),
              onTap: () {
                _logout(); // Logout and navigate to LoginPage
              },
            ),
          ],
        ),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _initialPosition,
          zoom: 14.0,
        ),
        markers: _markers,
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
        myLocationEnabled: true, // Show user's location if permission granted
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home, color: Colors.white),
              onPressed: () {
                // Navigate to home (you can define this)
              },
            ),
            IconButton(
              icon: const Icon(Icons.local_dining, color: Colors.orange),
              onPressed: () {
                // Navigate to restaurants (optional)
              },
            ),
            IconButton(
              icon: const Icon(Icons.local_gas_station, color: Colors.white),
              onPressed: () {
                // Navigate to petrol stations (optional)
              },
            ),
            IconButton(
              icon: const Icon(Icons.hotel, color: Colors.white),
              onPressed: () {
                // Navigate to hotels (optional)
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // SOS action (e.g., send location to emergency contacts)
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('SOS activated!')),
          );
        },
        backgroundColor: Colors.brown,
        child: const Text(
          'SOS',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}