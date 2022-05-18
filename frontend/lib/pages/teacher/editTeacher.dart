import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/teacher.dart';
import '../../models/user.dart';
import '../../scoped_models/main-model.dart';
import '../../widget/header.dart';

class EditTeacherPage extends StatefulWidget{
  final int id;
  final MainModel model;
  EditTeacherPage(this.id, this.model);
  @override
  State createState() => _EditTeacherState();
}
class _EditTeacherState extends State<EditTeacherPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    'name': null,
    'email': null,
    'password': null,
  };
  late Teacher _teacher;
  @override
  void initState() {
    _teacher = widget.model.teachers.firstWhere((element) => element.id == widget.id);
    _formData['name'] = _teacher.name;
    _formData['email'] = _teacher.email;
  }

  Widget _buildNameTextField() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: AppLocalizations.of(context).name, border: OutlineInputBorder(),filled: true, fillColor: Colors.white,),
      keyboardType: TextInputType.emailAddress,
      validator: (String? value) {
        if(value == null)
          return null;
        if (value.isEmpty) {
          return AppLocalizations.of(context).enterName;
        }
      },
      initialValue: _formData['name'],
      onSaved: (String? value) {
        _formData['name'] = value;
      },
    );
  }

  Widget _buildEmailTextField() {
    return TextFormField(
      decoration: InputDecoration(
          hintText: AppLocalizations.of(context).email, border: OutlineInputBorder(), filled: true, fillColor: Colors.white,
      ),
      initialValue: _formData['email'],
      onSaved: (String? value) {
        _formData['email'] = value;
      },
    );
  }
  Widget _buildPasswordTextField() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: AppLocalizations.of(context).password, border: OutlineInputBorder(), filled: true, fillColor: Colors.white,
      ),
      obscureText: true,
      validator: (value) {
        if(value == null || value.length == 0){
          return AppLocalizations.of(context).passwordCantBeLeftEmpty;
        }
        if (value.length < 6) {
          return AppLocalizations.of(context).passwordShouldBelong;
        }
      },
      onSaved: (String? value) {
        _formData['password'] = value;
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
            model.updateTeacher(widget.id, _formData['name'], _formData['email'], _formData['password']).then((value) =>
            {
              if(value){
                Navigator.pop(context, true)
              }
            });
          }
        },
        child: Text(AppLocalizations.of(context).update),
        style: ElevatedButton.styleFrom(
            primary: Theme.of(context).primaryColor,
            padding: EdgeInsets.all(20)
        )

    );
  }
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(builder: (BuildContext context, Widget? child, MainModel model) {
      return Scaffold(
        appBar: Header(),
        body: Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildNameTextField(),
                SizedBox(height: 10),
                _buildEmailTextField(),
                SizedBox(height: 10),
                _buildPasswordTextField(),
                SizedBox(height: 10),
                _buildSubmitButton(model)
              ],
            ),
          ),
        ),
      );
    });
  }
}