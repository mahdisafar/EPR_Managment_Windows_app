import 'package:flutter/material.dart';
import 'package:eprwindowsapp/core/models/account_model.dart';
import 'package:eprwindowsapp/config/enum.dart';
import 'account_list_table.dart';

class AddAccountDialog extends StatefulWidget {
  final Function(AccountModel) onSubmit;

  const AddAccountDialog({super.key, required this.onSubmit});

  @override
  State<AddAccountDialog> createState() => _AddAccountDialogState();
}

class _AddAccountDialogState extends State<AddAccountDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  AccountType _type = AccountType.cash;
  CurrencyType _currency = CurrencyType.toman;

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(AccountModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        accountName: _nameCtrl.text.trim(),
        accountType: _type,
        balance: 0.0,
        currency: _currency,
      ));
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(children: [
          Icon(Icons.account_balance_wallet_outlined, color: Color(0xFF1E3A8A)),
          SizedBox(width: 8),
          Text('حساب جدید',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'IranYekan')),
        ]),
        content: SizedBox(
          width: 400,
          child: Form(
            key: _formKey,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'نام حساب *',
                  labelStyle: TextStyle(fontFamily: 'IranYekan'),
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v == null || v.trim().isEmpty
                    ? 'نام حساب الزامی است'
                    : null,
              ),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(
                  child: DropdownButtonFormField<AccountType>(
                    initialValue: _type,
                    decoration: const InputDecoration(
                      labelText: 'نوع حساب',
                      labelStyle: TextStyle(fontFamily: 'IranYekan'),
                      border: OutlineInputBorder(),
                    ),
                    items: AccountType.values
                        .map((t) => DropdownMenuItem(
                            value: t,
                            child: Text(AccountListTable.typeLabel(t),
                                style:
                                    const TextStyle(fontFamily: 'IranYekan'))))
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
                            child: Text(AccountListTable.currencyLabel(c),
                                style:
                                    const TextStyle(fontFamily: 'IranYekan'))))
                        .toList(),
                    onChanged: (v) =>
                        setState(() => _currency = v ?? _currency),
                  ),
                ),
              ]),
            ]),
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
            child: const Text('ثبت حساب',
                style: TextStyle(fontFamily: 'IranYekan')),
          ),
        ],
      ),
    );
  }
}
