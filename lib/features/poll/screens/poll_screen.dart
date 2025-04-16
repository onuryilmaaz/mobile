import 'package:flutter/material.dart';
import 'package:mobile/features/home/widgets/drawer.dart';
import 'package:mobile/features/poll/providers/poll_provider.dart';
import 'package:mobile/features/poll/widgets/poll_item.dart';
import 'package:provider/provider.dart';

class PollScreen extends StatefulWidget {
  const PollScreen({super.key});

  @override
  State<PollScreen> createState() => _PollScreenState();
}

class _PollScreenState extends State<PollScreen> {
  @override
  void initState() {
    super.initState();
    // Sayfa ilk açıldığında aktif anketleri çek
    Future.microtask(
      () =>
          Provider.of<PollProvider>(context, listen: false).fetchActivePolls(),
    );
  }

  void _setScreen(String identifier) async {}

  @override
  Widget build(BuildContext context) {
    final pollProvider = context.watch<PollProvider>();
    final polls = pollProvider.activePolls;

    return Scaffold(
      appBar: AppBar(title: const Text("Poll")),
      backgroundColor: Colors.teal,
      drawer: MainDrawer(onSelectScreen: _setScreen),
      body: Builder(
        builder: (context) {
          if (pollProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (pollProvider.errorMessage != null) {
            return Center(child: Text("Hata: ${pollProvider.errorMessage}"));
          }

          if (polls == null) {
            return const Center(child: Text("Hiç aktif anket bulunamadı."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: polls.length,
            itemBuilder: (ctx, index) {
              final poll = polls[index];
              return PollItem(poll: poll); // poll objesini ver
            },
          );
        },
      ),
    );
  }
}
