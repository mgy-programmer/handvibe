
class CategoryModel {
  late String categoryId;
  late String categoryNameEN;
  late String categoryNameTR;
  late String categoryDescriptionTR;
  late String categoryDescriptionEN;

  CategoryModel(this.categoryId, this.categoryNameEN, this.categoryNameTR, this.categoryDescriptionEN, this.categoryDescriptionTR);

  CategoryModel.fromJson(Map json) {
    categoryId = json["categoryId"];
    categoryNameEN = json["categoryNameEN"];
    categoryNameTR = json["categoryNameTR"];
    categoryDescriptionTR = json["categoryDescriptionTR"];
    categoryDescriptionEN = json["categoryDescriptionEN"];
  }

  toJson() {
    return {
      "categoryId": categoryId,
      "categoryNameEN": categoryNameEN,
      "categoryNameTR": categoryNameTR,
      "categoryDescriptionTR": categoryDescriptionTR,
      "categoryDescriptionEN": categoryDescriptionEN,
    };
  }
}
