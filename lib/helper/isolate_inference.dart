import 'dart:io';
import 'dart:isolate';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as image_lib;
import 'package:Breed_dog/image_utils.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

//déclaration de nom de débogage d'isolat et la variable qui stockera l'inference dans l'isolat
// et ainsi les ports de communication
class IsolateInference {
  static const String _debugName = "TFLITE_INFERENCE";
  final ReceivePort _receivePort = ReceivePort();
  late Isolate _isolate;
  late SendPort _sendPort;

  SendPort get sendPort => _sendPort;

//a méthode start pour démarrer l'isolat.
//Le résultat est stocké dans _isolate.

  Future<void> start() async {
    _isolate = await Isolate.spawn<SendPort>(entryPoint, _receivePort.sendPort,
        debugName: _debugName);
      //Attends le premier message sur le port de réception,
    _sendPort = await _receivePort.first;
  }

//pour fermer l'isolat et le port de réception lorsqu'il n'est plus nécessaire.

  Future<void> close() async {
    _isolate.kill();
    _receivePort.close();
  }
//Attend des instances de InferenceModel
// provenant du thread principal et effectue la logique d'inférence pour chaque modèle.
  static void entryPoint(SendPort sendPort) async {
    final port = ReceivePort();
    sendPort.send(port.sendPort);
    //Conditionnellement charge une image à partir d'un modèle d'inférence.

    await for (final InferenceModel isolateModel in port) {
      image_lib.Image? img;
      if (isolateModel.isCameraFrame()) {
        img = ImageUtils.convertCameraImage(isolateModel.cameraImage!);
      } else {
        img = isolateModel.image;
      }

      // Redimensionne l'image pour correspondre à la forme d'entrée du modèle TensorFlow Lite.
      image_lib.Image imageInput = image_lib.copyResize(
        img!,
        width: isolateModel.inputShape[1],
        height: isolateModel.inputShape[2],
      );

      if (Platform.isAndroid && isolateModel.isCameraFrame()) {
        imageInput = image_lib.copyRotate(imageInput, angle: 90);
      }

     //Convertit l'image en une matrice de pixels RGB.
      final imageMatrix = List.generate(
        imageInput.height,
        (y) => List.generate(
          imageInput.width,
          (x) {
            final pixel = imageInput.getPixel(x, y);
            return [pixel.r, pixel.g, pixel.b];
          },
        ),
      );

//Prépare les structures de données pour les entrées et les sorties du modèle
// TensorFlow Lite.
//input) :c'est la représentation de l'image que le modèle utilisera pour l'inférence

//Transforme la matrice en une liste, car TensorFlow Lite attend généralement une listedes tenseurs
// pour l'inférence.
      // Set tensor input [1, 224, 224, 3]
      final input = [imageMatrix];
      // Set tensor output [1, 1001]
      final output = [List<int>.filled(isolateModel.outputShape[1], 0)];

      // //Crée une instance d'Interpreter à partir de l'adresse de l'interpréteur passée dans le modèle,
      // puis exécute l'inférence avec l'entrée préparée (input) et stocke le résultat dans output.

      Interpreter interpreter =
          Interpreter.fromAddress(isolateModel.interpreterAddress);
      interpreter.run(input, output);
      
      //  Calcule le score maximal parmi les résultats d'inférence.
      final result = output.first;
      int maxScore = result.reduce((a, b) => a + b);

      // Crée une classification en associant chaque label avec son score de 
      //confiance normalisé.
      var classification = <String, double>{};
      for (var i = 0; i < result.length; i++) {
        if (result[i] != 0) {
          classification[isolateModel.labels[i]] =
              result[i].toDouble() / maxScore.toDouble();
        }
      }
      //Envoie la classification au thread principal via le port de réponse.
      isolateModel.responsePort.send(classification);
    }
  }
}

class InferenceModel {
  CameraImage? cameraImage;
  image_lib.Image? image;
  int interpreterAddress;
  List<String> labels;
  List<int> inputShape;
  List<int> outputShape;
  late SendPort responsePort;

  InferenceModel(this.cameraImage, this.image, this.interpreterAddress,
      this.labels, this.inputShape, this.outputShape);

  // check if it is camera frame or still image
  bool isCameraFrame() {
    return cameraImage != null;
  }
}
