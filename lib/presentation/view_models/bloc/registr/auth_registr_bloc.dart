import '../../../../core/constants/app_imports.dart';
part 'auth_registr_event.dart';
part 'auth_registr_state.dart';

class AuthRegistrBloc extends Bloc<AuthRegistrEvent, AuthRegistrState> {
  AuthRegistrBloc() : super(AuthRegistrInitial()) {
    on<RegistrEvent>(registr);
  }

  Future<void> registr(
    RegistrEvent event,
    Emitter<AuthRegistrState> emit,
  ) async {
    emit(AuthRegistrLoading());
    try {

      final result = await ApiService.registr(
        event.name,
        event.phone_number,
        event.password,
      );
      if (result.statusCode == 200 || result.statusCode == 201) {
        emit(AuthRegistrSucces());
      } else {
        emit(AuthRegistrError(error: result.result["message"].toString()));
      }
    } catch (e) {
      emit(AuthRegistrError(error: "something went wrong $e"));
    }
  }
}
