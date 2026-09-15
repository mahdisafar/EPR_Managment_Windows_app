import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/excel_export_button.dart';
import '../../data/models/customer_model.dart';
import '../bloc/customer_bloc.dart';
import '../widgets/add_customer_dialog.dart';
import '../widgets/customer_data_table.dart';
import '../widgets/customer_summary_cards.dart';

class CustomerListPage extends StatefulWidget {
  const CustomerListPage({super.key});

  @override
  State<CustomerListPage> createState() => _CustomerListPageState();
}

class _CustomerListPageState extends State<CustomerListPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<CustomerBloc>().add(const LoadCustomersEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openAddCustomerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AddCustomerDialog(
        onSubmit: (newCustomer) {
          context.read<CustomerBloc>().add(AddCustomerEvent(newCustomer));
        },
      ),
    );
  }

  void _navigateToStatement(CustomerModel customer) {
    context.push('/customers/statement', extra: customer);
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
              // Header & Add Customer Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'مدیریت مشتریان',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'IranYekan',
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'لیست حساب‌ها، ثبت مشتری جدید و بررسی وضعیت بدهکاری‌ها',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                          fontFamily: 'IranYekan',
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E3A8A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () => _openAddCustomerDialog(context),
                    icon: const Icon(Icons.add_rounded, size: 20),
                    label: const Text(
                      'مشتری جدید',
                      style: TextStyle(
                          fontFamily: 'IranYekan', fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ExcelExportButton(
                fileName: 'لیست_مشتریان',
                headers: ['کد', 'نام', 'تماس', 'آدرس', 'بیلانس'],
                rowsBuilder: () {
                  final s = context.read<CustomerBloc>().state;
                  if (s is! CustomerLoadedState) return [];
                  return s.filteredCustomers
                      .map((c) => [
                            c.code,
                            c.fullName,
                            c.phoneNumber,
                            c.address,
                            c.currentBalance
                          ])
                      .toList();
                },
              ),
              // Search Bar
              SizedBox(
                width: 360,
                child: TextField(
                  controller: _searchController,
                  onChanged: (query) {
                    context
                        .read<CustomerBloc>()
                        .add(LoadCustomersEvent(searchQuery: query));
                  },
                  decoration: InputDecoration(
                    hintText: 'جستجو نام، کد یا شماره تماس...',
                    hintStyle:
                        const TextStyle(fontSize: 12, fontFamily: 'IranYekan'),
                    prefixIcon: const Icon(Icons.search, size: 20),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Summary Cards & Customer Table
              Expanded(
                child: BlocConsumer<CustomerBloc, CustomerState>(
                  listener: (context, state) {
                    if (state is CustomerSuccessState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message,
                              style: const TextStyle(fontFamily: 'IranYekan')),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } else if (state is CustomerErrorState) {
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
                    if (state is CustomerLoadingState) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is CustomerLoadedState) {
                      return Column(
                        children: [
                          CustomerSummaryCards(
                            totalCount: state.customers.length,
                            totalReceivables: state.totalReceivables,
                            totalPayables: state.totalPayables,
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: Theme.of(context).dividerColor),
                              ),
                              child: CustomerDataTable(
                                customers: state.filteredCustomers,
                                onCustomerTap: _navigateToStatement,
                              ),
                            ),
                          ),
                        ],
                      );
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
