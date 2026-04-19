import 'package:transactions/utils/datetime_extension.dart';
import 'package:flutter/material.dart';

class TimeOfDayPicker extends StatefulWidget {
  const TimeOfDayPicker({
    super.key,
    this.initialValue,
    this.nullable,
    this.label,
    required this.onTimeOfDay,
  });

  final TimeOfDay? initialValue;

  final String? label;
  final bool? nullable;

  final void Function(TimeOfDay? time) onTimeOfDay;

  @override
  State<TimeOfDayPicker> createState() => _DatepickerState();
}

class _DatepickerState extends State<TimeOfDayPicker> {
  final TextEditingController controller = TextEditingController();

  TimeOfDay? _currentValue;

  @override
  void initState() {
    _setValue(widget.initialValue);
    super.initState();
  }

  void _setValue(TimeOfDay? value) {
    _currentValue = value;
    controller.text = value?.toJson() ?? "";
  }

  void _valueChange(TimeOfDay? value) {
    _setValue(value);
    widget.onTimeOfDay(value);
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
    showTimePicker(
      context: context,
      initialTime: _currentValue ?? TimeOfDay(hour: 12, minute: 0),
    ).then((value) {
      if (value != null) {
        setState(() {
          _valueChange(value);
        });
      }
    });
  }
}
