import 'package:cloud_firestore/cloud_firestore.dart';

class AuthDreams{
  static QuerySnapshot? dreams;
  static void updateDreams(QuerySnapshot newDreams){
    dreams = newDreams;
  }
}