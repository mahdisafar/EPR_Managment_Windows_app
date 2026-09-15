import 'package:equatable/equatable.dart';
import '../../../../core/database/table_constants.dart';

class CustomerModel extends Equatable {
  final String id;
  final String code;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String address;
  final double initialBalance;
  final double currentBalance;

  const CustomerModel({
    required this.id,
    required this.code,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.address,
    this.initialBalance = 0.0,
    this.currentBalance = 0.0,
  });

  String get fullName => '$firstName $lastName';
  double get balance => currentBalance;
  CustomerModel copyWith({
    String? id,
    String? code,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? address,
    double? initialBalance,
    double? currentBalance,
  }) {
    return CustomerModel(
      id: id ?? this.id,
      code: code ?? this.code,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      initialBalance: initialBalance ?? this.initialBalance,
      currentBalance: currentBalance ?? this.currentBalance,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      TableConstants.columnId: id,
      TableConstants.colCustomerCode: code,
      TableConstants.colFirstName: firstName,
      TableConstants.colLastName: lastName,
      TableConstants.colPhone: phoneNumber,
      TableConstants.colAddress: address,
      TableConstants.colInitialBalance: initialBalance,
      TableConstants.colCurrentBalance: currentBalance,
    };
  }

  factory CustomerModel.fromMap(Map<String, dynamic> map) {
    return CustomerModel(
      id: map[TableConstants.columnId] as String,
      code: map[TableConstants.colCustomerCode] as String,
      firstName: map[TableConstants.colFirstName] as String,
      lastName: map[TableConstants.colLastName] as String,
      phoneNumber: (map[TableConstants.colPhone] ?? '') as String,
      address: (map[TableConstants.colAddress] ?? '') as String,
      initialBalance:
          (map[TableConstants.colInitialBalance] as num?)?.toDouble() ?? 0.0,
      currentBalance:
          (map[TableConstants.colCurrentBalance] as num?)?.toDouble() ?? 0.0,
    );
  }

  @override
  List<Object?> get props => [
        id,
        code,
        firstName,
        lastName,
        phoneNumber,
        address,
        initialBalance,
        currentBalance,
      ];
}
