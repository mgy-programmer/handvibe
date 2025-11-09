import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:handvibe/utility/useful_methods.dart';

class FirebaseStorageMethods {
  late Reference reference;
  late UploadTask uploadTask;
  late TaskSnapshot taskSnapshot;
  late String downloadURL;

  Future<String> addImageToFirebase(File imageFile, String id, String folderName, int quality) async {
    Uint8List compressed = await UsefulMethods().compressImage(imageFile, quality);
    reference = FirebaseStorage.instance.ref().child('$folderName/$id');
    uploadTask = reference.putData(compressed);
    taskSnapshot = await uploadTask.whenComplete(() => {});
    downloadURL = await taskSnapshot.ref.getDownloadURL();
    return downloadURL;
  }

  Future<String> addVideoToFirebase(File? imageFile, String id, String folderName) async {
    if (imageFile != null) {
      reference = FirebaseStorage.instance.ref().child('$folderName/$id');
      uploadTask = reference.putFile(imageFile);
      taskSnapshot = await uploadTask.whenComplete(() => {});
      downloadURL = await taskSnapshot.ref.getDownloadURL();
      return downloadURL;
    } else {
      return "";
    }
  }

  deleteFileFromFirebaseStorage(String mediaName, String folderName) async {
    try {
      reference = FirebaseStorage.instance.ref().child('$folderName/$mediaName');
      await reference.delete();
      debugPrint('File deleted successfully');
    } catch (e) {
      debugPrint('Error deleting file: $e');
    }
  }
}
