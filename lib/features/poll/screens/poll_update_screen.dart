// ignore_for_file: use_build_context_synchronously, unnecessary_to_list_in_spreads

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile/features/category/model/category_model.dart';
import 'package:mobile/features/category/services/category_service.dart';
import 'package:mobile/features/poll/model/poll_update.dart';
import 'package:mobile/features/poll/services/services.dart';

class PollUpdateScreen extends StatefulWidget {
  final int pollId;
  const PollUpdateScreen({required this.pollId, super.key});

  @override
  State<PollUpdateScreen> createState() => _PollUpdateScreenState();
}

class _PollUpdateScreenState extends State<PollUpdateScreen> {
  final _formKey = GlobalKey<FormState>();

  int? _selectedCategoryId;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isActive = true;
  bool _isLoading = true;
  String? _errorMessage;

  final Services services = Services();
  final List<Question> _questions = [];

  @override
  void initState() {
    super.initState();
    _loadPollData();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _loadPollData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final pollDetail = await services.getPoll(widget.pollId);

      // Populate form fields with existing data
      _titleController.text = pollDetail.title!;
      _descriptionController.text = pollDetail.description ?? '';
      _selectedCategoryId = pollDetail.categoryId;
      _categoryController.text = pollDetail.newCategoryName!;

      if (pollDetail.createdDate != null) {
        _startDate = DateTime.parse(pollDetail.createdDate!);
      }

      if (pollDetail.expiryDate != null) {
        _endDate = DateTime.parse(pollDetail.expiryDate!);
      }

      _isActive = pollDetail.isActive!;

      // Load existing questions
      _questions.clear();
      if (pollDetail.questions != null) {
        for (var q in pollDetail.questions!) {
          final question = Question(
            orderIndex: q.orderIndex ?? _questions.length,
          );
          question.text = q.text ?? '';
          question.type = q.type ?? 0;
          question.isRequired = q.isRequired ?? true;
          question.maxSelections = q.maxSelections ?? 0;

          // Load options if they exist
          if (q.options != null) {
            for (var o in q.options!) {
              final option = Option(
                orderIndex: o.orderIndex ?? question.options.length,
              );
              option.text = o.text ?? '';
              question.options.add(option);
            }
          }

          _questions.add(question);
        }
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Anket verisi yüklenemedi: $e';
      });
    }
  }

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

    final poll = PollUpdate(
      id: widget.pollId,
      title: _titleController.text,
      description: _descriptionController.text,
      categoryId: _selectedCategoryId!,
      newCategoryName: _categoryController.text,
      createdDate: _startDate?.toIso8601String(),
      expiryDate: _endDate?.toIso8601String(),
      isActive: _isActive,
      questions:
          _questions
              .map(
                (q) => QuestionUpdate(
                  text: q.text,
                  type: q.type,
                  orderIndex: q.orderIndex,
                  isRequired: q.isRequired,
                  maxSelections: q.maxSelections,
                  options:
                      q.options
                          .map(
                            (o) => OptionUpdate(
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
      await services.updatePoll(poll);

      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: const Text('Başarılı'),
              content: const Text('Anket başarıyla güncellendi.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pop(context); // Return to previous screen
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
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Kapat'),
                ),
              ],
            ),
      );
    }
  }

  Future<void> _pickDate({required bool isStart}) async {
    final now = DateTime.now();
    final initialDate = isStart ? _startDate ?? now : _endDate ?? now;

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
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
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Anket Güncelle')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Anket Güncelle')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadPollData,
                child: const Text('Tekrar Dene'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Anket Güncelle')),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Sorular',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    onPressed: _addQuestion,
                    child: const Text('Soru Ekle'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (_questions.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('Henüz soru eklenmemiş'),
                  ),
                )
              else
                ..._questions.map(
                  (q) => q.build(
                    context,
                    onChanged: () => setState(() {}),
                    onDelete:
                        () => setState(() {
                          _questions.remove(q);
                          // Update order indices
                          for (var i = 0; i < _questions.length; i++) {
                            _questions[i].orderIndex = i;
                          }
                        }),
                  ),
                ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitPoll,
                  child: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      'Anketi Güncelle',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
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
  int orderIndex;

  Question({required this.orderIndex});

  Widget build(
    BuildContext context, {
    required VoidCallback onChanged,
    VoidCallback? onDelete,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: TextEditingController(
                      text: text,
                    )..selection = TextSelection.collapsed(offset: text.length),
                    onChanged: (v) {
                      text = v;
                      onChanged();
                    },
                    decoration: const InputDecoration(labelText: 'Soru Metni'),
                  ),
                ),
                if (onDelete != null)
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: onDelete,
                  ),
              ],
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
                controller: TextEditingController(
                  text: maxSelections.toString(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (v) {
                  maxSelections = int.tryParse(v) ?? 0;
                  onChanged();
                },
                decoration: const InputDecoration(
                  labelText: 'Maksimum Seçim Sayısı',
                ),
              ),
            ],
            if (type == 0 || type == 3 || type == 4) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Seçenekler:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      options.add(Option(orderIndex: options.length));
                      onChanged();
                    },
                    child: const Text('Seçenek Ekle'),
                  ),
                ],
              ),
              ...options
                  .map(
                    (o) => o.build(
                      onChanged: onChanged,
                      onDelete: () {
                        options.remove(o);
                        // Update order indices
                        for (var i = 0; i < options.length; i++) {
                          options[i].orderIndex = i;
                        }
                        onChanged();
                      },
                    ),
                  )
                  .toList(),
              if (options.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Henüz seçenek eklenmemiş',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
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
  int orderIndex;

  Option({required this.orderIndex});

  Widget build({required VoidCallback onChanged, VoidCallback? onDelete}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: TextEditingController(text: text)
                ..selection = TextSelection.collapsed(offset: text.length),
              onChanged: (v) {
                text = v;
                onChanged();
              },
              decoration: const InputDecoration(labelText: 'Seçenek Metni'),
            ),
          ),
          if (onDelete != null)
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 20),
              onPressed: onDelete,
            ),
        ],
      ),
    );
  }
}
