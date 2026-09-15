import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// ایمپورت‌های پروژه
import 'package:eprwindowsapp/core/database/database_helper.dart';
import 'package:eprwindowsapp/core/database/table_constants.dart';
import 'package:eprwindowsapp/config/enum.dart';
import 'package:eprwindowsapp/core/models/transaction_model.dart';
import 'package:eprwindowsapp/core/data/datasources/transaction_local_data_source.dart';

import 'package:eprwindowsapp/features/customer/data/models/customer_model.dart';
import 'package:eprwindowsapp/features/customer/data/datasources/customer_local_data_source.dart';

import 'package:eprwindowsapp/features/shipment/data/models/shipment_model.dart';
import 'package:eprwindowsapp/features/shipment/data/models/shipment_expense_model.dart';
import 'package:eprwindowsapp/features/shipment/data/datasources/shipment_local_data_source.dart';

import 'package:eprwindowsapp/features/inventory/data/models/product_model.dart';
import 'package:eprwindowsapp/features/inventory/data/datasources/inventory_local_data_source.dart';

class TestDatabaseHelper implements DatabaseHelper {
  static Database? _testDb;

  @override
  Future<Database> get database async {
    if (_testDb != null && _testDb!.isOpen) return _testDb!;

    sqfliteFfiInit();
    _testDb = await databaseFactoryFfi.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
        version: 3, // ارتقا به نسخه ۳ برای هماهنگی با کل جداول
        onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
        onCreate: (db, version) async {
          // ۱. جدول مشتریان
          await db.execute('''
            CREATE TABLE ${TableConstants.customersTable} (
              ${TableConstants.columnId} TEXT PRIMARY KEY,
              ${TableConstants.colCustomerCode} TEXT UNIQUE NOT NULL,
              ${TableConstants.colFirstName} TEXT NOT NULL,
              ${TableConstants.colLastName} TEXT NOT NULL,
              ${TableConstants.colPhone} TEXT,
              ${TableConstants.colAddress} TEXT,
              ${TableConstants.colInitialBalance} REAL DEFAULT 0.0,
              ${TableConstants.colCurrentBalance} REAL DEFAULT 0.0
            )
          ''');

          // ۲. جدول محموله‌ها
          await db.execute('''
            CREATE TABLE ${TableConstants.shipmentsTable} (
              ${TableConstants.columnId} TEXT PRIMARY KEY,
              ${TableConstants.colShipmentNumber} TEXT UNIQUE NOT NULL,
              ${TableConstants.colOriginCountry} TEXT,
              ${TableConstants.colOriginCity} TEXT,
              ${TableConstants.colDestinationCountry} TEXT,
              ${TableConstants.colDestinationCity} TEXT,
              ${TableConstants.colStatus} TEXT NOT NULL,
              ${TableConstants.colTransportCompany} TEXT,
              ${TableConstants.colTruckNumber} TEXT,
              ${TableConstants.colDriverName} TEXT,
              ${TableConstants.colCargoType} TEXT,
              ${TableConstants.colPackageCount} INTEGER,
              ${TableConstants.colWeight} REAL,
              ${TableConstants.colCargoValue} REAL,
              ${TableConstants.colDispatchDate} TEXT,
              ${TableConstants.colTotalCosts} REAL DEFAULT 0.0
            )
          ''');

          // ۳. جدول مصارف گمرک
          await db.execute('''
            CREATE TABLE ${TableConstants.shipmentExpensesTable} (
              ${TableConstants.columnId} TEXT PRIMARY KEY,
              ${TableConstants.colShipmentId} TEXT NOT NULL,
              ${TableConstants.columnType} TEXT NOT NULL,
              ${TableConstants.columnAmount} REAL NOT NULL,
              ${TableConstants.colCurrency} TEXT NOT NULL,
              ${TableConstants.colSourceAccount} TEXT,
              ${TableConstants.colPaidTo} TEXT,
              ${TableConstants.colReceiptNumber} TEXT,
              ${TableConstants.columnDetails} TEXT,
              ${TableConstants.columnDate} TEXT NOT NULL,
              FOREIGN KEY (${TableConstants.colShipmentId}) REFERENCES ${TableConstants.shipmentsTable} (${TableConstants.columnId}) ON DELETE CASCADE
            )
          ''');

          // ۴. جدول انبار
          await db.execute('''
            CREATE TABLE ${TableConstants.productsTable} (
              ${TableConstants.columnId} TEXT PRIMARY KEY,
              ${TableConstants.colProductName} TEXT NOT NULL,
              ${TableConstants.colUnit} TEXT NOT NULL,
              ${TableConstants.colCurrentStock} REAL DEFAULT 0.0,
              ${TableConstants.colPurchasePrice} REAL DEFAULT 0.0,
              ${TableConstants.colLandedCost} REAL DEFAULT 0.0
            )
          ''');

          // ۵. جدول تراکنش‌ها
          await db.execute('''
            CREATE TABLE ${TableConstants.transactionsTable} (
              ${TableConstants.columnId} TEXT PRIMARY KEY,
              ${TableConstants.colTitle} TEXT NOT NULL,
              ${TableConstants.columnDetails} TEXT,
              ${TableConstants.columnAmount} REAL NOT NULL,
              ${TableConstants.colCurrency} TEXT DEFAULT 'toman',
              ${TableConstants.columnType} TEXT NOT NULL,
              ${TableConstants.colReferenceType} TEXT NOT NULL,
              ${TableConstants.colReferenceId} TEXT,
              ${TableConstants.colDocumentNumber} TEXT,
              ${TableConstants.colSourceAccount} TEXT,
              ${TableConstants.colDestinationAccount} TEXT,
              ${TableConstants.colPaidToOrFrom} TEXT,
              ${TableConstants.colQuantity} REAL,
              ${TableConstants.colUnitPrice} REAL,
              ${TableConstants.columnDate} TEXT NOT NULL
            )
          ''');

          // ۶. جدول حساب‌ها (جدید)
          await db.execute('''
            CREATE TABLE ${TableConstants.accountsTable} (
              ${TableConstants.columnId} TEXT PRIMARY KEY,
              ${TableConstants.colAccountName} TEXT NOT NULL,
              ${TableConstants.colAccountType} TEXT NOT NULL,
              ${TableConstants.colBalance} REAL DEFAULT 0.0,
              ${TableConstants.colCurrency} TEXT DEFAULT 'toman'
            )
          ''');

          // ۷. جدول فاکتورها (جدید)
          await db.execute('''
            CREATE TABLE ${TableConstants.invoicesTable} (
              ${TableConstants.columnId} TEXT PRIMARY KEY,
              ${TableConstants.colInvoiceNumber} TEXT UNIQUE NOT NULL,
              ${TableConstants.columnType} TEXT NOT NULL,
              ${TableConstants.colCustomerId} TEXT,
              ${TableConstants.colShipmentId} TEXT,
              ${TableConstants.colTotalAmount} REAL NOT NULL,
              ${TableConstants.columnDetails} TEXT,
              ${TableConstants.columnDate} TEXT NOT NULL,
              FOREIGN KEY (${TableConstants.colCustomerId}) REFERENCES ${TableConstants.customersTable} (${TableConstants.columnId}) ON DELETE SET NULL,
              FOREIGN KEY (${TableConstants.colShipmentId}) REFERENCES ${TableConstants.shipmentsTable} (${TableConstants.columnId}) ON DELETE SET NULL
            )
          ''');

          // ۸. جدول اقلام فاکتور (جدید)
          await db.execute('''
            CREATE TABLE ${TableConstants.invoiceItemsTable} (
              ${TableConstants.columnId} TEXT PRIMARY KEY,
              ${TableConstants.colInvoiceId} TEXT NOT NULL,
              ${TableConstants.colProductId} TEXT NOT NULL,
              ${TableConstants.colQuantity} REAL NOT NULL,
              ${TableConstants.colUnitPrice} REAL NOT NULL,
              ${TableConstants.colUnitLandedCost} REAL DEFAULT 0.0,
              ${TableConstants.colTotalPrice} REAL NOT NULL,
              FOREIGN KEY (${TableConstants.colInvoiceId}) REFERENCES ${TableConstants.invoicesTable} (${TableConstants.columnId}) ON DELETE CASCADE,
              FOREIGN KEY (${TableConstants.colProductId}) REFERENCES ${TableConstants.productsTable} (${TableConstants.columnId}) ON DELETE RESTRICT
            )
          ''');

          // ایندکس‌ها
          await db.execute(
              'CREATE INDEX idx_transactions_date ON ${TableConstants.transactionsTable}(${TableConstants.columnDate});');
          await db.execute(
              'CREATE INDEX idx_transactions_ref ON ${TableConstants.transactionsTable}(${TableConstants.colReferenceType}, ${TableConstants.colReferenceId});');
        },
      ),
    );
    return _testDb!;
  }

  @override
  Future<void> close() async {
    if (_testDb != null && _testDb!.isOpen) {
      await _testDb!.close();
      _testDb = null;
    }
  }

  @override
  // TODO: implement currentDatabasePath
  Future<String> get currentDatabasePath => throw UnimplementedError();

  @override
  void resetReference() {
    // TODO: implement resetReference
  }
}

void main() {
  late TestDatabaseHelper testDbHelper;
  late TransactionLocalDataSourceImpl transactionDS;
  late CustomerLocalDataSourceImpl customerDS;
  late ShipmentLocalDataSourceImpl shipmentDS;
  late InventoryLocalDataSourceImpl inventoryDS;

  setUp(() {
    testDbHelper = TestDatabaseHelper();
    transactionDS = TransactionLocalDataSourceImpl(dbHelper: testDbHelper);
    customerDS = CustomerLocalDataSourceImpl(dbHelper: testDbHelper);
    shipmentDS = ShipmentLocalDataSourceImpl(dbHelper: testDbHelper);
    inventoryDS = InventoryLocalDataSourceImpl(dbHelper: testDbHelper);
  });

  tearDown(() async {
    await testDbHelper.close();
  });

  test('تست جامع عملکردهای Data Sourceها و صحت محاسبات', () async {
    // ----------------------------------------------------
    // ۱. تست مشتریان
    // ----------------------------------------------------
    final customer = CustomerModel(
      id: 'c1',
      code: 'CUST-001',
      firstName: 'احمد',
      lastName: 'رضایی',
      phoneNumber: '0799000000',
      address: 'کابل',
      initialBalance: 1000.0,
      currentBalance: 1000.0,
    );
    await customerDS.insertCustomer(customer);

    await customerDS.updateCustomerBalance('c1', 500.0);
    final updatedCustomer = await customerDS.getCustomerById('c1');
    expect(updatedCustomer?.currentBalance, equals(1500.0));

    // ----------------------------------------------------
    // ۲. تست تراکنش‌ها (استفاده از ReferenceType)
    // ----------------------------------------------------
    final now = DateTime.now();
    await transactionDS.insertTransaction(TransactionModel(
      id: 't1',
      title: 'فروش پسته',
      amount: 2000.0,
      type: TransactionType.income,
      referenceType: ReferenceType.customer,
      referenceId: 'c1',
      date: now,
    ));

    await transactionDS.insertTransaction(TransactionModel(
      id: 't2',
      title: 'کرایه موتر',
      amount: 500.0,
      type: TransactionType.expense,
      referenceType: ReferenceType.shipment,
      referenceId: 's1',
      date: now,
    ));

    final summary = await transactionDS.getFinancialSummary();
    expect(summary['totalIncome'], equals(2000.0));
    expect(summary['totalExpense'], equals(500.0));
    expect(summary['netBalance'], equals(1500.0));

    // ----------------------------------------------------
    // ۳. تست محموله و مصارف گمرک (استفاده از ExpenseType و CurrencyType)
    // ----------------------------------------------------
    final shipment = ShipmentModel(
      id: 's1',
      shipmentNumber: 'SH-900',
      originCountry: 'افغانستان',
      originCity: 'کابل',
      destinationCountry: 'ایران',
      destinationCity: 'مشهد',
      dispatchDate: now,
      status: ShipmentStatus.registered,
      transportCompany: 'اتحاد',
      vehicleNumber: '4455',
      driverName: 'محمد',
      goodsType: 'پسته',
      packageCount: 100,
      weight: 2000.0,
      declaredValue: 50000.0,
      totalCustomsAndTransportCosts: 0.0,
    );
    await shipmentDS.insertShipment(shipment);

    await shipmentDS.insertShipmentExpense(ShipmentExpenseModel(
      id: 'e1',
      shipmentId: 's1',
      expenseType: ExpenseType.customsDuty,
      amount: 300.0,
      currency: CurrencyType.toman,
      sourceAccount: 'صندوق اصلی',
      paidTo: 'گمرک اسلام‌قلعه',
      date: now,
    ));

    await shipmentDS.insertShipmentExpense(ShipmentExpenseModel(
      id: 'e2',
      shipmentId: 's1',
      expenseType: ExpenseType.transportFare,
      amount: 200.0,
      currency: CurrencyType.toman,
      sourceAccount: 'صندوق اصلی',
      paidTo: 'راننده',
      date: now,
    ));

    final shipments = await shipmentDS.getShipments();
    expect(shipments.first.totalCustomsAndTransportCosts, equals(500.0));

    // ----------------------------------------------------
    // ۴. تست انبار
    // ----------------------------------------------------
    final product = ProductModel(
      id: 'p1',
      name: 'پسته ممتاز',
      unit: UnitType.kg,
      currentStock: 100.0,
      purchasePrice: 500.0,
      landedCost: 500.0,
    );
    await inventoryDS.insertProduct(product);

    await inventoryDS.updateStockAndLandedCost('p1', 50.0, 550.0);
    final updatedProduct = await inventoryDS.getProductById('p1');
    expect(updatedProduct?.currentStock, equals(150.0));
    expect(updatedProduct?.landedCost, equals(550.0));
  });
}
