class Note {
  final int id;
  final String title;
  final String content;
  final DateTime date;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
  });

  // Factory to create Note from database map
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['noteId'],
      title: map['title'],
      content: map['content'],
      date: DateTime.parse(map['date']),
    );
  }

  // Convert Note to map for database operations
  Map<String, dynamic> toMap() {
    return {
      'noteId': id,
      'title': title,
      'content': content,
      'date': date.toIso8601String(),
    };
  }
}
