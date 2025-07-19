import 'package:realm/realm.dart';

part 'my_user.realm.dart';

@RealmModel()
class _MyUser {
  @PrimaryKey()
  late ObjectId id;

  late String name;
  String? email;
}