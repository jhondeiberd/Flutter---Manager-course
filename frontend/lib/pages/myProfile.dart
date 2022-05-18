import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../scoped_models/main-model.dart';
import '../widget/footer.dart';
import '../widget/header.dart';
import '../scoped_models/main-model.dart';
import 'myprofiledisplay.dart';



class MyProfile extends StatefulWidget {
  @override
  State createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfile> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
        builder: (BuildContext context, Widget? child, MainModel model) {
          return Scaffold(
            appBar: Header(),
            bottomNavigationBar: Footer(),
            body:Container(
                child:   MyprofileDisplay(model)
            ),
          );
        });
  }

}