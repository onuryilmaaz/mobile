import 'package:flutter/material.dart';
import 'package:mobile/features/home/widgets/drawer.dart';
import 'package:mobile/features/poll/screens/poll_detail_screen.dart';
import 'package:mobile/features/poll/services/services.dart';

class PollScreen extends StatefulWidget {
  const PollScreen({super.key});

  @override
  State<PollScreen> createState() => _PollScreenState();
}

class _PollScreenState extends State<PollScreen> {
  void _setScreen(String identifier) async {}

  Future<Map<String, dynamic>>? _pollData;

  @override
  void initState() {
    super.initState();
    _pollData = _loadPollData();
  }

  Future<Map<String, dynamic>> _loadPollData() async {
    final service = Services();
    final activePolls = await service.getActivePoll();
    final participatedPolls = await service.getParticipatedPollIds();
    return {'activePolls': activePolls, 'participatedIds': participatedPolls};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Anketler")),
      backgroundColor: Colors.teal,
      drawer: MainDrawer(onSelectScreen: _setScreen),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _pollData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            final activePolls = snapshot.data!['activePolls'];
            final participatedIds = snapshot.data!['participatedIds'];

            return ListView.builder(
              itemCount: activePolls.length,
              itemBuilder: (context, index) {
                final poll = activePolls[index];
                final hasParticipated = participatedIds.contains(poll.id);

                return Opacity(
                  opacity: hasParticipated ? 0.5 : 1.0,
                  child: Card(
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
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              onPressed:
                                  hasParticipated
                                      ? null
                                      : () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) => PollDetailScreen(
                                                  pollId: poll.id!,
                                                ),
                                          ),
                                        );
                                      },
                              child: Text(
                                hasParticipated ? "Katıldınız" : "Ankete Katıl",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return const Center(child: Text("Veri bulunamadı"));
        },
      ),
    );
  }
}
