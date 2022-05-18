class Students {
  final int id;
  final String email;

  Students({
    required this.id,
    required this.email,
  });

  @override
  String toString() {
    return "id= ${id} email=${email}";
  }
}
