import 'package:bloc/bloc.dart';
import 'package:real_project/cotact_model.dart';
import 'package:real_project/data/datasources/network/api_service.dart';

part 'dashboard_help_event.dart';
part 'dashboard_help_state.dart';

class DashboardHelpBloc extends Bloc<DashboardHelpEvent, DashboardHelpState> {
  DashboardHelpBloc() : super(DashboardHelpInitial()) {
    on<DashboardHelpForUserEvent>(dashboardHelpForUser);
  }

  Future<void> dashboardHelpForUser(
    DashboardHelpForUserEvent event,
    Emitter<DashboardHelpState> emit,
  ) async {
    emit(DashboardHelpLoading());
    try {
      final result = await ApiService.dashboardHelp();
print('resques sent to dashboard help');
      print(result.statusCode);
      print(result.result);
      if (result.isSuccess) {
        emit(DashboardHelpSuccess(contact: ContactModel.fromJson(result.result)));
      } else {
        emit(DashboardHelpError(error: result.result.toString()));
      }
    } catch (e) {
      emit(DashboardHelpError(error: e.toString()));
    }
  }
}
