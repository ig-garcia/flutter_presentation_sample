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
    // when using a stateful widget there is the option of subscribing to viewmodel streams here.
    // for more usability it seems easier to do it with StreamBuilder as we can also build whatever we need.
    //_subscribeToSnackBarStream();
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
          renderProcessedData(),
          FloatingActionButton(
            onPressed: () {
              viewModel.counterAdd();
            },
            child: const Text("Add"),
          ),
          renderCount(),
          renderEffect(),
        ],
      ),
    );
  }

  StreamBuilder<int> renderCount() {
    return StreamBuilder<int>(
      stream: viewModel.counterStream,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        return Center(
          child: Text("Count: ${snapshot.data ?? "no data"}"),
        );
      },
    );
  }

  StreamBuilder<String> renderProcessedData() {
    return StreamBuilder<String>(
      stream: viewModel.stateSteam,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        return Center(
          child: Text(snapshot.data ?? 'No data'),
        );
      },
    );
  }

  StreamBuilder<OneTimeEffect<SampleEffect>> renderEffect() {
    return StreamBuilder<OneTimeEffect<SampleEffect>>(
      stream: viewModel.effectSteam,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final effect = snapshot.data!.getContentIfNotHandled();
          if (effect != null && effect is NewCount) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showSnackBar(effect);
            });
          }
        }
        return const SizedBox();
      },
    );
  }

  void _subscribeToSnackBarStream() {
    // Assuming `snackBarStream` is your Stream<String> for SnackBar messages
    _snackBarStreamSubscription = viewModel.effectSteam.listen((oneTimeEffect) {
      final effect = oneTimeEffect.getContentIfNotHandled();
      if (effect != null && effect is NewCount) {
        _showSnackBar(effect);
      }
    }, onError: (error) {}, onDone: () {}, cancelOnError: false);
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
