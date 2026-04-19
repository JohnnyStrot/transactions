import 'package:flutter/material.dart';
import 'package:transactions/utils/double_to_string_extension.dart';

class PriceBadge extends StatelessWidget {
  const PriceBadge(this.price, {super.key, this.bold = false});

  final double price;
  final bool bold;

  @override
  Widget build(BuildContext context) => Text(
    "${price.toReadableString(digits: 2)}€",
    textAlign: TextAlign.center,
    style: TextTheme.of(context).bodyLarge!.copyWith(
      color: price < 0
          ? Colors.red
          : price > 0
          ? Colors.lightGreenAccent
          : null,
      fontWeight: bold ? FontWeight.w800 : null,
    ),
  );
}
