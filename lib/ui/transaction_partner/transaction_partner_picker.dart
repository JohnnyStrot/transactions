import 'package:flutter_command/flutter_command.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:transactions/data/model/transaction_partner.dart';
import 'package:transactions/data/repositories/data_repository.dart';
import 'package:transactions/data/repositories/transaction_partner/transaction_partner_repository.dart';
import 'package:transactions/routing/routes.dart';
import 'package:transactions/ui/core/themes/dimens.dart';
import 'package:transactions/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

class TransactionPartnerPicker extends StatefulWidget {
  const TransactionPartnerPicker({
    super.key,
    required this.repository,
    required this.onSelect,
    this.initialValue,
  });

  final TransactionPartnerRepository repository;

  final void Function(TransactionPartner? l) onSelect;

  final TransactionPartner? initialValue;

  Future<Result<List<TransactionPartner>>> getEntities(
    String filterName,
    String filterCity,
    LoadProps? loadProps,
  ) {
    return repository
        .getEntities(
          filter: {"filter": filterName, "city": filterCity},
          skip: loadProps?.skip,
          take: loadProps?.take,
          order: "name",
          orderDesc: false,
        )
        .then((v) {
          switch (v) {
            case Ok<ResultList<TransactionPartner>>():
              return Result.ok(v.value.entities);
            case Error<ResultList<TransactionPartner>>():
              return Result.error(v.error);
          }
        });
  }

  @override
  State<TransactionPartnerPicker> createState() =>
      TransactionPartnerPickerState();
}

class TransactionPartnerPickerState extends State<TransactionPartnerPicker> {
  TransactionPartner? currentValue;

  final int take = 25;

  late TextEditingController nameController;
  late TextEditingController cityController;
  late PagingController<int, TransactionPartner> pagingController;

  @override
  void initState() {
    pagingController = PagingController(
      getNextPageKey: (state) =>
          state.lastPageIsEmpty ? null : state.nextIntPageKey,
      fetchPage: (pageKey) => getData(
        nameController.text,
        cityController.text,
        LoadProps(skip: (pageKey - 1) * take, take: take),
      ),
    );
    nameController = TextEditingController();
    cityController = TextEditingController();
    nameController.debounce(Durations.medium4).addListener(() {
      pagingController.refresh();
    });
    cityController.debounce(Durations.medium4).addListener(() {
      pagingController.refresh();
    });
    currentValue = widget.initialValue;
    super.initState();
  }

  void select(TransactionPartner? l) {
    setState(() {
      currentValue = l;
      widget.onSelect(l);
    });
  }

  Future<List<TransactionPartner>> getData(
    String filterName,
    String filterCity,
    LoadProps? loadProps,
  ) {
    return widget.getEntities(filterName, filterCity, loadProps).then((result) {
      switch (result) {
        case Ok<List<TransactionPartner>>():
          return result.value;
        case Error<List<TransactionPartner>>():
          return Future.value([]);
      }
    });
  }

  void addPartner(BuildContext context) async {
    var p = await GoRouter.of(
      context,
    ).push("${Routes.transactionPartners}${Routes.create}");
    if (p != null && p is TransactionPartner) {
      select(p);
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }

  String entityAsString(TransactionPartner? entity) {
    if (entity == null) {
      return "";
    }
    return entity.displayShort;
  }

  void openBottomSheet(BuildContext context) async {
    final paging = PagingListener(
      controller: pagingController,
      builder: (context, state, fetchNextPage) {
        return PagedSliverList<int, TransactionPartner>(
          state: state,
          fetchNextPage: fetchNextPage,
          builderDelegate: PagedChildBuilderDelegate(
            itemBuilder: (context, entity, index) => Padding(
              padding: EdgeInsets.only(top: index > 0 ? 10 : 0),
              child: buildEntry(context, entity),
            ),
          ),
        );
      },
    );

    final scroll = CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.only(
            bottom: Dimens.fabGap,
            right: Dimens.scrollBarGap,
          ),
          sliver: paging,
        ),
      ],
    );

    await showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Dimens.of(context).paddingScreenHorizontal,
              vertical: Dimens.of(context).paddingScreenVertical,
            ),
            child: Row(
              spacing: Dimens.hgap,
              children: [
                Expanded(
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: "Name"),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: cityController,
                    decoration: InputDecoration(labelText: "Stadt"),
                  ),
                ),
                IconButton(
                  onPressed: () => addPartner(context),
                  icon: Icon(Icons.add),
                ),
              ],
            ),
          ),
          Expanded(child: scroll),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: TextEditingController(text: entityAsString(currentValue)),
      decoration: InputDecoration(
        suffixIcon: IconButton(
          onPressed: () => select(null),
          icon: Icon(Icons.clear),
        ),
      ),
      onTap: () => openBottomSheet(context),
    );
  }

  Widget buildEntry(BuildContext context, TransactionPartner entity) {
    return ListTile(
      onTap: () {
        select(entity);
        Navigator.pop(context);
      },
      leading: Icon(Icons.group, size: 32),
      /*entity.imageLink.isNotEmpty
          ? Image.network(
              entity.imageLink,
              width: 32,
              height: 32,
              alignment: AlignmentGeometry.center,
              errorBuilder: (context, error, stackTrace) =>
                  Icon(Icons.group, size: 32),
            )
          : Icon(Icons.group, size: 32)*/
      title: Text(
        "${entity.company?.name.isNotEmpty ?? false ? "${entity.company!.name} " : ""}${entity.name}",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text([entity.city, entity.street].join(", ")),
    );
  }
}
