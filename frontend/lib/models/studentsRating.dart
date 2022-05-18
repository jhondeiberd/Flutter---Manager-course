import 'dart:convert';

class studentRating{
  final String question;
  final  String courseName;
  final  String answer;
  final int defaultRating;
  final int courseID;
  final String studentEmail;
  final int criterID;

  studentRating({
    required this.question,
    required this.courseName,
    required this.defaultRating,
    required this.criterID,
    this.answer="",
    this.courseID=0,
    this.studentEmail=""
  });




  @override
  String toString() {
    return "{ ${question} ,${courseName} ,${defaultRating} "
        ", ${answer} "
        ",${courseID} , ${studentEmail}  ,${criterID}";
  }





}