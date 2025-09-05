import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class FilterBottomSheetWidget extends StatefulWidget {
  final Map<String, String> currentFilters;
  final Function(Map<String, String>) onFiltersChanged;

  const FilterBottomSheetWidget({
    Key? key,
    required this.currentFilters,
    required this.onFiltersChanged,
  }) : super(key: key);

  @override
  State<FilterBottomSheetWidget> createState() =>
      _FilterBottomSheetWidgetState();
}

class _FilterBottomSheetWidgetState extends State<FilterBottomSheetWidget> {
  late Map<String, String> _filters;

  @override
  void initState() {
    super.initState();
    _filters = Map.from(widget.currentFilters);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          SizedBox(height: 2.h),

          // Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filter Species',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _filters.clear();
                  });
                },
                child: Text(
                  'Clear All',
                  style: TextStyle(
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Climate Zone Filter
          _buildFilterSection(
            'Climate Zone',
            ['Arid', 'Semi-Arid', 'Tropical'],
            'climateZone',
          ),

          SizedBox(height: 2.h),

          // Growth Rate Filter
          _buildFilterSection(
            'Growth Rate',
            ['Slow', 'Medium', 'Fast'],
            'growthRate',
          ),

          SizedBox(height: 2.h),

          // Water Needs Filter
          _buildFilterSection(
            'Water Needs',
            ['Low', 'Medium', 'High'],
            'waterNeeds',
          ),

          SizedBox(height: 2.h),

          // Soil Type Filter
          _buildFilterSection(
            'Soil Type',
            ['Sandy', 'Clay', 'Loamy', 'Rocky'],
            'soilType',
          ),

          SizedBox(height: 3.h),

          // Apply Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                widget.onFiltersChanged(_filters);
                Navigator.pop(context);
              },
              child: Text('Apply Filters'),
            ),
          ),

          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildFilterSection(
      String title, List<String> options, String filterKey) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: options.map((option) {
            final isSelected = _filters[filterKey] == option;
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _filters.remove(filterKey);
                  } else {
                    _filters[filterKey] = option;
                  }
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.outline,
                  ),
                ),
                child: Text(
                  option,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isSelected
                            ? Colors.white
                            : AppTheme.lightTheme.colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
