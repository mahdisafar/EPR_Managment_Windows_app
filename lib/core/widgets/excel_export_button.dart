import 'dart:io';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import '../utils/excel_service.dart';

class ExcelExportButton extends StatelessWidget {
  final String fileName;
  final List<String> headers;
  final List<List<dynamic>> Function() rowsBuilder;

  const ExcelExportButton({
    super.key,
    required this.fileName,
    required this.headers,
    required this.rowsBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'خروجی Excel',
      icon: const Icon(Icons.file_download, color: Color(0xFF1E3A8A)),
      onPressed: () async {
        final rows = rowsBuilder();
        if (rows.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('داده‌ای برای خروجی نیست.',
                  style: TextStyle(fontFamily: 'IranYekan')),
              backgroundColor: Colors.orange,
            ),
          );
          return;
        }

        final location = await getSaveLocation(
          suggestedName: '$fileName.xlsx',
          acceptedTypeGroups: [
            const XTypeGroup(label: 'Excel', extensions: ['xlsx']),
          ],
        );
        if (location == null) return;

        try {
          final bytes = ExcelService.build(headers: headers, rows: rows);
          final file = File(location.path);
          await file.writeAsBytes(bytes);

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('ذخیره شد: ${file.path}',
                    style: const TextStyle(fontFamily: 'IranYekan')),
                backgroundColor: Colors.green,
              ),
            );
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('خطا در ذخیره: $e',
                    style: const TextStyle(fontFamily: 'IranYekan')),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      },
    );
  }
}
