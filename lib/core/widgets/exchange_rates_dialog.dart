import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../config/enum.dart';
import '../di/injection.dart';
import '../utils/currency_converter.dart';
import '../utils/exchange_rate_service.dart';

class ExchangeRatesDialog extends StatefulWidget {
  const ExchangeRatesDialog({super.key});

  @override
  State<ExchangeRatesDialog> createState() => _ExchangeRatesDialogState();
}

class _ExchangeRatesDialogState extends State<ExchangeRatesDialog> {
  final _service = sl<ExchangeRateService>();
  final _controllers = <CurrencyType, TextEditingController>{};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final rates = await _service.getAllRates();
    for (final c in rates.keys) {
      _controllers[c] = TextEditingController(text: rates[c].toString());
    }
    if (mounted) setState(() => _loading = false);
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    for (final entry in _controllers.entries) {
      final rate = double.tryParse(entry.value.text) ?? 1.0;
      await _service.setRate(entry.key, rate);
    }
    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('نرخ ارزها ذخیره شد.',
              style: TextStyle(fontFamily: 'IranYekan')),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(children: [
          Icon(Icons.currency_exchange, color: Color(0xFF1E3A8A)),
          SizedBox(width: 8),
          Text('نرخ ارز (به تومان)',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'IranYekan')),
        ]),
        content: SizedBox(
          width: 360,
          child: _loading
              ? const Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Center(child: CircularProgressIndicator()),
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final c in CurrencyType.values)
                      if (c != CurrencyType.toman)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: TextField(
                            controller: _controllers[c],
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d*'))
                            ],
                            decoration: InputDecoration(
                              labelText:
                                  '۱ ${CurrencyConverter.label(c)} = چند تومان؟',
                              labelStyle:
                                  const TextStyle(fontFamily: 'IranYekan'),
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                  ],
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
            onPressed: _loading ? null : _save,
            child: const Text('ذخیره نرخ‌ها',
                style: TextStyle(fontFamily: 'IranYekan')),
          ),
        ],
      ),
    );
  }
}
