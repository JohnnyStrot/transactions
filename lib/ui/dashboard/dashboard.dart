import 'dart:math';

import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:transactions/routing/routes.dart';
import 'package:transactions/ui/core/themes/dimens.dart';
import 'package:transactions/ui/dashboard/dashboard_viewmodel.dart';
import 'package:transactions/ui/dashboard/timeline.dart';
import 'package:transactions/utils/double_to_string_extension.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key, required this.viewmodel});

  @override
  State<Dashboard> createState() => _DashboardState();

  final DashboardViewmodel viewmodel;
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => GoRouter.of(context).push(Routes.transactionsCapture),
        child: Icon(Icons.playlist_add),
      ),
      body: ListenableBuilder(
        listenable: widget.viewmodel,
        builder: (context, child) => Padding(
          padding: const EdgeInsets.all(Dimens.paddingHorizontal),
          child: ListView(
            children: [
              infoCard(
                "Summe",
                widget.viewmodel.sumTotal == null
                    ? Center(child: CircularProgressIndicator())
                    : Center(
                        child: Text(
                          "${widget.viewmodel.sumTotal!.toReadableString()}€",
                          style: TextTheme.of(context).headlineLarge,
                        ),
                      ),
              ),
              infoCard(
                "Summe (letzte 30 Tage)",
                widget.viewmodel.sum30days == null
                    ? Center(child: CircularProgressIndicator())
                    : Center(
                        child: Text(
                          "${widget.viewmodel.sum30days!.toReadableString()}€",
                          style: TextTheme.of(context).headlineLarge,
                        ),
                      ),
              ),
              infoCard(
                "Monatliche Werte",
                widget.viewmodel.expensesMonthly == null ||
                        widget.viewmodel.aggregateMonthly == null
                    ? CircularProgressIndicator()
                    : SfCartesianChart(
                        enableSideBySideSeriesPlacement: false,
                        primaryXAxis: CategoryAxis(
                          labelRotation: 90,
                          labelStyle: TextStyle(fontSize: 8),
                        ),
                        primaryYAxis: NumericAxis(),

                        legend: Legend(isVisible: true),
                        series: <CartesianSeries<(DateTime, double), String>>[
                          ColumnSeries<(DateTime, double), String>(
                            width: 0.4,
                            dataSource: widget.viewmodel.expensesMonthly ?? [],
                            xValueMapper: (data, _) => BoardDateFormat(
                              "yyyy MMMM",
                            ).format(data.$1.add(Duration(days: 1)), "de"),
                            yValueMapper: (data, _) => data.$2,
                            color: ColorScheme.of(context).primary,
                            legendItemText: "Ausgaben",
                          ),
                          ColumnSeries<(DateTime, double), String>(
                            width: 0.6,
                            legendItemText: "Summe",
                            dataSource: widget.viewmodel.aggregateMonthly ?? [],
                            xValueMapper: (data, _) => BoardDateFormat(
                              "yyyy MMMM",
                            ).format(data.$1.add(Duration(days: 1)), "de"),
                            yValueMapper: (data, _) => data.$2,
                            color: ColorScheme.of(context).secondary,
                          ),
                        ],
                      ),
              ),
              infoCard(
                "Kredite",
                widget.viewmodel.credits == null
                    ? CircularProgressIndicator()
                    : Column(
                        children: [
                          for (var (partner, value)
                              in widget.viewmodel.credits!)
                            Row(
                              spacing: Dimens.hgap,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    "${value.toReadableString()}€",
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    partner?.displayShort ?? "Unbekannt",
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
              ),
              infoCard(
                "Top 10 Ausgabesenken",
                widget.viewmodel.pieNegative == null
                    ? CircularProgressIndicator()
                    : SfCircularChart(
                        series: <PieSeries<(String, double), String>>[
                          PieSeries<(String, double), String>(
                            dataSource: widget.viewmodel.pieNegative ?? [],
                            xValueMapper: (data, _) => data.$1,
                            yValueMapper: (data, _) => data.$2,
                            dataLabelMapper: (datum, index) =>
                                "${datum.$1.substring(0, min(datum.$1.length, 14))}\n${datum.$2}€",
                            dataLabelSettings: DataLabelSettings(
                              isVisible: true,
                            ),
                            startAngle: -45,
                            endAngle: -45,
                            radius: "70%",
                          ),
                        ],
                      ),
              ),
              infoCard(
                "Top 10 Einnahmequellen",
                Container(
                  child: widget.viewmodel.piePositive == null
                      ? CircularProgressIndicator()
                      : SfCircularChart(
                          series: <PieSeries<(String, double), String>>[
                            PieSeries<(String, double), String>(
                              dataSource: widget.viewmodel.piePositive ?? [],
                              xValueMapper: (data, _) => data.$1,
                              yValueMapper: (data, _) => data.$2,
                              dataLabelMapper: (datum, index) =>
                                  "${datum.$1.substring(0, min(datum.$1.length, 14))}\n${datum.$2}€",
                              dataLabelSettings: DataLabelSettings(
                                isVisible: true,
                              ),
                              startAngle: -45,
                              endAngle: -45,
                              radius: "70%",
                            ),
                          ],
                        ),
                ),
              ),
              infoCard(
                "Zeitlinie",
                widget.viewmodel.timeline == null
                    ? CircularProgressIndicator()
                    : Timeline(
                        updateData: widget.viewmodel,
                        getData: () => widget.viewmodel.timeline ?? [],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget infoCard(String title, Widget content) => Card(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(title, style: TextTheme.of(context).bodyMedium),
          ),
          content,
        ],
      ),
    ),
  );
}
