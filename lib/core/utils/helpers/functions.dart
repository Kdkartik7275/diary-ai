import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:lifeline/core/snackbars/error_snackbar.dart';

Future<File?> pickImage({bool camera = false}) async {
  try {
    ImagePicker picker = ImagePicker();
    XFile? pickedFile = await picker.pickImage(
      source: camera ? ImageSource.camera : ImageSource.gallery,
    );

    return File(pickedFile!.path);
  } catch (e) {
    showErrorDialog(e.toString());
  }
  return null;
}
