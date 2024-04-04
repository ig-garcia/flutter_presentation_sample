import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation_sample/bloc/data_event.dart';
import '../../sample_repository.dart';
import '../sample_bloc.dart';
import 'sample_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DataBloc>(
      create: (_) => DataBloc(DataRepository()),
      child: const MaterialApp(home: DataScreen()),
    );
  }
}