import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/customer_model.dart';
import '../bloc/customer_statement_bloc.dart';
import '../widgets/customer_header_card.dart';
import '../widgets/customer_statement_table.dart';
import '../widgets/record_payment_dialog.dart';

class CustomerStatementPage extends StatefulWidget {
  final CustomerModel customer;

  const CustomerStatementPage({
    super.key,
    required this.customer,
  });

  @override
  State<CustomerStatementPage> createState() => _CustomerStatementPageState();
}

class _CustomerStatementPageState extends State<CustomerStatementPage> {
  @override
  void initState() {
    super.initState();
    context
        .read<CustomerStatementBloc>()
        .add(LoadCustomerStatementEvent(widget.customer.id));
  }

  void _openRecordPaymentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => RecordPaymentDialog(
        onSubmit: (amount) {
          context.read<CustomerStatementBloc>().add(
                RecordPaymentEvent(
                  customerId: widget.customer.id,
                  amount: amount,
                ),
              );
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
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'صورت‌حساب: ${widget.customer.fullName}',
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'IranYekan',
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Header Card
              CustomerHeaderCard(
                customer: widget.customer,
                onRecordPaymentTap: () => _openRecordPaymentDialog(context),
              ),
              const SizedBox(height: 20),

              // Statement DataTable Container
              Expanded(
                child:
                    BlocConsumer<CustomerStatementBloc, CustomerStatementState>(
                  listener: (context, state) {
                    if (state is PaymentRecordedSuccessState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message,
                              style: const TextStyle(fontFamily: 'IranYekan')),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } else if (state is CustomerStatementErrorState) {
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
                    if (state is CustomerStatementLoadingState) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is CustomerStatementLoadedState) {
                      return Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: Theme.of(context).dividerColor),
                          ),
                          child: CustomerStatementTable(
                            statements: state.statements,
                          ));
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
