import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:real_project/data/datasources/network/api_service.dart';
import 'package:real_project/faq_model.dart';

part 'get_questions_event.dart';
part 'get_questions_state.dart';

class GetQuestionsBloc extends Bloc<GetQuestionsEvent, GetQuestionsState> {
  GetQuestionsBloc() : super(GetQuestionsInitial()) {
    on<GetAllQuestionsForUserEvent>(getAllQuestionsForUser);
  }
  Future<void> getAllQuestionsForUser(
GetAllQuestionsForUserEvent event,
Emitter<GetQuestionsState> emit,

  ) async {
    emit(GetQuestionsLoading());
    try {
      final result = await ApiService.getAllQuestions();
      
      if (result.isSuccess) {
                final questions = (result.result as List)
            .map((json) => FaqModel.fromJson(json))
            .toList();

        emit(GetQuestionsSuccess(questions: questions));
      } else {
        emit(GetQuestionsError(message: result.result.toString()));
      }
    } catch (e) {
      emit(GetQuestionsError(message: e.toString()));
    }
  }
}
