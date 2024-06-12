import 'package:dream_diary/models/user_model.dart';

class AuthInfo{
  static User user= User(
    pinScreenStatus: 'open',
    pinCode: null,
  username : '',
  token: '',
  email: '', password: '');
  static void userUpdate(User newUser){
    user = newUser;
  }
}