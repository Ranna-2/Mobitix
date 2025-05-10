import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // New import for charts
import 'services.dart';

class PerformanceAnalytics extends StatefulWidget {
  @override
  _PerformanceAnalyticsState createState() => _PerformanceAnalyticsState();
}

class _PerformanceAnalyticsState extends State<PerformanceAnalytics> {
  int totalBookings = 0;
  double totalRevenue = 0.0;

  @override
  void initState() {
    super.initState();
    fetchPerformanceData();
  }

  void fetchPerformanceData() async {
    try {
      var data = await getPerformanceData();
      print('Performance Data: $data');
      setState(() {
        totalBookings = int.parse(data['totalBookings'] ?? '0');
        totalRevenue = double.parse(data['totalRevenue'] ?? '0.0');
      });
    } catch (e) {
      print('Error fetching performance data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Performance Analytics'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildMetricCard('Total Bookings', '$totalBookings', Icons.event_available),
            _buildMetricCard('Total Revenue', 'LKR ${totalRevenue.toStringAsFixed(2)}', Icons.attach_money),
            SizedBox(height: 30),
            Text(
              'Performance Chart',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            _buildBarChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 12),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue, size: 40),
        title: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        subtitle: Text(value, style: TextStyle(fontSize: 18, color: Colors.black87)),
      ),
    );
  }

  Widget _buildBarChart() {
    return AspectRatio(
      aspectRatio: 1.4,
      child: BarChart(
        BarChartData(
          borderData: FlBorderData(show: false),
          barGroups: [
            BarChartGroupData(x: 0, barRods: [
              BarChartRodData(
                toY: totalBookings.toDouble(),
                color: Colors.orangeAccent,
                width: 30,
                borderRadius: BorderRadius.circular(6),
              ),
            ], showingTooltipIndicators: [0]),
            BarChartGroupData(x: 1, barRods: [
              BarChartRodData(
                toY: totalRevenue,
                color: Colors.pinkAccent,
                width: 30,
                borderRadius: BorderRadius.circular(6),
              ),
            ], showingTooltipIndicators: [0]),
          ],
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: _bottomTitles,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 40),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(show: true),
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              tooltipBgColor: Colors.grey.shade200,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                String label = group.x == 0 ? 'Bookings' : 'Revenue';
                return BarTooltipItem(
                  '$label\n${group.x == 0 ? totalBookings : 'LKR ${totalRevenue.toStringAsFixed(2)}'}',
                  TextStyle(color: Colors.black),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(fontWeight: FontWeight.bold, fontSize: 14);
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = Text('Bookings', style: style);
        break;
      case 1:
        text = Text('Revenue', style: style);
        break;
      default:
        text = Text('', style: style);
        break;
    }
    return SideTitleWidget(axisSide: meta.axisSide, child: text);
  }
}
