import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import 'package:food_recognizer/service/image_classification_service.dart';

class ImageClassificationViewmodel extends ChangeNotifier {
  final ImageClassificationService _service;

  ImageClassificationViewmodel(this._service) {
    _service.initHelper();
  }

  Map<String, num> _classifications = {};
  bool isLoading = false;

  Map<String, num> get classifications => Map.fromEntries(
    (_classifications.entries.toList()
          ..sort((a, b) => a.value.compareTo(b.value)))
        .reversed
        .take(1),
  );

  Future<void> runClassificationFromImage(XFile image) async {
    isLoading = true;
    notifyListeners();
    _classifications = await _service.inferenceImage(image);
    isLoading = false;
    notifyListeners();
  }

  Future<void> close() async {
    await _service.close();
  }
}
