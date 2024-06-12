import '../../models/user_model.dart';

abstract class RegisterEvent{

}
class NewRegisterEvent extends RegisterEvent{
  final User user;
  NewRegisterEvent({required this.user});
}