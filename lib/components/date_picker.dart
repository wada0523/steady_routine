import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

class CustomDatePicker extends StatefulWidget {
  final DateTime? initialDate;

  const CustomDatePicker({super.key, this.initialDate});

  @override
  State<CustomDatePicker> createState() => CustomDatePickerState();
}

class CustomDatePickerState extends State<CustomDatePicker> {
  late DateTime date;
  String _dateString = "";

  @override
  void initState() {
    super.initState();
    date = widget.initialDate?.toLocal() ??
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    _dateString = DateFormat('yyyy / M / d').format(date);
  }

  void _updateDate(DateTime date) {
    setState(() {
      this.date = date;
      _dateString = DateFormat('yyyy / M / d').format(date);
    });
  }

  void setDate(DateTime? newDate) {
    if (newDate != null) {
      _updateDate(newDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {
            DatePicker.showDatePicker(context, showTitleActions: true,
                onChanged: (date) {
              _updateDate(date);
            }, onConfirm: (date) {
              _updateDate(date);
            }, currentTime: DateTime.now(), locale: LocaleType.jp);
          },
          child: Text(
            _dateString,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
