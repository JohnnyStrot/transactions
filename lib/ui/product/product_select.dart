import 'package:transactions/data/model/product.dart';
import 'package:transactions/data/repositories/product/product_repository.dart';
import 'package:transactions/ui/core/themes/dimens.dart';
import 'package:transactions/ui/core/ui/entity_select_box.dart';
import 'package:flutter/material.dart';
import 'package:transactions/utils/double_to_string_extension.dart';

class ProductSelect extends EntitySelectBox<Product> {
  const ProductSelect({
    super.key,
    required ProductRepository super.repository,
    required super.onSelect,
    super.initialValue,
  });

  @override
  Widget buildItem(
    BuildContext context,
    Product item,
    bool isDisabled,
    bool isSelected,
  ) => Row(
    spacing: Dimens.hdivide,
    children: [
      Expanded(
        flex: 3,
        child: Text(
          entityAsString(item),
          overflow: TextOverflow.ellipsis,
          style: TextTheme.of(context).headlineSmall!.copyWith(fontSize: 14),
        ),
      ),
    ],
  );

  @override
  Map<String, dynamic> createFilter(String filter) => <String, dynamic>{
    "name": filter,
  };

  @override
  String entityAsString(Product? entity) {
    if (entity == null) {
      return "";
    }
    return [
      entity.displayShort,
      if (entity.size != null || entity.unit.isNotEmpty)
        "(${entity.size?.toReadableString() ?? ""}${entity.unit})",
    ].join(" ");
  }

  @override
  String get label => "Produkt";
  @override
  String get order => "name";
}
