import 'package:dream_diary/app/app_view.dart';
import 'package:dream_diary/models/user_model.dart';
import 'package:dream_diary/register/bloc/register_bloc.dart';
import 'package:dream_diary/register/bloc/register_event.dart';
import 'package:dream_diary/register/bloc/register_state.dart';
import 'package:dream_diary/register/view/register_textfield.dart';
import 'package:dream_diary/utility/app_colors.dart';
import 'package:dream_diary/utility/size_config.dart';
import 'package:dream_diary/view/error_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordAgainController = TextEditingController();
  String _usernameError = '';
  String _emailError = '';
  String _passwordError = '';
  String _passwordAgainError = '';
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
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
                        SizedBox(height: SizeConfig.screenHeight * 0.2,),
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
                                  RegisterTextField(controller: _usernameController, hintText: 'Kullanıcı Adı',),
                                  if(_usernameError.isNotEmpty)ErrorView(error: _usernameError),
                                  RegisterTextField(controller: _emailController, hintText: 'E-Posta',),
                                  if(_emailError.isNotEmpty)ErrorView(error: _emailError),
                                  RegisterTextField(controller: _passwordController, hintText: 'Şifre',
                                    keyboardType: TextInputType.visiblePassword,
                                    obscureText: true,
                                  ),
                                  if(_passwordError.isNotEmpty)ErrorView(error: _passwordError),
                                  RegisterTextField(controller: _passwordAgainController,
                                    hintText: 'Şifre Tekrar',
                                    keyboardType: TextInputType.visiblePassword,
                                    obscureText: true,
                                  ),
                                  if(_passwordAgainError.isNotEmpty)ErrorView(error: _passwordAgainError),
                                  SizedBox(height: SizeConfig.screenHeight * 0.015,),
                                  ElevatedButton(
                                      onPressed: (){
                                        if(_usernameController.text.isEmpty){
                                          setState(() {
                                            _usernameError = 'Bu alan zorunludur';
                                          });
                                        }
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
                                        if(_passwordController.text.isEmpty){
                                          setState(() {
                                            _passwordError = 'Bu alan zorunludur';
                                          });
                                        }
                                        if(
                                        _usernameController.text.trim().isNotEmpty&&
                                            _emailController.text.trim().isNotEmpty&&
                                            _passwordController.text.trim().isNotEmpty&&
                                            _passwordAgainController.text.trim().isNotEmpty
                                        ){
                                          if(_passwordController.text.trim() != _passwordAgainController.text.trim()){
                                            setState(() {
                                              _passwordAgainError = 'Şifreler eşleşmiyor';
                                            });
                                          }else{
                                            User newUser = User(
                                                username: _usernameController.text.trim(),
                                                email: _emailController.text.trim(),
                                                password: _passwordController.text.trim(),
                                                token: 'token',
                                              pinCode: null,
                                              notificationsEnabled: false,
                                            );
                                            context.read<RegisterBloc>().add(NewRegisterEvent(user: newUser));
                                            if(state is RegisterSuccessfulState){
                                              Navigator.push(context, MaterialPageRoute(builder: (context)=>AppView()));
                                            }
                                          }
                                        }
                                      },
                                      child: const Text('Kaydol')),
                                ],
                              ),
                              SizedBox(height: 10,),
                            Text(state.result),
                            ],
                          )
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Padding(padding: const EdgeInsets.all(16),
                    child: GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                        child: Icon(Icons.close, size: 30,)),
                  ),),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
