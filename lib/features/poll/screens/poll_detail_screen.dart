// ignore_for_file: unnecessary_to_list_in_spreads, use_super_parameters, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:mobile/features/poll/controller/answer_controller.dart';
import 'package:mobile/features/poll/model/poll_model.dart';
import 'package:mobile/features/poll/screens/poll_screen.dart';
import 'package:mobile/features/poll/services/services.dart';

class PollDetailScreen extends StatefulWidget {
  const PollDetailScreen({super.key, required this.pollId});
  final int pollId;

  @override
  State<PollDetailScreen> createState() => _PollDetailScreenState();
}

class _PollDetailScreenState extends State<PollDetailScreen> {
  final service = Services();
  final AnswerController _answerController = AnswerController();
  String participationStatus = '';

  @override
  void initState() {
    super.initState();
    //service.checkParticipationStatus(widget.pollId);
    service.checkParticipationStatus(widget.pollId).then((hasSubmitted) {
      setState(() {
        participationStatus =
            hasSubmitted
                ? 'Ankete daha önce katıldınız'
                : 'Anketi şimdi yanıtlayabilirsiniz';
      });
    });
    service.getActivePollById(widget.pollId);
  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sonuç'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('Tamam'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PollScreen()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Anket Detayı')),
      body: FutureBuilder(
        future: service.getActivePollById(widget.pollId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            return ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 8,
                  ),
                  child: Column(
                    children: [
                      _PollDetailItem(data: data),
                      const SizedBox(height: 24),
                      if (data.questions != null)
                        ...data.questions!
                            .map(
                              (q) => _PollQuestionItem(
                                question: q,
                                answerController: _answerController,
                              ),
                            )
                            .toList(),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () async {
                          // ❌ Zaten katılmışsa engelle
                          if (participationStatus ==
                              'Ankete daha önce katıldınız') {
                            _showDialog('Bu ankete zaten katıldınız.');
                            return;
                          }

                          final answers = _answerController.getAnswers();

                          // 📋 Cevapları kontrol et (boş değilse gönder)
                          if (answers.isEmpty) {
                            _showDialog('Lütfen tüm soruları yanıtlayınız.');
                            return;
                          }

                          // ✅ Gönder
                          bool success = await service.submitPollResponse(
                            widget.pollId,
                            answers,
                          );

                          if (success) {
                            setState(() {
                              participationStatus =
                                  'Ankete daha önce katıldınız'; // UI'yı güncelle
                            });
                            _showDialog('Başarıyla ankete katıldınız!');
                          } else {
                            _showDialog('Bu ankete zaten katıldınız.');
                          }
                        },
                        child: const Text('Gönder'),
                      ),
                      // ElevatedButton(
                      //   onPressed: () async {
                      //     // AnswerController'dan cevapları al
                      //     final answers = _answerController.getAnswers();

                      //     // Servise gönder ve sonucu bekle
                      //     bool success = await service.submitPollResponse(
                      //       widget.pollId,
                      //       answers,
                      //     );

                      //     // Başarılı ise popup göster, değilse farklı bir popup göster
                      //     if (success) {
                      //       _showDialog('Başarıyla ankete katıldınız!');
                      //     } else {
                      //       _showDialog('Bu ankete zaten katıldınız.');
                      //     }
                      //   },
                      //   child: const Text('Gönder'),
                      // ),
                    ],
                  ),
                );
              },
            );
          }
          return Center(
            child: Text(
              "Anket detayları yüklenemedi - Hata kodu: ${snapshot.error}",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          );
        },
      ),
    );
  }
}

class _PollDetailItem extends StatelessWidget {
  final PollsDetail data;
  const _PollDetailItem({required this.data});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            elevation: 2,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Başlık
                      Text(
                        data.title.toString(),
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),

                      // Açıklama
                      if (data.description != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          data.description!,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],

                      const SizedBox(height: 16),

                      // Tarihler
                      Column(
                        children: [
                          _DateItem(
                            icon: Icons.calendar_today,
                            label: 'Oluşturulma',
                            date:
                                data.createdDate.toString() == 'null'
                                    ? DateTime.now()
                                    : DateTime.parse(
                                      data.createdDate.toString(),
                                    ),
                          ),
                          const SizedBox(width: 16),
                          _DateItem(
                            icon: Icons.event,
                            label: 'Bitiş',
                            date:
                                data.expiryDate.toString() == 'null'
                                    ? DateTime.now()
                                    : DateTime.parse(
                                      data.expiryDate.toString(),
                                    ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Durum Chip'i
                      Chip(
                        backgroundColor:
                            data.isActive ?? false
                                ? Colors.green[100]
                                : Colors.red[100],
                        label: Text(
                          data.isActive ?? false ? 'Aktif' : 'Pasif',
                          style: TextStyle(
                            color:
                                data.isActive ?? false
                                    ? Colors.green[800]
                                    : Colors.red[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Chip(
                    backgroundColor: Colors.blue[100],
                    label: Text(
                      data.newCategoryName ?? "",
                      style: TextStyle(
                        color: Colors.blue[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DateItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final DateTime date;

  const _DateItem({
    required this.icon,
    required this.label,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';

    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          '$label: $formattedDate',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
        ),
      ],
    );
  }
}

class _PollQuestionItem extends StatefulWidget {
  final Question question;
  final AnswerController answerController;
  const _PollQuestionItem({
    Key? key,
    required this.question,
    required this.answerController,
  }) : super(key: key);

  @override
  State<_PollQuestionItem> createState() => _PollQuestionItemState();
}

class _PollQuestionItemState extends State<_PollQuestionItem> {
  int? _singleValue;
  List<int> _multiValues = [];
  TextEditingController _textController = TextEditingController();
  late List<Option> _rankOptions;

  AnswerController get _answerController => widget.answerController;

  @override
  void initState() {
    super.initState();
    _rankOptions = List.from(widget.question.options);
  }

  @override
  Widget build(BuildContext context) {
    final q = widget.question;
    Widget input;
    switch (q.type) {
      case 0:
      case 2:
        input = Column(
          children:
              q.options.map((opt) {
                return RadioListTile<int>(
                  title: Text(opt.text),
                  value: opt.id,
                  groupValue: _singleValue,
                  onChanged: (v) {
                    setState(() {
                      _singleValue = v;
                      _answerController.setSingleChoice(q.id, v!);
                    });
                  },
                );
              }).toList(),
        );
        break;
      case 1:
        input = TextField(
          controller: _textController,
          decoration: InputDecoration(
            hintText: 'Cevabınızı buraya yazın',
            labelText: q.text,
            border: const OutlineInputBorder(),
          ),
          maxLines: null,
          onChanged: (value) {
            _answerController.setTextAnswer(q.id, value);
          },
        );
        break;
      case 3:
        input = Column(
          children:
              q.options.map((opt) {
                final checked = _multiValues.contains(opt.id);
                return CheckboxListTile(
                  title: Text(opt.text),
                  value: checked,
                  onChanged: (v) {
                    setState(() {
                      if (v == true) {
                        _multiValues.add(opt.id);
                      } else {
                        _multiValues.remove(opt.id);
                      }
                      _answerController.setMultiChoice(q.id, _multiValues);
                    });
                  },
                );
              }).toList(),
        );
        break;
      case 4:
        input = SizedBox(
          height: _rankOptions.length * 60.0,
          child: ReorderableListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (newIndex > oldIndex) newIndex--;
                final item = _rankOptions.removeAt(oldIndex);
                _rankOptions.insert(newIndex, item);
                _answerController.setRanking(
                  q.id,
                  _rankOptions.map((e) => e.id).toList(),
                );
              });
            },
            itemCount: _rankOptions.length,
            itemBuilder: (ctx, index) {
              final opt = _rankOptions[index];
              return ListTile(
                key: ValueKey(opt.id),
                leading: const Icon(Icons.drag_handle),
                title: Text(opt.text),
              );
            },
          ),
        );
        break;
      default:
        input = const Text('Bilinmeyen soru tipi');
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${q.orderIndex + 1}. ${q.text}',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          input,
        ],
      ),
    );
  }
}
