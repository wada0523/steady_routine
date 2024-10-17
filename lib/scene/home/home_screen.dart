import 'dart:async';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:realm/realm.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:steady_routine/scene/account/account_screen.dart';
import 'package:steady_routine/model/category_type.dart';
import 'package:steady_routine/scene/detail/routine_detail.dart';
import 'package:steady_routine/scene/settings/setting_screen.dart';
import 'package:steady_routine/scene/routine/add_routine_screen.dart';
import 'package:steady_routine/model/routine.dart';
import 'package:steady_routine/service/realm_service.dart';

class HomeScreen extends HookConsumerWidget {
  HomeScreen({super.key});

  final _eventController = StreamController<List<RoutineModel>>.broadcast();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasRoutine = useState<bool>(false);
    final selectedIndex = useState<int>(0);
    final selectedDate = useState<DateTime>(DateTime.now());
    final checkStates = useState<Map<String, Map<ObjectId, bool>>>({});

    useEffect(() {
      _checkHasRoutine(hasRoutine);
      return null;
    }, []);

    useEffect(() {
      _fetchRoutine(selectedDate.value, checkStates);
      return null;
    }, [selectedDate.value]);

    return Scaffold(
      appBar: AppBar(),
      body: Column(children: [
        EasyDateTimeLine(
          initialDate: selectedDate.value,
          onDateChange: (date) {
            selectedDate.value = date;
          },
          activeColor: const Color(0xffFFBF9B),
          dayProps: const EasyDayProps(
            height: 56.0,
            width: 56.0,
            dayStructure: DayStructure.dayNumDayStr,
            inactiveDayStyle: DayStyle(
              borderRadius: 48.0,
              dayNumStyle: TextStyle(
                fontSize: 18.0,
              ),
            ),
            activeDayStyle: DayStyle(
              dayNumStyle: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          locale: "ja",
        ),
        const SizedBox(height: 20),
        Expanded(
          child: StreamBuilder<List<RoutineModel>>(
            stream: _eventController.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data?.isNotEmpty == true) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final routine = snapshot.data![index];
                    bool isComplete =
                        checkStates.value[selectedDate.value.toString()]
                                ?[routine.id] ??
                            false;

                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(height: 60),
                        Align(
                          alignment: const Alignment(0.0, 1.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: 50,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: const Color(0xffD9D9D9)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                const SizedBox(width: 10),
                                Checkbox(
                                  activeColor:
                                      const Color.fromRGBO(33, 150, 243, 1),
                                  value: isComplete,
                                  onChanged: (value) {
                                    bool completeFlg = value ?? false;

                                    // Update checkStates for the selected date
                                    checkStates.value = {
                                      ...checkStates.value,
                                      selectedDate.value.toString(): {
                                        ...checkStates.value[selectedDate.value
                                                .toString()] ??
                                            {},
                                        routine.id: completeFlg,
                                      }
                                    };

                                    // Save the updated state to Realm
                                    RealmService.realmInstance
                                        .updateCompleteFlg(
                                      routine.id,
                                      selectedDate.value,
                                      completeFlg,
                                    );
                                  },
                                ),
                                Text(routine.routineName),
                                const Spacer(flex: 1),
                                SizedBox(
                                  width: 50,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RoutineDetailScreen(
                                                    routine: routine)),
                                      ).then((value) {
                                        if (value) {
                                          _fetchRoutine(
                                              selectedDate.value, checkStates);
                                        }
                                      });
                                    },
                                    child: Image.asset(
                                        'assets/images/right_arrow.png'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 10,
                          left: 15,
                          child: SizedBox(
                            width: 50,
                            child: Align(
                              alignment: Alignment.center,
                              child: Image.asset(
                                  routine.category.toCategory().toImagePath()),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return _noDataWidget(context, hasRoutine);
              }
            },
          ),
        )
      ]),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/footer_settings.png',
                fit: BoxFit.cover),
            label: "",
          ),
          BottomNavigationBarItem(
            icon:
                Image.asset('assets/images/footer_add.png', fit: BoxFit.cover),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/footer_account.png',
                fit: BoxFit.cover),
            label: "",
          ),
        ],
        currentIndex: selectedIndex.value,
        selectedItemColor: Colors.grey,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          selectedIndex.value = index;
          switch (selectedIndex.value) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              ).then((value) {
                debugPrint(value);
              });
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddRotineScreen()),
              ).then((value) {
                if (value) {
                  if (!hasRoutine.value) {
                    _checkHasRoutine(hasRoutine);
                  }
                }
              });
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AccountScreen()),
              ).then((value) {
                debugPrint(value);
              });
              break;
          }
        },
      ),
    );
  }

  Widget _noDataWidget(BuildContext context, ValueNotifier<bool> hasRoutine) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder:
          (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
        if (snapshot.hasError || hasRoutine.value) {
          return const Text("");
        } else {
          final prefs = snapshot.data;
          final bool firstAddRoutine =
              prefs?.getBool("firstAddRoutine") ?? false;
          if (firstAddRoutine) {
            return const Text("");
          } else {
            return SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Align(
                alignment: Alignment.topCenter,
                child:
                    Image.asset(AppLocalizations.of(context)!.no_data_img_path),
              ),
            );
          }
        }
      },
    );
  }

  void _checkHasRoutine(ValueNotifier<bool> hasRoutine) async {
    int count = await RealmService.realmInstance.getAllCount();
    hasRoutine.value = (count != 0);
  }

  Future<void> _fetchRoutine(DateTime date,
      ValueNotifier<Map<String, Map<ObjectId, bool>>> checkStates) async {
    List<RoutineModel> todayRoutine =
        await RealmService.realmInstance.getRoutines(date);

    Map<ObjectId, bool> newStates = checkStates.value[date.toString()] ?? {};

    for (RoutineModel routine in todayRoutine) {
      bool isComplete = routine.completeDays.contains(
        DateFormat('yyyyMMdd').format(date),
      );
      newStates[routine.id] = isComplete;
    }

    checkStates.value = {
      ...checkStates.value,
      date.toString(): newStates,
    };

    _eventController.add(todayRoutine);
  }
}
