import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vetpet/api/chat.dart';
import 'package:vetpet/common/utils.dart';
import 'package:vetpet/types.dart';

class ChatLayout extends StatefulWidget {
  const ChatLayout({super.key, required this.current, required this.other});
  final User current;
  final User other;

  @override
  State<ChatLayout> createState() => _ChatLayoutState();
}

class _ChatLayoutState extends State<ChatLayout> {
  late ChatApi chatApi;
  late Timer messageReciever;

  late FocusNode focusNode;

  @override
  void initState() {
    chatApi = ChatApi(widget.other);
    messageReciever = Timer.periodic(const Duration(seconds: 1), (timer) async {
      final newMessages = await chatApi.messageRequest();
      if (newMessages != null && mounted) {
        setState(() {
          messages.insertAll(0, newMessages);
        });
      }
    });
    focusNode = FocusNode();
    focusNode.requestFocus();
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    messageReciever.cancel();
    super.dispose();
  }

  List<Message> messages = [];

  final _typedMessage = TextEditingController();
  final _scrollController = ScrollController();

  void sendMessage() async {
    if (_typedMessage.text.isNotEmpty) {
      var message = chatApi.sendMessage(_typedMessage.text.trim());
      setState(() {
        _typedMessage.text = '';
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      });
      message.then((value) {
        if (!value['success'] && mounted) {
          Utils.showSnackbar(context, "Error sending message");
        }
      });
      focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.other.name),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ListView(
              controller: _scrollController,
              reverse: true,
              children: messages
                  .map<Widget>((e) => MessageContainer(message: e))
                  .toList()
                ..insert(0, const SizedBox(height: 70)),
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints.loose(
              const Size(double.infinity, 200),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 5, 5),
              child: Row(
                children: [
                  Flexible(
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
                        child: TextField(
                          focusNode: focusNode,
                          controller: _typedMessage,
                          maxLines: null,
                          textInputAction: TextInputAction.send,
                          decoration: const InputDecoration.collapsed(
                            hintText: 'Type message',
                          ),
                          onSubmitted: (value) => sendMessage(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  ElevatedButton(
                    onPressed: sendMessage,
                    style: ElevatedButton.styleFrom(
                      elevation: 2,
                      shape: const CircleBorder(),
                      fixedSize: const Size(50, 50),
                    ),
                    child: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MessageContainer extends StatelessWidget {
  const MessageContainer({super.key, required this.message});
  final Message message;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Align(
        alignment:
            message.byCurrent ? Alignment.centerRight : Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints.loose(
            Size(width * 0.80, double.infinity),
          ),
          child: Tooltip(
            message: Utils.formatDateTime(message.time),
            child: Material(
              elevation: 2,
              color: message.byCurrent
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(15),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  message.text,
                  style: TextStyle(
                    color: message.byCurrent
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
