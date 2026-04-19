import 'package:transactions/data/model/entity.dart';
import 'package:transactions/data/repositories/data_repository.dart';
import 'package:transactions/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

abstract class EntitySelect<T extends StrongEntity> extends StatefulWidget {
  const EntitySelect({
    super.key,
    required this.repository,
    required this.onSelect,
    this.initialValue,
  });

  final DataRepository<T> repository;

  final void Function(T? l) onSelect;

  final T? initialValue;

  String entityAsString(T? entity);

  String get label;

  Widget buildItem(
    BuildContext context,
    T item,
    bool isDisabled,
    bool isSelected,
  );

  Future<Result<List<T>>> getEntities(String filter, LoadProps? loadProps) {
    return repository
        .getEntities(
          filter: createFilter(filter),
          skip: loadProps?.skip,
          take: loadProps?.take,
          order: order,
          orderDesc: orderDesc,
        )
        .then((v) {
          switch (v) {
            case Ok<ResultList<T>>():
              return Result.ok(v.value.entities);
            case Error<ResultList<T>>():
              return Result.error(v.error);
          }
        });
  }

  Map<String, dynamic> createFilter(String filter);
  String get order;
  bool get orderDesc => false;
}

abstract class EntitySelectState<T extends StrongEntity>
    extends State<EntitySelect<T>> {
  T? currentValue;

  @override
  void initState() {
    currentValue = widget.initialValue;
    super.initState();
  }

  void select(T? l) {
    setState(() {
      currentValue = l;
      widget.onSelect(l);
    });
  }

  Future<List<T>> getData(String filter, LoadProps? loadProps) {
    return widget.getEntities(filter, loadProps).then((result) {
      switch (result) {
        case Ok<List<T>>():
          return result.value;
        case Error<List<T>>():
          return Future.value([]);
      }
    });
  }
}
