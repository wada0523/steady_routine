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
    DateTime end = DateTime(date.year, date.month, date.day, 23, 59);

    return await Future.delayed(
      const Duration(milliseconds: 100),
      () => realm.all<RoutineModel>().query(
          r'date >= $0 && date <= $1 OR (startDate <= $0 AND endDate >= $0 AND ANY weekDays == $2)',
          [start, end, date.weekday]).toList(),
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
      var target = realm
          .all<RoutineModel>()
          .query(r'id == $0', [routine.id])
          .toList()
          .first;

      // Update the fields of the existing routine
      target.routineName = routine.routineName; // Update name
      target.category = routine.category; // Update category
      target.maxCount = routine.maxCount; // Update max count
      target.startDate = routine.startDate; // Update start date
      target.endDate = routine.endDate; // Update end date
      target.date = routine.date; // Update date
      target.time = routine.time; // Update time
      target.weekDays = routine.weekDays; // Update weekdays
      target.memo = routine.memo; // Update memo
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
