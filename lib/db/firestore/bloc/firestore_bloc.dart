import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream_diary/db/firestore/bloc/firestore_event.dart';
import 'package:dream_diary/db/firestore/bloc/firestore_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FirestoreBloc extends Bloc<FirestoreEvent, FirestoreState>{
  FirestoreBloc():super(FirestoreInitialState()){
    on<AddToFirestore>((event,emit)async{
      emit(FirestoreWaitingState('Kaydediliyor...'));
      try{
        await FirebaseFirestore.instance.collection(event.collection).add(event.data.toJson());
        emit(FirestoreSuccessfulState('Kaydedildi.'));
      }catch(e){
        emit(FirestoreFailedState('Kaydedilemedi. Lütfen tekrar deneyiniz.'));
      }
    });
    on<UpdateDataInFirestore>((event,emit)async{
      emit(FirestoreWaitingState('Güncelleniyor...'));
      try{
        await FirebaseFirestore.instance.collection(event.collection).doc(event.id).update(event.data.toJson());
        emit(FirestoreSuccessfulState('Güncellendi.'));
        DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection(event.collection).doc(event.id).get();
        emit(FetchDocumentLoadedState(snapshot));
      }catch(e){
        emit(FirestoreFailedState('Güncellenemedi. Lütfen tekrar deneyiniz.'));
      }
    });
    on<DeleteFromFirestore>((event,emit)async{
      emit(FirestoreWaitingState('Siliniyor...'));
      try{
        await FirebaseFirestore.instance.collection(event.collection).doc(event.id).delete();
        emit(FirestoreSuccessfulState('Silindi.'));
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection(event.collection).get();
        emit(FetchQuerySnapshotLoadedState(querySnapshot));
      }catch(e){
        emit(FirestoreFailedState('Silinemedi. Lütfen tekrar deneyiniz.'));
      }
    });
    on<FetchDocument>((event,emit)async{
      emit(FirestoreWaitingState('Veriler getiriliyor...'));
      try{
        DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection(event.collection).doc(event.id).get();
        emit(FetchDocumentLoadedState(snapshot));
      }catch(e){
        emit(FirestoreFailedState('Veriler getirilemedi. Lütfen tekrar deneyiniz.'));
      }
    });
    on<FetchQuerySnapshot>((event,emit)async{
      emit(FirestoreWaitingState('Veriler getiriliyor...'));
      try{
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection(event.collection).get();
        emit(FetchQuerySnapshotLoadedState(querySnapshot));
      }catch(e){
        emit(FirestoreFailedState('Veriler getirilemedi. Lütfen tekrar deneyiniz.'));
      }
    });
  }
}