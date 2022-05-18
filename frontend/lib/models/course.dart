class Course {
  final int id;
  final String title;
  final String description;

  Course({
    required this.id,
    required this.title,
    required this.description,
  });

  @override
  String toString() {
    return "id= ${id} title=${title}";
  }
}
