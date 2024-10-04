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
    final Map<String, dynamic> data = {
      'eventId': eventId,
      'eventDate': eventDate,
      'content': content,
    };

    if (files != null && files!.isNotEmpty) {
      data['files'] = files;
    }

    return data;
  }
}
