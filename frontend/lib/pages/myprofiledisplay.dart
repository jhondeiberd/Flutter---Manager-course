import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/studentsRating.dart';
import '../scoped_models/main-model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyprofileDisplay extends StatefulWidget {
  final MainModel model;

  MyprofileDisplay(this.model);

  @override
  State createState() => _ProfileWidgetPageState();
}

class _ProfileWidgetPageState extends State<MyprofileDisplay> {
  bool _isTeacher = true;

  final Map<String, dynamic> _formData = {
    'userDetails': {}
  };

  Widget _Image() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(120, 80, 120, 20),
        child: Row(children: [
          Image.asset(
            'assets/images/place.png',
            fit: BoxFit.contain,
            height: 300,
            width: 300,
          ),
        ]));
  }

  @override
  void initState() {
    _formData["userDetails"] = widget.model.authUser;
 }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
        builder: (BuildContext context, Widget? child, MainModel model) {
      return Scaffold(
          body: Container(
              child: Column(
        children: [
          Padding(
              padding: EdgeInsets.fromLTRB(35, 10, 35, 10),
              child: Column(
                children: [
                  Text(_formData["userDetails"].name,
                      style: TextStyle(
                          color: Color.fromRGBO(146, 0, 11, 1),
                          fontSize: 25,
                          fontFamily: 'SpaceGrotesk')),
                ],
              )),
          _Image(),
          _formData["userDetails"].type==0? OutlinedButton(
              onPressed: () => Navigator.pushNamed(context,
                  '/courses'),
              child: Text(AppLocalizations.of(context).viewReview),
              style: OutlinedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                  padding: EdgeInsets.all(20))):OutlinedButton(
            // onPressed: () => Navigator.pushNamed(context, '/courses/${4}/criteria'), child: Text("View Criteria")),
              onPressed: () => Navigator.pushNamed(context,
                  '/teacher'),
              child:Text(AppLocalizations.of(context).viewTeacher),
              style: OutlinedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                  padding: EdgeInsets.all(20))),
          SizedBox(width: 10),
        ],


      )));
    });
  }
}
