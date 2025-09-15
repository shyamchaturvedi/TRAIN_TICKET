class Ticket {
  final int? id;
  final String title;
  final String holderName;
  final DateTime eventDate;
  final String venue;
  final String notes;

  const Ticket({
    this.id,
    required this.title,
    required this.holderName,
    required this.eventDate,
    required this.venue,
    this.notes = '',
  });

  Ticket copyWith({
    int? id,
    String? title,
    String? holderName,
    DateTime? eventDate,
    String? venue,
    String? notes,
  }) {
    return Ticket(
      id: id ?? this.id,
      title: title ?? this.title,
      holderName: holderName ?? this.holderName,
      eventDate: eventDate ?? this.eventDate,
      venue: venue ?? this.venue,
      notes: notes ?? this.notes,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'holder_name': holderName,
      'event_date': eventDate.toIso8601String(),
      'venue': venue,
      'notes': notes,
    };
  }

  factory Ticket.fromMap(Map<String, Object?> map) {
    return Ticket(
      id: map['id'] as int?,
      title: map['title'] as String? ?? '',
      holderName: map['holder_name'] as String? ?? '',
      eventDate: DateTime.parse(map['event_date'] as String? ?? DateTime.now().toIso8601String()),
      venue: map['venue'] as String? ?? '',
      notes: map['notes'] as String? ?? '',
    );
  }
}

