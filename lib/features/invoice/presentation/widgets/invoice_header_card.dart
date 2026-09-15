import 'package:flutter/material.dart';

class InvoiceHeaderCard extends StatelessWidget {
  final TextEditingController invoiceNumberController;
  final TextEditingController supplierController;
  final TextEditingController dateController;

  const InvoiceHeaderCard({
    super.key,
    required this.invoiceNumberController,
    required this.supplierController,
    required this.dateController,
  });

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
              'اطلاعات اولیه فاکتور خرید',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: invoiceNumberController,
                    decoration: const InputDecoration(
                      labelText: 'شماره فاکتور / سند',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.receipt_long),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: supplierController,
                    decoration: const InputDecoration(
                      labelText: 'فروشنده / تامین‌کننده',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: dateController,
                    decoration: const InputDecoration(
                      labelText: 'تاریخ ثبت',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
