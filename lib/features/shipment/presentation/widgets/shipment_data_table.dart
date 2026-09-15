import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:eprwindowsapp/config/enum.dart';
import '../../data/models/shipment_model.dart';

class ShipmentDataTable extends StatelessWidget {
  final List<ShipmentModel> shipments;
  final Function(ShipmentModel) onShipmentTap;

  const ShipmentDataTable({
    super.key,
    required this.shipments,
    required this.onShipmentTap,
  });

  static String statusLabel(ShipmentStatus status) {
    switch (status) {
      case ShipmentStatus.registered:
        return 'ثبت محموله';
      case ShipmentStatus.readyForShipping:
        return 'آماده ارسال';
      case ShipmentStatus.departedOrigin:
        return 'حرکت از مبدأ';
      case ShipmentStatus.inTransit:
        return 'در مسیر';
      case ShipmentStatus.arrivedBorder:
        return 'رسیدن به مرز';
      case ShipmentStatus.customs:
        return 'گمرک';
      case ShipmentStatus.cleared:
        return 'ترخیص';
      case ShipmentStatus.transferToDestination:
        return 'انتقال به مقصد';
      case ShipmentStatus.arrivedWarehouse:
        return 'رسیدن به انبار';
    }
  }

  static Color statusColor(ShipmentStatus status) {
    final idx = ShipmentStatus.values.indexOf(status);
    if (idx >= ShipmentStatus.values.length - 1) return Colors.green;
    if (idx >= 4) return Colors.orange;
    return Colors.blue;
  }

  static const TextStyle _headerStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontFamily: 'IranYekan',
    fontSize: 12,
  );

  static DataColumn _col(String label) => DataColumn(
        label: Text(label, style: _headerStyle),
      );

  @override
  Widget build(BuildContext context) {
    final formatter = intl.NumberFormat('#,##0.##', 'fa_IR');
    final dateFormatter = intl.DateFormat('yyyy/MM/dd', 'fa_IR');

    if (shipments.isEmpty) {
      return const Center(
        child: Text(
          'هیچ محموله‌ای ثبت نشده است.',
          style: TextStyle(fontFamily: 'IranYekan', color: Colors.grey),
        ),
      );
    }

    return SingleChildScrollView(
      child: SizedBox(
        width: double.infinity,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(Colors.grey.shade50),
          headingRowHeight: 48,
          columnSpacing: 16,
          dataRowMinHeight: 56,
          dataRowMaxHeight: 56,
          columns: [
            _col('شماره'),
            _col('مسیر'),
            _col('تاریخ'),
            _col('وضعیت'),
            _col('ترانسپورت'),
            _col('بسته/وزن'),
            _col('ارزش (toman)'),
            _col('عملیات'),
          ],
          rows: shipments.map((shipment) {
            return DataRow(
              cells: [
                DataCell(Text(shipment.shipmentNumber,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontFamily: 'IranYekan'))),
                DataCell(Text(
                  '${shipment.originCity} ← ${shipment.destinationCity}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontFamily: 'IranYekan'),
                )),
                DataCell(Text(dateFormatter.format(shipment.dispatchDate),
                    style: const TextStyle(fontFamily: 'IranYekan'))),
                DataCell(Chip(
                  label: Text(statusLabel(shipment.status),
                      style: const TextStyle(
                          fontSize: 11,
                          color: Colors.white,
                          fontFamily: 'IranYekan')),
                  backgroundColor: statusColor(shipment.status),
                  visualDensity: VisualDensity.compact,
                )),
                DataCell(Text(shipment.transportCompany,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontFamily: 'IranYekan'))),
                DataCell(Text(
                    '${formatter.format(shipment.packageCount)}/${formatter.format(shipment.weight)}',
                    style: const TextStyle(fontFamily: 'IranYekan'))),
                DataCell(Text(formatter.format(shipment.declaredValue),
                    style: const TextStyle(fontFamily: 'IranYekan'))),
                DataCell(
                  IconButton(
                    icon: const Icon(Icons.visibility_outlined,
                        color: Colors.blue, size: 20),
                    tooltip: 'جزئیات و پیگیری',
                    onPressed: () => onShipmentTap(shipment),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
