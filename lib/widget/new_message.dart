import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_chat/bloc/chat/chat_bloc.dart';

// ignore: use_key_in_widget_constructors
class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();

  // ignore: avoid_void_async
  void _sendMessage() async {
    FocusScope.of(context).unfocus();

    if (_controller.text.isNotEmpty) {
      BlocProvider.of<ChatBloc>(context).add(SendMessage(_controller.text));
    }
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _controller,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              autofocus: true,
              enableSuggestions: true,
              decoration: const InputDecoration(hintText: 'Отправить сообщение...'),
              // Здесь можно кидать эвент в блок и стрим что пользователь печатает, не поддерживается бекендом
              onChanged: (value) {},
            ),
          ),
          IconButton(
              color: Theme.of(context).primaryColor,
              icon: const Icon(
                Icons.send,
              ),
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  _sendMessage();
                }
              })
        ],
      ),
    );
  }
}
