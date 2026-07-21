import 'dart:convert';

import 'package:transactions/data/model/product.dart';
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
          if (res["sum"] is int) {
            res["sum"] = res["sum"].toDouble();
          }
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

  @override
  Future<Result<double>> sumExpInc(
    DateTime? dateFrom,
    DateTime? dateTo,
    bool income,
  ) {
    return apiService
        .get(
          "analysis/sum-exp-inc",
          params: {
            if (dateFrom != null) "dateFrom": dateFrom.toIso8601String(),
            if (dateTo != null) "dateTo": dateTo.toIso8601String(),
            if (income) "income": 1,
          },
        )
        .then((response) {
          var res = jsonDecode(response.body);
          if (res["sum"] is int) {
            res["sum"] = res["sum"].toDouble();
          }
          return Result<double>.ok(res["sum"]);
        })
        .catchError((err) {
          print(err);
          return Result<double>.error(Exception(err));
        });
  }

  @override
  Future<Result<List<(Product?, double)>>> productChildrenSum(
    DateTime? dateFrom,
    DateTime? dateTo,
    bool income,
    Product? parent, {
    int? top,
  }) {
    return apiService
        .get(
          "analysis/product-children-sum",
          params: {
            if (dateFrom != null) "dateFrom": dateFrom.toIso8601String(),
            if (dateTo != null) "dateTo": dateTo.toIso8601String(),
            if (income) "income": 1,
            if (parent != null) "id": parent.id,
          },
        )
        .then((response) {
          var res = jsonDecode(response.body);
          res = (res as List<dynamic>).map((c) {
            if (c["sum"] is int) {
              c["sum"] = c["sum"].toDouble();
            }
            if (c["product"] != null) {
              c["product"] = Product.fromJson(c["product"]);
            }
            return (c["product"], double.parse(c["sum"])) as (Product?, double);
          }).toList();
          res.sort((a, b) => b.$2.abs().compareTo(a.$2.abs()));

          if (top != null) {
            var otherSum = res
                .where((element) => element.$1 != null)
                .skip(top)
                .fold(
                  0.0,
                  (previousValue, element) => previousValue + element.$2,
                );
            var noProd = res
                .take(top)
                .firstWhere((element) => element.$1 == null);
            if (noProd != null) {
              otherSum += noProd.$2;
            }
            res = res.where((element) => element.$1 != null).take(top).toList();
            res.add((null, otherSum));
          }

          return Result<List<(Product?, double)>>.ok(
            res as List<(Product?, double)>,
          );
        })
        .catchError((err) {
          print(err);
          return Result<List<(Product?, double)>>.error(Exception(err));
        });
  }
}
