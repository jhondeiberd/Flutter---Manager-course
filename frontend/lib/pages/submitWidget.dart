import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped_models/main-model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/studentsRating.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SubmitWidget extends StatefulWidget {
  final MainModel model;
  SubmitWidget(this.model);
  @override
  State createState() => _SubmitWidgetPageState();

}

class _SubmitWidgetPageState extends State<SubmitWidget>{

final Map<String, dynamic> _formData = {
  'questionDetails':{},
  'title': "Course Name",
  'description': null,
  'average_rating': 5,
  'tempDetails':{},
  'courseID':null,
  'studentEmail':null,
  'success':null
};

Widget TextBox(int position){
  return TextFormField(
    decoration: InputDecoration(
        hintText: AppLocalizations.of(context).comment, border: OutlineInputBorder(), filled: true, fillColor: Colors.white,
        hintMaxLines: 1
    ),
    keyboardType: TextInputType.multiline,
    minLines: 2,
    maxLines: 3,
    onChanged: (newText){
      var changeDetails=studentRating(
          question: _formData["tempDetails"][position].question,
          courseName: _formData["tempDetails"][position].courseName,
          defaultRating: _formData["tempDetails"][position].defaultRating,
          criterID: _formData['tempDetails'][position].criterID,
          answer: newText
      );

      setState(() {
        _formData["tempDetails"][position]=changeDetails;
      });
    },
  );
}

Widget _buildStaticTitles() {
  return Padding(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
    child: Row(
      children: [
        Text(
          _formData["title"],
          style: const TextStyle(
            color: Color.fromRGBO(146, 0, 11, 1),
            fontSize: 15,
            fontFamily: 'SpaceGrotesk',
          ),
        ),
        Row(
          children: [
            Text(AppLocalizations.of(context).lowestAndHighest,
                style: TextStyle(
                    color: Color.fromRGBO(146, 0, 11, 1),
                    fontSize: 15,
                    fontFamily: 'SpaceGrotesk')),
          ],
        )
      ],
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    ),
  );
}
void _updateState(MainModel model) {
  if(model.questions.length!=0){
    _formData["title"]=model.questions[0].courseName;
  }
}

Widget _Slider(MainModel model, int pos) {
  _updateState(model);
  return model.questions.length!=0? Padding(
    padding: EdgeInsets.fromLTRB(80, 10, 80, 10),
    child: Card(
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(35, 10, 35, 10),
                child: Row(
                  children: [

                    Text(_formData["tempDetails"][pos].question,style: TextStyle(
                        color: Color.fromRGBO(146, 0, 11, 1),
                        fontSize: 15,
                        fontFamily: 'SpaceGrotesk')),

                    Text(_formData["tempDetails"][pos].defaultRating.toString())
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(35, 10, 35, 10),
                child: Column(
                  children: [
                    _buildRatingSlider(pos),
                  ],
                ),
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(75, 10, 75, 10),
                  child: Column(
                    children: [
                      TextBox(pos),
                    ],
                  )
              ),

            ],
          ),

          padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
        )

    ),

  ):Text(AppLocalizations.of(context).loading);

}
Widget _buildRatingSlider(int position) {
  return Slider(
    min: 0,
    divisions: 11,
    label: AppLocalizations.of(context).averageRating,
    max: 10,
    value: _formData["tempDetails"][position].defaultRating,
    onChanged: (double value) {

      var changeDetails=studentRating(
          question: _formData["tempDetails"][position].question,
          courseName: _formData["tempDetails"][position].courseName,
          criterID: _formData['tempDetails'][position].criterID,
          answer: _formData["tempDetails"][position].answer,
          defaultRating: value.toInt()
      );

      setState(() {
        _formData["tempDetails"][position]=changeDetails;
        // _formData["questionDetails"][position].defaultRating =value.toInt();
      });
    },
  );
}

void submitData(){
  var result= (widget.model.enterDetailsForRatings(_formData['tempDetails'], _formData["courseID"],_formData["studentEmail"]));
   result.then((value) =>
   {
    if(value==true){
      ///To do
      ///Handle context trur
      print("in true"),
      Navigator.pop(context,true)
      // SystemNavigator.pop()
    }else{
      print("in false")
    }
   }
   );

   //print(_formData["courseID"]);
}

Widget _buildSubmitButton(MainModel model) {
  return Padding(
    padding: const EdgeInsets.all(0),
    child: Container(
      width: double.infinity,
      margin: EdgeInsets.only(top :0),
      child: ElevatedButton(
        onPressed: () {submitData();},
        child: Text(AppLocalizations.of(context).submit),
        style: ElevatedButton.styleFrom(
            primary: Theme.of(context).primaryColor,
            padding: EdgeInsets.all(20)
        ),
      ),
    ),
  );
}


@override
void initState() {
  widget.model.fetchCriteriaAndquestions(widget.model.courseId);
  _formData["courseID"]= widget.model.courseId;
  _formData["studentEmail"]=widget.model.studentEmail;
  // print(_formData["courseID"]);
  // _formData["courseID"]=widget.model.courseId;
  // _formData["studentEmail"]=widget.model.studentEmail;
  var statuCopy=widget.model.fetchCriteriaAndquestion(widget.model.courseId);
      statuCopy.then((value) => {
        for(var pos=0;pos<value.length;pos++){
          print(value[pos]),
          _formData["tempDetails"][pos]=value[pos],
          // print(_formData["tempDetails"]),
          _formData["questionDetails"][pos]=value[pos]
        }
      });
}



  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(builder: (BuildContext context, Widget? child, MainModel model) {
      return Scaffold(
        body:Container(
          child: ListView(
            children: [
              _buildStaticTitles(),
              for(int pos =0;pos<model.questions.length;pos++) _Slider(model,pos) ,
           _buildSubmitButton(model)
            ],
          ),
        ),
      );
    });
  }
}