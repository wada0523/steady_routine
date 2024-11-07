import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:realm/realm.dart';
import 'package:steady_routine/components/day_of_week_filter.dart';
import 'package:steady_routine/components/column_divider.dart';
import 'package:steady_routine/components/categories_select.dart';
import 'package:steady_routine/model/category_type.dart';
import 'package:steady_routine/components/date_picker.dart';
import 'package:steady_routine/components/time_picker.dart';
import 'package:steady_routine/util/size_config.dart';
import 'package:steady_routine/model/routine.dart';
import 'package:steady_routine/service/realm_service.dart';

class AddRotineScreen extends StatefulWidget {
  final RoutineModel? routine;

  const AddRotineScreen({super.key, this.routine});

  @override
  AddRotineScreenState createState() => AddRotineScreenState();
}

class AddRotineScreenState extends State<AddRotineScreen> {
  final _formKey = GlobalKey<FormState>();

  List<int> _filtersNum = <int>[];

  ObjectId? _routineId; // null != edit
  int _selectType = 0;
  int _selectNeedsTime = 0;

  final TextEditingController _routineController = TextEditingController();
  final _keyDayOfWeekFilterState = GlobalKey<DayOfWeekFilterState>();
  final _keyDatePickerState = GlobalKey<CustomDatePickerState>();
  final _keyStartDatePickerState = GlobalKey<CustomDatePickerState>();
  final _keyEndDatePickerState = GlobalKey<CustomDatePickerState>();
  final _keyTimePickerState = GlobalKey<CustomTimePickerState>();
  final _keyCategoriesSelectState = GlobalKey<CategoriesSelectState>();
  final TextEditingController _memoController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.routine != null) {
      _routineId = widget.routine!.id;
      _routineController.text = widget.routine!.routineName;
      _selectType = widget.routine!.date != null ? 1 : 0;
      _selectNeedsTime = widget.routine!.time != null ? 0 : 1;

      _filtersNum.addAll(widget.routine!.weekDays);

      _memoController.text = widget.routine!.memo ?? "";
    }
  }

  @override
  void dispose() {
    _routineController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double width = SizeConfig.screenW!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: const Color(0xffC6C6C6),
            height: 1.0,
          ),
        ),
        flexibleSpace: Container(
          color: const Color(0xffffffff),
        ),
        title: Text(
          AppLocalizations.of(context)!.settings_title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22.0,
            color: Colors.black,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          margin: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(AppLocalizations.of(context)!.enter_routine,
                      style: const TextStyle(color: Colors.black))),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xffececec),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextFormField(
                  controller: _routineController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.please_enter_text;
                    }
                    return null;
                  },
                  cursorColor: const Color.fromRGBO(131, 124, 124, 1),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 18,
                    ),
                    isDense: true,
                  ),
                ),
              ),
              const ColumnDivider(),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 100,
                    child: Text(
                      AppLocalizations.of(context)!.type,
                    ),
                  ),
                  const Spacer(),
                  Wrap(
                    spacing: 10,
                    children: [
                      ChoiceChip(
                        showCheckmark: false,
                        label: Text(
                          AppLocalizations.of(context)!.repeat,
                          style: TextStyle(
                            color:
                                _selectType == 0 ? Colors.white : Colors.black,
                          ),
                        ),
                        selected: _selectType == 0,
                        selectedColor: const Color(0xfff88273),
                        backgroundColor: const Color(0xffececec),
                        onSelected: (_) {
                          setState(() {
                            _selectType = 0;
                          });
                        },
                      ),
                      ChoiceChip(
                        showCheckmark: false,
                        label: Text(
                          AppLocalizations.of(context)!.specify_date,
                          style: TextStyle(
                            color:
                                _selectType == 1 ? Colors.white : Colors.black,
                          ),
                        ),
                        selected: _selectType == 1,
                        selectedColor: const Color(0xfff88273),
                        backgroundColor: const Color(0xffececec),
                        onSelected: (_) {
                          setState(() {
                            _selectType = 1;
                          });
                        },
                      ),
                    ],
                  )
                ],
              ),
              const ColumnDivider(),
              Visibility(
                visible: _selectType == 1,
                child: Column(children: <Widget>[
                  Row(children: <Widget>[
                    SizedBox(
                      width: 200,
                      child: Text(
                        AppLocalizations.of(context)!.date,
                      ),
                    ),
                    const Spacer(),
                    CustomDatePicker(
                        key: _keyDatePickerState,
                        initialDate: widget.routine?.date),
                  ]),
                  const ColumnDivider(),
                ]),
              ),
              Visibility(
                visible: _selectType == 0,
                child: Column(children: <Widget>[
                  DayOfWeekFilter(
                      key: _keyDayOfWeekFilterState,
                      initialFiltersNum: _filtersNum),
                  const ColumnDivider(),
                  Row(children: <Widget>[
                    SizedBox(
                      width: 200,
                      child: Text(
                        AppLocalizations.of(context)!.when_will_you_start,
                      ),
                    ),
                    const Spacer(),
                    CustomDatePicker(
                        key: _keyStartDatePickerState,
                        initialDate: widget.routine?.startDate),
                  ]),
                  const ColumnDivider(),
                  Row(children: <Widget>[
                    SizedBox(
                      width: 200,
                      child: Text(
                        AppLocalizations.of(context)!
                            .until_when_will_you_try_it,
                      ),
                    ),
                    const Spacer(),
                    CustomDatePicker(
                        key: _keyEndDatePickerState,
                        initialDate: widget.routine?.endDate),
                  ]),
                  const ColumnDivider(),
                ]),
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 200,
                    child: Text(
                      AppLocalizations.of(context)!.specify_time,
                    ),
                  ),
                  const Spacer(),
                  Wrap(
                    spacing: 10,
                    children: [
                      ChoiceChip(
                        showCheckmark: false,
                        label: Text(
                          AppLocalizations.of(context)!.yes,
                          style: TextStyle(
                            color: _selectNeedsTime == 0
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        selected: _selectNeedsTime == 0,
                        selectedColor: const Color(0xfff88273),
                        backgroundColor: const Color(0xffececec),
                        onSelected: (_) {
                          setState(() {
                            _selectNeedsTime = 0;
                          });
                        },
                      ),
                      ChoiceChip(
                        showCheckmark: false,
                        label: Text(
                          AppLocalizations.of(context)!.no,
                          style: TextStyle(
                            color: _selectNeedsTime == 1
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        selected: _selectNeedsTime == 1,
                        selectedColor: const Color(0xfff88273),
                        backgroundColor: const Color(0xffececec),
                        onSelected: (_) {
                          setState(() {
                            _selectNeedsTime = 1;
                          });
                        },
                      ),
                    ],
                  )
                ],
              ),
              const ColumnDivider(),
              Visibility(
                visible: _selectNeedsTime == 0,
                child: Column(children: <Widget>[
                  Row(children: <Widget>[
                    SizedBox(
                      width: 150,
                      child: Text(
                        AppLocalizations.of(context)!.time,
                      ),
                    ),
                    const Spacer(),
                    CustomTimePicker(
                        key: _keyTimePickerState,
                        initialTime: widget.routine?.time),
                  ]),
                  const ColumnDivider(),
                ]),
              ),
              Row(children: <Widget>[
                SizedBox(
                  width: 100,
                  height: 30,
                  child: Text(
                    AppLocalizations.of(context)!.category,
                  ),
                ),
                CategoriesSelect(
                    key: _keyCategoriesSelectState,
                    initialSelectedType: widget.routine?.category.toCategory())
              ]),
              const ColumnDivider(),
              Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(AppLocalizations.of(context)!.memo,
                      style: const TextStyle(color: Colors.black))),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xffececec),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: SizedBox(
                  height: 100,
                  child: TextFormField(
                    controller: _memoController,
                    cursorColor: const Color.fromRGBO(131, 124, 124, 1),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 18,
                      ),
                      isDense: true,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: ElevatedButton(
                  onPressed: () {
                    if (validation()) {
                      var startDate =
                          _keyStartDatePickerState.currentState?.date;
                      var endDate = _keyEndDatePickerState.currentState?.date;
                      var weekdays =
                          _keyDayOfWeekFilterState.currentState?.filtersNum ??
                              [];
                      var date = _keyDatePickerState.currentState?.date;

                      weekdays.sort();

                      var maxCount = date == null
                          ? countTargetDays(startDate, endDate, weekdays)
                          : 1;

                      if (maxCount == 0) {
                        return;
                      }

                      var routine = RoutineModel(
                          _routineId ?? ObjectId(),
                          _routineController.text,
                          DateTime.now(),
                          _keyCategoriesSelectState.currentState!.selectedType!
                              .toShortString(),
                          maxCount,
                          startDate: startDate,
                          endDate: endDate,
                          date: date,
                          time: _keyTimePickerState.currentState?.time,
                          weekDays: weekdays,
                          memo: _memoController.text);

                      if (_routineId != null) {
                        RealmService.realmInstance.updateRoutine(routine);
                      } else {
                        RealmService.realmInstance.realm.write(() {
                          RealmService.realmInstance.realm.add(routine);
                        });
                      }
                      if (context.mounted) {
                        Navigator.pop(context, true);
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xff585858),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding: (width <= 550)
                        ? const EdgeInsets.symmetric(
                            horizontal: 100, vertical: 20)
                        : EdgeInsets.symmetric(
                            horizontal: width * 0.2, vertical: 25),
                    textStyle: TextStyle(fontSize: (width <= 550) ? 13 : 17),
                  ),
                  child: Text(AppLocalizations.of(context)!.submit),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int countTargetDays(
      DateTime? startDate, DateTime? endDate, List<int> weekdays) {
    int count = 0;

    if (startDate != null && endDate != null) {
      // 開始日から終了日までの日数分ループ
      for (var day = startDate;
          day.isBefore(endDate) || day.isAtSameMomentAs(endDate);
          day = day.add(const Duration(days: 1))) {
        // 曜日が選択されている場合のみカウント
        if (weekdays.contains(day.weekday)) {
          count++;
        }
      }
    }

    return count;
  }

  bool validation() {
    if (_routineController.text == "") {
      return false;
    }
    if (_selectType == 0) {
      // 繰り返し
      List<int>? filters = _keyDayOfWeekFilterState.currentState?.filtersNum;
      if (filters == null || filters.isEmpty) {
        //　曜日指定なし
        return false;
      }
      DateTime? startDate = _keyStartDatePickerState.currentState?.date;
      if (startDate == null) {
        // 開始日なし
        return false;
      }
      DateTime? endDate = _keyEndDatePickerState.currentState?.date;
      if (endDate == null) {
        // 終了日なし
        return false;
      }
    } else {
      DateTime? date = _keyDatePickerState.currentState?.date;
      if (date == null) {
        // 日にちなし
        return false;
      }
    }

    if (_selectNeedsTime == 0) {
      DateTime? time = _keyTimePickerState.currentState?.time;
      if (time == null) {
        // 時間なし
        return false;
      }
    }

    CategoryType? category =
        _keyCategoriesSelectState.currentState?.selectedType;
    if (category == null) {
      //　カテゴリ指定なし
      return false;
    }

    return true;
  }
}
