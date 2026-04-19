import 'package:transactions/data/model/entity.dart';
import 'package:transactions/data/repositories/data_repository.dart';
import 'package:transactions/utils/result.dart';
import 'package:flutter_command/flutter_command.dart';

abstract class DetailsViewmodel<
  T extends StrongEntity,
  M extends DetailsViewmodel<T, M>
> {
  DetailsViewmodel({required DataRepository<T> repository})
    : _repository = repository {
    loadEntity = Command.createAsync((id) async {
      final val = await _repository.getEntity(id);
      switch (val) {
        case Ok<T>():
          _entity = val.value;
        case Error<T>():
          _entity = null;
      }
      return val;
    }, initialValue: Result.ok(null));
    createEntity = Command.createAsyncNoParam(() async {
      final val = await _repository.createEntity();
      switch (val) {
        case Ok<T>():
          _entity = val.value;
        case Error<T>():
          _entity = null;
      }
      return val;
    }, initialValue: Result.ok(null));
    saveEntity = Command.createAsyncNoParam(() {
      if (entity == null) {
        return Future.value(Result.error(Exception("$typeName is null")));
      }
      return _repository.saveEntity(entity!);
    }, initialValue: Result.ok(null));
  }

  String get typeName;

  final DataRepository<T> _repository;

  late final Command<int, Result<T?>> loadEntity;
  late final Command<void, Result<T?>> createEntity;
  late final Command<void, Result<void>> saveEntity;

  bool get loading =>
      loadEntity.isExecuting.value || createEntity.isExecuting.value;

  T? _entity;

  T? get entity => _entity;
}
