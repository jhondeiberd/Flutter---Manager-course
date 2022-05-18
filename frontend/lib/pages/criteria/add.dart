
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../scoped_models/main-model.dart';
import '../../widget/footer.dart';
import '../../widget/header.dart';

class AddCriteriaPage extends StatefulWidget{
  final int courseId;
  AddCriteriaPage(this.courseId);

  @override
  State createState() => _AddCriteriaState();
}
class _AddCriteriaState extends State<AddCriteriaPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    'question': null,
  };
  Widget _buildQuestionTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        hintText: 'question', border: OutlineInputBorder(),filled: true, fillColor: Colors.white,),
      keyboardType: TextInputType.text,
      validator: (String? value) {
        if(value == null)
          return null;
        if (value.isEmpty) {
          return AppLocalizations.of(context).enterTitle;
        }
      },
      onSaved: (String? value) {
        _formData['question'] = value;
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
        model.addCriteria(_formData['question'], widget.courseId).then((value) =>
        {
          if(value){
            Navigator.pop(context, true)
          }else{
            // show snackbar
            ScaffoldMessenger.of(context)
                .showSnackBar(
                SnackBar(
                  content:Text(AppLocalizations.of(context).criteriaCouldNotBeAdded),
                  duration: Duration(seconds: 5),
                  action: SnackBarAction(
                    label: AppLocalizations.of(context).okay,
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
        bottomNavigationBar: Footer(),
        body: Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildQuestionTextField(),
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