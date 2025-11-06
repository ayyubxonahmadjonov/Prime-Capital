import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:real_project/data/datasources/network/api_service.dart';
import 'package:real_project/data/models/category_model.dart';

part 'get_categories_event.dart';
part 'get_categories_state.dart';

class GetCategoriesBloc extends Bloc<GetCategoriesEvent, GetCategoriesState> {
  GetCategoriesBloc() : super(GetCategoriesInitial()) {
    on<GetCategoriesListEvent>(getCategoriesList);
  }
  Future<void> getCategoriesList(
    GetCategoriesListEvent event,
    Emitter<GetCategoriesState> emit,
  ) async {
    emit(GetCategoriesLoading());
    try {
      final result = await ApiService.getCategories();
      if (result.isSuccess) {
        final categories =
            (result.result as List)
                .map((e) => CategoryModel.fromJson(e))
                .toList();
        emit(GetCategoriesSuccess(categories: categories));
      } else {
        emit(GetCategoriesError(message: result.result["message"].toString()));
      }
    } catch (e) {
      print("error $e");
    }
  }
}
