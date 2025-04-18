import 'package:flutter/material.dart';
import 'package:mobile/features/poll/models/option_detail_dto.dart';
import 'package:mobile/features/poll/models/question_detail_dto.dart';
import 'package:provider/provider.dart';
import 'package:mobile/features/poll/models/poll_detail_dto.dart';
import 'package:mobile/features/poll/models/poll_response_dto.dart';
import 'package:mobile/features/poll/providers/poll_provider.dart';
import 'package:mobile/features/poll/models/answer_dto.dart';

typedef Option = OptionDetailDto;

class PollDetailScreen extends StatefulWidget {
  const PollDetailScreen({super.key, required this.pollId});

  final int pollId;

  @override
  State<PollDetailScreen> createState() => _PollDetailScreenState();
}

class _PollDetailScreenState extends State<PollDetailScreen> {
  final Map<int, int?> _selectedOptions = {};
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadPollDetails());
  }

  Future<void> _loadPollDetails() async {
    final pollProvider = Provider.of<PollProvider>(context, listen: false);
    await pollProvider.fetchPollById(widget.pollId);
  }

  Future<void> _submitResponse() async {
    if (_selectedOptions.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lütfen en az bir seçenek seçin')),
        );
      }
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final pollProvider = Provider.of<PollProvider>(context, listen: false);

      final answers =
          _selectedOptions.entries.map((entry) {
            final Map<int, int?> optionMap = {};
            if (entry.value != null) {
              optionMap[entry.value!] = null;
            }

            return AnswerDto(
              questionId: entry.key,
              selectedOptionIds: optionMap,
            );
          }).toList();

      final response = PollResponseDto(answers: answers);

      final result = await pollProvider.submitPollResponse(
        widget.pollId,
        response,
      );

      if (mounted) {
        if (result) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Yanıtınız kaydedildi!')),
          );
          await _loadPollDetails();
        } else {
          showError('Yanıt gönderilemedi');
        }
      }
    } catch (e) {
      if (mounted) showError('Hata: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anket Detayı'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPollDetails,
          ),
        ],
      ),
      body: Consumer<PollProvider>(
        builder: (context, pollProvider, _) {
          if (pollProvider.isLoading)
            return const Center(child: CircularProgressIndicator());
          if (pollProvider.errorMessage != null)
            return _ErrorView(pollProvider);
          if (pollProvider.currentPoll == null)
            return const Center(child: Text('Anket bulunamadı'));

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _PollHeader(poll: pollProvider.currentPoll!),
                const SizedBox(height: 24),
                _buildQuestions(pollProvider.currentPoll!),
                const SizedBox(height: 24),
                _SubmitButton(
                  isSubmitting: _isSubmitting,
                  onSubmit: _submitResponse,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuestions(PollDetailDto poll) {
    return Column(
      children:
          poll.questions
              .map(
                (question) => _QuestionSection(
                  question: question,
                  selectedOptions: _selectedOptions,
                  onOptionSelected:
                      (questionId, optionId) => setState(() {
                        _selectedOptions[questionId] = optionId;
                      }),
                ),
              )
              .toList(),
    );
  }
}

class _PollHeader extends StatelessWidget {
  final PollDetailDto poll;

  const _PollHeader({required this.poll});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(poll.title, style: Theme.of(context).textTheme.headlineSmall),
            if (poll.description != null) ...[
              const SizedBox(height: 8),
              Text(
                poll.description!,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                _DateItem(
                  icon: Icons.calendar_today,
                  label: 'Oluşturulma',
                  date: poll.createdDate,
                ),
                if (poll.expiryDate != null) ...[
                  const SizedBox(width: 16),
                  _DateItem(
                    icon: Icons.event,
                    label: 'Bitiş',
                    date: poll.expiryDate!,
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),
            Chip(
              backgroundColor:
                  poll.isActive ? Colors.green[100] : Colors.red[100],
              label: Text(
                poll.isActive ? 'Aktif' : 'Pasif',
                style: TextStyle(
                  color: poll.isActive ? Colors.green[800] : Colors.red[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
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

class _QuestionSection extends StatelessWidget {
  final QuestionDetailDto question;
  final Map<int, int?> selectedOptions;
  final Function(int, int) onOptionSelected;

  const _QuestionSection({
    required this.question,
    required this.selectedOptions,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question.text, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        ...question.options.map(
          (option) => _OptionItem(
            option: option,
            isSelected: selectedOptions[question.id] == option.id,
            onSelected: () => onOptionSelected(question.id, option.id),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _OptionItem extends StatelessWidget {
  final Option option;
  final bool isSelected;
  final VoidCallback onSelected;

  const _OptionItem({
    required this.option,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    // null-aware operatör hatası burada düzeltildi
    final Color borderColor = isSelected ? Colors.blue : Colors.grey.shade300;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: isSelected ? Colors.blue[50] : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: borderColor, width: isSelected ? 2 : 1),
      ),
      child: InkWell(
        onTap: onSelected,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Radio<int>(
                value: option.id, // Null kontrolü yapıyoruz
                groupValue: isSelected ? option.id : null,
                onChanged: (_) => onSelected(),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  option.text,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final bool isSubmitting;
  final VoidCallback onSubmit;

  const _SubmitButton({required this.isSubmitting, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isSubmitting ? null : onSubmit,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child:
            isSubmitting
                ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                : const Text('Yanıtı Gönder', style: TextStyle(fontSize: 16)),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final PollProvider provider;

  const _ErrorView(this.provider);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Hata: ${provider.errorMessage}', textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              provider.clearErrorMessage();
              context
                  .findAncestorStateOfType<_PollDetailScreenState>()
                  ?._loadPollDetails();
            },
            child: const Text('Tekrar Dene'),
          ),
        ],
      ),
    );
  }
}
