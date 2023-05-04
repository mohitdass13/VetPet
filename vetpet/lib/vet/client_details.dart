import 'package:flutter/material.dart';
import 'package:vetpet/types.dart';

class ClientDetails extends StatefulWidget {
  const ClientDetails({super.key, required this.client});
  final Owner client;

  @override
  State<ClientDetails> createState() => _ClientDetailsState();
}

class _ClientDetailsState extends State<ClientDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.client.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Pets",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Flexible(
                      child: ListView(
                        shrinkWrap: true,
                        children: widget.client.pets
                            .map(
                              (e) => ListTile(
                                title: Text(e.name),
                                subtitle: Text('${e.id}'),
                                trailing: const Icon(Icons.navigate_next),
                                onTap: () => Navigator.pushNamed(
                                  context,
                                  '/vet/client/pet',
                                  arguments: e,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 60,
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/chat',
                          arguments: widget.client,
                        );
                      },
                      icon: const Icon(Icons.chat),
                      label: const Text('Chat'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.delete_forever),
                      label: const Text('Remove'),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
