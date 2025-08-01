import 'package:realm/realm.dart';

part 'product.realm.dart';

@RealmModel()
class _Product {
  @PrimaryKey()
  late ObjectId id;
  late String name;
  late double price;
  String? description;
}
