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

  Result<List<(TransactionPartner?, double)>> _mapPartnerValues(
    dynamic response,
  ) {
    var res = jsonDecode(response.body);

    return Result<List<(TransactionPartner?, double)>>.ok(
      (res as List<dynamic>).map<(TransactionPartner?, double)>((c) {
        var val = c["value"] is String
            ? double.parse(c["value"])
            : c["value"] is int
            ? c["value"].toDouble()
            : c["value"] is double
            ? c["value"]
            : 0;
        return c["transactionPartner"] != null &&
                c["transactionPartner"]["id"] != null
            ? (TransactionPartner.fromJson(c["transactionPartner"]), val)
            : (null, val);
      }).toList(),
    );
  }

  @override
  Future<Result<List<(TransactionPartner?, double)>>> getCredits() async {
    return await apiService
        .get("analysis/credits")
        .then(_mapPartnerValues)
        .catchError((err) {
          return Result<List<(TransactionPartner?, double)>>.error(
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
    Product? product,
  ) {
    return apiService
        .get(
          "analysis/sum-exp-inc",
          params: {
            if (dateFrom != null) "dateFrom": dateFrom.toIso8601String(),
            if (dateTo != null) "dateTo": dateTo.toIso8601String(),
            if (income) "income": 1,
            if (product != null) "product": product.id,
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
  Future<Result<List<(Product?, double, num)>>> productChildrenSum(
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
            if (c["count"] is num) {
            } else if (c["count"] is String) {
              c["count"] = int.parse(c["count"]);
            } else {
              c["count"] = 0;
            }
            if (c["product"] != null) {
              c["product"] = Product.fromJson(c["product"]);
            }
            if (parent != null) {
              c["product"].parent = parent;
            }
            return (c["product"], double.parse(c["sum"]), c["count"])
                as (Product?, double, int);
          }).toList();
          res.sort((a, b) => b.$2.abs().compareTo(a.$2.abs()));

          if (top != null) {
            var (otherSum, otherCount) = res
                .where((element) => element.$1 != null)
                .skip(top)
                .fold(
                  (0.0, 0 as num),
                  (previousValue, element) => (
                    previousValue.$1 + element.$2,
                    previousValue.$2 + element.$3,
                  ),
                );
            var noProd = res
                .take(top)
                .firstWhere((element) => element.$1 == null);
            if (noProd != null) {
              otherSum += noProd.$2;
              otherCount += noProd.$3;
            }
            res = res.where((element) => element.$1 != null).take(top).toList();
            res.add((null, otherSum, otherCount));
          }

          return Result<List<(Product?, double, int)>>.ok(
            res as List<(Product?, double, int)>,
          );
        })
        .catchError((err) {
          print(err);
          return Result<List<(Product?, double, int)>>.error(Exception(err));
        });
  }
}
