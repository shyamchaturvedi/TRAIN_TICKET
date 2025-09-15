import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../models/ticket.dart';
import '../providers/ticket_provider.dart';
import 'ticket_form_screen.dart';

class TicketViewScreen extends StatelessWidget {
  const TicketViewScreen({super.key, required this.ticket});

  final Ticket ticket;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticket Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final updated = await Navigator.push<Ticket?>(
                context,
                MaterialPageRoute(
                  builder: (_) => TicketFormScreen(initial: ticket),
                ),
              );
              if (updated != null && context.mounted) {
                await context.read<TicketProvider>().updateTicket(updated);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Delete ticket?'),
                  content: const Text('This action cannot be undone.'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                    FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
                  ],
                ),
              );
              if (confirm == true && context.mounted && ticket.id != null) {
                await context.read<TicketProvider>().deleteTicket(ticket.id!);
                if (context.mounted) Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(ticket.title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text('Holder: ${ticket.holderName}'),
          Text('Venue: ${ticket.venue}'),
          Text('When: ${DateFormat.yMMMd().add_jm().format(ticket.eventDate)}'),
          if (ticket.notes.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(ticket.notes),
          ],
          const SizedBox(height: 24),
          Center(
            child: QrImageView(
              data: _qrData(ticket),
              version: QrVersions.auto,
              size: 220,
            ),
          ),
        ],
      ),
    );
  }

  String _qrData(Ticket t) {
    return 'TICKET:${t.id ?? 'NEW'}|${t.title}|${t.holderName}|${t.eventDate.toIso8601String()}|${t.venue}';
  }
}

