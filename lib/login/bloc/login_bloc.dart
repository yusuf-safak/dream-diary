import 'package:dream_diary/login/bloc/login_event.dart';
import 'package:dream_diary/login/bloc/login_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState>{
  LoginBloc():super(LoginInitialState()){
    on<LoginNewEvent>((event,emit)async{
      final FirebaseAuth _auth = FirebaseAuth.instance;
      emit(LoginWaitingState('Giriş yapılıyor...'));
      try{
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: event.user.email,
          password: event.user.password,
        );
        if(userCredential.user != null){
          emit(LoginSuccessfulState('Giriş başarılı.'));
        }
      }catch(e){
        emit(LoginFailedState('Giriş yaparken bir sorun oluştu'));
      }
    });
  }
}