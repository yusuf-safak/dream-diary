import 'package:dream_diary/app/bloc/app_bloc.dart';
import 'package:dream_diary/app/bloc/app_event.dart';
import 'package:dream_diary/app/bloc/app_state.dart';
import 'package:dream_diary/auth/auth_dreams.dart';
import 'package:dream_diary/auth/auth_info.dart';
import 'package:dream_diary/models/user_model.dart'as user;
import 'package:dream_diary/screens/add_dream.dart';
import 'package:dream_diary/screens/pin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../db/firestore/bloc/firestore_bloc.dart';
import '../db/firestore/bloc/firestore_event.dart';
import '../db/firestore/bloc/firestore_state.dart';
import '../screens/calendar.dart';
import '../screens/profile.dart';

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      Calendar(),
      AddDream(),
      Profile(),
    ];

    return BlocListener<AppBloc, AppState>(
        listener: (context, state) {
          if (state.pageIndex == 2) {
            context.read<FirestoreBloc>().add(
                FetchQuerySnapshot(collection: 'dreams'));
          }
          if (state.pageIndex == 0) {
            context.read<FirestoreBloc>().add(
                FetchQuerySnapshot(collection: 'dreams'));
          }
          if (state.pageIndex == 1) {
            context.read<FirestoreBloc>().add(
                FetchDocument(collection: 'users',
                    id: FirebaseAuth.instance.currentUser!.uid));
          }
        },
        child: BlocBuilder<AppBloc, AppState>(
            builder: (context, state) {
              return BlocBuilder<FirestoreBloc, FirestoreState>(
                  builder: (context, firestoreState) {
                  return Scaffold(
                      body: Builder(
                        builder: (context) {
                          if (state.pageIndex == 2 &&
                              firestoreState is FirestoreWaitingState) {
                            return Center(child: CircularProgressIndicator());
                          }
                          else if (state.pageIndex == 2 &&
                              firestoreState is FetchQuerySnapshotLoadedState) {
                            AuthDreams.updateDreams(firestoreState.querySnapshot!);
                            context.read<FirestoreBloc>().add(
                                FetchDocument(collection: 'users',
                                    id: FirebaseAuth.instance.currentUser!.uid));
                            return Center(child: CircularProgressIndicator());
                          }
                          else if (state.pageIndex == 2 &&
                              firestoreState is FetchDocumentLoadedState) {
                            return Profile();
                          } else if (state.pageIndex == 1 &&
                              firestoreState is FirestoreWaitingState) {
                            return Center(child: CircularProgressIndicator());
                          } else if (state.pageIndex == 1 &&
                              firestoreState is FetchDocumentLoadedState) {
                            if (AuthInfo.user.pinScreenStatus == 'open' &&
                                firestoreState.document!['pin code'] != null) {
                              return PinScreen();
                            } else {
                              user.User newUser = user.User(
                                username: firestoreState.document!['username'],
                                email: firestoreState.document!['email'],
                                password: firestoreState.document!['password'],
                                token: firestoreState.document!['token'],
                                pinCode: firestoreState.document!['pin code'],
                                pinScreenStatus: 'close',
                              );
                              AuthInfo.userUpdate(newUser);
                              return AddDream();
                            }
                          }
                          else if (state.pageIndex == 0 &&
                              firestoreState is FirestoreWaitingState) {
                            return Center(child: CircularProgressIndicator());
                          } else if (state.pageIndex == 0 &&
                              firestoreState is FetchQuerySnapshotLoadedState) {
                            return Calendar();
                          }
                          else {
                            return pages[state.pageIndex];
                          }
                        },
                      ),
                      bottomNavigationBar:
                      (AuthInfo.user.pinScreenStatus == 'open' && !(firestoreState is FetchDocumentLoadedState)) ?
                      SizedBox.shrink() : BottomNavigationBar(
                        backgroundColor: Colors.grey.shade200,
                        items: [
                          const BottomNavigationBarItem(
                            icon: Icon(Icons.calendar_month, size: 28,),
                            label: '',
                          ),
                          const BottomNavigationBarItem(
                            icon: Icon(Icons.add_box_outlined, size: 28),
                            label: '',
                          ),
                          const BottomNavigationBarItem(
                            icon: Icon(Icons.person, size: 28),
                            label: '',
                          ),
                        ],
                        currentIndex: state.pageIndex,
                        onTap: (index) {
                          context.read<AppBloc>().add(UpdatePageIndex(index));
                        },
                        selectedItemColor: Colors.black,
                        unselectedItemColor: Colors.grey,
                      )
                  );
                }
              );
            }));
  }}
