import 'package:transactions/data/model/entity.dart';
import 'package:transactions/data/repositories/data_repository.dart';
import 'package:transactions/utils/result.dart';
import 'package:flutter_command/flutter_command.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

abstract class DataListViewmodel<T extends StrongEntity> {
  DataListViewmodel({required this.repository}) {
    deleteEntity = Command.createAsync((entity) async {
      var l = await repository.deleteEntity(entity.id);
      pagingController.refresh();
      return l;
    }, initialValue: Result.ok(null));
  }

  final int take = 20;

  late final pagingController = PagingController<int, T>(
    getNextPageKey: (state) =>
        state.lastPageIsEmpty ? null : state.nextIntPageKey,
    fetchPage: (pageKey) => getEntities(pageKey).then((v) {
      switch (v) {
        case Ok<ResultList<T>>():
          return v.value.entities;
        case Error<ResultList<T>>():
          return [];
      }
    }),
  );

  Future<Result<({int count, List<T> entities})>> getEntities(int pageKey) =>
      repository.getEntities(
        filter: searchValues(),
        take: take,
        skip: (pageKey - 1) * take,
      );

  void exLoadEntities() {
    pagingController.refresh();
  }

  final DataRepository<T> repository;

  late final Command<T, Result<void>> deleteEntity;

  Map<String, dynamic> searchValues();
}
