import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class WeatherHeaderWidget extends StatelessWidget {
  final String userName;
  final String location;
  final String temperature;
  final String weatherCondition;
  final String lastSyncTime;
  final bool isOffline;
  final VoidCallback? onRefresh;

  const WeatherHeaderWidget({
    Key? key,
    required this.userName,
    required this.location,
    required this.temperature,
    required this.weatherCondition,
    required this.lastSyncTime,
    required this.isOffline,
    this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.lightTheme.colorScheme.primary,
            AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.8),
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getGreeting(),
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        userName,
                        style: AppTheme.lightTheme.textTheme.headlineSmall
                            ?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: onRefresh,
                  child: Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: Icons.refresh.codePoint.toString(),
                      color: Colors.white,
                      size: 5.w,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                CustomIconWidget(
                  iconName: Icons.location_on.codePoint.toString(),
                  color: Colors.white.withValues(alpha: 0.9),
                  size: 4.w,
                ),
                SizedBox(width: 1.w),
                Expanded(
                  child: Text(
                    location,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Row(
              children: [
                Text(
                  temperature,
                  style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 2.w),
                CustomIconWidget(
                  iconName:
                      _getWeatherIcon(weatherCondition).codePoint.toString(),
                  color: Colors.white,
                  size: 6.w,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    weatherCondition,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            if (isOffline) ...[
              SizedBox(height: 1.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppTheme.warningColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: AppTheme.warningColor.withValues(alpha: 0.5),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: Icons.wifi_off.codePoint.toString(),
                      color: AppTheme.warningColor,
                      size: 4.w,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        'Offline - Last sync: $lastSyncTime',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  IconData _getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'sunny':
      case 'clear':
        return Icons.wb_sunny;
      case 'cloudy':
      case 'overcast':
        return Icons.cloud;
      case 'rainy':
      case 'rain':
        return Icons.grain;
      case 'stormy':
        return Icons.flash_on;
      default:
        return Icons.wb_cloudy;
    }
  }
}
