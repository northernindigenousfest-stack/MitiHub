import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SpeciesCardWidget extends StatelessWidget {
  final Map<String, dynamic> species;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const SpeciesCardWidget({
    Key? key,
    required this.species,
    required this.onTap,
    required this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tree Image
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: CustomImageWidget(
                  imageUrl: species['image'] as String,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Species Information
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(2.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Local Name
                    Text(
                      species['localName'] as String,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    SizedBox(height: 0.5.h),

                    // Scientific Name
                    Text(
                      species['scientificName'] as String,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontStyle: FontStyle.italic,
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    SizedBox(height: 1.h),

                    // Suitability Icons
                    Row(
                      children: [
                        if ((species['waterNeeds'] as String) == 'Low')
                          Padding(
                            padding: EdgeInsets.only(right: 1.w),
                            child: CustomIconWidget(
                              iconName: 'water_drop',
                              color: AppTheme.lightTheme.colorScheme.primary,
                              size: 16,
                            ),
                          ),
                        if ((species['growthRate'] as String) == 'Fast')
                          Padding(
                            padding: EdgeInsets.only(right: 1.w),
                            child: CustomIconWidget(
                              iconName: 'trending_up',
                              color: AppTheme.successColor,
                              size: 16,
                            ),
                          ),
                        if ((species['climateZone'] as String) == 'Arid')
                          CustomIconWidget(
                            iconName: 'wb_sunny',
                            color: AppTheme.warningColor,
                            size: 16,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
