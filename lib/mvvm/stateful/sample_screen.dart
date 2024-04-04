import 'package:flutter/material.dart';
import 'package:presentation_sample/sample_repository.dart';

import '../sample_view_model.dart';

class DataScreen extends StatefulWidget {
  const DataScreen({super.key});

  @override
  State<StatefulWidget> createState() => _DataState();
}

class _DataState extends State<DataScreen> {
  late final DataViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = DataViewModel(DataRepository());
  }

  @override
  void dispose() {
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
