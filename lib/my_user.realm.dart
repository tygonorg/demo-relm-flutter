// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_user.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
class MyUser extends _MyUser with RealmEntity, RealmObjectBase, RealmObject {
  MyUser(
    ObjectId id,
    String name,
  ) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
  }

  MyUser._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  Stream<RealmObjectChanges<MyUser>> get changes =>
      RealmObjectBase.getChanges<MyUser>(this);

  @override
  Stream<RealmObjectChanges<MyUser>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<MyUser>(this, keyPaths);

  @override
  MyUser freeze() => RealmObjectBase.freezeObject<MyUser>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'name': name.toEJson(),
    };
  }

  static EJsonValue _toEJson(MyUser value) => value.toEJson();
  static MyUser _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'name': EJsonValue name,
      } =>
        MyUser(
          fromEJson(id),
          fromEJson(name),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(MyUser._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(ObjectType.realmObject, MyUser, 'MyUser', [
      SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
