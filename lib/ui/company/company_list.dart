import 'package:transactions/data/model/company.dart';
import 'package:transactions/routing/routes.dart';
import 'package:transactions/ui/company/company_list_entry.dart';
import 'package:transactions/ui/core/themes/dimens.dart';
import 'package:transactions/ui/list_widgets/data_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_command/flutter_command.dart';

import 'company_list_viewmodel.dart';

class CompanyList
    extends DataListView<Company, CompanyListViewmodel, CompanyList> {
  const CompanyList({super.key, required super.viewmodel});

  @override
  State<CompanyList> createState() => _CompanyListState();
}

class _CompanyListState
    extends DataListViewState<Company, CompanyListViewmodel, CompanyList> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  @override
  void initState() {
    nameController
        .debounce(Durations.medium2)
        .listen((text, _) => widget.viewmodel.nameChanged(text.text));
    super.initState();
  }

  @override
  Widget buildEntry(BuildContext context, Company entity) {
    return CompanyListEntry(entity: entity, onDelete: (tp) => delete(tp));
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
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  String get entityDisplay => "Marken";

  @override
  String get route => Routes.companies;
}
