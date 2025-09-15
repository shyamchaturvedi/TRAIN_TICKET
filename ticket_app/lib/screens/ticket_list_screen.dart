import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/ticket.dart';
import '../providers/ticket_provider.dart';
import 'ticket_form_screen.dart';
import 'ticket_view_screen.dart';

class TicketListScreen extends StatefulWidget {
  const TicketListScreen({super.key});

  @override
  State<TicketListScreen> createState() => _TicketListScreenState();
}

class _TicketListScreenState extends State<TicketListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TicketProvider>().loadTickets();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TicketProvider>();
    final tickets = provider.tickets;
    return Scaffold(
      appBar: AppBar(title: const Text('Tickets')),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : tickets.isEmpty
              ? const Center(child: Text('No tickets yet. Tap + to add.'))
              : ListView.separated(
                  itemCount: tickets.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final ticket = tickets[index];
                    return ListTile(
                      title: Text(ticket.title),
                      subtitle: Text(
                        '${ticket.holderName} • ${DateFormat.yMMMd().add_jm().format(ticket.eventDate)}',
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TicketViewScreen(ticket: ticket),
                          ),
                        );
                        if (context.mounted) {
                          context.read<TicketProvider>().loadTickets();
                        }
                      },
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final created = await Navigator.push<Ticket?>(
            context,
            MaterialPageRoute(
              builder: (_) => const TicketFormScreen(),
            ),
          );
          if (created != null && context.mounted) {
            await context.read<TicketProvider>().addTicket(created);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

