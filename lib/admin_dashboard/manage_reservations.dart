import 'package:flutter/material.dart';
import 'services.dart';

class ManageReservations extends StatefulWidget {
  @override
  _ManageReservationsState createState() => _ManageReservationsState();
}

class _ManageReservationsState extends State<ManageReservations> {
  List reservations = [];

  @override
  void initState() {
    super.initState();
    fetchReservations();
  }

  void fetchReservations() async {
    var fetchedReservations = await fetchTicketReservations();
    setState(() {
      reservations = fetchedReservations;
    });
  }

  void deleteReservation(int ticketId) async {
    await deleteTicketReservation(ticketId);
    fetchReservations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Reservations'),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: reservations.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Ticket Reservations',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: reservations.length,
                itemBuilder: (context, index) {
                  var reservation = reservations[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.shade100,
                        child: Icon(Icons.person, color: Colors.blue),
                      ),
                      title: Text('Passenger: ${reservation['passenger_name']}'),
                      subtitle: Text('Seats: ${reservation['seats']}'),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => deleteReservation(reservation['id']),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
