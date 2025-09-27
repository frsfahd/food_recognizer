import 'package:flutter/material.dart';

import 'package:food_recognizer/ui/camera_page.dart';
import 'package:image_picker/image_picker.dart';

class HomeProvider extends ChangeNotifier {
  HomeProvider();

  String? imagePath;

  XFile? imageFile;

  bool isUploading = false;
  String? _message;

  get message => _message;
  set message(String msg) {
    _message = msg;
    notifyListeners();
  }

  void _setImage(XFile? value) {
    imageFile = value;
    imagePath = value?.path;
    notifyListeners();
  }

  void openCamera() async {
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      _setImage(pickedFile);
      _resetUploadState();
    }
  }

  void openGallery() async {
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _setImage(pickedFile);
      _resetUploadState();
    }
  }

  void openCustomCamera(BuildContext context) async {
    final XFile? resultImageFile = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CameraPage()),
    );

    if (resultImageFile != null) {
      _setImage(resultImageFile);
      _resetUploadState();
    }
  }

  void _resetUploadState() {
    _message = null;
    notifyListeners();
  }
}
