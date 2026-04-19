abstract class WeakEntity {
  Map<String, dynamic> toJson();
}

abstract class StrongEntity implements WeakEntity {
  int get id;
  String get displayShort;
}
