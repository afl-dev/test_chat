part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginLoaded extends LoginState {
  LoginLoaded(this.user) : assert(user != null);

  final String user;

  @override
  List<Object> get props => [user];
}

class LoginError extends LoginState {}
