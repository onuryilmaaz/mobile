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

  @override
  Widget build(BuildContext context) {
    final service = Services();

    return Scaffold(
      appBar: AppBar(title: const Text("Poll")),
      backgroundColor: Colors.teal,
      drawer: MainDrawer(onSelectScreen: _setScreen),
      body: FutureBuilder(
        future: service.getActivePoll(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            final data = snapshot.data;
            return ListView.builder(
              itemCount: data!.length,
              itemBuilder: (context, index) {
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
                          data[index].title.toString(),
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          data[index].description.toString(),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => PollDetailScreen(
                                        pollId: data[index].id!,
                                      ),
                                ),
                              );
                            },
                            child: const Text("Ankete Katıl"),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return Text("Data yok");
        },
      ),
    );
  }
}
