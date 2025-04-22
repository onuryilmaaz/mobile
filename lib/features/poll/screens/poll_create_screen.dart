import 'package:flutter/material.dart';

class PollCreateScreen extends StatefulWidget {
  const PollCreateScreen({super.key});

  @override
  State<PollCreateScreen> createState() => _PollCreateScreenState();
}

class _PollCreateScreenState extends State<PollCreateScreen> {
  final TextEditingController _pollTitleController = TextEditingController();
  List<Question> _questions = [];

  void _addQuestion() {
    setState(() {
      _questions.add(Question());
    });
  }

  void _savePoll() {
    final pollTitle = _pollTitleController.text;
    if (pollTitle.isEmpty || _questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Anket adı ve en az bir soru gerekli')),
      );
      return;
    }

    final pollData = {
      "title": pollTitle,
      "questions": _questions.map((q) => q.toJson()).toList(),
    };

    print('Oluşturulan Anket:');
    print(pollData);

    // Burada API'ye gönderirsin.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Anket Oluştur')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _pollTitleController,
              decoration: const InputDecoration(labelText: 'Anket Başlığı'),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _questions.length,
              itemBuilder: (context, index) {
                return QuestionWidget(
                  question: _questions[index],
                  onDelete: () {
                    setState(() {
                      _questions.removeAt(index);
                    });
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _addQuestion,
              icon: const Icon(Icons.add),
              label: const Text('Soru Ekle'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _savePoll,
              child: const Text('Anketi Kaydet'),
            ),
          ],
        ),
      ),
    );
  }
}

class Question {
  String text = '';
  List<String> options = [];

  Map<String, dynamic> toJson() {
    return {"questionText": text, "options": options};
  }
}

class QuestionWidget extends StatefulWidget {
  final Question question;
  final VoidCallback onDelete;

  const QuestionWidget({
    super.key,
    required this.question,
    required this.onDelete,
  });

  @override
  State<QuestionWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  final TextEditingController _questionController = TextEditingController();
  final List<TextEditingController> _optionControllers = [];

  void _addOption() {
    setState(() {
      _optionControllers.add(TextEditingController());
      widget.question.options.add('');
    });
  }

  @override
  void initState() {
    super.initState();
    _questionController.text = widget.question.text;
  }

  @override
  void dispose() {
    _questionController.dispose();
    for (var controller in _optionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _questionController,
              decoration: const InputDecoration(labelText: 'Soru'),
              onChanged: (value) {
                widget.question.text = value;
              },
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _optionControllers.length,
              itemBuilder: (context, index) {
                return TextField(
                  controller: _optionControllers[index],
                  decoration: InputDecoration(
                    labelText: 'Seçenek ${index + 1}',
                  ),
                  onChanged: (value) {
                    widget.question.options[index] = value;
                  },
                );
              },
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _addOption,
                  icon: const Icon(Icons.add),
                  label: const Text('Seçenek Ekle'),
                ),
                const Spacer(),
                IconButton(
                  onPressed: widget.onDelete,
                  icon: const Icon(Icons.delete, color: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
