import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/shipment_bloc.dart';
import '../widgets/shipment_form_fields.dart';

class RegisterShipmentPage extends StatelessWidget {
  const RegisterShipmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          title: const Text('ثبت محموله جدید',
              style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'IranYekan')),
        ),
        body: BlocConsumer<ShipmentBloc, ShipmentState>(
          listener: (context, state) {
            if (state is ShipmentListLoaded) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('محموله با موفقیت ثبت شد.',
                      style: TextStyle(fontFamily: 'IranYekan')),
                  backgroundColor: Colors.green,
                ),
              );
              context.pop();
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
            if (state is ShipmentLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: ShipmentFormFields(
                        onSubmit: (shipment) {
                          context
                              .read<ShipmentBloc>()
                              .add(RegisterShipmentEvent(shipment));
                        },
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
