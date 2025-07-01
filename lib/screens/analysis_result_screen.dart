import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:resume_analyzer/screens/upload%20state.dart';

class AnalysisResultScreen extends StatelessWidget {
  AnalysisResultScreen({super.key});

  static final _log = Logger('AnalysisResultScreen');
  final NumberFormat _percentFormat = NumberFormat.percentPattern();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analysis Results'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showAnalysisInfo(context),
          ),
        ],
      ),
      body: Consumer<UploadState>(
        builder: (context, uploadState, _) {
          if (uploadState.error != null) return _buildErrorView(context, uploadState.error!);
          if (uploadState.isLoading) return _buildLoadingView();
          if (uploadState.analysisResult == null) return _buildEmptyView(context);

          final analysis = uploadState.analysisResult!;
          final double score = analysis['score'] as double;
          final String label = analysis['label'] as String;
          final List<String> keywords = List<String>.from(analysis['keywords'] ?? []);
          final Map<String, dynamic> allScores = Map<String, dynamic>.from(analysis['all_scores'] ?? {});
          final String analysisDate = analysis['analysis_date'] as String? ?? '';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildScoreCard(context, label, score, analysisDate),
                const SizedBox(height: 24),

                if (keywords.isNotEmpty) ...[
                  _buildKeywordSection(context, keywords),
                  const SizedBox(height: 24),
                ],

                _buildCategoryScores(context, allScores),
                const SizedBox(height: 32),

                _buildActionButtons(context, uploadState),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildScoreCard(BuildContext context, String label, double score, String date) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  _getScoreIcon(score),
                  color: _getScoreColor(score),
                  size: 36,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: _getScoreColor(score),
                        ),
                      ),
                      if (date.isNotEmpty)
                        Text(
                          DateFormat.yMMMd().add_jm().format(DateTime.parse(date)),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                        ),
                    ],
                  ),
                ),
                Chip(
                  label: Text(
                    _percentFormat.format(score),
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: _getScoreColor(score),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: score,
              backgroundColor: Colors.grey.shade300,
              color: _getScoreColor(score),
              minHeight: 12,
              borderRadius: BorderRadius.circular(6),
            ),
            const SizedBox(height: 12),
            Text(
              _getScoreDescription(score),
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeywordSection(BuildContext context, List<String> keywords) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Matched Keywords:',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: keywords.map((keyword) => Chip(
            label: Text(keyword.capitalize()),
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildCategoryScores(BuildContext context, Map<String, dynamic> scores) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category Analysis:',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...scores.entries.map((entry) => _buildCategoryScoreItem(
          context,
          entry.key,
          entry.value as double,
        )),
      ],
    );
  }

  Widget _buildCategoryScoreItem(BuildContext context, String category, double score) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  category,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  _percentFormat.format(score),
                  style: TextStyle(
                    color: _getScoreColor(score),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: score,
              backgroundColor: Colors.grey.shade200,
              color: _getScoreColor(score),
              minHeight: 6,
              borderRadius: BorderRadius.circular(3),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, UploadState uploadState) {
    return Center(
      child: Column(
        children: [
          FilledButton.icon(
            icon: const Icon(Icons.refresh),
            label: const Text('Analyze Another Resume'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            ),
            onPressed: () {
              uploadState.clearAnalysis();
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/upload',
                    (route) => false,
              );
            },
          ),

        ],
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: Theme.of(context).colorScheme.error,
              size: 60,
            ),
            const SizedBox(height: 16),
            Text(
              'Analysis Error',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () {
                context.read<UploadState>().clearAnalysis();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/upload',
                      (route) => false,
                );
              },
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingView() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Analyzing resume...'),
            SizedBox(height: 8),
            Text(
              'This may take a few moments',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyView(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.upload_file,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'No Analysis Available',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text(
              'Upload a resume and job description to get started',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () {
                Navigator.pushNamed(context, '/upload');
              },
              child: const Text('Upload Resume'),
            ),
          ],
        ),
      ),
    );
  }


  void _showAnalysisInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About the Analysis'),
        content: const Text(
            'This analysis compares your resume against the job description '
                'using semantic similarity. The score reflects how well your '
                'qualifications match the job requirements.\n\n'
                'Scoring Guide:\n'
                '• 80-100%: Excellent match\n'
                '• 60-79%: Good match\n'
                '• 40-59%: Fair match\n'
                '• Below 40%: Poor match\n\n'
                'The category scores show how well your resume matches specific '
                'aspects of the job.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  IconData _getScoreIcon(double score) {
    if (score >= 0.8) return Icons.verified;
    if (score >= 0.6) return Icons.check_circle;
    if (score >= 0.4) return Icons.info;
    return Icons.warning;
  }

  String _getScoreDescription(double score) {
    if (score >= 0.8) return 'Your resume strongly matches the job requirements!';
    if (score >= 0.6) return 'Good match but could be improved in some areas.';
    if (score >= 0.4) return 'Some relevant qualifications but needs significant improvement.';
    return 'Limited match with the job requirements. Consider revising your resume.';
  }

  Color _getScoreColor(double score) {
    if (score >= 0.8) return Colors.green;
    if (score >= 0.6) return Colors.lightGreen;
    if (score >= 0.4) return Colors.orange;
    return Colors.red;
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}