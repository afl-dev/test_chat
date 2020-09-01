import 'package:bloc_test/bloc_test.dart';
import 'package:test/test.dart';
import 'package:test_chat/bloc/login/login_bloc.dart';

class MockLoginBloc extends MockBloc implements LoginBloc {}

LoginBloc loginBloc;

void main() {
  test();
}

void test() {
  setUp(() {
    loginBloc = LoginBloc();
  });

  group('LoginBloc', () {
    const user = 'SSS';

    blocTest(
      'TestLogin',
      build: () => loginBloc,
      act: (bloc) => bloc.add(SubmitLogin('SSS')),
      expect: [
        LoginLoading(),
        LoginLoaded(user),
      ],
    );
  });
}
