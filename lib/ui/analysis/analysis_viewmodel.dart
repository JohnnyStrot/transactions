import 'package:flutter/foundation.dart';
import 'package:flutter_command/flutter_command.dart';
import 'package:transactions/data/repositories/analysis/analysis_repository.dart';
import 'package:transactions/ui/analysis/analysis_interval.dart';

class AnalysisViewmodel with ChangeNotifier {
  final AnalysisRepository repository;

  Command<AnalysisInterval, AnalysisInterval> changeInterval;

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
          debugPrint("${val.intervalIndex} ${val.intervalSize} ${val.text}");
          return val;
        },
      );
}
