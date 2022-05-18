import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/course.dart';
import '../../scoped_models/main-model.dart';
import '../../widget/footer.dart';
import '../../widget/header.dart';

class EditCoursePage extends StatefulWidget{
  final int courseId;
  final MainModel model;
  EditCoursePage(this.courseId, this.model);
  @override
  State createState() => _EditCourseState();
}
class _EditCourseState extends State<EditCoursePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    'title': null,
    'description': null,
  };
  late Course _course;
  @override
  void initState() {
    _course = widget.model.courses.firstWhere((element) => element.id == widget.courseId);
    _formData['title'] = _course.title;
    _formData['description'] = _course.description;
  }

  Widget _buildTitleTextField() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: AppLocalizations.of(context).title, border: OutlineInputBorder(),filled: true, fillColor: Colors.white,),
      keyboardType: TextInputType.emailAddress,
      validator: (String? value) {
        if(value == null)
          return null;
        if (value.isEmpty) {
          return AppLocalizations.of(context).enterTitle;
        }
      },
      initialValue: _formData['title'],
      onSaved: (String? value) {
        _formData['title'] = value;
      },
    );
  }
  Widget _buildDescriptionTextField() {
    return TextFormField(
      decoration: InputDecoration(
          hintText: AppLocalizations.of(context).description, border: OutlineInputBorder(), filled: true, fillColor: Colors.white,
          hintMaxLines: 1
      ),
      keyboardType: TextInputType.multiline,
      minLines: 10,
      maxLines: 15,
      initialValue: _formData['description'],
      onSaved: (String? value) {
        _formData['description'] = value;
      },
    );
  }
  Widget _buildSubmitButton(MainModel model){
    return ElevatedButton(
        onPressed: () {
          FormState? currentState = _formKey.currentState;
          if(currentState !=  null){
            if (!currentState.validate()) {
              return;
            }
            currentState.save();
            model.updateCourse(widget.courseId,_formData['title'], _formData['description']).then((value) =>
            {
              if(value){
                Navigator.pop(context, true)
              }else{
                ScaffoldMessenger.of(context)
                .showSnackBar(
                SnackBar(
                  content:Text(AppLocalizations.of(context).courseCouldNotBeUpdated),
                  duration: Duration(seconds: 5),
                  action: SnackBarAction(
                    label: AppLocalizations.of(context).okay,
                    onPressed: (){},
                  ),
                ))

          }
            });
          }
        },
        child: Text(AppLocalizations.of(context).update)
    );
  }
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(builder: (BuildContext context, Widget? child, MainModel model) {
      return Scaffold(
        appBar: Header(),
        bottomNavigationBar: Footer(),
        body: Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildTitleTextField(),
                SizedBox(height: 10),
                _buildDescriptionTextField(),
                SizedBox(height: 10,),
                _buildSubmitButton(model)
              ],
            ),
          ),
        ),
      );
    });
  }
}