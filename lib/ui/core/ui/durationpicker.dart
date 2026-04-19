import 'package:transactions/utils/datetime_extension.dart';
import 'package:flutter/material.dart';
import 'package:material_duration_picker/material_duration_picker.dart';

class DurationPicker extends StatefulWidget {
  const DurationPicker({
    super.key,
    this.initialValue,
    this.nullable,
    this.label,
    required this.onDuration,
  });

  final Duration? initialValue;

  final String? label;
  final bool? nullable;

  final void Function(Duration? duration) onDuration;

  @override
  State<DurationPicker> createState() => _DatepickerState();
}

class _DatepickerState extends State<DurationPicker> {
  final TextEditingController controller = TextEditingController();

  Duration? _currentValue;

  @override
  void initState() {
    _setValue(widget.initialValue);
    super.initState();
  }

  void _setValue(Duration? value) {
    _currentValue = value;
    controller.text = value?.toJson() ?? "";
  }

  void _valueChange(Duration? value) {
    _setValue(value);
    widget.onDuration(value);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.none,
      readOnly: true,
      controller: controller,
      onTap: _showPicker,

      decoration: InputDecoration(
        prefixIcon: IconButton(
          icon: Icon(Icons.schedule),
          onPressed: _showPicker,
        ),
        label: widget.label == null ? null : Text(widget.label!),
        suffixIcon: _currentValue == null || widget.nullable == false
            ? null
            : IconButton(
                onPressed: () {
                  setState(() {
                    _valueChange(null);
                  });
                },
                icon: Icon(Icons.clear),
              ),
      ),
    );
  }

  void _showPicker() {
    showDurationPicker(
      context: context,
      durationPickerMode: DurationPickerMode.ms,
      initialDuration: _currentValue ?? Duration(hours: 0),
      initialEntryMode: DurationPickerEntryMode.input,
    ).then((value) {
      if (value != null) {
        setState(() {
          _valueChange(value);
        });
      }
    });
  }
}
