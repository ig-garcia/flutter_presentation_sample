import 'package:flutter/widgets.dart';
import 'package:presentation_sample/mvvm_valuenotifier/base_view_model.dart';
import 'package:provider/provider.dart';

class ViewModelProvider<T extends BaseViewModel> extends Provider<T> {
  ViewModelProvider({
    super.key,
    required super.create,
    super.lazy,
    super.builder,
    super.child,
  }) : super(
          dispose: (_, viewModel) => viewModel.close(),
        );
}

class ViewModelBuilder<T extends BaseViewModel> extends Builder {
  ViewModelBuilder({super.key, required Widget Function(T viewModel) child})
      : super(builder: (context) {
          final viewModel = context.read<T>();
          return child(viewModel);
        });
}
