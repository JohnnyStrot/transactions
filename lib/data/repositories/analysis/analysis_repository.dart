import 'package:transactions/data/model/transaction_partner.dart';
import 'package:transactions/utils/result.dart';

abstract class AnalysisRepository {
  Future<Result<double>> getSum(DateTime? dateFrom, DateTime? dateTo);
  Future<Result<List<(TransactionPartner, double)>>> getCredits();
  Future<Result<List<(String, double)>>> getPartnersPie(bool positive);
  Future<Result<List<(DateTime, double)>>> getAggregateDaily(
    DateTime? dateFrom,
    DateTime? dateTo,
  );
  Future<Result<List<(DateTime, double)>>> getAggregateMonthly(
    DateTime? dateFrom,
    DateTime? dateTo,
  );
  Future<Result<List<(DateTime, double)>>> getExpensesMonthly(
    DateTime? dateFrom,
    DateTime? dateTo,
  );
  Future<Result<List<(DateTime, double)>>> getTimeline(
    DateTime? dateFrom,
    DateTime? dateTo,
  );
}
