import 'package:dream_diary/app/app_view.dart';
import 'package:dream_diary/login/bloc/login_event.dart';
import 'package:dream_diary/register/view/register_textfield.dart';
import 'package:dream_diary/register/view/register_view.dart';
import 'package:dream_diary/utility/app_colors.dart';
import 'package:dream_diary/utility/size_config.dart';
import 'package:dream_diary/view/error_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/user_model.dart';
import '../bloc/login_bloc.dart';
import '../bloc/login_state.dart';
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _emailError = '';
  String _passwordError = '';
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
        return Scaffold(
          backgroundColor: backgroundColor,
          body: Scaffold(
            backgroundColor: softBackgroundColor,
                body: SafeArea(
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(height: SizeConfig.screenHeight * 0.25,),
                            Center(child: Text('DREAM DIARY',style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),)),
                            SizedBox(height: SizeConfig.screenHeight * 0.03,),
                            Center(
                                child: Column(
                                  children: [
                                    Column(
                                      children: <Widget>[
                                        RegisterTextField(
                                          controller: _emailController, hintText: 'E-Posta',
                                        ),
                                        if(_emailError.isNotEmpty)ErrorView(error: _emailError),
                                        RegisterTextField(controller: _passwordController, hintText: 'Şifre',
                                          keyboardType: TextInputType.visiblePassword,
                                          obscureText: true,
                                        ),
                                        if(_passwordError.isNotEmpty)ErrorView(error: _passwordError),
                                        SizedBox(height: SizeConfig.screenHeight * 0.015,),
                                        ElevatedButton(
                                            onPressed: (){
                                              if(_emailController.text.isEmpty){
                                                setState(() {
                                                  _emailError = 'Bu alan zorunludur';
                                                });
                                              }
                                              if(_passwordController.text.isEmpty){
                                                setState(() {
                                                  _passwordError = 'Bu alan zorunludur';
                                                });
                                              }
                                              if(
                                              _emailController.text.trim().isNotEmpty&&
                                                  _passwordController.text.trim().isNotEmpty
                                              ){
                                                User newUser = User(
                                                  email: _emailController.text.trim(),
                                                  password: _passwordController.text.trim(),
                                                );
                                                context.read<LoginBloc>().add(LoginNewEvent(user: newUser));
                                                if (state is LoginSuccessfulState) {
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => AppView()));
                                                }
                                              }
                                            },
                                            child: const Text('Giriş Yap')),
                                      ],
                                    ),
                                    SizedBox(height: SizeConfig.screenHeight * 0.25,),
                                    Text(state.result),
                                    TextButton(onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterView()));
                                    },
                                        child: Text(
                                            'Hesabın yok mu? Kaydol!',
                                          style: TextStyle(
                                            color: Colors.red.shade700
                                          ),
                                        ))
                                  ],
                                )
                            )
                          ],
                        ),
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
