import 'package:flutter/material.dart';
import 'package:resume_analyzer/screens/home_screen.dart';
import 'package:resume_analyzer/screens/resume_uploader_screen.dart';
import 'package:resume_analyzer/screens/analysis_result_screen.dart';
import 'package:resume_analyzer/screens/settings_screen.dart';
import 'package:resume_analyzer/screens/upload%20state.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UploadState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Resume Analyzer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        '/': (context) => const HomeScreen(),
        '/upload': (context) => const ResumeUploaderScreen(),
        '/results': (context) =>  AnalysisResultScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
      initialRoute: '/',
    );
  }
}