import 'package:flutter/material.dart';
import 'package:mobile/features/poll/model/question_update.dart';

class QuestionWidget extends StatelessWidget {
  final QuestionUpdate question;
  final VoidCallback onChanged;

  const QuestionWidget({
    super.key,
    required this.question,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              initialValue: question.text,
              decoration: const InputDecoration(labelText: 'Soru Metni'),
              onChanged: (value) {
                question.text = value;
                onChanged();
              },
            ),
            const SizedBox(height: 6),
            Text("Soru Tipi: ${question.type}"),
            ...question.options.map((o) => Text("• ${o.text}")),
          ],
        ),
      ),
    );
  }
}
