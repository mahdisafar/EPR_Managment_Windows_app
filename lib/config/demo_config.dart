import 'package:flutter/material.dart';

/// flutter build windows --release --dart-define=IS_DEMO=true
const bool kIsDemo = bool.fromEnvironment('IS_DEMO', defaultValue: false);

bool guardDemoFeature(BuildContext context, String featureName) {
  if (!kIsDemo) return true;
  showDialog(
    context: context,
    builder: (dialogContext) => Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(children: [
          Icon(Icons.lock_outline, color: Color(0xFF1E3A8A)),
          SizedBox(width: 8),
          Text('نسخه آزمایشی',
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'IranYekan')),
        ]),
        content: Text(
          featureName == 'گزارش‌ها'
              ? 'این بخش پس از تسویه‌حساب نهایی فعال می‌شه برای چک کردن محاسبات می‌تونی از دفتر روزنامه استفاده کنی'
              : 'این بخش پس از تسویه‌حساب نهایی فعال می‌شه',
          style: const TextStyle(fontFamily: 'IranYekan', fontSize: 13),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E3A8A),
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('متوجه شدم',
                style: TextStyle(fontFamily: 'IranYekan')),
          ),
        ],
      ),
    ),
  );
  return false;
}
