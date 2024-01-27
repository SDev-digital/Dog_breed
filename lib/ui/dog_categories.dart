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
      future: getCategories(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return const CircularProgressIndicator();
        }
        if(snapshot.hasError){
          return const Text("error note fitche categorie");
        }
        return 
 Column(
          children: [
            const SizedBox(height: 20),
            for (var i = 0; i < snapshot.data!.length; i += 3)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (var j = i; j < i + 3 && j < snapshot.data!.length; j++)
                    GestureDetector(
                      onTap: () {
                        // Navigate to DogDetailScreen when tapped
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
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
          ],
        );
        // data
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
  return Supabase.instance.client.from('categories').select().then((value) =>
      // ignore: unnecessary_cast
      (value as List<dynamic>).map((json) => Category.fromJson(json)).toList());
}