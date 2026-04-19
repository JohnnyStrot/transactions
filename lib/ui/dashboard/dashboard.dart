import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transactions/ui/product/product_picker.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ProductPicker(repository: context.read(), onSelect: (p) {}),
    );
  }
}
