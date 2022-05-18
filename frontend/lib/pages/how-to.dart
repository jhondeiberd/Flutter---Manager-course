import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped_models/main-model.dart';
import '../widget/footer.dart';
import '../widget/header.dart';

class HowToPage extends StatelessWidget {
  const HowToPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: const HowToWidget(),
    );
  }
}

Widget questionCard(String question, String answer){
  return Container(
    child: Card(
      color: const Color.fromRGBO(233, 233, 233, 1),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text(
                question,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22,
                    color: Color.fromRGBO(171, 0, 13, 1))
            ),
            subtitle: Text(
              answer,
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
          ),
        ],
      ),
    ),
  );
}

List<Widget> questionCards = [
  questionCard("How can I login as a director?", "Enter email and password in the login form and press \"Login\" button."),
  questionCard("Can directors create teachers?", "Yes, directors can create new teachers. when the director logs in, he can see the list of teachers and the same page has an option to add teacher. The director can click on \"+\" and enter the teacher's details like name, email and password."),
  questionCard("How can I log in as a teacher?", "Enter email and password in the login form and press \"Login\" button."),
  questionCard("How can teachers create courses and evaluation criteria?", "When the teacher logs in, he can see the list of their courses and the same page has an option to add new courses. To add evaluation criteria to a course, the teacher can click on a course to go to the course page, then click on \"+\" button and enter the question of the criteria."),
  questionCard("How can I log in as a student? Does it work the same on mobile and web?", "Students do not have an option to Login, instead they will be provided with a link or QR Code, to the rating page, by the teacher. For mobile, both QR Code and Link work, while for web only link takes the student to the rating page."),
  questionCard("How can a student login and rate an evaluation criteria?", "Once the student clicks on the link or scans the QR Code, he/she submits their email where they receive an OTP (One-Time Password), then the student has to verify the OTP before it expires, once the verification is complete,the student lands on the rating page where they can rate the teacher on each criterion."),
  questionCard("How can a teacher view the results?", "The teacher can view a list of all their courses, with every course there's an option to view results.")
];

class HowToWidget extends StatelessWidget {
  const HowToWidget({Key? key}) : super(key: key);

  Widget _buildMobLogo(double height,BuildContext context){
    return Container(
      height: height-20,
      padding: EdgeInsets.only(top:20),
      child: Column(
        children: [
          Expanded(
              child: Image(
                image: AssetImage('assets/images/logo.png'),
              )
          ),
          SizedBox(height: 15,),
          Text(
            "Course rating app",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 25,
            ),)
        ],
      ),
    );
  }

  @override
  Widget HowToPageWidget() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
          children: questionCards
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
          child: HowToPageWidget(),
        ),
      ),
    );
  }

  Widget _buildMobview(double targetWidth, double Hpadding,MainModel model,double deviceHeight,BuildContext context){
    return Scaffold(
      bottomNavigationBar: Footer(),
      body: Center(
        child: Container(
          width: targetWidth,
          padding: EdgeInsets.fromLTRB(Hpadding, 10, Hpadding, 10),
          child: Column(
            children: [
              _buildMobLogo(deviceHeight*0.35, context),
              SizedBox(height: deviceHeight*0.10,),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height - 20 - 60;//-20 for container padding and -60 for footer font and padding;
    double Hpadding = 80;
    if(deviceWidth<425)
      Hpadding = 20;
    final double targetWidth = deviceWidth<576?450:deviceWidth;
    return ScopedModelDescendant(builder: (BuildContext context, Widget? child, MainModel model) {
      return (deviceWidth>576?
      _buildWebview(targetWidth, Hpadding, model, deviceHeight)
          :_buildMobview(targetWidth, Hpadding, model, deviceHeight, context));
    });
  }
}
