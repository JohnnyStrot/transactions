import 'package:flutter_test/flutter_test.dart';
import 'package:transactions/utils/double_to_string_extension.dart';

void main() {
  test("double to string 5", () {
    expect(5.0.toReadableString(), "5");
  });
  test("double to string 5.5", () {
    expect(5.5.toReadableString(), "5.5");
  });
  test("double to string 5.0005", () {
    expect(5.0005.toReadableString(), "5.0005");
  });
  test("double to string 5.500", () {
    expect(5.500.toReadableString(), "5.5");
  });
  test("double to string 50", () {
    expect(50.0.toReadableString(), "50");
  });
  test("double to string 500", () {
    expect(500.0.toReadableString(), "500");
  });
  test("double to string 50000", () {
    expect(50000.0.toReadableString(), "50000");
  });
  test("double to string 0050000.05", () {
    expect(0050000.05.toReadableString(), "50000.05");
  });
  test("double to string -0.59 + 0.15", () {
    expect((-0.59 + 0.15).toReadableString(), "0.44");
  });
}
