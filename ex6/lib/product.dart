class Product {
  final int? id;
  final String name;
  final int quantity;
  final double price;

  Product({this.id, required this.name, required this.quantity, required this.price});

  factory Product.fromRow(Map<String, dynamic> row) {
    return Product(
      id: row['id'],
      name: row['name'],
      quantity: row['quantity'],
      price: row['price'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'price': price,
    };
  }
}
