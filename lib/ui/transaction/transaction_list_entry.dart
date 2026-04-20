import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:transactions/data/model/transaction.dart';
import 'package:transactions/routing/routes.dart';
import 'package:transactions/ui/core/themes/dimens.dart';
import 'package:transactions/ui/core/ui/price_badge.dart';
import 'package:transactions/ui/entity/entity_list_entry.dart';

class TransactionListEntry extends EntityListEntry<Transaction> {
  const TransactionListEntry({
    super.key,
    required super.entity,
    required super.onDelete,
  });

  @override
  String route(op) => Routes.transactions;

  @override
  Widget buildContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: Dimens.vgap,
      children: [
        Row(
          spacing: Dimens.hgap,
          children: [
            Expanded(
              child: Text(
                BoardDateFormat("yyyy-MM-dd HH:mm:ss").format(entity.timestamp),
              ),
            ),
            PriceBadge(entity.value, bold: true),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Text.rich(
                overflow: TextOverflow.ellipsis,
                TextSpan(
                  children: [
                    if (entity.transactionPartner != null)
                      TextSpan(
                        text: entity.transactionPartner!.title,
                        style: TextTheme.of(
                          context,
                        ).bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                      ),
                    if ((entity.transactionPartner?.subtitle ?? "").isNotEmpty)
                      TextSpan(text: " ${entity.transactionPartner!.subtitle}"),
                    if (entity.transactionPartner != null &&
                        entity.transactionPartner!.city.isNotEmpty)
                      TextSpan(text: ", ${entity.transactionPartner!.city}"),
                  ],
                ),
              ),
            ),
            if (entity.remark.isNotEmpty)
              Text(
                entity.remark,
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
          ],
        ),
      ],
    );
  }

  @override
  String entityToString(Transaction opp) => opp.displayShort;
}
