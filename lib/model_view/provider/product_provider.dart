import 'package:flutter/cupertino.dart';
import 'package:handvibe/model/category_model.dart';
import 'package:handvibe/model/product_model.dart';
import 'package:handvibe/model_view/firebase/firebase_product.dart';
import 'package:handvibe/utility/enum.dart';

class ProductProvider extends ChangeNotifier{
  List<ProductModel> productsByCategory = [];
  List<ProductModel> productsByCategoryList = [];
  List<ProductModel> productsBySeller = [];
  List<ProductModel> productsFavorite = [];
  List<ProductModel> productsWithLimit = [];
  List<ProductModel> searchedProduct = [];
  List<ProductModel> myProducts = [];
  List<ProductModel> userProducts = [];
  ProductModel? productModel;
  Progressing progressing = Progressing.idle;

  getProductInfo(String productId)async{
    progressing = Progressing.busy;
    productModel = await FirebaseProduct().getProductInfo(productId);
    progressing = Progressing.idle;
    notifyListeners();
  }

  getProductsWithLimit(int limit)async{
    progressing = Progressing.busy;
    productsWithLimit = await FirebaseProduct().getProductListWithLimit(limit);
    progressing = Progressing.idle;
    notifyListeners();
  }

  getSearchedProductsWithLimit(int limit, String searchedText)async{
    progressing = Progressing.busy;
    searchedProduct = await FirebaseProduct().getSearchedProduct(searchedText, limit);
    progressing = Progressing.idle;
    notifyListeners();
  }

  clearSearchedProducts(){
    searchedProduct.clear();
    notifyListeners();
  }

  getProductsByCategory(CategoryModel category, int limit)async{
    progressing = Progressing.busy;
    productsByCategory = await FirebaseProduct().getProductListByCategory(category, limit);
    progressing = Progressing.idle;
    notifyListeners();
  }

  getProductsByCategoryList(List<CategoryModel> category, int limit)async{
    progressing = Progressing.busy;
    productsByCategoryList = await FirebaseProduct().getProductListByCategoryList(category, limit);
    progressing = Progressing.idle;
    notifyListeners();
  }

  getProductsBySeller(String sellerId, int limit)async{
    progressing = Progressing.busy;
    productsBySeller = await FirebaseProduct().getProductListBySeller(sellerId, limit);
    progressing = Progressing.idle;
    notifyListeners();
  }

  getProductsFavorite(List<String> productIdList)async{
    progressing = Progressing.busy;
    productsFavorite = await FirebaseProduct().getProductListByMyFavorite(productIdList);
    progressing = Progressing.idle;
    notifyListeners();
  }

  getMyProducts(String myID, int limit)async{
    progressing = Progressing.busy;
    myProducts = await FirebaseProduct().getProductListBySeller(myID, limit);
    progressing = Progressing.idle;
    notifyListeners();
  }

  getUserProducts(String userID, int limit)async{
    progressing = Progressing.busy;
    userProducts = await FirebaseProduct().getProductListBySeller(userID, limit);
    progressing = Progressing.idle;
    notifyListeners();
  }
}