import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:transactions/data/model/transaction_partner.dart';
import 'package:transactions/data/repositories/analysis/analysis_repository.dart';
import 'package:transactions/utils/result.dart';

class DashboardViewmodel with ChangeNotifier {
  final AnalysisRepository repository;

  DashboardViewmodel({required this.repository}) {
    repository.getSum(null, null).then((res) {
      switch (res) {
        case Ok<double>():
          sumTotal = res.value;
          notifyListeners();
        case Error<double>():
          debugPrint(res.error.toString());
      }
    });
    repository.getSum(DateTime.now().subtract(Duration(days: 30)), null).then((
      res,
    ) {
      switch (res) {
        case Ok<double>():
          sum30days = res.value;
          notifyListeners();
        case Error<double>():
          debugPrint(res.error.toString());
      }
    });
    repository.getCredits().then((res) {
      switch (res) {
        case Ok<List<(TransactionPartner, double)>>():
          credits = res.value;
          notifyListeners();
        case Error<List<(TransactionPartner, double)>>():
          debugPrint(res.error.toString());
      }
    });
    repository.getPartnersPie(false).then((res) {
      switch (res) {
        case Ok<List<(String, double)>>():
          pieNegative = res.value;
          notifyListeners();
        case Error<List<(String, double)>>():
          debugPrint(res.error.toString());
      }
    });
    repository.getPartnersPie(true).then((res) {
      switch (res) {
        case Ok<List<(String, double)>>():
          piePositive = res.value;
          notifyListeners();
        case Error<List<(String, double)>>():
          debugPrint(res.error.toString());
      }
    });
    repository.getAggregateDaily(null, null).then((res) {
      switch (res) {
        case Ok<List<(DateTime, double)>>():
          aggregateDaily = res.value;
          notifyListeners();
        case Error<List<(DateTime, double)>>():
          debugPrint(res.error.toString());
      }
    });
    var date = DateTime.now();
    date = DateTime(
      date.year + (date.month == 11 ? 1 : 0),
      (date.month + 1) % 12,
    );
    date = DateTime(date.year, date.month).subtract(Duration(days: 1));
    var dateFirst = date.subtract(Duration(days: 360));
    debugPrint(BoardDateFormat("yyyy MMMM").format(dateFirst));
    debugPrint(BoardDateFormat("yyyy MMMM").format(date));
    repository
        .getAggregateMonthly(DateTime(dateFirst.year, dateFirst.month), date)
        .then((res) {
          switch (res) {
            case Ok<List<(DateTime, double)>>():
              aggregateMonthly = res.value;
              notifyListeners();
            case Error<List<(DateTime, double)>>():
              debugPrint(res.error.toString());
          }
        });
    repository
        .getExpensesMonthly(DateTime(dateFirst.year, dateFirst.month), date)
        .then((res) {
          switch (res) {
            case Ok<List<(DateTime, double)>>():
              expensesMonthly = res.value;
              notifyListeners();
            case Error<List<(DateTime, double)>>():
              debugPrint(res.error.toString());
          }
        });
    repository.getTimeline(null, null).then((res) {
      switch (res) {
        case Ok<List<(DateTime, double)>>():
          timeline = res.value;
          notifyListeners();
        case Error<List<(DateTime, double)>>():
          debugPrint(res.error.toString());
      }
    });
  }

  double? sumTotal;
  double? sum30days;
  List<(TransactionPartner, double)>? credits;
  List<(String, double)>? piePositive;
  List<(String, double)>? pieNegative;
  List<(DateTime, double)>? aggregateDaily;
  List<(DateTime, double)>? aggregateMonthly;
  List<(DateTime, double)>? expensesMonthly;
  List<(DateTime, double)>? timeline;
}
