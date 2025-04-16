import 'package:flutter/material.dart';

class PollDetailScreen extends StatelessWidget {
  const PollDetailScreen({super.key, required this.pollId});
  final pollId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(pollId.toString())),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            pollId.toString(),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
