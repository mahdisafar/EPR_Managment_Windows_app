import 'package:go_router/go_router.dart';
import '../../features/accounts/presentation/pages/accounts_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/customer/data/models/customer_model.dart';
import '../../features/customer/presentation/pages/customer_list_page.dart';
import '../../features/customer/presentation/pages/customer_statement_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/inventory/presentation/pages/inventory_page.dart';
import '../../features/invoice/presentation/pages/invoices_list_page.dart';
import '../../features/invoice/presentation/pages/purchase_invoice_page.dart';
import '../../features/invoice/presentation/pages/sale_invoice_page.dart';
import '../../features/ledger/presentation/pages/ledger_page.dart';
import '../../features/personal_expenses/presentation/pages/personal_expenses_page.dart';
import '../../features/reports/presentation/pages/reports_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/shipment/data/models/shipment_model.dart'
    show ShipmentModel;
import '../../features/shipment/presentation/pages/register_shipment_page.dart';
import '../../features/shipment/presentation/pages/shipment_detail_page.dart';
import '../../features/shipment/presentation/pages/shipments_page.dart';
import '../widgets/app_shell.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) =>
          AppShell(location: state.uri.path, child: child),
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const DashboardPage(),
        ),
        GoRoute(
          path: '/customers',
          builder: (context, state) => const CustomerListPage(),
        ),
        GoRoute(
          path: '/customers/statement',
          builder: (context, state) => CustomerStatementPage(
            customer: state.extra as CustomerModel,
          ),
        ),
        GoRoute(
          path: '/purchase-invoice',
          builder: (context, state) => const PurchaseInvoicePage(),
        ),
        GoRoute(
          path: '/invoices',
          builder: (context, state) => const InvoicesListPage(),
        ),
        GoRoute(
          path: '/reports',
          builder: (context, state) => const ReportsPage(),
        ),
        GoRoute(
          path: '/ledger',
          builder: (context, state) => const LedgerPage(),
        ),
        GoRoute(
          path: '/inventory',
          builder: (context, state) => const InventoryPage(),
        ),
        GoRoute(
          path: '/shipments',
          builder: (context, state) => const ShipmentsPage(),
        ),
        GoRoute(
          path: '/shipments/register',
          builder: (context, state) => const RegisterShipmentPage(),
        ),
        GoRoute(
          path: '/shipments/detail',
          builder: (context, state) =>
              ShipmentDetailPage(shipment: state.extra as ShipmentModel),
        ),
        GoRoute(
          path: '/accounts',
          builder: (context, state) => const AccountsPage(),
        ),
        GoRoute(
          path: '/sale-invoice',
          builder: (context, state) => const SaleInvoicePage(),
        ),
        GoRoute(
          path: '/personal-expenses',
          builder: (context, state) => const PersonalExpensesPage(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsPage(),
        ),
      ],
    ),
  ],
);
final loginRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const LoginPage()),
  ],
);
