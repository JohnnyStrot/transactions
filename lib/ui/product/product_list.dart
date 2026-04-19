import 'package:transactions/data/model/product.dart';
import 'package:transactions/routing/routes.dart';
import 'package:transactions/ui/core/themes/dimens.dart';
import 'package:transactions/ui/list_widgets/data_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_command/flutter_command.dart';
import 'package:transactions/ui/product/product_list_entry.dart';

import 'product_list_viewmodel.dart';

class ProductList
    extends DataListView<Product, ProductListViewmodel, ProductList> {
  const ProductList({super.key, required super.viewmodel});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState
    extends DataListViewState<Product, ProductListViewmodel, ProductList> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController producerController = TextEditingController();

  @override
  void initState() {
    nameController
        .debounce(Durations.medium2)
        .listen((text, _) => widget.viewmodel.nameChanged(text.text));
    producerController
        .debounce(Durations.medium2)
        .listen((text, _) => widget.viewmodel.producerChanged(text.text));
    super.initState();
  }

  @override
  Widget buildEntry(BuildContext context, Product entity) {
    return ProductListEntry(entity: entity, onDelete: (tp) => delete(tp));
  }

  @override
  Widget buildSearch(BuildContext context) {
    return Column(
      spacing: Dimens.vgap,
      children: [
        Row(
          spacing: Dimens.paddingHorizontal,
          children: [
            Expanded(
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  label: Text("Name"),
                  suffixIcon: IconButton(
                    onPressed: () {
                      nameController.clear();
                    },
                    icon: Icon(Icons.clear),
                  ),
                  filled: true,
                  border: UnderlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              child: TextField(
                controller: producerController,
                decoration: InputDecoration(
                  label: Text("Hersteller"),
                  suffixIcon: IconButton(
                    onPressed: () {
                      producerController.clear();
                    },
                    icon: Icon(Icons.clear),
                  ),
                  filled: true,
                  border: UnderlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  String get entityDisplay => "Produkte";

  @override
  String get route => Routes.products;
}
