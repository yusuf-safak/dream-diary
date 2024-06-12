import 'package:dream_diary/dream_comment/bloc/dream_comment_event.dart';
import 'package:dream_diary/dream_comment/bloc/dream_comment_state.dart';
import 'package:dream_diary/utility/emojis.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../utility/env.dart';
class DreamCommentBloc extends Bloc<DreamCommentEvent,DreamCommentState>{
  DreamCommentBloc():super(DreamCommentInitialState()){
    on<DreamCommentNewEvent>((event,emit)async{
      emit(DreamCommentWaitingState('Rüyanız yorumlanıyor...'));
      try{
        final apiKey = Env.get('API_KEY');
        final model = GenerativeModel(
          model: 'gemini-1.5-flash-latest',
          apiKey: apiKey!,
        );

        final prompt = '${event.user.username} adlı kullanıcı Rüya Günlüğüm uygulamasında "Nasıl hissediyorsunuz?" '
            'sorusuna${emojis.toString()} emojilerinden ${event.dream.emoji} emojisini seçerek\n'
            '${event.dream.title}\n'
            '${event.dream.description}\n'
            'yukarıdaki rüya metnini gönderdi. Bu rüyayı ${event.user.username} adlı kullanıcıya hitap ederek '
            've Rüya Günlüğüm uygulamasının bir yorumcusu gibi yorumlar mısın? '
            'Unutma, kullanıcı sorularına cevap veremez.';
        final content = [Content.text(prompt)];
        final response = await model.generateContent(content);
        if(response.text != null) {
          emit(DreamCommentLoadedState(response.text!));
        }
      }catch(e){
        emit(DreamCommentFailureState('Rüyanız yorumlanırken bir hata oluştu. Lütfen tekrar deneyiniz'));
      }
    });
  }
}