import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation_sample/cubit/data_state.dart';
import 'package:presentation_sample/sample_repository.dart';

import '../sample_cubit.dart';

class DataScreen extends StatefulWidget {
  const DataScreen({super.key});

  @override
  State<StatefulWidget> createState() => _DataState();
}

class _DataState extends State<DataScreen> {
  late final DataCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = DataCubit(DataRepository());
  }

  @override
  void dispose() {
    cubit.close();
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
              cubit.counterAdd();
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
      stream: cubit.counterStream,
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

  Widget renderProcessedData() {
    return BlocBuilder<DataCubit, DataState>(
        bloc: cubit,
        builder: (_, state) {
          if (state is NoDataYet) {
            return const CircularProgressIndicator();
          } else if (state is GotData) {
            return Center(
              child: Text(state.data),
            );
          }
          return const SizedBox();
        });
  }
}
