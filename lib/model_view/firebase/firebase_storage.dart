import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:handvibe/utility/useful_methods.dart';
import 'package:path_provider/path_provider.dart';

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

  Future<String> addDocumentToFirebase(File file, String id, String folderName) async {
    reference = FirebaseStorage.instance.ref().child('$folderName/$id');
    uploadTask = reference.putFile(file);
    taskSnapshot = await uploadTask.whenComplete(() => {});
    downloadURL = await taskSnapshot.ref.getDownloadURL();
    return downloadURL;
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

  Future<File?> downloadFile(String filePath) async {
    try {
      // Use dio to download the file
      Dio dio = Dio();
      Response<List<int>> response = await dio.get<List<int>>(
        filePath,
        options: Options(responseType: ResponseType.bytes),
      );

      // Get the local app directory
      Directory appDocDir = await getApplicationDocumentsDirectory();

      // Save the file to the app directory
      File file = File('${appDocDir.path}/invoice.pdf');
      await file.writeAsBytes(response.data!);
      debugPrint('File downloaded successfully to device storage: ${file.path}');
      return file;
    } catch (e) {
      debugPrint('Error downloading file: $e');
      return null;
    }
  }
}