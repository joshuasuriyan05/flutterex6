import 'package:flutter/material.dart';
import 'databasehelper.dart';
import 'product.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();
  List<Product> _products = [];

  @override
  void initState() {
    super.initState();
    _refreshProducts();
  }

  Future<void> _refreshProducts() async {
    final data = await DatabaseHelper.instance.readAllProducts();
    setState(() => _products = data);
  }

  double get totalStockValue {
    return _products.fold(0, (sum, item) => sum + (item.quantity * item.price));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Product Inventory Tracker",
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 243, 242, 225),
        appBar: AppBar(
          title: const Text("Product Inventory Tracker"),
          backgroundColor: const Color.fromARGB(255, 255, 175, 2),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                await DatabaseHelper.instance.deleteAllProducts();
                _refreshProducts();
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "Enter product name",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? "Enter name" : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Enter quantity",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? "Enter quantity" : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Enter price",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? "Enter price" : null,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 132, 31),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final name = _nameController.text;
                      final quantity = int.parse(_quantityController.text);
                      final price = double.parse(_priceController.text);

                      await DatabaseHelper.instance.insertProduct(
                        Product(name: name, quantity: quantity, price: price),
                      );

                      _nameController.clear();
                      _quantityController.clear();
                      _priceController.clear();

                      _refreshProducts();

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Product added successfully")),
                      );
                    }
                  },
                  child: const Text("Add Product"),
                ),
                const SizedBox(height: 15),
                Expanded(
                  child: _products.isEmpty
                      ? const Center(child: Text("No products found"))
                      : ListView.builder(
                          itemCount: _products.length,
                          itemBuilder: (context, index) {
                            final product = _products[index];
                            return Card(
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: product.quantity < 5
                                      ? Colors.red
                                      : Colors.blue,
                                  child: Text(product.name[0].toUpperCase()),
                                ),
                                title: Text(product.name),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "Quantity: ${product.quantity}, Price: ${product.price.toStringAsFixed(2)}"),
                                    if (product.quantity < 5)
                                      const Text(
                                        "Low Stock!",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Total Stock Value: ₹${totalStockValue.toStringAsFixed(2)}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
