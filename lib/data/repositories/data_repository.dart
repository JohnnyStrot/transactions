import 'package:transactions/utils/result.dart';

typedef ResultList<T> = ({List<T> entities, int count});

abstract class DataRepository<T> {
  Future<Result<ResultList<T>>> getEntities({
    Map<String, dynamic> filter,
    String? order,
    bool? orderDesc,
    int? skip,
    int? take,
  });

  Future<Result<T>> getEntity(int id);
  Future<Result<T>> createEntity();
  Future<Result<void>> saveEntity(T entity);
  Future<Result<void>> deleteEntity(int id);
}
