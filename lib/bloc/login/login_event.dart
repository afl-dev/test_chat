part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class SubmitLogin extends LoginEvent {
  SubmitLogin(this.user) : assert(user != null);

  final String user;
}
