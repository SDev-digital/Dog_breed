import 'package:flutter/material.dart';

class DogDetailScreen extends StatelessWidget {
  final String type; // Type de chien
  final String imagePath; // Chemin de l'image
  final String description; // Description du chien

  const DogDetailScreen({required this.type, required this.imagePath, required this.description}); // Constructeur

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dog Detail'), // Titre de la page
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            imagePath, // Chemin de l'image
            width: 200,
            height: 200,
            fit: BoxFit.cover, // Ajustement de l'image pour couvrir l'espace disponible
          ),
          
          const SizedBox(height: 20), // Espacement entre l'image et le texte
          Text(
            type, // Affichage du type de chien
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold), // Style du texte
          ),
           const SizedBox(height: 20), // Espacement entre le type de chien et la description
          Text(
            description, // Affichage de la description du chien
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Style du texte
          ),
          
        ],
      ),
    );
  }
}
