import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import '../../data/models/customer_model.dart';

class CustomerDataTable extends StatelessWidget {
  final List<CustomerModel> customers;
  final Function(CustomerModel) onCustomerTap;

  const CustomerDataTable({
    super.key,
    required this.customers,
    required this.onCustomerTap,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = intl.NumberFormat("#,##0.##", "fa_IR");

    if (customers.isEmpty) {
      return const Center(
        child: Text(
          'هیچ مشتری با این مشخصات یافت نشد.',
          style: TextStyle(fontFamily: 'IranYekan', color: Colors.grey),
        ),
      );
    }

    return SingleChildScrollView(
      child: SizedBox(
        width: double.infinity,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(Colors.grey.shade50),
          dataRowMinHeight: 56,
          dataRowMaxHeight: 56,
          columns: const [
            DataColumn(
                label: Text('کد مشتری',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontFamily: 'IranYekan'))),
            DataColumn(
                label: Text('نام و نام خانوادگی',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontFamily: 'IranYekan'))),
            DataColumn(
                label: Text('شماره تماس',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontFamily: 'IranYekan'))),
            DataColumn(
                label: Text('آدرس',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontFamily: 'IranYekan'))),
            DataColumn(
                label: Text('بیلانس فعلی (toman)',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontFamily: 'IranYekan'))),
            DataColumn(
                label: Text('عملیات',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontFamily: 'IranYekan'))),
          ],
          rows: customers.map((customer) {
            final isDebtor = customer.currentBalance > 0;
            final isCreditor = customer.currentBalance < 0;

            return DataRow(
              cells: [
                DataCell(Text(
                  customer.code,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontFamily: 'IranYekan'),
                )),
                DataCell(Text(
                  customer.fullName,
                  style: const TextStyle(fontFamily: 'IranYekan'),
                )),
                DataCell(Text(
                  customer.phoneNumber.isNotEmpty
                      ? customer.phoneNumber
                      : '---',
                  style: const TextStyle(fontFamily: 'IranYekan'),
                )),
                DataCell(Text(
                  customer.address.isNotEmpty ? customer.address : '---',
                  style: const TextStyle(fontFamily: 'IranYekan'),
                )),
                DataCell(Text(
                  currencyFormatter.format(customer.currentBalance),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDebtor
                        ? Colors.red.shade700
                        : (isCreditor ? Colors.green.shade700 : Colors.black87),
                    fontFamily: 'IranYekan',
                  ),
                )),
                DataCell(
                  IconButton(
                    icon: const Icon(Icons.receipt_long_outlined,
                        color: Colors.blue),
                    tooltip: 'مشاهده صورت‌حساب',
                    onPressed: () => onCustomerTap(customer),
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
