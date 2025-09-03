import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:handvibe/model/category_model.dart';
import 'package:handvibe/utility/constant.dart';

class FirebaseCategory {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  late DocumentSnapshot<Map<String, dynamic>> documentSnapshot;
  late QuerySnapshot<Map<String, dynamic>> querySnapshot;
  List<CategoryModel> categoryList = [];

  addCategory(CategoryModel data) async {
    await firebaseFirestore.collection(Constants().category).doc(data.categoryId).set(data.toJson());
  }

  Future<CategoryModel?> getCategoryInfo(String categoryId) async {
    documentSnapshot = await firebaseFirestore.collection(Constants().category).doc(categoryId).get();
    if (documentSnapshot.exists) {
      return CategoryModel.fromJson(documentSnapshot.data()!);
    } else {
      debugPrint("The data for the given uid does not exist $categoryId");
      return null;
    }
  }

  Future<List<CategoryModel>> getCategoryList() async {
    try {
      querySnapshot = await firebaseFirestore
          .collection(Constants().category)
          .get();

      categoryList = querySnapshot.docs.map((doc) => CategoryModel.fromJson(doc.data())).toList();

      return categoryList;
    } catch (e) {
      debugPrint("Error in getAllUserInfo: $e");
      return [];
    }
  }

  updateCategory(CategoryModel data) async {
    await firebaseFirestore.collection(Constants().category).doc(data.categoryId).update(data.toJson());
  }

  deleteCategory(String categoryId) async {
    await firebaseFirestore.collection(Constants().category).doc(categoryId).delete();
  }
}