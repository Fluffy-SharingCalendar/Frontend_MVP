class Event {
  final String title;
  final DateTime startDate;
  final DateTime finishDate;

  const Event(
    this.title,
    this.startDate,
    this.finishDate,
  );

  @override
  String toString() => title;
}
