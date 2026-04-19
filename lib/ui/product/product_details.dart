import 'package:provider/provider.dart';
import 'package:transactions/data/model/product.dart';
import 'package:transactions/ui/company/company_picker.dart';
import 'package:transactions/ui/core/themes/dimens.dart';
import 'package:transactions/ui/details/details_view.dart';
import 'package:flutter/material.dart';
import 'package:transactions/ui/product/product_details_viewmodel.dart';
import 'package:transactions/ui/product/product_select.dart';
import 'package:transactions/utils/double_to_string_extension.dart';

class ProductDetails
    extends DetailsView<Product, ProductDetails, ProductDetailsViewmodel> {
  const ProductDetails({super.key, required super.viewmodel});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState
    extends DetailsState<Product, ProductDetails, ProductDetailsViewmodel> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListenableBuilder(
      listenable: Listenable.merge([
        widget.viewmodel.createEntity,
        widget.viewmodel.loadEntity,
        widget.viewmodel.saveEntity,
      ]),
      builder: (context, _) {
        final product = widget.viewmodel.entity;
        if (product != null) {
          return Form(
            key: formKey,
            child: Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: submit,
                child: Icon(Icons.save),
              ),

              appBar: AppBar(
                title: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Produkt ",
                        style: TextStyle(fontWeight: FontWeight.w200),
                      ),
                      TextSpan(
                        text: product.displayShort.isEmpty
                            ? "#${product.id}"
                            : product.displayShort,
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                    style: TextTheme.of(context).headlineSmall!.copyWith(
                      fontSize: 16,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    onPressed: () => setState(() {
                      product.favorite = !product.favorite;
                    }),
                    icon: Icon(
                      Icons.star,
                      color: product.favorite
                          ? Colors.amber
                          : ColorScheme.of(context).onPrimaryContainer,
                    ),
                  ),
                ],
              ),
              body: ListView(
                padding: EdgeInsets.symmetric(
                  vertical: Dimens.of(context).paddingScreenVertical,
                  horizontal: Dimens.of(context).paddingScreenHorizontal,
                ),
                children: [
                  CompanyPicker(
                    repository: context.read(),
                    initialValue: product.producer,
                    onSelect: (c) => product.producer = c,
                  ),
                  SizedBox(height: Dimens.vgap),
                  TextFormField(
                    controller: TextEditingController(text: product.name),
                    onChanged: (value) => product.name = value,
                    decoration: InputDecoration(label: Text("Name")),
                  ),
                  SizedBox(height: Dimens.vgap),
                  ProductSelect(
                    repository: context.read(),
                    onSelect: (l) => product.parent = l,
                    initialValue: product.parent,
                  ),
                  SizedBox(height: Dimens.vdivide * 3),
                  Row(
                    spacing: Dimens.hgap,
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: product.size?.toReadableString(),
                          keyboardType: TextInputType.number,
                          validator: (value) =>
                              value == null ||
                                  value.isEmpty ||
                                  double.tryParse(value) != null
                              ? null
                              : "Ungültige Zahl",
                          decoration: InputDecoration(labelText: "VP-Größe"),
                          onChanged: (value) =>
                              product.size = double.tryParse(value),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          initialValue: product.unit,
                          onChanged: (value) => product.unit = value,
                          decoration: InputDecoration(label: Text("Einheit")),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimens.vgap),
                  Row(
                    spacing: Dimens.hgap,
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: product.package,
                          onChanged: (value) => product.package = value,
                          decoration: InputDecoration(
                            label: Text("Verpackung"),
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          initialValue: product.deposit?.toReadableString(),
                          keyboardType: TextInputType.number,
                          validator: (value) =>
                              value == null || double.tryParse(value) != null
                              ? null
                              : "Ungültige Zahl",
                          decoration: InputDecoration(labelText: "Pfand"),
                          onChanged: (value) =>
                              product.deposit = double.tryParse(value),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimens.vgap),
                  Row(
                    spacing: Dimens.hgap,
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: product.link,
                          onChanged: (value) => product.link = value,
                          decoration: InputDecoration(label: Text("Link")),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          initialValue: product.imageLink,
                          onChanged: (value) => product.imageLink = value,
                          decoration: InputDecoration(
                            label: Text("Bild (Link)"),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimens.vgap),
                  Row(
                    spacing: Dimens.hgap,
                    children: [
                      Checkbox(
                        value: product.vegetarian,
                        onChanged: (value) => setState(() {
                          product.vegetarian = value;
                        }),
                        tristate: true,
                      ),
                      Expanded(child: Text("Vegetarisch")),
                      Checkbox(
                        value: product.lactoseFree,
                        onChanged: (value) => setState(() {
                          product.lactoseFree = value;
                        }),
                        tristate: true,
                      ),
                      Expanded(child: Text("Laktosefrei")),
                    ],
                  ),
                  SizedBox(height: Dimens.vgap),
                  Row(
                    spacing: Dimens.hgap,
                    children: [
                      Checkbox(
                        value: product.vegan,
                        onChanged: (value) => setState(() {
                          product.vegan = value;
                        }),
                        tristate: true,
                      ),
                      Expanded(child: Text("Vegan")),
                      Checkbox(
                        value: product.glutenFree,
                        onChanged: (value) => setState(() {
                          product.glutenFree = value;
                        }),
                        tristate: true,
                      ),
                      Expanded(child: Text("Glutenfrei")),
                    ],
                  ),
                ],
              ),
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  String get typeDisplay => "Produkt";
}
