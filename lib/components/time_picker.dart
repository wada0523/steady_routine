import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:steady_routine/model/custom_picker.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;

class CustomTimePicker extends StatefulWidget {
  @override
  State<CustomTimePicker> createState() => CustomTimePickerState();

  const CustomTimePicker({super.key});
}

class CustomTimePickerState extends State<CustomTimePicker> {
  DateTime time = DateTime.now();
  String _timeString = "";

  @override
  void initState() {
    super.initState();
    _timeString = DateFormat('HH : mm').format(time);
  }

  void _updateTime(DateTime time) {
    setState(() {
      this.time = time;
      _timeString = DateFormat('HH : mm').format(time);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {
            picker.DatePicker.showPicker(context, showTitleActions: true,
                onChanged: (date) {
              _updateTime(date);
            }, onConfirm: (date) {
              _updateTime(date);
            },
                pickerModel: CustomPicker(currentTime: DateTime.now()),
                locale: picker.LocaleType.en);
          },
          child: Text(
            _timeString,
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
