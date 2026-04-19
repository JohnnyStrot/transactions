import 'package:transactions/data/services/api/api_service.dart';
import 'package:transactions/ui/core/themes/dimens.dart';
import 'package:transactions/ui/core/ui/image_upload.dart';
import 'package:transactions/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ImageView extends StatefulWidget {
  const ImageView({
    super.key,
    required this.type,
    required this.attr,
    required this.id,
    this.image,
    this.images,
    this.label = "Bild",
    required this.apiService,
    this.imageAspectRatio,
  });

  final String type;
  final String attr;
  final int id;
  final String label;
  final String? image;
  final List<String>? images;

  final ApiService apiService;

  final double? imageAspectRatio;

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  static const String _baseImageUrl = String.fromEnvironment(
    'base_image_url',
    defaultValue: 'http://localhost:4006/image-data',
  );

  @override
  void initState() {
    image = widget.image;
    images = widget.images;

    super.initState();
  }

  String? image;

  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  List<String>? images;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: Dimens.vgap,
          horizontal: Dimens.hgap,
        ),
        child: Column(
          spacing: Dimens.vgap,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              alignment: Alignment.topRight,
              children: [
                AspectRatio(
                  aspectRatio: widget.imageAspectRatio ?? 1.0,
                  child: Center(child: _getImage()),
                ),

                if (image != null || (images != null && images!.isNotEmpty))
                  FloatingActionButton.small(
                    heroTag: null,
                    onPressed: () {
                      if (image != null) {
                        _delete(image!);
                      } else {
                        _delete(images![_current]);
                      }
                    },
                    child: Icon(Icons.delete),
                  ),
                if (images != null && images!.isNotEmpty)
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        decoration: BoxDecoration(
                          color: ColorScheme.of(context).surface.withAlpha(100),
                        ),
                        child: Text("${_current + 1} von ${images!.length}"),
                      ),
                    ),
                  ),
              ],
            ),
            ImageUpload(
              apiService: widget.apiService,
              type: widget.type,
              attr: widget.attr,
              id: widget.id,
              multiple: widget.images != null,
              label: widget.label,
              onUpload: ({file, files}) {
                if (file != null) {
                  setState(() {
                    image = file;
                    images = null;
                  });
                } else if (files != null) {
                  setState(() {
                    if (images != null) {
                      images!.addAll(files);
                    } else {
                      images = files;
                      image = null;
                    }
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _delete(String image) async {
    var res = await widget.apiService.deleteImage(
      "image-upload/${widget.type}/${widget.attr}/${widget.id}",
      image,
    );
    switch (res) {
      case Ok<void>():
        setState(() {
          if (images != null) {
            images!.remove(image);
            if (_current >= images!.length) {
              _current = 0;
              _controller.animateToPage(0);
            }
          }
          this.image = null;
        });
      case Error<void>():
        if (context.mounted && mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Fehler beim Löschen")));
        }
    }
  }

  Widget _getImage() {
    if (image != null) {
      return Image.network(
        "$_baseImageUrl/${widget.type}/${widget.attr}/${widget.id}/$image",
        errorBuilder: (context, error, stackTrace) {
          return Text("Fehler beim Laden des Bildes: $error");
        },
      );
    } else if (images != null && images!.isNotEmpty) {
      return CarouselSlider.builder(
        carouselController: _controller,
        itemCount: images!.length,
        itemBuilder: (context, index, realIndex) {
          return Image.network(
            "$_baseImageUrl/${widget.type}/${widget.attr}/${widget.id}/${images![index]}",
            errorBuilder: (context, error, stackTrace) {
              return Text("Fehler beim Laden des Bildes");
            },
          );
        },
        options: CarouselOptions(
          aspectRatio: widget.imageAspectRatio ?? 1.0,
          onPageChanged: (index, reason) {
            setState(() {
              _current = index;
            });
          },
        ),
      );
    } else if (images != null) {
      return Text(
        "Keine Bilder",
        style: TextStyle(fontStyle: FontStyle.italic),
      );
    } else {
      return Text("Kein Bild", style: TextStyle(fontStyle: FontStyle.italic));
    }
  }
}
