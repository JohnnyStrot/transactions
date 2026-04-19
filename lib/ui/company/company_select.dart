import 'package:transactions/data/model/company.dart';
import 'package:transactions/data/repositories/company/company_repository.dart';
import 'package:transactions/ui/core/themes/dimens.dart';
import 'package:transactions/ui/core/ui/entity_select_box.dart';
import 'package:flutter/material.dart';

class CompanySelect extends EntitySelectBox<Company> {
  const CompanySelect({
    super.key,
    required CompanyRepository super.repository,
    required super.onSelect,
    super.initialValue,
  });

  @override
  Widget buildItem(
    BuildContext context,
    Company item,
    bool isDisabled,
    bool isSelected,
  ) => Row(
    spacing: Dimens.hdivide,
    children: [
      Expanded(
        flex: 3,
        child: Text(
          item.name,
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
  String entityAsString(Company? entity) => entity?.displayShort ?? "";

  @override
  String get label => "Marke";
  @override
  String get order => "name";
}
