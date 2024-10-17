import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import "package:intl/intl.dart";
import 'package:steady_routine/model/routine.dart';
import 'package:steady_routine/model/category_type.dart';
import 'package:steady_routine/service/realm_service.dart';
import 'dart:async';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  AccountScreenState createState() => AccountScreenState();
}

class AccountScreenState extends State<AccountScreen>
    with WidgetsBindingObserver {
  final _routineController =
      StreamController<List<(String, RoutineModel)>>.broadcast();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _fetchRoutine();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _routineController.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _fetchRoutine();
    }
  }

  @override
  Widget build(BuildContext context) {
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
          AppLocalizations.of(context)!.account_title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22.0,
            color: Colors.black,
          ),
        ),
      ),
      body: Scaffold(
          backgroundColor: Colors.white,
          body: Expanded(
            child: StreamBuilder<List<(String, RoutineModel)>>(
              stream: _routineController.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  // Group routines by category
                  final Map<String, List<RoutineModel>> groupedRoutines = {};

                  for (var item in snapshot.data!) {
                    final category = item.$1; // First element is the category
                    final routine =
                        item.$2; // Second element is the RoutineModel

                    if (!groupedRoutines.containsKey(category)) {
                      groupedRoutines[category] = [];
                    }
                    groupedRoutines[category]!.add(routine);
                  }

                  return ListView.builder(
                    itemCount: groupedRoutines.keys.length,
                    itemBuilder: (context, categoryIndex) {
                      final category =
                          groupedRoutines.keys.elementAt(categoryIndex);
                      final routinesInCategory = groupedRoutines[category]!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Routines in this category
                          ListView.builder(
                            physics:
                                const NeverScrollableScrollPhysics(), // Prevent scrolling of inner list
                            shrinkWrap:
                                true, // Use shrinkWrap to limit the height of the inner list
                            itemCount: routinesInCategory.length,
                            itemBuilder: (context, index) {
                              final event = routinesInCategory[index];
                              var formatter = DateFormat('yyyy/MM/dd');
                              var formatted = formatter.format(event.created);
                              return Padding(
                                padding:
                                    const EdgeInsets.only(left: 16, right: 16),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildHistoryItem(
                                        context,
                                        isFirst: index == 0,
                                        icon: event.category
                                            .toCategory()
                                            .toImagePath(),
                                        title: event.category,
                                        date: formatted,
                                        activities: [
                                          _buildActivity(
                                            event.routineName,
                                            event.completeDays.length,
                                            event.maxCount,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          const Divider(), // Optional divider between categories
                        ],
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return const SizedBox(); // Show an empty state if no data
                }
              },
            ),
          )),
    );
  }

  Widget _buildHistoryItem(BuildContext context,
      {required bool isFirst,
      required String icon,
      required String title,
      required String date,
      required List<Widget> activities}) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Row(
          children: [
            // Conditionally display the icon or a placeholder SizedBox
            isFirst
                ? SizedBox(
                    width: 50,
                    child: Image.asset(
                      icon,
                    ),
                  )
                : const SizedBox(width: 50),
            const SizedBox(width: 10),
            isFirst
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "登録日： $date",
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  )
                : const SizedBox(width: 50),
            const Spacer(flex: 1),
            Column(
              children: [
                ...activities,
              ],
            )
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildActivity(String name, int progress, int total,
      {bool isCompleted = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(
            width: 80,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                name,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            )),
        SizedBox(
            width: 80,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                '$progress / $total',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: isCompleted ? Colors.pink : Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )),
      ],
    );
  }

  void _fetchRoutine() async {
    List<RoutineModel> routines = await RealmService.realmInstance.getAll();

    const List<CategoryType> categoryOrder = [
      CategoryType.diet,
      CategoryType.beauty,
      CategoryType.child,
      CategoryType.study,
      CategoryType.medicine,
      CategoryType.book,
      CategoryType.food,
      CategoryType.other,
    ];
    routines.sort((a, b) {
      final indexA = categoryOrder.indexOf(a.category.toCategory());
      final indexB = categoryOrder.indexOf(b.category.toCategory());
      return indexA.compareTo(indexB);
    });

    final List<(String, RoutineModel)> routineWithCategory = [];

    for (var routine in routines) {
      final category = routine.category;
      routineWithCategory.add((category, routine));
    }

    // Add the list to the stream
    _routineController.add(routineWithCategory);
  }

  void sortRoutinesByCategory(List<RoutineModel> routines) {}
}
