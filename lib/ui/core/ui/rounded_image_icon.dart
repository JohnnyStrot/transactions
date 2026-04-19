import 'package:flutter/material.dart';

class RoundedImageIcon extends StatelessWidget {
  /// Location in image-data folder.
  final String imageLocation;
  final double size;

  static const String _baseImageUrl = String.fromEnvironment(
    'base_image_url',
    defaultValue: 'http://localhost:4006/image-data',
  );

  const RoundedImageIcon({
    super.key,
    required this.imageLocation,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Align(
        alignment: Alignment.center,
        child: ClipRRect(
          borderRadius: BorderRadiusGeometry.all(Radius.circular(size * 0.1)),
          child: Image.network(
            "$_baseImageUrl/$imageLocation",
            errorBuilder: (context, error, stackTrace) =>
                Placeholder(color: ColorScheme.of(context).errorContainer),
          ),
        ),
      ),
    );
  }
}
