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
      title: Text(AppLocalizations.of(context)!.delete_routine),
      surfaceTintColor: Colors.white,
      content: Text(AppLocalizations.of(context)!.delete_routine_confirm),
      actions: [
        TextButton(
          onPressed: () {
            // キャンセル時の処理
            Navigator.of(context).pop(false);
          },
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        TextButton(
          onPressed: () async {
            // 削除時の処理
            await _deleteRoutine(routine);
            if (context.mounted) {
              Navigator.of(context).pop(true);
            }
          },
          child: Text(AppLocalizations.of(context)!.delete),
        ),
      ],
    );
  }

  Future<void> _deleteRoutine(RoutineModel routine) async {
    RealmService.realmInstance.deleteRoutine(routine.id);
  }
}
