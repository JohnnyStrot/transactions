import 'package:flutter_command/flutter_command.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:transactions/data/model/product.dart';
import 'package:transactions/data/repositories/data_repository.dart';
import 'package:transactions/data/repositories/product/product_repository.dart';
import 'package:transactions/ui/core/themes/dimens.dart';
import 'package:transactions/ui/product/product_details.dart';
import 'package:transactions/ui/product/product_details_viewmodel.dart';
import 'package:transactions/utils/double_to_string_extension.dart';
import 'package:transactions/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

class ProductPicker extends StatefulWidget {
  const ProductPicker({
    super.key,
    required this.repository,
    required this.onSelect,
    this.initialValue,
    this.label,
  });

  final ProductRepository repository;

  final void Function(Product? l) onSelect;

  final Product? initialValue;

  final String? label;

  Future<Result<List<Product>>> getEntities(
    String filterName,
    String filterProducer,
    LoadProps? loadProps,
  ) {
    return repository
        .getEntities(
          filter: {"name": filterName, "producer": filterProducer},
          skip: loadProps?.skip,
          take: loadProps?.take,
          order: "name",
          orderDesc: false,
        )
        .then((v) {
          switch (v) {
            case Ok<ResultList<Product>>():
              return Result.ok(v.value.entities);
            case Error<ResultList<Product>>():
              return Result.error(v.error);
          }
        });
  }

  @override
  State<ProductPicker> createState() => ProductPickerState();
}

class ProductPickerState extends State<ProductPicker> {
  Product? currentValue;

  final int take = 15;

  late TextEditingController nameController;
  late TextEditingController producerController;
  late PagingController<int, Product> pagingController;

  @override
  void initState() {
    pagingController = PagingController(
      getNextPageKey: (state) =>
          state.lastPageIsEmpty ? null : state.nextIntPageKey,
      fetchPage: (pageKey) => getData(
        nameController.text,
        producerController.text,
        LoadProps(skip: (pageKey - 1) * take, take: take),
      ),
    );
    nameController = TextEditingController();
    producerController = TextEditingController();
    nameController.debounce(Durations.medium4).addListener(() {
      pagingController.refresh();
    });
    producerController.debounce(Durations.medium4).addListener(() {
      pagingController.refresh();
    });
    currentValue = widget.initialValue;
    super.initState();
  }

  void select(Product? l) {
    setState(() {
      currentValue = l;
      widget.onSelect(l);
    });
  }

  Future<List<Product>> getData(
    String filterName,
    String filterProducer,
    LoadProps? loadProps,
  ) {
    return widget.getEntities(filterName, filterProducer, loadProps).then((
      result,
    ) {
      switch (result) {
        case Ok<List<Product>>():
          return result.value;
        case Error<List<Product>>():
          return Future.value([]);
      }
    });
  }

  void addProduct(BuildContext context) async {
    ProductDetailsViewmodel vm = ProductDetailsViewmodel(
      productRepository: context.read(),
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
          child: ProductDetails(viewmodel: vm),
        ),
      ),
    );
    if (p != null && p is Product) {
      select(p);
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }

  String entityAsString(Product? entity) {
    if (entity == null) {
      return "";
    }
    return [
      entity.displayShort,
      if (entity.size != null || entity.unit.isNotEmpty)
        "(${entity.size?.toReadableString() ?? ""}${entity.unit})",
    ].join(" ");
  }

  void openBottomSheet(BuildContext context) async {
    final paging = PagingListener(
      controller: pagingController,
      builder: (context, state, fetchNextPage) {
        return PagedSliverList<int, Product>(
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
                    controller: producerController,
                    decoration: InputDecoration(labelText: "Hersteller"),
                  ),
                ),
                IconButton(
                  onPressed: () => addProduct(context),
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
        labelText: widget.label,
        suffixIcon: IconButton(
          onPressed: () => select(null),
          icon: Icon(Icons.clear),
        ),
      ),
      onTap: () => openBottomSheet(context),
    );
  }

  Widget buildEntry(BuildContext context, Product entity) {
    var icon = entity.imageLink.isNotEmpty
        ? Image.network(
            entity.imageLink,
            width: 32,
            height: 32,
            alignment: AlignmentGeometry.center,
            errorBuilder: (context, error, stackTrace) =>
                Icon(Icons.shopping_bag, size: 32),
          )
        : Icon(Icons.shopping_bag, size: 32);
    return ListTile(
      onTap: () {
        select(entity);
        Navigator.pop(context);
      },
      leading: entity.favorite
          ? Badge(
              label: Icon(Icons.star, size: 12),
              backgroundColor: Colors.amber,
              child: icon,
            )
          : icon,
      title: Text(
        "${entity.producer?.name.isNotEmpty ?? false ? "${entity.producer!.name} " : ""}${entity.name}",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle:
          entity.size != null ||
              entity.unit.isNotEmpty ||
              entity.package.isNotEmpty
          ? Text(
              "${entity.size?.toReadableString() ?? ""}${entity.unit} ${entity.package}",
            )
          : null,
    );
  }
}

class _ProductExpansionTile extends StatefulWidget {
  _ProductExpansionTile({
    required this.entity,
    required this.onSelect,
    required ProductRepository repository,
  }) : viewModel = _ProductExpansionTileViewModel(
         entity: entity,
         repository: repository,
       );

  final Product entity;
  final void Function() onSelect;
  final _ProductExpansionTileViewModel viewModel;

  @override
  State<_ProductExpansionTile> createState() => _ProductExpansionTileState();
}

class _ProductExpansionTileViewModel extends ChangeNotifier {
  _ProductExpansionTileViewModel({
    required this.entity,
    required this.repository,
  });

  Product entity;
  ProductRepository repository;
  List<Product>? children;
  bool called = false;

  void loadChildren() {
    if (!called) {
      called = true;
      repository.getChildren(entity.id).then((value) {
        switch (value) {
          case Ok<List<Product>>():
            children = value.value;
            notifyListeners();
          case Error<List<Product>>():
            called = false;
        }
      });
    }
  }
}

class _ProductExpansionTileState extends State<_ProductExpansionTile> {
  @override
  Widget build(BuildContext context) {
    Product entity = widget.entity;
    return ExpansionTile(
      childrenPadding: EdgeInsets.all(0),
      tilePadding: EdgeInsets.all(0),
      title: InkWell(
        onTap: widget.onSelect,
        child: Row(
          spacing: 4,
          children: [
            if (entity.producer != null) Text(entity.producer!.name),
            Text(entity.name),
            if (entity.unit.isNotEmpty || entity.size != null)
              Text("(${entity.size?.toReadableString() ?? ""}${entity.unit})"),
          ],
        ),
      ),
      onExpansionChanged: (value) {
        widget.viewModel.loadChildren();
      },
      children: [
        ListenableBuilder(
          listenable: widget.viewModel,
          builder: (context, child) => widget.viewModel.children == null
              ? Center(child: CircularProgressIndicator())
              : SizedBox(
                  height: 700,
                  child: ListView(
                    children: [
                      for (var child in widget.viewModel.children!)
                        _ProductExpansionTile(
                          entity: child,
                          onSelect: widget.onSelect,
                          repository: widget.viewModel.repository,
                        ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}
