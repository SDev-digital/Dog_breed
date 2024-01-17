import 'package:flutter/material.dart';

class DogCategoriesScreen extends StatelessWidget {
  const DogCategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> dogData = [
      {'type': 'Beagle', 'imagePath': 'lib/assets/images/pexels-pixabay-220938.jpg'},
      {'type': 'Labrador', 'imagePath': 'lib/assets/images/pexels-steshka-willems-1591939.jpg'},
      {'type': 'Poodle', 'imagePath': 'lib/assets/images/pexels-brett-sayles-1322182.jpg'},
      {'type': 'Husky', 'imagePath': 'lib/assets/images/pexels-charles-1851164.jpg'},
      {'type': 'Bulldog', 'imagePath': 'lib/assets/images/pexels-chevanon-photography-1108099.jpg'},
      {'type': 'Golden Retriever', 'imagePath': 'lib/assets/images/pexels-pixabay-220974.jpg'},
      {'type': 'Beagle', 'imagePath': 'lib/assets/images/pexels-cory-de-vega-732456.jpg'},
      {'type': 'Labrador', 'imagePath': 'lib/assets/images/pexels-creation-hill-1242419.jpg'},
      {'type': 'Poodle', 'imagePath': 'lib/assets/images/pexels-bruno-cervera-128817.jpg'},
      {'type': 'Husky', 'imagePath': 'lib/assets/images/pexels-dominika-roseclay-895259.jpg'},
      {'type': 'Bulldog', 'imagePath': 'lib/assets/images/pexels-hoy-1390784.jpg'},
      {'type': 'Golden Retriever', 'imagePath': 'lib/assets/images/pexels-jens-mahnke-776078.jpg'},
      {'type': 'Beagle', 'imagePath': 'lib/assets/images/pexels-kasuma-933498.jpg'},
      {'type': 'Labrador', 'imagePath': 'lib/assets/images/pexels-marco-de-groot-1557178.jpg'},
      {'type': 'Poodle', 'imagePath': 'lib/assets/images/pexels-svetozar-milashevich-1490908.jpg'},
      {'type': 'Husky', 'imagePath': 'lib/assets/images/pexels-tranmautritam-245035.jpg'},
      {'type': 'Bulldog', 'imagePath': 'lib/assets/images/pexels-vanserline-vandenberg-1619690.jpg'},
      {'type': 'Golden Retriever', 'imagePath': 'lib/assets/images/pexels-ylanite-koppens-612813.jpg'},
      {'type': 'Beagle', 'imagePath': 'lib/assets/images/pexels-yuliya-strizhkina-1198802.jpg'},
      {'type': 'Labrador', 'imagePath': 'lib/assets/images/pexels-summer-stock-333083.jpg'},
      {'type': 'Poodle', 'imagePath': 'lib/assets/images/pexels-goochie-poochie-grooming-3361722.jpg'},
      {'type': 'Husky', 'imagePath': 'lib/assets/images/pexels-steshka-willems-1591939.jpg'},
      {'type': 'Husky', 'imagePath': 'lib/assets/images/pexels-steshka-willems-1390361.jpg'},
      {'type': 'Husky', 'imagePath': 'lib/assets/images/pexels-mindaugas-1294062.jpg'},
      {'type': 'Husky', 'imagePath': 'lib/assets/images/pexels-melissa-jansen-van-rensburg-1954515.jpg'},
      {'type': 'Husky', 'imagePath': 'lib/assets/images/pexels-matheus-bertelli-1906153.jpg'},
      {'type': 'Husky', 'imagePath': 'lib/assets/images/pexels-dominika-roseclay-2023384.jpg'},
      {'type': 'Husky', 'imagePath': 'lib/assets/images/pexels-garfield-besa-686094.jpg'},
      {'type': 'Husky', 'imagePath': 'lib/assets/images/pexels-gilberto-reyes-825947.jpg'},
      {'type': 'Husky', 'imagePath': 'lib/assets/images/pexels-poodles-doodles-1458916.jpg'},
      // Add more dog types and image paths as needed
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dog Categories'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
         
            const SizedBox(height: 20), // Add some spacing
            // Display images in groups of three
            for (var i = 0; i < dogData.length; i += 3)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (var j = i; j < i + 3 && j < dogData.length; j++)
                    Column(
                      children: [
                        Image.asset(
                          dogData[j]['imagePath']!,
                          width: 100, // Set the width as needed
                          height: 100, // Set the height as needed
                          fit: BoxFit.cover, // Adjust the fit as needed
                        ),
                        const SizedBox(height: 10),
                        Text(
                          dogData[j]['type']!,
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
