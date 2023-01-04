abstract class MyModel<T> {
  static const String attributeId = '_id';
  late String? id;
  T fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson({bool includeId = true});
  String basePath();
  String paramsPath();
}
