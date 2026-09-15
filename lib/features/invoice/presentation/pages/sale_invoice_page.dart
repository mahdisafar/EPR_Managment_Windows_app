import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' as intl;
import 'package:printing/printing.dart';
import 'package:eprwindowsapp/core/di/injection.dart';
import 'package:eprwindowsapp/core/utils/pdf_service.dart';
import 'package:eprwindowsapp/features/inventory/data/models/product_model.dart';
import 'package:eprwindowsapp/features/invoice/presentation/bloc/invoice_bloc.dart';
import 'package:eprwindowsapp/features/invoice/presentation/bloc/invoice_event.dart';
import 'package:eprwindowsapp/features/invoice/presentation/bloc/invoice_state.dart';
import 'package:eprwindowsapp/features/invoice/presentation/widgets/add_item_dialog.dart';
import 'package:eprwindowsapp/features/invoice/presentation/widgets/sale_invoice_header_card.dart';
import 'package:eprwindowsapp/features/invoice/presentation/widgets/sale_invoice_items_table.dart';

class SaleInvoicePage extends StatefulWidget {
  const SaleInvoicePage({super.key});

  @override
  State<SaleInvoicePage> createState() => _SaleInvoicePageState();
}

class _SaleInvoicePageState extends State<SaleInvoicePage> {
  final invoiceNumCtrl = TextEditingController();
  final dateCtrl = TextEditingController(
    text: DateTime.now().toIso8601String().split('T').first,
  );

  @override
  void dispose() {
    invoiceNumCtrl.dispose();
    dateCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<InvoiceBloc>(
      create: (_) => sl<InvoiceBloc>()..add(LoadSaleInvoiceDependenciesEvent()),
      child: Builder(builder: (context) {
        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.5,
            title: const Text(
              'ثبت فاکتور فروش',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontFamily: 'IranYekan',
              ),
            ),
            actions: [
              BlocBuilder<InvoiceBloc, InvoiceState>(
                builder: (context, state) {
                  return IconButton(
                    tooltip: 'پیش‌نمایش و چاپ فاکتور',
                    icon: const Icon(Icons.print, color: Colors.black87),
                    onPressed: state.items.isEmpty
                        ? null
                        : () {
                            final data = InvoicePrintData(
                              title: 'فاکتور فروش',
                              invoiceNumber: invoiceNumCtrl.text,
                              dateText: dateCtrl.text,
                              counterpartyLabel: 'مشتری',
                              counterpartyName:
                                  state.selectedCustomer?.fullName ?? '---',
                              items: state.items,
                              products: state.availableProducts,
                              total: state.totalItemsAmount,
                            );
                            Printing.layoutPdf(
                              onLayout: (_) => PdfService.buildInvoicePdf(data),
                            );
                          },
                  );
                },
              ),
              BlocConsumer<InvoiceBloc, InvoiceState>(
                listener: (context, state) {
                  if (state.status == InvoiceStatus.success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'فاکتور فروش با موفقیت ثبت شد.',
                          style: TextStyle(fontFamily: 'IranYekan'),
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (context.mounted) context.go('/invoices');
                    });
                  } else if (state.status == InvoiceStatus.failure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          state.errorMessage ?? 'خطایی رخ داد',
                          style: const TextStyle(fontFamily: 'IranYekan'),
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E3A8A),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: state.status == InvoiceStatus.submitting
                          ? null
                          : () {
                              context.read<InvoiceBloc>().add(
                                    SubmitSaleInvoiceEvent(
                                      invoiceNumber: invoiceNumCtrl.text,
                                      date: dateCtrl.text,
                                    ),
                                  );
                            },
                      icon: state.status == InvoiceStatus.submitting
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.check),
                      label: const Text(
                        'ثبت فاکتور',
                        style: TextStyle(fontFamily: 'IranYekan'),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          body: BlocBuilder<InvoiceBloc, InvoiceState>(
            builder: (context, state) {
              if (state.status == InvoiceStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SaleInvoiceHeaderCard(
                      invoiceNumberController: invoiceNumCtrl,
                      dateController: dateCtrl,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'اقلام فاکتور',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'IranYekan',
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () async {
                            final result =
                                await showDialog<Map<String, dynamic>>(
                              context: context,
                              builder: (_) => AddItemDialog(
                                products: state.availableProducts,
                              ),
                            );

                            if (result != null && context.mounted) {
                              context.read<InvoiceBloc>().add(
                                    AddInvoiceItemEvent(
                                      product:
                                          result['product'] as ProductModel,
                                      quantity: result['quantity'] as double,
                                      unitPrice: result['unitPrice'] as double,
                                    ),
                                  );
                            }
                          },
                          icon: const Icon(Icons.add),
                          label: const Text(
                            'افزودن کالا',
                            style: TextStyle(fontFamily: 'IranYekan'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: SaleInvoiceItemsTable(
                        items: state.items,
                        availableProducts: state.availableProducts,
                        onRemoveItem: (index) {
                          context.read<InvoiceBloc>().add(
                                RemoveInvoiceItemEvent(index),
                              );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    _SaleSummaryFooter(total: state.totalItemsAmount),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }
}

class _SaleSummaryFooter extends StatelessWidget {
  final double total;

  const _SaleSummaryFooter({required this.total});

  @override
  Widget build(BuildContext context) {
    final formatter = intl.NumberFormat('#,##0.##', 'fa_IR');

    return Card(
      color: Colors.blueGrey.shade50,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'جمع کل فاکتور:',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontFamily: 'IranYekan',
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '${formatter.format(total)} تومان',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade800,
                fontFamily: 'IranYekan',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
