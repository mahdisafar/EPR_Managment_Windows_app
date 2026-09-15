import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/invoice_model.dart';

abstract class InvoiceRepository {
  Future<Either<Failure, Unit>> addInvoice(InvoiceModel invoice);
  Future<Either<Failure, InvoiceModel?>> getInvoiceById(String id);
  Future<Either<Failure, List<InvoiceModel>>> getAllInvoices();
  Future<Either<Failure, List<InvoiceModel>>> getInvoicesByCustomerId(
      String customerId);
  Future<Either<Failure, Unit>> deleteInvoice(String id);
}
