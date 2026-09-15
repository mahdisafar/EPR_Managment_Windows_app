import 'package:flutter/material.dart';
import 'package:eprwindowsapp/core/widgets/date_range_picker_dialog.dart';
import '../bloc/dashboard_bloc.dart';

class DateFilterSelector extends StatelessWidget {
  final DateFilterType selectedFilter;
  final ValueChanged<DateFilterType> onFilterSelected;
  final void Function(DateTime start, DateTime end)? onCustomRangeSelected;

  const DateFilterSelector({
    super.key,
    required this.selectedFilter,
    required this.onFilterSelected,
    this.onCustomRangeSelected,
  });

  Future<void> _openCustomRange(BuildContext context) async {
    final range = await showDialog<(DateTime, DateTime)>(
      context: context,
      builder: (_) => const CustomDateRangeDialog(),
    );
    if (range != null) {
      onFilterSelected(DateFilterType.custom);
      onCustomRangeSelected?.call(range.$1, range.$2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildFilterChip('امروز', DateFilterType.today),
          _buildFilterChip('این هفته', DateFilterType.thisWeek),
          _buildFilterChip('این ماه', DateFilterType.thisMonth),
          _buildFilterChip('امسال', DateFilterType.thisYear),
          _buildFilterChip('کل دوره', DateFilterType.allTime),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: InkWell(
              onTap: () => _openCustomRange(context),
              borderRadius: BorderRadius.circular(8),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: selectedFilter == DateFilterType.custom
                      ? Colors.blue.shade700
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  selectedFilter == DateFilterType.custom
                      ? 'انتخابی ✓'
                      : 'انتخابی',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: selectedFilter == DateFilterType.custom
                        ? FontWeight.bold
                        : FontWeight.w500,
                    color: selectedFilter == DateFilterType.custom
                        ? Colors.white
                        : Colors.grey.shade700,
                    fontFamily: 'IranYekan',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, DateFilterType filter) {
    final isSelected = selectedFilter == filter;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: InkWell(
        onTap: () => onFilterSelected(filter),
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue.shade700 : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? Colors.white : Colors.grey.shade700,
              fontFamily: 'IranYekan',
            ),
          ),
        ),
      ),
    );
  }
}
