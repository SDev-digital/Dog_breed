import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'isolate_inference.dart';
class ImageClassificationHelper {
  // Paths to the model file and labels file
  static const modelPath = 'assets/models/mobilenet_quant.tflite';
  static const labelsPath = 'assets/models/labels.txt';

  // Declare necessary variables
  late final Interpreter interpreter;
  late final List<String> labels;
  // ki9assam lkhadma 3la lkhadma dyal tel 

  // kidir tretment de camera et ou cupture des image 
  late final IsolateInference isolateInference;

  // kat3tiH les frimse image 
  late Tensor inputTensor;
  // result 
  late Tensor outputTensor;

  // Load model
  Future<void> _loadModel() async {
    // Create InterpreterOptions
    //confeguration 
    final options = InterpreterOptions();
    // Use XNNPACK Delegate (for Android)
    if (Platform.isAndroid) {
      options.addDelegate(XNNPackDelegate());
    }
    // Use GPU Delegate (uncomment if applicable, doesn't work on emulator)
    // if (Platform.isAndroid) {
    //   options.addDelegate(GpuDelegateV2());
    // }
    // Use Metal Delegate (for iOS)
    if (Platform.isIOS) {
      options.addDelegate(GpuDelegate());
    }

    // Load model from assets using the provided options
    interpreter = await Interpreter.fromAsset(modelPath, options: options);
    // Get the input and output tensors
    inputTensor = interpreter.getInputTensors().first;
    outputTensor = interpreter.getOutputTensors().first;

    // Log success message
    log('Interpreter loaded successfully');
  }

  // Load labels from assets
  Future<void> _loadLabels() async {
    final labelTxt = await rootBundle.loadString(labelsPath);
    labels = labelTxt.split('\n');
  }

  Future<void> initHelper() async {
    _loadLabels();
    _loadModel();
    isolateInference = IsolateInference();
    await isolateInference.start();
  }


  Future<Map<String, double>> _inference(InferenceModel inferenceModel) async {
    ReceivePort responsePort = ReceivePort();
    isolateInference.sendPort
        .send(inferenceModel..responsePort = responsePort.sendPort);
    // get inference result.
    var results = await responsePort.first;
    return results;
  }

  // inference camera frame
  // groupe le travail 
  Future<Map<String, double>> inferenceCameraFrame(
      CameraImage cameraImage) async {
    var isolateModel = InferenceModel(cameraImage, null, interpreter.address,
        labels, inputTensor.shape, outputTensor.shape);
    return _inference(isolateModel);
  }
  
  // inference still image
  Future<Map<String, double>> inferenceImage(Image image) async {
    var isolateModel = InferenceModel(null, image, interpreter.address, labels,
        inputTensor.shape, outputTensor.shape);
    return _inference(isolateModel);
  }

  Future<void> close() async {
    isolateInference.close();
  }
}
