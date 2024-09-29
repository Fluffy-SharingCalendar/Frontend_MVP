class EventDetail {
  final String title;
  final String startDate;
  final String endDate;
  final String color;
  final String randomImageUrl;

  EventDetail({
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.color,
    required this.randomImageUrl,
  });

  factory EventDetail.fromJson(Map<String, dynamic> json) {
    return EventDetail(
      title: json['title'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      color: json['color'],
      randomImageUrl: json['randomImageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'startDate': startDate,
      'endDate': endDate,
      'color': color,
      'randomImageUrl': randomImageUrl,
    };
  }
}
