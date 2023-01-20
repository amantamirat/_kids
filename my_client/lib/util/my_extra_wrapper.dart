import 'package:abdu_kids/model/my_model.dart';

class MyExtraWrapper {
  final MyModel data;
  final bool editMode;
  final bool manageMode;
  MyExtraWrapper(
      {required this.data, required this.editMode, required this.manageMode});
}
