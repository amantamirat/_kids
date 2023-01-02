import 'package:abdu_kids/model/my_model.dart';

class Kind extends MyModel<Kind> {
  static const String attributeColor = 'color';
  static const String attributeQuantity = 'quantity';

  late String? color;
  late int? quantity;

  @override
  Kind fromJson(Map<String, dynamic> json) {
    Kind kind = Kind();
    kind.id = json[MyModel.attributeId];
    kind.color = json[attributeColor];
    kind.quantity = json[attributeQuantity];
    return kind;
  }

  @override
  Map<String, dynamic> toJson({bool includeId = true}) {
    final data = <String, dynamic>{};
    if (includeId) {
      data[MyModel.attributeId] = id;
    }
    data[attributeColor] = color;
    data[attributeQuantity] = quantity;
    return data;
  }

  @override
  String path() {
    return "/kind";
  }
}
