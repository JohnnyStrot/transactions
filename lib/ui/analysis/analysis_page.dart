import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:transactions/data/model/product.dart';
import 'package:transactions/ui/analysis/analysis_interval.dart';
import 'package:transactions/ui/analysis/analysis_interval_size.dart';
import 'package:transactions/ui/analysis/analysis_viewmodel.dart';
import 'package:transactions/ui/analysis/product_pie_analysis.dart';
import 'package:transactions/ui/core/themes/dimens.dart';
import 'package:transactions/utils/double_to_string_extension.dart';
import 'package:transactions/utils/result.dart';

class AnalysisPage extends StatefulWidget {
  const AnalysisPage({super.key, required this.viewmodel});

  @override
  State<AnalysisPage> createState() => _AnalysisPageState();

  final AnalysisViewmodel viewmodel;
}

class _AnalysisPageState extends State<AnalysisPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListenableBuilder(
        listenable: widget.viewmodel,
        builder: (context, child) => Padding(
          padding: const EdgeInsets.all(Dimens.paddingHorizontal),
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("Analyse", style: TextTheme.of(context).headlineMedium),
                  intervalSelect(context),
                ],
              ),
              SizedBox(height: 8.0),
              IntervalSums(viewmodel: widget.viewmodel),
            ],
          ),
        ),
      ),
    );
  }

  Widget intervalSelect(BuildContext context) => ValueListenableBuilder(
    valueListenable: widget.viewmodel.changeInterval,
    builder: (context, interval, child) => InkWell(
      child: Text(interval.text),
      onTap: () => showModalBottomSheet(
        context: context,
        builder: (context) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
          child: ValueListenableBuilder(
            valueListenable: widget.viewmodel.changeInterval,
            builder: (context, interval, child) => Column(
              children: [
                Center(
                  child: Text(
                    "Intervall wählen",
                    style: TextTheme.of(context).headlineSmall,
                  ),
                ),
                SizedBox(height: 8.0),
                intervalSelectListTile(
                  interval,
                  AnalysisIntervalSize.yearly,
                  "Jährlich",
                  Icons.calendar_month,
                ),
                intervalSelectListTile(
                  interval,
                  AnalysisIntervalSize.sixMonthly,
                  "Halbjährlich",
                  Icons.calendar_month,
                ),
                intervalSelectListTile(
                  interval,
                  AnalysisIntervalSize.monthly,
                  "Monatlich",
                  Icons.calendar_month,
                ),
                intervalSelectListTile(
                  interval,
                  AnalysisIntervalSize.weekly,
                  "Wöchentlich",
                  Icons.calendar_month,
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  Widget intervalSelectListTile(
    AnalysisInterval currentInterval,
    AnalysisIntervalSize size,
    String text,
    IconData icon,
  ) => ListTile(
    leading: CircleAvatar(child: Icon(icon)),
    title: Text(text),
    selected: currentInterval.intervalSize == size,
    trailing: currentInterval.intervalSize == size ? Icon(Icons.check) : null,
    onTap: () => widget.viewmodel.changeInterval(
      AnalysisInterval(intervalIndex: 0, intervalSize: size),
    ),
  );
}

class IntervalSums extends StatefulWidget {
  const IntervalSums({super.key, required this.viewmodel});

  final AnalysisViewmodel viewmodel;

  @override
  State<IntervalSums> createState() => _IntervalSumsState();
}

class _IntervalSumsState extends State<IntervalSums> {
  @override
  void initState() {
    pageController = PageController();
    widget.viewmodel.changeInterval.addListener(
      () => pageController.jumpToPage(
        widget.viewmodel.changeInterval.value.intervalIndex,
      ),
    );
    super.initState();
  }

  late final PageController pageController;
  late final PageController indicatorController;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8.0,
      children: [
        Container(
          constraints: BoxConstraints(maxHeight: 225),
          child: Row(
            children: [
              Expanded(
                child: ScrollConfiguration(
                  behavior: MouseDragScrollBehavior(),
                  child: PageView.builder(
                    controller: pageController,

                    onPageChanged: (value) => widget.viewmodel.changeInterval(
                      AnalysisInterval(
                        intervalIndex: value,
                        intervalSize:
                            widget.viewmodel.changeInterval.value.intervalSize,
                      ),
                    ),
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    itemBuilder: (context, index) => ValueListenableBuilder(
                      valueListenable: widget.viewmodel.changeInterval,
                      builder: (context, value, child) => buildItem(
                        context,
                        AnalysisInterval(
                          intervalIndex: index,
                          intervalSize: value.intervalSize,
                        ),
                        index,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        ValueListenableBuilder(
          valueListenable: widget.viewmodel.changeInterval,
          builder: (context, value, child) => AnimatedSmoothIndicator(
            count: 52,
            activeIndex: value.intervalIndex,
            axisDirection: Axis.horizontal,
            textDirection: TextDirection.rtl,
            effect: ScrollingDotsEffect(
              activeStrokeWidth: 1,
              activeDotScale: 2,
              maxVisibleDots: 5,
              radius: 4,
              spacing: 10,
              dotHeight: 8,
              dotWidth: 8,
              dotColor: ColorScheme.of(context).onSurfaceVariant,
              activeDotColor: ColorScheme.of(context).onSurface,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildItem(BuildContext context, AnalysisInterval interval, int index) {
    return Row(
      children: [
        Expanded(child: cards(context, interval, false)),
        Expanded(child: cards(context, interval, true)),
      ],
    );
  }

  void navigateToProductPieAnalysis(
    BuildContext context,
    AnalysisInterval interval,
    bool income,
  ) {
    widget.viewmodel.changeProduct(null);
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) =>
            ProductPieAnalysis(viewmodel: widget.viewmodel, income: income),
      ),
    );
  }

  Widget cards(
    BuildContext context,
    AnalysisInterval interval,
    bool income,
  ) => Card.filled(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    child: InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => navigateToProductPieAnalysis(context, interval, income),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              income ? "Einnahmen" : "Ausgaben",
              style: TextTheme.of(context).bodyMedium!.copyWith(
                color: ColorScheme.of(context).onSurfaceVariant,
              ),
            ),
            FutureBuilder(
              future: widget.viewmodel.getSum(interval, null, income),
              builder: (context, snapshot) {
                switch (snapshot.data) {
                  case null:
                    return CircularProgressIndicator();
                  case Ok<double>():
                    var exp = (snapshot.data as Ok<double>).value;

                    return Text(
                      "${exp.toReadableString()} €",
                      style: TextTheme.of(
                        context,
                      ).titleMedium!.copyWith(fontWeight: FontWeight.bold),
                    );
                  case Error<double>():
                    return Text(
                      "Error: ${(snapshot.data as Error<double>).error}",
                    );
                }
              },
            ),
            SizedBox(height: 35),
            FutureBuilder(
              future: widget.viewmodel.repository.productChildrenSum(
                interval.intervalStart,
                interval.intervalEnd,
                income,
                null,
                top: 3,
              ),
              builder: (context, snapshot) {
                switch (snapshot.data) {
                  case null:
                    return LinearProgressIndicator();
                  case Ok<List<(Product?, double, num)>>():
                    var data =
                        (snapshot.data as Ok<List<(Product?, double, num)>>)
                            .value;
                    return Column(
                      spacing: 6,
                      children: [
                        Row(
                          spacing: 2,
                          children: [
                            for (var (p, d, n) in data)
                              Expanded(
                                flex: d.abs().ceil(),
                                child: Container(
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: p?.color ?? Colors.grey,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(),
                        for (var (p, _, _) in data)
                          Row(
                            spacing: 6,
                            children: [
                              Container(
                                height: 8,
                                width: 8,
                                decoration: BoxDecoration(
                                  color: p?.color ?? Colors.grey,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  p?.displayShort ?? "Weitere",
                                  style: TextTheme.of(context).bodySmall,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                      ],
                    );
                  case Error<List<(Product?, double, num)>>():
                    return Text(
                      "Error: ${(snapshot.data as Error<List<(Product?, double, num)>>).error}",
                    );
                }
              },
            ),
          ],
        ),
      ),
    ),
  );
}

class MouseDragScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    // etc.
  };
}
