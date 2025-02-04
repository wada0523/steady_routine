import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:realm/realm.dart' as realm;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:steady_routine/scene/account/account_screen.dart';
import 'package:steady_routine/model/category_type.dart';
import 'package:steady_routine/scene/detail/routine_detail.dart';
import 'package:steady_routine/scene/settings/setting_screen.dart';
import 'package:steady_routine/scene/routine/add_routine_screen.dart';
import 'package:steady_routine/model/routine.dart';
import 'package:steady_routine/service/realm_service.dart';
import 'package:steady_routine/providers/locale_provider.dart';
import 'package:steady_routine/util/admob.dart';

class HomeScreen extends HookConsumerWidget {
  HomeScreen({super.key});

  final EasyInfiniteDateTimelineController _controller =
      EasyInfiniteDateTimelineController();
  final _eventController = StreamController<List<RoutineModel>>.broadcast();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bannerId = getAdBannerUnitId();
    BannerAd myBanner = BannerAd(
        adUnitId: bannerId,
        size: AdSize.banner,
        request: const AdRequest(),
        listener: const BannerAdListener());
    myBanner.load();

    final now = DateTime.now().toLocal();
    final hasRoutine = useState<bool>(false);
    final selectedIndex = useState<int>(0);
    final selectedDate =
        useState<DateTime>(DateTime(now.year, now.month, now.day));
    final checkStates = useState<Map<String, Map<realm.ObjectId, bool>>>({});

    // 現在のロケールを監視
    final currentLocale = ref.watch(localeNotifierProvider);

    useEffect(() {
      _checkHasRoutine(hasRoutine);
      _fetchRoutine(selectedDate.value, checkStates);
      return null;
    }, [selectedDate.value, hasRoutine.value, checkStates.value]);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          EasyInfiniteDateTimeLine(
            controller: _controller,
            firstDate: DateTime(now.year - 1, 1, 1),
            focusDate: selectedDate.value,
            lastDate: DateTime(now.year + 1, 12, 31),
            onDateChange: (date) {
              selectedDate.value = date;
            },
            activeColor: const Color(0xffFFBF9B),
            headerBuilder: (BuildContext context, DateTime date) {
              return Container(
                color: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 60,
                      child: ElevatedButton(
                        onPressed: () async {
                          _controller.animateToCurrentData();
                          selectedDate.value = DateTime.now().toLocal();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffF88273),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.today,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        DateFormat(currentLocale.languageCode == 'ja'
                                ? 'yyyy年MM月'
                                : 'MM/yyyy')
                            .format(date),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 60,
                    )
                  ],
                ),
              );
            },
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
            locale: currentLocale.languageCode,
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
                                          ...checkStates.value[selectedDate
                                                  .value
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
                                  _buildRoutineText(routine),
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
                                          if (value == true) {
                                            _fetchRoutine(selectedDate.value,
                                                checkStates);
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
                                child: Image.asset(routine.category
                                    .toCategory()
                                    .toImagePath()),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  // データが読み込まれるまでローディング表示
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return _noDataWidget(context, hasRoutine);
                }
              },
            ),
          )
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: myBanner.size.width.toDouble(),
            height: myBanner.size.height.toDouble(),
            alignment: Alignment.center,
            child: AdWidget(ad: myBanner),
          ),
          const Divider(
            indent: 10,
            endIndent: 10,
            height: 1,
            color: Color(0xffC6C6C6),
            thickness: 1,
          ),
          BottomNavigationBar(
            showSelectedLabels: false,
            showUnselectedLabels: false,
            backgroundColor: Colors.white,
            items: [
              BottomNavigationBarItem(
                icon: Image.asset('assets/images/footer_settings.png',
                    fit: BoxFit.cover),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: Image.asset('assets/images/footer_add.png',
                    fit: BoxFit.cover),
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
                    MaterialPageRoute(
                        builder: (context) => const SettingsScreen()),
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
                    if (value == true) {
                      _fetchRoutine(selectedDate.value, checkStates);
                      if (!hasRoutine.value) {
                        _checkHasRoutine(hasRoutine);
                      }
                    }
                  });
                  break;
                case 2:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AccountScreen()),
                  ).then((value) {
                    debugPrint(value);
                  });
                  break;
              }
            },
          )
        ],
      ),
    );
  }

  Widget _buildRoutineText(RoutineModel routine) {
    DateTime? time = routine.time?.toLocal();
    return time != null
        ? Text('${routine.routineName} (${DateFormat('HH:mm').format(time)}〜)')
        : Text(routine.routineName);
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
    if (hasRoutine.value != (count != 0)) {
      hasRoutine.value = (count != 0);
    }
  }

  Future<void> _fetchRoutine(
    DateTime date,
    ValueNotifier<Map<String, Map<realm.ObjectId, bool>>> checkStates,
  ) async {
    try {
      // 当日のルーチンを取得
      List<RoutineModel> todayRoutine =
          await RealmService.realmInstance.getRoutines(date);

      // 現在の状態を取得（なければ空のマップを作成）
      Map<realm.ObjectId, bool> newStates =
          checkStates.value[date.toString()] ?? {};

      // 新しい状態を構築
      Map<realm.ObjectId, bool> updatedStates = {};
      for (RoutineModel routine in todayRoutine) {
        bool isComplete = routine.completeDays.contains(
          DateFormat('yyyyMMdd').format(date),
        );
        updatedStates[routine.id] = isComplete;
      }

      // 変更がある場合のみ更新
      if (!mapEquals(newStates, updatedStates)) {
        checkStates.value = {
          ...checkStates.value,
          date.toString(): updatedStates,
        };
      }

      // イベントを追加
      _eventController.add(todayRoutine);
    } catch (error) {
      debugPrint("Error in _fetchRoutine: $error");
      _eventController.addError(error);
    }
  }
}
