import 'package:flutter/material.dart';
import 'package:presentation_sample/effect.dart';
import 'package:presentation_sample/mvvm/provider/view_model_provider.dart';
import 'package:presentation_sample/mvvm/sample_effect.dart';

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
              renderState(viewModel),
              FloatingActionButton(
                onPressed: () {
                  viewModel.counterAdd();
                },
                child: const Text("Add"),
              ),
              renderCount(viewModel),
              renderEffect(viewModel),
            ],
          ),
        )
    );
  }

  StreamBuilder<int> renderCount(DataViewModel viewModel) {
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

  StreamBuilder<String> renderState(DataViewModel viewModel) {
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

  StreamBuilder<OneTimeEffect<SampleEffect>> renderEffect(DataViewModel viewModel) {
    return StreamBuilder<OneTimeEffect<SampleEffect>>(
      stream: viewModel.effectSteam,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final effect = snapshot.data!.getContentIfNotHandled();
          if (effect != null && effect is NewCount) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showSnackBar(context, effect);
            });
          }
        }
        return const SizedBox();
      },
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
