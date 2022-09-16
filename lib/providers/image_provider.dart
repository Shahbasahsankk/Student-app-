import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageProvder with ChangeNotifier {
  File? img;
  bool isVisible = false;
  void getImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image == null) {
      return;
    } else {
      final imagepath = File(image.path);
      img = imagepath;
    }
    notifyListeners();
  }

  void visible(img) {
    if (img == null) {
      isVisible = true;
    } else {
      isVisible = false;
    }
    notifyListeners();
  }
}
