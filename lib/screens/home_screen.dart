import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logging/logging.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static final _log = Logger('HomeScreen');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    _log.info('Building HomeScreen');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resume Analyzer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            SvgPicture.asset(
              'assets/images/undraw_resume_jrgi.svg',
              height: 200,
              semanticsLabel: 'Resume illustration',
            ),
            const SizedBox(height: 32),
            Text(
              'Analyze Your Resume in 3 Steps',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            _buildStepCard(
              context,
              icon: Icons.upload_file,
              step: 1,
              title: 'Upload Resume',
              description: 'Select your resume in PDF format',
            ),
            _buildStepCard(
              context,
              icon: Icons.analytics,
              step: 2,
              title: 'Add Job Details',
              description: 'Paste the job description or requirements',
            ),
            _buildStepCard(
              context,
              icon: Icons.assessment,
              step: 3,
              title: 'Get Analysis',
              description: 'Receive detailed matching results',
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/upload'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepCard(
      BuildContext context, {
        required IconData icon,
        required int step,
        required String title,
        required String description,
      }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(
                step.toString(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 16),
            Icon(icon, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(description),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}