import 'package:flutter/foundation.dart';

import '../data/store_factory.dart';
import '../models/ticket.dart';

class TicketProvider extends ChangeNotifier {
  TicketProvider();

  final List<Ticket> _tickets = <Ticket>[];
  bool _isLoading = false;

  List<Ticket> get tickets => List.unmodifiable(_tickets);
  bool get isLoading => _isLoading;

  Future<void> loadTickets() async {
    _isLoading = true;
    notifyListeners();
    try {
      final loaded = await getStore().fetchAllTickets();
      _tickets
        ..clear()
        ..addAll(loaded);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTicket(Ticket ticket) async {
    final created = await getStore().insertTicket(ticket);
    _tickets.add(created);
    notifyListeners();
  }

  Future<void> updateTicket(Ticket ticket) async {
    if (ticket.id == null) return;
    await getStore().updateTicket(ticket);
    final index = _tickets.indexWhere((t) => t.id == ticket.id);
    if (index != -1) {
      _tickets[index] = ticket;
      notifyListeners();
    }
  }

  Future<void> deleteTicket(int id) async {
    await getStore().deleteTicket(id);
    _tickets.removeWhere((t) => t.id == id);
    notifyListeners();
  }
}

