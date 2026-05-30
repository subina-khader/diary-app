class DiaryModel {
  final int? id;
  final String name;
  final int themeValue;
  final String themeName;
  final String categoryIconPath;
  final String categoryName;
  final bool isPrivate;
  final String? password;

  const DiaryModel({
    this.id,
    required this.name,
    required this.themeValue,
    required this.themeName,
    required this.categoryIconPath,
    required this.categoryName,
    required this.isPrivate,
    this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) "id": id,
      "name": name,
      "themeValue": themeValue,
      "themeName": themeName,
      "categoryIconPath": categoryIconPath,
      "categoryName": categoryName,
      "isPrivate": isPrivate ? 1 : 0,
      "password": password,
    };
  }

  factory DiaryModel.fromMap(Map<String, dynamic> map) {
    return DiaryModel(
      id: map["id"],
      name: map["name"],
      themeValue: map["themeValue"],
      themeName: map["themeName"],
      categoryIconPath: map["categoryIconPath"],
      categoryName: map["categoryName"],
      isPrivate: map["isPrivate"] == 1,
      password: map["password"],
    );
  }
}
