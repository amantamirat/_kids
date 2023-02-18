import 'package:abdu_kids/model/my_model.dart';
import 'package:abdu_kids/model/user.dart';

class ExtraWrapper {
  final User? user;
  final MyModel? model;
  final bool editMode;
  ExtraWrapper(this.user, this.model, {this.editMode = false});
}
