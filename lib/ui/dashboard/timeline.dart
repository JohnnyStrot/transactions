import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';

class Timeline extends StatefulWidget {
  const Timeline({super.key, required this.updateData, required this.getData});

  final Listenable updateData;
  final List<(DateTime, double)> Function() getData;

  @override
  State<Timeline> createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.updateData,
    builder: (context, child) {
      var data = widget.getData();

      return SfCartesianChart(
        primaryXAxis: DateTimeAxis(),
        series: <CartesianSeries>[
          // Renders line chart
          LineSeries<(DateTime, double), DateTime>(
            color: ColorScheme.of(context).primary,
            dataSource: data,
            xValueMapper: ((DateTime, double) sales, _) => sales.$1,
            yValueMapper: ((DateTime, double) sales, _) => sales.$2,
          ),
        ],
      );
    },
  );
}
