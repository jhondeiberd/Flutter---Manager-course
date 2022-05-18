class Teacher {
  final int id;
  final String name;
  final String email;
  final String profilePicture;
  final String password;

  Teacher({
    required this.id,
    required this.name,
    required this.email,
    this.profilePicture = '',
    this.password = '',
  });

}
