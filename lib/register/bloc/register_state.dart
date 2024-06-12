abstract class RegisterState{
  String result = '';
  RegisterState({required this.result});
}
class RegisterInitialState extends RegisterState{
  RegisterInitialState():super(result: '');
}
class RegisterWaitingState extends RegisterState{
  RegisterWaitingState(String waitingResult): super(result: waitingResult);
}
class RegisterSuccessfulState extends RegisterState{
  RegisterSuccessfulState(String successResult): super(result: successResult);
}
class RegisterFailedState extends RegisterState{
  RegisterFailedState(String failedResult): super(result: failedResult);
}