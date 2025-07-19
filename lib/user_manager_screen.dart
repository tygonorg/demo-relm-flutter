
import 'package:flutter/material.dart';
import 'package:realm/realm.dart';
import 'my_user.dart';

class UserManagerScreen extends StatefulWidget {
  final Realm realm;
  const UserManagerScreen({Key? key, required this.realm}) : super(key: key);

  @override
  State<UserManagerScreen> createState() => _UserManagerScreenState();
}

class _UserManagerScreenState extends State<UserManagerScreen> {
  late final RealmResults<MyUser> _users;

  @override
  void initState() {
    super.initState();
    _users = widget.realm.all<MyUser>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý người dùng')),
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
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showEditUserDialog(context, user),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Xác nhận xoá'),
                            content: const Text('Bạn có chắc muốn xoá người dùng này?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: const Text('Huỷ'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(true),
                                child: const Text('Xoá'),
                              ),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          widget.realm.write(() {
                            widget.realm.delete(user);
                          });
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddUserDialog(context),
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
          title: const Text('Thêm người dùng'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Tên người dùng'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Huỷ'),
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
              child: const Text('Thêm'),
            ),
          ],
        );
      },
    );
  }

  void _showEditUserDialog(BuildContext context, MyUser user) {
    final nameController = TextEditingController(text: user.name);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sửa người dùng'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Tên người dùng'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Huỷ'),
            ),
            TextButton(
              onPressed: () {
                final name = nameController.text;
                if (name.isNotEmpty) {
                  widget.realm.write(() {
                    user.name = name;
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Lưu'),
            ),
          ],
        );
      },
    );
  }
}
