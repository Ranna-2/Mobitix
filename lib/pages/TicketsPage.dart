import 'dart:convert';

import 'package:flutter/material.dart';
import '../model/ticket.dart';
import 'TicketConfirmationPage.dart';
import 'HomePage.dart';
import 'SearchPage.dart';
import 'MapPage.dart';
import 'ProfilePage.dart';
import '../widgets/CustomBottomNavBar.dart';
import 'package:http/http.dart' as http;

class TicketsPage extends StatefulWidget {
  const TicketsPage({Key? key}) : super(key: key);

  @override
  _TicketsPageState createState() => _TicketsPageState();
}

class _TicketsPageState extends State<TicketsPage> {
  List<Ticket> tickets = []; // You would load these from your database/backend



  @override
  void initState() {
    super.initState();
    // Load tickets - in a real app, this would come from your database/API
    _loadTickets();
  }

  Future<void> _loadTickets() async {
    try {
      // Replace with actual user mobile number or ID
      final userMobile = '0766665629'; // This should come from your auth system

      final response = await http.get(
        Uri.parse('http://192.168.106.242/mobitix/fetch_tickets.php?mobile=$userMobile'),
      );
      // Mock data - replace with actual data loading
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          tickets = data.map((t) => Ticket(
            id: t['id'],
            passengerName: t['passengerName'],
            mobile: t['mobile'],
            email: t['email'],
            seats: List<String>.from(t['seats'].map((s) => s.toString())),
            boarding: t['boarding'],
            destination: t['destination'],
            totalAmount: t['totalAmount'],
            bookingDate: DateTime.parse(t['bookingDate']),
            travelDate: DateTime.parse(t['travelDate']),
            busName: t['busName'],
            busId: t['busId'].toString(),
            paymentMethod: t['paymentMethod'],
            referenceId: t['referenceId'],
            status: t['status'],
          )).toList();
        });
      } else {
        throw Exception('Failed to load tickets');
      }
    } catch (e) {
      print('Error loading tickets: $e');
      // Fallback to mock data if API fails (remove in production)
      setState(() {
        tickets = [
          Ticket(
            id: 'ticket_123456',
            passengerName: 'Rina Maharoof',
            mobile: '0766665629',
            email: 'samanperera@gmail.com',
            seats: ['49', '50','48'],
            boarding: 'Colombo',
            destination: 'Kandy',
            totalAmount: 4500.00,
            bookingDate: DateTime.now(),
            travelDate: DateTime.now().add(const Duration(days: 1)),
            busName: 'Express Bus',
            busId: 'bus123',
            paymentMethod: 'Genie',
            referenceId: 'ref_123456',
            status: 'upcoming',
          ),
        ];
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final upcomingTrips = tickets.where((t) => t.status == 'upcoming').toList();
    final tripHistory = tickets.where((t) => t.status != 'upcoming').toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Tickets'),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Upcoming Trips'),
              Tab(text: 'Trip History'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildTicketList(upcomingTrips),
            _buildTicketList(tripHistory),
          ],
        ),
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: 2, // Set current index to 2 for TicketsPage
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
              // Already on TicketsPage
            } else if (index == 3) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => Mappage())
              );
            } else if (index == 4) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => ProfilePage())
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildTicketList(List<Ticket> tickets) {
    if (tickets.isEmpty) {
      return const Center(
        child: Text('No tickets found'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tickets.length,
      itemBuilder: (context, index) {
        final ticket = tickets[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TicketConfirmationPage(ticket: ticket),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${ticket.boarding} → ${ticket.destination}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Chip(
                        label: Text(
                          ticket.status.toUpperCase(),
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor: ticket.status == 'upcoming'
                            ? Colors.blue
                            : ticket.status == 'completed'
                            ? Colors.green
                            : Colors.red,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text('Seats: ${ticket.seats.join(', ')}'),
                  Text('Travel Date: ${_formatDate(ticket.travelDate)}'),
                  Text('Bus: ${ticket.busName}'),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'LKR ${ticket.totalAmount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TicketConfirmationPage(ticket: ticket),
                            ),
                          );
                        },
                        child: const Text('View Ticket'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}