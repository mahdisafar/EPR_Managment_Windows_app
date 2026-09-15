import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../features/invoice/data/models/invoice_model.dart';
import '../../../features/invoice/domain/repositories/invoice_repository.dart';

@lazySingleton
class GetAllInvoicesUseCase {
  final InvoiceRepository repository;

  GetAllInvoicesUseCase(this.repository);

  Future<List<InvoiceModel>> call() async {
    final result = await repository.getAllInvoices();
    return result.fold(
      (f) => throw Exception(f.message),
      (list) => list,
    );
  }
}
