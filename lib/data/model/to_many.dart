import 'package:transactions/data/model/entity.dart';

class ToMany<T extends WeakEntity> {
  List<T> entities;

  ToMany({required this.entities});

  factory ToMany.fromJson(
    List<dynamic>? json,
    T Function(Map<String, dynamic>) fromJson,
  ) => ToMany(entities: json?.map((c) => fromJson(c)).toList() ?? []);

  List<Map<String, dynamic>> toJson() =>
      entities.map((c) => c.toJson()).toList();
}
