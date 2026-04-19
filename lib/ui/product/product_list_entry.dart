import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:transactions/data/model/product.dart';
import 'package:transactions/routing/routes.dart';
import 'package:transactions/ui/entity/entity_list_entry.dart';
import 'package:transactions/utils/double_to_string_extension.dart';

class ProductListEntry extends EntityListEntry<Product> {
  const ProductListEntry({
    super.key,
    required super.entity,
    required super.onDelete,
  });

  @override
  String route(op) => Routes.products;

  @override
  String entityToString(Product opp) => opp.displayShort;

  @override
  Widget buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Row(
          spacing: 5,
          children: [
            if (entity.producer != null && entity.name.isNotEmpty)
              Text(entity.producer!.name),
            Expanded(
              child: Text(
                entity.name.isNotEmpty
                    ? entity.name
                    : entity.producer?.name ?? "",
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: TextTheme.of(context).displaySmall!.copyWith(
                  fontSize: TextTheme.of(context).bodyLarge!.fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              [
                "${entity.size?.toReadableString() ?? ""}${entity.unit}",
                entity.package,
              ].join(" "),
            ),
          ],
        ),
      ],
    );
  }
}
