import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resume_analyzer/screens/upload%20state.dart';

class ResumeUploaderScreen extends StatefulWidget {
  const ResumeUploaderScreen({super.key});

  @override
  State<ResumeUploaderScreen> createState() => _ResumeUploaderScreenState();
}

class _ResumeUploaderScreenState extends State<ResumeUploaderScreen> {
  final _jobDetailsController = TextEditingController();

  @override
  void dispose() {
    _jobDetailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Resume')),
      body: Consumer<UploadState>(
        builder: (context, uploadState, _) {
          if (!uploadState.isInitialized) {
            return _buildInitializationView();
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildJobDetailsCard(uploadState),
                const SizedBox(height: 16),
                _buildResumeUploadCard(uploadState),
                const SizedBox(height: 24),
                _buildAnalyzeButton(uploadState),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInitializationView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Initializing model...'),
        ],
      ),
    );
  }

  Widget _buildJobDetailsCard(UploadState uploadState) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ListTile(
              leading: Icon(Icons.description),
              title: Text('Job Details'),
              subtitle: Text('Enter the job description'),
            ),
            TextField(
              controller: _jobDetailsController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Paste job description here...',
              ),
              maxLines: 5,
              minLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResumeUploadCard(UploadState uploadState) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              leading: Icon(
                uploadState.fileName != null ? Icons.check_circle : Icons.upload_file,
                color: uploadState.fileName != null ? Colors.green : null,
              ),
              title: const Text('Resume Upload'),
              subtitle: Text(uploadState.fileName ?? 'No file selected'),
            ),
            ElevatedButton(
              onPressed: uploadState.isLoading
                  ? null
                  : () => uploadState.pickResumeFile(),
              child: const Text('Select PDF Resume'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyzeButton(UploadState uploadState) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: uploadState.isLoading ||
            _jobDetailsController.text.isEmpty ||
            uploadState.fileName == null
            ? null
            : () async {
          final success = await uploadState.analyzeResume(
            _jobDetailsController.text,
          );

          if (success && context.mounted) {
            Navigator.pushNamed(context, '/results');
          }
        },
        child: uploadState.isLoading
            ? const CircularProgressIndicator()
            : const Text('Run Model', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}