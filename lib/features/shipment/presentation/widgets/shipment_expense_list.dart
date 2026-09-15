import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:eprwindowsapp/config/enum.dart';
import '../../data/models/shipment_expense_model.dart';

class ShipmentExpenseList extends StatelessWidget {
  final List<ShipmentExpenseModel> expenses;

  const ShipmentExpenseList({super.key, required this.expenses});

  static String expenseTypeLabel(ExpenseType type) {
    switch (type) {
      case ExpenseType.customsDuty:
        return 'حقوق گمرکی';
      case ExpenseType.tax:
        return 'مالیات';
      case ExpenseType.clearanceFee:
        return 'هزینه ترخیص';
      case ExpenseType.documentFee:
        return 'هزینه اسناد';
      case ExpenseType.inspectionFee:
        return 'هزینه بازرسی';
      case ExpenseType.transportFare:
        return 'کرایه ترانسپورت';
      case ExpenseType.routeFee:
        return 'هزینه مسیر';
      case ExpenseType.loadingFee:
        return 'هزینه بارگیری';
      case ExpenseType.unloadingFee:
        return 'هزینه تخلیه';
      case ExpenseType.storageFee:
        return 'هزینه انبار';
      case ExpenseType.borderFee:
        return 'هزینه مرزی';
      case ExpenseType.porterFee:
        return 'هزینه جوالی';
      case ExpenseType.workerFee:
        return 'هزینه کارگر';
      case ExpenseType.other:
        return 'سایر مصارف';
    }
  }

  static String currencyLabel(CurrencyType c) {
    switch (c) {
      case CurrencyType.toman:
        return 'toman';
      case CurrencyType.usd:
        return 'USD';
      case CurrencyType.pkr:
        return 'PKR';
      case CurrencyType.irr:
        return 'IRR';
      case CurrencyType.eur:
        return 'Euro';
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatter = intl.NumberFormat('#,##0.##', 'fa_IR');
    final dateFormatter = intl.DateFormat('yyyy/MM/dd', 'fa_IR');

    if (expenses.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(24.0),
        child: Center(
          child: Text('هنوز مصرفی برای این محموله ثبت نشده است.',
              style: TextStyle(fontFamily: 'IranYekan', color: Colors.grey)),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: expenses.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final e = expenses[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.red.shade50,
            child: Icon(Icons.payments_outlined,
                color: Colors.red.shade700, size: 20),
          ),
          title: Text(expenseTypeLabel(e.expenseType),
              style: const TextStyle(
                  fontWeight: FontWeight.w600, fontFamily: 'IranYekan')),
          subtitle: Text(
            '${dateFormatter.format(e.date)} — به: ${e.paidTo}${e.receiptNumber != null ? ' — رسید: ${e.receiptNumber}' : ''}',
            style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontFamily: 'IranYekan'),
          ),
          trailing: Text(
            '${formatter.format(e.amount)} ${currencyLabel(e.currency)}',
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontFamily: 'IranYekan'),
          ),
        );
      },
    );
  }
}
