import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:eprwindowsapp/features/inventory/data/models/product_model.dart';
import 'package:eprwindowsapp/features/invoice/data/models/invoice_item_model.dart';

class SaleInvoiceItemsTable extends StatelessWidget {
  final List<InvoiceItemModel> items;
  final List<ProductModel> availableProducts;
  final Function(int index) onRemoveItem;

  const SaleInvoiceItemsTable({
    super.key,
    required this.items,
    required this.availableProducts,
    required this.onRemoveItem,
  });

  String _productName(String productId) {
    final product = availableProducts.where((p) => p.id == productId);
    return product.isEmpty ? productId : product.first.name;
  }

  double _productStock(String productId) {
    final product = availableProducts.where((p) => p.id == productId);
    return product.isEmpty ? 0.0 : product.first.currentStock;
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
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
              fontFamily: 'IranYekan',
            ),
          ),
        ),
      );
    }

    return DataTable(
      headingRowColor: WidgetStateProperty.all(Colors.grey.shade50),
      columns: const [
        DataColumn(
            label: Text('نام کالا',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontFamily: 'IranYekan'))),
        DataColumn(
            label: Text('موجودی انبار',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontFamily: 'IranYekan'))),
        DataColumn(
            label: Text('تعداد',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontFamily: 'IranYekan'))),
        DataColumn(
            label: Text('قیمت فروش واحد',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontFamily: 'IranYekan'))),
        DataColumn(
            label: Text('جمع',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontFamily: 'IranYekan'))),
        DataColumn(
            label: Text('عملیات',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontFamily: 'IranYekan'))),
      ],
      rows: List.generate(items.length, (index) {
        final item = items[index];
        return DataRow(
          cells: [
            DataCell(Text(_productName(item.productId),
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontFamily: 'IranYekan'))),
            DataCell(Text(formatter.format(_productStock(item.productId)),
                style: TextStyle(
                    color: Colors.grey.shade700, fontFamily: 'IranYekan'))),
            DataCell(Text(formatter.format(item.quantity),
                style: const TextStyle(fontFamily: 'IranYekan'))),
            DataCell(Text(formatter.format(item.unitPrice),
                style: const TextStyle(fontFamily: 'IranYekan'))),
            DataCell(Text(
              formatter.format(item.totalPrice),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'IranYekan',
              ),
            )),
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
