class Review {
  final String question;
  final String comment;
  final int rating;

  Review({
    required this.question,
    required this.comment,
    required this.rating
  });

  @override
  String toString() {
    return "question= ${question} comment=${comment} rating=${rating}";
  }
}
