import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream_diary/auth/auth_info.dart';
import 'package:dream_diary/db/firestore/bloc/firestore_bloc.dart';
import 'package:dream_diary/db/firestore/bloc/firestore_event.dart';
import 'package:dream_diary/dream_comment/bloc/dream_comment_bloc.dart';
import 'package:dream_diary/dream_comment/bloc/dream_comment_event.dart';
import 'package:dream_diary/dream_comment/view/dream_comment_view.dart';
import 'package:dream_diary/models/dream_model.dart';
import 'package:dream_diary/utility/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../app/bloc/app_bloc.dart';
import '../app/bloc/app_event.dart';
import '../utility/emojis.dart';
import '../view/custom_button.dart';
class AddDream extends StatefulWidget {
  String? dreamId;
  Dream? dream;
  AddDream({super.key,
    this.dreamId,this.dream});

  @override
  State<AddDream> createState() => _AddDreamState();
}

class _AddDreamState extends State<AddDream> {
  int selectedEmojiIndex = 2;
  DateTime selectedDay = DateTime.now();
  bool isShowCalendar = false;
  DateTime focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    if(widget.dream != null){
      selectedEmojiIndex = emojis.indexOf(widget.dream!.emoji!);
      selectedDay = widget.dream!.time;
      focusedDay = widget.dream!.time;
    }
    _titleController = widget.dream != null?
    TextEditingController(text: widget.dream!.title)
        :TextEditingController();
    _descriptionController =
    widget.dream != null?
    TextEditingController(text: widget.dream!.description)
        :TextEditingController();
  }
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.02),
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.025,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: [
                    CustomButton(
                      onTap: (){
                        context.read<AppBloc>().add(UpdatePageIndex(0));
                        if(widget.dream != null){
                          Navigator.pop(context);
                        }
                      },
                      text: 'X',
                      buttonColor: Colors.red.shade700,
                    ),
                    Spacer(),
                    if(widget.dream == null)
                      CustomButton(
                          onTap: (){
                            Dream dream = Dream(
                                userId: FirebaseAuth.instance.currentUser!.uid,
                                title: _titleController.text.trim(),
                                description: _descriptionController.text.trim(),
                                emoji: emojis[selectedEmojiIndex],
                                time: selectedDay);
                            context.read<FirestoreBloc>().add(FetchDocument(collection: 'users', id: dream.userId));
                            DocumentSnapshot? user = context.read<FirestoreBloc>().state.document;
                            if(user != null)
                              context.read<DreamCommentBloc>().add(DreamCommentNewEvent(dream: dream,
                                  user:AuthInfo.user));
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>DreamCommentView(dream: dream,)));
                          },
                          text: 'Yorumlat', buttonColor: Colors.orange,),
                    SizedBox(width: SizeConfig.screenWidth * 0.02,),
                    CustomButton(
                        onTap: (){
                          Dream newDream = Dream(
                              userId: FirebaseAuth.instance.currentUser!.uid,
                              title: _titleController.text.trim(),
                              description: _descriptionController.text.trim(),
                              emoji: emojis[selectedEmojiIndex],
                              time: selectedDay);
                          if(widget.dream == null){
                            context.read<FirestoreBloc>().add(AddToFirestore(collection: 'dreams', data: newDream));
                          }else{
                            context.read<FirestoreBloc>().add(UpdateDataInFirestore(id: widget.dreamId!,
                                collection: 'dreams', data: newDream));
                          }
                          context.read<AppBloc>().add(UpdatePageIndex(0));
                        },
                        text: widget.dream == null?'Kaydet':'Güncelle',
                        buttonColor:Colors.green
                    ),
                  ],
                ),
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.01,),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: (){
                          setState(() {
                            isShowCalendar = !isShowCalendar;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_month_outlined,size: 30,),
                              SizedBox(width: SizeConfig.screenWidth * 0.02,),
                              Text(DateFormat('d MMMM yyyy', 'tr_TR').format(selectedDay),style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold
                              ),),
                              Spacer(),
                              Icon(isShowCalendar?Icons.keyboard_arrow_up_sharp:Icons.keyboard_arrow_down_sharp,size: 30,),
                            ],
                          ),
                        ),
                      ),
                      if(isShowCalendar)...[
                        TableCalendar(firstDay: DateTime.utc(2023, 1, 1),
                          lastDay: DateTime.utc(DateTime.now().year, 12,31),
                          focusedDay: focusedDay,
                          selectedDayPredicate: (day) => isSameDay(day, selectedDay),
                          onDaySelected: (_selectedDay, _focusedDay) {
                          setState(() {
                            selectedDay = _selectedDay;
                            focusedDay = _focusedDay;
                            isShowCalendar = false;
                          });
                          },
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
                          locale: 'tr_TR',
                          headerStyle: HeaderStyle(
                              formatButtonVisible: false
                          ),
                          calendarFormat: CalendarFormat.month,
                        ),
                        SizedBox(height: 10,),
                      ],
                      SizedBox(height: SizeConfig.screenHeight * 0.01,),
                      Text('Nasıl hissediyorsunuz?',style: TextStyle(
                          fontSize: 16,fontWeight: FontWeight.bold
                      ),),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for(int i = 0; i < emojis.length; i++)...[
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.screenWidth * 0.01,
                                vertical: SizeConfig.screenHeight * 0.01,
                              ),
                              child: GestureDetector(
                                onTap: (){
                                  setState(() {
                                    selectedEmojiIndex = i;
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: selectedEmojiIndex == i?Colors.black12:Colors.transparent,
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Text(emojis[i],style: TextStyle(
                                      fontSize: selectedEmojiIndex == i?40:35
                                  ),),
                                ),
                              ),
                            )
                          ]
                        ],
                      ),
                      SizedBox(height: SizeConfig.screenHeight * 0.02,),
                      TextField(
                        controller: _titleController,
                        decoration: InputDecoration(
                            hintText: 'Rüyanıza bir başlık verin',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)
                            )
                        ),
                      ),
                      SizedBox(height: SizeConfig.screenHeight * 0.02,),
                      TextField(
                        controller: _descriptionController,
                        maxLines: 15,
                        decoration: InputDecoration(
                            hintText: 'Rüyanızı açıklayın',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)
                            )
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
