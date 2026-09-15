import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eprwindowsapp/features/customer/data/models/customer_model.dart';
import '../bloc/invoice_bloc.dart';
import '../bloc/invoice_event.dart';
import '../bloc/invoice_state.dart';

class SaleInvoiceHeaderCard extends StatelessWidget {
  final TextEditingController invoiceNumberController;
  final TextEditingController dateController;

  const SaleInvoiceHeaderCard({
    super.key,
    required this.invoiceNumberController,
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
              'اطلاعات فاکتور فروش',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'IranYekan',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: invoiceNumberController,
                    decoration: const InputDecoration(
                      labelText: 'شماره فاکتور',
                      labelStyle: TextStyle(fontFamily: 'IranYekan'),
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.receipt_long),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: dateController,
                    decoration: const InputDecoration(
                      labelText: 'تاریخ ثبت',
                      labelStyle: TextStyle(fontFamily: 'IranYekan'),
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: BlocBuilder<InvoiceBloc, InvoiceState>(
                    builder: (context, state) {
                      return DropdownButtonFormField<CustomerModel>(
                        initialValue: state.selectedCustomer,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'مشتری (نسیه)',
                          labelStyle: TextStyle(fontFamily: 'IranYekan'),
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        items: state.availableCustomers
                            .map((c) => DropdownMenuItem(
                                  value: c,
                                  child: Text(
                                    '${c.fullName} — ${c.code}',
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontFamily: 'IranYekan'),
                                  ),
                                ))
                            .toList(),
                        onChanged: (customer) {
                          if (customer != null) {
                            context
                                .read<InvoiceBloc>()
                                .add(SelectSaleCustomerEvent(customer));
                          }
                        },
                      );
                    },
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
