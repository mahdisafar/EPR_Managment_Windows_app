// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/accounts/domain/usecases/add_accountusecase.dart'
    as _i989;
import '../../features/accounts/domain/usecases/get_all_accounts_usecase.dart'
    as _i843;
import '../../features/accounts/presentation/bloc/accounts_bloc.dart' as _i103;
import '../../features/auth/domain/usecases/change_password_usecase.dart'
    as _i788;
import '../../features/auth/domain/usecases/login_usecase.dart' as _i188;
import '../../features/auth/presentation/bloc/auth_bloc.dart' as _i797;
import '../../features/customer/data/datasources/customer_local_data_source.dart'
    as _i253;
import '../../features/customer/data/repositories/customer_repository_impl.dart'
    as _i592;
import '../../features/customer/domain/repositories/customer_repository.dart'
    as _i547;
import '../../features/customer/domain/usecases/add_customer_usecase.dart'
    as _i379;
import '../../features/customer/domain/usecases/get_customer_statement_usecase.dart'
    as _i256;
import '../../features/customer/domain/usecases/record_customer_payment_usecase.dart'
    as _i985;
import '../../features/customer/presentation/bloc/customer_bloc.dart' as _i897;
import '../../features/customer/presentation/bloc/customer_statement_bloc.dart'
    as _i772;
import '../../features/dashboard/domain/usecases/get_financial_summary_usecase.dart'
    as _i460;
import '../../features/dashboard/presentation/bloc/dashboard_bloc.dart'
    as _i652;
import '../../features/inventory/data/datasources/inventory_local_data_source.dart'
    as _i509;
import '../../features/inventory/data/repositories/inventory_repository_impl.dart'
    as _i572;
import '../../features/inventory/domain/repositories/inventory_repository.dart'
    as _i422;
import '../../features/inventory/domain/usecases/add_product_usecase.dart'
    as _i234;
import '../../features/inventory/domain/usecases/get_all_products_usecase.dart'
    as _i590;
import '../../features/inventory/presentation/bloc/inventory_bloc.dart'
    as _i690;
import '../../features/invoice/data/datasources/invoice_local_data_source.dart'
    as _i375;
import '../../features/invoice/data/repositories/invoice_repository_impl.dart'
    as _i205;
import '../../features/invoice/domain/repositories/invoice_repository.dart'
    as _i339;
import '../../features/invoice/domain/usecases/calculate_landed_cost_use_case.dart'
    as _i357;
import '../../features/invoice/domain/usecases/process_purchase_invoice_use_case.dart'
    as _i974;
import '../../features/invoice/domain/usecases/process_sale_invoice_use_case.dart'
    as _i320;
import '../../features/invoice/presentation/bloc/invoice_bloc.dart' as _i269;
import '../../features/invoice/presentation/bloc/invoices_list_bloc.dart'
    as _i543;
import '../../features/ledger/domain/usecases/get_general_ledger_usecase.dart'
    as _i787;
import '../../features/ledger/presentation/bloc/ledger_bloc.dart' as _i1062;
import '../../features/personal_expenses/data/datasources/personal_expense_local_data_source.dart'
    as _i685;
import '../../features/personal_expenses/data/repositories/personal_expense_repository_impl.dart'
    as _i297;
import '../../features/personal_expenses/domain/repositories/personal_expense_repository.dart'
    as _i201;
import '../../features/personal_expenses/domain/usecases/add_personal_expense_usecase.dart'
    as _i117;
import '../../features/personal_expenses/domain/usecases/get_personal_expenses_usecase.dart'
    as _i82;
import '../../features/personal_expenses/presentation/bloc/personal_expenses_bloc.dart'
    as _i420;
import '../../features/reports/domain/usecases/get_profit_and_loss_use_case.dart'
    as _i1054;
import '../../features/reports/presentation/bloc/reports_bloc.dart' as _i554;
import '../../features/shipment/data/datasources/shipment_local_data_source.dart'
    as _i967;
import '../../features/shipment/data/repositories/shipment_repository_impl.dart'
    as _i729;
import '../../features/shipment/domain/repositories/shipment_repository.dart'
    as _i248;
import '../../features/shipment/domain/usecases/add_shipment_expense_usecase.dart'
    as _i1025;
import '../../features/shipment/domain/usecases/get_shipment_expenses_usecase.dart'
    as _i152;
import '../../features/shipment/domain/usecases/get_shipments_usecase.dart'
    as _i190;
import '../../features/shipment/domain/usecases/register_shipment_usecase.dart'
    as _i270;
import '../../features/shipment/domain/usecases/update_shipment_status_usecase.dart'
    as _i988;
import '../../features/shipment/presentation/bloc/shipment_bloc.dart' as _i883;
import '../data/datasources/transaction_local_data_source.dart' as _i1008;
import '../data/repositories/account_repository_impl.dart' as _i870;
import '../data/repositories/auth_repository_impl.dart' as _i74;
import '../data/repositories/transaction_repository_impl.dart' as _i114;
import '../database/auth_local_data_source.dart' as _i33;
import '../database/database_helper.dart' as _i64;
import '../domain/repositories/account_repository.dart' as _i64;
import '../domain/repositories/auth_repository.dart' as _i800;
import '../domain/repositories/transaction_repository.dart' as _i118;
import '../domain/usecase/add_transaction_usecase.dart' as _i242;
import '../domain/usecase/get_all_accounts_usecase.dart' as _i232;
import '../domain/usecase/get_all_customers_use_case.dart' as _i74;
import '../domain/usecase/get_all_invoices_usecase.dart' as _i235;
import '../domain/usecase/get_all_products_use_case.dart' as _i867;
import '../domain/usecase/get_all_shipments_usecase.dart' as _i693;
import '../domain/usecase/get_all_transactions_usecase.dart' as _i540;
import '../domain/usecase/get_shipment_expenses_usecase.dart' as _i1043;
import '../domain/usecase/record_account_transaction_use_case.dart' as _i176;
import '../utils/app_settings_service.dart' as _i659;
import '../utils/backup_service.dart' as _i847;
import '../utils/exchange_rate_service.dart' as _i199;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.lazySingleton<_i357.CalculateLandedCostUseCase>(
        () => _i357.CalculateLandedCostUseCase());
    gh.lazySingleton<_i967.ShipmentLocalDataSource>(() =>
        _i967.ShipmentLocalDataSourceImpl(dbHelper: gh<_i64.DatabaseHelper>()));
    gh.lazySingleton<_i685.PersonalExpenseLocalDataSource>(() =>
        _i685.PersonalExpenseLocalDataSourceImpl(
            dbHelper: gh<_i64.DatabaseHelper>()));
    gh.lazySingleton<_i659.AppSettingsService>(
        () => _i659.AppSettingsService(dbHelper: gh<_i64.DatabaseHelper>()));
    gh.lazySingleton<_i847.BackupService>(
        () => _i847.BackupService(dbHelper: gh<_i64.DatabaseHelper>()));
    gh.lazySingleton<_i199.ExchangeRateService>(
        () => _i199.ExchangeRateService(dbHelper: gh<_i64.DatabaseHelper>()));
    gh.lazySingleton<_i201.PersonalExpenseRepository>(() =>
        _i297.PersonalExpenseRepositoryImpl(
            localDataSource: gh<_i685.PersonalExpenseLocalDataSource>()));
    gh.lazySingleton<_i33.AuthLocalDataSource>(() =>
        _i33.AuthLocalDataSourceImpl(dbHelper: gh<_i64.DatabaseHelper>()));
    gh.lazySingleton<_i1008.TransactionLocalDataSource>(() =>
        _i1008.TransactionLocalDataSourceImpl(
            dbHelper: gh<_i64.DatabaseHelper>()));
    gh.lazySingleton<_i248.ShipmentRepository>(() =>
        _i729.ShipmentRepositoryImpl(
            localDataSource: gh<_i967.ShipmentLocalDataSource>()));
    gh.lazySingleton<_i375.InvoiceLocalDataSource>(() =>
        _i375.InvoiceLocalDataSourceImpl(
            databaseHelper: gh<_i64.DatabaseHelper>()));
    gh.lazySingleton<_i800.AuthRepository>(() => _i74.AuthRepositoryImpl(
        localDataSource: gh<_i33.AuthLocalDataSource>()));
    gh.lazySingleton<_i253.CustomerLocalDataSource>(() =>
        _i253.CustomerLocalDataSourceImpl(dbHelper: gh<_i64.DatabaseHelper>()));
    gh.lazySingleton<_i509.InventoryLocalDataSource>(() =>
        _i509.InventoryLocalDataSourceImpl(
            dbHelper: gh<_i64.DatabaseHelper>()));
    gh.lazySingleton<_i118.TransactionRepository>(() =>
        _i114.TransactionRepositoryImpl(
            localDataSource: gh<_i1008.TransactionLocalDataSource>()));
    gh.lazySingleton<_i788.ChangePasswordUseCase>(
        () => _i788.ChangePasswordUseCase(gh<_i800.AuthRepository>()));
    gh.lazySingleton<_i188.LoginUseCase>(
        () => _i188.LoginUseCase(gh<_i800.AuthRepository>()));
    gh.lazySingleton<_i64.AccountRepository>(
        () => _i870.AccountRepositoryImpl(dbHelper: gh<_i64.DatabaseHelper>()));
    gh.lazySingleton<_i339.InvoiceRepository>(() => _i205.InvoiceRepositoryImpl(
        localDataSource: gh<_i375.InvoiceLocalDataSource>()));
    gh.lazySingleton<_i232.GetAllAccountsUseCase>(
        () => _i232.GetAllAccountsUseCase(gh<_i64.AccountRepository>()));
    gh.lazySingleton<_i989.AddAccountUseCase>(
        () => _i989.AddAccountUseCase(gh<_i64.AccountRepository>()));
    gh.lazySingleton<_i843.GetAllAccountsUseCase>(
        () => _i843.GetAllAccountsUseCase(gh<_i64.AccountRepository>()));
    gh.factory<_i797.AuthBloc>(() => _i797.AuthBloc(
          loginUseCase: gh<_i188.LoginUseCase>(),
          changePasswordUseCase: gh<_i788.ChangePasswordUseCase>(),
        ));
    gh.lazySingleton<_i1025.AddShipmentExpenseUseCase>(
        () => _i1025.AddShipmentExpenseUseCase(
              gh<_i248.ShipmentRepository>(),
              accountRepository: gh<_i64.AccountRepository>(),
              transactionRepository: gh<_i118.TransactionRepository>(),
            ));
    gh.lazySingleton<_i693.GetAllShipmentsUseCase>(
        () => _i693.GetAllShipmentsUseCase(gh<_i248.ShipmentRepository>()));
    gh.lazySingleton<_i1043.GetShipmentExpensesUseCase>(() =>
        _i1043.GetShipmentExpensesUseCase(gh<_i248.ShipmentRepository>()));
    gh.lazySingleton<_i152.GetShipmentExpensesUseCase>(
        () => _i152.GetShipmentExpensesUseCase(gh<_i248.ShipmentRepository>()));
    gh.lazySingleton<_i190.GetShipmentsUseCase>(
        () => _i190.GetShipmentsUseCase(gh<_i248.ShipmentRepository>()));
    gh.lazySingleton<_i270.RegisterShipmentUseCase>(
        () => _i270.RegisterShipmentUseCase(gh<_i248.ShipmentRepository>()));
    gh.lazySingleton<_i988.UpdateShipmentStatusUseCase>(() =>
        _i988.UpdateShipmentStatusUseCase(gh<_i248.ShipmentRepository>()));
    gh.lazySingleton<_i422.InventoryRepository>(() =>
        _i572.InventoryRepositoryImpl(
            localDataSource: gh<_i509.InventoryLocalDataSource>()));
    gh.lazySingleton<_i974.ProcessPurchaseInvoiceUseCase>(() =>
        _i974.ProcessPurchaseInvoiceUseCase(
          invoiceRepository: gh<_i339.InvoiceRepository>(),
          accountRepository: gh<_i64.AccountRepository>(),
          inventoryRepository: gh<_i422.InventoryRepository>(),
          transactionRepository: gh<_i118.TransactionRepository>(),
          calculateLandedCostUseCase: gh<_i357.CalculateLandedCostUseCase>(),
        ));
    gh.lazySingleton<_i82.GetPersonalExpensesUseCase>(() =>
        _i82.GetPersonalExpensesUseCase(gh<_i201.PersonalExpenseRepository>()));
    gh.lazySingleton<_i235.GetAllInvoicesUseCase>(
        () => _i235.GetAllInvoicesUseCase(gh<_i339.InvoiceRepository>()));
    gh.lazySingleton<_i242.AddTransactionUseCase>(
        () => _i242.AddTransactionUseCase(gh<_i118.TransactionRepository>()));
    gh.lazySingleton<_i540.GetAllTransactionsUseCase>(() =>
        _i540.GetAllTransactionsUseCase(gh<_i118.TransactionRepository>()));
    gh.lazySingleton<_i460.GetFinancialSummaryUseCase>(() =>
        _i460.GetFinancialSummaryUseCase(gh<_i118.TransactionRepository>()));
    gh.lazySingleton<_i787.GetGeneralLedgerUseCase>(
        () => _i787.GetGeneralLedgerUseCase(gh<_i118.TransactionRepository>()));
    gh.lazySingleton<_i547.CustomerRepository>(() =>
        _i592.CustomerRepositoryImpl(
          localDataSource: gh<_i253.CustomerLocalDataSource>(),
          invoiceLocalDataSource: gh<_i375.InvoiceLocalDataSource>(),
          transactionLocalDataSource: gh<_i1008.TransactionLocalDataSource>(),
        ));
    gh.lazySingleton<_i117.AddPersonalExpenseUseCase>(
        () => _i117.AddPersonalExpenseUseCase(
              personalExpenseRepository: gh<_i201.PersonalExpenseRepository>(),
              accountRepository: gh<_i64.AccountRepository>(),
              transactionRepository: gh<_i118.TransactionRepository>(),
            ));
    gh.lazySingleton<_i1054.GetProfitAndLossUseCase>(
        () => _i1054.GetProfitAndLossUseCase(
              invoiceRepository: gh<_i339.InvoiceRepository>(),
              inventoryRepository: gh<_i422.InventoryRepository>(),
              transactionRepository: gh<_i118.TransactionRepository>(),
            ));
    gh.factory<_i883.ShipmentBloc>(() => _i883.ShipmentBloc(
          getShipmentsUseCase: gh<_i190.GetShipmentsUseCase>(),
          registerShipmentUseCase: gh<_i270.RegisterShipmentUseCase>(),
          updateShipmentStatusUseCase: gh<_i988.UpdateShipmentStatusUseCase>(),
          getShipmentExpensesUseCase: gh<_i152.GetShipmentExpensesUseCase>(),
          addShipmentExpenseUseCase: gh<_i1025.AddShipmentExpenseUseCase>(),
          getAllAccountsUseCase: gh<_i232.GetAllAccountsUseCase>(),
        ));
    gh.lazySingleton<_i867.GetAllProductsUseCase>(
        () => _i867.GetAllProductsUseCase(gh<_i422.InventoryRepository>()));
    gh.lazySingleton<_i234.AddProductUseCase>(
        () => _i234.AddProductUseCase(gh<_i422.InventoryRepository>()));
    gh.lazySingleton<_i590.GetAllProductsUseCase>(
        () => _i590.GetAllProductsUseCase(gh<_i422.InventoryRepository>()));
    gh.factory<_i1062.LedgerBloc>(() => _i1062.LedgerBloc(
        getGeneralLedgerUseCase: gh<_i787.GetGeneralLedgerUseCase>()));
    gh.lazySingleton<_i74.GetAllCustomersUseCase>(
        () => _i74.GetAllCustomersUseCase(gh<_i547.CustomerRepository>()));
    gh.lazySingleton<_i379.AddCustomerUseCase>(
        () => _i379.AddCustomerUseCase(gh<_i547.CustomerRepository>()));
    gh.lazySingleton<_i256.GetCustomerStatementUseCase>(() =>
        _i256.GetCustomerStatementUseCase(gh<_i547.CustomerRepository>()));
    gh.lazySingleton<_i985.RecordCustomerPaymentUseCase>(() =>
        _i985.RecordCustomerPaymentUseCase(gh<_i547.CustomerRepository>()));
    gh.factory<_i554.ReportsBloc>(() => _i554.ReportsBloc(
          getProfitAndLossUseCase: gh<_i1054.GetProfitAndLossUseCase>(),
          getFinancialSummaryUseCase: gh<_i460.GetFinancialSummaryUseCase>(),
          getAllCustomersUseCase: gh<_i74.GetAllCustomersUseCase>(),
          getAllInvoicesUseCase: gh<_i235.GetAllInvoicesUseCase>(),
          getAllShipmentsUseCase: gh<_i693.GetAllShipmentsUseCase>(),
          getShipmentExpensesUseCase: gh<_i1043.GetShipmentExpensesUseCase>(),
        ));
    gh.lazySingleton<_i320.ProcessSaleInvoiceUseCase>(
        () => _i320.ProcessSaleInvoiceUseCase(
              invoiceRepository: gh<_i339.InvoiceRepository>(),
              inventoryRepository: gh<_i422.InventoryRepository>(),
              customerRepository: gh<_i547.CustomerRepository>(),
              accountRepository: gh<_i64.AccountRepository>(),
              transactionRepository: gh<_i118.TransactionRepository>(),
            ));
    gh.factory<_i772.CustomerStatementBloc>(() => _i772.CustomerStatementBloc(
          getCustomerStatementUseCase: gh<_i256.GetCustomerStatementUseCase>(),
          recordCustomerPaymentUseCase:
              gh<_i985.RecordCustomerPaymentUseCase>(),
        ));
    gh.factory<_i652.DashboardBloc>(() => _i652.DashboardBloc(
          getFinancialSummaryUseCase: gh<_i460.GetFinancialSummaryUseCase>(),
          getAllCustomersUseCase: gh<_i74.GetAllCustomersUseCase>(),
        ));
    gh.lazySingleton<_i176.RecordAccountTransactionUseCase>(
        () => _i176.RecordAccountTransactionUseCase(
              accountRepository: gh<_i64.AccountRepository>(),
              customerRepository: gh<_i547.CustomerRepository>(),
              transactionRepository: gh<_i118.TransactionRepository>(),
            ));
    gh.factory<_i420.PersonalExpensesBloc>(() => _i420.PersonalExpensesBloc(
          getPersonalExpensesUseCase: gh<_i82.GetPersonalExpensesUseCase>(),
          addPersonalExpenseUseCase: gh<_i117.AddPersonalExpenseUseCase>(),
          getAllAccountsUseCase: gh<_i232.GetAllAccountsUseCase>(),
        ));
    gh.factory<_i690.InventoryBloc>(() => _i690.InventoryBloc(
          getAllProductsUseCase: gh<_i867.GetAllProductsUseCase>(),
          addProductUseCase: gh<_i234.AddProductUseCase>(),
        ));
    gh.factory<_i269.InvoiceBloc>(() => _i269.InvoiceBloc(
          processPurchaseInvoiceUseCase:
              gh<_i974.ProcessPurchaseInvoiceUseCase>(),
          processSaleInvoiceUseCase: gh<_i320.ProcessSaleInvoiceUseCase>(),
          calculateLandedCostUseCase: gh<_i357.CalculateLandedCostUseCase>(),
          getAllProductsUseCase: gh<_i867.GetAllProductsUseCase>(),
          getAllCustomersUseCase: gh<_i74.GetAllCustomersUseCase>(),
        ));
    gh.factory<_i897.CustomerBloc>(() => _i897.CustomerBloc(
          getAllCustomersUseCase: gh<_i74.GetAllCustomersUseCase>(),
          addCustomerUseCase: gh<_i379.AddCustomerUseCase>(),
        ));
    gh.factory<_i543.InvoicesListBloc>(() => _i543.InvoicesListBloc(
          getAllInvoicesUseCase: gh<_i235.GetAllInvoicesUseCase>(),
          getAllCustomersUseCase: gh<_i74.GetAllCustomersUseCase>(),
          getAllProductsUseCase: gh<_i867.GetAllProductsUseCase>(),
        ));
    gh.factory<_i103.AccountsBloc>(() => _i103.AccountsBloc(
          getAllAccountsUseCase: gh<_i843.GetAllAccountsUseCase>(),
          addAccountUseCase: gh<_i989.AddAccountUseCase>(),
          recordAccountTransactionUseCase:
              gh<_i176.RecordAccountTransactionUseCase>(),
          getAllCustomersUseCase: gh<_i74.GetAllCustomersUseCase>(),
        ));
    return this;
  }
}
