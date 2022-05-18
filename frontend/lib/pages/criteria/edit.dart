import 'package:flutter/material.dart';
import '../../models/criteria.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/course.dart';
import '../../scoped_models/main-model.dart';
import '../../widget/footer.dart';
import '../../widget/header.dart';

class EditCriteriaPage extends StatefulWidget{
  final int criteriaId;
  final MainModel model;
  EditCriteriaPage(this.criteriaId, this.model);
  @override
  State createState() => _EditCriteriaState();
}
class _EditCriteriaState extends State<EditCriteriaPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    'question': null,
  };
  late Criteria _criteria;
  @override
  void initState() {
    _criteria = widget.model.criteria.firstWhere((element) => element.id == widget.criteriaId);
    _formData['question'] = _criteria.question;
  }

  Widget _buildTitleTextField() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'question', border: OutlineInputBorder(),filled: true, fillColor: Colors.white,),
      keyboardType: TextInputType.emailAddress,
      validator: (String? value) {
        if(value == null)
          return null;
        if (value.isEmpty) {
          return AppLocalizations.of(context).pleaseEnterQuestion;
        }
      },
      initialValue: _formData['question'],
      onSaved: (String? value) {
        _formData['question'] = value;
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
            model.updateCriteria(widget.criteriaId,_formData['question'],).then((value) =>
            {
              if(value){
                Navigator.pop(context, true)
              }else{
                ScaffoldMessenger.of(context)
                    .showSnackBar(
                    SnackBar(
                      content:Text(AppLocalizations.of(context).criteriaCouldNotBeUpdated),
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