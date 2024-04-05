import 'dart:async';

import 'package:flutter/material.dart';
import 'package:presentation_sample/sample_repository.dart';

import '../../effect.dart';
import '../sample_effect.dart';
import '../sample_view_model.dart';

class DataScreen extends StatefulWidget {
  const DataScreen({super.key});

  @override
  State<StatefulWidget> createState() => _DataState();
}

class _DataState extends State<DataScreen> {
  late final DataViewModel viewModel;
  StreamSubscription<OneTimeEffect<SampleEffect>>? _snackBarStreamSubscription;

  @override
  void initState() {
    super.initState();
    viewModel = DataViewModel(DataRepository());
  }

  @override
  void dispose() {
    _snackBarStreamSubscription?.cancel();
    viewModel.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Access the ViewModel provided by Provider
    return Scaffold(
      appBar: AppBar(title: const Text('Data Stream Example')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          renderEffectAndState(),
          FloatingActionButton(
            onPressed: () {
              viewModel.counterAdd();
            },
            child: const Text("Add"),
          ),
          renderCount(),
          //renderEffect(),
        ],
      ),
    );
  }

  ValueListenableBuilder<int> renderCount() {
    return ValueListenableBuilder<int>(
      valueListenable: viewModel.counterValueNotifier,
      builder: (_, count, child) {
        return Center(
          child: Text("Count: $count"),
        );
      },
    );
  }

  ValueListenableBuilder<String> renderState() {
    return ValueListenableBuilder<String>(
      valueListenable: viewModel.stateValueNotifier,
      builder: (_, state, child) {
        return Center(
          child: Text(state),
        );
      },
    );
  }

  ValueListenableBuilder<OneTimeEffect<SampleEffect>> renderEffectAndState() {
    return ValueListenableBuilder<OneTimeEffect<SampleEffect>>(
      valueListenable: viewModel.effectValueNotifier,
      builder: (context, oneTimeEffect, child) {
        final effect = oneTimeEffect.getContentIfNotHandled();
        if (effect != null && effect is NewCount) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showSnackBar(effect);
          });
        }
        return child!;
      },
      child: renderState(),
    );
  }

  void _showSnackBar(NewCount effect) {
    final snackBar = SnackBar(
      content: Text('new count: ${effect.count}'),
      duration: const Duration(milliseconds: 400),
    );
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

}
