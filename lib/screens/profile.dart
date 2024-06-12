import 'package:dream_diary/auth/auth_check.dart';
import 'package:dream_diary/auth/auth_info.dart';
import 'package:dream_diary/db/firestore/bloc/firestore_bloc.dart';
import 'package:dream_diary/db/firestore/bloc/firestore_event.dart';
import 'package:dream_diary/db/firestore/bloc/firestore_state.dart';
import 'package:dream_diary/screens/pin_screen.dart';
import 'package:dream_diary/screens/reminder_screen.dart';
import 'package:dream_diary/utility/app_colors.dart';
import 'package:dream_diary/utility/size_config.dart';
import 'package:dream_diary/utility/snackbar_helper.dart';
import 'package:dream_diary/view/emoji_graphic.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dream_diary/models/user_model.dart' as user;

import '../view/custom_button.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FirestoreBloc, FirestoreState>(
      builder: (context, state) {
        if(state is FetchDocumentLoadedState) {
          return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: SizeConfig.screenHeight * 0.02,),
                  Center(child: Text('DREAM DIARY',style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),)),
                  SizedBox(height: SizeConfig.screenHeight * 0.03,),
                  Center(
                    child: Container(
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 5.0,
                            color: Colors.black26,
                            offset: Offset(1.5, 1.5),
                          )
                        ],
                      ),
                      padding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.25,
                      vertical: SizeConfig.screenHeight * 0.03
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 5.0,
                                  color: Colors.black26,
                                  offset: Offset(1.5, 1.5),
                                )
                              ],
                              shape: BoxShape.circle
                            ),
                            child: Icon(Icons.person,size: 70, color: Colors.grey.shade600,),// You can add a profile image asset here
                          ),
                          SizedBox(height: SizeConfig.screenHeight * 0.013),
                          Text(
                            state.document!['username'],
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: SizeConfig.screenHeight * 0.005),
                          Text(
                            state.document!['email'], // Display email or other user info if available
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: SizeConfig.screenHeight * 0.04,),
                  Text('Rüyalar sana nasıl hissettiriyor?',style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                  ),),

                  EmojiGraphic(),

                  SizedBox(height: SizeConfig.screenHeight * 0.01),
                  _buildProfileOption(context, 'Pin Kilidi', Icons.lock_outline),
                  _buildProfileOption(context, 'Hatırlatıcı', Icons.notifications_outlined,
                    onTapCallback: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ReminderScreen()));
                    }
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.01,),
                  Center(
                    child: CustomButton(
                      onTap: () async {
                        await FirebaseAuth.instance.signOut().then((value) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AuthCheck()),
                          );
                        });
                      },
                      text:'Çıkış Yap',
                      buttonColor: Colors.red.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        }else{
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildProfileOption(BuildContext context, String title, IconData icon,
      {VoidCallback? onTapCallback}
      ) {
    return BlocBuilder<FirestoreBloc, FirestoreState>(
      builder: (context,state) {
        return Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 0),
              leading: Icon(icon,),
              title: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              trailing: title == 'Pin Kilidi'?
                  state.document!['pin code'] == null?
              CustomButton(
                  onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>PinScreen()));
                  },
                  text: 'Kilitle'):
                  CustomButton(
                      onTap: (){
                        user.User newUser = user.User(
                          username: AuthInfo.user.username,
                          email: AuthInfo.user.email,
                          password: AuthInfo.user.password,
                          token: AuthInfo.user.token,
                          pinCode: null,
                        );
                        context.read<FirestoreBloc>().add(UpdateDataInFirestore(
                            id: FirebaseAuth.instance.currentUser!.uid,
                            collection: 'users', data: newUser
                        ));
                        SnackbarHelper.showSnackbar(context, 'Pin kilidi kaldırıldı.');
                      },
                      text: 'Kilidi Kaldır',
                  )
                  :Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              onTap: onTapCallback??(){},
            ),
            Divider(height: 10,),
          ],
        );
      }
    );
  }
}
