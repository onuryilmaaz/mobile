// ignore_for_file: use_build_context_synchronously, unnecessary_to_list_in_spreads

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile/features/category/model/category_model.dart';
import 'package:mobile/features/category/services/category_service.dart';
import 'package:mobile/features/poll/model/poll_create.dart';
import 'package:mobile/features/poll/screens/poll_screen.dart';
import 'package:mobile/features/poll/services/services.dart';

class PollCreateScreen extends StatefulWidget {
  const PollCreateScreen({super.key});

  @override
  State<PollCreateScreen> createState() => _PollCreateScreenState();
}

class _PollCreateScreenState extends State<PollCreateScreen> {
  final _formKey = GlobalKey<FormState>();

  int? _selectedCategoryId;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isActive = true;

  final Services services = Services();
  final List<Question> _questions = [];

  Future<void> _selectCategory() async {
    final categories = await CategoryService().fetchCategories();

    final selected = await showDialog<Category>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Kategori Seç"),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return ListTile(
                  title: Text(category.name),
                  onTap: () => Navigator.pop(context, category),
                );
              },
            ),
          ),
        );
      },
    );

    if (selected != null) {
      setState(() {
        _selectedCategoryId = selected.id;
        _categoryController.text = selected.name;
      });
    }
  }

  void _addQuestion() {
    setState(() {
      _questions.add(Question(orderIndex: _questions.length));
    });
  }

  bool _areQuestionsValid() {
    for (var q in _questions) {
      if (q.text.trim().isEmpty) return false;

      if ((q.type == 0 || q.type == 3 || q.type == 4)) {
        if (q.options.isEmpty) return false;
        for (var o in q.options) {
          if (o.text.trim().isEmpty) return false;
        }
      }
    }
    return true;
  }

  void _submitPoll() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen bir kategori seçin")),
      );
      return;
    }

    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tarihleri seçmeyi unutmayın")),
      );
      return;
    }

    if (_questions.isEmpty || !_areQuestionsValid()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tüm sorular geçerli olmalıdır")),
      );
      return;
    }

    final poll = PollCreate(
      title: _titleController.text,
      description: _descriptionController.text,
      categoryId: _selectedCategoryId!,
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

    try {
      await services.createPoll(poll);

      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: const Text('Başarılı'),
              content: const Text('Anket başarıyla oluşturuldu.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PollScreen()),
                    );
                  },
                  child: const Text('Tamam'),
                ),
              ],
            ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: const Text('Hata'),
              content: Text('Bir hata oluştu: $e'),
              actions: [
                TextButton(
                  onPressed:
                      () => {
                        Navigator.of(context).pop(),
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PollScreen()),
                        ),
                      },
                  child: const Text('Kapat'),
                ),
              ],
            ),
      );
    }
  }

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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Anket Başlığı'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Başlık boş olamaz'
                            : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Açıklama'),
                maxLines: 3,
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Açıklama boş olamaz'
                            : null,
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: _selectCategory,
                child: AbsorbPointer(
                  child: TextField(
                    controller: _categoryController,
                    decoration: const InputDecoration(
                      labelText: 'Kategori Seç',
                      suffixIcon: Icon(Icons.arrow_drop_down),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
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
              ..._questions.map(
                (q) => q.build(context, onChanged: () => setState(() {})),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _addQuestion,
                child: const Text('Soru Ekle'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed:
                    _questions.isNotEmpty && _areQuestionsValid()
                        ? _submitPoll
                        : null,
                child: const Text('Anketi Oluştur'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Question {
  String text = '';
  int type = 0;
  bool isRequired = true;
  int maxSelections = 0;
  final List<Option> options = [];
  final int orderIndex;

  Question({required this.orderIndex});

  Widget build(BuildContext context, {required VoidCallback onChanged}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (v) {
                text = v;
                onChanged();
              },
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
              onChanged: (v) {
                isRequired = v ?? true;
                onChanged();
              },
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
                  options.add(Option(orderIndex: options.length));
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
}

class Option {
  String text = '';
  final int orderIndex;

  Option({required this.orderIndex});

  Widget build(VoidCallback onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextField(
        onChanged: (v) {
          text = v;
          onChanged();
        },
        decoration: const InputDecoration(labelText: 'Seçenek Metni'),
      ),
    );
  }
}
