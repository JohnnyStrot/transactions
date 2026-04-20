import 'dart:convert';

import 'package:transactions/data/model/transaction_partner.dart';
import 'package:transactions/data/repositories/analysis/analysis_repository.dart';
import 'package:transactions/data/services/api/api_service.dart';
import 'package:transactions/utils/result.dart';

class AnalysisRepositoryRemote implements AnalysisRepository {
  AnalysisRepositoryRemote({required this.apiService});

  final ApiService apiService;

  @override
  Future<Result<double>> getSum(DateTime? dateFrom, DateTime? dateTo) async {
    return await apiService
        .get(
          "analysis/sum",
          params: {
            if (dateFrom != null) "dateFrom": dateFrom.toIso8601String(),
            if (dateTo != null) "dateTo": dateTo.toIso8601String(),
          },
        )
        .then((response) {
          var res = jsonDecode(response.body);

          return Result<double>.ok(res["sum"]);
        })
        .catchError((err) {
          print(err);
          return Result<double>.error(Exception(err));
        });
  }

  Result<List<(TransactionPartner, double)>> _mapPartnerValues(
    dynamic response,
  ) {
    var res = jsonDecode(response.body);

    return Result<List<(TransactionPartner, double)>>.ok(
      (res as List<dynamic>)
          .map<(TransactionPartner, double)>(
            (c) => (
              TransactionPartner.fromJson(c["transactionPartner"]),
              double.parse(c["value"]),
            ),
          )
          .toList(),
    );
  }

  @override
  Future<Result<List<(TransactionPartner, double)>>> getCredits() async {
    return await apiService
        .get("analysis/credits")
        .then(_mapPartnerValues)
        .catchError((err) {
          return Result<List<(TransactionPartner, double)>>.error(
            Exception(err),
          );
        });
  }

  Result<List<(DateTime, double)>> _mapDateValuePairs(dynamic response) {
    var res = jsonDecode(response.body);

    return Result<List<(DateTime, double)>>.ok(
      (res as List<dynamic>)
          .map<(DateTime, double)>(
            (c) => (DateTime.parse(c["date"]), double.parse(c["value"])),
          )
          .toList(),
    );
  }

  @override
  Future<Result<List<(String, double)>>> getPartnersPie(bool positive) async {
    return await apiService
        .get("analysis/partners-pie-${positive ? "positive" : "negative"}")
        .then((response) {
          var res = jsonDecode(response.body);
          return Result<List<(String, double)>>.ok(
            res
                .map<(String, double)>(
                  (c) => (c["name"] as String, double.parse(c["value"])),
                )
                .toList(),
          );
        })
        .catchError((err) {
          return Result<List<(String, double)>>.error(Exception(err));
        });
  }

  @override
  Future<Result<List<(DateTime, double)>>> getAggregateDaily(
    DateTime? dateFrom,
    DateTime? dateTo,
  ) async {
    return await apiService
        .get(
          "analysis/aggregate-daily",
          params: {
            if (dateFrom != null) "dateFrom": dateFrom.toIso8601String(),
            if (dateTo != null) "dateTo": dateTo.toIso8601String(),
          },
        )
        .then(_mapDateValuePairs)
        .catchError((err) {
          print(err);
          return Result<List<(DateTime, double)>>.error(Exception(err));
        });
  }

  @override
  Future<Result<List<(DateTime, double)>>> getAggregateMonthly(
    DateTime? dateFrom,
    DateTime? dateTo,
  ) async {
    return await apiService
        .get(
          "analysis/aggregate-monthly",
          params: {
            if (dateFrom != null) "dateFrom": dateFrom.toIso8601String(),
            if (dateTo != null) "dateTo": dateTo.toIso8601String(),
          },
        )
        .then(_mapDateValuePairs)
        .catchError((err) {
          print(err);
          return Result<List<(DateTime, double)>>.error(Exception(err));
        });
  }

  @override
  Future<Result<List<(DateTime, double)>>> getExpensesMonthly(
    DateTime? dateFrom,
    DateTime? dateTo,
  ) async {
    return await apiService
        .get(
          "analysis/expenses-monthly",
          params: {
            if (dateFrom != null) "dateFrom": dateFrom.toIso8601String(),
            if (dateTo != null) "dateTo": dateTo.toIso8601String(),
          },
        )
        .then(_mapDateValuePairs)
        .catchError((err) {
          print(err);
          return Result<List<(DateTime, double)>>.error(Exception(err));
        });
  }

  @override
  Future<Result<List<(DateTime, double)>>> getTimeline(
    DateTime? dateFrom,
    DateTime? dateTo,
  ) async {
    return await apiService
        .get(
          "analysis/timeline",
          params: {
            if (dateFrom != null) "dateFrom": dateFrom.toIso8601String(),
            if (dateTo != null) "dateTo": dateTo.toIso8601String(),
          },
        )
        .then(_mapDateValuePairs)
        .catchError((err) {
          print(err);
          return Result<List<(DateTime, double)>>.error(Exception(err));
        });
  }
}
