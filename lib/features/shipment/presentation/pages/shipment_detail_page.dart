import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' as intl;
import 'package:eprwindowsapp/core/di/injection.dart';
import '../../data/models/shipment_model.dart';
import '../bloc/shipment_bloc.dart';
import '../widgets/add_expense_dialog.dart';
import '../widgets/shipment_expense_list.dart';
import '../widgets/shipment_info_card.dart';
import '../widgets/shipment_status_timeline.dart';

class ShipmentDetailPage extends StatefulWidget {
  final ShipmentModel shipment;

  const ShipmentDetailPage({super.key, required this.shipment});

  @override
  State<ShipmentDetailPage> createState() => _ShipmentDetailPageState();
}

class _ShipmentDetailPageState extends State<ShipmentDetailPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ShipmentBloc>(
      create: (_) =>
          sl<ShipmentBloc>()..add(LoadShipmentDetailEvent(widget.shipment)),
      child: Builder(builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: const Color(0xFFF8FAFC),
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0.5,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black87),
                onPressed: () => context.pop(),
              ),
              title: Text('پیگیری محموله ${widget.shipment.shipmentNumber}',
                  style: const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'IranYekan')),
            ),
            body: BlocConsumer<ShipmentBloc, ShipmentState>(
              listener: (context, state) {
                if (state is ShipmentDetailError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message,
                          style: const TextStyle(fontFamily: 'IranYekan')),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else if (state is ShipmentError) {
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
                if (state is! ShipmentDetailLoaded) {
                  return const Center(child: CircularProgressIndicator());
                }

                final shipment = state.shipment;
                final formatter = intl.NumberFormat('#,##0.##', 'fa_IR');

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(children: [
                    ShipmentInfoCard(
                      shipment: shipment,
                      onAdvanceStatus: () {
                        context
                            .read<ShipmentBloc>()
                            .add(AdvanceShipmentStatusEvent(shipment));
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: ShipmentStatusTimeline(
                              currentStatus: shipment.status),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 3,
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('مصارف گمرک و ترانسپورت',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'IranYekan')),
                                      ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFF1E3A8A),
                                          foregroundColor: Colors.white,
                                        ),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (dialogContext) =>
                                                AddExpenseDialog(
                                              accounts: state.accounts,
                                              shipmentId: shipment.id,
                                              onSubmit: (expense) {
                                                context
                                                    .read<ShipmentBloc>()
                                                    .add(
                                                        AddShipmentExpenseEvent(
                                                            expense));
                                              },
                                            ),
                                          );
                                        },
                                        icon: const Icon(Icons.add, size: 18),
                                        label: const Text('ثبت مصرف',
                                            style: TextStyle(
                                                fontFamily: 'IranYekan')),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'جمع مصارف: ${formatter.format(state.totalExpenses)} toman',
                                    style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontFamily: 'IranYekan'),
                                  ),
                                  const SizedBox(height: 8),
                                  ShipmentExpenseList(expenses: state.expenses),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ]),
                );
              },
            ),
          ),
        );
      }),
    );
  }
}
