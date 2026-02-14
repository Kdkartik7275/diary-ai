import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
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

String formatCount(int count) {
  if (count < 1000) {
    return count.toString();
  } else if (count < 1000000) {
    final value = count / 1000;
    return value % 1 == 0
        ? '${value.toInt()}k'
        : '${value.toStringAsFixed(1)}k';
  } else if (count < 1000000000) {
    final value = count / 1000000;
    return value % 1 == 0
        ? '${value.toInt()}M'
        : '${value.toStringAsFixed(1)}M';
  } else {
    final value = count / 1000000000;
    return value % 1 == 0
        ? '${value.toInt()}B'
        : '${value.toStringAsFixed(1)}B';
  }
}

String getCommentTime(Timestamp timestamp) {
  final DateTime commentTime = timestamp.toDate();
  final Duration diff = DateTime.now().difference(commentTime);

  if (diff.inSeconds < 60) {
    return 'just now';
  } else if (diff.inMinutes < 60) {
    return '${diff.inMinutes}m ago';
  } else if (diff.inHours < 24) {
    return '${diff.inHours}h ago';
  } else if (diff.inDays < 7) {
    return '${diff.inDays}d ago';
  } else {
    return '${commentTime.day}/${commentTime.month}/${commentTime.year}';
  }
}
