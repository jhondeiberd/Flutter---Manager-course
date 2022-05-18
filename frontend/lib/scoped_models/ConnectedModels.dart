import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/subjects.dart';
import '../models/review.dart';
import '../models/students.dart';
import '../models/deadline.dart';
import 'main-model.dart';
import '../models/course.dart';
import '../models/criteria.dart';
import '../models/user.dart';
import '../models/studentsRating.dart';
import '../models/teacher.dart';

class ConnectedModels extends Model{
  List<Criteria> _criteria = [];
  List<Course> _courses = [];
  List<Deadline> _deadline = [];
 List<studentRating> _question=[];
  late Course _courseId;
  List<Teacher> _teachers = [];
  List<Students> _students = [];
  List<Review> _review = [];
  User? _authUser;
  bool isLoading = false;
  String tokenKeyHeader = "x-access-token";
}

class CoursesModel extends ConnectedModels {

  List<Course> get courses {
    return List.from(_courses);
  }

  List<studentRating> get questions{
    return List.from(_question);
  }

  Future<bool> addCourse(String title, String description, int teacherId) async {
    isLoading = true;
    notifyListeners();
    // int? userId = _authUser?.id;
    // if(userId == null)
    //   return false;
    final Map<String, dynamic> courseData = {
      "title": title,
      "description": description,
      "teacher_id": teacherId
    };

    return http.post(
        Uri.parse('${MainModel.apiEndpoint}course'),
        headers: {
          "Content-type": "application/json",
          tokenKeyHeader: _authUser?.token ?? ""
        },
        body: json.encode(courseData)
    ).then<bool>((http.Response response) {
      if (response.statusCode != 200 && response.statusCode != 201) {
        isLoading = false;
        notifyListeners();
        return false;
      }
      // print(response.body);
      final Map<String, dynamic> responseData = json.decode(response.body);
      if(responseData["status"] == "Success"){
        final Course newCourse = Course(
            id: responseData["course_id"],
            title: title,
            description: description
        );
        _courses.add(newCourse);
        isLoading = false;
        notifyListeners();
        return true;
      }else{
        isLoading = false;
        notifyListeners();
        return false;
      }


    }).catchError((error) {
      isLoading = false;
      notifyListeners();
      return false;
    });

  }

  Future<dynamic> fetchCriteriaAndquestions(int CourseID){
    bool  isLoading = true;
    notifyListeners();
    return http.get(
        Uri.parse('${MainModel.apiEndpoint}sendQuestions/${CourseID}'),
    ).then<Null>((http.Response response){
      final List<studentRating> fetchedstudentList = [];
      final List<dynamic> questionListData = json.decode(response.body)["results"];

      if (questionListData == null) {
        isLoading = false;
        notifyListeners();
        return;
      }

      questionListData.forEach((dynamic questionData) {
        final studentRating question = studentRating(
          question: questionData["question"],
          courseName: questionData["title"],
          defaultRating: 5, criterID: questionData["criId"]
        );
        fetchedstudentList.add(question);

      });

      _question=fetchedstudentList.toList();



      isLoading = false;
      notifyListeners();

    }).catchError((error) {
      isLoading = false;
      notifyListeners();
      // print("Error fetch Courses");
      // print(error);
      return;
    });
  }

  Future<List<studentRating>> fetchCriteriaAndquestion(int CourseID) async {
    final response = await http
        .get(Uri.parse('${MainModel.apiEndpoint}sendQuestions/${CourseID}'));

    final List<studentRating> fetchedstudentList = [];
    if (response.statusCode == 200) {
      final List<dynamic> questionListData = json.decode(response.body)["results"];
      if (questionListData == null) {
            isLoading = false;
            notifyListeners();
          }


        questionListData.forEach((dynamic questionData) {
          final studentRating question = studentRating(
              question: questionData["question"],
              courseName: questionData["title"],
              defaultRating: 5,
            criterID: questionData["criId"]
          );
            fetchedstudentList.add(question);
        });
      notifyListeners();

      return fetchedstudentList;

    }else{
      throw Exception('Failed to load album');
    }
  }

  Future<Null> fetchCourses(int teacherId) {
    isLoading = true;
    notifyListeners();
    return http
        .get(
      Uri.parse('${MainModel.apiEndpoint}teacher/${teacherId}/courses'),
      headers: {
        tokenKeyHeader: _authUser?.token ?? ""
      }
    )
        .then<Null>((http.Response response) {
      final List<Course> fetchedCourseList = [];
      final List<dynamic> courseListData = json.decode(response.body)["results"];
      if (courseListData == null) {
        isLoading = false;
        notifyListeners();
        return;
      }
      courseListData.forEach((dynamic courseData) {
        final Course course = Course(
          id: courseData["id"],
          title: courseData["title"],
          description: courseData["description"],
        );
        fetchedCourseList.add(course);
      });
      _courses = fetchedCourseList.toList();
      isLoading = false;
      notifyListeners();
    }).catchError((error) {
      isLoading = false;
      notifyListeners();
    
      return;
    });
  }

  Future<bool> enterDetailsForRatings(Map<dynamic, dynamic> data, int courseID, String studentEmail) async{
    final List<studentRating> ratingListFromStudent = [];
    final List<Map<dynamic, dynamic>> finalList=[];
     final List<dynamic> ratingList = [];
    data.forEach((key, value) {

      final Map<String, dynamic> authData = {
        'question': value.question,
        'courseName': value.courseName,
        'defaultRating': value.defaultRating,
        'answer': value.answer,
        'courseID': courseID,
        'studentEmail': studentEmail,
        'criterId':value.criterID
      };
      ratingList.add(authData);

    });
    var jsonList=(json.encode(ratingList));
    return http.post(
        Uri.parse('${MainModel.apiEndpoint}sendFeedBackFromStudent'),
        headers: {
          "Content-type": "application/json"
        },
        body:jsonList
    ).then<bool>((http.Response response) {
      if (response.statusCode != 200 && response.statusCode != 201) {
        isLoading = false;
        notifyListeners();
        return false;
      }
      final Map<String, dynamic> responseData = json.decode(response.body);
      if(responseData["status"] == "Success"){
        isLoading = false;
        notifyListeners();
        return true;
      }else{
        isLoading = false;
        print("in fail");
        notifyListeners();
        return false;
      }
    });
  }

  Future<bool> updateCourse(int id, String title, String description) async {
    isLoading = true;
    notifyListeners();
    final Map<String, dynamic> courseData = {
      "title": title,
      "description": description,
    };

    return http.put(
        Uri.parse('${MainModel.apiEndpoint}course/${id}'),
        headers: {
          "Content-type": "application/json",
          tokenKeyHeader: _authUser?.token ?? ""
        },
        body: json.encode(courseData)
    ).then<bool>((http.Response response) {
      if (response.statusCode != 200 && response.statusCode != 201) {
        isLoading = false;
        notifyListeners();
        return false;
      }
      // print(response.body);
      final Map<String, dynamic> responseData = json.decode(response.body);
      if(responseData["status"] == "Success"){
        final Course updatedCourse = Course(
            id: id,
            title: title,
            description: description
        );
        int index=0;
        _courses.forEach((element) {
          if(element.id == id){
            _courses[index] = updatedCourse;
          }
          index++;
        });
        isLoading = false;
        notifyListeners();
        return true;
      }else{
        isLoading = false;
        notifyListeners();
        return false;
      }


    }).catchError((error) {
      isLoading = false;
      notifyListeners();
      return false;
    });

  }

  Future<bool> deleteCourse(int id) async {
    // isLoading = true;
    notifyListeners();
    return http.delete(
      Uri.parse('${MainModel.apiEndpoint}course/${id}'),
      headers: {
        tokenKeyHeader: _authUser?.token ?? ""
      }
    ).then<bool>((http.Response response) {
      if (response.statusCode != 200 && response.statusCode != 201) {
        isLoading = false;
        notifyListeners();
        return false;
      }
      print(response.body);
      final Map<String, dynamic> responseData = json.decode(response.body);
      if(responseData["status"] == "Success"){
        _courses.remove(_courses.firstWhere((element) => element.id == id)) ;
        isLoading = false;
        notifyListeners();
        return true;
      }else{
        isLoading = false;
        notifyListeners();
        return false;
      }


    }).catchError((error) {
      isLoading = false;
      notifyListeners();
      return false;
    });

  }
  Future<bool> unDeleteCourse(int id) async {
    // isLoading = true;
    notifyListeners();
    return http.delete(
      Uri.parse('${MainModel.apiEndpoint}course/${id}/undo'),
      headers: {
        tokenKeyHeader: _authUser?.token ?? ""
      }
    ).then<bool>((http.Response response) {
      if (response.statusCode != 200 && response.statusCode != 201) {
        isLoading = false;
        notifyListeners();
        return false;
      }
      final Map<String, dynamic> responseData = json.decode(response.body);
      final dynamic courseData  = responseData['course'];
      if(responseData["status"] == "Success"){
        final Course newCourse = Course(
            id: courseData['id'],
            title: courseData['title'],
            description:  courseData['description']
        );
        _courses.add(newCourse);
        isLoading = false;
        notifyListeners();
        return true;
      }else{
        isLoading = false;
        notifyListeners();
        return false;
      }


    }).catchError((error) {
      isLoading = false;
      notifyListeners();
      return false;
    });

  }

  Future<bool> updateDeadline(int id, String title, DateTime deadline) async {
    isLoading = true;
    notifyListeners();
    final Map<String, dynamic> courseData = {
      "title": title,
      "deadline": deadline,
    };
    print('updateDeadline: {$courseData}');
    courseData["deadline"]= courseData["deadline"].toIso8601String();
    // print(courseData["deadline"]);

    return http.put(
        Uri.parse('${MainModel.apiEndpoint}updateDeadline/${id}'),
        headers: {
          "Content-type": "application/json",
          tokenKeyHeader: _authUser?.token ?? ""
        },
        body: json.encode(courseData)
    ).then<bool>((http.Response response) {
      if (response.statusCode != 200 && response.statusCode != 201) {
        isLoading = false;
        notifyListeners();
        return false;
      }

      final Map<String, dynamic> responseData = json.decode(response.body);
      if(responseData["status"] == "Success"){
        final Deadline updatedDeadline = Deadline(
            id: id,
            title: title,
            deadline: deadline,
        );
        int index=0;
        _deadline.forEach((element) {
          if(element.id == id){
            _deadline[index] = updatedDeadline;
          }
          index++;
        });
        isLoading = false;
        notifyListeners();
        return true;
      }else{
        isLoading = false;
        notifyListeners();
        return false;
      }
    }).catchError((error) {
      isLoading = false;
      notifyListeners();
      return false;
    });
  }
}

class CriteriaModel extends ConnectedModels {

  List<Criteria> get criteria {
    return List.from(_criteria);
  }

  Future<bool> addCriteria(String question, int courseId) async {
    isLoading = true;
    notifyListeners();
    final Map<String, dynamic> criteriaData = {
      "question": question,
      "course_id": courseId
    };

    return http.post(
        Uri.parse('${MainModel.apiEndpoint}criteria'),
        headers: {
          "Content-type": "application/json",
          tokenKeyHeader: _authUser?.token ?? ""
        },
        body: json.encode(criteriaData)
    ).then<bool>((http.Response response) {
      if (response.statusCode != 200 && response.statusCode != 201) {
        isLoading = false;
        notifyListeners();
        return false;
      }
   
      final Map<String, dynamic> responseData = json.decode(response.body);
      if(responseData["status"] == "Success"){
        final Criteria newCriteria = Criteria(
            id: responseData["criteria_id"],
            question: question
        );
        _criteria.add(newCriteria);
        isLoading = false;
        notifyListeners();
        return true;
      }else{
        isLoading = false;
        notifyListeners();
        return false;
      }


    }).catchError((error) {
      isLoading = false;
      notifyListeners();
      return false;
    });

  }

  Future<Null> fetchCriteria(int courseId) {
    isLoading = true;
    notifyListeners();
    return http
        .get(
      Uri.parse('${MainModel.apiEndpoint}course/${courseId}/criteria'),
      headers: {
        tokenKeyHeader: _authUser?.token ?? ""
      }
    )
        .then<Null>((http.Response response) {
      final List<Criteria> fetchedCriteriaList = [];
      final List<dynamic> courseListData = json.decode(response.body)["results"];
      if (courseListData == null) {
        isLoading = false;
        notifyListeners();
        return;
      }
      courseListData.forEach((dynamic criteriaData) {
        final Criteria criteria = Criteria(
          id: criteriaData["id"],
          question: criteriaData["question"],
        );
        fetchedCriteriaList.add(criteria);
      });
      _criteria = fetchedCriteriaList.toList();
      isLoading = false;
      notifyListeners();
    }).catchError((error) {
      isLoading = false;
      notifyListeners();
      return;
    });
  }

  Future<bool> updateCriteria(int id, String question) async {
    isLoading = true;
    notifyListeners();
    final Map<String, dynamic> criteriaData = {
      "question": question,
    };

    return http.put(
        Uri.parse('${MainModel.apiEndpoint}criteria/${id}'),
        headers: {
          "Content-type": "application/json",
          tokenKeyHeader: _authUser?.token ?? ""
        },
        body: json.encode(criteriaData)
    ).then<bool>((http.Response response) {
      if (response.statusCode != 200 && response.statusCode != 201) {
        isLoading = false;
        notifyListeners();
        return false;
      }

      final Map<String, dynamic> responseData = json.decode(response.body);
      if(responseData["status"] == "Success"){
        final Criteria updatedCriteria = Criteria(
            id: id,
            question: question,
        );
        int index=0;
        _criteria.forEach((element) {
          if(element.id == id){
            _criteria[index] = updatedCriteria;
          }
          index++;
        });
        isLoading = false;
        notifyListeners();
        return true;
      }else{
        isLoading = false;
        notifyListeners();
        return false;
      }


    }).catchError((error) {
      isLoading = false;
      notifyListeners();
      return false;
    });

  }

  Future<bool> deleteCriteria(int id) async {
 
    notifyListeners();
    return http.delete(
      Uri.parse('${MainModel.apiEndpoint}criteria/${id}'),
      headers: {
        tokenKeyHeader: _authUser?.token ?? ""
      }
    ).then<bool>((http.Response response) {
      if (response.statusCode != 200 && response.statusCode != 201) {
        isLoading = false;
        notifyListeners();
        return false;
      }
      final Map<String, dynamic> responseData = json.decode(response.body);
      if(responseData["status"] == "Success"){
        _criteria.remove(_criteria.firstWhere((element) => element.id == id)) ;
        isLoading = false;
        notifyListeners();
        return true;
      }else{
        isLoading = false;
        notifyListeners();
        return false;
      }


    }).catchError((error) {
      isLoading = false;
      notifyListeners();
      return false;
    });

  }
  Future<bool> unDeleteCriteria(int id) async {

    notifyListeners();
    return http.delete(
      Uri.parse('${MainModel.apiEndpoint}criteria/${id}/undo'),
      headers: {
        tokenKeyHeader: _authUser?.token ?? ""
      }
    ).then<bool>((http.Response response) {
      if (response.statusCode != 200 && response.statusCode != 201) {
        isLoading = false;
        notifyListeners();
        return false;
      }
      final Map<String, dynamic> responseData = json.decode(response.body);
      if(responseData["status"] == "Success"){
        final dynamic criteriaData = responseData["criteria"];
        final Criteria criteria = Criteria(
          id: criteriaData["id"],
          question: criteriaData["question"],
        );
        _criteria.add(criteria);
        print(criteria);
        isLoading = false;
        notifyListeners();
        return true;
      }else{
        isLoading = false;
        notifyListeners();
        return false;
      }


    }).catchError((error) {
      isLoading = false;
      notifyListeners();
      return false;
    });

  }

}

class UsersModel extends ConnectedModels{
  late Timer _authTimer;
  PublishSubject<bool> _userSubject = PublishSubject();

  User? get authUser {
    return _authUser;
  }
  PublishSubject<bool> get userSubject {
    return _userSubject;
  }

  Future<Map<String, dynamic>> authenticate(String email, String password) async {
    bool _isLoading = true;
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
    };
    http.Response response = await http.post(
        Uri.parse('${MainModel.apiEndpoint}login'),
        body: authData
    );
    final Map<String, dynamic> responseData = json.decode(response.body);
    bool hasError = true;
    String message = 'Something went wrong.';
    if(responseData["status"] == "Success"){
      hasError = false;
      message = 'Authentication succeeded!';
      _authUser = User(
        id: responseData["id"],
        name: responseData["name"],
        type: responseData["type"],
        email: responseData["email"],
        token: responseData["token"],
      );
      setAuthTimeout(responseData['expiresIn']);
      _userSubject.add(true);
      final DateTime now = DateTime.now();
      final DateTime expiryTime =
      now.add(Duration(seconds: responseData['expiresIn']));
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', responseData['token']);
      prefs.setInt('userId', responseData["id"]);
      prefs.setString('userName', responseData["name"]);
      prefs.setInt('userType', responseData["type"]);
      prefs.setString('userEmail', responseData["email"]);
      prefs.setString('expiryTime', expiryTime.toIso8601String());

      bool _isLoading = false;
    }else{
      bool _isLoading = false;
    }
    return {'success': !hasError, 'message': message};
  }
  void autoAuthenticate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    final String? expiryTimeString = prefs.getString('expiryTime');
    if (token != null && expiryTimeString!= null) {
      final DateTime now = DateTime.now();
      final parsedExpiryTime = DateTime.parse(expiryTimeString);
      if (parsedExpiryTime.isBefore(now)) {
        _authUser = null;
        notifyListeners();
        return;
      }
      final int userId = prefs.getInt('userId') as int;
      final String userName = prefs.getString('userName') as String;
      final String userEmail = prefs.getString('userEmail') as String;
      final int userType = prefs.getInt('userType') as int;
      final int tokenLifespan = parsedExpiryTime.difference(now).inSeconds;
      _authUser = User(
          name: userName,
          email: userEmail,
          type: userType,
          token: token,
          id: userId
      );
      _userSubject.add(true);
      setAuthTimeout(tokenLifespan);
      notifyListeners();
    }
  }

  void logout() async {
    _authUser = null;
    _authTimer.cancel();
    _userSubject.add(false);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('userId');
    prefs.remove('userName');
    prefs.remove('userEmail');
    prefs.remove('userType');
  }

  void setAuthTimeout(int time) {
    _authTimer = Timer(Duration(seconds: time), logout);
  }

}

class TeacherModel extends ConnectedModels {

  List<Teacher> get teachers {
    return List.from(_teachers);
  }

  Future<bool> addTeacher(String name, String email, String password) async {
    isLoading = true;
    notifyListeners();
    final Map<String, dynamic> teacherData = {
      "name": name,
      "email": email,
      "password": password,
    };

    return http.post(
        Uri.parse('${MainModel.apiEndpoint}teacher'),
        headers: {
          "Content-type": "application/json",
          tokenKeyHeader: _authUser?.token ?? ""
        },
        body: json.encode(teacherData)
    ).then<bool>((http.Response response) {
      if (response.statusCode != 200 && response.statusCode != 201) {
        isLoading = false;
        notifyListeners();
        return false;
      }
      // print(response.body);
      final Map<String, dynamic> responseData = json.decode(response.body);
      if(responseData["status"] == "Success"){
        final Teacher newTeacher = Teacher(
            id: responseData["teacher_id"],
            name: name,
            email: email,
        );
        _teachers.add(newTeacher);
        isLoading = false;
        notifyListeners();
        return true;
      }else{
        isLoading = false;
        notifyListeners();
        return false;
      }


    }).catchError((error) {
      isLoading = false;
      notifyListeners();
      return false;
    });

  }

  Future<Null> fetchTeacher() {
    isLoading = true;
    notifyListeners();
    return http
        .get(
      Uri.parse('${MainModel.apiEndpoint}teacher'),
      headers: {
        tokenKeyHeader: _authUser?.token ?? ""
      }
    )
        .then<Null>((http.Response response) {
      final List<Teacher> fetchedTeacherList = [];
      final List<dynamic> teacherListData = json.decode(response.body)["results"];
      if (teacherListData == null) {
        isLoading = false;
        notifyListeners();
        return;
      }
      teacherListData.forEach((dynamic teacherData) {
        final Teacher teacher = Teacher(
          id: teacherData["id"],
          name: teacherData["name"],
          email: teacherData["email"],
        );
        fetchedTeacherList.add(teacher);
      });
      _teachers = fetchedTeacherList.toList();
      isLoading = false;
      notifyListeners();
    }).catchError((error) {
      isLoading = false;
      notifyListeners();
      return;
    });
  }

  Future<bool> updateTeacher(int id, String name, String email, String password) async {
    isLoading = true;
    notifyListeners();
    final Map<String, dynamic> teacherData = {
      "name": name,
      "email": email,
      "password": password,
    };

    return http.put(
        Uri.parse('${MainModel.apiEndpoint}teacher/${id}'),
        headers: {
          "Content-type": "application/json",
          tokenKeyHeader: _authUser?.token ?? ""
        },
        body: json.encode(teacherData)
    ).then<bool>((http.Response response) {
      if (response.statusCode != 200 && response.statusCode != 201) {
        isLoading = false;
        notifyListeners();
        return false;
      }
      // print(response.body);
      final Map<String, dynamic> responseData = json.decode(response.body);
      if(responseData["status"] == "Success"){
        final Teacher updatedTeacher = Teacher(
            id: id,
            name: name,
            email: email
        );
        int index = 0;
        _teachers.forEach((element) {
          if(element.id == id){
            _teachers[index] = updatedTeacher;
          }
          index++;
        });
        isLoading = false;
        notifyListeners();
        return true;
      }else{
        isLoading = false;
        notifyListeners();
        return false;
      }


    }).catchError((error) {
      isLoading = false;
      notifyListeners();
      return false;
    });

  }

  Future<bool> deleteTeacher(int id) async {
    // isLoading = true;
    notifyListeners();
    return http.delete(
      Uri.parse('${MainModel.apiEndpoint}teacher/${id}'),
      headers: {
        tokenKeyHeader: _authUser?.token ?? ""
      }
    ).then<bool>((http.Response response) {
      if (response.statusCode != 200 && response.statusCode != 201) {
        isLoading = false;
        notifyListeners();
        return false;
      }
      // print(response.body);
      final Map<String, dynamic> responseData = json.decode(response.body);
      if(responseData["status"] == "Success"){
        _teachers.remove(_teachers.firstWhere((element) => element.id == id)) ;
        isLoading = false;
        notifyListeners();
        return true;
      }else{
        isLoading = false;
        notifyListeners();
        return false;
      }


    }).catchError((error) {
      isLoading = false;
      notifyListeners();
      return false;
    });

  }
  Future<bool> unDeleteTeacher(int id) async {
    // isLoading = true;
    notifyListeners();
    return http.delete(
      Uri.parse('${MainModel.apiEndpoint}teacher/${id}/undo'),
      headers: {
        tokenKeyHeader: _authUser?.token ?? ""
      }
    ).then<bool>((http.Response response) {
      if (response.statusCode != 200 && response.statusCode != 201) {
        isLoading = false;
        notifyListeners();
        return false;
      }
      final Map<String, dynamic> responseData = json.decode(response.body);
      final dynamic teacherData = responseData['teacher'];
      if(responseData["status"] == "Success"){
        final Teacher newTeacher = Teacher(
          id: teacherData["id"],
          name: teacherData["name"],
          email: teacherData["email"],
        );
        _teachers.add(newTeacher);
        isLoading = false;
        notifyListeners();
        return true;
      }else{
        isLoading = false;
        notifyListeners();
        return false;
      }


    }).catchError((error) {
      isLoading = false;
      notifyListeners();
      return false;
    });

  }

}

class StudentsModel extends ConnectedModels {

  List<Students> get students {
    return List.from(_students);
  }

  Future<Null> fetchStudents(int CourseID) {
    isLoading = true;
    notifyListeners();
    return http
        .get(
        Uri.parse('${MainModel.apiEndpoint}students/${CourseID}'),
        headers: {
          tokenKeyHeader: _authUser?.token ?? ""
        }
    )
        .then<Null>((http.Response response) {
      final List<Students> fetchedStudentsList = [];
      final List<dynamic> studentsListData = json.decode(response.body)["results"];
      if (studentsListData == null) {
        isLoading = false;
        notifyListeners();
        return;
      }
      studentsListData.forEach((dynamic studentsData) {
        final Students students = Students(
          id: studentsData["id"],
          email: studentsData["email"],
        );
        fetchedStudentsList.add(students);
      });
      _students = fetchedStudentsList.toList();
      isLoading = false;
      notifyListeners();
    }).catchError((error) {
      isLoading = false;
      notifyListeners();
      return;
    });
  }

}

class ReviewsModel extends ConnectedModels {

  List<Review> get review {
    return List.from(_review);
  }

  Future<Null> fetchReview(int review_id) {
    isLoading = true;
    notifyListeners();
    return http
        .get(
        Uri.parse('${MainModel.apiEndpoint}rating/${review_id}'),
        headers: {
          tokenKeyHeader: _authUser?.token ?? ""
        }
    ).then<Null>((http.Response response) {
      final List<Review> fetchedRatingsList = [];
      final List<dynamic> ratingListData = json.decode(response.body)["results"];
      if (ratingListData == null) {
        isLoading = false;
        notifyListeners();
        return;
      }
      ratingListData.forEach((dynamic ratingsData) {
        final Review ratings = Review(
            question: ratingsData["question"],
            comment:ratingsData["comment"],
            rating:ratingsData["rating"]
        );
        fetchedRatingsList.add(ratings);
      });
      _review = fetchedRatingsList.toList();
      isLoading = false;
      notifyListeners();
    }).catchError((error) {
      isLoading = false;
      notifyListeners();
      return;
    });
  }

}
