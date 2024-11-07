import 'package:realm/realm.dart';
import 'package:intl/intl.dart';
import 'package:steady_routine/model/routine.dart';

class RealmService {
  static RealmService realmInstance = RealmService();

  late Realm realm;
  final config = Configuration.local([RoutineModel.schema]);

  void initialize() {
    realm = Realm(config);
  }

  Future<List<RoutineModel>> getRoutines(DateTime date) async {
    DateTime start = DateTime(date.year, date.month, date.day, 0, 0);
    DateTime end = DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
    int weekday = date.weekday;

    return await Future.delayed(
      const Duration(milliseconds: 100),
      () => realm.all<RoutineModel>().query(
          r'(date >= $0 AND date <= $1) OR (startDate <= $0 AND endDate >= $0 AND ANY weekDays == $2)',
          [start, end, weekday]).toList(),
    );
  }

  Future<List<RoutineModel>> getAll() async {
    return await Future.delayed(
      const Duration(milliseconds: 100),
      () => realm.all<RoutineModel>().toList(),
    );
  }

  Future<int> getAllCount() async {
    return await Future.delayed(
      const Duration(milliseconds: 100),
      () => realm.all<RoutineModel>().length,
    );
  }

  void updateRoutine(RoutineModel routine) {
    realm.write(() {
      // リストが空でないかを確認
      var results =
          realm.all<RoutineModel>().query(r'id == $0', [routine.id]).toList();

      if (results.isNotEmpty) {
        var target = results.first;
        routine.weekDays.sort();
        target.routineName = routine.routineName;
        target.category = routine.category;
        target.maxCount = routine.maxCount;
        target.startDate = routine.startDate;
        target.endDate = routine.endDate;
        target.date = routine.date;
        target.time = routine.time;
        target.memo = routine.memo;

        target.weekDays.clear();
        target.weekDays.addAll(routine.weekDays);
      } else {
        // IDに該当するRoutineが見つからない場合の処理
        print("Routine with ID ${routine.id} not found.");
      }
    });
  }

  void updateCompleteFlg(ObjectId eventId, DateTime date, bool completeFlg) {
    realm.write(() {
      var target = realm
          .all<RoutineModel>()
          .query(r'id == $0', [eventId])
          .toList()
          .first;

      var formatter = DateFormat('yyyyMMdd');
      var completeDay = formatter.format(date);
      if (completeFlg) {
        target.completeDays.add(completeDay);
      } else {
        target.completeDays.remove(completeDay);
      }

      realm.add(target, update: true);
    });
  }

  void deleteRoutine(ObjectId eventId) async {
    final personToDelete =
        realm.query<RoutineModel>(r'id == $0', [eventId]).first;
    realm.write(() {
      realm.delete(personToDelete);
    });
  }
}
