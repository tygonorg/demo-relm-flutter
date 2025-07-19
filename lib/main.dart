import 'package:flutter/material.dart';
import 'package:realm/realm.dart';
import 'splash_screen.dart'; // Import the splash screen
import 'my_user.dart';
import 'product.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final config = Configuration.local([MyUser.schema, Product.schema]);
  final realm = Realm(config);

  runApp(MyApp(realm: realm));
}

class MyApp extends StatelessWidget {
  final Realm realm;

  const MyApp({Key? key, required this.realm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Realm Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(realm: realm), // Truyền Realm vào SplashScreen
    );
  }
}
