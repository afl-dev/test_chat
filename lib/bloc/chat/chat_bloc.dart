import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

part 'chat_event.dart';

part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc({this.user}) : super(ChatInitial());

  WebSocketChannel channel;
  bool statusConnect;
  String user;


  // авторизация
  void tryConnect(String user) {
    try {
      channel = IOWebSocketChannel.connect('ws://pm.tada.team/ws?name=$user');
      statusConnect = true;
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      this.add(ConnectedError('Error connect WS'));
      throw (e);
    }
  }

  // добавляем листенер для стрима, получение новых данных
  void addListener() {
    channel.stream.listen((dynamic snapshot) {
      final dynamic chatData = jsonDecode(snapshot as String);
      // Получем данные отправляем эвент в свой блок
      this.add(UpdateData(chatData));
    },
        // Соединение закрыто
        onDone: () {
      statusConnect = false;
      this.add(ConnectedOnDone());
    }, onError: (e) {
      this.add(ConnectedError('Error channel.stream.listen'));
      throw ('Error channel.stream.listen \n' + e);
    });
  }

  @override
  // Эвенты преобразовываем в стейты
  Stream<ChatState> mapEventToState(
    ChatEvent event,
  ) async* {
    if (event is TryConnect) {
      yield Loading();
      try {
        tryConnect(user);
        addListener();
        yield Loaded();
      // ignore: avoid_catches_without_on_clauses
      } catch (e) {
        yield ErrorConnectSocket('Error TryConnect');
        throw ('Error TryConnect \n' + e);
      }
    }

    if (event is SendMessage) {
      try {
        // Отправка сообщения
        if (statusConnect) {
          channel.sink.add('{"text": "${event.message}"}');
          yield MessageSent();
        }
      // ignore: avoid_catches_without_on_clauses
      } catch (e) {
        throw ('Exception SendMessage \n $e');
      }
    }
    if (event is UpdateData) {
      yield UpdateDataState(event.chatData);
    }
    if (event is ConnectedOnDone) {
      yield ConnectedOnDoneState();
    }

    if (event is ConnectedError){
      yield ErrorConnectSocket(event.error);
    }
  }
}
