import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation_sample/cubit/sample_cubit.dart';
import '../../sample_repository.dart';
import 'sample_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DataCubit>(
      create: (_) => DataCubit(DataRepository()),
      child: const MaterialApp(home: DataScreen()),
    );
  }
}