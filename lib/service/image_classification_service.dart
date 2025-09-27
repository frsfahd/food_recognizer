import 'dart:developer';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/services.dart';
import 'package:food_recognizer/service/firebase_ml_service.dart';
import 'package:food_recognizer/service/isolate_inference.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as image_lib;

class ImageClassificationService {
  final FirebaseMlService _mlService;
  final modelPath = 'assets/1.tflite';
  final labelsPath = 'assets/probability-labels-en.txt';
  late final File modelFile;

  ImageClassificationService(this._mlService);

  late final Interpreter interpreter;
  late final List<String> labels;
  late Tensor inputTensor;
  late Tensor outputTensor;
  late final IsolateInference isolateInference;

  Future<void> initModel() async {
    modelFile = await _mlService.loadModel();
    _loadLabels();
    _loadModel();
  }

  Future<void> _loadModel() async {
    // modelFile = await _mlService.loadModel();

    final options = InterpreterOptions()
      ..useNnApiForAndroid = true
      ..useMetalDelegateForIOS = true;

    interpreter = Interpreter.fromFile(modelFile, options: options);
    // Get tensor input shape [1, 224, 224, 3]
    inputTensor = interpreter.getInputTensors().first;
    // Get tensor output shape [1, 2024]
    outputTensor = interpreter.getOutputTensors().first;

    log('Interpreter loaded successfully');
  }

  // todo-02-service-05: load labels from assets
  Future<void> _loadLabels() async {
    final labelTxt = await rootBundle.loadString(labelsPath);
    labels = labelTxt.split('\n');
  }

  Future<void> initHelper() async {
    // _loadLabels();
    // _loadModel();
    isolateInference = IsolateInference();
    await isolateInference.start();
  }

  Future<Map<String, double>> inferenceImage(XFile image) async {
    final bytes = await image.readAsBytes();
    final image_input = image_lib.decodeImage(bytes);

    var isolateModel = InferenceModel(
      image_input,
      interpreter.address,
      labels,
      inputTensor.shape,
      outputTensor.shape,
    );

    ReceivePort responsePort = ReceivePort();
    isolateInference.sendPort.send(
      isolateModel..responsePort = responsePort.sendPort,
    );
    // get inference result.
    var results = await responsePort.first;
    return results;
  }

  Future<void> close() async {
    await isolateInference.close();
  }
}
