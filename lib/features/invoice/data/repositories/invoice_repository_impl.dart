import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/invoice_repository.dart';
import '../datasources/invoice_local_data_source.dart';
import '../models/invoice_model.dart';

@LazySingleton(as: InvoiceRepository)
class InvoiceRepositoryImpl implements InvoiceRepository {
  final InvoiceLocalDataSource localDataSource;

  InvoiceRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, Unit>> addInvoice(InvoiceModel invoice) async {
    try {
      await localDataSource.insertInvoice(invoice);
      return const Right(unit);
    } catch (e) {
      return Left(DatabaseFailure('خطا در ثبت فاکتور: $e'));
    }
  }

  @override
  Future<Either<Failure, InvoiceModel?>> getInvoiceById(String id) async {
    try {
      final result = await localDataSource.getInvoiceById(id);
      return Right(result);
    } catch (e) {
      return Left(DatabaseFailure('خطا در یافتن فاکتور: $e'));
    }
  }

  @override
  Future<Either<Failure, List<InvoiceModel>>> getAllInvoices() async {
    try {
      final invoices = await localDataSource.getAllInvoices();
      return Right(invoices);
    } catch (e) {
      return Left(DatabaseFailure('خطا در دریافت فاکتورها: $e'));
    }
  }

  @override
  Future<Either<Failure, List<InvoiceModel>>> getInvoicesByCustomerId(
      String customerId) async {
    try {
      final invoices =
          await localDataSource.getInvoicesByCustomerId(customerId);
      return Right(invoices);
    } catch (e) {
      return Left(DatabaseFailure('خطا در دریافت فاکتورهای مشتری: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteInvoice(String id) async {
    try {
      await localDataSource.deleteInvoice(id);
      return const Right(unit);
    } catch (e) {
      return Left(DatabaseFailure('خطا در حذف فاکتور: $e'));
    }
  }
}
