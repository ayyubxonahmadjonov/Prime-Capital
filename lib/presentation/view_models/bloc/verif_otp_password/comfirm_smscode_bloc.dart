import 'package:real_project/core/constants/app_imports.dart';

part 'comfirm_smscode_event.dart';
part 'comfirm_smscode_state.dart';

class ComfirmSmscodeBloc
    extends Bloc<ComfirmSmscodeEvent, ComfirmSmscodeState> {
  ComfirmSmscodeBloc() : super(ComfirmSmscodeInitial()) {
    on<ComfirmCodeEmailEvent>(comfirmCodeEmail);
  }
  Future<void> comfirmCodeEmail(
    ComfirmCodeEmailEvent event,
    Emitter<ComfirmSmscodeState> emit,
  ) async {
    emit(ConfirmSmsCodeLoadingState());
    try {
      print(event.phone_number);
      print(event.otp_code);
      final result = await ApiService.confirmotpforResetPassword(
        event.phone_number,
        event.otp_code,
      );

print(result.result);
      if (result.isSuccess) {
        final String resetToken = result.result["reset_token"];
        await SharedPreferencesHelper().setString("reset_token", resetToken);
        emit(ConfirmSmsCodeSuccesState());
      } else {
        emit(
          ConfirmSmsCodeErrorState(error: result.result["message"].toString()),
        );
      }
    } catch (e) {
      emit(ConfirmSmsCodeErrorState(error: "something went wrong $e"));
    }
  }
}
