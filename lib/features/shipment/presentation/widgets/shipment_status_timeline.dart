import 'package:flutter/material.dart';
import 'package:eprwindowsapp/config/enum.dart';
import 'shipment_data_table.dart';

class ShipmentStatusTimeline extends StatelessWidget {
  final ShipmentStatus currentStatus;

  const ShipmentStatusTimeline({super.key, required this.currentStatus});

  @override
  Widget build(BuildContext context) {
    final statuses = ShipmentStatus.values;
    final currentIndex = statuses.indexOf(currentStatus);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('پیگیری وضعیت محموله',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'IranYekan')),
            const SizedBox(height: 20),
            ...List.generate(statuses.length, (i) {
              final isDone = i < currentIndex;
              final isCurrent = i == currentIndex;
              final isLast = i == statuses.length - 1;

              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDone
                                ? Colors.green
                                : (isCurrent
                                    ? const Color(0xFF1E3A8A)
                                    : Colors.grey.shade300),
                          ),
                          child: Icon(
                            isDone ? Icons.check : Icons.circle,
                            size: isDone ? 16 : 10,
                            color: Colors.white,
                          ),
                        ),
                        if (!isLast)
                          Expanded(
                            child: Container(
                              width: 2,
                              color:
                                  isDone ? Colors.green : Colors.grey.shade300,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        ShipmentDataTable.statusLabel(statuses[i]),
                        style: TextStyle(
                          fontFamily: 'IranYekan',
                          fontSize: 14,
                          fontWeight:
                              isCurrent ? FontWeight.bold : FontWeight.normal,
                          color: isCurrent
                              ? const Color(0xFF1E3A8A)
                              : (isDone
                                  ? Colors.green.shade700
                                  : Colors.grey.shade600),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
