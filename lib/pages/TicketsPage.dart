import 'package:flutter/material.dart';
import '../model/ticket.dart';
import 'TicketConfirmationPage.dart';
import 'HomePage.dart';
import 'SearchPage.dart';
import 'MapPage.dart';
import 'ProfilePage.dart';
import '../widgets/CustomBottomNavBar.dart';

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

  void _loadTickets() {
    // Mock data - replace with actual data loading
    setState(() {
      tickets = [
        Ticket(
          id: 'ticket_123456',
          passengerName: 'Saman Perera',
          mobile: '0766665629',
          email: 'samanperera@gmail.com',
          seats: ['11', '10','18'],
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
        // Add more tickets as needed
      ];
    });
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