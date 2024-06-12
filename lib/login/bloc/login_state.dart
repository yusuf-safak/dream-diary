abstract class LoginState{
  String result = '';
  LoginState({required this.result});
}
class LoginInitialState extends LoginState{
  LoginInitialState():super(result:'');
}
class LoginWaitingState extends LoginState{
  LoginWaitingState(String waitingResult):super(result: waitingResult);
}
class LoginSuccessfulState extends LoginState{
  LoginSuccessfulState(String succesfulResult):super(result: succesfulResult);
}
class LoginFailedState extends LoginState{
  LoginFailedState(String failedResult):super(result: failedResult);
}