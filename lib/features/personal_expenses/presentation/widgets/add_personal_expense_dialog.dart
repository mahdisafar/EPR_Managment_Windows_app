import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:eprwindowsapp/core/di/injection.dart';
import 'package:eprwindowsapp/core/models/account_model.dart';
import 'package:eprwindowsapp/core/utils/currency_converter.dart';
import 'package:eprwindowsapp/core/utils/exchange_rate_service.dart';
import '../../../../config/enum.dart';
import '../../data/models/personal_expense_model.dart';

class AddPersonalExpenseDialog extends StatefulWidget {
  final List<AccountModel> accounts;
  final Function(PersonalExpenseModel) onSubmit;

  const AddPersonalExpenseDialog({
    super.key,
    required this.accounts,
    required this.onSubmit,
  });

  @override
  State<AddPersonalExpenseDialog> createState() =>
      _AddPersonalExpenseDialogState();
}

class _AddPersonalExpenseDialogState extends State<AddPersonalExpenseDialog> {
  static const categories = [
    'خوراک',
    'لباس',
    'حمل و نقل',
    'بهداشت',
    'آموزش',
    'خانه',
    'سایر',
  ];

  final _formKey = GlobalKey<FormState>();
  String _category = categories.first;
  CurrencyType _currency = CurrencyType.toman;
  AccountModel? _selectedAccount;

  final _receiptCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _qtyCtrl = TextEditingController(text: '1');
  final _priceCtrl = TextEditingController();
  final _rateCtrl = TextEditingController(text: '1');
  final _notesCtrl = TextEditingController();
  final _dateCtrl = TextEditingController(
    text: DateTime.now().toIso8601String().split('T').first,
  );

  @override
  void dispose() {
    _nameCtrl.dispose();
    _qtyCtrl.dispose();
    _priceCtrl.dispose();
    _rateCtrl.dispose();
    _notesCtrl.dispose();
    _dateCtrl.dispose();
    _receiptCtrl.dispose();
    super.dispose();
  }

  Future<void> _onCurrencyChanged(CurrencyType c) async {
    setState(() => _currency = c);
    if (c != CurrencyType.toman) {
      final rate = await sl<ExchangeRateService>().getRate(c);
      _rateCtrl.text = rate.toString();
    } else {
      _rateCtrl.text = '1';
    }
  }

  double get _tomanPreview {
    final qty = double.tryParse(_qtyCtrl.text) ?? 1.0;
    final price = double.tryParse(_priceCtrl.text) ?? 0.0;
    final rate = double.tryParse(_rateCtrl.text) ?? 1.0;
    return CurrencyConverter.totoman(
        amount: qty * price, currency: _currency, exchangeRate: rate);
  }

  void _submit() {
    if (_formKey.currentState!.validate() && _selectedAccount != null) {
      final qty = double.tryParse(_qtyCtrl.text) ?? 1.0;
      final price = double.tryParse(_priceCtrl.text) ?? 0.0;
      final rate = double.tryParse(_rateCtrl.text) ?? 1.0;
      final total = qty * price;

      widget.onSubmit(PersonalExpenseModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        itemName: _nameCtrl.text.trim(),
        category: _category,
        quantity: qty,
        unitPrice: price,
        totalAmount: total,
        currency: _currency,
        originalAmount: _currency == CurrencyType.toman ? null : total,
        exchangeRate: _currency == CurrencyType.toman ? null : rate,
        date: DateTime.tryParse(_dateCtrl.text) ?? DateTime.now(),
        notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
        receiptNumber:
            _receiptCtrl.text.trim().isEmpty ? null : _receiptCtrl.text.trim(),
        accountId: _selectedAccount!.id,
        accountName: _selectedAccount!.accountName,
      ));
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final numeric = [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(children: [
          Icon(Icons.person_outline, color: Color(0xFF1E3A8A)),
          SizedBox(width: 8),
          Text('ثبت مصرف شخصی',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'IranYekan')),
        ]),
        content: SizedBox(
          width: 460,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                TextFormField(
                  controller: _nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'نام مورد *',
                    labelStyle: TextStyle(fontFamily: 'IranYekan'),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'نام مورد الزامی است'
                      : null,
                ),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _category,
                      decoration: const InputDecoration(
                        labelText: 'دسته',
                        labelStyle: TextStyle(fontFamily: 'IranYekan'),
                        border: OutlineInputBorder(),
                      ),
                      items: categories
                          .map((c) => DropdownMenuItem(
                              value: c,
                              child: Text(c,
                                  style: const TextStyle(
                                      fontFamily: 'IranYekan'))))
                          .toList(),
                      onChanged: (v) =>
                          setState(() => _category = v ?? _category),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<CurrencyType>(
                      initialValue: _currency,
                      decoration: const InputDecoration(
                        labelText: 'واحد پول',
                        labelStyle: TextStyle(fontFamily: 'IranYekan'),
                        border: OutlineInputBorder(),
                      ),
                      items: CurrencyType.values
                          .map((c) => DropdownMenuItem(
                              value: c,
                              child: Text(CurrencyConverter.label(c),
                                  style: const TextStyle(
                                      fontFamily: 'IranYekan'))))
                          .toList(),
                      onChanged: (v) {
                        if (v != null) _onCurrencyChanged(v);
                      },
                    ),
                  ),
                ]),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _receiptCtrl,
                  decoration: const InputDecoration(
                    labelText: 'شماره رسید / سند',
                    labelStyle: TextStyle(fontFamily: 'IranYekan'),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(
                    child: TextFormField(
                      controller: _qtyCtrl,
                      keyboardType: TextInputType.number,
                      inputFormatters: numeric,
                      onChanged: (_) => setState(() {}),
                      decoration: const InputDecoration(
                        labelText: 'تعداد / مقدار',
                        labelStyle: TextStyle(fontFamily: 'IranYekan'),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _priceCtrl,
                      keyboardType: TextInputType.number,
                      inputFormatters: numeric,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        labelText:
                            'فی واحد (${CurrencyConverter.shortLabel(_currency)}) *',
                        labelStyle: const TextStyle(fontFamily: 'IranYekan'),
                        border: const OutlineInputBorder(),
                      ),
                      validator: (v) => (double.tryParse(v ?? '0') ?? 0) <= 0
                          ? 'فی باید بزرگ‌تر از صفر باشد'
                          : null,
                    ),
                  ),
                ]),
                if (_currency != CurrencyType.toman) ...[
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _rateCtrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: numeric,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      labelText: 'نرخ تبدیل (تومان)',
                      labelStyle: TextStyle(fontFamily: 'IranYekan'),
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => (double.tryParse(v ?? '0') ?? 0) <= 0
                        ? 'نرخ باید بزرگ‌تر از صفر باشد'
                        : null,
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'معادل تومانی: ${_tomanPreview.toStringAsFixed(0)} تومان',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                        fontFamily: 'IranYekan',
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                TextFormField(
                  controller: _dateCtrl,
                  decoration: const InputDecoration(
                    labelText: 'تاریخ',
                    labelStyle: TextStyle(fontFamily: 'IranYekan'),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<AccountModel>(
                  initialValue: _selectedAccount,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'پرداخت از حساب *',
                    labelStyle: TextStyle(fontFamily: 'IranYekan'),
                    border: OutlineInputBorder(),
                  ),
                  items: widget.accounts
                      .map((a) => DropdownMenuItem(
                            value: a,
                            child: Text(a.accountName,
                                overflow: TextOverflow.ellipsis,
                                style:
                                    const TextStyle(fontFamily: 'IranYekan')),
                          ))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedAccount = v),
                  validator: (_) => _selectedAccount == null
                      ? 'انتخاب حساب الزامی است'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _notesCtrl,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'تفصیلات / یادداشت',
                    labelStyle: TextStyle(fontFamily: 'IranYekan'),
                    border: OutlineInputBorder(),
                  ),
                ),
              ]),
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
            child: const Text('ثبت مصرف',
                style: TextStyle(fontFamily: 'IranYekan')),
          ),
        ],
      ),
    );
  }
}
