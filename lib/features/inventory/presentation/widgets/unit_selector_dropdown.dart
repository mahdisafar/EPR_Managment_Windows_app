import 'package:flutter/material.dart';
import 'package:eprwindowsapp/config/enum.dart';

class UnitSelectorDropdown extends StatelessWidget {
  final UnitType selectedUnit;
  final ValueChanged<UnitType?> onChanged;

  const UnitSelectorDropdown({
    super.key,
    required this.selectedUnit,
    required this.onChanged,
  });

  static String labelOf(UnitType unit) {
    switch (unit) {
      case UnitType.kg:
        return 'کیلو';
      case UnitType.ser:
        return 'سیر';
      case UnitType.carton:
        return 'کارتن';
      case UnitType.item:
        return 'عدد';
      case UnitType.ton:
        return 'تن';
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<UnitType>(
      initialValue: selectedUnit,
      decoration: const InputDecoration(
        labelText: 'واحد اندازه‌گیری *',
        labelStyle: TextStyle(fontFamily: 'IranYekan'),
        border: OutlineInputBorder(),
      ),
      items: UnitType.values
          .map((u) => DropdownMenuItem(
                value: u,
                child: Text(labelOf(u),
                    style: const TextStyle(fontFamily: 'IranYekan')),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }
}
