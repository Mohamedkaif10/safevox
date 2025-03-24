import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart'; // Add this import
import 'package:safevoxx/login.dart'; 
import 'package:safevoxx/emergency_contact.dart';
import 'package:safevoxx/voice_activation.dart';
import 'package:safevoxx/recordings.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController _mapController;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Default initial position (fallback if location fails)
  static const LatLng _defaultPosition = LatLng(17.4125, 78.3254);
  LatLng? _currentPosition; // To store user's current location

  // Map Markers
  final Set<Marker> _markers = {
    Marker(
      markerId: MarkerId('cricket_ground'),
      position: LatLng(17.4125, 78.3254),
      infoWindow: InfoWindow(title: 'SVM Gagan Sports Cricket Ground'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    ),
    Marker(
      markerId: MarkerId('new_cricket_stadium'),
      position: LatLng(17.4150, 78.3300),
      infoWindow: InfoWindow(title: 'New Cricket Stadium'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    ),
    Marker(
      markerId: MarkerId('sncc_iit_hyderabad'),
      position: LatLng(17.4100, 78.3200),
      infoWindow: InfoWindow(title: 'SNCC IIT Hyderabad'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    ),
    Marker(
      markerId: MarkerId('iit_hyderabad'),
      position: LatLng(17.4100, 78.3200),
      infoWindow: InfoWindow(title: 'Indian Institute of Technology, Hyderabad'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    ),
  };

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
    _requestPermissionsAndGetLocation();
  }

  // Function to request permissions and get current location
  Future<void> _requestPermissionsAndGetLocation() async {
    // Request permissions
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.microphone,
      Permission.storage,
      Permission.contacts,
      Permission.notification,
      Permission.location,
    ].request();

    // Check location permission specifically
    if (await Permission.location.isGranted) {
      await _getCurrentLocation();
    } else if (await Permission.location.isDenied) {
      _showPermissionDialog(Permission.location);
    }

    statuses.forEach((permission, status) {
      if (status.isDenied && permission != Permission.location) {
        _showPermissionDialog(permission);
      }
    });
  }

  // Function to fetch user's current location
  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      print("Error getting location: $e");
      setState(() {
        _currentPosition = _defaultPosition; // Fallback to default if location fails
      });
    }
  }

  // Show dialog if user denies permission
  void _showPermissionDialog(Permission permission) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Permission Required'),
        content: Text(
          'This app requires ${permission.toString().split('.').last} permission to work properly. Please enable it in settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await openAppSettings();
              Navigator.pop(context);
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  void _checkAuthStatus() {
    if (_auth.currentUser == null) {
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
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Row(
          children: [
            Image.asset(
              'assets/safevoxx_logo.png',
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
                'https://example.com/profile.jpg'), // Replace with actual profile image
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
            Container(
              padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.grey),
              title: const Text('My Profile', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.mic, color: Colors.grey),
              title: const Text('Voice Activation', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VoiceActivationPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.grey),
              title: const Text('Settings', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.history, color: Colors.grey),
              title: const Text('History', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.add, color: Colors.grey),
              title: const Text('Add Emergency Contacts', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EmergencyContactPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.music_note, color: Colors.grey),
              title: const Text('Recordings', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RecordingsPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.grey),
              title: const Text('Logout', style: TextStyle(color: Colors.white)),
              onTap: () {
                _logout();
              },
            ),
          ],
        ),
      ),
      body: _currentPosition == null
          ? const Center(child: CircularProgressIndicator()) // Show loading until location is fetched
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _currentPosition ?? _defaultPosition, // Use current position or fallback
                zoom: 14.0,
              ),
              markers: _markers,
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
              },
              myLocationEnabled: true, // Shows user's location dot on the map
              myLocationButtonEnabled: true, // Adds a button to center on user's location
            ),
    );
  }
}