 

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import '../helper/image_classification_helper.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}
//ette classe représente l'état associé à GalleryScreen. Elle gère l'état de l'écran,
// y compris les variables pour la classification d'image et la gestion des images.
class _GalleryScreenState extends State<GalleryScreen> {
  ImageClassificationHelper? imageClassificationHelper;
  final imagePicker = ImagePicker();
  String? imagePath;
  img.Image? image;
  Map<String, double>? classification;
  bool cameraIsAvailable = Platform.isAndroid || Platform.isIOS;

// Méthode appelée lors de la création de l'objet d'état.
// Elle initialise imageClassificationHelper en appelant initHelper().
  @override
  void initState() {
    imageClassificationHelper = ImageClassificationHelper();
    imageClassificationHelper!.initHelper();
    super.initState();
  }

  // cleanResult(): Réinitialise les résultats de la classification en remettant à zéro imagePath
  //, image, et classification.
  void cleanResult() {
    imagePath = null;
    image = null;
    classification = null;
    setState(() {});
  }

  // Méthode pour traiter l'image sélectionnée.
  //lit les octets de l'image depuis le fichier, puis décode l'image à l'aide de la bibliothèque image.
  Future<void> processImage() async {
    if (imagePath != null) {
      // Read image bytes from file
      final imageData = File(imagePath!).readAsBytesSync();

      // Decode image using package:image/image.dart (https://pub.dev/image)
      image = img.decodeImage(imageData);
      setState(() {});
      classification = await imageClassificationHelper?.inferenceImage(image!);
      setState(() {});
    }
  }
  //Méthode appelée lorsque l'objet GalleryScreen est supprimé.
  //Ferme la classe ImageClassificationHelper pour libérer les ressources.
  @override
  void dispose() {
    imageClassificationHelper?.close();
    super.dispose();
  }

 //Méthode responsable de la construction de l'interface utilisateur de l'écran.
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              if (cameraIsAvailable)
                TextButton.icon(
                  onPressed: () async {
                    cleanResult();
                    final result = await imagePicker.pickImage(
                      source: ImageSource.camera,
                    );

                    imagePath = result?.path;
                    setState(() {});
                    processImage();
                  },
                  icon: const Icon(
                    Icons.camera,
                    size: 35,
                  ),
                  label: const Text("Take a photo"),
                ),
              TextButton.icon(
                onPressed: () async {
                  cleanResult();
                  final result = await imagePicker.pickImage(
                    source: ImageSource.gallery,
                  );

                  imagePath = result?.path;
                  setState(() {});
                  processImage();
                },
                icon: const Icon(
                  Icons.photo,
                  size: 35,
                ),
                label: const Text("Pick from gallery"),
              ),
            ],
          ),
          const Divider(color: Color.fromARGB(255, 0, 0, 0)),
          Expanded(
              child: Stack(
            alignment: Alignment.center,
            children: [
              if (imagePath != null) Image.file(File(imagePath!)),
              if (image == null)
                  Image.asset(
                    'assets/images/pngegg.png',
                    height: 100,
                    width: 100,
                  ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(),
                 
                  const Spacer(),
                  // Show classification result
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        if (classification != null)
                          ...(classification!.entries.toList()
                                ..sort(
                                  (a, b) => a.value.compareTo(b.value),
                                ))
                              .reversed
                              .take(3)
                              .map(
                                (e) => Container(
                                  padding: const EdgeInsets.all(8),
                                  color: Color.fromARGB(255, 210, 193, 193),
                                  child: Row(
                                    children: [
                                      Text(e.key),
                                      const Spacer(),
                                      Text(e.value.toStringAsFixed(2))
                                    ],
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          )),
        ],
      ),
    );
  }
}
//Ces classes et méthodes travaillent ensemble pour créer une interface utilisateur permettant à l'utilisateur de choisir une image, de la visualiser, puis de voir les résultats de la classification d'image. 
//La logique d'inférence d'image est encapsulée dans la classe ImageClassificationHelper.