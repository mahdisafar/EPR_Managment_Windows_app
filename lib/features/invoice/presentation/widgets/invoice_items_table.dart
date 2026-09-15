import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:eprwindowsapp/features/inventory/data/models/product_model.dart';
import 'package:eprwindowsapp/features/invoice/data/models/invoice_item_model.dart';

class InvoiceItemsTable extends StatelessWidget {
  final List<InvoiceItemModel> items;
  final List<ProductModel> availableProducts;
  final Function(int index) onRemoveItem;

  const InvoiceItemsTable({
    super.key,
    required this.items,
    this.availableProducts = const [],
    required this.onRemoveItem,
  });

  String _productName(String productId) {
    final product = availableProducts.where((p) => p.id == productId);
    return product.isEmpty ? productId : product.first.name;
  }

  @override
  Widget build(BuildContext context) {
    final formatter = intl.NumberFormat('#,##0.##', 'fa_IR');

    if (items.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text(
            'هیچ کالایی به فاکتور اضافه نشده است.',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ),
      );
    }

    return DataTable(
      headingRowColor: WidgetStateProperty.all(Colors.grey.shade50),
      columns: const [
        DataColumn(label: Text('نام کالا')),
        DataColumn(label: Text('تعداد')),
        DataColumn(label: Text('قیمت واحد خرید')),
        DataColumn(label: Text('مجموع فاکتور')),
        DataColumn(label: Text('فی تمام‌شده با هزینه‌ها')),
        DataColumn(label: Text('عملیات')),
      ],
      rows: List.generate(items.length, (index) {
        final item = items[index];
        return DataRow(
          cells: [
            DataCell(Text(
              _productName(item.productId),
              style: const TextStyle(fontWeight: FontWeight.w600),
            )),
            DataCell(Text(formatter.format(item.quantity),
                style: const TextStyle(fontFamily: 'IranYekan'))),
            DataCell(Text(formatter.format(item.unitPrice),
                style: const TextStyle(fontFamily: 'IranYekan'))),
            DataCell(Text(formatter.format(item.totalPrice),
                style: const TextStyle(fontFamily: 'IranYekan'))),
            DataCell(
              Text(
                formatter.format(item.unitLandedCost),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                  fontFamily: 'IranYekan',
                ),
              ),
            ),
            DataCell(
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () => onRemoveItem(index),
              ),
            ),
          ],
        );
      }),
    );
  }
}
