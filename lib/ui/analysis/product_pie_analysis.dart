import 'package:flutter/material.dart';
import 'package:flutter_command/flutter_command.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:transactions/data/model/product.dart';
import 'package:transactions/ui/analysis/analysis_interval.dart';
import 'package:transactions/ui/analysis/analysis_viewmodel.dart';
import 'package:transactions/ui/core/themes/theme.dart';
import 'package:transactions/utils/result.dart';

class ProductPieAnalysis extends StatefulWidget {
  const ProductPieAnalysis({
    super.key,
    required this.viewmodel,
    required this.income,
  });

  final AnalysisViewmodel viewmodel;
  final bool income;

  @override
  State<ProductPieAnalysis> createState() => _ProductPieAnalysisState();
}

class _ProductPieAnalysisState extends State<ProductPieAnalysis> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: ListView(children: [dataWrapper(context)]),
    );
  }

  Widget dataWrapper(BuildContext context) => ValueListenableBuilder(
    valueListenable: widget.viewmodel.changeProduct.combineLatest(
      widget.viewmodel.changeInterval,
      (p, i) => (p, i),
    ),
    builder: (context, val, child) {
      var product = val.$1;
      var interval = val.$2;
      return FutureBuilder(
        future: widget.viewmodel.repository.productChildrenSum(
          interval.intervalStart,
          interval.intervalEnd,
          widget.income,
          product,
        ),
        builder: (context, snap) {
          switch (snap.data) {
            case null:
              return Center(child: CircularProgressIndicator());
            case Ok<List<(Product?, double, num)>>():
              return buildContent(
                context,
                product,
                interval,
                (snap.data as Ok<List<(Product?, double, num)>>).value,
              );
            case Error<List<(Product?, double, num)>>():
              return Center(
                child: Text(
                  "Error ${(snap.data as Error<List<(Product?, double, num)>>).error}",
                ),
              );
          }
        },
      );
    },
  );

  Widget buildContent(
    BuildContext context,
    Product? product,
    AnalysisInterval interval,
    List<(Product?, double, num)> data,
  ) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: FutureBuilder(
        future: widget.viewmodel.getSum(interval, product, widget.income),
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.data is! Ok) {
            return Text("");
          }
          var sum = (asyncSnapshot.data as Ok).value;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 200,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (data.isNotEmpty)
                      SfCircularChart(
                        series: [
                          DoughnutSeries<(Product?, double, num), int>(
                            dataSource: data,
                            xValueMapper: (datum, index) => datum.$1?.id ?? -1,
                            yValueMapper: (datum, index) => datum.$2,
                            pointColorMapper: (datum, index) =>
                                datum.$1?.color ??
                                AppTheme.pieChartColors[index %
                                    AppTheme.pieChartColors.length],
                            innerRadius: "85",
                            radius: "100",
                          ),
                        ],
                      ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          widget.income ? "Einnahmen" : "Ausgaben",
                          style: TextTheme.of(context).bodySmall,
                        ),
                        Text(
                          "${sum.toString()} €",
                          style: TextTheme.of(context).headlineSmall!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          interval.text,
                          style: TextTheme.of(context).bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              if (product != null)
                Card.filled(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      minVerticalPadding: 8.0,
                      leading: CircleAvatar(
                        backgroundColor: product.color,
                        foregroundColor: ColorScheme.of(context).onSurface,
                        child: product.imageLink.isNotEmpty
                            ? Image.network(
                                product.imageLink,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(product.iconData),
                              )
                            : Icon(product.iconData),
                      ),
                      trailing: TextButton(
                        onPressed: () =>
                            widget.viewmodel.changeProduct(product.parent),
                        child: Text("Abwählen"),
                      ),
                      title: Text(
                        product.displayShort,
                        style: TextTheme.of(context).bodyMedium!,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitleTextStyle: TextTheme.of(context).bodySmall!
                          .copyWith(
                            color: ColorScheme.of(context).onSurfaceVariant,
                          ),
                    ),
                  ),
                ),
              if (product != null || data.isNotEmpty) SizedBox(height: 6),
              if (data.isNotEmpty)
                Text(
                  product == null ? "Nach Produkt" : "Unterprodukte",
                  style: TextTheme.of(context).titleMedium,
                ),
              if (data.isNotEmpty) SizedBox(height: 6),
              if (data.isNotEmpty)
                Card.filled(
                  child: Column(
                    children: [
                      for (var (index, (product, value, count)) in data.indexed)
                        ListTile(
                          onTap: product != null
                              ? () {
                                  widget.viewmodel.changeProduct(product);
                                }
                              : null,
                          leading: CircleAvatar(
                            backgroundColor:
                                product?.color ??
                                AppTheme.pieChartColors[index %
                                    AppTheme.pieChartColors.length],
                            foregroundColor: ColorScheme.of(context).onSurface,
                            child: product == null
                                ? Icon(Icons.question_mark)
                                : product.imageLink.isNotEmpty
                                ? Image.network(
                                    product.imageLink,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Icon(product.iconData),
                                  )
                                : Icon(product.iconData),
                          ),
                          title: Row(
                            spacing: 10.0,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 5,
                                child: Text(
                                  product?.displayShort ?? "Kein Produkt",
                                  style: TextTheme.of(context).bodyMedium!,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                "${value.toString()} €",
                                style: TextTheme.of(context).bodyMedium!,
                              ),
                            ],
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "$count Transaktion${count != 1 ? "en" : ""}",
                              ),
                              Text(
                                "${(sum == 0.0 ? 0 : value / sum * 100).round().toString()}%",
                              ),
                            ],
                          ),
                          subtitleTextStyle: TextTheme.of(context).bodySmall!
                              .copyWith(
                                color: ColorScheme.of(context).onSurfaceVariant,
                              ),
                        ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
