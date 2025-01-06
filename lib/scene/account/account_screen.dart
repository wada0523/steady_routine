import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import "package:intl/intl.dart";
import 'package:steady_routine/model/routine.dart';
import 'package:steady_routine/model/category_type.dart';
import 'package:steady_routine/service/realm_service.dart';
import 'package:steady_routine/util/admob.dart';

class AccountScreen extends HookConsumerWidget {
  AccountScreen({super.key});

  final _routineController =
      StreamController<List<(String, RoutineModel)>>.broadcast();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bannerId = getAdBannerUnitId();
    BannerAd myBanner = BannerAd(
        adUnitId: bannerId,
        size: AdSize.banner,
        request: const AdRequest(),
        listener: const BannerAdListener());
    myBanner.load();

    useEffect(() {
      _fetchRoutine();
      return null;
    }, []);

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
        body: StreamBuilder<List<(String, RoutineModel)>>(
          stream: _routineController.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              // Group routines by category
              final Map<String, List<RoutineModel>> groupedRoutines = {};

              for (var item in snapshot.data!) {
                final category = item.$1; // First element is the category
                final routine = item.$2; // Second element is the RoutineModel

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
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            child: SizedBox(
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                      const Divider(),
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
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Container(
            width: myBanner.size.width.toDouble(),
            height: myBanner.size.height.toDouble(),
            alignment: Alignment.center,
            child: AdWidget(ad: myBanner),
          ),
        ),
      ),
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
                    width: 30,
                    child: Image.asset(
                      icon,
                    ),
                  )
                : const SizedBox(width: 30),
            const SizedBox(width: 15),
            isFirst
                ? SizedBox(
                    width: 120,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "登録日： $date",
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  )
                : const SizedBox(width: 120),
            const SizedBox(width: 30),
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
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
            width: 90,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 14,
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
                  fontSize: 14,
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
