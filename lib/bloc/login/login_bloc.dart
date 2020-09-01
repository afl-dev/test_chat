import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

// Блок логин

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial());
  String user;

// проверяем коннект к серверу
  Future<bool> checkConnect() async {
    try {
      final result = await InternetAddress.lookup('pm.tada.team');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // ignore: avoid_print
        print('Connected');
        return true;
      } else {
        // ignore: avoid_print
        print('Not connected');
        return false;
      }
    // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      // ignore: avoid_print
      print('Error checkConnect() - not connected \n $e');
      return false;
    }
  }

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is SubmitLogin) {
      yield LoginLoading();
      try {
        if (await checkConnect()) {
          user = event.user;
          yield LoginLoaded(event.user);
        } else {
          yield LoginError();
        }
        // ignore: avoid_catches_without_on_clauses
      } catch (e) {
        yield LoginError();
        throw ('Error SubmitLogin \n $e');
      }
    }
  }
}
