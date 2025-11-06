// get_profile_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_imports.dart';

part 'get_profile_event.dart';
part 'get_profile_state.dart';

class GetProfileBloc extends Bloc<GetProfileEvent, GetProfileState> {
  GetProfileBloc() : super(GetProfileInitial()) {
    on<GetProfileDetailsEvent>(_onGetProfile);
  }

  Future<void> _onGetProfile(
    GetProfileDetailsEvent event,
    Emitter<GetProfileState> emit,
  ) async {
    emit(GetProfileLoading());

    try {
      final result = await ApiService.getProfile();

      if (result.statusCode == 200 && result.isSuccess) {
        final user = UserModel.fromJson(result.result as Map<String, dynamic>);

        String formattedDate;
        double invest = 0.0;
        double capital = 0.0;

        if (user.balanceHistory.isNotEmpty) {
          final lastHistory = user.balanceHistory.last;
          final ts = lastHistory.ts;
          formattedDate = "${ts.year}-${ts.month.toString().padLeft(2, '0')}";
          invest = lastHistory.newInvest;
          capital = lastHistory.newReit;
        } 
      
        else {
          final now = DateTime.now();
          formattedDate = "${now.year}-${now.month.toString().padLeft(2, '0')}";
          invest = 0.0;
          capital = 0.0;
        }

        await HiveBoxes.monthly_invests.put(formattedDate, invest);
        await HiveBoxes.monthly_capitals.put(formattedDate, capital);


        emit(GetProfileSuccess(user: user));
      } else if (result.statusCode == 401) {
        emit(GetProfileError(error: "Sessiya tugadi. Iltimos, qayta kiring."));
      } else {
        final message = result.result["message"]?.toString() ?? "Server xatosi";
        emit(GetProfileError(error: message));
      }
    } catch (e) {
      emit(GetProfileError(error: "Xato: $e"));
    }
  }
}