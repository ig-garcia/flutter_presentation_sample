import 'package:flutter/material.dart';
import 'package:presentation_sample/mvvm/provider/view_model_provider.dart';

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
              renderProcessedData(viewModel),
              FloatingActionButton(
                onPressed: () {
                  viewModel.counterAdd();
                },
                child: const Text("Add"),
              ),
              renderCount(viewModel),
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

  StreamBuilder<String> renderProcessedData(DataViewModel viewModel) {
    return StreamBuilder<String>(
      stream: viewModel.processedDataStream,
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
}
