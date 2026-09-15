import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import '../../../../config/enum.dart' show ShipmentStatus;
import '../../data/models/shipment_model.dart';
import 'shipment_data_table.dart';

class ShipmentInfoCard extends StatelessWidget {
  final ShipmentModel shipment;
  final VoidCallback? onAdvanceStatus;

  const ShipmentInfoCard({
    super.key,
    required this.shipment,
    this.onAdvanceStatus,
  });

  Widget _info(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 11, color: Colors.grey, fontFamily: 'IranYekan')),
        const SizedBox(height: 2),
        Text(value,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                fontFamily: 'IranYekan')),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final formatter = intl.NumberFormat('#,##0.##', 'fa_IR');
    final dateFormatter = intl.DateFormat('yyyy/MM/dd', 'fa_IR');
    final isLast = shipment.status == ShipmentStatus.values.last;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('محموله ${shipment.shipmentNumber}',
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'IranYekan')),
                  const SizedBox(height: 4),
                  Text(
                    '${shipment.originCity} ← ${shipment.destinationCity}',
                    style: TextStyle(
                        color: Colors.grey.shade600, fontFamily: 'IranYekan'),
                  ),
                ]),
                Row(children: [
                  Chip(
                    label: Text(ShipmentDataTable.statusLabel(shipment.status),
                        style: const TextStyle(
                            color: Colors.white, fontFamily: 'IranYekan')),
                    backgroundColor:
                        ShipmentDataTable.statusColor(shipment.status),
                  ),
                  const SizedBox(width: 12),
                  if (!isLast && onAdvanceStatus != null)
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: onAdvanceStatus,
                      icon: const Icon(Icons.arrow_forward, size: 18),
                      label: const Text('مرحله بعد',
                          style: TextStyle(fontFamily: 'IranYekan')),
                    ),
                ]),
              ],
            ),
            const Divider(height: 28),
            Wrap(
              spacing: 32,
              runSpacing: 16,
              children: [
                _info('نوع کالا', shipment.goodsType),
                _info('شرکت ترانسپورت', shipment.transportCompany),
                _info('موتر / راننده',
                    '${shipment.vehicleNumber} — ${shipment.driverName}'),
                _info(
                    'تاریخ ارسال', dateFormatter.format(shipment.dispatchDate)),
                _info('تعداد بسته', formatter.format(shipment.packageCount)),
                _info('وزن (کیلو)', formatter.format(shipment.weight)),
                _info('ارزش کالا (toman)',
                    formatter.format(shipment.declaredValue)),
                _info('مجموع مصارف (toman)',
                    formatter.format(shipment.totalCustomsAndTransportCosts)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
