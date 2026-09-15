import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:eprwindowsapp/config/enum.dart';
import 'package:eprwindowsapp/features/inventory/data/models/product_model.dart';
import 'unit_selector_dropdown.dart';

class AddProductDialog extends StatefulWidget {
  final Function(ProductModel) onSubmit;

  const AddProductDialog({super.key, required this.onSubmit});

  @override
  State<AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<AddProductDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController(text: '0');
  UnitType _selectedUnit = UnitType.kg;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final purchasePrice = double.tryParse(_priceController.text) ?? 0.0;

      final newProduct = ProductModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        unit: _selectedUnit,
        currentStock: 0.0,
        purchasePrice: purchasePrice,
        landedCost: purchasePrice,
      );

      widget.onSubmit(newProduct);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.inventory_2_outlined, color: Color(0xFF1E3A8A)),
            SizedBox(width: 8),
            Text(
              'ثبت کالای جدید',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'IranYekan'),
            ),
          ],
        ),
        content: SizedBox(
          width: 420,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'نام کالا *',
                    labelStyle: TextStyle(fontFamily: 'IranYekan'),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'نام کالا الزامی است'
                      : null,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: UnitSelectorDropdown(
                        selectedUnit: _selectedUnit,
                        onChanged: (unit) {
                          if (unit != null) {
                            setState(() => _selectedUnit = unit);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d*')),
                        ],
                        decoration: const InputDecoration(
                          labelText: 'قیمت خرید (toman)',
                          labelStyle: TextStyle(fontFamily: 'IranYekan'),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('انصراف',
                style: TextStyle(color: Colors.grey, fontFamily: 'IranYekan')),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E3A8A),
              foregroundColor: Colors.white,
            ),
            onPressed: _submit,
            child: const Text('ثبت کالا',
                style: TextStyle(fontFamily: 'IranYekan')),
          ),
        ],
      ),
    );
  }
}
