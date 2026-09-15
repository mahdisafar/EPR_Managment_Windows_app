import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as intl;
import 'package:printing/printing.dart';
import 'package:eprwindowsapp/core/utils/pdf_service.dart';
import 'package:eprwindowsapp/core/widgets/excel_export_button.dart';
import '../../data/models/invoice_model.dart';
import '../bloc/invoices_list_bloc.dart';
import '../widgets/invoice_list_table.dart';
import '../widgets/invoice_preview_dialog.dart';

class InvoicesListPage extends StatefulWidget {
  const InvoicesListPage({super.key});

  @override
  State<InvoicesListPage> createState() => _InvoicesListPageState();
}

class _InvoicesListPageState extends State<InvoicesListPage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<InvoicesListBloc>().add(LoadInvoicesListEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _printInvoice(InvoicesListLoaded state, InvoiceModel inv) {
    final isSale = inv.type.name == 'sale';
    final itemsTotal = inv.items.fold<double>(0.0, (s, i) => s + i.totalPrice);
    final data = InvoicePrintData(
      title: isSale ? 'فاکتور فروش' : 'فاکتور خرید',
      invoiceNumber: inv.invoiceNumber,
      dateText: intl.DateFormat('yyyy/MM/dd').format(inv.date),
      counterpartyLabel: isSale ? 'مشتری' : 'فروشنده',
      counterpartyName: isSale
          ? (state.customerNames[inv.customerId] ?? '---')
          : (inv.details ?? '---'),
      items: inv.items,
      products: state.products,
      sideCosts: isSale ? 0 : (inv.totalAmount - itemsTotal),
      total: inv.totalAmount,
    );
    showDialog(
      context: context,
      builder: (_) => InvoicePreviewDialog(data: data),
    );
  }

  Widget _filterChip(String label, String value, String current,
      void Function(String) onSelect) {
    final selected = current == value;
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: ChoiceChip(
        label: Text(label,
            style: const TextStyle(fontFamily: 'IranYekan', fontSize: 12)),
        selected: selected,
        selectedColor: const Color(0xFF1E3A8A),
        labelStyle: TextStyle(
          color: selected ? Colors.white : Colors.grey.shade700,
          fontFamily: 'IranYekan',
        ),
        onSelected: (_) => onSelect(value),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('فاکتورها',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'IranYekan')),
                  SizedBox(height: 4),
                  Text('لیست کامل فاکتورهای فروش و خرید ثبت‌شده',
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                          fontFamily: 'IranYekan')),
                ],
              ),
              const SizedBox(height: 20),

              // Filters + Search + Excel
              Row(
                children: [
                  BlocBuilder<InvoicesListBloc, InvoicesListState>(
                    builder: (context, state) {
                      final current = state is InvoicesListLoaded
                          ? state.typeFilter
                          : 'all';
                      return Row(children: [
                        _filterChip(
                            'همه',
                            'all',
                            current,
                            (v) => context
                                .read<InvoicesListBloc>()
                                .add(FilterInvoicesByTypeEvent(v))),
                        _filterChip(
                            'فروش',
                            'sale',
                            current,
                            (v) => context
                                .read<InvoicesListBloc>()
                                .add(FilterInvoicesByTypeEvent(v))),
                        _filterChip(
                            'خرید',
                            'purchase',
                            current,
                            (v) => context
                                .read<InvoicesListBloc>()
                                .add(FilterInvoicesByTypeEvent(v))),
                      ]);
                    },
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 300,
                    child: TextField(
                      controller: _searchController,
                      onChanged: (q) => context
                          .read<InvoicesListBloc>()
                          .add(SearchInvoicesListEvent(q)),
                      decoration: InputDecoration(
                        hintText: 'جستجو شماره فاکتور یا نام مشتری...',
                        hintStyle: const TextStyle(
                            fontSize: 12, fontFamily: 'IranYekan'),
                        prefixIcon: const Icon(Icons.search, size: 20),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 12),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.grey.shade300)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.grey.shade300)),
                      ),
                    ),
                  ),
                  const Spacer(),
                  ExcelExportButton(
                    fileName: 'لیست_فاکتورها',
                    headers: [
                      'شماره',
                      'نوع',
                      'طرف حساب',
                      'تاریخ',
                      'اقلام',
                      'مبلغ کل'
                    ],
                    rowsBuilder: () {
                      final s = context.read<InvoicesListBloc>().state;
                      if (s is! InvoicesListLoaded) return [];
                      return s.filteredInvoices
                          .map((inv) => [
                                inv.invoiceNumber,
                                inv.type.name == 'sale' ? 'فروش' : 'خرید',
                                s.customerNames[inv.customerId] ??
                                    (inv.details ?? 'تأمین‌کننده'),
                                inv.date.toIso8601String(),
                                inv.items.length,
                                inv.totalAmount,
                              ])
                          .toList();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Total + Table
              Expanded(
                child: BlocConsumer<InvoicesListBloc, InvoicesListState>(
                  listener: (context, state) {
                    if (state is InvoicesListError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message,
                              style: const TextStyle(fontFamily: 'IranYekan')),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is InvoicesListLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is InvoicesListLoaded) {
                      final formatter = intl.NumberFormat('#,##0.##', 'fa_IR');
                      return Column(children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: Theme.of(context).dividerColor),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'جمع فاکتورها (${formatter.format(state.filteredInvoices.length)} فقره):',
                                style: const TextStyle(
                                    fontFamily: 'IranYekan',
                                    color: Colors.grey),
                              ),
                              Text(
                                '${formatter.format(state.totalFiltered)} toman',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade900,
                                  fontFamily: 'IranYekan',
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: Theme.of(context).dividerColor),
                            ),
                            child: InvoiceListTable(
                              invoices: state.filteredInvoices,
                              customerNames: state.customerNames,
                              onPrint: (inv) => _printInvoice(state, inv),
                            ),
                          ),
                        ),
                      ]);
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
