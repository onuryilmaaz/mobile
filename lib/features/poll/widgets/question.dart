import 'package:flutter/material.dart';

class QuestionWidget extends StatefulWidget {
  final Map<String, dynamic> question;

  const QuestionWidget({super.key, required this.question});

  @override
  State<QuestionWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  dynamic selectedValue;
  Set<int> selectedOptions = {};
  List<dynamic> reorderedOptions = [];

  @override
  void initState() {
    super.initState();
    reorderedOptions = widget.question['options'];
  }

  @override
  Widget build(BuildContext context) {
    final q = widget.question;
    final options = q['options'] as List<dynamic>;

    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(q['text'], style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),

            if (q['type'] == 0 || q['type'] == 2)
              ...options.map(
                (opt) => RadioListTile(
                  title: Text(opt['text']),
                  value: opt['id'],
                  groupValue: selectedValue,
                  onChanged: (val) => setState(() => selectedValue = val),
                ),
              ),
            if (q['type'] == 1)
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Yanıtınızı yazın...",
                ),
                onChanged: (val) => selectedValue = val,
              ),
            if (q['type'] == 3)
              ...options.map(
                (opt) => CheckboxListTile(
                  title: Text(opt['text']),
                  value: selectedOptions.contains(opt['id']),
                  onChanged: (val) {
                    setState(() {
                      val!
                          ? selectedOptions.add(opt['id'])
                          : selectedOptions.remove(opt['id']);
                    });
                  },
                ),
              ),
            if (q['type'] == 4)
              ReorderableListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) newIndex--;
                    final item = reorderedOptions.removeAt(oldIndex);
                    reorderedOptions.insert(newIndex, item);
                  });
                },
                children: [
                  for (int i = 0; i < reorderedOptions.length; i++)
                    ListTile(
                      key: ValueKey(reorderedOptions[i]['id']),
                      title: Text(reorderedOptions[i]['text']),
                      leading: const Icon(Icons.drag_handle),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
