import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:eprwindowsapp/core/di/injection.dart';
import 'package:eprwindowsapp/core/utils/app_settings_service.dart';
import 'package:eprwindowsapp/core/utils/backup_service.dart';
import 'package:eprwindowsapp/core/widgets/app_card.dart';
import 'package:eprwindowsapp/core/widgets/exchange_rates_dialog.dart';
import 'package:eprwindowsapp/features/auth/presentation/widgets/change_password_dialog.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _settings = sl<AppSettingsService>();
  final _backup = sl<BackupService>();

  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    _nameCtrl.text =
        await _settings.get(AppSettingsService.keyCompanyName) ?? '';
    _phoneCtrl.text =
        await _settings.get(AppSettingsService.keyCompanyPhone) ?? '';
    _addressCtrl.text =
        await _settings.get(AppSettingsService.keyCompanyAddress) ?? '';
    if (mounted) setState(() => _loading = false);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveCompanyInfo() async {
    await _settings.set(
        AppSettingsService.keyCompanyName, _nameCtrl.text.trim());
    await _settings.set(
        AppSettingsService.keyCompanyPhone, _phoneCtrl.text.trim());
    await _settings.set(
        AppSettingsService.keyCompanyAddress, _addressCtrl.text.trim());
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('اطلاعات شرکت ذخیره شد.',
              style: TextStyle(fontFamily: 'IranYekan')),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _createBackup() async {
    final now = DateTime.now();
    final suggested =
        'backup_${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}.db';
    final location = await getSaveLocation(
      suggestedName: suggested,
      acceptedTypeGroups: [
        const XTypeGroup(label: 'Database', extensions: ['db'])
      ],
    );
    if (location == null) return;
    try {
      final path = await _backup.backupTo(location.path);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('پشتیبان در این مسیر ذخیره شد:\n$path',
                style: const TextStyle(fontFamily: 'IranYekan')),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطا در بکاپ: $e',
                style: const TextStyle(fontFamily: 'IranYekan')),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _restoreBackup() async {
    final file = await openFile(
      acceptedTypeGroups: [
        const XTypeGroup(label: 'Database', extensions: ['db'])
      ],
    );
    if (file == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red),
            SizedBox(width: 8),
            Text('بازیابی پشتیبان',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'IranYekan')),
          ]),
          content: const Text(
            'بازیابی، تمام داده‌های فعلی را با فایل پشتیبان جایگزین می‌کند.\n\n⚠️ داده‌های فعلی برای همیشه از بین می‌روند. آیا مطمئن هستید؟',
            style: TextStyle(fontFamily: 'IranYekan', fontSize: 13),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('انصراف',
                  style:
                      TextStyle(color: Colors.grey, fontFamily: 'IranYekan')),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, foregroundColor: Colors.white),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('بله، بازیابی کن',
                  style: TextStyle(fontFamily: 'IranYekan')),
            ),
          ],
        ),
      ),
    );
    if (confirmed != true) return;

    try {
      await _backup.restoreFrom(file.path);
      if (mounted) {
        await showDialog(
          context: context,
          builder: (dialogContext) => Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              title: const Text('بازیابی انجام شد',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontFamily: 'IranYekan')),
              content: const Text(
                'دیتابیس با موفقیت جایگزین شد.\nاپ بسته می‌شود — لطفاً دوباره آن را باز کنید.',
                style: TextStyle(fontFamily: 'IranYekan'),
              ),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E3A8A),
                      foregroundColor: Colors.white),
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('متوجه شدم',
                      style: TextStyle(fontFamily: 'IranYekan')),
                ),
              ],
            ),
          ),
        );
        if (mounted) SystemNavigatorPopWrapper.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطا در بازیابی: $e',
                style: const TextStyle(fontFamily: 'IranYekan')),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('تنظیمات',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'IranYekan')),
                  const SizedBox(height: 4),
                  const Text('اطلاعات شرکت، نرخ ارز، پشتیبان‌گیری و امنیت',
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                          fontFamily: 'IranYekan')),
                  const SizedBox(height: 20),

                  AppCard(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('اطلاعات شرکت (سربرگ فاکتور)',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'IranYekan')),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _nameCtrl,
                          decoration: const InputDecoration(
                            labelText: 'نام شرکت',
                            labelStyle: TextStyle(fontFamily: 'IranYekan'),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(children: [
                          Expanded(
                            child: TextField(
                              controller: _phoneCtrl,
                              decoration: const InputDecoration(
                                labelText: 'تلفن',
                                labelStyle: TextStyle(fontFamily: 'IranYekan'),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: TextField(
                              controller: _addressCtrl,
                              decoration: const InputDecoration(
                                labelText: 'آدرس',
                                labelStyle: TextStyle(fontFamily: 'IranYekan'),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ]),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E3A8A),
                            foregroundColor: Colors.white,
                          ),
                          onPressed: _saveCompanyInfo,
                          icon: const Icon(Icons.save, size: 18),
                          label: const Text('ذخیره اطلاعات شرکت',
                              style: TextStyle(fontFamily: 'IranYekan')),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  AppCard(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('نرخ ارز',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'IranYekan')),
                              SizedBox(height: 4),
                              Text(
                                  'تنظیم نرخ تبدیل دلار، یورو، کلدار و تومان به تومان',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                      fontFamily: 'IranYekan')),
                            ]),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E3A8A),
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (_) => const ExchangeRatesDialog());
                          },
                          icon: const Icon(Icons.currency_exchange, size: 18),
                          label: const Text('تنظیم نرخ‌ها',
                              style: TextStyle(fontFamily: 'IranYekan')),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  AppCard(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('پشتیبان‌گیری و بازیابی',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'IranYekan')),
                        const SizedBox(height: 4),
                        const Text(
                            'یک نسخه از کل دیتابیس (همه اطلاعات) ذخیره یا بازیابی کنید',
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                                fontFamily: 'IranYekan')),
                        const SizedBox(height: 12),
                        Row(children: [
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                            ),
                            onPressed: _createBackup,
                            icon: const Icon(Icons.backup, size: 18),
                            label: const Text('ایجاد پشتیبان',
                                style: TextStyle(fontFamily: 'IranYekan')),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange.shade700,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                            ),
                            onPressed: _restoreBackup,
                            icon: const Icon(Icons.restore, size: 18),
                            label: const Text('بازیابی پشتیبان',
                                style: TextStyle(fontFamily: 'IranYekan')),
                          ),
                        ]),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  AppCard(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('امنیت',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'IranYekan')),
                              SizedBox(height: 4),
                              Text('رمز عبور ورود به سیستم',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                      fontFamily: 'IranYekan')),
                            ]),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E3A8A),
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (_) => const ChangePasswordDialog());
                          },
                          icon: const Icon(Icons.lock_reset, size: 18),
                          label: const Text('تغییر رمز عبور',
                              style: TextStyle(fontFamily: 'IranYekan')),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SystemNavigatorPopWrapper {
  static void pop() {
    Navigator.of(FocusManager.instance.primaryFocus!.context!).pop();
  }
}
