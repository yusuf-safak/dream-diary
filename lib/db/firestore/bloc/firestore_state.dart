import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FirestoreState{
  String? result;
  DocumentSnapshot? document;
  QuerySnapshot? querySnapshot;
  FirestoreState({
    this.result,
    this.querySnapshot,
    this.document
  });
}
class FirestoreInitialState extends FirestoreState{
  FirestoreInitialState():super(result: '', document: null, querySnapshot: null);
}
class FirestoreWaitingState extends FirestoreState{
  FirestoreWaitingState(String waitingResult):super(result: waitingResult);
}
class FirestoreSuccessfulState extends FirestoreState{
  FirestoreSuccessfulState(String succesfulResult):super(result: succesfulResult);
}
class FirestoreFailedState extends FirestoreState{
  FirestoreFailedState(String failedResult):super(result: failedResult);
}

class FetchDocumentLoadedState extends FirestoreState{
  FetchDocumentLoadedState(DocumentSnapshot snapshot):super(document: snapshot);
}

class FetchQuerySnapshotLoadedState extends FirestoreState{
  FetchQuerySnapshotLoadedState(QuerySnapshot querySnapshot):super(querySnapshot: querySnapshot);
}