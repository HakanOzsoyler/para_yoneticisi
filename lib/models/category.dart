class Category {
  int? categoryID;
  String? categoryName;
  String? type;
  String? categoryIconName;

  Category(this.categoryName, this.type, this.categoryIconName);

  Category.withID(this.categoryID, this.categoryName, this.type);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['categoryID'] = categoryID;
    map['categoryName'] = categoryName;
    map['type'] = type;
    map['categoryIconName'] = categoryIconName;
    return map;
  }

  Category.fromMap(Map<String, dynamic> map) {
    categoryID = map['categoryID'];
    categoryName = map['categoryName'];
    type = map['type'];
    categoryIconName = map['categoryIconName'];
  }
  @override
  String toString() {
    return 'Category{categoryID: $categoryID, categoryName: $categoryName, type: $type}';
  }
}
