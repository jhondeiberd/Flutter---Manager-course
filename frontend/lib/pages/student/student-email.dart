import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../scoped_models/main-model.dart';
import '../../../widget/footer.dart';
import '../../../widget/header.dart';

class StudentLoginPage extends StatefulWidget{
  @override
  State createState() => _StudentLoginPageState();
}
class _StudentLoginPageState extends State<StudentLoginPage> {
  final Map<String, dynamic> _formData = {
    'email': null,
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildMobLogo(double height){
    return Container(
      height: height-20,
      padding: EdgeInsets.only(top:20),
      child: Column(
        children: [
          Expanded(
              child: Image(
                image: AssetImage('images/logo.png'),
              )
          ),
          SizedBox(height: 15,),
          Text(
            AppLocalizations.of(context).courseRatingApp,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 25,
            ),)
        ],

      ),
    );
  }

  Widget _buildEmailTextFieldWidget(){
    return Column(
      children: [
        Text(
          AppLocalizations.of(context).enterValidEmail,
          style: TextStyle(
              color: Theme.of(context).primaryColor),
        ),
        SizedBox(height: 10,),
        TextFormField(
          decoration: InputDecoration(border: OutlineInputBorder(), filled: true, fillColor: Colors.white),
          keyboardType: TextInputType.emailAddress,
          validator: (String? value) {
          if(value == null) {
          return null;
          }
          if (value.isEmpty ||
          !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
              .hasMatch(value)) {
          return AppLocalizations.of(context).enterValidEmail;
          }
          },
          onSaved: (String? value) {
          _formData['email'] = value;
          },
        ),
      ],
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }

  Widget _buildSubmitButton(MainModel model) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top : 10.0),
      child: ElevatedButton(
        onPressed: () {_submitForm(model);},
        child: Text(AppLocalizations.of(context).submit),
        style: ElevatedButton.styleFrom(
            primary: Theme.of(context).primaryColor,
            padding: EdgeInsets.all(20)
        ),
      ),
    );
  }
  Widget _buildForm(MainModel model, double height){
    return Container(
      height: height,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildEmailTextFieldWidget(),
            SizedBox(height: 10,),
            _buildSubmitButton(model)
          ],
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
        ),
      ),
    );
  }
  Widget _buildWebview(double targetWidth, double Hpadding,MainModel model,double deviceHeight){
    return Scaffold(
      appBar: Header(),
      bottomNavigationBar: Footer(),
      body: Center(
        child: Container(
          width: targetWidth,
          padding: EdgeInsets.fromLTRB(Hpadding, 10, Hpadding, 10),
          child: Column(
            children: [
              // SizedBox(height: deviceHeight*0.10,),
              _buildForm(model, deviceHeight*0.55),
            ],
          ),

        ),
      ),
    );
  }
  Widget _buildMobview(double targetWidth, double Hpadding,MainModel model,double deviceHeight){
    return Scaffold(
      bottomNavigationBar: Footer(),
      body: Center(
        child: Container(
          width: targetWidth,
          padding: EdgeInsets.fromLTRB(Hpadding, 10, Hpadding, 10),
          child: Column(
            children: [
              _buildMobLogo(deviceHeight*0.35),
              SizedBox(height: deviceHeight*0.10,),
              _buildForm(model, deviceHeight*0.55),
            ],
          ),

        ),
      ),
    );
  }

  _submitForm(MainModel model) {
    FormState? currentState = _formKey.currentState;

    if(currentState !=  null){
      if (!currentState.validate()) {
        return;
      }
      currentState.save();
      model.sendOtp(_formData['email']).then((value) =>
      {
        if(value){
          Navigator.pushReplacementNamed(context, "/student/verify-otp")   // todo change the route for
        }else{
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(AppLocalizations.of(context).error),
                content: Text(AppLocalizations.of(context).somethingWentWrong),
                actions: <Widget>[
                  TextButton(
                    child: Text(AppLocalizations.of(context).okay),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            },
          )
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height - 20 - 60;//-20 for container padding and -60 for footer font and padding;
    double Hpadding = 80;
    if(deviceWidth<425)
      Hpadding = 20;
    final double targetWidth = deviceWidth>576?450:deviceWidth;
    return ScopedModelDescendant(builder: (BuildContext context, Widget? child, MainModel model) {
      return (deviceWidth>576?
      _buildWebview(targetWidth, Hpadding, model, deviceHeight)
          :_buildMobview(targetWidth, Hpadding, model, deviceHeight));
    });
  }
}