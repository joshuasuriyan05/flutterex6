import 'package:flutter_test/flutter_test.dart';
import 'package:product_inventory/main.dart'; // 👈 Use your project name here

void main() {
  testWidgets('App loads and displays Product Inventory Tracker title',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Product Inventory Tracker'), findsOneWidget);
    expect(find.text('Save Product'), findsOneWidget);
  });
}
