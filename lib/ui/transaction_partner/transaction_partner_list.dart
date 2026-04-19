import 'package:transactions/data/model/transaction_partner.dart';
import 'package:transactions/routing/routes.dart';
import 'package:transactions/ui/core/themes/dimens.dart';
import 'package:transactions/ui/list_widgets/data_list_view.dart';
import 'package:transactions/ui/transaction_partner/transaction_partner_list_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_command/flutter_command.dart';

import 'transaction_partner_list_viewmodel.dart';

class TransactionPartnerList
    extends
        DataListView<
          TransactionPartner,
          TransactionPartnerListViewmodel,
          TransactionPartnerList
        > {
  const TransactionPartnerList({super.key, required super.viewmodel});

  @override
  State<TransactionPartnerList> createState() => _TransactionPartnerListState();
}

class _TransactionPartnerListState
    extends
        DataListViewState<
          TransactionPartner,
          TransactionPartnerListViewmodel,
          TransactionPartnerList
        > {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController companyController = TextEditingController();

  @override
  void initState() {
    nameController
        .debounce(Durations.medium2)
        .listen((text, _) => widget.viewmodel.nameChanged(text.text));
    cityController
        .debounce(Durations.medium2)
        .listen((text, _) => widget.viewmodel.cityChanged(text.text));
    companyController
        .debounce(Durations.medium2)
        .listen((text, _) => widget.viewmodel.companyChanged(text.text));
    super.initState();
  }

  @override
  Widget buildEntry(BuildContext context, TransactionPartner entity) {
    return TransactionPartnerListEntry(
      entity: entity,
      onDelete: (tp) => delete(tp),
    );
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
            Expanded(
              child: TextField(
                controller: companyController,
                decoration: InputDecoration(
                  label: Text("Firma"),
                  suffixIcon: IconButton(
                    onPressed: () {
                      companyController.clear();
                    },
                    icon: Icon(Icons.clear),
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        Row(
          spacing: Dimens.paddingHorizontal,
          children: [
            Expanded(
              child: TextField(
                controller: cityController,
                decoration: InputDecoration(
                  label: Text("Stadt"),
                  suffixIcon: IconButton(
                    onPressed: () {
                      cityController.clear();
                    },
                    icon: Icon(Icons.clear),
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(child: SizedBox()),
          ],
        ),
      ],
    );
  }

  @override
  String get entityDisplay => "Transaktions-Partnys";

  @override
  String get route => Routes.transactionPartners;
}
