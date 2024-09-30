import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DayOfWeekFilter extends StatefulWidget {
  @override
  State<DayOfWeekFilter> createState() => DayOfWeekFilterState();

  const DayOfWeekFilter({super.key});
}

class DayOfWeekFilterState extends State<DayOfWeekFilter> {
  final List<int> filtersNum = <int>[];
  final List<String> filters = <String>[];

  Iterable<Widget> dayOfWeekWidgets(BuildContext context) sync* {
    List<String> weekdays = [
      AppLocalizations.of(context)!.monday,
      AppLocalizations.of(context)!.tuesday,
      AppLocalizations.of(context)!.wednesday,
      AppLocalizations.of(context)!.thursday,
      AppLocalizations.of(context)!.friday,
      AppLocalizations.of(context)!.saturday,
      AppLocalizations.of(context)!.sunday,
    ];

    for (final (index, weekday) in weekdays.indexed) {
      yield FilterChip(
        padding: const EdgeInsets.all(10),
        label: Text(weekday,
            style: TextStyle(
                color:
                    filters.contains(weekday) ? Colors.white : Colors.black)),
        shape: CircleBorder(
          side: BorderSide(
              width: 1,
              style: BorderStyle.solid,
              color: filters.contains(weekday) ? Colors.pink : Colors.grey),
        ),
        backgroundColor: const Color(0xffececec),
        selectedColor: const Color(0xfff88273),
        showCheckmark: false,
        selected: filters.contains(weekday),
        onSelected: (value) {
          setState(() {
            if (value) {
              filters.add(weekday);
              filtersNum.add(index + 1); // DateTimeクラスのweekdayは1（=月曜日）
            } else {
              filters.removeWhere((value) => value == weekday);
              filtersNum.removeWhere((value) => value == index + 1);
            }
          });
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Ink(
      color: Colors.white,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Wrap(
              children: dayOfWeekWidgets(context).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
