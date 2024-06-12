
import 'package:dream_diary/models/dream_model.dart';

import '../../models/user_model.dart';

abstract class DreamCommentEvent{
}
class DreamCommentNewEvent extends DreamCommentEvent{
  final Dream dream;
  final User user;
  DreamCommentNewEvent({
    required this.user,
    required this.dream});
}