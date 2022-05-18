import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../scoped_models/main-model.dart';
import '../../widget/courses.dart';
import '../../widget/footer.dart';
import '../../widget/header.dart';

class CoursesPage extends StatelessWidget{
  final int? teacherId;
  CoursesPage(this.teacherId);

  _onAdd(BuildContext context) async {
    dynamic isAdded = await Navigator.pushNamed(context, "/teachers/${teacherId}/courses/add");
    if(isAdded!= null && isAdded){
      ScaffoldMessenger.of(context)
          .showSnackBar(
          SnackBar(
            content:Text(AppLocalizations.of(context).courseAddedSuccessfully),
            duration: Duration(seconds: 5),
            action: SnackBarAction(
              label: AppLocalizations.of(context).okay,
              onPressed: (){},
            ),
          ));

    }
  }
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(builder: (BuildContext context, Widget? child, MainModel model) {
      return Scaffold(
          appBar: Header(),
          bottomNavigationBar: Footer(),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _onAdd(context),
          child: Icon(Icons.add),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 25, top: 15),
              child:  Text(
                AppLocalizations.of(context).courses,
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

          child: CoursesWidget(model,this.teacherId),
        ),],
          crossAxisAlignment: CrossAxisAlignment.start,
      ));
    });

  }

}