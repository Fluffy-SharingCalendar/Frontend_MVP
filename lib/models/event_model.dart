class Event {
  final int eventId;
  final String title;
  final String color;
  final String startDate;
  final String endDate;

  Event({
    required this.eventId,
    required this.title,
    required this.color,
    required this.startDate,
    required this.endDate,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      eventId: json['eventId'],
      title: json['title'],
      color: json['color'],
      startDate: json['startDate'],
      endDate: json['endDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'eventId': eventId,
      'title': title,
      'color': color,
      'startDate': startDate,
      'endDate': endDate,
    };
  }
}
