part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class SendMessage extends ChatEvent {
  SendMessage(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class UpdateData extends ChatEvent {
  UpdateData(this.chatData);

  final dynamic chatData;

  @override
  List<Object> get props => [chatData];
}

class TryConnect extends ChatEvent {}

class ConnectedOnDone extends ChatEvent {}

class ConnectedError extends ChatEvent {
  ConnectedError(this.error);

  final String error;
}
