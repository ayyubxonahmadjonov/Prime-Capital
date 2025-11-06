import 'package:bloc/bloc.dart';
import 'package:real_project/data/datasources/network/api_service.dart';
import 'package:real_project/data/models/income_list_model.dart';

part 'get_income_list_event.dart';
part 'get_income_list_state.dart';

class GetIncomeListBloc extends Bloc<GetIncomeListEvent, GetIncomeListState> {
  GetIncomeListBloc() : super(GetIncomeListInitial()) {
    on<GetIncomeEvent>(getIncomeList);
  }
  Future<void> getIncomeList(
    GetIncomeEvent event,
    Emitter<GetIncomeListState> emit,
  ) async {
    try {
      emit(GetIncomeListLoading());
      final result = await ApiService.getIncomeList();
      if (result.isSuccess) {
        final incomeList =
            (result.result as List)
                .map((e) => IncomeModel.fromJson(e))
                .toList();

        emit(GetIncomeListSuccess(incomeList: incomeList));
      } else {
        emit(GetIncomeListError(message: result.result["message"].toString()));
      }
    } catch (e) {
      print(e);
    }
  }
}
