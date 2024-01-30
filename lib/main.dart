import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'ui/dog_categories.dart';
import 'package:firebase_core/firebase_core.dart';
import 'ui/camera.dart';
import 'ui/gallery.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ionicons/ionicons.dart';
Future<void> main() async {
  // Ensure Flutter is initialized and Firebase is initialized
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
final supaDB = await Supabase.initialize(
    headers: {
      'Content-Type': 'Application/json',
    },
    url: 'https://sxbfjhdcziiekfxczdfm.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InN4YmZqaGRjemlpZWtmeGN6ZGZtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDYzNjA2NjAsImV4cCI6MjAyMTkzNjY2MH0.yKDcVsxj9n7Wmsromu5RFTWddYkHdo_5qJcpkXIq4Kc',
  );

  // Run the app
  runApp(const BottomNavigationBarApp());
}

// Top-level widget for the app
class BottomNavigationBarApp extends StatelessWidget {
  const BottomNavigationBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BottomNavigationBarExample(),
    );
  }
}
// Main StatefulWidget for the bottom navigation bar example
class BottomNavigationBarExample extends StatefulWidget {
  const BottomNavigationBarExample({super.key});

  @override
  State<BottomNavigationBarExample> createState() =>
      _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState
    extends State<BottomNavigationBarExample> {
  // Camera description for camera access
  late CameraDescription cameraDescription;

  // Index of the selected item in the bottom navigation bar
  int _selectedIndex = 0;

  // List to store widget options for different pages
  List<Widget>? _widgetOptions;

  // Boolean indicating if the camera is available based on the platform
  bool cameraIsAvailable = Platform.isAndroid || Platform.isIOS;

  @override
  void initState() {
    super.initState();
    // Execute the following code after the first frame is displayed
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      initPages();
    });
  }

  // Initialize the pages based on camera availability
  Future<void> initPages() async {
    // Start with the GalleryScreen as the default page
    _widgetOptions = [const GalleryScreen()];

    // If the camera is available, add the CameraScreen
    if (cameraIsAvailable) {
      cameraDescription = (await availableCameras()).first;
      _widgetOptions!.add(CameraScreen(camera: cameraDescription));
    }
    // Add DogCategoriesScreen to the list of options
    _widgetOptions!.add(const DogCategoriesScreen());
    // Update the state to reflect the changes
    setState(() {});
  }
  // Handle item tap in the bottom navigation bar
  void _onItemTapped(int index) {
    // Check if camera is not available and the selected item is related to camera
    if (!cameraIsAvailable && (index == 1)) {
      debugPrint("This is not supported on your current platform");
      return;
    }
    // Update the selected index
    setState(() {
      _selectedIndex = index;
    });
  }@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      // App bar title with an image
      title: Image.asset(
        'assets/images/tfl_logo.jpg',
        width: 1000, // Adjust the width as needed
        height: 1000,
      ),
      // App bar background color with opacity
      backgroundColor: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.5),
    ),
    body: Center(
      // Display the selected widget option in the center of the screen
      child: _widgetOptions?.elementAt(_selectedIndex),
    ),
    bottomNavigationBar: BottomNavigationBar(
      // Items in the bottom navigation bar
         items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Ionicons.image),
            label: 'Gallery screen',
          ),
          BottomNavigationBarItem(
            icon: Icon(Ionicons.camera),
            label: 'Live Camera',
          ),
          BottomNavigationBarItem(
            icon: Icon(Ionicons.grid), // Icon for dog categories
            label: 'Dog Categories',
          ),
        ],
      // Current index of the selected item
      currentIndex: _selectedIndex,
      // Color of the selected item
      selectedItemColor: Colors.amber[800],
      // Callback function when an item is tapped
      onTap: _onItemTapped,
    ),
  );
}

}
