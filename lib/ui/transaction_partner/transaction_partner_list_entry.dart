import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:transactions/data/model/transaction_partner.dart';
import 'package:transactions/routing/routes.dart';
import 'package:transactions/ui/entity/entity_list_entry.dart';

class TransactionPartnerListEntry extends EntityListEntry<TransactionPartner> {
  const TransactionPartnerListEntry({
    super.key,
    required super.entity,
    required super.onDelete,
  });

  @override
  String route(op) => Routes.transactionPartners;

  @override
  String entityToString(TransactionPartner opp) => opp.displayShort;

  @override
  Widget buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Row(
          spacing: 5,
          children: [
            Text(
              entity.company?.name ?? entity.name,
              overflow: TextOverflow.ellipsis,
              style: TextTheme.of(context).displaySmall!.copyWith(
                fontSize: TextTheme.of(context).bodyLarge!.fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (entity.company != null) Text(entity.name),
          ],
        ),
        if (entity.city.isNotEmpty)
          Text(
            "${entity.street.isNotEmpty ? "${entity.street}, " : ""}${entity.city}",
          ),
      ],
    );
  }
}
