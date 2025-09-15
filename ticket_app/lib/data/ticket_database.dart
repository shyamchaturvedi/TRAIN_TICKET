import 'dart:async';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/ticket.dart';

class TicketDatabase {
  TicketDatabase._internal();
  static final TicketDatabase instance = TicketDatabase._internal();

  static const String _dbName = 'tickets.db';
  static const int _dbVersion = 1;
  static const String tableTickets = 'tickets';

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final dbPath = p.join(docsDir.path, _dbName);
    return openDatabase(
      dbPath,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableTickets (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        holder_name TEXT NOT NULL,
        event_date TEXT NOT NULL,
        venue TEXT NOT NULL,
        notes TEXT NOT NULL
      );
    ''');
  }

  Future<List<Ticket>> fetchAllTickets() async {
    final db = await database;
    final rows = await db.query(tableTickets, orderBy: 'event_date ASC');
    return rows.map((m) => Ticket.fromMap(m)).toList();
  }

  Future<Ticket> insertTicket(Ticket ticket) async {
    final db = await database;
    final id = await db.insert(tableTickets, ticket.toMap());
    return ticket.copyWith(id: id);
  }

  Future<int> updateTicket(Ticket ticket) async {
    final db = await database;
    return db.update(
      tableTickets,
      ticket.toMap(),
      where: 'id = ?',
      whereArgs: [ticket.id],
    );
  }

  Future<int> deleteTicket(int id) async {
    final db = await database;
    return db.delete(
      tableTickets,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

