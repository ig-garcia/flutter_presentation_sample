import 'package:flutter/material.dart';
import 'package:presentation_sample/effect.dart';
import 'package:presentation_sample/mvvm_valuenotifier/provider/view_model_provider.dart';
import 'package:presentation_sample/mvvm_valuenotifier/sample_effect.dart';

import '../sample_view_model.dart';

class DataScreen extends StatelessWidget {
  const DataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DataViewModel>(child: (viewModel) =>
        Scaffold(
          appBar: AppBar(title: const Text('Data Stream Example')),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              renderEffectAndState(viewModel),
              FloatingActionButton(
                onPressed: () {
                  viewModel.counterAdd();
                },
                child: const Text("Add"),
              ),
              renderCount(viewModel),
              //renderEffectAndState(viewModel),
            ],
          ),
        )
    );
  }

  ValueListenableBuilder<int> renderCount(DataViewModel viewModel) {
    return ValueListenableBuilder<int>(
      valueListenable: viewModel.counterValueNotifier,
      builder: (_, count, child) {
        return Center(
          child: Text("Count: $count"),
        );
      },
    );
  }

  ValueListenableBuilder<String> renderState(DataViewModel viewModel) {
    return ValueListenableBuilder<String>(
      valueListenable: viewModel.stateValueNotifier,
      builder: (_, state, child) {
        return Center(
          child: Text(state),
        );
      },
    );
  }

  ValueListenableBuilder<OneTimeEffect<SampleEffect>> renderEffectAndState(DataViewModel viewModel) {
    return ValueListenableBuilder<OneTimeEffect<SampleEffect>>(
      valueListenable: viewModel.effectValueNotifier,
      builder: (context, oneTimeEffect, child) {
        final effect = oneTimeEffect.getContentIfNotHandled();
        if (effect != null && effect is NewCount) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showSnackBar(context, effect);
          });
        }
        return child!;
      },
      child: renderState(viewModel),
    );
  }

  void _showSnackBar(BuildContext context, NewCount effect) {
    final snackBar = SnackBar(
      content: Text('new count: ${effect.count}'),
      duration: const Duration(milliseconds: 400),
    );
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
