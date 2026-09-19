import 'package:eprwindowsapp/core/database/table_constants.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper {
  static const String _dbName = 'epr_accounting.db';
  static const int _dbVersion = 7;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<String> get currentDatabasePath async {
    final db = await database;
    return db.path;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'EPRAccounting', _dbName);

    return await databaseFactoryFfi.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: _dbVersion,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
        onConfigure: _onConfigure,
      ),
    );
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _onCreate(Database db, int version) async {
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

    await db.execute('''
      CREATE TABLE ${TableConstants.shipmentExpensesTable} (
        ${TableConstants.columnId} TEXT PRIMARY KEY,
        ${TableConstants.colShipmentId} TEXT NOT NULL,
        ${TableConstants.columnType} TEXT NOT NULL,
        ${TableConstants.columnAmount} REAL NOT NULL,
        ${TableConstants.colCurrency} TEXT NOT NULL,
        ${TableConstants.colOriginalAmount} REAL,
        ${TableConstants.colExchangeRate} REAL,
        ${TableConstants.colSourceAccount} TEXT,
        ${TableConstants.colPaidTo} TEXT,
        ${TableConstants.colReceiptNumber} TEXT,
        ${TableConstants.columnDetails} TEXT,
        ${TableConstants.columnDate} TEXT NOT NULL,
        FOREIGN KEY (${TableConstants.colShipmentId}) REFERENCES ${TableConstants.shipmentsTable} (${TableConstants.columnId}) ON DELETE CASCADE
      )
    ''');

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
// TODO: think about replacing referenceType/referenceId with real FK tables
// (one per type) so the db can actually check the ids instead of us
    await db.execute('''
      CREATE TABLE ${TableConstants.transactionsTable} (
        ${TableConstants.columnId} TEXT PRIMARY KEY,
        ${TableConstants.colTitle} TEXT NOT NULL,
        ${TableConstants.columnDetails} TEXT,
        ${TableConstants.columnAmount} REAL NOT NULL,
        ${TableConstants.colCurrency} TEXT DEFAULT 'toman',
        ${TableConstants.colOriginalAmount} REAL,
        ${TableConstants.colExchangeRate} REAL,
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

    await db.execute('''
      CREATE TABLE ${TableConstants.accountsTable} (
        ${TableConstants.columnId} TEXT PRIMARY KEY,
        ${TableConstants.colAccountName} TEXT NOT NULL,
        ${TableConstants.colAccountType} TEXT NOT NULL,
        ${TableConstants.colBalance} REAL DEFAULT 0.0,
        ${TableConstants.colCurrency} TEXT DEFAULT 'toman'
      )
    ''');

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

    await db.execute('''
      CREATE TABLE ${TableConstants.appSettingsTable} (
        ${TableConstants.colSettingKey} TEXT PRIMARY KEY,
        ${TableConstants.colSettingValue} TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE ${TableConstants.personalExpensesTable} (
        ${TableConstants.columnId} TEXT PRIMARY KEY,
        ${TableConstants.colItemName} TEXT NOT NULL,
        ${TableConstants.colCategory} TEXT,
        ${TableConstants.colQuantity} REAL DEFAULT 1.0,
        ${TableConstants.colUnitPrice} REAL DEFAULT 0.0,
        ${TableConstants.colTotalAmount} REAL NOT NULL,
        ${TableConstants.colOriginalAmount} REAL,
        ${TableConstants.colExchangeRate} REAL,
        ${TableConstants.columnDate} TEXT NOT NULL,
        ${TableConstants.colNotes} TEXT,
        ${TableConstants.colAccountId} TEXT,
        ${TableConstants.colAccountName} TEXT,
        ${TableConstants.colReceiptNumber} TEXT
      )
    ''');

    await db.execute(
        'CREATE INDEX idx_transactions_date ON ${TableConstants.transactionsTable}(${TableConstants.columnDate});');
    await db.execute(
        'CREATE INDEX idx_transactions_ref ON ${TableConstants.transactionsTable}(${TableConstants.colReferenceType}, ${TableConstants.colReferenceId});');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS ${TableConstants.accountsTable} (
          ${TableConstants.columnId} TEXT PRIMARY KEY,
          ${TableConstants.colAccountName} TEXT NOT NULL,
          ${TableConstants.colAccountType} TEXT NOT NULL,
          ${TableConstants.colBalance} REAL DEFAULT 0.0,
          ${TableConstants.colCurrency} TEXT DEFAULT 'toman'
        )
      ''');
      await db.execute('''
        CREATE TABLE IF NOT EXISTS ${TableConstants.invoicesTable} (
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
      await db.execute('''
        CREATE TABLE IF NOT EXISTS ${TableConstants.invoiceItemsTable} (
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
    }
    if (oldVersion < 4) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS ${TableConstants.appSettingsTable} (
          ${TableConstants.colSettingKey} TEXT PRIMARY KEY,
          ${TableConstants.colSettingValue} TEXT
        )
      ''');
    }
    if (oldVersion < 5) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS ${TableConstants.personalExpensesTable} (
          ${TableConstants.columnId} TEXT PRIMARY KEY,
          ${TableConstants.colItemName} TEXT NOT NULL,
          ${TableConstants.colCategory} TEXT,
          ${TableConstants.colQuantity} REAL DEFAULT 1.0,
          ${TableConstants.colUnitPrice} REAL DEFAULT 0.0,
          ${TableConstants.colTotalAmount} REAL NOT NULL,
          ${TableConstants.columnDate} TEXT NOT NULL,
          ${TableConstants.colNotes} TEXT,
          ${TableConstants.colAccountId} TEXT,
          ${TableConstants.colAccountName} TEXT
        )
      ''');
    }
    if (oldVersion < 6) {
      await db.execute(
        'ALTER TABLE ${TableConstants.personalExpensesTable} ADD COLUMN ${TableConstants.colReceiptNumber} TEXT',
      );
    }

    if (oldVersion < 7) {
      await db.execute(
        'ALTER TABLE ${TableConstants.transactionsTable} ADD COLUMN ${TableConstants.colOriginalAmount} REAL',
      );
      await db.execute(
        'ALTER TABLE ${TableConstants.transactionsTable} ADD COLUMN ${TableConstants.colExchangeRate} REAL',
      );
      await db.execute(
        'ALTER TABLE ${TableConstants.shipmentExpensesTable} ADD COLUMN ${TableConstants.colOriginalAmount} REAL',
      );
      await db.execute(
        'ALTER TABLE ${TableConstants.shipmentExpensesTable} ADD COLUMN ${TableConstants.colExchangeRate} REAL',
      );
      await db.execute(
        'ALTER TABLE ${TableConstants.personalExpensesTable} ADD COLUMN ${TableConstants.colOriginalAmount} REAL',
      );
      await db.execute(
        'ALTER TABLE ${TableConstants.personalExpensesTable} ADD COLUMN ${TableConstants.colExchangeRate} REAL',
      );
    }
  }

  void resetReference() {
    _database = null;
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
