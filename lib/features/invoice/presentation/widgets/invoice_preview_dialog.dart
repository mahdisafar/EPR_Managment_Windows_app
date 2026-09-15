import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:printing/printing.dart';
import 'package:eprwindowsapp/config/print_config.dart';
import 'package:eprwindowsapp/core/di/injection.dart';
import 'package:eprwindowsapp/core/utils/app_settings_service.dart';
import 'package:eprwindowsapp/core/utils/pdf_service.dart';

class InvoicePreviewDialog extends StatefulWidget {
  final InvoicePrintData data;

  const InvoicePreviewDialog({super.key, required this.data});

  @override
  State<InvoicePreviewDialog> createState() => _InvoicePreviewDialogState();
}

class _InvoicePreviewDialogState extends State<InvoicePreviewDialog> {
  String _companyName = PrintConfig.companyName;
  String _companyPhone = PrintConfig.companyPhone;
  String _companyAddress = PrintConfig.companyAddress;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _loadCompanyInfo();
  }

  Future<void> _loadCompanyInfo() async {
    final settings = sl<AppSettingsService>();
    final name = await settings.get(AppSettingsService.keyCompanyName);
    final phone = await settings.get(AppSettingsService.keyCompanyPhone);
    final address = await settings.get(AppSettingsService.keyCompanyAddress);
    if (mounted) {
      setState(() {
        _companyName = name ?? PrintConfig.companyName;
        _companyPhone = phone ?? PrintConfig.companyPhone;
        _companyAddress = address ?? PrintConfig.companyAddress;
        _loaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    final formatter = intl.NumberFormat('#,##0.##', 'fa_IR');

    String nameOf(String productId) {
      final p = data.products.where((x) => x.id == productId);
      return p.isEmpty ? productId : p.first.name;
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        insetPadding: const EdgeInsets.all(24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 760,
          height: 640,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${data.title} — ${data.invoiceNumber}',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'IranYekan')),
                  Row(children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E3A8A),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        Printing.layoutPdf(
                          onLayout: (_) => PdfService.buildInvoicePdf(data),
                        );
                      },
                      icon: const Icon(Icons.print, size: 18),
                      label: const Text('چاپ / PDF',
                          style: TextStyle(fontFamily: 'IranYekan')),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ]),
                ],
              ),
              const Divider(height: 20),

              Expanded(
                child: !_loaded
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(_companyName,
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF1E3A8A),
                                              fontFamily: 'IranYekan')),
                                      const SizedBox(height: 2),
                                      Text(_companyAddress,
                                          style: const TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey,
                                              fontFamily: 'IranYekan')),
                                      Text('تلفن: $_companyPhone',
                                          style: const TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey,
                                              fontFamily: 'IranYekan')),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1E3A8A),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(data.title,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'IranYekan')),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text('شماره: ${data.invoiceNumber}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'IranYekan')),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey.shade400),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('تاریخ: ${data.dateText}',
                                        style: const TextStyle(
                                            fontFamily: 'IranYekan')),
                                    Text(
                                        '${data.counterpartyLabel}: ${data.counterpartyName}',
                                        style: const TextStyle(
                                            fontFamily: 'IranYekan')),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              Table(
                                border: TableBorder.all(
                                    color: Colors.grey.shade300, width: 0.5),
                                columnWidths: const {
                                  0: FixedColumnWidth(40),
                                  2: FixedColumnWidth(80),
                                  3: FixedColumnWidth(100),
                                  4: FixedColumnWidth(110),
                                },
                                children: [
                                  TableRow(
                                    decoration:
                                        BoxDecoration(color: Color(0xFF1E3A8A)),
                                    children: [
                                      _cell('ردیف',
                                          bold: true, color: Colors.white),
                                      _cell('نام کالا',
                                          bold: true, color: Colors.white),
                                      _cell('تعداد',
                                          bold: true, color: Colors.white),
                                      _cell('فی',
                                          bold: true, color: Colors.white),
                                      _cell('جمع',
                                          bold: true, color: Colors.white),
                                    ],
                                  ),
                                  for (var i = 0; i < data.items.length; i++)
                                    TableRow(children: [
                                      _cell(formatter.format(i + 1)),
                                      _cell(nameOf(data.items[i].productId)),
                                      _cell(formatter
                                          .format(data.items[i].quantity)),
                                      _cell(formatter
                                          .format(data.items[i].unitPrice)),
                                      _cell(formatter
                                          .format(data.items[i].totalPrice)),
                                    ]),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  width: 240,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade400),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Column(children: [
                                    _totalRow(
                                        'مجموع اجناس:',
                                        formatter.format(
                                            data.total - data.sideCosts)),
                                    if (data.sideCosts > 0)
                                      _totalRow('هزینه‌های جانبی:',
                                          formatter.format(data.sideCosts)),
                                    const Divider(height: 12),
                                    _totalRow(
                                      'جمع کل:',
                                      '${formatter.format(data.total)} toman',
                                      bold: true,
                                    ),
                                  ]),
                                ),
                              ),
                              const SizedBox(height: 40),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _signature('امضای تحویل‌دهنده'),
                                  _signature('امضای گیرنده'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _cell(String text, {bool bold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12,
          fontFamily: 'IranYekan',
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          color: color,
        ),
      ),
    );
  }

  static Widget _totalRow(String label, String value, {bool bold = false}) {
    final style = TextStyle(
      fontSize: 12,
      fontFamily: 'IranYekan',
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label, style: style), Text(value, style: style)],
      ),
    );
  }

  static Widget _signature(String label) {
    return Column(children: [
      SizedBox(width: 140, height: 36),
      Container(
        width: 140,
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey.shade500)),
        ),
        padding: const EdgeInsets.only(top: 4),
        child: Center(
          child: Text(label,
              style: const TextStyle(fontSize: 11, fontFamily: 'IranYekan')),
        ),
      ),
    ]);
  }
}
