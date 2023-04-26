import 'package:flutter/material.dart';
import 'package:vetpet/types.dart';

class ChatLayout extends StatefulWidget {
  const ChatLayout({super.key, required this.current, required this.other});
  final User current;
  final User other;

  @override
  State<ChatLayout> createState() => _ChatLayoutState();
}

class _ChatLayoutState extends State<ChatLayout> {
  List<Message> messages = [
    Message(
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
        true),
    Message(
        'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla par',
        false),
    Message("Hellooo", false),
    Message("Hellooo", true),
  ];

  final _typedMessage = TextEditingController();
  final _scrollController = ScrollController();

  void sendMessage() {
    setState(() {
      messages.insert(0, Message(_typedMessage.text, true));
      messages.insert(0, Message(_typedMessage.text, false));
      _typedMessage.text = '';
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    });
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
    );
  }
}
