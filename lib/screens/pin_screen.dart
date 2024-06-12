import 'package:dream_diary/app/app_view.dart';
import 'package:dream_diary/auth/auth_info.dart';
import 'package:dream_diary/db/firestore/bloc/firestore_bloc.dart';
import 'package:dream_diary/db/firestore/bloc/firestore_event.dart';
import 'package:dream_diary/db/firestore/bloc/firestore_state.dart';
import 'package:dream_diary/models/user_model.dart' as user;
import 'package:dream_diary/utility/app_colors.dart';
import 'package:dream_diary/utility/size_config.dart';
import 'package:dream_diary/utility/snackbar_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PinScreen extends StatefulWidget {
  @override
  _PinScreenState createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  List<String> _pin = [];

  void _pinControl(String userPinCode) {
    if(userPinCode.isNotEmpty) {
      if (_pin.join() == userPinCode) {
      user.User newUser = user.User(email: AuthInfo.user.email,
          password: AuthInfo.user.password,
        token: AuthInfo.user.token,
        username: AuthInfo.user.username,
        pinCode: AuthInfo.user.pinCode,
        pinScreenStatus: 'close'
      );
      AuthInfo.userUpdate(newUser);
      Navigator.push(context, MaterialPageRoute(builder: (context)=>AppView()));
    } else {
      SnackbarHelper.showSnackbar(context, 'Pin kodu hatalı!');
    }
    }else{
      user.User newUser = user.User(email: AuthInfo.user.email,
          password: AuthInfo.user.password,
          token: AuthInfo.user.token,
          username: AuthInfo.user.username,
          pinCode: _pin.join(),
          pinScreenStatus: 'close'
      );
      context.read<FirestoreBloc>().add(UpdateDataInFirestore(
          id: FirebaseAuth.instance.currentUser!.uid,
          collection: 'users', data: newUser));
      AuthInfo.userUpdate(newUser);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AppView()));
      SnackbarHelper.showSnackbar(context, 'Pin kilidi oluşturuldu.', backgroundColor: Colors.green);
    }
    setState(() {
      _pin.clear();
    });
  }

  void _addNumber(String rakam, String userPinCode) {
    setState(() {
      if (_pin.length < 4) {
        _pin.add(rakam);
      }
      if (_pin.length == 4) {
        _pinControl(userPinCode);
      }
    });
  }

  void _removeLastNumber() {
    setState(() {
      if (_pin.isNotEmpty) {
        _pin.removeLast();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FirestoreBloc,FirestoreState>(
      builder: (context,state) {
        return Scaffold(
          backgroundColor: backgroundColor,
          body: Scaffold(
            backgroundColor: softBackgroundColor,
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(child: Text('DREAM DIARY',style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),)),
                  SizedBox(height: SizeConfig.screenHeight * 0.05,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (index) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 8.0),
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Center(
                          child: Text(
                            _pin.length > index ? _pin[index] : '',
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 20),
                  GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: 12,
                    itemBuilder: (context, index) {
                      if (index < 9) {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.red.shade700,
                              backgroundColor: Colors.grey.shade400
                          ),
                          onPressed: () => _addNumber((index + 1).toString(),state.document!['pin code']??''),
                          child: Text(
                            (index + 1).toString(),
                            style: TextStyle(fontSize: 24),
                          ),
                        );
                      } else if (index == 9) {
                        return SizedBox.shrink();
                      } else if (index == 10) {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.red.shade700,
                              backgroundColor: Colors.grey.shade400
                          ),
                          onPressed: () => _addNumber('0',state.document!['pin code']??''),
                          child: Text(
                            '0',
                            style: TextStyle(fontSize: 24),
                          ),
                        );
                      } else {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.red.shade700,
                            backgroundColor: Colors.grey.shade400
                          ),
                          onPressed: _removeLastNumber,
                          child: Icon(Icons.backspace),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
