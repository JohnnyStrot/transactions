import 'package:flutter/material.dart';
import 'package:flutter_command/flutter_command.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:transactions/data/model/product.dart';
import 'package:transactions/data/model/transaction.dart';
import 'package:transactions/data/model/transaction_part.dart';
import 'package:transactions/data/model/transaction_partner.dart';
import 'package:transactions/ui/core/ui/price_badge.dart';
import 'package:transactions/ui/transaction/transaction_capture_viewmodel.dart';
import 'package:transactions/ui/transaction_partner/transaction_partner_details.dart';
import 'package:transactions/ui/transaction_partner/transaction_partner_details_viewmodel.dart';
import 'package:transactions/utils/double_to_string_extension.dart';
import 'package:transactions/utils/result.dart';
import 'package:auto_hyphenating_text/auto_hyphenating_text.dart';

class TransactionCapture extends StatefulWidget {
  const TransactionCapture({super.key, required this.viewmodel});

  final TransactionCaptureViewmodel viewmodel;

  @override
  State<TransactionCapture> createState() => _TransactionCaptureState();
}

class _TransactionCaptureState extends State<TransactionCapture>
    with SingleTickerProviderStateMixin {
  late final TabController tabController;
  late final TextEditingController partnerSearchController;
  late final TextEditingController partnerCityController;

  late final TextEditingController productNameController;
  late final TextEditingController productProducerController;

  @override
  void initState() {
    initHyphenation(DefaultResourceLoaderLanguage.de1996);
    tabController = TabController(length: 3, vsync: this);
    partnerSearchController = TextEditingController(text: null);
    partnerSearchController
        .debounce(Durations.medium3)
        .listen((val, _) => widget.viewmodel.partnerSearchText(val));

    partnerCityController = TextEditingController(text: null);
    partnerCityController
        .debounce(Durations.medium3)
        .listen((val, _) => widget.viewmodel.partnerCityText(val));

    productNameController = TextEditingController(text: null);
    productNameController
        .debounce(Durations.medium3)
        .listen((val, _) => widget.viewmodel.productNameText(val));

    productProducerController = TextEditingController(text: null);
    productProducerController
        .debounce(Durations.medium3)
        .listen((val, _) => widget.viewmodel.productProducerText(val));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TabBar(
          controller: tabController,
          tabs: <Widget>[
            Tab(icon: Icon(Icons.calendar_month)),
            Tab(icon: Icon(Icons.person)),
            Tab(icon: Icon(Icons.list)),
          ],
        ),
      ),
      floatingActionButton: ListenableBuilder(
        listenable: Listenable.merge([
          tabController,
          widget.viewmodel.changePartner,
        ]),
        builder: (context, child) {
          switch (tabController.index) {
            case 0:
              return FloatingActionButton(
                onPressed: () {
                  tabController.animateTo(1);
                },
                child: Icon(Icons.arrow_forward),
              );
            case 1:
              if (widget.viewmodel.changePartner.value != null) {
                return FloatingActionButton(
                  onPressed: () {
                    tabController.animateTo(2);
                  },
                  child: Icon(Icons.arrow_forward),
                );
              } else {
                return FloatingActionButton(
                  onPressed: () => addPartner(context),
                  child: Icon(Icons.person_add),
                );
              }
            case 2:
              return FloatingActionButton(
                onPressed: () {
                  widget.viewmodel.save().then((res) {
                    switch (res) {
                      case Ok<Transaction>():
                        if (context.mounted) {
                          GoRouter.of(context).pop();
                        }
                      case Error<Transaction>():
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Transaktion konnte nicht gespeichert werden",
                              ),
                            ),
                          );
                        }
                    }
                  });
                },
                child: Icon(Icons.save),
              );
          }
          return SizedBox();
        },
      ),
      body: TabBarView(
        controller: tabController,
        children: <Widget>[
          buildTimestampPage(context),
          buildPartnerPage(context),
          buildContentPage(context),
        ],
      ),
    );
  }

  Widget buildTimestampPage(BuildContext context) {
    DateTime now = DateTime.now();

    return ValueListenableBuilder(
      valueListenable: widget.viewmodel.changeTimestamp,
      builder: (context, value, child) {
        return Column(
          children: [
            CalendarDatePicker(
              initialDate: value,
              firstDate: DateTime(2020),
              lastDate: DateTime(now.year + 2),
              onDateChanged: widget.viewmodel.changeDate,
            ),
            TextButton(
              onPressed: () {
                showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(value),
                ).then(widget.viewmodel.changeTime);
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  DateFormat.Hm().format(value),
                  style: TextStyle(fontSize: 32),
                ),
              ),
            ),
            Expanded(child: SizedBox()),
            TextFormField(
              controller: TextEditingController(text: widget.viewmodel.remark),
              onChanged: (value) => widget.viewmodel.remark = value,
              decoration: InputDecoration(label: Text("Bemerkung")),
            ),
            Expanded(child: SizedBox()),
            Text(
              "${DateFormat.yMMMMd("DE_de").format(value)} ${DateFormat.Hm().format(value)}",
            ),
            SizedBox(height: 36.0),
          ],
        );
      },
    );
  }

  Widget buildPartnerPage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            spacing: 8.0,
            children: [
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(labelText: "Name / Marke"),
                  controller: partnerSearchController,
                ),
              ),
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(labelText: "Stadt"),
                  controller: partnerCityController,
                ),
              ),
            ],
          ),
          ValueListenableBuilder(
            valueListenable: widget.viewmodel.changePartner,
            builder: (context, selected, child) {
              return AnimatedSize(
                duration: Durations.short3,
                child: Column(
                  children: [
                    SizedBox(height: 16),
                    if (selected != null)
                      Card.filled(child: transactionPartnerListTile(selected)),
                    if (selected != null) SizedBox(height: 16),
                  ],
                ),
              );
            },
          ),
          Expanded(
            child: Card.filled(
              child: CustomScrollView(
                slivers: [
                  PagingListener(
                    controller: widget.viewmodel.partnerPagingController,
                    builder: (context, state, fetchNextPage) {
                      return PagedSliverList<int, TransactionPartner>(
                        state: state,
                        fetchNextPage: fetchNextPage,
                        builderDelegate: PagedChildBuilderDelegate(
                          itemBuilder: (context, partner, index) => Padding(
                            padding: EdgeInsets.only(top: index > 0 ? 10 : 0),
                            child: transactionPartnerListTile(partner),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget transactionPartnerListTile(TransactionPartner partner) {
    var company = partner.company;

    Widget leading;
    Widget title;
    Widget subtitle = Text(
      [
        if (partner.city.isNotEmpty) partner.city,
        if (partner.street.isNotEmpty) partner.street,
      ].join(", "),
    );

    if (company != null) {
      leading = company.logo.isNotEmpty
          ? Image.network(
              company.logo,
              errorBuilder: (context, error, stackTrace) =>
                  Icon(Symbols.factory),
            )
          : Icon(Symbols.factory);

      title = Text(
        [
          if (company.name.isNotEmpty) company.name,
          if (partner.name.isNotEmpty) partner.name,
        ].join(" "),
      );
    } else {
      leading = Icon(Icons.person);
      title = Text(partner.name);
    }

    return ValueListenableBuilder(
      valueListenable: widget.viewmodel.changePartner,
      builder: (context, selected, child) {
        return ListTile(
          onTap: () {
            if (selected == partner) {
              widget.viewmodel.changePartner(null);
            } else {
              widget.viewmodel.changePartner(partner);
            }
          },
          leading: leading,
          trailing: selected == partner ? Icon(Icons.check) : null,
          title: title,
          subtitle: subtitle,
          selected: partner == selected,
        );
      },
    );
  }

  void addPartner(BuildContext context) async {
    TransactionPartnerDetailsViewmodel vm = TransactionPartnerDetailsViewmodel(
      transactionPartnerRepository: context.read(),
    );
    vm.createEntity.execute();

    var p = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            Navigator.pop(context, vm.entity);
          },
          child: TransactionPartnerDetails(viewmodel: vm),
        ),
      ),
    );
    if (p != null && p is TransactionPartner) {
      widget.viewmodel.changePartner(p);
      tabController.animateTo(2);
    }
  }

  Widget productCard((Product, double?) item, double amount) {
    final card = Card.filled(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {
          widget.viewmodel.addProduct(item.$1, item.$2);
        },
        onLongPress: () {
          widget.viewmodel.addProductDetails(context, item.$1, item.$2);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    item.$2 == null ? "" : "${item.$2!.toReadableString()} €",
                    style: TextStyle(fontSize: 10),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                    fit: BoxFit.contain,
                    item.$1.imageLink,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(item.$1.iconData),
                  ),
                ),
              ),
              if (item.$1.producer != null)
                AutoHyphenatingText(
                  item.$1.producer!.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 10),
                ),
              AutoHyphenatingText(
                item.$1.name,
                maxLines: 3,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 10),
              ),
              if (item.$1.productPackage.isNotEmpty)
                Text(
                  "(${item.$1.productPackage})",
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 10),
                ),
            ],
          ),
        ),
      ),
    );
    return amount > 0.0
        ? Badge(label: Text(amount.toReadableString()), child: card)
        : card;
  }

  Widget partCard(TransactionPartContent part) {
    final card = SizedBox(
      width: 90,
      child: Card.filled(
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: () {
            widget.viewmodel.partDetailsDialog(context, part);
          },
          onLongPress: () {
            widget.viewmodel.removePart(part);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (part.amount != null)
                      Expanded(
                        child: Text(
                          [
                            (part.amount!.toReadableString()),
                            "${part.product?.size?.toReadableString() ?? ""}${part.product?.unit}",
                          ].join(part.product?.size != null ? "x" : ""),
                          maxLines: 1,
                          style: TextStyle(fontSize: 8),
                          overflow: TextOverflow.clip,
                        ),
                      ),
                    Text(
                      "${part.value.toReadableString()} €",
                      maxLines: 1,
                      style: TextStyle(fontSize: 8),
                    ),
                  ],
                ),
                if (part.product != null)
                  AutoHyphenatingText(
                    part.product!.displayShort,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 9),
                  ),
                if (part.product == null && part.purpose.isNotEmpty)
                  AutoHyphenatingText(
                    part.purpose,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 9),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
    return card;
  }

  Widget buildContentPage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4.0,
            children: [
              Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      height: 70,
                      child: CustomScrollView(
                        controller: widget.viewmodel.scrollControllerParts,
                        scrollDirection: Axis.horizontal,
                        slivers: [
                          ListenableBuilder(
                            listenable: widget.viewmodel,
                            builder: (context, child) => SliverList.list(
                              children: [
                                for (var p in widget.viewmodel.transactionParts)
                                  partCard(p),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      spacing: 4.0,
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: "Produkt"),
                            controller: productNameController,
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: "Hersteller",
                            ),
                            controller: productProducerController,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ListenableBuilder(
                    listenable: widget.viewmodel,
                    builder: (context, child) =>
                        PriceBadge(widget.viewmodel.sum, bold: true),
                  ),
                  IconButton(
                    onPressed: () => widget.viewmodel.addTextPart(context),
                    icon: Icon(Symbols.add_notes),
                  ),
                  IconButton(
                    onPressed: () => widget.viewmodel.createProduct(context),
                    icon: Icon(Symbols.box_add),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: EdgeInsetsGeometry.all(8.0),
                  sliver: PagingListener(
                    controller: widget.viewmodel.productPagingController,
                    builder: (context, state, fetchNextPage) {
                      return PagedSliverGrid<int, (Product, double?)>(
                        state: state,
                        fetchNextPage: fetchNextPage,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 4.0,
                          mainAxisSpacing: 4.0,
                          mainAxisExtent: 150,
                        ),
                        builderDelegate: PagedChildBuilderDelegate(
                          itemBuilder: (context, item, index) =>
                              ListenableBuilder(
                                listenable: widget.viewmodel,
                                builder: (context, child) {
                                  final amount = widget.viewmodel.productAmount(
                                    item.$1,
                                  );
                                  return productCard(item, amount);
                                },
                              ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
