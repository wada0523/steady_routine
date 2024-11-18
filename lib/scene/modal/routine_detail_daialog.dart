import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:steady_routine/model/routine.dart';
import 'package:steady_routine/service/realm_service.dart';

class RoutineDeleteDialog extends StatelessWidget {
  final RoutineModel routine;

  const RoutineDeleteDialog({super.key, required this.routine});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // 角丸を設定
      ),
      title: Column(
        children: [
          Image.asset(
            'assets/images/announce.png',
            width: 48,
            height: 48,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.delete_routine,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      content: Text(
        AppLocalizations.of(context)!.delete_routine_confirm,
        style: const TextStyle(fontSize: 16),
        textAlign: TextAlign.center,
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // キャンセルボタン
            SizedBox(
              width: 100,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xff5D5D5D)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
                child: Text(
                  AppLocalizations.of(context)!.cancel,
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                ),
              ),
            ),

            const SizedBox(width: 10),
            // 削除ボタン
            SizedBox(
              width: 100,
              child: ElevatedButton(
                onPressed: () async {
                  await _deleteRoutine(routine);
                  if (context.mounted) {
                    Navigator.of(context).pop(true);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffF88273), // 背景色を赤系に設定
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
                child: Text(
                  AppLocalizations.of(context)!.delete,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _deleteRoutine(RoutineModel routine) async {
    RealmService.realmInstance.deleteRoutine(routine.id);
  }
}
