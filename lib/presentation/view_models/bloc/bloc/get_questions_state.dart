part of 'get_questions_bloc.dart';


abstract class GetQuestionsState {}

 class GetQuestionsInitial extends GetQuestionsState {}
class GetQuestionsLoading extends GetQuestionsState {}
class GetQuestionsSuccess extends GetQuestionsState {
  final List<FaqModel> questions;
  GetQuestionsSuccess({required this.questions});
}
class GetQuestionsError extends GetQuestionsState {
  final String message;
  GetQuestionsError({required this.message});
}