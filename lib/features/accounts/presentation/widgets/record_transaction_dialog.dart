import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:eprwindowsapp/core/di/injection.dart';
import 'package:eprwindowsapp/core/models/account_model.dart';
import 'package:eprwindowsapp/core/utils/currency_converter.dart';
import 'package:eprwindowsapp/core/utils/exchange_rate_service.dart';
import 'package:eprwindowsapp/features/customer/data/models/customer_model.dart';

import '../../../../config/enum.dart';

class RecordTransactionDialog extends StatefulWidget {
  final bool isReceipt;
  final List<AccountModel> accounts;
  final List<CustomerModel> customers;
  final void Function({
    required String accountId,
    required double amount,
    required String title,
    String? details,
    required String documentNumber,
    String? customerId,
    required CurrencyType currency,
    required double exchangeRate,
  }) onSubmit;

  const RecordTransactionDialog({
    super.key,
    required this.isReceipt,
    required this.accounts,
    required this.customers,
    required this.onSubmit,
  });

  @override
  State<RecordTransactionDialog> createState() =>
      _RecordTransactionDialogState();
}

class _RecordTransactionDialogState extends State<RecordTransactionDialog> {
  final _formKey = GlobalKey<FormState>();
  AccountModel? _selectedAccount;
  CustomerModel? _selectedCustomer;
  CurrencyType _currency = CurrencyType.toman;

  final _amountCtrl = TextEditingController();
  final _rateCtrl = TextEditingController(text: '1');
  final _titleCtrl = TextEditingController();
  final _docCtrl = TextEditingController();
  final _detailsCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleCtrl.text = widget.isReceipt ? 'دریافت نقد' : 'پرداخت نقد';
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _rateCtrl.dispose();
    _titleCtrl.dispose();
    _docCtrl.dispose();
    _detailsCtrl.dispose();
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
    final amount = double.tryParse(_amountCtrl.text) ?? 0.0;
    final rate = double.tryParse(_rateCtrl.text) ?? 1.0;
    return CurrencyConverter.totoman(
        amount: amount, currency: _currency, exchangeRate: rate);
  }

  void _submit() {
    if (_formKey.currentState!.validate() && _selectedAccount != null) {
      widget.onSubmit(
        accountId: _selectedAccount!.id,
        amount: double.tryParse(_amountCtrl.text) ?? 0.0,
        title: _titleCtrl.text.trim(),
        details:
            _detailsCtrl.text.trim().isEmpty ? null : _detailsCtrl.text.trim(),
        documentNumber: _docCtrl.text.trim(),
        customerId: _selectedCustomer?.id,
        currency: _currency,
        exchangeRate: double.tryParse(_rateCtrl.text) ?? 1.0,
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.isReceipt ? Colors.green : Colors.red;
    final numeric = [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(children: [
          Icon(widget.isReceipt ? Icons.download : Icons.upload, color: color),
          const SizedBox(width: 8),
          Text(widget.isReceipt ? 'ثبت رسید (دریافت)' : 'ثبت برداشت (پرداخت)',
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
                DropdownButtonFormField<AccountModel>(
                  initialValue: _selectedAccount,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'حساب (صندوق/بانک) *',
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
                Row(children: [
                  Expanded(
                    child: TextFormField(
                      controller: _amountCtrl,
                      keyboardType: TextInputType.number,
                      inputFormatters: numeric,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        labelText:
                            'مبلغ (${CurrencyConverter.shortLabel(_currency)}) *',
                        labelStyle: const TextStyle(fontFamily: 'IranYekan'),
                        border: const OutlineInputBorder(),
                      ),
                      validator: (v) => (double.tryParse(v ?? '0') ?? 0) <= 0
                          ? 'مبلغ باید بزرگ‌تر از صفر باشد'
                          : null,
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
                  controller: _docCtrl,
                  decoration: const InputDecoration(
                    labelText: 'شماره سند / رسید',
                    labelStyle: TextStyle(fontFamily: 'IranYekan'),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _titleCtrl,
                  decoration: const InputDecoration(
                    labelText: 'عنوان *',
                    labelStyle: TextStyle(fontFamily: 'IranYekan'),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'عنوان الزامی است' : null,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<CustomerModel>(
                  initialValue: _selectedCustomer,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'مربوط به مشتری (اختیاری)',
                    labelStyle: TextStyle(fontFamily: 'IranYekan'),
                    border: OutlineInputBorder(),
                    helperText: 'اگر انتخاب شود، باقیات مشتری هم آپدیت می‌شود',
                    helperStyle:
                        TextStyle(fontFamily: 'IranYekan', fontSize: 11),
                  ),
                  items: widget.customers
                      .map((c) => DropdownMenuItem(
                            value: c,
                            child: Text('${c.fullName} — ${c.code}',
                                overflow: TextOverflow.ellipsis,
                                style:
                                    const TextStyle(fontFamily: 'IranYekan')),
                          ))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedCustomer = v),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _detailsCtrl,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'تفصیلات',
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
              backgroundColor: color,
              foregroundColor: Colors.white,
            ),
            onPressed: _submit,
            child: Text(widget.isReceipt ? 'ثبت رسید' : 'ثبت برداشت',
                style: const TextStyle(fontFamily: 'IranYekan')),
          ),
        ],
      ),
    );
  }
}
