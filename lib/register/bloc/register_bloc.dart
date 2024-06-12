import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream_diary/register/bloc/register_event.dart';
import 'package:dream_diary/register/bloc/register_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState>{
  RegisterBloc():super(RegisterInitialState()){
    on<NewRegisterEvent>((event,emit)async{
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      final FirebaseAuth _auth = FirebaseAuth.instance;
      emit(RegisterWaitingState('Kullanıcı kaydediliyor...'));
      try{
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: event.user.email,
          password: event.user.password,
        );
        await _firestore.collection('users').doc(userCredential.user!.uid).set(event.user.toJson());
        if(_auth.currentUser != null) {
          emit(RegisterSuccessfulState('Kaydınız başarıyla tamamlandı!'));
        }
      }catch(e){
        emit(RegisterFailedState('Kayıt olurken bir sorun oluştu.'));
      }
    });
  }
}