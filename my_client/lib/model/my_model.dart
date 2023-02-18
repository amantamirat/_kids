abstract class MyModel {
  static const String attributeId = '_id';
  late String? id;
  late String? message="";
  MyModel fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson({bool includeId = true});
  String header();
  //the following needs some modifications.
  String basePath();
  String paramsPath();
  String? defaultNextPage() {
    return null;
  }
  List<MyModel>? subList() {
    return null;
  }
}
