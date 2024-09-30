class Posting {
  final int eventId;
  final String eventDate;
  final String content;
  final List<String>? files;

  Posting({
    required this.eventId,
    required this.eventDate,
    required this.content,
    this.files,
  });

  Map<String, dynamic> toJson() {
    return {
      'eventId': eventId,
      'eventDate': eventDate,
      'content': content,
      'files': files,
    };
  }
}
