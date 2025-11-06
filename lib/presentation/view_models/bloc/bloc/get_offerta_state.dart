part of 'get_offerta_bloc.dart';


abstract class GetOffertaState {}

final class GetOffertaInitial extends GetOffertaState {}
class GetOffertaLoading extends GetOffertaState {}
class GetOffertaSuccess extends GetOffertaState {
  final List<OfferModel> result;
  GetOffertaSuccess({required this.result});
}
class GetOffertaError extends GetOffertaState {
  final String message;
  GetOffertaError({required this.message});
}