import 'package:transactions/data/model/transaction_partner.dart';
import 'package:transactions/data/repositories/transaction_partner/transaction_partner_repository.dart';
import 'package:transactions/ui/core/themes/dimens.dart';
import 'package:transactions/ui/core/ui/entity_select_box.dart';
import 'package:flutter/material.dart';

class TransactionPartnerSelect extends EntitySelectBox<TransactionPartner> {
  const TransactionPartnerSelect({
    super.key,
    required TransactionPartnerRepository super.repository,
    required super.onSelect,
    super.initialValue,
  });

  @override
  Widget buildItem(
    BuildContext context,
    TransactionPartner item,
    bool isDisabled,
    bool isSelected,
  ) => Row(
    spacing: Dimens.hdivide,
    children: [
      Expanded(
        flex: 3,
        child: Text(
          item.company?.name ?? item.name,
          overflow: TextOverflow.ellipsis,
          style: TextTheme.of(context).headlineSmall!.copyWith(fontSize: 14),
        ),
      ),
      Expanded(
        flex: 2,
        child: Text(item.city, overflow: TextOverflow.ellipsis),
      ),
      Expanded(
        flex: 2,
        child: Text(item.street, overflow: TextOverflow.ellipsis),
      ),
    ],
  );

  @override
  Map<String, dynamic> createFilter(String filter) => <String, dynamic>{
    "name": filter,
  };

  @override
  String entityAsString(TransactionPartner? entity) =>
      entity?.displayShort ?? "";

  @override
  String get label => "Transaktions-Partny";
  @override
  String get order => "name";
}
