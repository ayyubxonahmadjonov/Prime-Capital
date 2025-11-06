import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:real_project/data/datasources/local/shared_preferences_service.dart';
import 'package:real_project/data/datasources/network/api_service.dart';

part 'verify_otp_event.dart';
part 'verify_otp_state.dart';

class VerifyOtpBloc extends Bloc<VerifyOtpEvent, VerifyOtpState> {
  VerifyOtpBloc() : super(VerifyOtpInitial()) {
    on<VerifyOtpCodeEvent>(verifyOtpCode);
  }
  Future<void> verifyOtpCode(
    VerifyOtpCodeEvent event,
    Emitter<VerifyOtpState> emit,
  ) async {
    emit(VerifyOtpLoading());
    try {
      final result = await ApiService.verify_otp(
        event.phone,
        event.otpCode,
        event.otpType,
      );

      if (result.isSuccess) {
        final refresh = result.result["tokens"]["refresh"];

        final access = result.result["tokens"]["access"];

        await SharedPreferencesHelper().setString("access", access);
        await SharedPreferencesHelper().setString("refresh", refresh);
        emit(VerifyOtpSuccess());
      } else {
        emit(VerifyOtpError(message: result.result["message"].toString()));
      }
    } catch (e) {
      emit(VerifyOtpError(message: e.toString()));
    }
  }
}
