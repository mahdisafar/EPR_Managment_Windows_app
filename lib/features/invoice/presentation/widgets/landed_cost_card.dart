import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LandedCostCard extends StatefulWidget {
  final Function(double freight, double customs, double labor) onCostsChanged;

  const LandedCostCard({super.key, required this.onCostsChanged});

  @override
  State<LandedCostCard> createState() => _LandedCostCardState();
}

class _LandedCostCardState extends State<LandedCostCard> {
  final _freightController = TextEditingController(text: '0');
  final _customsController = TextEditingController(text: '0');
  final _laborController = TextEditingController(text: '0');

  @override
  void dispose() {
    _freightController.dispose();
    _customsController.dispose();
    _laborController.dispose();
    super.dispose();
  }

  void _triggerChange() {
    final f = double.tryParse(_freightController.text) ?? 0.0;
    final c = double.tryParse(_customsController.text) ?? 0.0;
    final l = double.tryParse(_laborController.text) ?? 0.0;
    widget.onCostsChanged(f, c, l);
  }

  Widget _buildField(TextEditingController controller, String label) {
    return Expanded(
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
        ],
        onChanged: (_) => _triggerChange(),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontFamily: 'IranYekan'),
          border: const OutlineInputBorder(),
          suffixText: 'تومان',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'هزینه‌های جانبی خرید (محاسبه فی تمام‌شده)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'IranYekan',
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildField(_freightController, 'کرایه حمل'),
                const SizedBox(width: 8),
                _buildField(_customsController, 'گمرک / محصول'),
                const SizedBox(width: 8),
                _buildField(_laborController, 'تخلیه / بارگیری'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
