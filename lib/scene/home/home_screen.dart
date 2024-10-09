import 'dart:async';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    final selectedIndex = useState<int>(0);
    final selectedDate = useState<DateTime>(DateTime.now());
    final checkStates = useState<List<bool>>([]);

    useEffect(() {
      Future.microtask(() async {
        await _fetchRoutine(DateTime.now());
      });
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(),
      body: Column(children: [
        EasyDateTimeLine(
          initialDate: selectedDate.value,
          onDateChange: (date) {
            selectedDate.value = date;
            _fetchRoutine(selectedDate.value);
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
                // 初期のチェックボックス状態を設定
                if (checkStates.value.isEmpty) {
                  checkStates.value = List.generate(
                    snapshot.data!.length,
                    (index) => snapshot.data![index].completeDays.contains(
                      DateFormat('yyyyMMdd').format(selectedDate.value),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final routine = snapshot.data![index];

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
                                  value: checkStates.value[index],
                                  onChanged: (value) {
                                    checkStates.value[index] = value ?? false;
                                    RealmService.realmInstance.updateRoutine(
                                      routine.id,
                                      selectedDate.value,
                                      checkStates.value[index],
                                    );
                                    checkStates
                                        .notifyListeners(); // 状態が変わったことを通知
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
                                          _fetchRoutine(selectedDate.value);
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
                return FutureBuilder<SharedPreferences>(
                  future: SharedPreferences.getInstance(),
                  builder: (BuildContext context,
                      AsyncSnapshot<SharedPreferences> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text("");
                    } else if (snapshot.hasError) {
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
                            child: Image.asset(
                                AppLocalizations.of(context)!.no_data_img_path),
                          ),
                        );
                      }
                    }
                  },
                );
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
                  _fetchRoutine(selectedDate.value);
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

  Future<void> _fetchRoutine(DateTime date) async {
    List<RoutineModel> todayRoutine =
        await RealmService.realmInstance.getRoutines(date);
    _eventController.add(todayRoutine);
  }
}
