import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:steady_routine/model/routine.dart';
import 'package:steady_routine/scene/modal/routine_detail_daialog.dart';

class RoutineDetailScreen extends HookConsumerWidget {
  final RoutineModel routine;

  const RoutineDetailScreen({required this.routine});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                    style: const TextStyle(fontSize: 18)),
                Text(_formatWeekDays(routine.weekDays),
                    style: const TextStyle(fontSize: 18)),
              ],
            ),
            const Divider(),
            _buildDateRow(AppLocalizations.of(context)!.when_will_you_start,
                routine.startDate),
            const Divider(),
            _buildDateRow(
                AppLocalizations.of(context)!.until_when_will_you_try_it,
                routine.endDate),
            const Divider(),
            _buildTimeRow(
                AppLocalizations.of(context)!.specify_time, routine.time),
            const Divider(),
            _buildCategoryRow(routine.category),
            const Divider(),
            Text(AppLocalizations.of(context)!.memo,
                style: const TextStyle(fontSize: 18)),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                routine.memo ?? '',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle edit button press
                },
                child: Text(AppLocalizations.of(context)!.edit),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
              ),
            ),
            Center(
              child: TextButton(
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
                  ).then((value) {
                    if (value && context.mounted) {
                      Navigator.pop(context, true);
                    }
                  });
                },
                child: Text(AppLocalizations.of(context)!.delete),
                style: TextButton.styleFrom(
                    // primary: Colors.grey,
                    ),
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
        Text(label, style: const TextStyle(fontSize: 18)),
        Text(date != null ? DateFormat('yyyy / M / d').format(date) : '未指定',
            style: const TextStyle(fontSize: 18)),
      ],
    );
  }

  Widget _buildTimeRow(String label, DateTime? time) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 18)),
        Text(time != null ? DateFormat('HH:mm').format(time) : '未指定',
            style: const TextStyle(fontSize: 18)),
      ],
    );
  }

  Widget _buildCategoryRow(String category) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('カテゴリ', style: TextStyle(fontSize: 18)),
        Row(
          children: [
            const Icon(Icons.circle, color: Colors.teal, size: 24),
            const SizedBox(width: 8),
            Text(category, style: const TextStyle(fontSize: 18)),
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
