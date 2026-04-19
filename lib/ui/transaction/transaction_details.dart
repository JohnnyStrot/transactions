import 'package:provider/provider.dart';
import 'package:transactions/data/model/transaction.dart';
import 'package:transactions/data/model/transaction_part.dart';
import 'package:transactions/ui/core/themes/dimens.dart';
import 'package:transactions/ui/core/ui/price_badge.dart';
import 'package:transactions/ui/details/details_view.dart';
import 'package:flutter/material.dart';
import 'package:transactions/ui/product/product_picker.dart';
import 'package:transactions/ui/transaction/transaction_details_viewmodel.dart';
import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:transactions/ui/transaction_partner/transaction_partner_picker.dart';
import 'package:transactions/utils/double_to_string_extension.dart';

class TransactionDetails
    extends
        DetailsView<
          Transaction,
          TransactionDetails,
          TransactionDetailsViewmodel
        > {
  const TransactionDetails({super.key, required super.viewmodel});

  @override
  State<TransactionDetails> createState() => _TransactionDetailsState();
}

class _TransactionDetailsState
    extends
        DetailsState<
          Transaction,
          TransactionDetails,
          TransactionDetailsViewmodel
        >
    with SingleTickerProviderStateMixin {
  ValueNotifier<DateTime> dateChanged = ValueNotifier(DateTime.now());

  TransactionPart? editingPart;
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    dateChanged.addListener(() {
      widget.viewmodel.entity?.timestamp = dateChanged.value;
    });
    super.initState();
  }

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
        final transaction = widget.viewmodel.entity;
        if (transaction != null) {
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
                        text: "Transaktion ",
                        style: TextStyle(fontWeight: FontWeight.w200),
                      ),
                      TextSpan(
                        text: "#${transaction.id}",
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
                bottom: TabBar(
                  controller: tabController,
                  tabs: [
                    Tab(text: "Daten"),
                    Tab(text: "Inhalt"),
                  ],
                ),
              ),
              body: TabBarView(
                controller: tabController,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: Dimens.of(context).paddingScreenVertical,
                          horizontal: Dimens.of(
                            context,
                          ).paddingScreenHorizontal,
                        ),
                        child: Column(
                          children: [
                            BoardDateTimeInputField(
                              decoration: InputDecoration(
                                labelText: "Zeitstempel",
                              ),
                              options: BoardDateTimeOptions(
                                withSecond: true,
                                boardTitle: "Zeitstempel",
                                languages: BoardPickerLanguages(
                                  today: "Heute",
                                  tomorrow: "Morgen",
                                  yesterday: "Gestern",
                                  now: "Jetzt",
                                  locale: "de",
                                ),
                                actionButtonTypes: [
                                  BoardDateButtonType.yesterday,
                                  BoardDateButtonType.today,
                                  BoardDateButtonType.tomorrow,
                                ],
                                pickerFormat: PickerFormat.dmy,
                                startDayOfWeek: DateTime.monday,
                              ),
                              initialDate: transaction.timestamp,
                              onChanged: (date) => transaction.timestamp = date,
                            ),
                            SizedBox(height: Dimens.vgap),
                            TextFormField(
                              controller: TextEditingController(
                                text: transaction.remark,
                              ),
                              onChanged: (value) => transaction.remark = value,
                              decoration: InputDecoration(
                                label: Text("Bemerkung"),
                              ),
                            ),
                            SizedBox(height: Dimens.vgap),
                            TransactionPartnerPicker(
                              repository: context.read(),
                              onSelect: (l) =>
                                  transaction.transactionPartner = l,
                              initialValue: transaction.transactionPartner,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: Dimens.vdivide),
                      Expanded(child: contentTable(transaction, false)),
                    ],
                  ),
                  contentTable(transaction, true),
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

  void addPart() async {
    var part = await widget.viewmodel.createPart();
    if (part != null) {
      setState(() {
        widget.viewmodel.entity?.transactionParts.insert(0, part);
        editingPart = part;
      });
    }
  }

  void editPart(TransactionPart part) {
    setState(() {
      editingPart = part;
    });
  }

  void finishEditing() {
    setState(() {
      editingPart = null;
    });
  }

  void deletePart(TransactionPart part) {
    setState(() {
      widget.viewmodel.entity?.transactionParts.remove(part);
    });
  }

  String partContentText(TransactionPart part) => [
    if (part.amount != null) part.amount!.toReadableString(digits: 3),
    if (part.product != null) part.product!.displayShort,
    part.purpose,
  ].join(" ");

  Widget contentTable(Transaction transaction, bool canEdit) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: ColorScheme.of(context).surfaceBright,
          ),
          padding: EdgeInsets.symmetric(vertical: Dimens.vgap),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 70,
                child: PriceBadge(transaction.value, bold: true),
              ),
              Expanded(
                child: Text(
                  "${transaction.transactionParts.length} Posten",
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
              IconButton(
                onPressed: canEdit
                    ? addPart
                    : () {
                        addPart();
                        tabController.animateTo(1);
                      },
                icon: Icon(Icons.add),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: transaction.transactionParts.length,
            itemBuilder: (context, index) {
              var part = transaction.transactionParts[index];
              return Container(
                padding: const EdgeInsets.symmetric(vertical: Dimens.vgap / 2),
                decoration: BoxDecoration(
                  border: BoxBorder.symmetric(
                    horizontal: BorderSide(
                      color: ColorScheme.of(context).onSurface.withAlpha(40),
                      width: 1,
                    ),
                  ),
                ),
                child: part == editingPart && canEdit
                    ? partEditingRow(part)
                    : partDisplayRow(part, canEdit),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget partEditingRow(TransactionPart part) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingHorizontal),
    child: Column(
      spacing: Dimens.vgap,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(onPressed: finishEditing, icon: Icon(Icons.done)),
          ],
        ),
        Row(
          spacing: Dimens.hgap,
          children: [
            Expanded(
              child: TextFormField(
                initialValue: part.value.toReadableString(),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || double.tryParse(value) != null
                    ? null
                    : "Ungültige Zahl",
                decoration: InputDecoration(labelText: "Wert"),
                onChanged: (value) {
                  var v = double.tryParse(value);
                  if (v != null) {
                    part.value = v;
                  }
                },
              ),
            ),
            Expanded(
              child: TextFormField(
                initialValue: part.amount?.toReadableString(),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || double.tryParse(value) != null
                    ? null
                    : "Ungültige Zahl",
                decoration: InputDecoration(labelText: "Menge"),
                onChanged: (value) {
                  part.amount = double.tryParse(value);
                },
              ),
            ),
          ],
        ),
        TextFormField(
          initialValue: part.purpose,
          validator: (value) =>
              value != null && value.length > 127 ? null : "Max. 127 Zeichen",
          decoration: InputDecoration(labelText: "Inhalt"),
          onChanged: (value) {
            part.purpose = value;
          },
        ),
        ProductPicker(
          repository: context.read(),
          onSelect: (l) => part.product = l,
          initialValue: part.product,
        ),
      ],
    ),
  );

  Widget partDisplayRow(TransactionPart part, bool canEdit) => Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      SizedBox(width: 70, child: PriceBadge(part.value)),
      Expanded(flex: 3, child: Text(partContentText(part), softWrap: true)),
      if (canEdit)
        IconButton(onPressed: () => editPart(part), icon: Icon(Icons.edit)),
      if (canEdit)
        IconButton(onPressed: () => deletePart(part), icon: Icon(Icons.delete)),
    ],
  );

  @override
  String get typeDisplay => "Transaktion";
}
