import 'package:flutter/material.dart';
import 'product_manager_screen.dart';
import 'user_manager_screen.dart'; // Import the new screen
import 'package:realm/realm.dart';

class HomeScreen extends StatelessWidget {
  final Realm? realm;
  const HomeScreen({Key? key, this.realm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductManagerScreen(realm: realm!),
                  ),
                );
              },
              child: const Text('Quản lý sản phẩm'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserManagerScreen(realm: realm!),
                  ),
                );
              },
              child: const Text('Quản lý người dùng'),
            ),
          ],
        ),
      ),
    );
  }
}
