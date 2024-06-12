import 'package:equatable/equatable.dart';

class AppState extends Equatable {
  final int pageIndex;
  final DateTime focusedDay;
  final DateTime selectedDay;
  final int selectedEmojiIndex;
  final bool isShowCalendar;

  AppState({
    required this.pageIndex,
    required this.focusedDay,
    required this.selectedDay,
    required this.selectedEmojiIndex,
    required this.isShowCalendar,
  });

  AppState copyWith({
    int? pageIndex,
    DateTime? focusedDay,
    DateTime? selectedDay,
    int? selectedEmojiIndex,
    bool? isShowCalendar,
  }) {
    return AppState(
      pageIndex: pageIndex ?? this.pageIndex,
      focusedDay: focusedDay ?? this.focusedDay,
      selectedDay: selectedDay ?? this.selectedDay,
      selectedEmojiIndex: selectedEmojiIndex ?? this.selectedEmojiIndex,
      isShowCalendar: isShowCalendar ?? this.isShowCalendar,
    );
  }

  @override
  List<Object?> get props => [
    pageIndex, focusedDay,selectedDay, selectedEmojiIndex,
    isShowCalendar,
  ];
}