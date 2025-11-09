import 'package:handvibe/model/media_hide_model.dart';
import 'package:handvibe/model/category_model.dart';

class ProductModel {
  late String productId;
  late String sellerId;
  late String productName;
  late List<MediaHideModel> productImages;
  late String description;
  late List<CategoryModel> productCategoryList;
  late List<String> productCategoryIdList;
  late String price;
  late String currency;
  late DateTime createdTime;

  ProductModel(
    this.productId,
    this.sellerId,
    this.productName,
    this.productImages,
    this.description,
    this.productCategoryList,
    this.productCategoryIdList,
    this.price,
    this.currency,
    this.createdTime,
  );

  ProductModel.fromJson(Map json) {
    productId = json["productId"];
    sellerId = json["sellerId"];
    productName = json["productName"];
    productImages = dynamicToModelListForMedia(json["productImages"]);
    description = json["description"];
    productCategoryList = dynamicToModelListForCategory(json["productCategoryList"]);
    productCategoryIdList = dynamicToModelListForString(json["productCategoryIdList"]);
    price = json["price"];
    currency = json["currency"];
    createdTime = DateTime.parse(json["createdTime"]);
  }

  toJson() {
    return {
      "productId": productId,
      "sellerId": sellerId,
      "productName": productName,
      "productImages": listToMapForMedia(productImages),
      "description": description,
      "productCategoryList": listToMapForCategory(productCategoryList),
      "productCategoryIdList": productCategoryIdList,
      "price": price,
      "currency": currency,
      "createdTime": createdTime.toString()
    };
  }



  dynamicToModelListForMedia(List<dynamic> list) {
    List<MediaHideModel> newList = [];
    for (var i in list) {
      newList.add(MediaHideModel.fromJson(i));
    }
    return newList;
  }

  listToMapForMedia(List<MediaHideModel> listModel) {
    List<Map<String, dynamic>> jsonObjects = listModel.map((model) {
      return {
        "mediaPath": model.mediaPath,
        "mediaName": model.mediaName,
      };
    }).toList();
    return jsonObjects;
  }

  dynamicToModelListForCategory(List<dynamic> list) {
    List<CategoryModel> newList = [];
    for (var i in list) {
      newList.add(CategoryModel.fromJson(i));
    }
    return newList;
  }

  dynamicToModelListForString(List<dynamic> list) {
    List<String> newList = [];
    for (var i in list) {
      newList.add(i.toString());
    }
    return newList;
  }

  listToMapForCategory(List<CategoryModel> listModel) {
    List<Map<String, dynamic>> jsonObjects = listModel.map((model) {
      return {
        "categoryId": model.categoryId,
        "categoryNameEN": model.categoryNameEN,
        "categoryNameTR": model.categoryNameTR,
        "categoryDescriptionTR": model.categoryDescriptionTR,
        "categoryDescriptionEN": model.categoryDescriptionEN,
      };
    }).toList();
    return jsonObjects;
  }
}
