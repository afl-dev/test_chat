import 'package:bloc_test/bloc_test.dart';
import 'package:test/test.dart';
import 'package:test_chat/bloc/chat/chat_bloc.dart';
import 'package:test_chat/bloc/login/login_bloc.dart';

class MockLoginBloc extends MockBloc implements LoginBloc {}

ChatBloc chatBloc;

void main() {
  test();
}

void test() {
  setUp(() {
    chatBloc = ChatBloc(user: 'SSS');
  });

  group('ChatBloc', () {

    blocTest(
      'TestChat',
      build: () => chatBloc,
      act: (bloc) async => bloc.add(TryConnect()),
      expect: [
        isA<Loading>(),
        isA<Loaded>(),
      ],
    );
    blocTest(
      'TestSendMessage',
      build: () => chatBloc,
      act: (bloc) async => bloc..add(TryConnect())..add(SendMessage('ddd')),
      expect: [
        // Если без Equatable
        isA<Loading>(),
        isA<Loaded>(),
        isA<MessageSent>(),
      ],
    );
  });
}
