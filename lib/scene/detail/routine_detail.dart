import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:steady_routine/components/column_divider.dart';
import 'package:steady_routine/model/category_type.dart';
import 'package:steady_routine/model/routine.dart';
import 'package:steady_routine/scene/modal/routine_detail_daialog.dart';
import 'package:steady_routine/scene/routine/add_routine_screen.dart';
import 'package:steady_routine/util/size_config.dart';

class RoutineDetailScreen extends HookConsumerWidget {
  final RoutineModel routine;

  const RoutineDetailScreen({super.key, required this.routine});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          AppLocalizations.of(context)!.routine_datail,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22.0,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(5.0),
              width: width,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xffECECEC)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  routine.routineName, // Routine name
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (routine.date != null) ...[
              Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
                  child: _buildDateRow(
                      context,
                      AppLocalizations.of(context)!.date,
                      routine.date?.toLocal())),
              const ColumnDivider(),
            ] else ...[
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppLocalizations.of(context)!.repeat,
                        style: const TextStyle(fontSize: 14)),
                    Text(_formatWeekDays(routine.weekDays),
                        style: const TextStyle(fontSize: 14)),
                  ],
                ),
              ),
              const ColumnDivider(),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
                  child: _buildDateRow(
                      context,
                      AppLocalizations.of(context)!.when_will_you_start,
                      routine.startDate?.toLocal())),
              const ColumnDivider(),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
                  child: _buildDateRow(
                      context,
                      AppLocalizations.of(context)!.until_when_will_you_try_it,
                      routine.endDate?.toLocal())),
              const ColumnDivider(),
            ],
            Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
                child: _buildTimeRow(
                    context,
                    AppLocalizations.of(context)!.specify_time,
                    routine.time?.toLocal())),
            const ColumnDivider(),
            Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
                child: _buildCategoryRow(routine.category)),
            const ColumnDivider(),
            Padding(
              padding: const EdgeInsets.only(
                  top: 0.0, bottom: 20.0, right: 10.0, left: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(AppLocalizations.of(context)!.memo,
                        style: const TextStyle(fontSize: 14)),
                  ),
                  ConstrainedBox(
                    constraints:
                        const BoxConstraints(maxWidth: 200, minHeight: 60),
                    child: Text(
                      routine.memo ?? '',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AddRotineScreen(routine: routine)),
                  ).then((value) {
                    if (value == true) {
                      if (context.mounted) {
                        Navigator.of(context).pop(true);
                      }
                    }
                  });
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
                child: Text(AppLocalizations.of(context)!.edit),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 12.0),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      opaque: false,
                      pageBuilder: (BuildContext context,
                          Animation<double> animation,
                          Animation<double> secondaryAnimation) {
                        return Scaffold(
                          backgroundColor: Colors.black.withOpacity(0.5),
                          body: Center(
                            child: RoutineDeleteDialog(routine: routine),
                          ),
                        );
                      },
                    ),
                  ).then((value) {
                    if (value == true) {
                      if (context.mounted) {
                        Navigator.of(context).pop(true);
                      }
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color(0xff585858),
                  backgroundColor: Colors.white,
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
                child: Text(AppLocalizations.of(context)!.delete),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateRow(BuildContext context, String label, DateTime? date) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 14)),
        Text(
            date != null
                ? DateFormat('yyyy / M / d').format(date)
                : AppLocalizations.of(context)!.unspecified,
            style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _buildTimeRow(BuildContext context, String label, DateTime? time) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 14)),
        Text(
            time != null
                ? DateFormat('HH:mm').format(time)
                : AppLocalizations.of(context)!.unspecified,
            style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _buildCategoryRow(String category) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('カテゴリ', style: TextStyle(fontSize: 14)),
        Column(
          children: [
            SizedBox(
              width: 50,
              child: Image.asset(
                category.toCategory().toImagePath(),
              ),
            ),
            const SizedBox(width: 8),
            Text(category, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ],
    );
  }

  String _formatWeekDays(List<int> weekDays) {
    const weekDayNames = ['月', '火', '水', '木', '金', '土', '日'];

    // 曜日名に変換して、空白で結合
    return weekDays.map((day) => weekDayNames[day - 1]).join(' ');
  }
}
