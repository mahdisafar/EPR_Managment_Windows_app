import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:printing/printing.dart';
import 'package:eprwindowsapp/core/di/injection.dart';
import 'package:eprwindowsapp/core/utils/pdf_service.dart';
import 'package:eprwindowsapp/features/invoice/presentation/bloc/invoice_bloc.dart';
import 'package:eprwindowsapp/features/invoice/presentation/bloc/invoice_event.dart';
import 'package:eprwindowsapp/features/invoice/presentation/bloc/invoice_state.dart';
import 'package:eprwindowsapp/features/invoice/presentation/widgets/invoice_header_card.dart';
import 'package:eprwindowsapp/features/invoice/presentation/widgets/landed_cost_card.dart';
import 'package:eprwindowsapp/features/invoice/presentation/widgets/invoice_items_table.dart';
import 'package:eprwindowsapp/features/invoice/presentation/widgets/add_item_dialog.dart';
import 'package:eprwindowsapp/features/inventory/data/models/product_model.dart';

class PurchaseInvoicePage extends StatefulWidget {
  const PurchaseInvoicePage({super.key});

  @override
  State<PurchaseInvoicePage> createState() => _PurchaseInvoicePageState();
}

class _PurchaseInvoicePageState extends State<PurchaseInvoicePage> {
  final invoiceNumCtrl = TextEditingController();
  final supplierCtrl = TextEditingController();
  final dateCtrl = TextEditingController(
    text: DateTime.now().toIso8601String().split('T').first,
  );

  @override
  void dispose() {
    invoiceNumCtrl.dispose();
    supplierCtrl.dispose();
    dateCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<InvoiceBloc>(
      create: (context) =>
          sl<InvoiceBloc>()..add(LoadPurchaseInvoiceDependenciesEvent()),
      child: Builder(builder: (context) {
        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.5,
            title: const Text(
              'ثبت فاکتور خرید جدید',
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
                              title: 'فاکتور خرید',
                              invoiceNumber: invoiceNumCtrl.text,
                              dateText: dateCtrl.text,
                              counterpartyLabel: 'فروشنده',
                              counterpartyName: supplierCtrl.text,
                              items: state.items,
                              products: state.availableProducts,
                              sideCosts: state.totalLandedCost,
                              total: state.grandTotal,
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
                          'فاکتور خرید با موفقیت ثبت شد.',
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
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: state.status == InvoiceStatus.submitting
                          ? null
                          : () {
                              context.read<InvoiceBloc>().add(
                                    SubmitPurchaseInvoiceEvent(
                                      invoiceNumber: invoiceNumCtrl.text,
                                      supplierName: supplierCtrl.text,
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
                        'ثبت و نهایی‌سازی',
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
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    InvoiceHeaderCard(
                      invoiceNumberController: invoiceNumCtrl,
                      supplierController: supplierCtrl,
                      dateController: dateCtrl,
                    ),
                    const SizedBox(height: 12),
                    LandedCostCard(
                      onCostsChanged: (freight, customs, labor) {
                        context.read<InvoiceBloc>().add(
                              UpdateLandedCostsEvent(
                                freightCost: freight,
                                customsCost: customs,
                                laborCost: labor,
                              ),
                            );
                      },
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
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: InvoiceItemsTable(
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
                    _buildSummaryFooter(state),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildSummaryFooter(InvoiceState state) {
    return Card(
      color: Colors.blueGrey.shade50,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _SummaryTile(
              label: 'مجموع اجناس:',
              value: '${state.totalItemsAmount.toStringAsFixed(0)} تومان',
            ),
            _SummaryTile(
              label: 'مجموع هزینه‌های جانبی:',
              value: '${state.totalLandedCost.toStringAsFixed(0)} تومان',
            ),
            _SummaryTile(
              label: 'جمع کل فاکتور:',
              value: '${state.grandTotal.toStringAsFixed(0)} تومان',
              isBold: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _SummaryTile({
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label,
            style: const TextStyle(
                color: Colors.grey, fontSize: 13, fontFamily: 'IranYekan')),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 18 : 15,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: isBold ? Colors.green.shade800 : Colors.black87,
            fontFamily: 'IranYekan',
          ),
        ),
      ],
    );
  }
}
