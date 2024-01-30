import 'package:Breed_dog/ui/dog_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DogCategoriesScreen extends StatelessWidget {
  const DogCategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dog Categories'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: getCategories(), // Appel à la fonction pour récupérer les catégories
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Affiche un indicateur de chargement pendant le chargement des données
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error fetching categories")); // Affiche un message d'erreur en cas d'échec de récupération des données
          }
          return SingleChildScrollView( // Utilisation de SingleChildScrollView pour permettre le défilement des catégories
            child: Column(
              children: [
                const SizedBox(height: 20), // Ajoute un espace au-dessus des catégories
                for (var i = 0; i < snapshot.data!.length; i += 3)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      for (var j = i;
                          j < i + 3 && j < snapshot.data!.length;
                          j++)
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DogDetailScreen(
                                  type: snapshot.data![j].name,
                                  imagePath: snapshot.data![j].imageUrl,
                                  description: snapshot.data![j].description,
                                ),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              Image.network(
                                snapshot.data![j].imageUrl,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                snapshot.data![j].name,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class Category {
  final String name;
  final String description;
  final String imageUrl;

  Category(this.name, this.description, this.imageUrl);

  static Category fromJson(dynamic json) {
    return Category(
      json['name'],
      json['description'],
      json['image_url'],
    );
  }
}

Future<List<Category>> getCategories() {
  return Supabase.instance.client.from('categories').select().then(
        (value) => (value as List<dynamic>) // Assure que la valeur retournée est bien une liste dynamique
            .map((json) => Category.fromJson(json)) // Convertit chaque élément JSON en objet Category
            .toList(), // Retourne une liste de catégories
      );
}
