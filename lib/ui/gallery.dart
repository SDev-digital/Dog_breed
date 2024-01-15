 

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

class _GalleryScreenState extends State<GalleryScreen> {
  ImageClassificationHelper? imageClassificationHelper;
  final imagePicker = ImagePicker();
  String? imagePath;
  img.Image? image;
  Map<String, double>? classification;
  bool cameraIsAvailable = Platform.isAndroid || Platform.isIOS;

  @override
  void initState() {
    imageClassificationHelper = ImageClassificationHelper();
    imageClassificationHelper!.initHelper();
    super.initState();
  }

  // Clean old results when press some take picture button
  void cleanResult() {
    imagePath = null;
    image = null;
    classification = null;
    setState(() {});
  }

  // Process picked image
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

  @override
  void dispose() {
    imageClassificationHelper?.close();
    super.dispose();
  }

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
          const Divider(color: Colors.black),
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
