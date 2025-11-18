import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.home, color: cs.primary, size: 36),
                const SizedBox(height: 8),
                const Text('Welcome! You are logged in.'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
