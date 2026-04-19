import 'dart:convert';

import 'package:transactions/data/model/entity.dart';
import 'package:transactions/data/repositories/data_repository.dart';
import 'package:transactions/data/services/api/api_service.dart';

import '../../../utils/result.dart';

abstract class DataRepositoryRemote<T extends StrongEntity>
    implements DataRepository<T> {
  DataRepositoryRemote({required this.apiService});

  final ApiService apiService;

  String get typeName;
  String get typeApiEndpoint;

  T Function(Map<String, dynamic> json) get fromJson;

  @override
  Future<Result<T>> createEntity() async {
    return await apiService
        .post(typeApiEndpoint, {})
        .then((response) {
          return Result.ok(fromJson(jsonDecode(response.body)));
        })
        .catchError((err) {
          return Result<T>.error(Exception(err));
        });
  }

  @override
  Future<Result<void>> deleteEntity(int id) async {
    return await apiService
        .delete("$typeApiEndpoint/$id", {})
        .then((response) {
          return Result<void>.ok(null);
        })
        .catchError((err) {
          return Result<void>.error(Exception(err));
        });
  }

  @override
  Future<Result<ResultList<T>>> getEntities({
    Map<String, dynamic>? filter,
    String? order,
    bool? orderDesc,
    int? skip,
    int? take,
  }) async {
    var params = <String, dynamic>{};

    if (skip != null) params["skip"] = skip;
    if (take != null) params["take"] = take;
    if (order != null) params["order"] = order;
    if (orderDesc != null) params["order_desc"] = orderDesc;
    if (filter != null) params.addAll(filter);

    return await apiService
        .get(typeApiEndpoint, params: params)
        .then((response) {
          var res = jsonDecode(response.body);

          List<T> entities = (res["entities"] as List<dynamic>).map((
            entityJson,
          ) {
            return fromJson(entityJson);
          }).toList();
          int count = res["count"];

          return Result<ResultList<T>>.ok((entities: entities, count: count));
        })
        .catchError((err) {
          print(err);
          return Result<ResultList<T>>.error(Exception(err));
        });
  }

  @override
  Future<Result<T>> getEntity(int id) async {
    return await apiService
        .get("$typeApiEndpoint/$id")
        .then((response) {
          return Result<T>.ok(fromJson(jsonDecode(response.body)));
        })
        .catchError((err) {
          return Result<T>.error(Exception(err));
        });
  }

  @override
  Future<Result<void>> saveEntity(T entity) async {
    return await apiService
        .put("$typeApiEndpoint/${entity.id}", entity.toJson())
        .then((response) {
          return Result<void>.ok(null);
        })
        .catchError((err) {
          return Result<void>.error(Exception(err));
        });
  }
}
