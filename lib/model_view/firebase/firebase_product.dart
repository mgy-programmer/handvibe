import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:handvibe/model/category_model.dart';
import 'package:handvibe/model/product_model.dart';
import 'package:handvibe/utility/constant.dart';

class FirebaseProduct {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  late DocumentSnapshot<Map<String, dynamic>> documentSnapshot;
  late QuerySnapshot<Map<String, dynamic>> querySnapshot;
  List<ProductModel> productList = [];

  addProduct(ProductModel data) async {
    await firebaseFirestore.collection(Constants().products).doc(data.productId).set(data.toJson());
  }

  Future<ProductModel?> getProductInfo(String productId) async {
    documentSnapshot = await firebaseFirestore.collection(Constants().products).doc(productId).get();
    if (documentSnapshot.exists) {
      return ProductModel.fromJson(documentSnapshot.data()!);
    } else {
      debugPrint("The data for the given uid does not exist $productId");
      return null;
    }
  }

  Future<List<ProductModel>> getProductListWithLimit(int limit) async {
    try {
      querySnapshot = await firebaseFirestore
          .collection(Constants().products)
          .orderBy("createdTime", descending: true)
          .limit(limit)
          .get();

      productList = querySnapshot.docs.map((doc) => ProductModel.fromJson(doc.data())).toList();

      return productList;
    } catch (e) {
      debugPrint("Error in getAllUserInfo: $e");
      return [];
    }
  }

  Future<List<ProductModel>> getProductListByCategory(CategoryModel category, int limit) async {
    try {
      querySnapshot = await firebaseFirestore
          .collection(Constants().products)
          .where("productCategoryList", arrayContains: category.toJson())
          .limit(limit)
          .get();

      productList = querySnapshot.docs.map((doc) => ProductModel.fromJson(doc.data())).toList();

      return productList;
    } catch (e) {
      debugPrint("Error in getAllUserInfo: $e");
      return [];
    }
  }

  Future<List<ProductModel>> getProductListByCategoryList(List<CategoryModel> categories, int limit) async {
    try {
      // Sadece categoryId'leri ayıkla
      List<String> categoryIds = categories.map((category) => category.categoryId).toList();

      // Firestore'da productCategoryIdList: ["cat1", "cat2", ...] şeklinde tutulmalı
      QuerySnapshot querySnapshot = await firebaseFirestore
          .collection(Constants().products)
          .where("productCategoryIdList", arrayContainsAny: categoryIds)
          .limit(limit)
          .get();

      List<ProductModel> productList = querySnapshot.docs
          .map((doc) => ProductModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return productList;
    } catch (e) {
      debugPrint("Error in getProductListByCategoryList: $e");
      return [];
    }
  }

  Future<List<ProductModel>> getSearchedProduct(String searchText, int limit) async {
    try {
      querySnapshot = await firebaseFirestore
          .collection(Constants().products)
          .where("productName", isGreaterThan: searchText)
          .limit(limit)
          .get();

      productList = querySnapshot.docs.map((doc) => ProductModel.fromJson(doc.data())).toList();
      debugPrint("Geldi");
      return productList;
    } catch (e) {
      debugPrint("Error in getAllUserInfo: $e");
      return [];
    }
  }

  Future<List<ProductModel>> getProductListBySeller(String sellerId, int limit) async {
    try {
      querySnapshot = await firebaseFirestore
          .collection(Constants().products)
          .where("sellerId", isEqualTo: sellerId)
          .orderBy("createdTime", descending: true)
          .limit(limit)
          .get();

      productList = querySnapshot.docs.map((doc) => ProductModel.fromJson(doc.data())).toList();

      return productList;
    } catch (e) {
      debugPrint("Error in getAllUserInfo: $e");
      return [];
    }
  }

  Future<List<ProductModel>> getProductListByMyFavorite(List<String> productIdList) async {
    productList = [];
    try {
      for(var i in productIdList){
        documentSnapshot = await firebaseFirestore.collection(Constants().products).doc(i).get();
        if (documentSnapshot.exists) {
          productList.add(ProductModel.fromJson(documentSnapshot.data()!));
        } else {
          debugPrint("The data for the given uid does not exist $productIdList");
        }
      }
      return productList;
    } catch (e) {
      debugPrint("Error in getAllUserInfo: $e");
      return [];
    }
  }

  updateProduct(ProductModel data) async {
    await firebaseFirestore.collection(Constants().products).doc(data.productId).update(data.toJson());
  }

  deleteProduct(String productId) async {
    await firebaseFirestore.collection(Constants().products).doc(productId).delete();
  }
}
