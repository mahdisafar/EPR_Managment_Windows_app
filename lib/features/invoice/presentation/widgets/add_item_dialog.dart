import 'package:flutter/material.dart';
import 'package:eprwindowsapp/features/inventory/data/models/product_model.dart';

import '../../../inventory/presentation/widgets/unit_selector_dropdown.dart';

class AddItemDialog extends StatefulWidget {
  final List<ProductModel> products;

  const AddItemDialog({super.key, required this.products});

  @override
  State<AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  ProductModel? selectedProduct;
  final quantityController = TextEditingController();
  final priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('افزودن کالا به فاکتور'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<ProductModel>(
              initialValue: selectedProduct,
              items: widget.products
                  .map((p) => DropdownMenuItem(
                        value: p,
                        child: Text(
                            '${p.name} (${UnitSelectorDropdown.labelOf(p.unit)})'),
                      ))
                  .toList(),
              onChanged: (val) => setState(() => selectedProduct = val),
              decoration: const InputDecoration(
                labelText: 'انتخاب محصول',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'تعداد / مقدار',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'قیمت خرید واحد',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('انصراف'),
        ),
        ElevatedButton(
          onPressed: () {
            final qty = double.tryParse(quantityController.text) ?? 0.0;
            final price = double.tryParse(priceController.text) ?? 0.0;

            if (selectedProduct != null && qty > 0 && price > 0) {
              Navigator.pop(context, {
                'product': selectedProduct,
                'quantity': qty,
                'unitPrice': price,
              });
            }
          },
          child: const Text('افزودن'),
        ),
      ],
    );
  }
}
