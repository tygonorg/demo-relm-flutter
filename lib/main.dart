import 'package:flutter/material.dart';
import 'package:realm/realm.dart';

import 'my_user.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final config = Configuration.local([MyUser.schema]);
  final realm = Realm(config);

  runApp(MyApp(realm: realm));
}

class MyApp extends StatelessWidget {
  final Realm realm;

  const MyApp({Key? key, required this.realm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Realm User List',
      home: UserListScreen(realm: realm),
    );
  }
}

class UserListScreen extends StatefulWidget {
  final Realm realm;

  const UserListScreen({Key? key, required this.realm}) : super(key: key);

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  late final RealmResults<MyUser> _users;

  @override
  void initState() {
    super.initState();
    _users = widget.realm.all<MyUser>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
      ),
      body: StreamBuilder<RealmResultsChanges<MyUser>>(
        stream: _users.changes,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final results = snapshot.data!.results;

          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final user = results[index];
              return ListTile(
                title: Text(user.name),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    widget.realm.write(() {
                      widget.realm.delete(user);
                    });
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddUserDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddUserDialog(BuildContext context) {
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add User'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final name = nameController.text;
                if (name.isNotEmpty) {
                  widget.realm.write(() {
                    widget.realm.add(MyUser(ObjectId(), name));
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}