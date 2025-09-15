import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/ticket.dart';
import 'ticket_store.dart';

class WebTicketStore implements TicketStore {
  static const String _prefsKey = 'tickets_store_v1';

  Future<List<Ticket>> _readAll() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_prefsKey);
    if (jsonString == null || jsonString.isEmpty) return <Ticket>[];
    final List<dynamic> list = json.decode(jsonString) as List<dynamic>;
    return list
        .map((e) => Ticket.fromMap((e as Map<dynamic, dynamic>).map((k, v) => MapEntry(k as String, v))))
        .toList();
  }

  Future<void> _writeAll(List<Ticket> tickets) async {
    final prefs = await SharedPreferences.getInstance();
    final list = tickets.map((t) => t.toMap()).toList();
    await prefs.setString(_prefsKey, json.encode(list));
  }

  @override
  Future<List<Ticket>> fetchAllTickets() async {
    final list = await _readAll();
    list.sort((a, b) => a.eventDate.compareTo(b.eventDate));
    return list;
  }

  @override
  Future<Ticket> insertTicket(Ticket ticket) async {
    final list = await _readAll();
    final newId = (list.map((t) => t.id ?? 0).fold<int>(0, (p, c) => c > p ? c : p)) + 1;
    final created = ticket.copyWith(id: newId);
    list.add(created);
    await _writeAll(list);
    return created;
  }

  @override
  Future<int> updateTicket(Ticket ticket) async {
    final list = await _readAll();
    final index = list.indexWhere((t) => t.id == ticket.id);
    if (index == -1) return 0;
    list[index] = ticket;
    await _writeAll(list);
    return 1;
  }

  @override
  Future<int> deleteTicket(int id) async {
    final list = await _readAll();
    final removed = list.removeWhere((t) => t.id == id);
    await _writeAll(list);
    return removed > 0 ? 1 : 0;
  }
}

TicketStore getImplStore() => WebTicketStore();

