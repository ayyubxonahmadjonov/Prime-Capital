part of 'dashboard_help_bloc.dart';


abstract class DashboardHelpState {}

final class DashboardHelpInitial extends DashboardHelpState {}

final class DashboardHelpLoading extends DashboardHelpState {}

final class DashboardHelpSuccess extends DashboardHelpState {
  final ContactModel contact;

  DashboardHelpSuccess({required this.contact});
}

final class DashboardHelpError extends DashboardHelpState {
  final String error;

  DashboardHelpError({required this.error});
}
