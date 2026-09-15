import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as intl;
import '../../../../core/widgets/excel_export_button.dart';
import '../bloc/personal_expenses_bloc.dart';
import '../widgets/add_personal_expense_dialog.dart';
import '../widgets/personal_expense_table.dart';

class PersonalExpensesPage extends StatefulWidget {
  const PersonalExpensesPage({super.key});

  @override
  State<PersonalExpensesPage> createState() => _PersonalExpensesPageState();
}

class _PersonalExpensesPageState extends State<PersonalExpensesPage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<PersonalExpensesBloc>().add(LoadPersonalExpensesEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openAddDialog(BuildContext context) {
    final state = context.read<PersonalExpensesBloc>().state;
    if (state is! PersonalExpensesLoaded) return;

    showDialog(
      context: context,
      builder: (dialogContext) => AddPersonalExpenseDialog(
        accounts: state.accounts,
        onSubmit: (expense) {
          context
              .read<PersonalExpensesBloc>()
              .add(AddPersonalExpenseEvent(expense));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('مصارف شخصی',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'IranYekan')),
                      SizedBox(height: 4),
                      Text(
                          'ثبت مصارف روزمره — به‌صورت خودکار از حساب کم و در گزارش‌ها محاسبه می‌شود',
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                              fontFamily: 'IranYekan')),
                    ],
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E3A8A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14),
                    ),
                    onPressed: () => _openAddDialog(context),
                    icon: const Icon(Icons.add_rounded, size: 20),
                    label: const Text('مصرف جدید',
                        style: TextStyle(
                            fontFamily: 'IranYekan',
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ExcelExportButton(
                fileName: 'مصارف_شخصی',
                headers: [
                  'مورد',
                  'دسته',
                  'تعداد',
                  'فی',
                  'جمع',
                  'تاریخ',
                  'حساب',
                  'رسید'
                ],
                rowsBuilder: () {
                  final s = context.read<PersonalExpensesBloc>().state;
                  if (s is! PersonalExpensesLoaded) return [];
                  return s.filteredExpenses
                      .map((e) => [
                            e.itemName,
                            e.category,
                            e.quantity,
                            e.unitPrice,
                            e.totalAmount,
                            e.date.toIso8601String(),
                            e.accountName ?? '',
                            e.receiptNumber ?? '',
                          ])
                      .toList();
                },
              ),
              // Search
              SizedBox(
                width: 360,
                child: TextField(
                  controller: _searchController,
                  onChanged: (q) => context
                      .read<PersonalExpensesBloc>()
                      .add(SearchPersonalExpensesEvent(q)),
                  decoration: InputDecoration(
                    hintText: 'جستجو نام مورد یا دسته...',
                    hintStyle:
                        const TextStyle(fontSize: 12, fontFamily: 'IranYekan'),
                    prefixIcon: const Icon(Icons.search, size: 20),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 12),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade300)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade300)),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Total bar + Table
              Expanded(
                child:
                    BlocConsumer<PersonalExpensesBloc, PersonalExpensesState>(
                  listener: (context, state) {
                    if (state is PersonalExpensesError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message,
                              style: const TextStyle(fontFamily: 'IranYekan')),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is PersonalExpensesLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is PersonalExpensesLoaded) {
                      final formatter = intl.NumberFormat('#,##0.##', 'fa_IR');

                      return Column(children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: Theme.of(context).dividerColor),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'جمع مصارف${state.query.isNotEmpty ? ' (فیلترشده)' : ''}:',
                                style: const TextStyle(
                                    fontFamily: 'IranYekan',
                                    color: Colors.grey),
                              ),
                              Text(
                                '${formatter.format(state.totalFiltered)} toman',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red.shade800,
                                  fontFamily: 'IranYekan',
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: Theme.of(context).dividerColor),
                            ),
                            child: PersonalExpenseTable(
                                expenses: state.filteredExpenses),
                          ),
                        ),
                      ]);
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
