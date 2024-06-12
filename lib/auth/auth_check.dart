import 'package:dream_diary/app/app_view.dart';
import 'package:dream_diary/db/firestore/bloc/firestore_bloc.dart';
import 'package:dream_diary/db/firestore/bloc/firestore_event.dart';
import 'package:dream_diary/db/firestore/bloc/firestore_state.dart';
import 'package:dream_diary/login/view/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCheck extends StatefulWidget {
  @override
  _AuthCheckState createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        context.read<FirestoreBloc>().add(
          FetchDocument(
            collection: 'users',
            id: user.uid,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FirestoreBloc, FirestoreState>(
      listener: (context, state) {
        if(state is FetchDocumentLoadedState){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>AppView()));
        }
      },
      child: FirebaseAuth.instance.currentUser == null?LoginView():Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/dream_diary_landing_screen.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      )
    );
  }
}
