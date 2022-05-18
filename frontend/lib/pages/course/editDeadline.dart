import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../models/course.dart';
import '../../scoped_models/main-model.dart';
import '../../widget/footer.dart';
import '../../widget/header.dart';

class EditDeadlinePage extends StatefulWidget{
  final int courseId;
  final MainModel model;
  EditDeadlinePage(this.courseId, this.model);
  @override
  State createState() => _EditDeadlineState();
}

class _EditDeadlineState extends State<EditDeadlinePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime deadline = DateTime.now();
  TimeOfDay deadlineTime = TimeOfDay.now();
  // final DateFormat dateFormat = DateFormat('yyyy-mm-dd HH:mm');
  final Map<String, dynamic> _formData = {
    'title': null,
  };
  late Course _course;
  @override
  void initState() {
    _course = widget.model.courses.firstWhere((element) => element.id == widget.courseId);
    _formData['title'] = _course.title;
    _formData['deadlineTime'] = TimeOfDay.now();
    _formData['deadline'] = DateTime.now();
  }

  Widget _buildTitleTextField() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'Title', border: OutlineInputBorder(), filled: true, fillColor: Colors.white, labelText: 'Course name',
      ),
      keyboardType: TextInputType.emailAddress,
      initialValue: _formData['title'],
      readOnly: true,
      onSaved: (String? value) {
        _formData['title'] = value;
      },
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _formData['deadline'], // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked.isAfter(DateTime.now())) {
      final time = await showTimePicker(
        context: context,
        initialTime: _formData['deadlineTime'],
      );
      if (time != null) {
        setState(() {
          deadlineTime = time;
        });
      }
      setState(() {
        deadline = DateTime(
          picked.year,
          picked.month,
          picked.day,
          deadlineTime.hour,
          deadlineTime.minute,
        );
        onSaved: (String? value) {
          _formData['deadline'] = deadline;
        };
      });
      print('DeadLine: {$deadline}');
      print('_formData: {$_formData[deadline]}');
    } else {
      ScaffoldMessenger.of(context)
        .showSnackBar(
        SnackBar(
          content:Text("The date must be greater than the current date"),
          duration: Duration(seconds: 5),
          action: SnackBarAction(
            label: "OK",
            onPressed: (){},
          ),
        ));
    };
  }

  Widget _buildDeadlineDateTimeField() {
    return Row(
      children: [
        Text('Deadline: '),
        SizedBox(width: 10,),
        Text('$deadline'),
        SizedBox(width: 10,),
        ElevatedButton(
            onPressed: () => _selectDate(context),
            child: Text('Select Date')
        ),
      ],
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
            model.updateDeadline(widget.courseId,_formData['title'], _formData['deadline']).then((value) =>
            {
              if(value){
                Navigator.pop(context, true)
              }else{
                ScaffoldMessenger.of(context)
                    .showSnackBar(
                    SnackBar(
                      content:Text("Deadline couldn't be updated"),
                      duration: Duration(seconds: 5),
                      action: SnackBarAction(
                        label: "OK",
                        onPressed: (){},
                      ),
                    ))
              }
            });
          }
        },
        child: Text("Update")
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
                Text('Course deadline', style: TextStyle(fontSize: 24)),
                SizedBox(height: 20),
                _buildTitleTextField(),
                SizedBox(height: 30),
                _buildDeadlineDateTimeField(),
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