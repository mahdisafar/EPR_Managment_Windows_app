import 'package:equatable/equatable.dart';

class CustomerStatementDTO extends Equatable {
  final String id;
  final DateTime date;
  final String details;
  final double? quantity;
  final double? price;
  final double totalAmount;
  final double receipts;
  final double runningBalance;

  const CustomerStatementDTO({
    required this.id,
    required this.date,
    required this.details,
    this.quantity,
    this.price,
    required this.totalAmount,
    required this.receipts,
    required this.runningBalance,
  });

  @override
  List<Object?> get props => [
        id,
        date,
        details,
        quantity,
        price,
        totalAmount,
        receipts,
        runningBalance,
      ];
}
