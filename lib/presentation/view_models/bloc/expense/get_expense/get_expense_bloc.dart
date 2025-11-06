import 'package:bloc/bloc.dart';
import 'package:real_project/data/datasources/network/api_service.dart';
import 'package:real_project/data/models/expense_list_model.dart';

part 'get_expense_event.dart';
part 'get_expense_state.dart';

class GetExpenseBloc extends Bloc<GetExpenseEvent, GetExpenseState> {
  GetExpenseBloc() : super(GetExpenseInitial()) {
    on<GetExpenseListEvent>(getExpenseList);
  }
  Future<void> getExpenseList(
    GetExpenseListEvent event,
    Emitter<GetExpenseState> emit,
  ) async {
    emit(GetExpenseLoading());
    try {
      final result = await ApiService.getExpenseList();
      if (result.isSuccess) {
        final expenseList =
            (result.result as List)
                .map((e) => ExpenseModel.fromJson(e))
                .toList();
        emit(GetExpenseSuccessState(expenseList: expenseList));
      } else {
        emit(
          GetExpenseErrorState(message: result.result["message"].toString()),
        );
      }
    } catch (e) {
      print(e);
    }
  }
}
