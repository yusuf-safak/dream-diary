import 'package:dream_diary/models/firestore_model.dart';

abstract class FirestoreEvent{

}
class AddToFirestore extends FirestoreEvent{
  final FireStoreModel data;
  final String collection;
  AddToFirestore({
    required this.collection,
    required this.data
  });
}
class UpdateDataInFirestore extends FirestoreEvent{
  final FireStoreModel data;
  final String collection;
  final String id;
  UpdateDataInFirestore({
    required this.id,
    required this.collection,
    required this.data,
  });
}
class DeleteFromFirestore extends FirestoreEvent{
  final String collection;
  final String id;
  DeleteFromFirestore({
    required this.id,
    required this.collection,
  });
}
class FetchDocument extends FirestoreEvent{
  final String collection;
  final String id;
  FetchDocument({
    required this.collection,
    required this.id
});
}
class FetchQuerySnapshot extends FirestoreEvent{
  final String collection;
  FetchQuerySnapshot({
    required this.collection,
  });
}