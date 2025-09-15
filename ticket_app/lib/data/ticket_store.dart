import '../models/ticket.dart';

abstract class TicketStore {
  Future<List<Ticket>> fetchAllTickets();
  Future<Ticket> insertTicket(Ticket ticket);
  Future<int> updateTicket(Ticket ticket);
  Future<int> deleteTicket(int id);
}

