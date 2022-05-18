import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../scoped_models/main-model.dart';
import '../widget/footer.dart';
import '../widget/header.dart';
import '../scoped_models/main-model.dart';
import '../pages/submitWidget.dart';

class SubmitRatingPage extends StatefulWidget {
  @override
  State createState() => _SubmitRatingPageState();
}

class _SubmitRatingPageState extends State<SubmitRatingPage> {


  final Map<String, dynamic> _formData = {
    'title': "Course Name",
    'description': null,
    'deadlineDate': DateTime.now(),
    'deadlineTime': TimeOfDay.now(),
    'average_rating': 5,
    'looping_length':0
  };





  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
        builder: (BuildContext context, Widget? child, MainModel model) {
          return Scaffold(
        appBar: Header(),
        bottomNavigationBar: Footer(),
        body:Container(
          child: SubmitWidget(model),
        ),
      );
    });
  }
}
