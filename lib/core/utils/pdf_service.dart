import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart' as intl;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../config/print_config.dart';
import '../../features/invoice/data/models/invoice_item_model.dart';
import '../../features/inventory/data/models/product_model.dart';
import '../di/injection.dart';
import 'app_settings_service.dart';

class InvoicePrintData {
  final String title;
  final String invoiceNumber;
  final String dateText;
  final String counterpartyLabel;
  final String counterpartyName;
  final List<InvoiceItemModel> items;
  final List<ProductModel> products;
  final double sideCosts;
  final double total;

  const InvoicePrintData({
    required this.title,
    required this.invoiceNumber,
    required this.dateText,
    required this.counterpartyLabel,
    required this.counterpartyName,
    required this.items,
    required this.products,
    this.sideCosts = 0,
    required this.total,
  });
}

class PdfService {
  static pw.Font? _font;

  static Future<pw.Font> _loadFont() async {
    _font ??= pw.Font.ttf(
      await rootBundle.load('assets/fonts/Qs_Iranyekan.ttf'),
    );
    return _font!;
  }

  static Future<Uint8List> buildInvoicePdf(InvoicePrintData data) async {
    final font = await _loadFont();

    final settings = sl<AppSettingsService>();
    final companyName = await settings.get(AppSettingsService.keyCompanyName) ??
        PrintConfig.companyName;
    final companyPhone =
        await settings.get(AppSettingsService.keyCompanyPhone) ??
            PrintConfig.companyPhone;
    final companyAddress =
        await settings.get(AppSettingsService.keyCompanyAddress) ??
            PrintConfig.companyAddress;

    final t = pw.TextStyle(font: font, fontSize: 10);
    final bold =
        pw.TextStyle(font: font, fontSize: 10, fontWeight: pw.FontWeight.bold);
    final formatter = intl.NumberFormat('#,##0.##', 'fa_IR');

    String nameOf(String productId) {
      final p = data.products.where((x) => x.id == productId);
      return p.isEmpty ? productId : p.first.name;
    }

    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => pw.Directionality(
          textDirection: pw.TextDirection.rtl,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(companyName,
                          style: pw.TextStyle(
                              font: font,
                              fontSize: 15,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.blue900)),
                      pw.SizedBox(height: 3),
                      pw.Text(companyAddress, style: t),
                      pw.Text('تلفن: $companyPhone', style: t),
                    ],
                  ),
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.blue900,
                      borderRadius: pw.BorderRadius.circular(6),
                    ),
                    child: pw.Text(data.title,
                        style: pw.TextStyle(
                            font: font,
                            fontSize: 14,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.white)),
                  ),
                ],
              ),
              pw.SizedBox(height: 12),

              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey400),
                  borderRadius: pw.BorderRadius.circular(6),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('شماره: ${data.invoiceNumber}', style: bold),
                    pw.Text('تاریخ: ${data.dateText}', style: t),
                    pw.Text(
                        '${data.counterpartyLabel}: ${data.counterpartyName}',
                        style: t),
                  ],
                ),
              ),
              pw.SizedBox(height: 12),

              pw.TableHelper.fromTextArray(
                headers: ['ردیف', 'نام کالا', 'تعداد', 'فی', 'جمع'],
                headerStyle: pw.TextStyle(
                    font: font,
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.white),
                headerDecoration:
                    const pw.BoxDecoration(color: PdfColors.blue900),
                cellStyle: t,
                cellAlignments: {
                  0: pw.Alignment.center,
                  2: pw.Alignment.center,
                  3: pw.Alignment.center,
                  4: pw.Alignment.center,
                },
                rowDecoration: const pw.BoxDecoration(
                    border: pw.Border(
                        bottom: pw.BorderSide(color: PdfColors.grey300))),
                data: [
                  for (var i = 0; i < data.items.length; i++)
                    [
                      formatter.format(i + 1),
                      nameOf(data.items[i].productId),
                      formatter.format(data.items[i].quantity),
                      formatter.format(data.items[i].unitPrice),
                      formatter.format(data.items[i].totalPrice),
                    ],
                ],
              ),
              pw.SizedBox(height: 12),

              pw.Align(
                alignment: pw.Alignment.centerLeft,
                child: pw.Container(
                  width: 220,
                  padding: const pw.EdgeInsets.all(10),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey400),
                    borderRadius: pw.BorderRadius.circular(6),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _totalRow('مجموع اجناس:',
                          formatter.format(data.total - data.sideCosts), t),
                      if (data.sideCosts > 0)
                        _totalRow('هزینه‌های جانبی:',
                            formatter.format(data.sideCosts), t),
                      pw.Divider(height: 8),
                      _totalRow(
                        'جمع کل:',
                        '${formatter.format(data.total)} تومان',
                        pw.TextStyle(
                            font: font,
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.blue900),
                      ),
                    ],
                  ),
                ),
              ),

              pw.Spacer(),

              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  _signatureBox('امضای تحویل‌دهنده', t),
                  _signatureBox('امضای گیرنده', t),
                ],
              ),
              pw.SizedBox(height: 12),

              pw.Divider(),
              pw.Center(
                child: pw.Text(
                  'این فاکتور به‌صورت سیستمی تولید شده و بدون مهر و امضا اعتبار ندارد.',
                  style: pw.TextStyle(
                      font: font, fontSize: 8, color: PdfColors.grey600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    return pdf.save();
  }

  static pw.Widget _totalRow(String label, String value, pw.TextStyle style) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: style),
          pw.Text(value, style: style),
        ],
      ),
    );
  }

  static pw.Widget _signatureBox(String label, pw.TextStyle t) {
    return pw.Column(children: [
      pw.Container(width: 130, height: 40),
      pw.Container(
        width: 130,
        decoration: const pw.BoxDecoration(
          border: pw.Border(top: pw.BorderSide(color: PdfColors.grey500)),
        ),
        padding: const pw.EdgeInsets.only(top: 4),
        child: pw.Center(child: pw.Text(label, style: t)),
      ),
    ]);
  }
}
