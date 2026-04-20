import 'package:flutter_command/flutter_command.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:transactions/data/model/company.dart';
import 'package:transactions/data/repositories/data_repository.dart';
import 'package:transactions/data/repositories/company/company_repository.dart';
import 'package:transactions/routing/routes.dart';
import 'package:transactions/ui/company/company_details.dart';
import 'package:transactions/ui/company/company_details_viewmodel.dart';
import 'package:transactions/ui/core/themes/dimens.dart';
import 'package:transactions/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

class CompanyPicker extends StatefulWidget {
  const CompanyPicker({
    super.key,
    required this.repository,
    required this.onSelect,
    this.initialValue,
  });

  final CompanyRepository repository;

  final void Function(Company? l) onSelect;

  final Company? initialValue;

  Future<Result<List<Company>>> getEntities(
    String filterName,
    LoadProps? loadProps,
  ) {
    return repository
        .getEntities(
          filter: {"name": filterName},
          skip: loadProps?.skip,
          take: loadProps?.take,
          order: "name",
          orderDesc: false,
        )
        .then((v) {
          switch (v) {
            case Ok<ResultList<Company>>():
              return Result.ok(v.value.entities);
            case Error<ResultList<Company>>():
              return Result.error(v.error);
          }
        });
  }

  @override
  State<CompanyPicker> createState() => CompanyPickerState();
}

class CompanyPickerState extends State<CompanyPicker> {
  Company? currentValue;

  final int take = 25;

  late TextEditingController nameController;
  late PagingController<int, Company> pagingController;

  @override
  void initState() {
    pagingController = PagingController(
      getNextPageKey: (state) =>
          state.lastPageIsEmpty ? null : state.nextIntPageKey,
      fetchPage: (pageKey) => getData(
        nameController.text,
        LoadProps(skip: (pageKey - 1) * take, take: take),
      ),
    );
    nameController = TextEditingController();
    nameController.debounce(Durations.medium4).addListener(() {
      pagingController.refresh();
    });
    currentValue = widget.initialValue;
    super.initState();
  }

  void select(Company? l) {
    setState(() {
      currentValue = l;
      widget.onSelect(l);
    });
  }

  Future<List<Company>> getData(String filterName, LoadProps? loadProps) {
    return widget.getEntities(filterName, loadProps).then((result) {
      switch (result) {
        case Ok<List<Company>>():
          return result.value;
        case Error<List<Company>>():
          return Future.value([]);
      }
    });
  }

  void addCompany(BuildContext context) async {
    CompanyDetailsViewmodel vm = CompanyDetailsViewmodel(
      companyRepository: context.read(),
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
          child: CompanyDetails(viewmodel: vm),
        ),
      ),
    );
    if (p != null && p is Company) {
      select(p);
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }

  String entityAsString(Company? entity) {
    if (entity == null) {
      return "";
    }
    return entity.displayShort;
  }

  void openBottomSheet(BuildContext context) async {
    final paging = PagingListener(
      controller: pagingController,
      builder: (context, state, fetchNextPage) {
        return PagedSliverList<int, Company>(
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
                IconButton(
                  onPressed: () => addCompany(context),
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

  Widget buildEntry(BuildContext context, Company entity) {
    return ListTile(
      onTap: () {
        select(entity);
        Navigator.pop(context);
      },
      leading: Icon(Icons.label, size: 32),
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
      title: Text(entity.name, style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
