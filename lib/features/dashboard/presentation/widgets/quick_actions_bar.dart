import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:eprwindowsapp/features/customer/presentation/bloc/customer_bloc.dart';
import 'package:eprwindowsapp/features/customer/presentation/widgets/add_customer_dialog.dart';

class QuickActionsBar extends StatelessWidget {
  const QuickActionsBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'دسترسی سریع دسکتاپ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'IranYekan',
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildActionButton(
                icon: Icons.add_shopping_cart,
                label: 'فاکتور فروش جدید',
                color: Colors.green,
                onTap: () => context.go('/sale-invoice'),
              ),
              _buildActionButton(
                icon: Icons.shopping_bag_outlined,
                label: 'فاکتور خرید جدید',
                color: Colors.blue,
                onTap: () => context.go('/purchase-invoice'),
              ),
              _buildActionButton(
                icon: Icons.person_add_alt_1_outlined,
                label: 'ثبت مشتری جدید',
                color: Colors.orange,
                onTap: () => _openAddCustomerDialog(context),
              ),
              _buildActionButton(
                icon: Icons.local_shipping_outlined,
                label: 'ثبت محموله جدید',
                color: Colors.purple,
                onTap: () {
                  context.go('/shipments/register');
                },
              ),
            ],
          ),
        ],
      ),
    );
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

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18, color: color),
      label: Text(
        label,
        style: const TextStyle(
          fontFamily: 'IranYekan',
          fontSize: 13,
          color: Colors.black87,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withValues(alpha: 0.08),
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: color.withValues(alpha: 0.2)),
        ),
      ),
    );
  }
}
