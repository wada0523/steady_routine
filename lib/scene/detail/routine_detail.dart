import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:steady_routine/components/column_divider.dart';
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
          AppLocalizations.of(context)!.settings_title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22.0,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                routine.routineName, // Routine name
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context)!.repeat,
                    style: const TextStyle(fontSize: 13)),
                Text(_formatWeekDays(routine.weekDays),
                    style: const TextStyle(fontSize: 13)),
              ],
            ),
            const ColumnDivider(),
            _buildDateRow(AppLocalizations.of(context)!.when_will_you_start,
                routine.startDate),
            const ColumnDivider(),
            _buildDateRow(
                AppLocalizations.of(context)!.until_when_will_you_try_it,
                routine.endDate),
            const ColumnDivider(),
            _buildTimeRow(
                AppLocalizations.of(context)!.specify_time, routine.time),
            const ColumnDivider(),
            _buildCategoryRow(routine.category),
            const ColumnDivider(),
            Text(AppLocalizations.of(context)!.memo,
                style: const TextStyle(fontSize: 13)),
            Padding(
              padding: const EdgeInsets.only(top: 12.0, bottom: 24.0),
              child: Text(
                routine.memo ?? '',
                style: const TextStyle(fontSize: 16),
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
                    if (value) {}
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
                        return RoutineDeleteDialog(routine: routine);
                      },
                    ),
                  );
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

  Widget _buildDateRow(String label, DateTime? date) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13)),
        Text(date != null ? DateFormat('yyyy / M / d').format(date) : '未指定',
            style: const TextStyle(fontSize: 13)),
      ],
    );
  }

  Widget _buildTimeRow(String label, DateTime? time) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13)),
        Text(time != null ? DateFormat('HH:mm').format(time) : '未指定',
            style: const TextStyle(fontSize: 13)),
      ],
    );
  }

  Widget _buildCategoryRow(String category) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('カテゴリ', style: TextStyle(fontSize: 13)),
        Row(
          children: [
            const Icon(Icons.circle, color: Colors.teal, size: 24),
            const SizedBox(width: 8),
            Text(category, style: const TextStyle(fontSize: 13)),
          ],
        ),
      ],
    );
  }

  String _formatWeekDays(List<int> weekDays) {
    const weekDayNames = ['日', '月', '火', '水', '木', '金', '土'];
    return weekDays.map((day) => weekDayNames[day - 1]).join(' ');
  }
}
