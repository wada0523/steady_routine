// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routine.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class RoutineModel extends _RoutineModel
    with RealmEntity, RealmObjectBase, RealmObject {
  RoutineModel(
    ObjectId id,
    String routineName,
    DateTime created,
    String category,
    int maxCount, {
    DateTime? startDate,
    DateTime? endDate,
    DateTime? date,
    DateTime? time,
    Iterable<int> weekDays = const [],
    String? memo,
    Iterable<String> completeDays = const [],
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'routineName', routineName);
    RealmObjectBase.set(this, 'startDate', startDate);
    RealmObjectBase.set(this, 'endDate', endDate);
    RealmObjectBase.set(this, 'date', date);
    RealmObjectBase.set(this, 'time', time);
    RealmObjectBase.set<RealmList<int>>(
        this, 'weekDays', RealmList<int>(weekDays));
    RealmObjectBase.set(this, 'created', created);
    RealmObjectBase.set(this, 'category', category);
    RealmObjectBase.set(this, 'memo', memo);
    RealmObjectBase.set<RealmList<String>>(
        this, 'completeDays', RealmList<String>(completeDays));
    RealmObjectBase.set(this, 'maxCount', maxCount);
  }

  RoutineModel._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get routineName =>
      RealmObjectBase.get<String>(this, 'routineName') as String;
  @override
  set routineName(String value) =>
      RealmObjectBase.set(this, 'routineName', value);

  @override
  DateTime? get startDate =>
      RealmObjectBase.get<DateTime>(this, 'startDate') as DateTime?;
  @override
  set startDate(DateTime? value) =>
      RealmObjectBase.set(this, 'startDate', value);

  @override
  DateTime? get endDate =>
      RealmObjectBase.get<DateTime>(this, 'endDate') as DateTime?;
  @override
  set endDate(DateTime? value) => RealmObjectBase.set(this, 'endDate', value);

  @override
  DateTime? get date =>
      RealmObjectBase.get<DateTime>(this, 'date') as DateTime?;
  @override
  set date(DateTime? value) => RealmObjectBase.set(this, 'date', value);

  @override
  DateTime? get time =>
      RealmObjectBase.get<DateTime>(this, 'time') as DateTime?;
  @override
  set time(DateTime? value) => RealmObjectBase.set(this, 'time', value);

  @override
  RealmList<int> get weekDays =>
      RealmObjectBase.get<int>(this, 'weekDays') as RealmList<int>;
  @override
  set weekDays(covariant RealmList<int> value) =>
      throw RealmUnsupportedSetError();

  @override
  DateTime get created =>
      RealmObjectBase.get<DateTime>(this, 'created') as DateTime;
  @override
  set created(DateTime value) => RealmObjectBase.set(this, 'created', value);

  @override
  String get category =>
      RealmObjectBase.get<String>(this, 'category') as String;
  @override
  set category(String value) => RealmObjectBase.set(this, 'category', value);

  @override
  String? get memo => RealmObjectBase.get<String>(this, 'memo') as String?;
  @override
  set memo(String? value) => RealmObjectBase.set(this, 'memo', value);

  @override
  RealmList<String> get completeDays =>
      RealmObjectBase.get<String>(this, 'completeDays') as RealmList<String>;
  @override
  set completeDays(covariant RealmList<String> value) =>
      throw RealmUnsupportedSetError();

  @override
  int get maxCount => RealmObjectBase.get<int>(this, 'maxCount') as int;
  @override
  set maxCount(int value) => RealmObjectBase.set(this, 'maxCount', value);

  @override
  Stream<RealmObjectChanges<RoutineModel>> get changes =>
      RealmObjectBase.getChanges<RoutineModel>(this);

  @override
  Stream<RealmObjectChanges<RoutineModel>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<RoutineModel>(this, keyPaths);

  @override
  RoutineModel freeze() => RealmObjectBase.freezeObject<RoutineModel>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'routineName': routineName.toEJson(),
      'startDate': startDate.toEJson(),
      'endDate': endDate.toEJson(),
      'date': date.toEJson(),
      'time': time.toEJson(),
      'weekDays': weekDays.toEJson(),
      'created': created.toEJson(),
      'category': category.toEJson(),
      'memo': memo.toEJson(),
      'completeDays': completeDays.toEJson(),
      'maxCount': maxCount.toEJson(),
    };
  }

  static EJsonValue _toEJson(RoutineModel value) => value.toEJson();
  static RoutineModel _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'routineName': EJsonValue routineName,
        'created': EJsonValue created,
        'category': EJsonValue category,
        'maxCount': EJsonValue maxCount,
      } =>
        RoutineModel(
          fromEJson(id),
          fromEJson(routineName),
          fromEJson(created),
          fromEJson(category),
          fromEJson(maxCount),
          startDate: fromEJson(ejson['startDate']),
          endDate: fromEJson(ejson['endDate']),
          date: fromEJson(ejson['date']),
          time: fromEJson(ejson['time']),
          weekDays: fromEJson(ejson['weekDays']),
          memo: fromEJson(ejson['memo']),
          completeDays: fromEJson(ejson['completeDays']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(RoutineModel._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, RoutineModel, 'RoutineModel', [
      SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
      SchemaProperty('routineName', RealmPropertyType.string),
      SchemaProperty('startDate', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('endDate', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('date', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('time', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('weekDays', RealmPropertyType.int,
          collectionType: RealmCollectionType.list),
      SchemaProperty('created', RealmPropertyType.timestamp),
      SchemaProperty('category', RealmPropertyType.string),
      SchemaProperty('memo', RealmPropertyType.string, optional: true),
      SchemaProperty('completeDays', RealmPropertyType.string,
          collectionType: RealmCollectionType.list),
      SchemaProperty('maxCount', RealmPropertyType.int),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
