import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:eprwindowsapp/config/enum.dart';
import '../../data/models/shipment_model.dart';

class ShipmentFormFields extends StatefulWidget {
  final Function(ShipmentModel) onSubmit;

  const ShipmentFormFields({super.key, required this.onSubmit});

  @override
  State<ShipmentFormFields> createState() => _ShipmentFormFieldsState();
}

class _ShipmentFormFieldsState extends State<ShipmentFormFields> {
  final _formKey = GlobalKey<FormState>();

  final _numberCtrl = TextEditingController();
  final _originCountryCtrl = TextEditingController(text: 'افغانستان');
  final _originCityCtrl = TextEditingController();
  final _destCountryCtrl = TextEditingController();
  final _destCityCtrl = TextEditingController();
  final _dateCtrl = TextEditingController(
    text: DateTime.now().toIso8601String().split('T').first,
  );
  final _companyCtrl = TextEditingController();
  final _vehicleCtrl = TextEditingController();
  final _driverCtrl = TextEditingController();
  final _goodsCtrl = TextEditingController();
  final _packagesCtrl = TextEditingController(text: '1');
  final _weightCtrl = TextEditingController();
  final _valueCtrl = TextEditingController();

  @override
  void dispose() {
    _numberCtrl.dispose();
    _originCountryCtrl.dispose();
    _originCityCtrl.dispose();
    _destCountryCtrl.dispose();
    _destCityCtrl.dispose();
    _dateCtrl.dispose();
    _companyCtrl.dispose();
    _vehicleCtrl.dispose();
    _driverCtrl.dispose();
    _goodsCtrl.dispose();
    _packagesCtrl.dispose();
    _weightCtrl.dispose();
    _valueCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final shipment = ShipmentModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        shipmentNumber: _numberCtrl.text.trim(),
        originCountry: _originCountryCtrl.text.trim(),
        originCity: _originCityCtrl.text.trim(),
        destinationCountry: _destCountryCtrl.text.trim(),
        destinationCity: _destCityCtrl.text.trim(),
        dispatchDate: DateTime.tryParse(_dateCtrl.text) ?? DateTime.now(),
        status: ShipmentStatus.registered,
        transportCompany: _companyCtrl.text.trim(),
        vehicleNumber: _vehicleCtrl.text.trim(),
        driverName: _driverCtrl.text.trim(),
        goodsType: _goodsCtrl.text.trim(),
        packageCount: int.tryParse(_packagesCtrl.text) ?? 0,
        weight: double.tryParse(_weightCtrl.text) ?? 0.0,
        declaredValue: double.tryParse(_valueCtrl.text) ?? 0.0,
      );

      widget.onSubmit(shipment);
    }
  }

  Widget _field(TextEditingController ctrl, String label,
      {TextInputType? type,
      List<TextInputFormatter>? formatters,
      String? Function(String?)? validator}) {
    return TextFormField(
      controller: ctrl,
      keyboardType: type,
      inputFormatters: formatters,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontFamily: 'IranYekan'),
        border: const OutlineInputBorder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final numeric = [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))];

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Expanded(
                child: _field(_numberCtrl, 'شماره محموله *',
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'شماره الزامی است'
                        : null)),
            const SizedBox(width: 12),
            Expanded(child: _field(_dateCtrl, 'تاریخ ارسال')),
            const SizedBox(width: 12),
            Expanded(
                child: _field(_goodsCtrl, 'نوع کالا *',
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'نوع کالا الزامی است'
                        : null)),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: _field(_originCountryCtrl, 'کشور مبدأ')),
            const SizedBox(width: 12),
            Expanded(
                child: _field(_originCityCtrl, 'شهر مبدأ *',
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'شهر مبدأ الزامی است'
                        : null)),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: _field(_destCountryCtrl, 'کشور مقصد')),
            const SizedBox(width: 12),
            Expanded(
                child: _field(_destCityCtrl, 'شهر مقصد *',
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'شهر مقصد الزامی است'
                        : null)),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: _field(_companyCtrl, 'شرکت ترانسپورت')),
            const SizedBox(width: 12),
            Expanded(child: _field(_vehicleCtrl, 'شماره موتر')),
            const SizedBox(width: 12),
            Expanded(child: _field(_driverCtrl, 'راننده')),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(
                child: _field(_packagesCtrl, 'تعداد بسته',
                    type: TextInputType.number,
                    formatters: [FilteringTextInputFormatter.digitsOnly])),
            const SizedBox(width: 12),
            Expanded(
                child: _field(_weightCtrl, 'وزن (کیلو) *',
                    type: TextInputType.number,
                    formatters: numeric,
                    validator: (v) => (double.tryParse(v ?? '0') ?? 0) <= 0
                        ? 'وزن باید بزرگ‌تر از صفر باشد'
                        : null)),
            const SizedBox(width: 12),
            Expanded(
                child: _field(_valueCtrl, 'ارزش کالا (toman)',
                    type: TextInputType.number, formatters: numeric)),
          ]),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E3A8A),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: _submit,
              icon: const Icon(Icons.local_shipping),
              label: const Text('ثبت محموله',
                  style: TextStyle(fontFamily: 'IranYekan', fontSize: 15)),
            ),
          ),
        ],
      ),
    );
  }
}
