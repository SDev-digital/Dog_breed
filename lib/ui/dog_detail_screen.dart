import 'package:flutter/material.dart';

class DogDetailScreen extends StatelessWidget {
  final String type;
  final String imagePath;
  final String description;

  DogDetailScreen({required this.type, required this.imagePath, required this.description});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dog Detail'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            imagePath,
            width: 200,
            height: 200,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 20),
          Text(
            type,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
           const SizedBox(height: 20),
          Text(
            description,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
