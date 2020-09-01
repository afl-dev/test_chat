part of 'chat_bloc.dart';

abstract class ChatState {
  const ChatState();

  List<Object> get props => [];
}

class ChatInitial extends ChatState {}

class Loading extends ChatState {}

class Loaded extends ChatState {}

class UpdateDataState extends ChatState {
  UpdateDataState(this.chatData);

  final dynamic chatData;

  @override
  List<Object> get props => [chatData];
}

class ConnectedOnDoneState extends ChatState {}

class MessageSent  extends ChatState {}

class ErrorConnectSocket extends ChatState {
  ErrorConnectSocket(this.error);

  final String error;
  @override
  List<Object> get props => [error];

}
