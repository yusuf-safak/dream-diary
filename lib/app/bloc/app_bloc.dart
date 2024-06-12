import 'package:bloc/bloc.dart';
import 'app_event.dart';
import 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(AppState(pageIndex: 1,
      focusedDay: DateTime.now(),
    selectedDay: DateTime.now(),
    selectedEmojiIndex: 2,
    isShowCalendar: false,
  )) {
    on<UpdatePageIndex>((event, emit) {
      emit(state.copyWith(pageIndex: event.pageIndex));
    });

    on<UpdateFocusedDay>((event, emit) {
      emit(state.copyWith(focusedDay: event.focusedDay));
    });

    on<UpdateSelectedDay>((event, emit) {
      emit(state.copyWith(selectedDay: event.selectedDay));
    });

    on<UpdateSelectedEmojiIndex>((event, emit) {
      emit(state.copyWith(selectedEmojiIndex: event.selectedEmojiIndex));
    });

    on<UpdateIsShowCalendar>((event, emit) {
      emit(state.copyWith(isShowCalendar: event.isShowCalendar));
    });

  }
}
