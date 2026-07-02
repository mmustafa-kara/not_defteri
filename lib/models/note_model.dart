class Note {
  final int? id;
  final String title;
  final String content;
  final String categoryName;
  final String priority; // 'Acil', 'Önemli', 'Normal', 'Az Önemli'
  final DateTime createdAt;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.categoryName,
    required this.priority,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'categoryName': categoryName,
      'priority': priority,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      categoryName: map['categoryName'],
      priority: map['priority'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
