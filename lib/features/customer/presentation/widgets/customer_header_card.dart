import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import '../../data/models/customer_model.dart';

class CustomerHeaderCard extends StatelessWidget {
  final CustomerModel customer;
  final VoidCallback onRecordPaymentTap;

  const CustomerHeaderCard({
    super.key,
    required this.customer,
    required this.onRecordPaymentTap,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = intl.NumberFormat("#,##0.##", "fa_IR");
    final isDebtor = customer.currentBalance > 0;
    final isCreditor = customer.currentBalance < 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Customer Details
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    customer.fullName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'IranYekan',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'کد: ${customer.code}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue.shade800,
                        fontFamily: 'IranYekan',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.phone, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    customer.phoneNumber.isNotEmpty
                        ? customer.phoneNumber
                        : '---',
                    style: const TextStyle(
                        color: Colors.grey, fontFamily: 'IranYekan'),
                  ),
                  const SizedBox(width: 24),
                  const Icon(Icons.location_on, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    customer.address.isNotEmpty ? customer.address : '---',
                    style: const TextStyle(
                        color: Colors.grey, fontFamily: 'IranYekan'),
                  ),
                ],
              ),
            ],
          ),

          // Balance & Action Button
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'بیلانس فعلی (باقیات)',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontFamily: 'IranYekan',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${currencyFormatter.format(customer.currentBalance)} toman',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'IranYekan',
                      color: isDebtor
                          ? Colors.red.shade700
                          : (isCreditor
                              ? Colors.green.shade700
                              : Colors.black87),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 24),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: onRecordPaymentTap,
                icon: const Icon(Icons.payments_outlined, size: 18),
                label: const Text(
                  'ثبت دریافت وجه',
                  style: TextStyle(
                      fontFamily: 'IranYekan', fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
