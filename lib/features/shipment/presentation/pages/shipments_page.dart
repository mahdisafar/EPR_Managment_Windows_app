import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/excel_export_button.dart';
import '../bloc/shipment_bloc.dart';
import '../widgets/shipment_data_table.dart';

class ShipmentsPage extends StatefulWidget {
  const ShipmentsPage({super.key});

  @override
  State<ShipmentsPage> createState() => _ShipmentsPageState();
}

class _ShipmentsPageState extends State<ShipmentsPage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ShipmentBloc>().add(LoadShipmentsEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
                      Text('مدیریت محموله‌ها',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'IranYekan')),
                      SizedBox(height: 4),
                      Text('لیست محموله‌های ترانزیت، وضعیت و جزئیات گمرک',
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
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      context.push('/shipments/register').then((_) {
                        if (context.mounted) {
                          context
                              .read<ShipmentBloc>()
                              .add(LoadShipmentsEvent());
                        }
                      });
                    },
                    icon: const Icon(Icons.add_rounded, size: 20),
                    label: const Text('محموله جدید',
                        style: TextStyle(
                            fontFamily: 'IranYekan',
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Search
              SizedBox(
                width: 360,
                child: TextField(
                  controller: _searchController,
                  onChanged: (q) =>
                      context.read<ShipmentBloc>().add(SearchShipmentsEvent(q)),
                  decoration: InputDecoration(
                    hintText: 'جستجو شماره، کالا، راننده یا شرکت...',
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
              ExcelExportButton(
                fileName: 'لیست_محموله‌ها',
                headers: [
                  'شماره',
                  'مسیر',
                  'تاریخ',
                  'وضعیت',
                  'ترانسپورت',
                  'بسته',
                  'وزن',
                  'ارزش'
                ],
                rowsBuilder: () {
                  final s = context.read<ShipmentBloc>().state;
                  if (s is! ShipmentListLoaded) return [];
                  return s.filteredShipments
                      .map((x) => [
                            x.shipmentNumber,
                            '${x.originCity}←${x.destinationCity}',
                            x.dispatchDate.toIso8601String(),
                            x.status.name,
                            x.transportCompany,
                            x.packageCount,
                            x.weight,
                            x.declaredValue,
                          ])
                      .toList();
                },
              ),
              // Table
              Expanded(
                child: BlocConsumer<ShipmentBloc, ShipmentState>(
                  listener: (context, state) {
                    if (state is ShipmentError) {
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
                    if (state is ShipmentLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is ShipmentListLoaded) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(12),
                          border:
                              Border.all(color: Theme.of(context).dividerColor),
                        ),
                        child: ShipmentDataTable(
                          shipments: state.filteredShipments,
                          onShipmentTap: (shipment) {
                            context
                                .push('/shipments/detail', extra: shipment)
                                .then((_) {
                              if (context.mounted) {
                                context
                                    .read<ShipmentBloc>()
                                    .add(LoadShipmentsEvent());
                              }
                            });
                          },
                        ),
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
