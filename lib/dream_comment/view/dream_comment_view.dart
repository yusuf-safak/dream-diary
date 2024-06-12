import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream_diary/app/app_view.dart';
import 'package:dream_diary/auth/auth_info.dart';
import 'package:dream_diary/db/firestore/bloc/firestore_state.dart';
import 'package:dream_diary/dream_comment/bloc/dream_comment_bloc.dart';
import 'package:dream_diary/dream_comment/bloc/dream_comment_state.dart';
import 'package:dream_diary/models/dream_model.dart';
import 'package:dream_diary/utility/size_config.dart';
import 'package:dream_diary/view/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/bloc/app_bloc.dart';
import '../../app/bloc/app_event.dart';
import '../../db/firestore/bloc/firestore_bloc.dart';
import '../../db/firestore/bloc/firestore_event.dart';
import '../../view/custom_button.dart';
import '../bloc/dream_comment_event.dart';
class DreamCommentView extends StatelessWidget {
  Dream? dream;
  String? dreamId;
  DreamCommentView({super.key, this.dream, this.dreamId});

  @override
  Widget build(BuildContext context) {
    return BlocListener<FirestoreBloc,FirestoreState>(
      listener: (context,state){
        if(state is FirestoreSuccessfulState){
          context.read<FirestoreBloc>().add(
              FetchQuerySnapshot(collection: 'dreams'));
        }
      },
      child:BlocBuilder<DreamCommentBloc,DreamCommentState>(builder:(context, state){
          return Scaffold(
            appBar: CustomAppBar(context: context,
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if(dream != null && state is DreamCommentLoadedState && dream!.comment == null)...[
                        Text(state.comment,textAlign: TextAlign.center,),
                        SizedBox(height: SizeConfig.screenHeight * 0.01,),
                        CustomButton(onTap: (){
                          Dream newDream = Dream(
                              userId: dream!.userId,
                              title: dream!.title,
                              time: dream!.time,
                              description: dream!.description,
                              emoji: dream!.emoji,
                              comment: state.comment
                          );
                          if(dreamId == null) {
                            context.read<FirestoreBloc>().add(AddToFirestore(collection: 'dreams', data: newDream));
                          }else{
                            context.read<FirestoreBloc>().add(UpdateDataInFirestore(collection: 'dreams', data: newDream, id: dreamId!));
                          }
                          Future.delayed(Duration(seconds: 1),(){
                            context.read<AppBloc>().add(UpdatePageIndex(0));
                            Navigator.pop(context);
                          });
                        },
                            text: 'Yorumu Kaydet',
                          buttonColor: Colors.green,
                        ),]
                      else if(dream!.comment != null)...[
                        Text(dream!.comment!,textAlign: TextAlign.center,),
                        SizedBox(height: SizeConfig.screenHeight * 0.01,),
                        CustomButton(onTap: (){
                          Dream newDream = Dream(
                              userId: dream!.userId,
                              title: dream!.title,
                              time: dream!.time,
                              description: dream!.description,
                              emoji: dream!.emoji,
                              comment: null
                          );
                          context.read<FirestoreBloc>().add(FetchDocument(collection: 'users', id: dream!.userId));
                          context.read<DreamCommentBloc>().add(DreamCommentNewEvent(dream: newDream,
                              user: AuthInfo.user));
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>DreamCommentView(dream: newDream, dreamId: dreamId,)));
                        },
                            text: 'Yeniden Yorumlat',
                          buttonColor: Colors.deepOrange,
                        ),
                      ]
                      else...[
                        SizedBox(height: SizeConfig.screenHeight * 0.32,),
                        Center(child: Text(state.comment,textAlign: TextAlign.center,)),
                      ]
                    ],
                  ),
                ),
              ),
            ),
          );
        })
    );
  }
}
