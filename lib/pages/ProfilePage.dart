import 'package:flutter/material.dart';
import 'package:mobitix/pages/TicketsPage.dart';
import 'LoginPage.dart';
import 'package:mobitix/widgets/CustomBottomNavBar.dart';
import 'HomePage.dart';
import 'MapPage.dart';
import 'SearchPage.dart';
import 'OtpVerificationPage.dart';


class ProfilePage extends StatelessWidget {
  // In a real app, you would get this from shared preferences or state management
  final Map<String, dynamic> userData = {
    'FullName': 'Rina Maharoof',
    'Email': 'Rinamaharoof@gmail.com',
    'PhoneNo': '0766665629',
    'CreatedAt': '2025-05-15',
  };

  final Color primaryColor = Color(0xFF3399ff);
  final Color secondaryColor = Color(0xFF3399ff);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
        backgroundColor: primaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Header
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: primaryColor.withOpacity(0.2),
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: primaryColor,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userData['FullName'],
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          userData['Email'],
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Member since ${userData['CreatedAt']}',
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            // User Details
            _buildDetailCard(
              title: 'Personal Information',
              items: [
                _buildDetailItem(Icons.person, 'Name', userData['FullName']),
                _buildDetailItem(Icons.email, 'Email', userData['Email']),
                _buildDetailItem(Icons.phone, 'Phone', userData['PhoneNo']),
              ],
            ),
            SizedBox(height: 16),

            // Account Actions
            _buildDetailCard(
              title: 'Account',
              items: [
                _buildActionItem(
                  Icons.lock,
                  'Change Password',
                  onTap: () {
                    // Navigate to change password screen
                  },
                ),
                _buildActionItem(
                  Icons.verified_user,
                  'Verify Account',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OtpVerificationPage(
                          email: userData['Email'],
                          isRegistration: false,
                        ),
                      ),
                    );
                  },
                ),
                _buildActionItem(
                  Icons.delete,
                  'Delete Account',
                  isDestructive: true,
                  onTap: () {
                    // Show delete confirmation
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 4, // Set current index to 2 for TicketsPage
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => HomePage())
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => SearchPage())
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const TicketsPage()),
            );
          } else if (index == 3) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => Mappage())
            );
          } else if (index == 4) {

          }
        },
      ),
    );
  }

  Widget _buildDetailCard({
    required String title,
    required List<Widget> items,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            SizedBox(height: 12),
            ...items,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: secondaryColor, size: 24),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600]),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem(
      IconData icon,
      String label, {
        bool isDestructive = false,
        required VoidCallback onTap,
      }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDestructive ? Colors.red : secondaryColor,
              size: 24,
            ),
            SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: isDestructive ? Colors.red : Colors.black,
              ),
            ),
            Spacer(),
            Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}