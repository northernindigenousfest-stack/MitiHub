import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/activity_card_widget.dart';
import './widgets/miti_bot_chat_bubble_widget.dart';
import './widgets/quick_action_button_widget.dart';
import './widgets/statistics_card_widget.dart';
import './widgets/weather_header_widget.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  int _currentIndex = 0;
  bool _isRefreshing = false;
  bool _isOffline = false;
  late TabController _tabController;

  // Mock data for dashboard
  final Map<String, dynamic> _userProfile = {
    "id": 1,
    "name": "Sarah Wanjiku",
    "role": "Guardian",
    "location": "Marsabit, Northern Kenya",
    "adoptedTrees": 12,
    "monitoringStreak": 45,
    "conservationPoints": 2850,
    "lastSync": "2 hours ago",
  };

  final Map<String, dynamic> _weatherData = {
    "temperature": "28°C",
    "condition": "Sunny",
    "humidity": "45%",
    "windSpeed": "12 km/h",
  };

  final List<Map<String, dynamic>> _recentActivities = [
    {
      "id": 1,
      "type": "tree_monitoring",
      "title": "Tree Monitoring Update",
      "description":
          "Successfully monitored 3 Acacia trees in Marsabit region. All trees showing healthy growth with 15cm height increase this month.",
      "timestamp": "2 hours ago",
      "imageUrl":
          "https://images.pexels.com/photos/1072824/pexels-photo-1072824.jpeg?auto=compress&cs=tinysrgb&w=800",
      "isRead": false,
    },
    {
      "id": 2,
      "type": "community_achievement",
      "title": "Community Milestone Reached",
      "description":
          "Marsabit community has successfully adopted 500 trees this month! You contributed 12 trees to this achievement.",
      "timestamp": "5 hours ago",
      "imageUrl": "",
      "isRead": false,
    },
    {
      "id": 3,
      "type": "news",
      "title": "New Tree Species Available",
      "description":
          "Drought-resistant Baobab saplings are now available for adoption. Perfect for Northern Kenya's climate conditions.",
      "timestamp": "1 day ago",
      "imageUrl":
          "https://images.pexels.com/photos/1072824/pexels-photo-1072824.jpeg?auto=compress&cs=tinysrgb&w=800",
      "isRead": true,
    },
    {
      "id": 4,
      "type": "adoption",
      "title": "Tree Adoption Success",
      "description":
          "Congratulations! Your newly adopted Moringa tree has been planted in the Marsabit conservation area.",
      "timestamp": "2 days ago",
      "imageUrl":
          "https://images.pexels.com/photos/1072824/pexels-photo-1072824.jpeg?auto=compress&cs=tinysrgb&w=800",
      "isRead": true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _checkConnectivity();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _checkConnectivity() async {
    // Simulate connectivity check
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _isOffline =
          DateTime.now().millisecond % 2 == 0; // Random offline state for demo
    });
  }

  Future<void> _refreshData() async {
    if (_isRefreshing) return;

    setState(() => _isRefreshing = true);

    // Haptic feedback
    HapticFeedback.lightImpact();

    // Simulate data refresh
    await Future.delayed(const Duration(seconds: 2));

    await _checkConnectivity();

    setState(() => _isRefreshing = false);

    // Show success feedback
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isOffline ? 'Showing cached data' : 'Data refreshed successfully',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: Colors.white,
            ),
          ),
          backgroundColor:
              _isOffline ? AppTheme.warningColor : AppTheme.successColor,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _onBottomNavTap(int index) {
    setState(() => _currentIndex = index);

    // Navigate to different screens based on index
    switch (index) {
      case 0:
        // Dashboard - already here
        break;
      case 1:
        Navigator.pushNamed(context, '/tree-species-library');
        break;
      case 2:
        // Monitor screen - would navigate here
        break;
      case 3:
        // Community screen - would navigate here
        break;
      case 4:
        // Profile screen - would navigate here
        break;
    }
  }

  void _onStatisticsLongPress(String type) {
    // Show detailed analytics overlay
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildAnalyticsOverlay(type),
    );
  }

  void _shareActivity(Map<String, dynamic> activity) {
    final String shareText = "${activity['title']}\n${activity['description']}";
    // In a real app, would use share_plus package
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing: ${activity['title']}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _viewActivityDetails(Map<String, dynamic> activity) {
    showDialog(
      context: context,
      builder: (context) => _buildActivityDetailsDialog(activity),
    );
  }

  void _markActivityAsRead(Map<String, dynamic> activity) {
    setState(() {
      final index =
          _recentActivities.indexWhere((a) => a['id'] == activity['id']);
      if (index != -1) {
        _recentActivities[index]['isRead'] = true;
      }
    });

    HapticFeedback.selectionClick();
  }

  void _adoptTree() {
    // Navigate to tree adoption flow
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening tree adoption...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _monitorTree() {
    // Navigate to tree monitoring
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening tree monitoring...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _openMitiBot() {
    Navigator.pushNamed(context, '/miti-bot-chat');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: _refreshData,
            color: AppTheme.lightTheme.colorScheme.primary,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: WeatherHeaderWidget(
                    userName: _userProfile['name'] as String,
                    location: _userProfile['location'] as String,
                    temperature: _weatherData['temperature'] as String,
                    weatherCondition: _weatherData['condition'] as String,
                    lastSyncTime: _userProfile['lastSync'] as String,
                    isOffline: _isOffline,
                    onRefresh: _refreshData,
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: 3.h),
                ),
                SliverToBoxAdapter(
                  child: _buildStatisticsSection(),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: 3.h),
                ),
                SliverToBoxAdapter(
                  child: _buildQuickActionsSection(),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: 3.h),
                ),
                SliverToBoxAdapter(
                  child: _buildRecentActivityHeader(),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final activity = _recentActivities[index];
                      return ActivityCardWidget(
                        activity: activity,
                        onShare: () => _shareActivity(activity),
                        onViewDetails: () => _viewActivityDetails(activity),
                        onMarkAsRead: () => _markActivityAsRead(activity),
                      );
                    },
                    childCount: _recentActivities.length,
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: 20.h), // Space for floating elements
                ),
              ],
            ),
          ),
          MitiBotChatBubbleWidget(onTap: _openMitiBot),
          if (_isRefreshing)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: LinearProgressIndicator(
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildStatisticsSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Impact',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StatisticsCardWidget(
                title: 'Adopted Trees',
                value: '${_userProfile['adoptedTrees']}',
                subtitle: 'Growing strong',
                icon: Icons.eco,
                iconColor: AppTheme.successColor,
                onLongPress: () => _onStatisticsLongPress('trees'),
              ),
              StatisticsCardWidget(
                title: 'Monitoring Streak',
                value: '${_userProfile['monitoringStreak']}',
                subtitle: 'Days active',
                icon: Icons.trending_up,
                iconColor: AppTheme.lightTheme.colorScheme.primary,
                onLongPress: () => _onStatisticsLongPress('streak'),
              ),
              StatisticsCardWidget(
                title: 'Conservation Points',
                value: '${_userProfile['conservationPoints']}',
                subtitle: 'Total earned',
                icon: Icons.stars,
                iconColor: AppTheme.warningColor,
                onLongPress: () => _onStatisticsLongPress('points'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              QuickActionButtonWidget(
                title: 'Adopt Tree',
                icon: Icons.favorite,
                backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                foregroundColor: Colors.white,
                onPressed: _adoptTree,
              ),
              QuickActionButtonWidget(
                title: 'Monitor Tree',
                icon: Icons.camera_alt,
                backgroundColor: AppTheme.successColor,
                foregroundColor: Colors.white,
                onPressed: _monitorTree,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivityHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Recent Activity',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          TextButton(
            onPressed: () {
              // Navigate to full activity feed
            },
            child: Text(
              'View All',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.shadowColor,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor:
            AppTheme.lightTheme.bottomNavigationBarTheme.backgroundColor,
        selectedItemColor:
            AppTheme.lightTheme.bottomNavigationBarTheme.selectedItemColor,
        unselectedItemColor:
            AppTheme.lightTheme.bottomNavigationBarTheme.unselectedItemColor,
        selectedLabelStyle:
            AppTheme.lightTheme.bottomNavigationBarTheme.selectedLabelStyle,
        unselectedLabelStyle:
            AppTheme.lightTheme.bottomNavigationBarTheme.unselectedLabelStyle,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.park),
            label: 'Trees',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Monitor',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsOverlay(String type) {
    String title;
    String description;

    switch (type) {
      case 'trees':
        title = 'Adopted Trees Analytics';
        description =
            'Your 12 adopted trees include 5 Acacia, 4 Moringa, and 3 Baobab species. Average survival rate: 95%.';
        break;
      case 'streak':
        title = 'Monitoring Streak Analytics';
        description =
            'You\'ve maintained a 45-day monitoring streak! Your consistency helps ensure tree health and growth tracking.';
        break;
      case 'points':
        title = 'Conservation Points Breakdown';
        description =
            'Earned through: Tree adoption (1200 pts), Monitoring (800 pts), Community engagement (500 pts), Educational activities (350 pts).';
        break;
      default:
        title = 'Analytics';
        description = 'Detailed analytics information.';
    }

    return Container(
      height: 50.h,
      margin: EdgeInsets.all(4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            description,
            style: AppTheme.lightTheme.textTheme.bodyLarge,
          ),
          SizedBox(height: 3.h),
          // Placeholder for chart
          Container(
            width: double.infinity,
            height: 25.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: Icons.bar_chart.codePoint.toString(),
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 10.w,
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Detailed Chart View',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityDetailsDialog(Map<String, dynamic> activity) {
    return Dialog(
      backgroundColor: AppTheme.lightTheme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: EdgeInsets.all(4.w),
        constraints: BoxConstraints(maxHeight: 70.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    activity['title'] as String,
                    style:
                        AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            if ((activity['imageUrl'] as String).isNotEmpty) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CustomImageWidget(
                  imageUrl: activity['imageUrl'] as String,
                  width: double.infinity,
                  height: 25.h,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 2.h),
            ],
            Flexible(
              child: SingleChildScrollView(
                child: Text(
                  activity['description'] as String,
                  style: AppTheme.lightTheme.textTheme.bodyLarge,
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              activity['timestamp'] as String,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _shareActivity(activity);
                  },
                  child: Text('Share'),
                ),
                SizedBox(width: 2.w),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Close'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
