import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:real_project/core/utils/value_notifier.dart';
import 'package:real_project/data/datasources/local/shared_preferences_service.dart';
import 'package:real_project/data/datasources/network/api_service.dart';

part 'create_income_event.dart';
part 'create_income_state.dart';

class CreateIncomeBloc extends Bloc<CreateIncomeEvent, CreateIncomeState> {
  CreateIncomeBloc() : super(CreateIncomeInitial()) {
    on<CreateNewIncomeEvent>(createNewIncome);
  }
  Future<void> createNewIncome(
    CreateNewIncomeEvent event,
    Emitter<CreateIncomeState> emit,
  ) async {
    emit(CreateIncomeLoading());
    try {
      final result = await ApiService.createIncome(
        event.amount,
        event.date,
        event.category,
      );

      if (result.isSuccess) {
final now = DateTime.now();
final key = 'total_income_${now.year}_${now.month}';

double oldIncome = SharedPreferencesHelper().getDouble(key) ?? 0.0;


double newIncome = oldIncome + num.parse(event.amount);

await SharedPreferencesHelper().setDouble(key, newIncome);

incomeNotifier.value = newIncome;

        emit(CreateIncomeSuccess());
      } else {
        emit(CreateIncomeError(message: result.result["message"].toString()));
      }
    } catch (e) {}
  }
}
