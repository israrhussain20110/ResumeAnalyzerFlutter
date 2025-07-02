import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static final _log = Logger('SettingsScreen');

  @override
  Widget build(BuildContext context) {
    _log.info('Building SettingsScreen');
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: SwitchListTile(
                title: const Text('Dark Mode'),
                subtitle: const Text('Switch between light and dark theme'),
                value: Theme.of(context).brightness == Brightness.dark,
                onChanged: (value) {
                  _log.info('Theme switched to ${value ? 'dark' : 'light'}');
                  // Implement theme switching logic here
                },
              ),
            ),
            const Spacer(),
            Text(
              'Resume Analyzer v1.0',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
