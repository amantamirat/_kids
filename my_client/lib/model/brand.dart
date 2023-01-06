import 'package:abdu_kids/model/my_model.dart';

class Brand extends MyModel<Brand> {
  static const String path = "/brands";
  static const String attributeName = 'name';
  late String? name;

  @override
  Brand fromJson(Map<String, dynamic> json) {
    id = json[MyModel.attributeId];
    name = json[attributeName];
    return this;
  }

  @override
  Map<String, dynamic> toJson({bool includeId = true}) {
    final data = <String, dynamic>{};
    if (includeId) {
      data["_id"] = id;
    }
    data[attributeName] = name;
    return data;
  }

  @override
  String basePath() {
    return path;
  }

  @override
  String paramsPath() {
    return "";
  }

  static List<Brand> brandsFromJson(dynamic str) =>
      List<Brand>.from((str).map((x) => Brand().fromJson(x)));
}
