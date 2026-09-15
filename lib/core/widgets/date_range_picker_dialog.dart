import 'package:flutter/material.dart';

class CustomDateRangeDialog extends StatefulWidget {
  const CustomDateRangeDialog({super.key});

  @override
  State<CustomDateRangeDialog> createState() => _CustomDateRangeDialogState();
}

class _CustomDateRangeDialogState extends State<CustomDateRangeDialog> {
  final _startCtrl = TextEditingController();
  final _endCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _startCtrl.text =
        DateTime(now.year, now.month, 1).toIso8601String().split('T').first;
    _endCtrl.text = now.toIso8601String().split('T').first;
  }

  @override
  void dispose() {
    _startCtrl.dispose();
    _endCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final start = DateTime.tryParse(_startCtrl.text.trim());
    final end = DateTime.tryParse(_endCtrl.text.trim());
    if (start != null && end != null) {
      Navigator.of(context).pop((start, end));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(children: [
          Icon(Icons.date_range, color: Color(0xFF1E3A8A)),
          SizedBox(width: 8),
          Text('بازه زمانی دلخواه',
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'IranYekan')),
        ]),
        content: SizedBox(
          width: 380,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(
              controller: _startCtrl,
              decoration: const InputDecoration(
                labelText: 'از تاریخ (YYYY-MM-DD) *',
                labelStyle: TextStyle(fontFamily: 'IranYekan'),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _endCtrl,
              decoration: const InputDecoration(
                labelText: 'تا تاریخ (YYYY-MM-DD) *',
                labelStyle: TextStyle(fontFamily: 'IranYekan'),
                border: OutlineInputBorder(),
              ),
            ),
          ]),
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
            child:
                const Text('اعمال', style: TextStyle(fontFamily: 'IranYekan')),
          ),
        ],
      ),
    );
  }
}
