import 'package:provider/provider.dart';
import 'package:transactions/data/model/transaction_partner.dart';
import 'package:transactions/ui/company/company_select.dart';
import 'package:transactions/ui/core/themes/dimens.dart';
import 'package:transactions/ui/core/ui/address_input.dart';
import 'package:transactions/ui/details/details_view.dart';
import 'package:transactions/ui/transaction_partner/transaction_partner_details_viewmodel.dart';
import 'package:flutter/material.dart';

class TransactionPartnerDetails
    extends
        DetailsView<
          TransactionPartner,
          TransactionPartnerDetails,
          TransactionPartnerDetailsViewmodel
        > {
  const TransactionPartnerDetails({super.key, required super.viewmodel});

  @override
  State<TransactionPartnerDetails> createState() =>
      _TransactionPartnerDetailsState();
}

class _TransactionPartnerDetailsState
    extends
        DetailsState<
          TransactionPartner,
          TransactionPartnerDetails,
          TransactionPartnerDetailsViewmodel
        > {
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
        final transactionPartner = widget.viewmodel.entity;
        if (transactionPartner != null) {
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
                        text: "T.-Partny ",
                        style: TextStyle(fontWeight: FontWeight.w200),
                      ),
                      TextSpan(
                        text: transactionPartner.displayShort.isEmpty
                            ? "#${transactionPartner.id}"
                            : transactionPartner.displayShort,
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
              ),
              body: ListView(
                padding: EdgeInsets.symmetric(
                  vertical: Dimens.of(context).paddingScreenVertical,
                  horizontal: Dimens.of(context).paddingScreenHorizontal,
                ),
                children: [
                  TextFormField(
                    controller: TextEditingController(
                      text: transactionPartner.name,
                    ),
                    onChanged: (value) => transactionPartner.name = value,
                    decoration: InputDecoration(label: Text("Name")),
                  ),
                  SizedBox(height: Dimens.vgap),
                  CompanySelect(
                    repository: context.read(),
                    initialValue: transactionPartner.company,
                    onSelect: (l) => transactionPartner.company = l,
                  ),
                  SizedBox(height: Dimens.vdivide),
                  AddressInput(addressable: transactionPartner),
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
  String get typeDisplay => "T.-Partny";
}
