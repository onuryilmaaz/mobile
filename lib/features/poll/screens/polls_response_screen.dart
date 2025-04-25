// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:mobile/features/home/widgets/drawer.dart';
import 'package:mobile/features/poll/screens/poll_update_screen.dart';
import 'package:mobile/features/poll/services/services.dart';

class PollsResponseScreen extends StatefulWidget {
  const PollsResponseScreen({super.key});
  @override
  State<PollsResponseScreen> createState() => _PollsResponseScreenState();
}

class _PollsResponseScreenState extends State<PollsResponseScreen> {
  final service = Services();

  void _setScreen(String identifier) async {}

  Future<bool> _confirmDelete(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text("Anketi Sil"),
                content: const Text(
                  "Bu anketi silmek istediğinize emin misiniz?",
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text("İptal"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text(
                      "Sil",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
        ) ??
        false;
  }

  void _showBottomMessage(
    BuildContext context,
    String message, {
    bool error = false,
  }) {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      isScrollControlled: false,
      backgroundColor: error ? Colors.red[100] : Colors.green[100],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        Future.delayed(const Duration(seconds: 3), () {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        });

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                error ? Icons.error_outline : Icons.check_circle_outline,
                color: error ? Colors.red : Colors.green,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    color: error ? Colors.red[900] : Colors.green[900],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  bool isPollExpired(DateTime expiryDate) {
    return expiryDate.isBefore(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Anket Listesi")),
      backgroundColor: Colors.teal,
      drawer: MainDrawer(onSelectScreen: _setScreen),
      body: FutureBuilder(
        future: service.pollsResponse(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            final data = snapshot.data;
            return ListView.builder(
              itemCount: data!.length,
              itemBuilder: (context, index) {
                final poll = data[index];
                final expired = isPollExpired(DateTime.parse(poll.expiryDate!));
                return Card(
                  elevation: 4,
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          poll.title.toString(),
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          poll.description.toString(),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.category, size: 16),
                            const SizedBox(width: 4),
                            Text("Kategori: ${poll.newCategoryName}"),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.question_answer, size: 16),
                            const SizedBox(width: 4),
                            Text("Soru sayısı: ${poll.questionCount}"),
                            const SizedBox(width: 16),
                            const Icon(Icons.how_to_vote, size: 16),
                            const SizedBox(width: 4),
                            Text("Cevap sayısı: ${poll.responseCount}"),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                child: ElevatedButton(
                                  onPressed:
                                      expired
                                          ? null
                                          : () async {
                                            try {
                                              await service.togglePollStatus(
                                                poll.id!,
                                              );
                                              setState(() {}); // refresh
                                            } catch (e) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    "Hata: ${e.toString()}",
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        expired
                                            ? Colors.grey
                                            : poll.isActive!
                                            ? Colors.amber
                                            : Colors.green,
                                  ),
                                  child: Text(
                                    expired
                                        ? "Süresi Doldu"
                                        : poll.isActive!
                                        ? "Anketi Pasifleştir"
                                        : "Anketi Aktifleştir",
                                    style: const TextStyle(color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => PollUpdateScreen(
                                              pollId: poll.id ?? 0,
                                            ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.purple,
                                  ),
                                  child: const Text(
                                    "Anketi Düzenle",
                                    style: TextStyle(color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                  ),
                                  child: const Text(
                                    "Anket Sonuçları",
                                    style: TextStyle(color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    final confirmed = await _confirmDelete(
                                      context,
                                    );
                                    if (!confirmed) return;

                                    try {
                                      await service.deletePoll(poll.id!);
                                      setState(() {}); // Listeyi yenile
                                      _showBottomMessage(
                                        context,
                                        "Anket başarıyla silindi",
                                      );
                                    } catch (e) {
                                      _showBottomMessage(
                                        context,
                                        "Hata: ${e.toString()}",
                                        error: true,
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  child: const Text(
                                    "Anketi Sil",
                                    style: TextStyle(color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const Center(child: Text("Data yok"));
        },
      ),
    );
  }
}
