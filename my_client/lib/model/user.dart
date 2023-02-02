import 'package:abdu_kids/model/my_model.dart';
import 'package:abdu_kids/util/page_names.dart';

enum Role {
  customer("Customer"),
  administrator("Administrator");

  const Role(this.title);
  final String title;
}

enum Status {
  pending("Pending"),
  verified("Verified"),
  blocked("Blocked");

  const Status(this.title);
  final String title;
}

class User extends MyModel {
  static const String attributeFirstName = 'first_name';
  static const String attributeLastName = 'last_name';
  static const String attributeEmail = 'email';
  static const String attributePhoneNumber = 'phone_number';
  static const String attributeAddress = 'address';
  static const String attributePassword = 'password';
  static const String attributeUserStatus = 'user_status';
  static const String attributeRole = 'role';
  static const String attributeToken = 'token';
  static const String attributeCode = 'verification_code';

  late String? firstName = "Unkown";
  late String? lastName = "";
  late String email;
  late String? phoneNumber = "";
  late String? address = "";
  late String password;
  late Role role = Role.customer;
  late Status status = Status.pending;
  late String? token = "";
  late String? verificationCode = "";

  @override
  User fromJson(Map<String, dynamic> json) {
    id = json[MyModel.attributeId];
    firstName = json[attributeFirstName];
    lastName = json[attributeLastName];
    email = json[attributeEmail];
    phoneNumber = json[attributePhoneNumber];
    address = json[attributeAddress];
    password = json[attributePassword];
    var userrole = json[attributeRole];
    for (Role r in Role.values) {
      if (userrole == r.title) {
        role = r;
        break;
      }
    }
    var userstatus = json[attributeUserStatus];
    for (Status u in Status.values) {
      if (userstatus == u.title) {
        status = u;
        break;
      }
    }
    token = json[attributeToken];
    verificationCode = json[attributeCode];
    //products = Product.productsFromJson(json[attributeProducts], this);
    return this;
  }

  @override
  Map<String, dynamic> toJson({bool includeId = true}) {
    final data = <String, dynamic>{};
    if (includeId) {
      data[MyModel.attributeId] = id;
    }
    data[attributeFirstName] = firstName;
    data[attributeLastName] = lastName;
    data[attributeEmail] = email;
    data[attributePhoneNumber] = phoneNumber;
    data[attributeAddress] = address;
    data[attributePassword] = password;
    data[attributeUserStatus] = status.title;
    data[attributeRole] = role.title;
    data[attributeToken] = token;
    data[attributeCode] = verificationCode;
    return data;
  }

  @override
  String header() {
    return firstName == null ? "" : firstName!;
  }

  @override
  String basePath() {
    return "/${PageNames.users}";
  }

  @override
  String paramsPath() {
    return "";
  }

  static List<User> usersFromJson(dynamic str) =>
      List<User>.from((str).map((x) => User().fromJson(x)));
}
