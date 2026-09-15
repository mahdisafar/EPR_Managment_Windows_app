import 'dart:typed_data';
import 'package:excel/excel.dart';

class ExcelService {
  static Uint8List build({
    required List<String> headers,
    required List<List<dynamic>> rows,
  }) {
    final excel = Excel.createExcel();

    final defaultSheet = excel.getDefaultSheet();
    if (defaultSheet != null) {
      excel.rename(defaultSheet, 'گزارش');
    }
    final sheet = excel['گزارش'];

    CellValue? cell(dynamic v) {
      if (v == null) return null;
      if (v is int) return IntCellValue(v);
      if (v is double) return DoubleCellValue(v);
      if (v is num) return DoubleCellValue(v.toDouble());
      return TextCellValue(v.toString());
    }

    sheet.appendRow(headers.map(cell).toList());
    for (final row in rows) {
      sheet.appendRow(row.map(cell).toList());
    }

    return Uint8List.fromList(excel.encode()!);
  }
}
