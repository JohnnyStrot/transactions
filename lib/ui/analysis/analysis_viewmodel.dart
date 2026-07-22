import 'package:flutter/foundation.dart';
import 'package:flutter_command/flutter_command.dart';
import 'package:transactions/data/model/product.dart';
import 'package:transactions/data/repositories/analysis/analysis_repository.dart';
import 'package:transactions/ui/analysis/analysis_interval.dart';
import 'package:transactions/utils/result.dart';

class AnalysisViewmodel with ChangeNotifier {
  final AnalysisRepository repository;

  Command<AnalysisInterval, AnalysisInterval> changeInterval;
  Command<Product?, Product?> changeProduct;

  final Map<(AnalysisInterval, Product?), (double, double)> _expIncCache;

  AnalysisViewmodel({required this.repository})
    : changeInterval = CommandSync(
        initialValue: AnalysisInterval(),
        restriction: null,
        ifRestrictedExecuteInstead: null,
        includeLastResultInCommandResults: false,
        noReturnValue: false,
        errorFilter: null,
        notifyOnlyWhenValueChanges: true,
        name: null,
        noParamValue: false,
        func: (val) {
          return val;
        },
      ),
      changeProduct = CommandSync(
        initialValue: null,
        restriction: null,
        ifRestrictedExecuteInstead: null,
        includeLastResultInCommandResults: false,
        noReturnValue: false,
        errorFilter: null,
        notifyOnlyWhenValueChanges: true,
        name: null,
        noParamValue: false,
        func: (val) {
          return val;
        },
      ),
      _expIncCache = <(AnalysisInterval, Product?), (double, double)>{};

  Future<Result<double>> getSum(
    AnalysisInterval interval,
    Product? product,
    bool income,
  ) async {
    if (_expIncCache.containsKey((interval, product))) {
      return income
          ? Result.ok(_expIncCache[(interval, product)]!.$2)
          : Result.ok(_expIncCache[(interval, product)]!.$1);
    }
    var exp = await repository.sumExpInc(
      interval.intervalStart,
      interval.intervalEnd,
      false,
      product,
    );
    var inc = await repository.sumExpInc(
      interval.intervalStart,
      interval.intervalEnd,
      true,
      product,
    );
    if (exp is Ok<double> && inc is Ok<double>) {
      _expIncCache[(interval, product)] = (exp.value, inc.value);
      return income ? Result.ok(inc.value) : Result.ok(exp.value);
    } else if (exp is Error<double>) {
      return Result.error(exp.error);
    } else {
      return Result.error((inc as Error<double>).error);
    }
  }
}
