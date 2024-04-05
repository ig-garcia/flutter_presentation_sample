import 'package:flutter/material.dart';
import 'package:presentation_sample/mvvm_valuenotifier/provider/sample_screen.dart';
import 'package:presentation_sample/mvvm_valuenotifier/provider/view_model_provider.dart';

import '../../sample_repository.dart';
import '../sample_view_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<DataViewModel>(
      create: (_) => DataViewModel(DataRepository()),
      child: const MaterialApp(home: DataScreen()),
    );
  }
}