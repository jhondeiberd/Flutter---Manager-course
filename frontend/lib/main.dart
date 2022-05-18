import 'package:course_rating/pages/review/view.dart';
import 'package:course_rating/pages/course/editDeadline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:scoped_model/scoped_model.dart';
import 'package:url_strategy/url_strategy.dart';

import 'helpers/custom-route.dart';

import 'pages/course/view.dart';
import 'pages/course/add.dart';
import 'pages/course/edit.dart';

import 'pages/criteria/view.dart';
import 'pages/how-to.dart';

import './pages/course/view.dart';
import './pages/criteria/view.dart';
import './pages/teacher/viewTeacher.dart';
import 'models/teacher.dart';
import './pages/teacher/addTeacher.dart';
import 'pages/students/view.dart';
import 'pages/teacher/editTeacher.dart';
import 'pages/login.dart';
import 'pages/student/verify-otp.dart';
import 'pages/student/student-email.dart';
import 'scoped_models/main-model.dart';
import 'pages/SubmitRating.dart';
import 'pages/myProfile.dart';

void main() {
  setPathUrlStrategy();
  runApp(MyApp());
}
class MyApp extends StatefulWidget {

  @override
  State createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
  final MainModel _model = MainModel();
  bool _isAuthenticated = false;
  bool
  _isTeacher = true;
  @override
  void initState() {
    _model.autoAuthenticate();
    _model.userSubject.listen((bool isAuthenticated) {
      setState(() {
        _isAuthenticated = isAuthenticated;
        int? userType = _model.authUser?.type;
        if(userType==1)
          _isTeacher = false;
        else
          _isTeacher = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
        model: _model,
        child: MaterialApp(
          title: 'Course Rating App',
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            Locale('en', ''), // English, no country code
            Locale('fr', ''), // French, no country code
          ],
          theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: Colors.blue,
            primaryColor: Color.fromRGBO(171, 0, 13, 1)
          ),
          // home: const MyHomePage(title: 'Flutter Demo Home Page'),
          routes: {
            '/': (BuildContext context) =>
            !_isAuthenticated? LoginPage() :(_isTeacher?CoursesPage(null):TeacherPage()),
            '/student': (BuildContext context) => StudentLoginPage(),
            '/student/verify-otp': (BuildContext context) => OtpVerificationPage(),
            '/submit':(BuildContext context)=>SubmitRatingPage(),
            '/teacher': (BuildContext context) => TeacherPage(),
            '/teacher/add': (BuildContext context) => AddTeacher(),
            "/profile":(BuildContext context) => MyProfile(),
            '/how-to': (BuildContext context) => HowToPage(),
          },
          onGenerateRoute: (RouteSettings routeSettings) {
            String? routeName = routeSettings.name;
            if(routeName != null) {
              final List<String> pathElements = routeName.split('/');
              if (pathElements[0] != '') {
                return null;
              }

              if (pathElements[1] == 'teachers') {
                final String teacherId = pathElements[2];
                if (pathElements[3] == 'courses') {
                  if (pathElements.length==5 && pathElements[4] == 'add') {
                    return CustomRoute<bool>(
                      builder: (BuildContext context) =>
                          AddCoursePage(int.parse(teacherId)),
                    );
                  }
                  return CustomRoute<bool>(
                    builder: (BuildContext context) =>
                        CoursesPage(int.parse(teacherId)),
                  );

                }
                return null;
              }

              if (pathElements[1] == 'students') {
                  final String courseId = pathElements[2];
                  print(courseId);
                  return CustomRoute<bool>(
                    builder: (BuildContext context) =>
                        StudentsPage(int.parse(courseId)),
                  );
              }

              if (pathElements[1] == 'review') {
                final String reviewId = pathElements[2];
                print(reviewId);
                return CustomRoute<bool>(
                  builder: (BuildContext context) =>
                      ReviewsPage(int.parse(reviewId)),
                );
              }

              if (pathElements[1] == 'courses') {
                final String courseId = pathElements[2];
                // final List<Course> courses = _model.courses;
                // final Course course =
                // courses.firstWhere((Course course) {
                //   return course.id.toString() == courseId;
                // });
                if (pathElements[3] == 'criteria') {
                  final String courseId = pathElements[2];
                  // final List<Course> courses = _model.courses;
                  // final Course course =
                  // courses.firstWhere((Course course) {
                  //   return course.id.toString() == courseId;
                  // });
                  return CustomRoute<bool>(
                    builder: (BuildContext context) =>
                        CritriaPage(int.parse(courseId),_model),
                  );
                }
                if (pathElements[3] == 'deadline') {
                  final String courseId = pathElements[2];
                  return CustomRoute<bool>(
                    builder: (BuildContext context) =>
                        EditDeadlinePage(int.parse(courseId),_model),
                  );
                }
                return CustomRoute<bool>(
                  builder: (BuildContext context) =>
                      EditCoursePage(int.parse(courseId),_model),
                );
              }
              else if (pathElements[1] == 'teacher') {
                final String id = pathElements[2];
                final List<Teacher> teachers = _model.teachers;
                final Teacher teacher =
                teachers.firstWhere((Teacher teacher) {
                  return teacher.id.toString() == id;
                });
                return CustomRoute<bool>(
                  builder: (BuildContext context) =>
                      EditTeacherPage(int.parse(id),_model),
                );
              }
              return null;

            }
          },



        ));
  }
}

