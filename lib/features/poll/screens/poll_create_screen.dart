import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile/features/poll/model/poll_create.dart';
import 'package:mobile/features/poll/services/services.dart';

class PollCreateScreen extends StatefulWidget {
  const PollCreateScreen({super.key});

  @override
  State<PollCreateScreen> createState() => _PollCreateScreenState();
}

class _PollCreateScreenState extends State<PollCreateScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController(); // Kategori ekleme
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isActive = true;

  final Services services = Services();

  final List<Question> _questions = [];

  void _addQuestion() {
    setState(() {
      _questions.add(
        Question(orderIndex: _questions.length),
      ); // Sorular sıralı artacak
    });
  }

  void _submitPoll() async {
    final poll = PollCreate(
      title: _titleController.text,
      description: _descriptionController.text,
      categoryId: 1020, // Sabit
      categoryName: _categoryController.text,
      createdDate: _startDate?.toIso8601String(),
      expiryDate: _endDate?.toIso8601String(),
      isActive: _isActive,
      questions:
          _questions
              .map(
                (q) => QuestionCreate(
                  text: q.text,
                  type: q.type,
                  orderIndex: q.orderIndex,
                  isRequired: q.isRequired,
                  maxSelections: q.maxSelections,
                  options:
                      q.options
                          .map(
                            (o) => OptionCreate(
                              text: o.text,
                              orderIndex: o.orderIndex,
                            ),
                          )
                          .toList(),
                ),
              )
              .toList(),
    );

    await services.createPoll(poll); // Servisi çağırıyoruz
  }

  // void _submitPoll() {
  //   final pollData = {
  //     'title': _titleController.text,
  //     'description': _descriptionController.text,
  //     'categoryId': 1020, // Sabit ID
  //     'categoryName': _categoryController.text, // Kullanıcının girdiği kategori
  //     'createdDate': _startDate?.toIso8601String(),
  //     'expiryDate': _endDate?.toIso8601String(),
  //     'isActive': _isActive,
  //     'questions': _questions.map((q) => q.toJson()).toList(),
  //   };

  //   print(pollData);
  //   // Burada API'ye gönderme işlemi yapılabilir
  // }

  Future<void> _pickDate({required bool isStart}) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365 * 5)),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Anket Oluştur')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Anket Başlığı'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Açıklama'),
              maxLines: 3,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _categoryController, // Kategori alanı
              decoration: const InputDecoration(labelText: 'Kategori Adı'),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                TextButton(
                  onPressed: () => _pickDate(isStart: true),
                  child: Text(
                    _startDate == null
                        ? 'Başlangıç Tarihi Seç'
                        : DateFormat('yyyy-MM-dd').format(_startDate!),
                  ),
                ),
                const SizedBox(width: 10),
                TextButton(
                  onPressed: () => _pickDate(isStart: false),
                  child: Text(
                    _endDate == null
                        ? 'Bitiş Tarihi Seç'
                        : DateFormat('yyyy-MM-dd').format(_endDate!),
                  ),
                ),
              ],
            ),
            SwitchListTile(
              value: _isActive,
              onChanged: (v) => setState(() => _isActive = v),
              title: const Text('Aktif mi?'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Sorular',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ..._questions
                .map((q) => q.build(context, onChanged: () => setState(() {})))
                .toList(),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addQuestion,
              child: const Text('Soru Ekle'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitPoll,
              child: const Text('Anketi Oluştur'),
            ),
          ],
        ),
      ),
    );
  }
}

class Question {
  String text = '';
  int type =
      0; // 0: Çoktan seçmeli, 1: Text, 2: Doğru/yanlış, 3: Çoklu seçim, 4: Sıralama
  bool isRequired = true;
  int maxSelections = 0;
  final List<Option> options = [];
  final int orderIndex;

  Question({required this.orderIndex}); // Constructor'a orderIndex ekledim

  Widget build(BuildContext context, {required VoidCallback onChanged}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (v) => text = v,
              decoration: const InputDecoration(labelText: 'Soru Metni'),
            ),
            const SizedBox(height: 8),
            DropdownButton<int>(
              value: type,
              items: const [
                DropdownMenuItem(value: 0, child: Text('Çoktan Seçmeli')),
                DropdownMenuItem(value: 1, child: Text('Metin (Text)')),
                DropdownMenuItem(value: 2, child: Text('Doğru / Yanlış')),
                DropdownMenuItem(value: 3, child: Text('Çoklu Seçim')),
                DropdownMenuItem(value: 4, child: Text('Sıralama')),
              ],
              onChanged: (v) {
                if (v != null) {
                  type = v;
                  options.clear();
                  onChanged();
                }
              },
            ),
            CheckboxListTile(
              value: isRequired,
              onChanged: (v) => {isRequired = v ?? true, onChanged()},
              title: const Text('Zorunlu mu?'),
            ),
            if (type == 4) ...[
              TextField(
                keyboardType: TextInputType.number,
                onChanged: (v) => maxSelections = int.tryParse(v) ?? 0,
                decoration: const InputDecoration(
                  labelText: 'Maksimum Seçim Sayısı',
                ),
              ),
            ],
            if (type == 0 || type == 3 || type == 4) ...[
              const SizedBox(height: 8),
              const Text(
                'Seçenekler:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ...options.map((o) => o.build(onChanged)).toList(),
              TextButton(
                onPressed: () {
                  options.add(
                    Option(orderIndex: options.length),
                  ); // Seçeneklerde de orderIndex sıralı olacak
                  onChanged();
                },
                child: const Text('Seçenek Ekle'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'text': text,
    'type': type,
    'orderIndex': orderIndex,
    'isRequired': isRequired,
    'maxSelections': maxSelections,
    'options': options.map((o) => o.toJson()).toList(),
  };
}

class Option {
  String text = '';
  final int orderIndex;

  Option({required this.orderIndex}); // Seçeneklere da orderIndex ekledim

  Widget build(VoidCallback onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextField(
        onChanged: (v) => {text = v, onChanged()},
        decoration: const InputDecoration(labelText: 'Seçenek Metni'),
      ),
    );
  }

  Map<String, dynamic> toJson() => {'text': text, 'orderIndex': orderIndex};
}
