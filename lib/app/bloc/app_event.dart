import 'package:equatable/equatable.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object?> get props => [];
}

class UpdatePageIndex extends AppEvent {
  final int pageIndex;

  const UpdatePageIndex(this.pageIndex);

  @override
  List<Object?> get props => [pageIndex];
}

class UpdateFocusedDay extends AppEvent {
  final DateTime focusedDay;

  const UpdateFocusedDay(this.focusedDay);

  @override
  List<Object?> get props => [focusedDay];
}
class UpdateSelectedDay extends AppEvent {
  final DateTime selectedDay;

  const UpdateSelectedDay(this.selectedDay);

  @override
  List<Object?> get props => [selectedDay];
}
class UpdateSelectedEmojiIndex extends AppEvent {
  final int selectedEmojiIndex;

  const UpdateSelectedEmojiIndex(this.selectedEmojiIndex);

  @override
  List<Object?> get props => [selectedEmojiIndex];
}
class UpdateIsShowCalendar extends AppEvent {
  final bool isShowCalendar;

  const UpdateIsShowCalendar(this.isShowCalendar);

  @override
  List<Object?> get props => [isShowCalendar];
}
