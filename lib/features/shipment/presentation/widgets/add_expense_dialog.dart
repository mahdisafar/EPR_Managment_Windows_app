import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:eprwindowsapp/core/di/injection.dart';
import 'package:eprwindowsapp/core/models/account_model.dart';
import 'package:eprwindowsapp/core/utils/currency_converter.dart';
import 'package:eprwindowsapp/core/utils/exchange_rate_service.dart';
import '../../../../config/enum.dart';
import '../../data/models/shipment_expense_model.dart';
import 'shipment_expense_list.dart';

class AddExpenseDialog extends StatefulWidget {
  final String shipmentId;
  final List<AccountModel> accounts;
  final Function(ShipmentExpenseModel) onSubmit;

  const AddExpenseDialog({
    super.key,
    required this.shipmentId,
    required this.accounts,
    required this.onSubmit,
  });

  @override
  State<AddExpenseDialog> createState() => _AddExpenseDialogState();
}

class _AddExpenseDialogState extends State<AddExpenseDialog> {
  final _formKey = GlobalKey<FormState>();
  ExpenseType _type = ExpenseType.transportFare;
  CurrencyType _currency = CurrencyType.toman;
  AccountModel? _selectedAccount;

  final _amountCtrl = TextEditingController();
  final _rateCtrl = TextEditingController(text: '1');
  final _paidToCtrl = TextEditingController();
  final _receiptCtrl = TextEditingController();
  final _detailsCtrl = TextEditingController();
  final _dateCtrl = TextEditingController(
    text: DateTime.now().toIso8601String().split('T').first,
  );

  @override
  void dispose() {
    _amountCtrl.dispose();
    _rateCtrl.dispose();
    _paidToCtrl.dispose();
    _receiptCtrl.dispose();
    _detailsCtrl.dispose();
    _dateCtrl.dispose();
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
      final amount = double.tryParse(_amountCtrl.text) ?? 0.0;
      final rate = double.tryParse(_rateCtrl.text) ?? 1.0;

      final expense = ShipmentExpenseModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        shipmentId: widget.shipmentId,
        expenseType: _type,
        amount: amount,
        currency: _currency,
        originalAmount: _currency == CurrencyType.toman ? null : amount,
        exchangeRate: _currency == CurrencyType.toman ? null : rate,
        sourceAccount: _selectedAccount!.id,
        paidTo: _paidToCtrl.text.trim(),
        receiptNumber:
            _receiptCtrl.text.trim().isEmpty ? null : _receiptCtrl.text.trim(),
        details:
            _detailsCtrl.text.trim().isEmpty ? null : _detailsCtrl.text.trim(),
        date: DateTime.tryParse(_dateCtrl.text) ?? DateTime.now(),
      );

      widget.onSubmit(expense);
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
          Icon(Icons.add_card, color: Color(0xFF1E3A8A)),
          SizedBox(width: 8),
          Text('ثبت مصرف محموله',
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
                Row(children: [
                  Expanded(
                    child: DropdownButtonFormField<ExpenseType>(
                      initialValue: _type,
                      decoration: const InputDecoration(
                        labelText: 'نوع مصرف *',
                        labelStyle: TextStyle(fontFamily: 'IranYekan'),
                        border: OutlineInputBorder(),
                      ),
                      items: ExpenseType.values
                          .map((t) => DropdownMenuItem(
                              value: t,
                              child: Text(
                                  ShipmentExpenseList.expenseTypeLabel(t),
                                  style: const TextStyle(
                                      fontFamily: 'IranYekan'))))
                          .toList(),
                      onChanged: (v) => setState(() => _type = v ?? _type),
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
                  if (_currency != CurrencyType.toman) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _rateCtrl,
                        keyboardType: TextInputType.number,
                        inputFormatters: numeric,
                        onChanged: (_) => setState(() {}),
                        decoration: const InputDecoration(
                          labelText: 'نرخ (افغانی)',
                          labelStyle: TextStyle(fontFamily: 'IranYekan'),
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) => (double.tryParse(v ?? '0') ?? 0) <= 0
                            ? 'نرخ باید بزرگ‌تر از صفر باشد'
                            : null,
                      ),
                    ),
                  ],
                ]),
                if (_currency != CurrencyType.toman) ...[
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'معادل تومان ${_tomanPreview.toStringAsFixed(0)} toman',
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
                            child: Text(
                                '${a.accountName} (مانده: ${a.balance.toStringAsFixed(0)})',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 12, fontFamily: 'IranYekan')),
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
                      controller: _paidToCtrl,
                      decoration: const InputDecoration(
                        labelText: 'پرداخت به (شخص/شرکت) *',
                        labelStyle: TextStyle(fontFamily: 'IranYekan'),
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) => v == null || v.trim().isEmpty
                          ? 'نام گیرنده الزامی است'
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _receiptCtrl,
                      decoration: const InputDecoration(
                        labelText: 'شماره رسید',
                        labelStyle: TextStyle(fontFamily: 'IranYekan'),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ]),
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
