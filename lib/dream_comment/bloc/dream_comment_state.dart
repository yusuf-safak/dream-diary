abstract class DreamCommentState{
  final String comment;
  DreamCommentState({
    required this.comment,
  });
}
class DreamCommentInitialState extends DreamCommentState{
  DreamCommentInitialState():super(comment: '');
}
class DreamCommentWaitingState extends DreamCommentState{
  DreamCommentWaitingState(String waitingComment):super(comment: waitingComment);
}
class DreamCommentLoadedState extends DreamCommentState{
  DreamCommentLoadedState(String comment):super(comment: comment);
}
class DreamCommentFailureState extends DreamCommentState{
  DreamCommentFailureState(String failureComment):super(comment: failureComment);
}