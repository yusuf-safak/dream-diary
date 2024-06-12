import 'package:dream_diary/models/user_model.dart';

abstract class LoginEvent{

}
class LoginNewEvent extends LoginEvent{
  final User user;
  LoginNewEvent({
    required this.user});
}