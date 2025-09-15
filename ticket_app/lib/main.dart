import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/ticket_provider.dart';
import 'screens/ticket_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TicketProvider(),
      child: MaterialApp(
        title: 'Ticket App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
        ),
        home: const TicketListScreen(),
      ),
    );
  }
}
