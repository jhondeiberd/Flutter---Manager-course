import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../scoped_models/main-model.dart';
import '../../widget/header.dart';

class AddTeacher extends StatefulWidget {
  const AddTeacher({Key? key}) : super(key: key);

  @override
  State createState() => _AddTeacherState();
}

class _AddTeacherState extends State<AddTeacher> {
  final _formKey = GlobalKey<FormState>();

  String? name;
  String? email;
  String? password;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(builder: (BuildContext context, Widget? child, MainModel model){
      return Scaffold(
        appBar: Header(),
        body: Form(
          key: _formKey,
          child: Scrollbar(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextFormField(
                      autofocus: true,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if(value!= null){
                          if (value.isEmpty) {
                            return AppLocalizations.of(context).enterName;
                          }
                        }
                      },
                      decoration: InputDecoration(
                        filled: true,
                        border: OutlineInputBorder(),
                        labelText: AppLocalizations.of(context).name,
                        hintText: AppLocalizations.of(context).enterName,
                      ),
                      onSaved: (value) {
                        name = value;
                      },
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    TextFormField(
                      autofocus: true,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty ||
                            !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                .hasMatch(value)) {
                          return AppLocalizations.of(context).enterValidEmail;
                        }
                      },
                      decoration: InputDecoration(
                        filled: true,
                        border: OutlineInputBorder(),
                        hintText: AppLocalizations.of(context).enterValidEmail,
                        labelText: AppLocalizations.of(context).email,
                      ),
                      onSaved: (value) {
                        email = value;
                      },
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    TextFormField(
                      autofocus: true,
                      textInputAction: TextInputAction.next,
                      obscureText: true,
                      validator: (value) {
                        if(value == null || value.length == 0){
                          return AppLocalizations.of(context).passwordCantBeLeftEmpty;
                        }
                        if (value.length < 6) {
                          return AppLocalizations.of(context).passwordShouldBelong;
                        }
                      },
                      decoration: InputDecoration(
                        filled: true,
                        border: OutlineInputBorder(),
                        hintText: AppLocalizations.of(context).enterPassword,
                        labelText: AppLocalizations.of(context).password,

                      ),
                      onSaved: (value) {
                        password = value;
                      },
                    ),
                    const SizedBox(
                      height: 24,
                    ),

                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Theme.of(context).primaryColor,
                                    padding: EdgeInsets.all(20)
                                ),
                                child: Text(AppLocalizations.of(context).okay),
                                onPressed: () {
                                  FormState? currentState = _formKey.currentState;
                                  if(currentState!= null){
                                    if (! currentState.validate()) {
                                      return;
                                    }
                                    currentState.save();
                                    model.addTeacher(name as String, email  as String, password  as String).then((value) =>
                                    {
                                      if(value){
                                          showDialog<void>(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text(AppLocalizations.of(context).newTeacher),
                                            //content: Text('The teacher: $name with email: $email was added'),
                                            content: Text(AppLocalizations.of(context).teacherAddedSuccessfully),
                                            actions: [
                                              TextButton (
                                                child: Text(AppLocalizations.of(context).done),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          ),
                                        )

                                      }else{
                                        showDialog<void>(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text(AppLocalizations.of(context).newTeacher),
                                            content: Text(AppLocalizations.of(context).somethingWentWrong),
                                            actions: [
                                              TextButton (
                                                child: Text(AppLocalizations.of(context).done),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          ),
                                        )

                                      }
                                    });

                                  }

                                }
                            ),
                          ),
                        ]
                    )
                  ],
                ),
              )
          ),
        ),
      );
    });
  }
}
