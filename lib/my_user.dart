import 'package:realm/realm.dart';

part 'my_user.g.dart';

@RealmModel()
class _MyUser {
  @PrimaryKey()
  late ObjectId id;

  late String name;
}