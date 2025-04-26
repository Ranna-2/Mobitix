// pages/TicketConfirmationPage.dart
import 'package:flutter/material.dart';
import 'package:mobitix/pages/TicketsPage.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../model/ticket.dart';

class TicketConfirmationPage extends StatelessWidget {
  final Ticket ticket;

  const TicketConfirmationPage({Key? key, required this.ticket}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticket Confirmation'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 20),
            const Text(
              'Payment Successful!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            _buildTicketCard(context),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              icon: const Icon(Icons.download),
              label: const Text('Download Ticket as PDF'),
              onPressed: () => _generateAndSavePdf(context),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('View My Tickets'),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const TicketsPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'E-Ticket',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            _buildTicketRow('Booking ID:', ticket.id),
            _buildTicketRow('Passenger:', ticket.passengerName),
            _buildTicketRow('Mobile:', ticket.mobile),
            _buildTicketRow('Seats:', ticket.seats.join(', ')),
            _buildTicketRow('Route:', '${ticket.boarding} → ${ticket.destination}'),
            _buildTicketRow('Travel Date:',
                '${ticket.travelDate.day}/${ticket.travelDate.month}/${ticket.travelDate.year}'),
            _buildTicketRow('Bus:', ticket.busName),
            _buildTicketRow('Payment Method:', ticket.paymentMethod),
            const Divider(),
            _buildTicketRow(
              'Total Amount:',
              'LKR ${ticket.totalAmount.toStringAsFixed(2)}',
              isBold: true,
            ),
            const SizedBox(height: 10),
            const Text(
              'Show this ticket to the conductor when boarding',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _generateAndSavePdf(BuildContext context) async {
    // Create a PDF document
    final pdf = pw.Document();

    // Add a page to the PDF
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Mobitix E-Ticket',
                  style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Text('Booking ID: ${ticket.id}'),
              pw.Text('Passenger: ${ticket.passengerName}'),
              pw.Text('Mobile: ${ticket.mobile}'),
              pw.Text('Seats: ${ticket.seats.join(', ')}'),
              pw.Text('Route: ${ticket.boarding} → ${ticket.destination}'),
              pw.Text('Travel Date: ${ticket.travelDate.day}/${ticket.travelDate.month}/${ticket.travelDate.year}'),
              pw.Text('Bus: ${ticket.busName}'),
              pw.Text('Payment Method: ${ticket.paymentMethod}'),
              pw.SizedBox(height: 20),
              pw.Text('Total Amount: LKR ${ticket.totalAmount.toStringAsFixed(2)}',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Text('Show this ticket to the conductor when boarding',
                  style: pw.TextStyle(fontStyle: pw.FontStyle.italic)),
            ],
          );
        },
      ),
    );

    // Save the PDF document
    await Printing.sharePdf(
        bytes: await pdf.save(),
        filename: 'mobitix-ticket-${ticket.id}.pdf'
    );
  }
}