import '../models/ticket.dart';
import 'ticket_database.dart';
import 'ticket_store.dart';

class SqliteTicketStore implements TicketStore {
  @override
  Future<Ticket> insertTicket(Ticket ticket) {
    return TicketDatabase.instance.insertTicket(ticket);
  }

  @override
  Future<int> updateTicket(Ticket ticket) {
    return TicketDatabase.instance.updateTicket(ticket);
  }

  @override
  Future<int> deleteTicket(int id) {
    return TicketDatabase.instance.deleteTicket(id);
  }

  @override
  Future<List<Ticket>> fetchAllTickets() {
    return TicketDatabase.instance.fetchAllTickets();
  }
}

TicketStore getImplStore() => SqliteTicketStore();

