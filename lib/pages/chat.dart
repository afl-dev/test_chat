import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_chat/bloc/chat/chat_bloc.dart';
import 'package:test_chat/widget/message_bubble.dart';
import 'package:test_chat/widget/new_message.dart';

class ChatPage extends StatefulWidget {
  ChatPage({Key key, @required this.user}) : super(key: key);

  final String user;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final list = <Widget>[];
  final listLog = <dynamic>[];
  ScrollController _scrollController;
  PageController _controller;
  ChatBloc chatBloc;

  @override
  void initState() {
    _scrollController = ScrollController();
    _controller = PageController(initialPage: 0);
    chatBloc = BlocProvider.of<ChatBloc>(context);
    super.initState();
  }

  void animateToEndMessage() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    chatBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocConsumer<ChatBloc, ChatState>(listener: (context, state) {
        if (state is UpdateDataState) {
          if (state.chatData != null) {
            listLog.add(state.chatData);
            list.add(MessageBubble(
              created: state.chatData['created'],
              name: state.chatData['name'] ?? 'бот',
              text: state.chatData['text'],
              isMe: state.chatData['name'] == widget?.user,
              key: ValueKey(list.length),
            ));
            Future.delayed(const Duration(milliseconds: 50)).then((value) {
              if (_controller.page == 0) {
                animateToEndMessage();
              }
            });
          }
        }
        if (state is ConnectedOnDoneState) {
          // Если соединение потеряно, показывает снекбар, реконнект через  milliseconds: 2500
          const snackBar =  SnackBar(
              backgroundColor: Colors.red,
              content: Text('Соединение потеряно... try'));
          Scaffold.of(context).showSnackBar(snackBar);
          Future.delayed(const Duration(milliseconds: 2500)).then(
              (value) async => chatBloc.add(TryConnect()));
        }
      }, builder: (context, state) {
        if (state is Loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is ErrorConnectSocket){
          return Center(
            child: Card(
              child: Column(
                children: [
                  RaisedButton(
                    child: Text('${state.error}'),
                    onPressed: () async => chatBloc.add(TryConnect()),
                  ),
                ],
              ),
            ),
          );
        }
        return PageView(controller: _controller, children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Column(
              children: [
                Expanded(
                  flex: 12,
                  child: ListView(
                    controller: _scrollController,
                    children: <Widget>[
                      if (list.isEmpty)
                        const Center(child: Text('Сообщения не найдены')),
                      ...list,
                      // NewMessage(),
                    ],
                  ),
                ),
                Expanded(flex: 2, child: NewMessage()),
              ],
            ),
          ),
          ListView(
            children: [
              Text('${[...listLog]}')
            ],
          )
        ]);
      }),
    );
  }
}
