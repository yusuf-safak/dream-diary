import 'package:dream_diary/models/firestore_model.dart';

class Dream implements FireStoreModel{
  final String userId;
  String? title;
  String? emoji;
  String? description;
  String? comment;
  final DateTime time;

  Dream({
    required this.userId,
    this.title,
    this.description,
    this.emoji,
    this.comment,
    required this.time
  });

  factory Dream.fromJson(Map<String, dynamic> json) {
    return Dream(
      userId: json['user id'],
      title: json['title'],
      description: json['description'],
      emoji: json['emoji'],
      comment: json['comment'],
      time: json['time'],
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'user id': userId,
      'title': title,
      'description': description,
      'emoji': emoji,
      'comment':comment,
      'time': time,
    };
  }

}