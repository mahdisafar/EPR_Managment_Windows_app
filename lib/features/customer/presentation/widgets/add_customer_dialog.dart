import 'package:flutter/material.dart';
import '../../data/models/customer_model.dart';

class AddCustomerDialog extends StatefulWidget {
  final Function(CustomerModel) onSubmit;

  const AddCustomerDialog({super.key, required this.onSubmit});

  @override
  State<AddCustomerDialog> createState() => _AddCustomerDialogState();
}

class _AddCustomerDialogState extends State<AddCustomerDialog> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _initialBalanceController = TextEditingController(text: '0.0');

  @override
  void dispose() {
    _codeController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _initialBalanceController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final initialBalance =
          double.tryParse(_initialBalanceController.text) ?? 0.0;
      final newCustomer = CustomerModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        code: _codeController.text.trim(),
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        address: _addressController.text.trim(),
        initialBalance: initialBalance,
        currentBalance: initialBalance,
      );

      widget.onSubmit(newCustomer);
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
            Icon(Icons.person_add_alt_1, color: Color(0xFF1E3A8A)),
            SizedBox(width: 8),
            Text(
              'ثبت مشتری جدید',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'IranYekan'),
            ),
          ],
        ),
        content: SizedBox(
          width: 480,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _codeController,
                          decoration:
                              const InputDecoration(labelText: 'کد مشتری *'),
                          validator: (v) =>
                              v == null || v.isEmpty ? 'کد الزامی است' : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _initialBalanceController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'بیلانس ابتدایی (toman)',
                            hintText: 'بدهکاری (+) / پیش‌پرداخت (-)',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _firstNameController,
                          decoration: const InputDecoration(labelText: 'نام *'),
                          validator: (v) =>
                              v == null || v.isEmpty ? 'نام الزامی است' : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _lastNameController,
                          decoration: const InputDecoration(
                              labelText: 'نام خانوادگی *'),
                          validator: (v) => v == null || v.isEmpty
                              ? 'نام خانوادگی الزامی است'
                              : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(labelText: 'شماره تماس'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _addressController,
                    maxLines: 2,
                    decoration:
                        const InputDecoration(labelText: 'آدرس / محل سکونت'),
                  ),
                ],
              ),
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
            child: const Text('ثبت مشتری',
                style: TextStyle(fontFamily: 'IranYekan')),
          ),
        ],
      ),
    );
  }
}
