import 'package:realm/realm.dart';

part 'routine.realm.dart';

@RealmModel()
class _RoutineModel {
  @PrimaryKey()
  late ObjectId id;
  late String routineName;
  late DateTime? startDate;
  late DateTime? endDate;
  late DateTime? date;
  late DateTime? time;
  late List<int> weekDays;
  late DateTime created;
  late String category;
  late String? memo;
  late List<String> completeDays;
  late int maxCount;
}
