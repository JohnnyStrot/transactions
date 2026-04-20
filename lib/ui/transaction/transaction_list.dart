import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:transactions/data/model/transaction.dart';
import 'package:transactions/routing/routes.dart';
import 'package:transactions/ui/core/themes/dimens.dart';
import 'package:transactions/ui/list_widgets/data_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_command/flutter_command.dart';
import 'package:transactions/ui/transaction/transaction_list_entry.dart';

import 'transaction_list_viewmodel.dart';

class TransactionList
    extends
        DataListView<Transaction, TransactionListViewmodel, TransactionList> {
  const TransactionList({super.key, required super.viewmodel});

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState
    extends
        DataListViewState<
          Transaction,
          TransactionListViewmodel,
          TransactionList
        > {
  final TextEditingController remarkController = TextEditingController();
  final TextEditingController partnerController = TextEditingController();

  @override
  void initState() {
    remarkController
        .debounce(Durations.medium2)
        .listen((text, _) => widget.viewmodel.remarkChanged(text.text));
    partnerController
        .debounce(Durations.medium2)
        .listen((text, _) => widget.viewmodel.partnerChanged(text.text));
    super.initState();
  }

  @override
  Widget buildEntry(BuildContext context, Transaction entity) {
    return TransactionListEntry(entity: entity, onDelete: (tp) => delete(tp));
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
                controller: partnerController,
                decoration: InputDecoration(
                  label: Text("Partny"),
                  suffixIcon: IconButton(
                    onPressed: () {
                      partnerController.clear();
                    },
                    icon: Icon(Icons.clear),
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              child: TextField(
                controller: remarkController,
                decoration: InputDecoration(
                  label: Text("Bemerkung"),
                  suffixIcon: IconButton(
                    onPressed: () {
                      remarkController.clear();
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
          children: [
            Expanded(
              child: ListenableBuilder(
                listenable: Listenable.merge([
                  widget.viewmodel.dateFromChanged,
                  widget.viewmodel.dateToChanged,
                ]),
                builder: (context, _) {
                  return TextField(
                    controller: TextEditingController(
                      text: widget.viewmodel.dateSearch,
                    ),
                    decoration: InputDecoration(
                      suffix: IconButton(
                        onPressed: () {
                          widget.viewmodel.dateFromChanged(null);
                          widget.viewmodel.dateToChanged(null);
                        },
                        icon: Icon(Icons.clear),
                      ),
                    ),
                    onTap: () async {
                      var val = await showBoardDateTimeMultiPicker(
                        context: context,
                        dateRangeMode: MultiPickerDateRangeMode.flexible,
                        options: BoardDateTimeOptions(
                          viewMode: BoardDateTimeViewMode.calendarOnly,
                          startDayOfWeek: DateTime.monday,
                          activeColor: ColorScheme.of(context).primaryContainer,

                          showDateButton: true,
                        ),
                        showDragHandle: true,

                        pickerType: DateTimePickerType.date,
                      );
                      if (val != null) {
                        widget.viewmodel.dateFromChanged(val.start);
                        if (val.end != val.start) {
                          widget.viewmodel.dateToChanged(val.end);
                        } else {
                          widget.viewmodel.dateToChanged(null);
                        }
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  String get entityDisplay => "Transaktionen";

  @override
  String get route => Routes.transactions;
}
