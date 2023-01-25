abstract class MyModel {
  static const String attributeId = '_id';
  late String? id;
  MyModel fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson(
      {bool includeId = true});
  String header();
  //the following needs some modifications.
  String basePath();
  String paramsPath();
}
