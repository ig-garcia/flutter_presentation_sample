import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation_sample/cubit/data_state.dart';

import '../sample_cubit.dart';

class DataScreen extends StatelessWidget {
  const DataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the ViewModel provided by Provider
    final cubit = BlocProvider.of<DataCubit>(context, listen: false);
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
          renderCount(cubit),
        ],
      ),
    );
  }

  StreamBuilder<int> renderCount(DataCubit cubit) {
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
    return BlocBuilder<DataCubit, DataState>(builder: (_, state) {
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
