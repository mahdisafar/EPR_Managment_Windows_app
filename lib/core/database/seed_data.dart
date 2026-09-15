import 'package:sqflite/sqflite.dart';
import 'database_helper.dart';
import 'table_constants.dart';

class SeedData {
  static const bool enabled = true;

  static Future<void> seedIfEmpty() async {
    if (!enabled) return;

    final db = await DatabaseHelper.instance.database;

    final customerCount = Sqflite.firstIntValue(await db.rawQuery(
          'SELECT COUNT(*) FROM ${TableConstants.customersTable}',
        )) ??
        0;

    if (customerCount > 0) return;

    await _seed(db);
  }

  static String _daysAgo(int days) =>
      DateTime.now().subtract(Duration(days: days)).toIso8601String();

  static Future<void> _seed(Database db) async {
    final batch = db.batch();

    final customers = [
      [
        'seed-cust-1',
        'C-1001',
        'احمد',
        'رحیمی',
        '09123456789',
        'تهران، بازار بزرگ',
        15000000.0,
        15000000.0
      ],
      [
        'seed-cust-2',
        'C-1002',
        'محمد',
        'کریمی',
        '09351234567',
        'مشهد، بازار رضا',
        0.0,
        0.0
      ],
      [
        'seed-cust-3',
        'C-1003',
        'عبدالله',
        'صادقی',
        '09198765432',
        'اصفهان',
        -5000000.0,
        -5000000.0
      ],
      [
        'seed-cust-4',
        'C-1004',
        'نجیب',
        'احمدی',
        '09213456789',
        'تبریز، بازار',
        25000000.0,
        25000000.0
      ],
      [
        'seed-cust-5',
        'C-1005',
        'فاطمه',
        'نظری',
        '09365432109',
        'تهران، چهارسو',
        8000000.0,
        8000000.0
      ],
    ];
    for (final c in customers) {
      batch.insert(TableConstants.customersTable, {
        TableConstants.columnId: c[0],
        TableConstants.colCustomerCode: c[1],
        TableConstants.colFirstName: c[2],
        TableConstants.colLastName: c[3],
        TableConstants.colPhone: c[4],
        TableConstants.colAddress: c[5],
        TableConstants.colInitialBalance: c[6],
        TableConstants.colCurrentBalance: c[7],
      });
    }

    final products = [
      ['seed-prod-1', 'پسته', 'kg', 500.0, 850000.0, 950000.0],
      ['seed-prod-2', 'پیاز', 'kg', 2000.0, 25000.0, 30000.0],
      ['seed-prod-3', 'زعفران', 'ser', 50.0, 12000000.0, 14000000.0],
      ['seed-prod-4', 'برنج', 'kg', 300.0, 110000.0, 130000.0],
      ['seed-prod-5', 'خرما', 'carton', 40.0, 1800000.0, 2000000.0],
    ];
    for (final p in products) {
      batch.insert(TableConstants.productsTable, {
        TableConstants.columnId: p[0],
        TableConstants.colProductName: p[1],
        TableConstants.colUnit: p[2],
        TableConstants.colCurrentStock: p[3],
        TableConstants.colPurchasePrice: p[4],
        TableConstants.colLandedCost: p[5],
      });
    }

    final accounts = [
      ['seed-acc-1', 'صندوق نقدی اصلی', 'cash', 500000000.0, 'toman'],
      ['seed-acc-2', 'حساب بانک', 'bank', 1200000000.0, 'toman'],
      ['seed-acc-3', 'باقیات مشتریان', 'payableReceivable', 0.0, 'toman'],
    ];
    for (final a in accounts) {
      batch.insert(TableConstants.accountsTable, {
        TableConstants.columnId: a[0],
        TableConstants.colAccountName: a[1],
        TableConstants.colAccountType: a[2],
        TableConstants.colBalance: a[3],
        TableConstants.colCurrency: a[4],
      });
    }

    final shipments = [
      [
        'seed-ship-1',
        'SH-1001',
        'ایران',
        'تبریز',
        'ترکیه',
        'وان',
        'inTransit',
        'ترانسپورت آراس',
        '24-365-IR',
        'رضا محمدی',
        'پسته و خشکبار',
        120,
        4800.0,
        850000000.0,
        _daysAgo(6),
        45000000.0
      ],
      [
        'seed-ship-2',
        'SH-1002',
        'ایران',
        'تهران',
        'ترکیه',
        'استانبول',
        'customs',
        'ترانسپورت سپاهان',
        '10-842-IR',
        'علی حسینی',
        'زعفران',
        15,
        75.0,
        240000000.0,
        _daysAgo(3),
        18000000.0
      ],
    ];
    for (final s in shipments) {
      batch.insert(TableConstants.shipmentsTable, {
        TableConstants.columnId: s[0],
        TableConstants.colShipmentNumber: s[1],
        TableConstants.colOriginCountry: s[2],
        TableConstants.colOriginCity: s[3],
        TableConstants.colDestinationCountry: s[4],
        TableConstants.colDestinationCity: s[5],
        TableConstants.colStatus: s[6],
        TableConstants.colTransportCompany: s[7],
        TableConstants.colTruckNumber: s[8],
        TableConstants.colDriverName: s[9],
        TableConstants.colCargoType: s[10],
        TableConstants.colPackageCount: s[11],
        TableConstants.colWeight: s[12],
        TableConstants.colCargoValue: s[13],
        TableConstants.colDispatchDate: s[14],
        TableConstants.colTotalCosts: s[15],
      });
    }

    final shipmentExpenses = [
      [
        'seed-shexp-1',
        'seed-ship-1',
        'transportFare',
        30000000.0,
        'toman',
        'seed-acc-1',
        'ترانسپورت آراس',
        'RCP-501',
        'کرایه حمل تبریز تا وان',
        _daysAgo(5)
      ],
      [
        'seed-shexp-2',
        'seed-ship-1',
        'borderFee',
        8000000.0,
        'toman',
        'seed-acc-1',
        'گمرک بازرگان',
        'RCP-502',
        'هزینه عبور مرزی',
        _daysAgo(5)
      ],
      [
        'seed-shexp-3',
        'seed-ship-2',
        'customsDuty',
        15000000.0,
        'toman',
        'seed-acc-2',
        'گمرک امیرکبیر',
        'RCP-503',
        'حقوق گمرکی',
        _daysAgo(2)
      ],
    ];
    for (final e in shipmentExpenses) {
      batch.insert(TableConstants.shipmentExpensesTable, {
        TableConstants.columnId: e[0],
        TableConstants.colShipmentId: e[1],
        TableConstants.columnType: e[2],
        TableConstants.columnAmount: e[3],
        TableConstants.colCurrency: e[4],
        TableConstants.colSourceAccount: e[5],
        TableConstants.colPaidTo: e[6],
        TableConstants.colReceiptNumber: e[7],
        TableConstants.columnDetails: e[8],
        TableConstants.columnDate: e[9],
      });
    }

    final invoices = [
      [
        'seed-inv-1',
        'INV-S-1001',
        'sale',
        'seed-cust-1',
        22000000.0,
        'فروش نسیه پسته',
        _daysAgo(5)
      ],
      [
        'seed-inv-2',
        'INV-S-1002',
        'sale',
        'seed-cust-4',
        7200000.0,
        'فروش نسیه پیاز و زعفران',
        _daysAgo(3)
      ],
      [
        'seed-inv-3',
        'INV-S-1003',
        'sale',
        'seed-cust-5',
        7500000.0,
        'فروش نسیه برنج',
        _daysAgo(1)
      ],
    ];
    for (final inv in invoices) {
      batch.insert(TableConstants.invoicesTable, {
        TableConstants.columnId: inv[0],
        TableConstants.colInvoiceNumber: inv[1],
        TableConstants.columnType: inv[2],
        TableConstants.colCustomerId: inv[3],
        TableConstants.colShipmentId: null,
        TableConstants.colTotalAmount: inv[4],
        TableConstants.columnDetails: inv[5],
        TableConstants.columnDate: inv[6],
      });
    }

    final invoiceItems = [
      [
        'seed-item-1',
        'seed-inv-1',
        'seed-prod-1',
        20.0,
        1100000.0,
        950000.0,
        22000000.0
      ],
      [
        'seed-item-2',
        'seed-inv-2',
        'seed-prod-2',
        100.0,
        40000.0,
        30000.0,
        4000000.0
      ],
      [
        'seed-item-3',
        'seed-inv-2',
        'seed-prod-3',
        2.0,
        1600000.0,
        14000000.0,
        3200000.0
      ],
      [
        'seed-item-4',
        'seed-inv-3',
        'seed-prod-4',
        50.0,
        150000.0,
        130000.0,
        7500000.0
      ],
    ];
    for (final item in invoiceItems) {
      batch.insert(TableConstants.invoiceItemsTable, {
        TableConstants.columnId: item[0],
        TableConstants.colInvoiceId: item[1],
        TableConstants.colProductId: item[2],
        TableConstants.colQuantity: item[3],
        TableConstants.colUnitPrice: item[4],
        TableConstants.colUnitLandedCost: item[5],
        TableConstants.colTotalPrice: item[6],
      });
    }

    final transactions = [
      [
        'seed-tx-1',
        'فروش نقد پسته',
        'ثبت سیستم بابت فروش کالا',
        45000000.0,
        'income',
        'inventory',
        'seed-inv-1',
        'INV-S-1001',
        'seed-acc-1',
        null,
        'seed-cust-1',
        20.0,
        1100000.0,
        5
      ],
      [
        'seed-tx-2',
        'فاکتور فروش شماره INV-S-1001',
        'ثبت سیستم بابت فروش کالا',
        22000000.0,
        'income',
        'inventory',
        'seed-inv-1',
        'INV-S-1001',
        'seed-cust-1',
        null,
        'seed-cust-1',
        20.0,
        1100000.0,
        5
      ],
      [
        'seed-tx-3',
        'کرایه کامیون حمل کالا',
        'کرایه حمل از بازار به انبار',
        8000000.0,
        'expense',
        'general',
        null,
        'RCP-601',
        'seed-acc-1',
        null,
        'راننده کامیون',
        null,
        null,
        4
      ],
      [
        'seed-tx-4',
        'فاکتور فروش شماره INV-S-1002',
        'ثبت سیستم بابت فروش کالا',
        7200000.0,
        'income',
        'inventory',
        'seed-inv-2',
        'INV-S-1002',
        'seed-cust-4',
        null,
        'seed-cust-4',
        null,
        null,
        3
      ],
      [
        'seed-tx-5',
        'مصرف دفتر و لوازم',
        'خرید دفتر، قلم و لوازم مصرفی',
        3500000.0,
        'expense',
        'general',
        null,
        'RCP-602',
        'seed-acc-1',
        null,
        'لوازم‌التحریر ایران',
        null,
        null,
        2
      ],
      [
        'seed-tx-6',
        'حقوق گمرک محموله SH-1002',
        'ثبت سیستم بابت ترانزیت',
        15000000.0,
        'expense',
        'shipment',
        'seed-ship-2',
        'RCP-503',
        'seed-acc-2',
        null,
        'گمرک امیرکبیر',
        null,
        null,
        2
      ],
      [
        'seed-tx-7',
        'فاکتور فروش شماره INV-S-1003',
        'ثبت سیستم بابت فروش کالا',
        7500000.0,
        'income',
        'inventory',
        'seed-inv-3',
        'INV-S-1003',
        'seed-cust-5',
        null,
        'seed-cust-5',
        null,
        null,
        1
      ],
      [
        'seed-tx-8',
        'دریافت رسید از مشتری',
        'رسید نقد از احمد رحیمی',
        10000000.0,
        'income',
        'customer',
        'seed-cust-1',
        'RCP-603',
        'seed-acc-1',
        null,
        'seed-cust-1',
        null,
        null,
        1
      ],
    ];
    for (final t in transactions) {
      batch.insert(TableConstants.transactionsTable, {
        TableConstants.columnId: t[0],
        TableConstants.colTitle: t[1],
        TableConstants.columnDetails: t[2],
        TableConstants.columnAmount: t[3],
        TableConstants.colCurrency: 'toman',
        TableConstants.columnType: t[4],
        TableConstants.colReferenceType: t[5],
        TableConstants.colReferenceId: t[6],
        TableConstants.colDocumentNumber: t[7],
        TableConstants.colSourceAccount: t[8],
        TableConstants.colDestinationAccount: t[9],
        TableConstants.colPaidToOrFrom: t[10],
        TableConstants.colQuantity: t[11],
        TableConstants.colUnitPrice: t[12],
        TableConstants.columnDate: _daysAgo(t[13] as int),
      });
    }

    await batch.commit(noResult: true);
  }
}
