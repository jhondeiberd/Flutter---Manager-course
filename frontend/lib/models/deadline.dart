class Deadline {
  final int id;
  final String title;
  final DateTime deadline;

  Deadline({
    required this.id,
    required this.title,
    required this.deadline,
  });

  @override
  String toString() {
    return "id= ${id} title=${title}";
  }
}
