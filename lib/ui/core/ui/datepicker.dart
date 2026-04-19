import 'package:flutter/material.dart';

class Datepicker extends StatefulWidget {
  const Datepicker({
    super.key,
    this.initialValue,
    this.label,
    this.nullable,
    required this.onDate,
  });

  final DateTime? initialValue;

  final bool? nullable;

  final String? label;
  final void Function(DateTime? date) onDate;

  @override
  State<Datepicker> createState() => _DatepickerState();
}

class _DatepickerState extends State<Datepicker> {
  final TextEditingController controller = TextEditingController();

  DateTime? _currentValue;

  @override
  void initState() {
    _setValue(widget.initialValue);
    super.initState();
  }

  void _setValue(DateTime? value) {
    _currentValue = value;
    controller.text = value?.toString().substring(0, 10) ?? "";
  }

  void _valueChange(DateTime? value) {
    _setValue(value);
    widget.onDate(value);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.none,
      readOnly: true,
      controller: controller,
      onTap: _showPicker,
      decoration: InputDecoration(
        label: widget.label == null ? null : Text(widget.label!),
        prefixIcon: IconButton(
          icon: Icon(Icons.calendar_month),
          onPressed: _showPicker,
        ),
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
    showDatePicker(
      context: context,
      firstDate: DateTime.fromMillisecondsSinceEpoch(0),
      lastDate: DateTime(3000),
      initialDate: _currentValue,
    ).then((value) {
      if (value != null) {
        setState(() {
          _valueChange(value);
        });
      }
    });
  }
}
