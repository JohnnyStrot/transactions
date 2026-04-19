import 'package:transactions/data/model/entity.dart';
import 'package:transactions/ui/details/details_viewmodel.dart';
import 'package:transactions/utils/result.dart';
import 'package:flutter/material.dart';

abstract class DetailsView<
  T extends StrongEntity,
  V extends DetailsView<T, V, M>,
  M extends DetailsViewmodel<T, M>
>
    extends StatefulWidget {
  const DetailsView({super.key, required this.viewmodel});

  final M viewmodel;
}

abstract class DetailsState<
  T extends StrongEntity,
  V extends DetailsView<T, V, M>,
  M extends DetailsViewmodel<T, M>
>
    extends State<V>
    with AutomaticKeepAliveClientMixin<V> {
  final formKey = GlobalKey<FormState>();

  String get typeDisplay;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    widget.viewmodel.saveEntity.addListener(_onSaved);
  }

  @override
  void didUpdateWidget(covariant V oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewmodel.saveEntity.removeListener(_onSaved);
    widget.viewmodel.saveEntity.addListener(_onSaved);
  }

  @override
  void dispose() {
    widget.viewmodel.saveEntity.removeListener(_onSaved);
    super.dispose();
  }

  void submit() {
    if (formKey.currentState != null && formKey.currentState!.validate()) {
      widget.viewmodel.saveEntity.execute();
    }
  }

  void _onSaved() {
    if (!widget.viewmodel.saveEntity.isExecuting.value) {
      switch (widget.viewmodel.saveEntity.value) {
        case Ok<void>():
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("$typeDisplay gespeichert")));
        case Error<void>():
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("$typeDisplay konnte nicht gespeichert werden"),
              action: SnackBarAction(
                label: "Nochmal",
                onPressed: widget.viewmodel.saveEntity.execute,
              ),
            ),
          );
      }
    }
  }
}
