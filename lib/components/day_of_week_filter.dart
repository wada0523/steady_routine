import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DayOfWeekFilter extends StatefulWidget {
  final List<int>? initialFiltersNum;

  @override
  State<DayOfWeekFilter> createState() => DayOfWeekFilterState();

  const DayOfWeekFilter({super.key, this.initialFiltersNum});
}

class DayOfWeekFilterState extends State<DayOfWeekFilter> {
  List<int> filtersNum = <int>[];
  List<String> filters = <String>[];

  @override
  void initState() {
    super.initState();
    filtersNum = widget.initialFiltersNum ?? <int>[];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    filters.addAll(
      filtersNum.map((day) => getDayString(day)).toList(),
    );
  }

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
            if (value == true) {
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

  String getDayString(int day) {
    switch (day) {
      case 1:
        return AppLocalizations.of(context)!.monday;
      case 2:
        return AppLocalizations.of(context)!.tuesday;
      case 3:
        return AppLocalizations.of(context)!.wednesday;
      case 4:
        return AppLocalizations.of(context)!.thursday;
      case 5:
        return AppLocalizations.of(context)!.friday;
      case 6:
        return AppLocalizations.of(context)!.saturday;
      case 7:
        return AppLocalizations.of(context)!.sunday;
      default:
        return "";
    }
  }
}
