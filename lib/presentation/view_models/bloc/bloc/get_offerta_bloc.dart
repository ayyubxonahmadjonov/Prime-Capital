import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:real_project/data/datasources/network/api_service.dart';
import 'package:real_project/offerta_model.dart';

part 'get_offerta_event.dart';
part 'get_offerta_state.dart';

class GetOffertaBloc extends Bloc<GetOffertaEvent, GetOffertaState> {
  GetOffertaBloc() : super(GetOffertaInitial()) {
    on<GetOffertaForUserEvent>(getOffertaForUser);
  }
  Future<void> getOffertaForUser(GetOffertaForUserEvent event, Emitter<GetOffertaState> emit) async {
    emit(GetOffertaLoading());
    try {
      final result = await ApiService.getOfferta();
      print(result.statusCode);
      print(result.result);
      if (result.isSuccess) {
         // JSON ro'yxatini OfferModel ro'yxatiga parse qilish
        final List<OfferModel> offers = (result.result as List)
            .map((json) => OfferModel.fromJson(json))
            .toList();
        emit(GetOffertaSuccess(result: offers));
      } else {
        emit(GetOffertaError(message: result.result["message"].toString()));
      }
    } catch (e) {
      emit(GetOffertaError(message: e.toString()));
    }
  }

  
}
