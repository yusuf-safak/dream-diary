import 'package:dream_diary/auth/auth_info.dart';
import 'package:dream_diary/db/firestore/bloc/firestore_bloc.dart';
import 'package:dream_diary/db/firestore/bloc/firestore_event.dart';
import 'package:dream_diary/db/firestore/bloc/firestore_state.dart';
import 'package:dream_diary/utility/size_config.dart';
import 'package:dream_diary/view/custom_app_bar.dart';
import 'package:dream_diary/view/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dream_diary/models/user_model.dart' as user;

class ReminderScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
          return Scaffold(
          appBar: CustomAppBar(context: context,),
          body: BlocBuilder<FirestoreBloc,FirestoreState>(
    builder: (context,state) {
    if(state is FetchDocumentLoadedState) {
    bool isClick = state.document!['notifications enabled'];
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.notifications_active_outlined,size: 80,),
                    Text(
                      'Hatırlatıcı',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Hatırlatıcı günlük yazmayı unutmamanız için her gün size bildirim gönderir.\n'
                          'Hatırlatıcıyı açmak ister misiniz?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 20),
                    if (state.document!['notifications enabled'])
                      Text(
                        'Hatırlatıcı aktif',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.green,
                        ),
                      ),
                    SizedBox(height: 10),
                    CustomButton(
                      onTap: (){
                        isClick = !isClick;
                        user.User newUser = user.User(
                          email: AuthInfo.user.email,
                          password: AuthInfo.user.password,
                          notificationsEnabled: isClick,
                          username: AuthInfo.user.username,
                          pinCode: AuthInfo.user.pinCode,
                          token: AuthInfo.user.token
                        );
                        AuthInfo.userUpdate(newUser);
                        context.read<FirestoreBloc>().add(UpdateDataInFirestore(
                            id: FirebaseAuth.instance.currentUser!.uid,
                            collection: 'users', data: newUser));
                      },
                      text: state.document!['notifications enabled'] ? 'Hatırlatıcıyı Kapat' : 'Hatırlatıcıyı Aç',
                    ),
                    SizedBox(height: SizeConfig.screenHeight * 0.15,)
                  ],
                ),
              );
            }else{
      return Center(child: CircularProgressIndicator());
    }
    }
          ),
        );
        }
}
