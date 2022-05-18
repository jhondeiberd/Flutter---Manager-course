import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../scoped_models/main-model.dart';
import '../../widget/header.dart';
import '../../widget/teacher.dart';

class TeacherPage extends StatelessWidget{
  _addTeacher(BuildContext context) {
    Navigator.pushNamed(context, "/teacher/add");
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(builder: (BuildContext context, Widget? child, MainModel model) {
      return Scaffold(
        appBar:Header(),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _addTeacher(context),
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(Icons.add),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 25, top: 15),
              child:  Text(
                AppLocalizations.of(context).teachers,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
                ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TeacherWidget(model),
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      );
    });

  }

}