import 'package:dream_diary/models/firestore_model.dart';
class User implements FireStoreModel{
  String? username; final String email; final String password;
  String? token; String? pinCode; String? pinScreenStatus; bool? notificationsEnabled;
  User({
    this.username, required this.email, required this.password, this.token,
    this.pinCode, this.pinScreenStatus, this.notificationsEnabled
  });
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      email: json['email'],
      password: json['password'],
      token: json['token'],
      pinCode: json['pin code'],
      notificationsEnabled: json['notifications enabled'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'token': token,
      'pin code': pinCode,
      'notifications enabled': notificationsEnabled
    };
  }
}
