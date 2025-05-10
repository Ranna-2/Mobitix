import 'package:flutter/material.dart';
import 'manage_schedules.dart';
import 'manage_reservations.dart';
import 'performance_analytics.dart';
import '../pages/LoginPage.dart'; // Make sure this exists or rename accordingly

class AdminDashboard extends StatelessWidget {
  final Color primaryColor = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Admin Dashboard'),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'logout') {
                _showLogoutConfirmation(context);
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: 'logout',
                child: Text('Logout'),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildTile(
              context,
              icon: Icons.schedule,
              label: 'Manage Schedules',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ManageSchedules()),
              ),
            ),
            _buildTile(
              context,
              icon: Icons.event_seat,
              label: 'Manage Reservations',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ManageReservations()),
              ),
            ),
            _buildTile(
              context,
              icon: Icons.bar_chart,
              label: 'Performance Analytics',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PerformanceAnalytics()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTile(BuildContext context,
      {required IconData icon,
        required String label,
        required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 6,
        color: Colors.blue.shade50,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 48, color: primaryColor),
              SizedBox(height: 12),
              Text(
                label,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Confirm Logout'),
        content: Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(), // Dismiss
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // Close dialog
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => LoginPage()),
                    (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(
              'Logout',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
