import 'package:eprwindowsapp/core/widgets/demo_watermark.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../config/demo_config.dart';
import '../../features/accounts/presentation/bloc/accounts_bloc.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart'
    show AuthBloc, LogoutEvent;
import '../../features/customer/presentation/bloc/customer_bloc.dart';
import '../../features/customer/presentation/bloc/customer_statement_bloc.dart';
import '../../features/dashboard/presentation/bloc/dashboard_bloc.dart';
import '../../features/inventory/presentation/bloc/inventory_bloc.dart';
import '../../features/invoice/presentation/bloc/invoices_list_bloc.dart';
import '../../features/ledger/presentation/bloc/ledger_bloc.dart';
import '../../features/personal_expenses/presentation/bloc/personal_expenses_bloc.dart';
import '../../features/reports/presentation/bloc/reports_bloc.dart';
import '../../features/shipment/presentation/bloc/shipment_bloc.dart';
import '../di/injection.dart';

class AppShell extends StatelessWidget {
  final String location;
  final Widget child;

  const AppShell({super.key, required this.location, required this.child});

  static const _destinations = [
    (path: '/', icon: Icons.dashboard_outlined, label: 'داشبورد'),
    (path: '/customers', icon: Icons.people_alt_outlined, label: 'مشتریان'),
    (
      path: '/sale-invoice',
      icon: Icons.point_of_sale_outlined,
      label: 'فاکتور فروش'
    ),
    (
      path: '/purchase-invoice',
      icon: Icons.shopping_cart_outlined,
      label: 'فاکتور خرید'
    ),
    (path: '/invoices', icon: Icons.receipt_long_outlined, label: 'فاکتورها'),
    (path: '/inventory', icon: Icons.warehouse_outlined, label: 'انبار'),
    (
      path: '/shipments',
      icon: Icons.local_shipping_outlined,
      label: 'محموله‌ها'
    ),
    (path: '/reports', icon: Icons.bar_chart_outlined, label: 'گزارش‌ها'),
    (path: '/ledger', icon: Icons.menu_book_outlined, label: 'دفتر روزنامه'),
    (path: '/accounts', icon: Icons.account_balance_outlined, label: 'حساب‌ها'),
    (
      path: '/personal-expenses',
      icon: Icons.person_outline,
      label: 'مصارف شخصی'
    ),
    (path: '/settings', icon: Icons.settings_outlined, label: 'تنظیمات'),
  ];

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(children: [
            Icon(Icons.logout_rounded, color: Colors.red),
            SizedBox(width: 8),
            Text('خروج از حساب',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'IranYekan')),
          ]),
          content: const Text(
            'آیا مطمئن هستید که می‌خواهید از حساب خود خارج شوید؟',
            style: TextStyle(fontFamily: 'IranYekan', fontSize: 14),
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
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('بله، خارج شو',
                  style: TextStyle(fontFamily: 'IranYekan')),
            ),
          ],
        ),
      ),
    );
    if (confirmed == true && context.mounted) {
      context.read<AuthBloc>().add(LogoutEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<DashboardBloc>()),
        BlocProvider(create: (_) => sl<CustomerBloc>()),
        BlocProvider(create: (_) => sl<CustomerStatementBloc>()),
        BlocProvider(create: (_) => sl<LedgerBloc>()),
        BlocProvider(create: (_) => sl<ReportsBloc>()),
        BlocProvider(create: (_) => sl<InventoryBloc>()),
        BlocProvider(create: (_) => sl<ShipmentBloc>()),
        BlocProvider(create: (_) => sl<AccountsBloc>()),
        BlocProvider(create: (_) => sl<PersonalExpensesBloc>()),
        BlocProvider(create: (_) => sl<InvoicesListBloc>()),
      ],
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: const Color(0xFFF1F5F9),
          body: Column(
            children: [
              if (kIsDemo)
                Container(
                  width: double.infinity,
                  color: Colors.amber.shade100,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: const Center(
                    child: Text(
                      "این نسخه آزمایشی برای تست همه فیچرها طبق داک کافیه — نسخه کامل بعد توافق ارسال می‌شود",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                        fontFamily: 'IranYekan',
                      ),
                    ),
                  ),
                ),
              Expanded(
                child: Row(
                  children: [
                    _AppSidebar(
                      location: location,
                      destinations: _destinations,
                      onSelect: (index) {
                        final dest = _destinations[index];
                        if (dest.path == '/reports') {
                          if (!guardDemoFeature(context, 'گزارش‌ها')) return;
                        }
                        context.go(dest.path);
                      },
                      onLogout: () => _confirmLogout(context),
                    ),
                    Container(width: 1, color: Colors.grey.shade200),
                    Expanded(child: child),
                    const DemoWatermark(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppSidebar extends StatelessWidget {
  final String location;
  final List<({String path, IconData icon, String label})> destinations;
  final ValueChanged<int> onSelect;
  final VoidCallback onLogout;

  const _AppSidebar({
    required this.location,
    required this.destinations,
    required this.onSelect,
    required this.onLogout,
  });

  bool _isSelected(String path) =>
      path == '/' ? location == '/' : location.startsWith(path);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 230,
      color: Colors.white,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E3A8A), Color(0xFF2B4AA6)],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
            child: const Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.account_balance,
                      color: Colors.white, size: 22),
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ERP Accounting',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'IranYekan')),
                    Text('سامانه مدیریت مالی',
                        style: TextStyle(
                            fontSize: 11,
                            color: Colors.white70,
                            fontFamily: 'IranYekan')),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              itemCount: destinations.length,
              itemBuilder: (context, index) {
                final d = destinations[index];
                final selected = _isSelected(d.path);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    decoration: BoxDecoration(
                      color: selected
                          ? const Color(0xFF1E3A8A).withValues(alpha: 0.08)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: selected
                          ? Border.all(
                              color: const Color(0xFF1E3A8A)
                                  .withValues(alpha: 0.3))
                          : null,
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () => onSelect(index),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 11),
                        child: Row(
                          children: [
                            Icon(
                              d.icon,
                              size: 20,
                              color: selected
                                  ? const Color(0xFF1E3A8A)
                                  : Colors.grey.shade600,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                d.label,
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontFamily: 'IranYekan',
                                  fontWeight: selected
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                  color: selected
                                      ? const Color(0xFF1E3A8A)
                                      : Colors.grey.shade700,
                                ),
                              ),
                            ),
                            if (selected)
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF1E3A8A),
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(10),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: onLogout,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.red.shade100),
                ),
                child: Row(
                  children: [
                    Icon(Icons.logout_rounded,
                        size: 18, color: Colors.red.shade700),
                    const SizedBox(width: 10),
                    Text('خروج از حساب',
                        style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.bold,
                            color: Colors.red.shade700,
                            fontFamily: 'IranYekan')),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
