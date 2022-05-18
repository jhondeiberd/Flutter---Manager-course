class Criteria {
  final int id;
  final String question;

  Criteria({
    required this.id,
    required this.question,
  });

  @override
  String toString() {
    return "id= ${id} title=${question}";
  }
}