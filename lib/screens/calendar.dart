
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream_diary/app/bloc/app_event.dart';
import 'package:dream_diary/auth/auth_info.dart';
import 'package:dream_diary/screens/add_dream.dart';
import 'package:dream_diary/utility/emojis.dart';
import 'package:dream_diary/utility/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../app/bloc/app_bloc.dart';
import '../app/bloc/app_state.dart';
import '../db/firestore/bloc/firestore_bloc.dart';
import '../db/firestore/bloc/firestore_event.dart';
import '../db/firestore/bloc/firestore_state.dart';
import '../dream_comment/bloc/dream_comment_bloc.dart';
import '../dream_comment/bloc/dream_comment_event.dart';
import '../dream_comment/view/dream_comment_view.dart';
import '../models/dream_model.dart';
class Calendar extends StatelessWidget {
  const Calendar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FirestoreBloc, FirestoreState>(builder: (context,stateFirestore){
      QuerySnapshot? querySnapshot = stateFirestore.querySnapshot;
        return BlocBuilder<AppBloc, AppState>(builder: (context,state){
            return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TableCalendar(firstDay: DateTime.utc(2023, 1, 1),
                        lastDay: DateTime.utc(DateTime.now().year, 12,31),
                        focusedDay: state.focusedDay,
                        selectedDayPredicate: (day) => isSameDay(day, state.selectedDay),
                        onDaySelected: (selectedDay, focusedDay) {
                          context.read<AppBloc>().add(UpdateSelectedDay(selectedDay));
                          context.read<AppBloc>().add(UpdateFocusedDay(focusedDay));
                        },
                        locale: 'tr_TR',
                      calendarStyle: CalendarStyle(
                        todayDecoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(10),
                          shape: BoxShape.rectangle
                        ),
                        selectedDecoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10),
                            shape: BoxShape.rectangle
                        ),
                        defaultTextStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600
                        )
                      ),
                        headerStyle: HeaderStyle(
                          formatButtonVisible: false
                        ),
                        calendarFormat: CalendarFormat.twoWeeks,
                    ),
                    for(var doc in querySnapshot!.docs)...[
                      if(doc['user id'] == FirebaseAuth.instance.currentUser!.uid
                      && DateFormat('dd.MM.yyyy').format(state.selectedDay) == DateFormat('dd.MM.yyyy').format(doc['time'].toDate())
                      )...[
                        SizedBox(height: SizeConfig.screenHeight * 0.015,),
                        GestureDetector(
                          onTap: (){
                            Dream newDream = Dream(
                                userId: doc['user id'],
                                time: doc['time'].toDate(),
                              title: doc['title'],
                              description: doc['description'],
                              emoji: doc['emoji'],
                              comment: doc['comment']
                            );
                            for(int i = 0; i < emojis.length; i++){
                             if(emojis[i]==doc['emoji']){
                               context.read<AppBloc>().add(UpdateSelectedEmojiIndex(i));
                             }
                            }
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>AddDream(
                              dreamId: doc.id,
                              dream: newDream,
                            )));
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.red.shade100,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 5.0,
                                    color: Colors.black54,
                                    offset: Offset(1.5, 1.5),
                                  ),
                                ]
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.calendar_month_outlined,size: 30,),
                                      SizedBox(width: SizeConfig.screenWidth * 0.02,),
                                      Text(DateFormat('d MMMM yyyy', 'tr_TR').format(doc['time'].toDate()),style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold
                                      ),),
                                    ],
                                  ),
                                  SizedBox(height: SizeConfig.screenHeight * 0.01,),
                                  Row(
                                    children: [
                                      Text(doc['emoji'],style: TextStyle(
                                        fontSize: 30,
                                      ),),
                                      SizedBox(width: SizeConfig.screenWidth * 0.02,),
                                      Text(doc['title'],style: TextStyle(
                                        fontSize: 16,fontWeight: FontWeight.bold
                                      ),),
                                    ],
                                  ),
                                  SizedBox(height: SizeConfig.screenHeight * 0.01,),
                                  Text(doc['description'],style: TextStyle(
                                      fontSize: 14
                                  ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: SizeConfig.screenHeight * 0.01,),
                                  if(doc['comment'] == null)...[
                                    Align(
                                      alignment: Alignment.center,
                                      child: GestureDetector(
                                        onTap: (){
                                          Dream dream = Dream(
                                              userId: doc['user id'],
                                              title: doc['title'],
                                              description: doc['description'],
                                              emoji: doc['emoji'],
                                              time: doc['time'].toDate(),
                                            comment: null,
                                          );

                                          context.read<DreamCommentBloc>().add(DreamCommentNewEvent(dream: dream,
                                              user: AuthInfo.user));
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>DreamCommentView(dream: dream,
                                            dreamId: doc.id,
                                          )));
                                        },
                                        child: Text('Yorumlat',style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.deepOrange
                                        ),),
                                      ),
                                    ),
                                  ]else...[
                                    Align(
                                      alignment: Alignment.center,
                                      child: GestureDetector(
                                        onTap: (){
                                          Dream dream = Dream(
                                              userId: doc['user id'],
                                              title: doc['title'],
                                              description: doc['description'],
                                              emoji: doc['emoji'],
                                              time: doc['time'].toDate(),
                                            comment: doc['comment']
                                          );
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>DreamCommentView(dream: dream,
                                            dreamId: doc.id,
                                          )));
                                        },
                                        child: Text('Yorumu gör',style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.deepOrange
                                        ),),
                                      ),
                                    ),
                                  ]
                                ],
                              ),
                            ),
                          ),
                        )
                      ]
                    ]
                  ],
                ),
              ),
            );
          }
        );
      }
    );
  }
}
