import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:flutter_command/flutter_command.dart';
import 'package:transactions/data/model/transaction.dart';
import 'package:transactions/data/repositories/transaction/transaction_repository.dart';
import 'package:transactions/ui/list_widgets/data_list_viewmodel.dart';

class TransactionListViewmodel extends DataListViewmodel<Transaction> {
  TransactionListViewmodel({
    required TransactionRepository transactionRepository,
  }) : super(repository: transactionRepository) {
    remarkChanged = Command.createAsyncNoResult((s) async {
      _searchRemark = s;
      exLoadEntities();
    });
    partnerChanged = Command.createAsyncNoResult((s) async {
      _searchPartner = s;
      exLoadEntities();
    });
    dateFromChanged = Command.createAsyncNoResult((s) async {
      _searchDateFrom = s;
      exLoadEntities();
    });
    dateToChanged = Command.createAsyncNoResult((s) async {
      _searchDateTo = s;
      exLoadEntities();
    });
  }

  late final Command<String?, void> remarkChanged;
  late final Command<String?, void> partnerChanged;
  late final Command<DateTime?, void> dateFromChanged;
  late final Command<DateTime?, void> dateToChanged;

  String? _searchRemark;
  String? _searchPartner;
  DateTime? _searchDateFrom;
  DateTime? _searchDateTo;

  String get dateSearch => [
    if (_searchDateFrom != null)
      BoardDateFormat("yyyy-MM-dd HH:mm:ss").format(_searchDateFrom!),
    if (_searchDateTo != null)
      BoardDateFormat("yyyy-MM-dd HH:mm:ss").format(_searchDateTo!),
  ].join(" - ");

  @override
  searchValues() {
    var search = <String, dynamic>{};
    if (_searchRemark != null) {
      search["remark"] = _searchRemark;
    }
    if (_searchPartner != null) {
      search["partner"] = _searchPartner;
    }
    if (_searchDateFrom != null && _searchDateTo != null) {
      search["dateFrom"] = _searchDateFrom!.toIso8601String();
      search["dateTo"] = _searchDateTo!.toIso8601String();
    } else if (_searchDateFrom != null || _searchDateTo != null) {
      search["date"] = _searchDateFrom ?? _searchDateTo;
    }
    print(search);
    return search;
  }
}
