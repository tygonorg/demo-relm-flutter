import 'package:flutter/material.dart';
import 'package:realm/realm.dart';
import 'product.dart';

class ProductManagerScreen extends StatefulWidget {
  final Realm realm;
  const ProductManagerScreen({Key? key, required this.realm}) : super(key: key);

  @override
  State<ProductManagerScreen> createState() => _ProductManagerScreenState();
}

class _ProductManagerScreenState extends State<ProductManagerScreen> {
  late final RealmResults<Product> _products;

  @override
  void initState() {
    super.initState();
    _products = widget.realm.all<Product>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý sản phẩm')),
      body: StreamBuilder<RealmResultsChanges<Product>>(
        stream: _products.changes,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final results = snapshot.data!.results;
          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final product = results[index];
              return ListTile(
                title: Text(product.name),
                subtitle: Text('Giá: ${product.price}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showEditProductDialog(context, product),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        widget.realm.write(() {
                          widget.realm.delete(product);
                        });
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
        onPressed: () => _showAddProductDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddProductDialog(BuildContext context) {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final descController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Thêm sản phẩm'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Tên sản phẩm'),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Giá'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: descController,
                decoration: const InputDecoration(labelText: 'Mô tả'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Huỷ'),
            ),
            TextButton(
              onPressed: () {
                final name = nameController.text;
                final price = double.tryParse(priceController.text) ?? 0;
                final desc = descController.text;
                if (name.isNotEmpty) {
                  widget.realm.write(() {
                    widget.realm.add(Product(ObjectId(), name, price,
                        description: desc.isNotEmpty ? desc : null));
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

  void _showEditProductDialog(BuildContext context, Product product) {
    final nameController = TextEditingController(text: product.name);
    final priceController =
        TextEditingController(text: product.price.toString());
    final descController =
        TextEditingController(text: product.description ?? '');
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sửa sản phẩm'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Tên sản phẩm'),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Giá'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: descController,
                decoration: const InputDecoration(labelText: 'Mô tả'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Huỷ'),
            ),
            TextButton(
              onPressed: () {
                final name = nameController.text;
                final price = double.tryParse(priceController.text) ?? 0;
                final desc = descController.text;
                if (name.isNotEmpty) {
                  widget.realm.write(() {
                    product.name = name;
                    product.price = price;
                    product.description = desc.isNotEmpty ? desc : null;
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
