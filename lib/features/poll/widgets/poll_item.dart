import 'package:flutter/material.dart';
import 'package:mobile/features/poll/models/poll_list_dto.dart';
import 'package:mobile/features/poll/screens/poll_detail_screen.dart';

class PollItem extends StatelessWidget {
  final PollListDto poll;

  const PollItem({super.key, required this.poll});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              poll.title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              poll.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PollDetailScreen(pollId: poll.id),
                    ),
                  );
                },
                child: const Text("Ankete Katıl"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
