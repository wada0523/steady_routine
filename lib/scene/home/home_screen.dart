import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:steady_routine/scene/account/account_screen.dart';
import 'package:steady_routine/model/category_type.dart';
import 'package:steady_routine/scene/settings/setting_screen.dart';
import 'package:steady_routine/scene/routine/add_routine_screen.dart';
import 'package:steady_routine/model/routine.dart';
import 'package:steady_routine/service/realm_service.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  int _selectedIndex = 0;
  DateTime _selectedDate = DateTime.now();
  final _eventController = StreamController<List<RoutineModel>>.broadcast();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _fetchRoutine(DateTime.now());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _eventController.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _fetchRoutine(DateTime.now());
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      switch (_selectedIndex) {
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
            MaterialPageRoute(builder: (context) => const AddRotineScreen()),
          ).then((value) {
            if (value) {
              _fetchRoutine(_selectedDate);
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Scaffold(
        backgroundColor: Colors.white,
        body: Column(children: [
          EasyDateTimeLine(
            initialDate: _selectedDate,
            onDateChange: (selectedDate) {
              _selectedDate = selectedDate;
              _fetchRoutine(selectedDate);
            },
            activeColor: const Color(0xffFFBF9B),
            headerProps: const EasyHeaderProps(
              dateFormatter: DateFormatter.monthOnly(),
            ),
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
            locale: AppLocalizations.of(context)?.localeName ?? "ja",
          ),
          const SizedBox(height: 20),
          Expanded(
            child: StreamBuilder<List<RoutineModel>>(
              stream: _eventController.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data?.isNotEmpty == true) {
                  return ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        final event = snapshot.data![index];
                        var formatter = DateFormat('yyyyMMdd');
                        var completeDay = formatter.format(_selectedDate);
                        var checkState =
                            event.completeDays.contains(completeDay);
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
                                  border: Border.all(
                                      color: const Color(0xffD9D9D9)),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    const SizedBox(width: 10),
                                    Checkbox(
                                      activeColor: Colors.blue,
                                      value: checkState,
                                      onChanged: (value) => setState(() {
                                        checkState = !checkState;
                                        RealmService.realmInstance
                                            .updateRoutine(event.id,
                                                _selectedDate, checkState);
                                      }),
                                    ),
                                    Text(event.routineName),
                                    const Spacer(flex: 1),
                                    SizedBox(
                                      width: 50,
                                      child: Image.asset(
                                        'assets/images/right_arrow.png',
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
                                    event.category.toCategory().toImagePath(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      });
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Image.asset(
                        AppLocalizations.of(context)!.no_data_img_path,
                      ),
                    ),
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
                icon: Image.asset(
                  'assets/images/footer_settings.png',
                  fit: BoxFit.cover,
                ),
                label: ""),
            BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/images/footer_add.png',
                  fit: BoxFit.cover,
                ),
                label: ""),
            BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/images/footer_account.png',
                  fit: BoxFit.cover,
                ),
                label: ""),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.grey,
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  void _fetchRoutine(DateTime date) async {
    List<RoutineModel> todayRoutine =
        await RealmService.realmInstance.getRoutines(date);
    _eventController.add(todayRoutine);
  }
}
