class Notice {
  String title;
  String description;
  String id;

  Notice({
    required this.title,
    required this.description,
    required this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'id': id,
    };
  }

  factory Notice.fromMap(Map<String, dynamic> map, String documentId) {
    return Notice(
      title: map['title'],
      description: map['description'],
      id: documentId,
    );
  }
}
