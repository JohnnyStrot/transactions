import 'package:transactions/data/model/addressable.dart';
import 'package:transactions/ui/core/themes/dimens.dart';
import 'package:flutter/material.dart';

class AddressInput extends StatelessWidget {
  const AddressInput({super.key, required this.addressable});

  final Addressable addressable;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: Dimens.vgap,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text("Adresse", style: TextTheme.of(context).headlineSmall),
        Row(
          spacing: Dimens.hgap,
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                validator: (value) => value == null || (value.length <= 45)
                    ? null
                    : "Max. 45 Zeichen",
                controller: TextEditingController(text: addressable.street),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("Straße"),
                ),
                onChanged: (value) {
                  addressable.street = value;
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: TextFormField(
                validator: (value) => value == null || (value.length <= 10)
                    ? null
                    : "Max. 10 Zeichen",
                controller: TextEditingController(
                  text: addressable.houseNumber,
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("Hausnr."),
                ),
                onChanged: (value) {
                  addressable.houseNumber = value;
                },
              ),
            ),
          ],
        ),
        Row(
          spacing: Dimens.hgap,
          children: [
            Expanded(
              flex: 1,
              child: TextFormField(
                validator: (value) => value == null || (value.length <= 10)
                    ? null
                    : "Max. 10 Zeichen",
                controller: TextEditingController(text: addressable.postcode),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("PLZ."),
                ),
                onChanged: (value) {
                  addressable.postcode = value;
                },
              ),
            ),
            Expanded(
              flex: 2,
              child: TextFormField(
                validator: (value) => value == null || (value.length <= 45)
                    ? null
                    : "Max 45 Zeichen",
                controller: TextEditingController(text: addressable.city),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("Stadt"),
                ),
                onChanged: (value) {
                  addressable.city = value;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
