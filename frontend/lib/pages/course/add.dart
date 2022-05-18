import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../scoped_models/main-model.dart';
import '../../widget/footer.dart';
import '../../widget/header.dart';

class AddCoursePage extends StatefulWidget{
  final int teacherId;
  AddCoursePage(this.teacherId);
  @override
  State createState() => _AddCourseState();
}
class _AddCourseState extends State<AddCoursePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    'title': null,
    'description': null,
  };
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
      onSaved: (String? value) {
        _formData['description'] = value;
      },
    );
  }
  Widget _buildSubmitButton(MainModel model){
    return ElevatedButton(
        onPressed: () => _onSubmitForm(model),
        child: Text(AppLocalizations.of(context).add),
        style: ElevatedButton.styleFrom(
            primary: Theme.of(context).primaryColor,
            padding: EdgeInsets.all(20)
        )
    );
  }
  _onSubmitForm(MainModel model) {
    {
      FormState? currentState = _formKey.currentState;
      if(currentState !=  null){
        if (!currentState.validate()) {
          return;
        }
        currentState.save();
        // print(_formData);
        model.addCourse(_formData['title'], _formData['description'], widget.teacherId).then((value) =>
        {
          if(value){
            Navigator.pop(context, true)
          }else{
            // show snackbar
            ScaffoldMessenger.of(context)
                .showSnackBar(
                SnackBar(
                  content:Text(AppLocalizations.of(context).courseCouldNotBeAdded),
                  duration: Duration(seconds: 5),
                  action: SnackBarAction(
                    label: "OK",
                    onPressed: (){},
                  ),
                ))
          }
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(builder: (BuildContext context, Widget? child, MainModel model) {
      return Scaffold(
        appBar: Header(),
        bottomNavigationBar: Footer() ,
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