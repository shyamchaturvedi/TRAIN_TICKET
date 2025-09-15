import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/ticket.dart';

class TicketFormScreen extends StatefulWidget {
  const TicketFormScreen({super.key, this.initial});

  final Ticket? initial;

  @override
  State<TicketFormScreen> createState() => _TicketFormScreenState();
}

class _TicketFormScreenState extends State<TicketFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _holderController;
  late TextEditingController _venueController;
  late TextEditingController _notesController;
  DateTime _eventDate = DateTime.now().add(const Duration(days: 1));

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initial?.title ?? '');
    _holderController = TextEditingController(text: widget.initial?.holderName ?? '');
    _venueController = TextEditingController(text: widget.initial?.venue ?? '');
    _notesController = TextEditingController(text: widget.initial?.notes ?? '');
    _eventDate = widget.initial?.eventDate ?? _eventDate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _holderController.dispose();
    _venueController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _eventDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date == null) return;
    if (!mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_eventDate),
    );
    if (time == null) return;
    if (!mounted) return;
    setState(() {
      _eventDate = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final ticket = Ticket(
      id: widget.initial?.id,
      title: _titleController.text.trim(),
      holderName: _holderController.text.trim(),
      eventDate: _eventDate,
      venue: _venueController.text.trim(),
      notes: _notesController.text.trim(),
    );
    Navigator.pop(context, ticket);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.initial == null ? 'New Ticket' : 'Edit Ticket')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              TextFormField(
                controller: _holderController,
                decoration: const InputDecoration(labelText: 'Holder Name'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              TextFormField(
                controller: _venueController,
                decoration: const InputDecoration(labelText: 'Venue'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(labelText: 'Notes (optional)'),
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text('Event: ${DateFormat.yMMMd().add_jm().format(_eventDate)}'),
                  ),
                  TextButton.icon(
                    onPressed: _pickDateTime,
                    icon: const Icon(Icons.calendar_today),
                    label: const Text('Pick'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _save,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

